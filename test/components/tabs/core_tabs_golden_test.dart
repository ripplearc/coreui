import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

ThemeData _createTestTheme() {
  return CoreTheme.light().copyWith(
    textTheme: ThemeData.light().textTheme.apply(
          fontFamily: 'Roboto',
        ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  final typography = AppTypographyExtension.create();
  final colors = AppColorsExtension.create();

  testWidgets('CoreTabs Golden Test - All Variants',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final widget = MaterialApp(
      theme: _createTestTheme(),
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: Padding(
          padding: const EdgeInsets.all(CoreSpacing.space4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tabs Test',
                style: typography.bodyLargeSemiBold
                    .copyWith(color: colors.textDark),
              ),
              const CoreTabs(tabs: ['Tab 1', 'Tab 2'], selectedIndex: 0),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(tabs: ['Tab 1', 'Tab 2'], selectedIndex: 1),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(tabs: ['Tab 1', 'Tab 2', 'Tab 3'], selectedIndex: 0),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(tabs: ['Tab 1', 'Tab 2', 'Tab 3'], selectedIndex: 1),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(tabs: ['Tab 1', 'Tab 2', 'Tab 3'], selectedIndex: 2),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 0),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 1),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 2),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'], selectedIndex: 3),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 0),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 1),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 2),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 3),
              const SizedBox(height: CoreSpacing.space6),
              const CoreTabs(
                  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
                  selectedIndex: 4),
            ],
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_tabs_component.png'),
    );
  });

  Future<void> pumpStateRows(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(240, 160));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: _createTestTheme(),
        home: Scaffold(
          backgroundColor: colors.pageBackground,
          body: const Padding(
            padding: EdgeInsets.all(CoreSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoreTabs(key: Key('first_row'), tabs: ['Tab 1', 'Tab 2']),
                SizedBox(height: CoreSpacing.space4),
                CoreTabs(key: Key('second_row'), tabs: ['Tab 1', 'Tab 2']),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder tabOf(String row, int index) => find.descendant(
        of: find.byKey(Key(row)),
        matching: find.byKey(CoreTabs.tabKey(index)),
      );

  testWidgets('CoreTabs Golden Test - Pressed', (WidgetTester tester) async {
    await pumpStateRows(tester);

    final unselected =
        await tester.startGesture(tester.getCenter(tabOf('first_row', 1)));
    final selected =
        await tester.startGesture(tester.getCenter(tabOf('second_row', 0)));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_tabs_pressed.png'),
    );
    await unselected.cancel();
    await selected.cancel();
  });

  testWidgets('CoreTabs Golden Test - Focused', (WidgetTester tester) async {
    await pumpStateRows(tester);

    // First row: the selected tab. Second row: the unselected one.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_tabs_focused_selected.png'),
    );

    for (var i = 0; i < 3; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    }
    await tester.pumpAndSettle();
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_tabs_focused.png'),
    );
  });
}
