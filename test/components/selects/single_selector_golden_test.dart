import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_core_ui/core_ui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  testWidgets('SingleItemSelector - all variants', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 600));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Container(
            color: CoreBackgroundColors.pageBackground,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Default (no selection)'),
                const SizedBox(height: 8),
                SingleItemSelector<String>(
                  labelText: 'Role',
                  hintText: 'Select a role',
                  modalTitle: 'Select Role',
                  items: const ['Engineer', 'Designer'],
                  selectedItem: null,
                  onItemSelected: (_) {},
                  isDisabled: false,
                ),
                const SizedBox(height: 16),
                const Text('Selected'),
                const SizedBox(height: 8),
                SingleItemSelector<String>(
                  labelText: 'Role',
                  hintText: 'Select a role',
                  modalTitle: 'Select Role',
                  items: const ['Engineer', 'Designer'],
                  selectedItem: 'Designer',
                  onItemSelected: (_) {},
                  isDisabled: false,
                ),
                const SizedBox(height: 16),
                const Text('Disabled'),
                const SizedBox(height: 8),
                SingleItemSelector<String>(
                  labelText: 'Role',
                  hintText: 'Select a role',
                  modalTitle: 'Select Role',
                  items: const ['Engineer', 'Designer'],
                  selectedItem: 'Designer',
                  onItemSelected: (_) {},
                  isDisabled: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/single_item_selector.png'),
    );
  });

  testWidgets('SingleItemSelector with bottom sheet', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: const ['Engineer', 'Designer', 'Manager'],
              selectedItem: null,
              onItemSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(SingleItemSelector<String>));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/single_item_selector_with_bottom_sheet.png'),
    );
  });

  testWidgets('SingleItemSelector with bottom sheet and selected item',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: const ['Engineer', 'Designer', 'Manager'],
              selectedItem: 'Designer',
              onItemSelected: (_) {},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(SingleItemSelector<String>));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
          'goldens/single_item_selector_with_bottom_sheet_selected.png'),
    );
  });
}
