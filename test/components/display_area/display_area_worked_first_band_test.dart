import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import 'display_area_test_helpers.dart';

/// The grey band behind the part of a chain that is worked first (CA-1479,
/// UX Design Doc rule 4.6).
void main() {
  const label = 'Worked first, 2 plus 3, equals 5';
  const sideReach = CoreSpacing.space2 - CoreSpacing.space1 / 2;
  const verticalReach = CoreSpacing.space1;
  const areaKey = Key('painted_area');
  // The chips' wrap is a Wrap subclass, which byType does not match.
  final wrapFinder = find.byWidgetPredicate((widget) => widget is Wrap);

  setUpAll(() async {
    await loadFonts();
  });

  CoreWorkedFirstBand band({
    int start = 0,
    int end = 1,
    String semanticsLabel = label,
  }) =>
      CoreWorkedFirstBand(
        start: start,
        end: end,
        semanticsLabel: semanticsLabel,
      );

  List<CoreCalculatorChip> chips(List<String> values) => [
        for (var i = 0; i < values.length; i++)
          CoreCalculatorChip(
            key: Key('chip_$i'),
            value: values[i],
            type: CoreCalculatorChipType.editable,
          ),
      ];

  Future<void> pumpArea(
    WidgetTester tester, {
    required List<CoreCalculatorChip> chipsList,
    CoreWorkedFirstBand? band,
    double width = 390,
    double textScale = 1,
    String errorMessage = '',
  }) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = ui.Size(width, 844);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          body: MediaQuery.withClampedTextScaling(
            minScaleFactor: textScale,
            maxScaleFactor: textScale,
            child: RepaintBoundary(
              key: areaKey,
              child: CoreDisplayArea(
                closeSemanticLabel: testCloseSemanticLabel,
                historyPlaceholder: testHistoryPlaceholder,
                chipsList: chipsList,
                workedFirstBand: band,
                hasError: errorMessage.isNotEmpty,
                errorMessage: errorMessage,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
  }

  List<Rect> bandRects(WidgetTester tester) {
    final wrap = tester.renderObject<RenderWrap>(wrapFinder);
    return (wrap as dynamic).bandRects as List<Rect>;
  }

  Rect rectInWrap(WidgetTester tester, Finder finder) {
    final wrap = tester.renderObject<RenderWrap>(wrapFinder);
    final box = tester.renderObject<RenderBox>(finder);
    return box.localToGlobal(Offset.zero, ancestor: wrap) & box.size;
  }

  Rect chipRectInWrap(WidgetTester tester, int index) =>
      rectInWrap(tester, find.byKey(Key('chip_$index')));

  Future<int> paintedArgbAt(WidgetTester tester, Offset position) async {
    final boundary = tester.renderObject<RenderRepaintBoundary>(
      find.byKey(areaKey),
    );
    final origin = boundary.localToGlobal(Offset.zero);
    final width = boundary.size.width.round();
    final ByteData bytes = (await tester.runAsync<ByteData>(() async {
      final image = await boundary.toImage();
      final data = await image.toByteData();
      image.dispose();
      return data!;
    }))!;
    final pixel = ((position.dy - origin.dy).round() * width +
            (position.dx - origin.dx).round()) *
        4;
    return bytes.getUint8(pixel + 3) << 24 |
        bytes.getUint8(pixel) << 16 |
        bytes.getUint8(pixel + 1) << 8 |
        bytes.getUint8(pixel + 2);
  }

  group('CoreWorkedFirstBand', () {
    test('covers the chips from start to end inclusive', () {
      final span = band(start: 1, end: 2);
      expect(span.covers(0), isFalse);
      expect(span.covers(1), isTrue);
      expect(span.covers(2), isTrue);
      expect(span.covers(3), isFalse);
    });

    test('no span covers an index below 0', () {
      expect(band().covers(-1), isFalse);
    });

    test('a span that starts and ends on one chip covers that chip alone', () {
      final span = band(start: 2, end: 2);
      expect(span.covers(1), isFalse);
      expect(span.covers(2), isTrue);
      expect(span.covers(3), isFalse);
    });

    test('two bands built apart with the same span and label are equal', () {
      final first = band();
      final second = band();
      expect(identical(first, second), isFalse,
          reason: 'the two must be different objects, or equality is not '
              'what makes them equal');
      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('a different start, end or label makes a different band', () {
      expect(band(), isNot(band(start: 1)));
      expect(band(), isNot(band(end: 2)));
      expect(band(), isNot(band(semanticsLabel: 'Worked first')));
    });

    test('a debug build refuses a span that ends before it starts', () {
      expect(() => band(start: 2, end: 1), throwsAssertionError);
    });

    test('a debug build refuses a span that starts below 0', () {
      expect(() => band(start: -1, end: 0), throwsAssertionError);
    });

    test('a debug build refuses an empty label', () {
      expect(() => band(semanticsLabel: ''), throwsAssertionError);
    });
  });

  group('CoreDisplayArea worked-first band', () {
    testWidgets('with no band no box is painted', (tester) async {
      await pumpArea(tester, chipsList: chips(['2', '+3', '×4']));

      expect(bandRects(tester), isEmpty);
    });

    for (final (width, textScale) in [
      (390.0, 1.0),
      (360.0, 1.0),
      (390.0, 2.0)
    ]) {
      testWidgets(
          'at $width dp and $textScale times the text size a band over the '
          'first two of three chips paints one box that reaches 6 dp past '
          'them at the sides and 4 dp above and below, and stops short of '
          'the third', (tester) async {
        await pumpArea(
          tester,
          chipsList: chips(['2', '+3', '×4']),
          width: width,
          textScale: textScale,
        );
        final before = [for (var i = 0; i < 3; i++) chipRectInWrap(tester, i)];
        expect(before[2].top, before[0].top,
            reason: 'the three chips must share a run here, or the test '
                'proves nothing');

        await pumpArea(
          tester,
          chipsList: chips(['2', '+3', '×4']),
          band: band(),
          width: width,
          textScale: textScale,
        );

        final after = [for (var i = 0; i < 3; i++) chipRectInWrap(tester, i)];
        expect(after, before, reason: 'the band moves no chip');
        final rects = bandRects(tester);
        expect(rects, hasLength(1));
        final box = rects.single;
        expect(box.left, before[0].left - sideReach);
        expect(box.right, before[1].right + sideReach);
        expect(box.top, before[0].top - verticalReach);
        expect(box.bottom, before[1].bottom + verticalReach);
        expect(box.right, lessThan(before[2].left),
            reason: 'the box stops in the 8 dp gap before the third chip');
      });
    }

    testWidgets('a span on one chip paints one box round that chip',
        (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(start: 1, end: 1),
      );

      final chip = chipRectInWrap(tester, 1);
      final box = bandRects(tester).single;
      expect(box.left, chip.left - sideReach);
      expect(box.right, chip.right + sideReach);
      expect(box.top, chip.top - verticalReach);
      expect(box.bottom, chip.bottom + verticalReach);
    });

    testWidgets(
        'a span over three chips that each take a run of their own paints '
        'three boxes, one above each chip', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips([
          'Pitch-rise per 12in run 6in/12in',
          '+ Pitch-rise per 12in run 6in/12in',
          '× Pitch-rise per 12in run 6in/12in',
        ]),
        band: band(end: 2),
        width: 320,
      );

      final rows = [for (var i = 0; i < 3; i++) chipRectInWrap(tester, i)];
      expect(rows[1].top, greaterThanOrEqualTo(rows[0].bottom),
          reason: 'each chip must take a run of its own here, or the test '
              'proves nothing');
      expect(rows[2].top, greaterThanOrEqualTo(rows[1].bottom));
      final rects = bandRects(tester);
      expect(rects, hasLength(3));
      expect(
        rects.map((rect) => rect.top),
        containsAll([for (final row in rows) row.top - verticalReach]),
      );
    });

    testWidgets(
        'when the tape is cut to one chip and the span stays, one box is '
        'painted round the chip that is left', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(end: 2),
      );
      expect(bandRects(tester).single.right,
          chipRectInWrap(tester, 2).right + sideReach);

      await pumpArea(tester, chipsList: chips(['2']), band: band(end: 2));

      expect(tester.takeException(), isNull);
      final chip = chipRectInWrap(tester, 0);
      final box = bandRects(tester).single;
      expect(box.left, chip.left - sideReach);
      expect(box.right, chip.right + sideReach);
    });

    testWidgets(
        'under right-to-left text the first chip sits at the right and the '
        'band reaches past the chips at either side the same way',
        (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const ui.Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: CoreDisplayArea(
                closeSemanticLabel: testCloseSemanticLabel,
                historyPlaceholder: testHistoryPlaceholder,
                chipsList: chips(['2', '+3', '×4']),
                workedFirstBand: band(),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 200));

      final rows = [for (var i = 0; i < 3; i++) chipRectInWrap(tester, i)];
      expect(rows[0].left, greaterThan(rows[1].right),
          reason: 'the first chip must sit to the right of the second here, '
              'or the test proves nothing');
      final box = bandRects(tester).single;
      expect(box.right, rows[0].right + sideReach);
      expect(box.left, rows[1].left - sideReach);
      expect(box.left, greaterThan(rows[2].right),
          reason: 'the box stops in the gap before the third chip');
    });

    testWidgets('in the full-screen stage the band is painted on the tape too',
        (tester) async {
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      tester.view.physicalSize = const ui.Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      final stages = <DisplayAreaStage>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              chipsList: chips(['2', '+3', '×4']),
              workedFirstBand: band(),
              onStageChanged: stages.add,
              previousSessions: const [
                CoreHistorySessionData(
                  dateLabel: 'Today',
                  chipsList: [],
                  value: '5',
                ),
              ],
            ),
          ),
        ),
      );
      for (var swipe = 0; swipe < 2; swipe++) {
        await tester.fling(
          find.byType(CoreDisplayArea),
          const Offset(0, 200),
          1000,
        );
        await tester.pumpAndSettle();
      }
      expect(stages.last, DisplayAreaStage.fullScreen);

      final tapeWrap = find.ancestor(
        of: find.byKey(const Key('chip_0')),
        matching: wrapFinder,
      );
      final renderWrap = tester.renderObject<RenderWrap>(tapeWrap);
      final rects = (renderWrap as dynamic).bandRects as List<Rect>;
      Rect chipRect(int index) {
        final chip =
            tester.renderObject<RenderBox>(find.byKey(Key('chip_$index')));
        return chip.localToGlobal(Offset.zero, ancestor: renderWrap) &
            chip.size;
      }

      expect(rects, hasLength(1));
      expect(rects.single.left, chipRect(0).left - sideReach);
      expect(rects.single.right, chipRect(1).right + sideReach);
    });

    testWidgets(
        'an empty tape with a band lays out with no error and shows its '
        'placeholder', (tester) async {
      await pumpArea(tester, chipsList: const [], band: band());

      expect(tester.takeException(), isNull);
      expect(find.text(testHistoryPlaceholder), findsOneWidget);
      expect(wrapFinder, findsNothing);
    });

    testWidgets(
        'in expandedCurrent, with more than five chips, the band is painted '
        'beside its first chip too', (tester) async {
      final colors = CoreTheme.light().coreColors;
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4', '+5', '×6', '+7']),
        band: band(),
      );
      await tester.fling(
        find.byType(CoreDisplayArea),
        const Offset(0, 200),
        1000,
      );
      await tester.pumpAndSettle();

      expect(bandRects(tester), hasLength(1));
      final firstChip = tester.getRect(find.byKey(const Key('chip_0')));
      expect(
        await paintedArgbAt(
          tester,
          firstChip.centerLeft - const Offset(sideReach / 2, 0),
        ),
        colors.backgroundWorkedFirstBand.toARGB32(),
      );
    });

    testWidgets(
        'the band is painted in the band fill beside its first chip, where '
        'the area shows its own colour without one', (tester) async {
      final colors = CoreTheme.light().coreColors;
      await pumpArea(tester, chipsList: chips(['2', '+3', '×4']));
      final besideTheFirstChip =
          tester.getRect(find.byKey(const Key('chip_0'))).centerLeft -
              const Offset(sideReach / 2, 0);
      expect(await paintedArgbAt(tester, besideTheFirstChip),
          colors.backgroundBlueLight.toARGB32());

      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
      );

      expect(await paintedArgbAt(tester, besideTheFirstChip),
          colors.backgroundWorkedFirstBand.toARGB32());
    });

    testWidgets('a span that wraps onto two runs paints one box per run',
        (tester) async {
      await pumpArea(
        tester,
        chipsList: chips([
          'Pitch-rise per 12in run 6in/12in',
          '+ Pitch-rise per 12in run 6in/12in',
          '×4',
        ]),
        band: band(),
        width: 320,
      );

      final first = chipRectInWrap(tester, 0);
      final second = chipRectInWrap(tester, 1);
      expect(second.top, greaterThanOrEqualTo(first.bottom),
          reason: 'the chips must wrap here, or the test proves nothing');
      final rects = bandRects(tester);
      expect(rects, hasLength(2));
      expect(rects.map((rect) => rect.top),
          containsAll([first.top - verticalReach, second.top - verticalReach]));
    });

    testWidgets(
        'on a collapsed tape of three runs, which shows the last two, the '
        'band keeps its reach at the side of each run that shows',
        (tester) async {
      final colors = CoreTheme.light().coreColors;
      await pumpArea(
        tester,
        chipsList: chips([
          'Pitch-rise per 12in run 6in/12in',
          '+ Pitch-rise per 12in run 6in/12in',
          '× Pitch-rise per 12in run 6in/12in',
        ]),
        band: band(end: 2),
        width: 320,
      );

      final tape = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('display_area_history_panel')),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      final hidden = tester.getRect(find.byKey(const Key('chip_0')));
      expect(hidden.bottom, lessThanOrEqualTo(tape.top),
          reason: 'the first run must be scrolled out of the tape here, or '
              'the test proves nothing');
      for (final shown in [1, 2]) {
        final chip = tester.getRect(find.byKey(Key('chip_$shown')));
        expect(
          await paintedArgbAt(
            tester,
            chip.centerLeft - const Offset(sideReach / 2, 0),
          ),
          colors.backgroundWorkedFirstBand.toARGB32(),
          reason: 'run of chip $shown',
        );
      }
      expect(
        await paintedArgbAt(
          tester,
          Offset(tape.left + CoreSpacing.space4, tape.top - verticalReach / 2),
        ),
        colors.backgroundBlueLight.toARGB32(),
        reason: 'the run above the tape stays hidden',
      );
    });

    testWidgets(
        'a span that runs past the chips stops at the last chip, short of '
        'the error chip', (tester) async {
      const error = 'area + length';
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3']),
        band: band(end: 5),
        errorMessage: error,
      );

      final lastChip = chipRectInWrap(tester, 1);
      final errorChip = rectInWrap(tester, find.bySemanticsLabel(error));
      expect(errorChip.left, greaterThan(lastChip.right),
          reason: 'the error chip must sit after the chips on their run, or '
              'the test proves nothing');
      final box = bandRects(tester).single;
      expect(box.right, lastChip.right + sideReach);
      expect(box.right, lessThan(errorChip.left));
    });

    testWidgets('a span that starts past the chips paints no box',
        (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3']),
        band: band(start: 2, end: 3),
        errorMessage: 'area + length',
      );

      expect(bandRects(tester), isEmpty);
    });
  });
}
