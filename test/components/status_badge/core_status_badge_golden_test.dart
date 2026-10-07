import 'package:flutter/material.dart';
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

  Widget captioned(String title, TextStyle style, Widget badge) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 120, child: Text(title, style: style)),
        badge,
      ],
    );
  }

  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;
    final caption =
        theme.coreTypography.bodySmallRegular.copyWith(color: colors.textBody);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 560x200 @ 2.0 => 280x100 logical: two captioned badges with space4
    // padding and a space3 gap.
    tester.view.physicalSize = const Size(560, 200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _withRoboto(theme),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                captioned(
                  'Label only',
                  caption,
                  const CoreStatusBadge(label: 'Sample rate'),
                ),
                const SizedBox(height: CoreSpacing.space3),
                captioned(
                  'With info icon',
                  caption,
                  const CoreStatusBadge(
                    label: 'Sample rate',
                    showInfoIcon: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreStatusBadge Visual Regression - Light', (tester) async {
    await pumpVariants(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_status_badge_light.png'),
    );
  });

  testWidgets('CoreStatusBadge Visual Regression - Dark', (tester) async {
    await pumpVariants(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_status_badge_dark.png'),
    );
  });
}
