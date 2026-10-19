import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  final themes = {'light': CoreTheme.light(), 'dark': CoreTheme.dark()};

  Widget buildApp(ThemeData theme, Widget body) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme.copyWith(
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
      ),
      home: Scaffold(
        backgroundColor: theme.coreColors.pageBackground,
        body: body,
      ),
    );
  }

  Widget buildSelector({String? selectedItem, bool isDisabled = false}) {
    return SingleItemSelector<String>(
      labelText: 'Role',
      hintText: 'Select a role',
      modalTitle: 'Select Role',
      items: const ['Engineer', 'Designer', 'Manager'],
      selectedItem: selectedItem,
      onItemSelected: (_) {},
      isDisabled: isDisabled,
    );
  }

  for (final MapEntry(key: name, value: theme) in themes.entries) {
    testWidgets('SingleItemSelector - all variants - $name', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final labelStyle = theme.coreTypography.bodyMediumRegular
          .copyWith(color: theme.coreColors.textHeadline);

      await tester.pumpWidget(
        buildApp(
          theme,
          Padding(
            padding: const EdgeInsets.all(CoreSpacing.space4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Default (no selection)', style: labelStyle),
                const SizedBox(height: CoreSpacing.space2),
                buildSelector(),
                const SizedBox(height: CoreSpacing.space4),
                Text('Selected', style: labelStyle),
                const SizedBox(height: CoreSpacing.space2),
                buildSelector(selectedItem: 'Designer'),
                const SizedBox(height: CoreSpacing.space4),
                Text('Disabled', style: labelStyle),
                const SizedBox(height: CoreSpacing.space2),
                buildSelector(selectedItem: 'Designer', isDisabled: true),
              ],
            ),
          ),
        ),
      );

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/single_item_selector_$name.png'),
      );
    });

    testWidgets('SingleItemSelector with bottom sheet - $name', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(buildApp(theme, Center(child: buildSelector())));
      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/single_item_selector_with_bottom_sheet_$name.png',
        ),
      );
    });

    testWidgets('SingleItemSelector with bottom sheet and selected item - '
        '$name', (tester) async {
      await tester.binding.setSurfaceSize(const Size(400, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        buildApp(theme, Center(child: buildSelector(selectedItem: 'Designer'))),
      );
      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/single_item_selector_with_bottom_sheet_selected_$name.png',
        ),
      );
    });
  }
}
