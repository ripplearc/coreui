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
            child: CoreMultiSelectSheet(
              title: 'Tags',
              searchHint: 'Search by tag name',
              emptyLabel: 'No tags found.',
              initialSelectedIds: const {'roofing'},
              listData: const CoreMultiSelectListData(
                isLoading: false,
                items: [
                  CoreMultiSelectItem(id: 'roofing', label: 'Roofing'),
                  CoreMultiSelectItem(id: 'wall', label: 'Wall'),
                  CoreMultiSelectItem(id: 'flooring', label: 'Flooring'),
                ],
              ),
              onSearchQueryChanged: (_) {},
              onApply: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('CoreMultiSelectSheet Visual Regression - Light',
      (WidgetTester tester) async {
    await pumpVariant(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_multi_select_sheet_light.png'),
    );
  });

  testWidgets('CoreMultiSelectSheet Visual Regression - Dark',
      (WidgetTester tester) async {
    await pumpVariant(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_multi_select_sheet_dark.png'),
    );
  });
}
