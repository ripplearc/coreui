import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class ChipShowcaseScreen extends StatefulWidget {
  const ChipShowcaseScreen({super.key});

  @override
  State<ChipShowcaseScreen> createState() => _ChipShowcaseScreenState();
}

class _ChipShowcaseScreenState extends State<ChipShowcaseScreen> {
  late List<ValueNotifier<bool>> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.generate(7, (_) => ValueNotifier(false));
  }

  @override
  void dispose() {
    for (final notifier in _selected) {
      notifier.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypographyExtension.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Core Chip Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chip Sizes', style: typography.titleMediumSemiBold),
            const SizedBox(height: CoreSpacing.space5),
            Text('Small Chips', style: typography.bodyMediumRegular),
            const SizedBox(height: CoreSpacing.space3),
            Wrap(
              spacing: CoreSpacing.space3,
              runSpacing: CoreSpacing.space3,
              children: [
                CoreChip(
                  label: 'Small Chip',
                  selected: _selected[0],
                  size: CoreChipSize.small,
                ),
                CoreChip(
                  label: 'Small with Icon',
                  selected: _selected[1],
                  size: CoreChipSize.small,
                  icon: CoreIcons.checkCircle,
                ),
              ],
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text('Medium Chips', style: typography.bodyMediumRegular),
            const SizedBox(height: CoreSpacing.space3),
            Wrap(
              spacing: CoreSpacing.space3,
              runSpacing: CoreSpacing.space3,
              children: [
                CoreChip(
                  label: 'Medium Chip',
                  selected: _selected[2],
                  size: CoreChipSize.medium,
                ),
                CoreChip(
                  label: 'Medium with Icon',
                  selected: _selected[3],
                  size: CoreChipSize.medium,
                  icon: CoreIcons.checkCircle,
                ),
              ],
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text('Large Chips', style: typography.bodyMediumRegular),
            const SizedBox(height: CoreSpacing.space3),
            Wrap(
              spacing: CoreSpacing.space3,
              runSpacing: CoreSpacing.space3,
              children: [
                CoreChip(
                  label: 'Large Chip',
                  selected: _selected[4],
                  size: CoreChipSize.large,
                ),
                CoreChip(
                  label: 'Large with Icon',
                  selected: _selected[5],
                  size: CoreChipSize.large,
                  icon: CoreIcons.checkCircle,
                ),
              ],
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text('States', style: typography.bodyMediumRegular),
            const SizedBox(height: CoreSpacing.space3),
            Text(
              'Click chips above to see default, hover, pressed, and selected states.',
              style: typography.bodySmallRegular,
            ),
            const SizedBox(height: CoreSpacing.space3),
            Text(
              'The chips use color tokens for consistent styling across states.',
              style: typography.bodySmallRegular
                  .copyWith(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: CoreSpacing.space3),
            Text('Non-interactive', style: typography.bodyMediumRegular),
            const SizedBox(height: CoreSpacing.space3),
            CoreChip(
              label: 'Read-only',
              selected: _selected[6],
            ),
          ],
        ),
      ),
    );
  }
}
