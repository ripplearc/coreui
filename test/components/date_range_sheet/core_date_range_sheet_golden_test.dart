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

  Future<void> pumpVariant(
    WidgetTester tester,
    ThemeData theme, {
    DateRange? initialRange,
  }) async {
    final colors = theme.coreColors;

    // physicalSize is in physical pixels; logical size = physicalSize / DPR.
    // 780x1200 @ 2.0 => 390x600 logical, tall enough for the full sheet body.
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
            child: CoreDateRangeSheet(initialRange: initialRange),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('CoreDateRangeSheet Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariant(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_range_sheet_light.png'),
    );
  });

  testWidgets('CoreDateRangeSheet Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariant(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_date_range_sheet_dark.png'),
    );
  });

  testWidgets('CoreDateRangeSheet Visual Regression - Custom selected - Light',
      (WidgetTester tester) async {
    await pumpVariant(
      tester,
      _withRoboto(CoreTheme.light()),
      initialRange: DateRange(
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 5),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/core_date_range_sheet_custom_selected_light.png'),
    );
  });

  testWidgets('CoreDateRangeSheet Visual Regression - Custom selected - Dark',
      (WidgetTester tester) async {
    await pumpVariant(
      tester,
      _withRoboto(CoreTheme.dark()),
      initialRange: DateRange(
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 5),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/core_date_range_sheet_custom_selected_dark.png'),
    );
  });
}
