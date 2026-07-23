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

  Future<void> pumpSocialButton(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    tester.view.physicalSize = const Size(800, 300);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

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
                label: 'Continue with Google',
                variant: CoreButtonVariant.social,
                size: CoreButtonSize.large,
                onPressed: () {},
                icon: CoreIconWidget(
                  icon: CoreIcons.google,
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

  testWidgets('CoreButton social variant — light theme', (tester) async {
    await pumpSocialButton(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_light.png'),
    );
  });

  testWidgets('CoreButton social variant — dark theme', (tester) async {
    await pumpSocialButton(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_social_dark.png'),
    );
  });
}
