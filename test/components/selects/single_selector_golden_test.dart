import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:core_ui/core_ui.dart'; // update this import

void main() {
  testGoldens('SingleItemSelector Golden Test', (WidgetTester tester) async {
    await loadAppFonts();

    final builder = GoldenBuilder.column()
      ..addScenario(
        'Default (no selection)',
        SingleItemSelector<String>(
          labelText: 'Role',
          hintText: 'Select a role',
          modalTitle: 'Select Role',
          items: ['Engineer', 'Designer'],
          selectedItem: null,
          onItemSelected: (_) {},
        ),
      )
      ..addScenario(
        'Selected',
        SingleItemSelector<String>(
          labelText: 'Role',
          hintText: 'Select a role',
          modalTitle: 'Select Role',
          items: ['Engineer', 'Designer'],
          selectedItem: 'Designer',
          onItemSelected: (_) {},
        ),
      )
      ..addScenario(
        'Disabled',
        SingleItemSelector<String>(
          labelText: 'Role',
          hintText: 'Select a role',
          modalTitle: 'Select Role',
          items: ['Engineer', 'Designer'],
          selectedItem: null,
          onItemSelected: (_) {},
          isDisabled: true,
        ),
      );

    await tester.pumpWidgetBuilder(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: builder.build(),
      ),
      surfaceSize: const Size(400, 500),
    );

    await screenMatchesGolden(tester, 'single_item_selector');
  });

   testGoldens('SingleItemSelector with bottom sheet', (tester) async {
    await loadAppFonts();

    final items = ['Engineer', 'Designer', 'Manager'];

    await tester.pumpWidgetBuilder(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: items,
              selectedItem: null,
              onItemSelected: (_) {},
            ),
          ),
        ),
      ),
      surfaceSize: const Size(400, 800),
    );

    // Tap the selector to open bottom sheet
    await tester.tap(find.byType(SingleItemSelector<String>));
    await tester.pumpAndSettle();

    // Take golden screenshot with bottom sheet visible
    await screenMatchesGolden(tester, 'single_item_selector_with_bottom_sheet');
  });

  testGoldens('SingleItemSelector with bottom sheet and selected item', (tester) async {
    await loadAppFonts();

    final items = ['Engineer', 'Designer', 'Manager'];

    await tester.pumpWidgetBuilder(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: items,
              selectedItem: 'Designer',
              onItemSelected: (_) {},
            ),
          ),
        ),
      ),
      surfaceSize: const Size(400, 800),
    );

    // Tap the selector to open bottom sheet
    await tester.tap(find.byType(SingleItemSelector<String>));
    await tester.pumpAndSettle();

    // Take screenshot
    await screenMatchesGolden(tester, 'single_item_selector_with_bottom_sheet_selected');
  });
}
