import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme(ThemeData theme) {
  return theme.copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  Future<void> pumpDots(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;
    final typography = theme.coreTypography;
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    await tester.binding.setSurfaceSize(const Size(800, 400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    Widget buildColumnExample(String title, Widget dots) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title, style: typography.bodyMediumRegular),
            const SizedBox(height: CoreSpacing.space4),
            dots,
          ],
        );

    final widget = MaterialApp(
      theme: _createTestTheme(theme),
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space8,
              vertical: CoreSpacing.space8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildColumnExample(
                  'Default (space3 / 12px)',
                  const CoreWritingDots(),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Medium (space5 / 20px)',
                  const CoreWritingDots(size: CoreSpacing.space5),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Large (space10 / 40px)',
                  const CoreWritingDots(size: CoreSpacing.space10),
                ),
                const SizedBox(width: CoreSpacing.space8),
                buildColumnExample(
                  'Inline with Text',
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Addition', style: typography.bodyMediumRegular),
                      const CoreWritingDots(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('CoreWritingDots Component Visual Regression Test',
      (WidgetTester tester) async {
    await pumpDots(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_writing_dots_component.png'),
    );

    debugDisableShadows = true;
  });

  testWidgets('CoreWritingDots Component Visual Regression Test - Dark',
      (WidgetTester tester) async {
    await pumpDots(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_writing_dots_component_dark.png'),
    );

    debugDisableShadows = true;
  });

  testWidgets('CoreWritingDots on the display area background - Dark',
      (WidgetTester tester) async {
    final theme = CoreTheme.dark();
    final colors = theme.coreColors;
    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);
    await tester.binding.setSurfaceSize(const Size(200, 100));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        theme: _createTestTheme(theme),
        home: Scaffold(
          backgroundColor: colors.backgroundBlueLight,
          body: const Center(child: CoreWritingDots(size: CoreSpacing.space10)),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_writing_dots_display_area_dark.png'),
    );

    debugDisableShadows = true;
  });
}
