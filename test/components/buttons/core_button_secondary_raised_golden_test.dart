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

  Future<void> pumpRaisedSecondaryButton(
    WidgetTester tester,
    ThemeData theme,
  ) async {
    final colors = theme.coreColors;

    debugDisableShadows = false;
    addTearDown(() => debugDisableShadows = true);

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 800x176 @ 2.0 => 400x88 logical: one medium button (40) inside space6
    // padding — the recipe the display area's dependent-key pills use.
    tester.view.physicalSize = const Size(800, 176);
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
            padding: const EdgeInsets.all(CoreSpacing.space6),
            child: CoreButton(
              label: 'Rate: \$12.3/ft²',
              variant: CoreButtonVariant.secondary,
              size: CoreButtonSize.medium,
              shadows: CoreShadows.small,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();
  }

  testWidgets('CoreButton raised secondary — light theme', (tester) async {
    await pumpRaisedSecondaryButton(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_secondary_raised_light.png'),
    );
    debugDisableShadows = true;
  });

  testWidgets('CoreButton raised secondary — dark theme', (tester) async {
    await pumpRaisedSecondaryButton(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_secondary_raised_dark.png'),
    );
    debugDisableShadows = true;
  });
}
