import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import 'display_area_test_helpers.dart';

/// A text scaler that doubles text up to 100 dp and leaves larger sizes as
/// they are, the way a phone's uneven font scaling treats large text.
class SmallTextOnlyScaler extends TextScaler {
  /// Creates the scaler.
  const SmallTextOnlyScaler();

  @override
  double scale(double fontSize) => fontSize <= 100 ? fontSize * 2 : fontSize;

  @override
  double get textScaleFactor => 2;
}

/// The collapsed display area at 85%, 100%, 130% and 200% text (CA-1487,
/// CA-1489, CA-1492).
void main() {
  const label = 'Pitch-rise per 12in run';
  const value = '6in/12in';
  const scales = [1.0, 1.3, 2.0, 3.0];
  const pillKey = Key('units_pill');

  setUpAll(() async {
    await loadFonts();
  });

  void setPhone(WidgetTester tester, double width) {
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });
    tester.view.physicalSize = ui.Size(width, 844);
    tester.view.devicePixelRatio = 1.0;
  }

  Future<void> pumpArea(
    WidgetTester tester, {
    required double scale,
    required Widget area,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          body: MediaQuery.withClampedTextScaling(
            minScaleFactor: scale,
            maxScaleFactor: scale,
            child: area,
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  Future<void> pumpAreaWithScaler(
    WidgetTester tester, {
    required TextScaler textScaler,
    required Widget area,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light().copyWith(
          textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
        ),
        home: Scaffold(
          body: Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaler: textScaler),
              child: area,
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));
  }

  List<CoreCalculatorChip> chips(int count) => [
        for (var i = 0; i < count; i++)
          CoreCalculatorChip(
            key: Key('chip_$i'),
            label: label,
            value: value,
            type: CoreCalculatorChipType.active,
          ),
      ];

  group('CoreDisplayArea collapsed height at a large text size', () {
    for (final scale in scales) {
      testWidgets(
          'at 390 dp and $scale times the text size the whole value shows '
          'inside the collapsed area', (WidgetTester tester) async {
        setPhone(tester, 390);
        await pumpArea(
          tester,
          scale: scale,
          area: CoreDisplayArea(
            closeSemanticLabel: testCloseSemanticLabel,
            historyPlaceholder: testHistoryPlaceholder,
            label: label,
            isTyping: true,
            value: value,
            chipsList: chips(1),
          ),
        );

        expect(tester.takeException(), isNull);
        final areaRect = tester.getRect(find.byType(CoreDisplayArea));
        final valueRect = tester.getRect(find.text(value).last);
        expect(valueRect.bottom, lessThanOrEqualTo(areaRect.bottom));
        expect(valueRect.top, greaterThanOrEqualTo(areaRect.top));
        expect(areaRect.height, greaterThanOrEqualTo(CoreSpacing.space57));
        expect(areaRect.height,
            lessThanOrEqualTo(CoreSpacing.space57 * scale + 0.01));
      });
    }

    testWidgets('at the default text size the collapsed area is still 228 dp',
        (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: 1,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          isTyping: true,
          value: value,
          chipsList: chips(1),
        ),
      );

      expect(tester.getRect(find.byType(CoreDisplayArea)).height,
          CoreSpacing.space57);
    });

    testWidgets(
        'at twice the text size the collapsed area is taller than '
        '228 dp, as the value needs', (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: 2,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          isTyping: true,
          value: value,
          chipsList: chips(1),
        ),
      );

      final areaRect = tester.getRect(find.byType(CoreDisplayArea));
      final valueRect = tester.getRect(find.text(value).last);
      expect(valueRect.bottom, greaterThan(CoreSpacing.space57),
          reason: 'the value must need more than 228 dp here, or the test '
              'proves nothing');
      expect(areaRect.height, greaterThan(CoreSpacing.space57));
    });
  });

  group('CoreDisplayArea collapsed height at a small or uneven text size', () {
    const smallScale = 0.85;

    testWidgets(
        'at 85% text the collapsed area lays out without an error and is '
        'still 228 dp', (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: smallScale,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          isTyping: true,
          value: value,
          chipsList: chips(1),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getRect(find.byType(CoreDisplayArea)).height,
          CoreSpacing.space57);
    });

    testWidgets(
        'at 80% text, where 228 dp times the scale is less than 228 dp, the '
        'collapsed area is still 228 dp and lays out without an error',
        (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: 0.8,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          isTyping: true,
          value: value,
          chipsList: chips(1),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(CoreSpacing.space57 * 0.8, lessThan(CoreSpacing.space57),
          reason: 'the scaled height must fall below the minimum here, or '
              'the test proves nothing');
      expect(tester.getRect(find.byType(CoreDisplayArea)).height,
          CoreSpacing.space57);
    });

    testWidgets(
        'at 85% text two rows of chips with a factor both show whole, as '
        'they did under the fixed 68 dp', (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: smallScale,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          value: value,
          chipsList: [
            for (var i = 0; i < 2; i++)
              CoreCalculatorChip(
                key: Key('chip_$i'),
                factor: CoreIcons.addOperator,
                label: label,
                value: value,
                type: CoreCalculatorChipType.editable,
              ),
          ],
        ),
      );

      expect(tester.takeException(), isNull);
      final tapeRect = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('display_area_history_panel')),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      final firstRect = tester.getRect(find.byKey(const Key('chip_0')));
      final secondRect = tester.getRect(find.byKey(const Key('chip_1')));
      expect(secondRect.top, greaterThanOrEqualTo(firstRect.bottom),
          reason: 'the chips must wrap here, or the test proves nothing');
      expect(firstRect.top, greaterThanOrEqualTo(tapeRect.top));
      expect(secondRect.bottom, lessThanOrEqualTo(tapeRect.bottom));
    });

    testWidgets(
        'under a text scaler that doubles text and leaves 228 as it is, the '
        'area still grows to show the value', (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpAreaWithScaler(
        tester,
        textScaler: const SmallTextOnlyScaler(),
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          isTyping: true,
          value: value,
          chipsList: chips(1),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(const SmallTextOnlyScaler().scale(CoreSpacing.space57),
          CoreSpacing.space57);
      final areaRect = tester.getRect(find.byType(CoreDisplayArea));
      final valueRect = tester.getRect(find.text(value).last);
      expect(valueRect.bottom, greaterThan(CoreSpacing.space57),
          reason: 'the value must need more than 228 dp here, or the test '
              'proves nothing');
      expect(valueRect.bottom, lessThanOrEqualTo(areaRect.bottom));
      expect(areaRect.height, lessThanOrEqualTo(CoreSpacing.space57 * 2));
    });
  });

  group('CoreDisplayArea collapsed tape and hard inputs at a large text size',
      () {
    testWidgets(
        'at twice the text size a tape of three rows shows its last two rows '
        'whole, where the fixed 68 dp showed one and a half',
        (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: 2,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          value: value,
          chipsList: chips(3),
        ),
      );

      expect(tester.takeException(), isNull);
      final tapeRect = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('display_area_history_panel')),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      final rows = [
        for (var i = 0; i < 3; i++) tester.getRect(find.byKey(Key('chip_$i'))),
      ];
      expect(rows[1].top, greaterThanOrEqualTo(rows[0].bottom),
          reason: 'each chip must take a row of its own here, or the test '
              'proves nothing');
      expect(rows[2].top, greaterThanOrEqualTo(rows[1].bottom));
      expect(rows[0].bottom, lessThanOrEqualTo(tapeRect.top),
          reason: 'the first row is the one scrolled out');
      expect(rows[1].top, greaterThanOrEqualTo(tapeRect.top));
      expect(rows[2].bottom, lessThanOrEqualTo(tapeRect.bottom));
      expect(
        tapeRect.height,
        rows[1].height +
            rows[2].height +
            CoreSpacing.space2 +
            2 * CoreSpacing.space1,
      );
    });

    testWidgets(
        'at twice the text size chips that wrap onto three rows keep the '
        'collapsed tape at two rows of chips, with the close icon centred on '
        'the first row shown', (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: 2,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          value: value,
          chipsList: chips(3),
        ),
      );

      expect(tester.takeException(), isNull);
      final tapeRect = tester.getRect(
        find.descendant(
          of: find.byKey(const Key('display_area_history_panel')),
          matching: find.byType(SingleChildScrollView),
        ),
      );
      final rows = [
        for (var i = 0; i < 3; i++) tester.getRect(find.byKey(Key('chip_$i'))),
      ];
      expect(rows[1].top, greaterThanOrEqualTo(rows[0].bottom),
          reason: 'each chip must take a row of its own here, or the test '
              'proves nothing');
      expect(rows[2].top, greaterThanOrEqualTo(rows[1].bottom));
      final oneLineChipHeight = rows[0].height;
      expect(rows[1].height, oneLineChipHeight);
      expect(rows[2].height, oneLineChipHeight);
      expect(
        tapeRect.height,
        2 * oneLineChipHeight + CoreSpacing.space2 + 2 * CoreSpacing.space1,
      );
      final iconRect = tester.getRect(find.byType(IconButton));
      expect(rows[0].bottom, lessThanOrEqualTo(tapeRect.top),
          reason: 'the first row is the one scrolled out');
      expect(iconRect.center.dy, moreOrLessEquals(rows[1].center.dy));
    });

    testWidgets(
        'at twice the text size an empty tape with no widget in its slot '
        'shows its placeholder whole', (WidgetTester tester) async {
      setPhone(tester, 320);
      await pumpArea(
        tester,
        scale: 2,
        area: const CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
        ),
      );

      expect(tester.takeException(), isNull);
      final areaRect = tester.getRect(find.byType(CoreDisplayArea));
      final textRect = tester.getRect(find.text(testHistoryPlaceholder));
      expect(textRect.bottom, lessThanOrEqualTo(areaRect.bottom));
      expect(textRect.right, lessThanOrEqualTo(areaRect.right));
    });

    testWidgets(
        'a theme whose value text has a font size of 0 keeps the area at '
        '228 dp and lays out without an error', (WidgetTester tester) async {
      setPhone(tester, 390);
      final typography = CoreTheme.light().coreTypography;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light().copyWith(
            extensions: [
              CoreTheme.light().coreColors,
              typography.copyWith(
                bodyMediumSemiBold:
                    typography.bodyMediumSemiBold.copyWith(fontSize: 0),
              ),
            ],
          ),
          home: Scaffold(
            body: MediaQuery.withClampedTextScaling(
              minScaleFactor: 2,
              maxScaleFactor: 2,
              child: CoreDisplayArea(
                closeSemanticLabel: testCloseSemanticLabel,
                historyPlaceholder: testHistoryPlaceholder,
                chipsList: chips(1),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
      expect(tester.getRect(find.byType(CoreDisplayArea)).height,
          CoreSpacing.space57);
    });
  });

  group('CoreDisplayArea close icon centred on the first chip row', () {
    for (final scale in [1.3, 2.0]) {
      testWidgets(
          'at $scale times the text size the close icon and the first chip '
          'share a centre', (WidgetTester tester) async {
        setPhone(tester, 390);
        await pumpArea(
          tester,
          scale: scale,
          area: CoreDisplayArea(
            closeSemanticLabel: testCloseSemanticLabel,
            historyPlaceholder: testHistoryPlaceholder,
            label: label,
            value: value,
            chipsList: chips(1),
          ),
        );

        expect(tester.takeException(), isNull);
        final iconRect = tester.getRect(find.byType(IconButton));
        final chipRect = tester.getRect(find.byKey(const Key('chip_0')));
        expect(iconRect.center.dy, moreOrLessEquals(chipRect.center.dy));
      });
    }

    testWidgets(
        'at the default text size the close icon is where it was, so the '
        'goldens do not change', (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: 1,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          value: value,
          chipsList: chips(1),
        ),
      );

      final areaRect = tester.getRect(find.byType(CoreDisplayArea));
      final iconRect = tester.getRect(find.byType(IconButton));
      final chipRect = tester.getRect(find.byKey(const Key('chip_0')));
      expect(iconRect.top - areaRect.top, 13.5);
      expect(iconRect.height, 40);
      expect(chipRect.top - areaRect.top, 16);
      expect(chipRect.height, 30);
    });

    testWidgets(
        'when the chips wrap onto more rows the close icon stays beside '
        'the first row', (WidgetTester tester) async {
      setPhone(tester, 390);
      await pumpArea(
        tester,
        scale: 2,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          value: value,
          chipsList: chips(2),
        ),
      );

      expect(tester.takeException(), isNull);
      final iconRect = tester.getRect(find.byType(IconButton));
      final firstRect = tester.getRect(find.byKey(const Key('chip_0')));
      final secondRect = tester.getRect(find.byKey(const Key('chip_1')));
      expect(secondRect.top, greaterThanOrEqualTo(firstRect.bottom),
          reason: 'the chips must wrap here, or the test proves nothing');
      expect(iconRect.center.dy, moreOrLessEquals(firstRect.center.dy));
      expect(iconRect.bottom, lessThanOrEqualTo(secondRect.top));
    });

    testWidgets(
        'at 320 dp and twice the text size two chips wrap, the close icon '
        'shares a centre with the first chip and the value still shows '
        'inside the area', (WidgetTester tester) async {
      setPhone(tester, 320);
      await pumpArea(
        tester,
        scale: 2,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: label,
          isTyping: true,
          value: value,
          chipsList: chips(2),
        ),
      );

      expect(tester.takeException(), isNull);
      final areaRect = tester.getRect(find.byType(CoreDisplayArea));
      final iconRect = tester.getRect(find.byType(IconButton));
      final firstRect = tester.getRect(find.byKey(const Key('chip_0')));
      final secondRect = tester.getRect(find.byKey(const Key('chip_1')));
      final valueRect = tester.getRect(find.text(value).last);
      expect(secondRect.top, greaterThanOrEqualTo(firstRect.bottom),
          reason: 'the chips must wrap here, or the test proves nothing');
      expect(iconRect.center.dy, moreOrLessEquals(firstRect.center.dy));
      expect(valueRect.bottom, lessThanOrEqualTo(areaRect.bottom));
      expect(areaRect.height, lessThanOrEqualTo(CoreSpacing.space57 * 2));
    });
  });

  group('CoreDisplayArea empty tape row at a large text size', () {
    testWidgets(
        'at 320 dp and twice the text size the whole placeholder shows above '
        'the bottom of the area, with the pill beside it',
        (WidgetTester tester) async {
      setPhone(tester, 320);
      await pumpArea(
        tester,
        scale: 2,
        area: CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          emptyTapeTrailing: CoreButton(
            key: pillKey,
            size: CoreButtonSize.small,
            variant: CoreButtonVariant.secondary,
            fullWidth: false,
            semanticsLabel: 'System of units: Imperial',
            onPressed: () {},
            child: const Text('Imperial'),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      final areaRect = tester.getRect(find.byType(CoreDisplayArea));
      final textRect = tester.getRect(find.text(testHistoryPlaceholder));
      final pillRect = tester.getRect(find.byKey(pillKey));
      expect(textRect.bottom, greaterThan(CoreSpacing.space57),
          reason: 'the placeholder must run past 228 dp here, or the test '
              'proves nothing');
      expect(textRect.bottom, lessThanOrEqualTo(areaRect.bottom));
      expect(textRect.right, pillRect.left - CoreSpacing.space2);
      expect(pillRect.bottom, lessThanOrEqualTo(areaRect.bottom));
    });
  });
}
