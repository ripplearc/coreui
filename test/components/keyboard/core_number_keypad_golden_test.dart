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
    // 824x1600 @ 2.0 => a 412 dp wide phone, tall enough for two keypads.
    tester.view.physicalSize = const Size(824, 1600);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    Widget keypad({required String clearLabel, bool isConfirmEnabled = true}) {
      return CoreNumberKeypad(
        onDigitPressed: (_) {},
        onDecimalPressed: () {},
        onBackspacePressed: () {},
        onClearPressed: () {},
        onConfirmPressed: () {},
        clearLabel: clearLabel,
        confirmLabel: 'Add to estimate',
        isConfirmEnabled: isConfirmEnabled,
      );
    }

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: theme.coreColors.pageBackground,
          body: Column(
            children: [
              const SizedBox(height: CoreSpacing.space6),
              keypad(clearLabel: 'Back to 10%'),
              const SizedBox(height: CoreSpacing.space6),
              keypad(clearLabel: 'Clear', isConfirmEnabled: false),
            ],
          ),
        ),
      ),
    );

    await tester.pump();
  }

  testWidgets('CoreNumberKeypad Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_number_keypad_light.png'),
    );
  });

  testWidgets('CoreNumberKeypad Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariants(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_number_keypad_dark.png'),
    );
  });
}
