import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('CoreChip Component Visual Regression Test',
      (WidgetTester tester) async {
    // Skip on CI environments due to platform-specific rendering differences
    if (Platform.environment.containsKey('CI') ||
        Platform.environment.containsKey('GITHUB_ACTIONS')) {
      return;
    }
    await tester.binding.setSurfaceSize(const Size(1200, 600));

    final selectedSmall = ValueNotifier<bool>(false);
    final selectedSmallIcon = ValueNotifier<bool>(false);
    final selectedMedium = ValueNotifier<bool>(false);
    final selectedMediumIcon = ValueNotifier<bool>(false);
    final selectedMediumSelected = ValueNotifier<bool>(true);
    final selectedLarge = ValueNotifier<bool>(false);
    final selectedLargeIcon = ValueNotifier<bool>(false);
    final selectedLargeSelected = ValueNotifier<bool>(true);

    final chips = <Widget>[
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Small - Default',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Small Chip',
            selected: selectedSmall,
            size: CoreChipSize.small,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Small - With Icon',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Small Icon',
            selected: selectedSmallIcon,
            size: CoreChipSize.small,
            icon: CoreIcons.check,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Medium - Default',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Medium Chip',
            selected: selectedMedium,
            size: CoreChipSize.medium,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Medium - With Icon',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Medium Icon',
            selected: selectedMediumIcon,
            size: CoreChipSize.medium,
            icon: CoreIcons.favorite,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Medium - Selected',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Selected',
            selected: selectedMediumSelected,
            size: CoreChipSize.medium,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Large - Default',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Large Chip',
            selected: selectedLarge,
            size: CoreChipSize.large,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Large - With Icon',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Large Icon',
            selected: selectedLargeIcon,
            size: CoreChipSize.large,
            icon: CoreIcons.settings,
          ),
        ],
      ),
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Large - Selected',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          CoreChip(
            label: 'Selected',
            selected: selectedLargeSelected,
            size: CoreChipSize.large,
          ),
        ],
      ),
    ];

    final widget = MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            children: chips,
          ),
        ),
      ),
    );

    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/core_chip_component.png'),
    );
  });
}
