import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  Future<void> pumpButton(WidgetTester tester, ThemeData theme) async {
    // 240x120 @ 2.0 => the button beside a field's placeholder.
    tester.view.physicalSize = const Size(480, 240);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: Center(
            child: CoreOutlinedIconButton(
              icon: CoreIcons.search,
              onTap: () {},
              semanticLabel: 'Look up a rate',
            ),
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreOutlinedIconButton Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpButton(tester, CoreTheme.light());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_outlined_icon_button_light.png'),
    );
  });

  testWidgets('CoreOutlinedIconButton Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpButton(tester, CoreTheme.dark());

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_outlined_icon_button_dark.png'),
    );
  });
}
