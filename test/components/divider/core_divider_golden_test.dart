import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 720x134 @ 2.0 => 360x67 logical: three 1px rules, two space6 gaps, and
    // space2 vertical padding, with no dead space below the last rule.
    tester.view.physicalSize = const Size(720, 134);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: CoreSpacing.space2),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CoreDivider(),
                const SizedBox(height: CoreSpacing.space6),
                const CoreDivider(
                  indent: CoreSpacing.space4,
                  endIndent: CoreSpacing.space4,
                ),
                const SizedBox(height: CoreSpacing.space6),
                CoreDivider(color: colors.lineMid),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreDivider Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariants(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_divider_light.png'),
    );
  });

  testWidgets('CoreDivider Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_divider_dark.png'),
    );
  });
}
