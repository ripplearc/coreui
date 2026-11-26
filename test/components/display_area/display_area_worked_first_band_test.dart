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

  Widget areaApp({
    required List<CoreCalculatorChip> chipsList,
    CoreWorkedFirstBand? band,
    double textScale = 1,
    String errorMessage = '',
    List<CoreHistorySessionData> previousSessions = const [],
    ValueChanged<String>? onPreviousSessionTapped,
  }) =>
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
                previousSessions: previousSessions,
                onPreviousSessionTapped: onPreviousSessionTapped,
                restoreSemanticsLabel: onPreviousSessionTapped == null
                    ? null
                    : testRestoreSemanticsLabel,
              ),
            ),
          ),
        ),
      );

  Future<void> pumpArea(
    WidgetTester tester, {
    required List<CoreCalculatorChip> chipsList,
    CoreWorkedFirstBand? band,
    double width = 390,
    double textScale = 1,
    String errorMessage = '',
    List<CoreHistorySessionData> previousSessions = const [],
    ValueChanged<String>? onPreviousSessionTapped,
  }) async {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = ui.Size(width, 844);
    tester.view.devicePixelRatio = 1.0;
    await tester.pumpWidget(
      areaApp(
        chipsList: chipsList,
        band: band,
        textScale: textScale,
        errorMessage: errorMessage,
        previousSessions: previousSessions,
        onPreviousSessionTapped: onPreviousSessionTapped,
      ),
    );
    await tester.pump(const Duration(milliseconds: 200));
  }

  List<Rect> bandRectsOf(WidgetTester tester, Finder wrap) {
    final renderWrap = tester.renderObject<RenderWrap>(wrap);
    return (renderWrap as dynamic).bandRects as List<Rect>;
  }

  List<Rect> bandRects(WidgetTester tester) => bandRectsOf(tester, wrapFinder);

  double bandOpacity(WidgetTester tester) {
    final wrap = tester.renderObject<RenderWrap>(wrapFinder);
    final band = (wrap as dynamic).band;
    return band == null ? 0 : band.opacity as double;
  }

  final sessionWrapFinder = find.descendant(
    of: find.byKey(const Key('display_area_previous_section')),
    matching: wrapFinder,
  );

  Future<void> swipeToThePreviousSession(WidgetTester tester) async {
    await tester.fling(
      find.byType(CoreDisplayArea),
      const Offset(0, 200),
      1000,
    );
    await tester.pumpAndSettle();
  }

  Rect rectIn(WidgetTester tester, Finder wrap, Finder finder) {
    final renderWrap = tester.renderObject<RenderWrap>(wrap);
    final box = tester.renderObject<RenderBox>(finder);
    return box.localToGlobal(Offset.zero, ancestor: renderWrap) & box.size;
  }

  Rect rectInWrap(WidgetTester tester, Finder finder) =>
      rectIn(tester, wrapFinder, finder);

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
    testWidgets('the band fades in over 150 ms', (tester) async {
      await pumpArea(tester, chipsList: chips(['2', '+3', '×4']));
      await tester.pumpWidget(
        areaApp(chipsList: chips(['2', '+3', '×4']), band: band()),
      );

      expect(bandOpacity(tester), 0);
      await tester.pump(const Duration(milliseconds: 75));
      expect(bandOpacity(tester), greaterThan(0));
      expect(bandOpacity(tester), lessThan(1));
      await tester.pump(const Duration(milliseconds: 75));
      expect(bandOpacity(tester), 1);
    });

    testWidgets(
        'when the span goes and its chips stay, the band fades out over '
        '150 ms from where it was, and its label goes at once', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
      );
      final shown = bandRects(tester).single;

      await tester.pumpWidget(areaApp(chipsList: chips(['2', '+3'])));
      await tester.pump(const Duration(milliseconds: 75));

      expect(bandOpacity(tester), lessThan(1));
      expect(bandOpacity(tester), greaterThan(0));
      expect(bandRects(tester).single, shown);
      expect(find.bySemanticsLabel(label), findsNothing);

      await tester.pump(const Duration(milliseconds: 75));
      expect(bandRects(tester), isEmpty);
    });

    testWidgets(
        'when the tape is replaced as the span goes, no band is painted '
        'behind the new chips, not even for a frame', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
      );

      await tester.pumpWidget(areaApp(chipsList: chips(['10 ft', '× 12 ft'])));
      expect(bandRects(tester), isEmpty);
      await tester.pump(const Duration(milliseconds: 75));
      expect(bandRects(tester), isEmpty);
    });

    testWidgets(
        'when the tape is cut shorter than the span as the span goes, no '
        'band is painted', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
      );

      await tester.pumpWidget(areaApp(chipsList: chips(['2'])));
      await tester.pump(const Duration(milliseconds: 75));
      expect(bandRects(tester), isEmpty);
    });

    testWidgets('the band fades in, out and in again', (tester) async {
      await pumpArea(tester, chipsList: chips(['2', '+3', '×4']));
      for (var round = 0; round < 2; round++) {
        await tester.pumpWidget(
          areaApp(chipsList: chips(['2', '+3', '×4']), band: band()),
        );
        await tester.pump(const Duration(milliseconds: 200));
        expect(bandOpacity(tester), 1, reason: 'round $round, in');

        await tester.pumpWidget(areaApp(chipsList: chips(['2', '+3', '×4'])));
        await tester.pump(const Duration(milliseconds: 200));
        expect(bandRects(tester), isEmpty, reason: 'round $round, out');
      }
    });

    testWidgets(
        'a span that comes back half-way through the fade-out fades in from '
        'where it was, not from nothing', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
      );
      await tester.pumpWidget(areaApp(chipsList: chips(['2', '+3', '×4'])));
      await tester.pump(const Duration(milliseconds: 75));
      final halfWay = bandOpacity(tester);
      expect(halfWay, greaterThan(0));
      expect(halfWay, lessThan(1));

      await tester.pumpWidget(
        areaApp(chipsList: chips(['2', '+3', '×4']), band: band()),
      );
      await tester.pump(const Duration(milliseconds: 16));
      expect(bandOpacity(tester), greaterThanOrEqualTo(halfWay));
      await tester.pump(const Duration(milliseconds: 150));
      expect(bandOpacity(tester), 1);
    });

    testWidgets(
        'a span that grows while the band shows widens the box at once, with '
        'no second fade', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '×3', '+4', '×5']),
        band: band(),
      );
      final narrow = bandRects(tester).single;

      await tester.pumpWidget(
        areaApp(chipsList: chips(['2', '×3', '+4', '×5']), band: band(end: 2)),
      );

      expect(bandOpacity(tester), 1);
      expect(bandRects(tester).single.right, greaterThan(narrow.right));
    });

    testWidgets('the same span given again does not start the fade again',
        (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
      );

      await tester.pumpWidget(
        areaApp(chipsList: chips(['2', '+3', '×4']), band: band()),
      );

      expect(bandOpacity(tester), 1);
    });

    testWidgets(
        'a span replaced by another half-way through the fade-in jumps to '
        'the new chips and keeps the opacity it had reached', (tester) async {
      final fourChips = ['2', '+3', '×4', '+5'];
      await pumpArea(tester, chipsList: chips(fourChips));
      await tester
          .pumpWidget(areaApp(chipsList: chips(fourChips), band: band()));
      await tester.pump(const Duration(milliseconds: 75));
      final reached = bandOpacity(tester);
      expect(reached, greaterThan(0));
      expect(reached, lessThan(1));
      final firstBox = bandRects(tester).single;

      await tester.pumpWidget(
        areaApp(chipsList: chips(fourChips), band: band(start: 2, end: 3)),
      );

      final box = bandRects(tester).single;
      expect(box, isNot(firstBox));
      expect(box.left, chipRectInWrap(tester, 2).left - sideReach);
      expect(box.right, chipRectInWrap(tester, 3).right + sideReach);
      expect(bandOpacity(tester), greaterThanOrEqualTo(reached));
      expect(bandOpacity(tester), lessThan(1));
      await tester.pump(const Duration(milliseconds: 150));
      expect(bandOpacity(tester), 1);
    });

    testWidgets(
        'a span that goes half-way through the fade-in fades out from the '
        'opacity it had reached and ends with no box', (tester) async {
      await pumpArea(tester, chipsList: chips(['2', '+3', '×4']));
      await tester.pumpWidget(
        areaApp(chipsList: chips(['2', '+3', '×4']), band: band()),
      );
      await tester.pump(const Duration(milliseconds: 75));
      final reached = bandOpacity(tester);
      expect(reached, greaterThan(0));
      expect(reached, lessThan(1));

      await tester.pumpWidget(areaApp(chipsList: chips(['2', '+3', '×4'])));
      expect(bandOpacity(tester), moreOrLessEquals(reached));

      await tester.pump(const Duration(milliseconds: 75));
      expect(bandOpacity(tester), lessThan(reached));
      expect(bandOpacity(tester), greaterThan(0));

      await tester.pump(const Duration(milliseconds: 75));
      expect(bandRects(tester), isEmpty);
    });

    testWidgets(
        'a session card with no band draws no box and reads no label while '
        'the tape shows its band', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
        previousSessions: [
          CoreHistorySessionData(
            dateLabel: 'Today',
            chipsList: chips(['7', '+8']),
            value: '15',
          ),
        ],
      );
      await swipeToThePreviousSession(tester);

      expect(sessionWrapFinder, findsOneWidget);
      expect(bandRectsOf(tester, sessionWrapFinder), isEmpty);
      final tapeWrap = find.ancestor(
        of: find.byKey(const Key('chip_2')),
        matching: wrapFinder,
      );
      expect(bandRectsOf(tester, tapeWrap), hasLength(1));
      expect(find.bySemanticsLabel(label), findsOneWidget);
      handle.dispose();
    });

    testWidgets(
        'a screen reader hears the label once, before the chips, and each '
        'chip as its own stop', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3', '×4']),
        band: band(),
      );

      expect(find.bySemanticsLabel(label), findsOneWidget);
      final bandNode = tester.getSemantics(find.bySemanticsLabel(label));
      expect(bandNode.label, label);
      for (var index = 0; index < 3; index++) {
        final node = tester.getSemantics(find.byKey(Key('chip_$index')));
        expect(node.flagsCollection.isButton, isTrue);
        expect(node.parent, bandNode, reason: 'the chips come after the label');
      }
      handle.dispose();
    });

    testWidgets('a screen reader hears nothing for a span that covers no chip',
        (tester) async {
      final handle = tester.ensureSemantics();
      await pumpArea(
        tester,
        chipsList: chips(['2', '+3']),
        band: band(start: 5, end: 6),
      );

      expect(bandRects(tester), isEmpty);
      expect(find.bySemanticsLabel(label), findsNothing);
      handle.dispose();
    });

    testWidgets(
        'a session card draws its own band at once, behind its first two '
        'chips', (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['7']),
        previousSessions: [
          CoreHistorySessionData(
            dateLabel: 'Today',
            chipsList: chips(['2', '+3', '×4']),
            value: '20',
            workedFirstBand: band(),
          ),
        ],
      );
      await swipeToThePreviousSession(tester);

      expect(sessionWrapFinder, findsOneWidget);
      final sessionWrap = tester.renderObject<RenderWrap>(sessionWrapFinder);
      expect((sessionWrap as dynamic).band.opacity, 1);
      expect(bandRectsOf(tester, sessionWrapFinder), hasLength(1));
    });

    testWidgets(
        'a session that takes the place of a banded one draws no band, not '
        'even for a frame', (tester) async {
      CoreHistorySessionData session(CoreWorkedFirstBand? band) =>
          CoreHistorySessionData(
            dateLabel: 'Today',
            chipsList: chips(['2', '+3', '×4']),
            value: '20',
            workedFirstBand: band,
          );
      await pumpArea(
        tester,
        chipsList: chips(['7']),
        previousSessions: [session(band())],
      );
      await swipeToThePreviousSession(tester);
      expect(bandRectsOf(tester, sessionWrapFinder), hasLength(1));

      await tester.pumpWidget(
        areaApp(
          chipsList: chips(['7']),
          previousSessions: [session(band()), session(null)],
        ),
      );

      expect(bandRectsOf(tester, sessionWrapFinder), isEmpty);
    });

    testWidgets(
        'a session with a band and no chips draws no band, announces '
        'nothing and lays out with no error', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpArea(
        tester,
        chipsList: chips(['7']),
        previousSessions: [
          CoreHistorySessionData(
            dateLabel: 'Today',
            chipsList: const [],
            value: '20',
            workedFirstBand: band(),
          ),
        ],
      );
      await swipeToThePreviousSession(tester);

      expect(tester.takeException(), isNull);
      expect(bandRectsOf(tester, sessionWrapFinder), isEmpty);
      expect(find.bySemanticsLabel(label), findsNothing);
      handle.dispose();
    });

    testWidgets(
        'a session band that runs past its chips stops at the last chip',
        (tester) async {
      await pumpArea(
        tester,
        chipsList: chips(['7']),
        previousSessions: [
          CoreHistorySessionData(
            dateLabel: 'Today',
            chipsList: chips(['2', '+3']),
            value: '5',
            workedFirstBand: band(end: 9),
          ),
        ],
      );
      await swipeToThePreviousSession(tester);

      final lastChip = rectIn(
        tester,
        sessionWrapFinder,
        find.descendant(
          of: sessionWrapFinder,
          matching: find.byKey(const Key('chip_1')),
        ),
      );
      final box = bandRectsOf(tester, sessionWrapFinder).single;
      expect(box.right, lastChip.right + sideReach);
    });

    testWidgets(
        'a card that can be restored is one stop, and reads the band label '
        'once, before its chips', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpArea(
        tester,
        chipsList: chips(['7']),
        previousSessions: [
          CoreHistorySessionData(
            id: 'session-1',
            dateLabel: 'Today',
            chipsList: chips(['2', '+3', '×4']),
            value: '20',
            workedFirstBand: band(),
          ),
        ],
        onPreviousSessionTapped: (_) {},
      );
      await swipeToThePreviousSession(tester);

      final card = tester.getSemantics(
        find.byKey(const Key('display_area_previous_session_session-1')),
      );
      expect(card.mergeAllDescendantsIntoThisNode, isTrue);
      expect(card.flagsCollection.isButton, isTrue);
      final read = card.getSemanticsData().label;
      expect(label.allMatches(read), hasLength(1));
      expect(read, startsWith(testRestoreSemanticsLabel));
      expect(read.indexOf(label), lessThan(read.indexOf('+3')));
      handle.dispose();
    });
  });
}
