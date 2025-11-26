import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class ChipShowcaseScreen extends StatefulWidget {
  const ChipShowcaseScreen({super.key});

  @override
  State<ChipShowcaseScreen> createState() => _ChipShowcaseScreenState();
}

class _ChipShowcaseScreenState extends State<ChipShowcaseScreen> {
  late ValueNotifier<bool> smallChipSelected;
  late ValueNotifier<bool> mediumChipSelected;
  late ValueNotifier<bool> largeChipSelected;
  late ValueNotifier<bool> smallChipWithIconSelected;
  late ValueNotifier<bool> mediumChipWithIconSelected;
  late ValueNotifier<bool> largeChipWithIconSelected;

  @override
  void initState() {
    super.initState();
    smallChipSelected = ValueNotifier(false);
    mediumChipSelected = ValueNotifier(false);
    largeChipSelected = ValueNotifier(false);
    smallChipWithIconSelected = ValueNotifier(false);
    mediumChipWithIconSelected = ValueNotifier(false);
    largeChipWithIconSelected = ValueNotifier(false);
  }

  @override
  void dispose() {
    smallChipSelected.dispose();
    mediumChipSelected.dispose();
    largeChipSelected.dispose();
    smallChipWithIconSelected.dispose();
    mediumChipWithIconSelected.dispose();
    largeChipWithIconSelected.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Core Chip Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chip Sizes',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),

            // Small Chips
            Text(
              'Small Chips',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CoreChip(
                  label: 'Small Chip',
                  selected: smallChipSelected,
                  size: CoreChipSize.small,
                ),
                CoreChip(
                  label: 'Small with Icon',
                  selected: smallChipWithIconSelected,
                  size: CoreChipSize.small,
                  icon: CoreIcons.checkCircle,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Medium Chips
            Text(
              'Medium Chips',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CoreChip(
                  label: 'Medium Chip',
                  selected: mediumChipSelected,
                  size: CoreChipSize.medium,
                ),
                CoreChip(
                  label: 'Medium with Icon',
                  selected: mediumChipWithIconSelected,
                  size: CoreChipSize.medium,
                  icon: CoreIcons.checkCircle,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Large Chips
            Text(
              'Large Chips',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                CoreChip(
                  label: 'Large Chip',
                  selected: largeChipSelected,
                  size: CoreChipSize.large,
                ),
                CoreChip(
                  label: 'Large with Icon',
                  selected: largeChipWithIconSelected,
                  size: CoreChipSize.large,
                  icon: CoreIcons.checkCircle,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // States
            Text(
              'States',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'Default: Click chips above to see default, hover, pressed, and selected states.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            const Text(
              'The chips use color tokens for consistent styling across states.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
