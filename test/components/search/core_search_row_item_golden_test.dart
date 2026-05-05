import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreSearchRowItem Visual Regression Test',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 300);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    final colors = AppColorsExtension.create();

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _createTestTheme(),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoreSearchRowItem.recentSearch(
                text: '#Carpentry',
                onTap: () {},
                onTrailingTap: () {},
              ),
              CoreSearchRowItem.suggestion(
                text: '#Carpentry',
                query: 'Car',
                onTap: () {},
                onTrailingTap: () {},
              ),
              CoreSearchRowItem.suggestion(
                text: 'Carparking cost',
                query: 'Car',
                onTap: () {},
                onTrailingTap: () {},
              ),
            ],
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_search_row_item.png'),
    );
  });
}
