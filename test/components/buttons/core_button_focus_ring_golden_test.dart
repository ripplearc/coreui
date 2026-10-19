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
    await loadFonts();
  });

  Future<void> pumpFocusedPrimary(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    tester.view.physicalSize = const Size(400, 200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: CoreButton(
              label: 'Button',
              onPressed: () {},
              fullWidth: false,
              autofocus: true,
              icon: CoreIconWidget(
                icon: CoreIcons.add,
                color: colors.textInverse,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('CoreButton primary focused — light theme', (tester) async {
    await pumpFocusedPrimary(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_focus_ring_light.png'),
    );
  });

  testWidgets('CoreButton primary focused — dark theme', (tester) async {
    await pumpFocusedPrimary(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_button_focus_ring_dark.png'),
    );
  });
}
