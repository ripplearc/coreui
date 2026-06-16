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

  Future<void> pumpVariants(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;
    final typography = theme.coreTypography;

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 760x200 @ 2.0 => 380x100 logical, wide enough for all variants in one row.
    tester.view.physicalSize = const Size(760, 200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space6),
            child: Wrap(
              spacing: CoreSpacing.space6,
              runSpacing: CoreSpacing.space6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const CoreInitialAvatar(name: 'John Doe'),
                const CoreInitialAvatar(name: 'floyd miles'),
                const CoreInitialAvatar(name: 'Madonna'),
                const CoreInitialAvatar(name: ''),
                CoreInitialAvatar(
                  name: 'Esther Howard',
                  backgroundColor: colors.backgroundGreenLight,
                  textColor: colors.iconGreen,
                ),
                CoreInitialAvatar(
                  name: 'Savannah Nguyen',
                  radius: 20,
                  textStyle: typography.bodyLargeSemiBold,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('CoreInitialAvatar Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_initial_avatar_light.png'),
    );
  });

  testWidgets('CoreInitialAvatar Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_initial_avatar_dark.png'),
    );
  });
}
