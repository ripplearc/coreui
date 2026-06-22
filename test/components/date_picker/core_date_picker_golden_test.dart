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

  Future<void> pumpVariant(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 780x1200 @ 2.0 => 390x600 logical, tall enough for the full calendar.
    tester.view.physicalSize = const Size(780, 1200);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Center(
            child: CoreDatePicker(
              selectedDate: DateTime(2025, 8, 17),
              today: DateTime(2025, 8, 5),
              onDateChanged: (_) {},
              onCancel: () {},
              onConfirm: () {},
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('CoreDatePicker Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariant(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_picker_light.png'),
    );
  });
}
