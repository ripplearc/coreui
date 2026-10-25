import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _withRoboto(ThemeData base) {
  return base.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  Future<void> pumpVariant(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 780x400 @ 2.0 => 390x200 logical, enough for both chip variants.
    tester.view.physicalSize = const Size(780, 400);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Inactive variant: no range selected.
                CoreDateFilterChip(
                  selectedDateRange: null,
                  label: 'Modified',
                  onApply: (_) {},
                  onClear: () {},
                ),
                const SizedBox(height: CoreSpacing.space4),
                // Active variant: pill with the formatted range and clear ×.
                CoreDateFilterChip(
                  selectedDateRange: DateRange(
                    start: DateTime(2026, 1, 1),
                    end: DateTime(2026, 1, 5),
                  ),
                  label: 'Modified',
                  onApply: (_) {},
                  onClear: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> pumpActivePill(WidgetTester tester, {Color? parentColor}) async {
    final theme = _withRoboto(CoreTheme.light());
    tester.view.physicalSize = const Size(780, 160);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    final chip = Center(
      child: CoreDateFilterChip(
        selectedDateRange: DateRange(
          start: DateTime(2026, 1, 1),
          end: DateTime(2026, 1, 5),
        ),
        label: 'Modified',
        onApply: (_) {},
        onClear: () {},
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: parentColor == null
              ? chip
              : ColoredBox(color: parentColor, child: chip),
        ),
      ),
    );
  }

  testWidgets('CoreDateFilterChip Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariant(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_filter_chip_light.png'),
    );
  });

  testWidgets('CoreDateFilterChip Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariant(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_filter_chip_dark.png'),
    );
  });

  testWidgets('CoreDateFilterChip Visual Regression - range focused',
      (WidgetTester tester) async {
    await pumpActivePill(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_filter_chip_range_focused.png'),
    );
  });

  testWidgets('CoreDateFilterChip Visual Regression - clear focused',
      (WidgetTester tester) async {
    await pumpActivePill(tester);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_filter_chip_clear_focused.png'),
    );
  });

  testWidgets('CoreDateFilterChip Visual Regression - pressed',
      (WidgetTester tester) async {
    await pumpActivePill(tester);
    final gesture =
        await tester.press(find.text('Jan 01, 2026 - Jan 05, 2026'));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_filter_chip_pressed.png'),
    );
    await gesture.cancel();
  });

  testWidgets('CoreDateFilterChip Visual Regression - white parent',
      (WidgetTester tester) async {
    await pumpActivePill(
      tester,
      parentColor: AppColorsExtension.create().iconWhite,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_filter_chip_white_parent.png'),
    );
  });
}
