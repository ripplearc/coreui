import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../await_images_extension.dart';
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

  Future<void> pumpSocialButton(
    WidgetTester tester,
    ThemeData theme, {
    required String label,
    required CoreIconData icon,
    bool isDisabled = false,
    double textScale = 1,
  }) async {
    final colors = theme.coreColors;

    tester.view.physicalSize = const Size(800, 300);
    tester.view.devicePixelRatio = 2.0;
    tester.platformDispatcher.textScaleFactorTestValue = textScale;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(CoreSpacing.space6),
              child: CoreButton(
                label: label,
                variant: CoreButtonVariant.social,
                size: CoreButtonSize.large,
                onPressed: () {},
                isDisabled: isDisabled,
                icon: CoreIconWidget(
                  icon: icon,
                  size: CoreSpacing.space6,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.awaitImages();
  }

  testWidgets('CoreButton social variant Google — light theme', (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.light()),
      label: 'Continue with Google',
      icon: CoreIcons.google,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_light.png'),
    );
  });

  testWidgets('CoreButton social variant Google — dark theme', (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.dark()),
      label: 'Continue with Google',
      icon: CoreIcons.google,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_dark.png'),
    );
  });

  testWidgets('CoreButton social variant Apple — light theme', (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.light()),
      label: 'Continue with Apple',
      icon: CoreIcons.apple,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_apple_light.png'),
    );
  });

  testWidgets('CoreButton social variant Apple — dark theme', (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.dark()),
      label: 'Continue with Apple',
      icon: CoreIcons.apple,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_apple_dark.png'),
    );
  });

  testWidgets('CoreButton social variant Google pressed — light theme',
      (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.light()),
      label: 'Continue with Google',
      icon: CoreIcons.google,
    );

    final gesture =
        await tester.startGesture(tester.getCenter(find.byType(CoreButton)));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_pressed_light.png'),
    );
    await gesture.up();
  });

  testWidgets('CoreButton social variant Google disabled — light theme',
      (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.light()),
      label: 'Continue with Google',
      icon: CoreIcons.google,
      isDisabled: true,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_disabled_light.png'),
    );
  });

  testWidgets('CoreButton social variant Google pressed — dark theme',
      (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.dark()),
      label: 'Continue with Google',
      icon: CoreIcons.google,
    );

    final gesture =
        await tester.startGesture(tester.getCenter(find.byType(CoreButton)));
    await tester.pump();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_pressed_dark.png'),
    );
    await gesture.up();
  });

  testWidgets('CoreButton social variant Google disabled — dark theme',
      (tester) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.dark()),
      label: 'Continue with Google',
      icon: CoreIcons.google,
      isDisabled: true,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_disabled_dark.png'),
    );
  });

  testWidgets('CoreButton social variant long label at 200% text', (
    tester,
  ) async {
    await pumpSocialButton(
      tester,
      _withRoboto(CoreTheme.light()),
      label: 'Continue with Microsoft',
      icon: CoreIcons.microsoft,
      textScale: 2,
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_large_text.png'),
    );
  });
}
