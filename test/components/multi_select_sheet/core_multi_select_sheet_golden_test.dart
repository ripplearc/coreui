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

  Future<void> pumpKeyboardVariant(WidgetTester tester, ThemeData theme) async {
    final colors = theme.coreColors;

    // 780x1688 @ 2.0 => 390x844 logical, a phone-sized viewport tall enough
    // for the lifted sheet plus the simulated keyboard.
    tester.view.physicalSize = const Size(780, 1688);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(() => tester.view.reset());

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          appBar: AppBar(title: const Text('Search')),
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () => CoreQuickSheet.show<void>(
                  context: context,
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
                child: const Text('Open tag filter'),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open tag filter'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    // Simulate the keyboard opening: 600 physical px = 300 logical.
    tester.view.viewInsets = const FakeViewPadding(bottom: 600);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
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

  testWidgets('CoreMultiSelectSheet Visual Regression - Keyboard open - Light',
      (WidgetTester tester) async {
    await pumpKeyboardVariant(tester, _withRoboto(CoreTheme.light()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_multi_select_sheet_keyboard_light.png'),
    );
  });

  testWidgets('CoreMultiSelectSheet Visual Regression - Keyboard open - Dark',
      (WidgetTester tester) async {
    await pumpKeyboardVariant(tester, _withRoboto(CoreTheme.dark()));

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_multi_select_sheet_keyboard_dark.png'),
    );
  });
}
