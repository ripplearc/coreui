import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class CalculatorChipShowcaseScreen extends StatelessWidget {
  const CalculatorChipShowcaseScreen({super.key});

  void _showProvenance(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _section(BuildContext context, String title, List<Widget> chips) {
    final typography = Theme.of(context).coreTypography;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typography.bodyLargeSemiBold),
        const SizedBox(height: CoreSpacing.space3),
        Wrap(
          spacing: CoreSpacing.space2,
          runSpacing: CoreSpacing.space2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: chips,
        ),
        const SizedBox(height: CoreSpacing.space6),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator Chip Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(context, 'Typed (outlined)', [
              CoreCalculatorChip(
                type: CoreCalculatorChipType.editable,
                label: 'Length',
                value: '22ft',
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.editable,
                value: '4in',
                factor: CoreIcons.addOperator,
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.active,
                label: 'Width',
                value: '10ft',
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.active,
                value: '4in',
                factor: CoreIcons.addOperator,
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.active,
                factor: CoreIcons.addOperator,
                onTap: () {},
              ),
            ]),
            _section(context, 'Computed (filled) — long-press for provenance', [
              CoreCalculatorChip(
                type: CoreCalculatorChipType.result,
                label: 'Area',
                value: '220ft²',
                onTap: () {},
                onLongPress: () => _showProvenance(
                  context,
                  'Area 220ft² came from Length 22ft × Width 10ft',
                ),
                longPressSemanticLabel: 'show which chips produced this result',
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.result,
                value: '4in',
                factor: CoreIcons.addOperator,
                onLongPress: () => _showProvenance(context, '4in was added'),
                longPressSemanticLabel: 'show which chips produced this result',
              ),
              const CoreCalculatorChip(
                type: CoreCalculatorChipType.disabled,
                label: 'Area',
                value: '410.67ft²',
              ),
            ]),
            _section(context, 'Tentative (dashed)', [
              CoreCalculatorChip(
                type: CoreCalculatorChipType.dashed,
                label: 'Height',
                value: '8ft ?',
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.dashed,
                label: 'Area',
                value: '220ft²',
                onTap: () {},
              ),
            ]),
            _section(context, 'Error', [
              const CoreCalculatorChip(
                type: CoreCalculatorChipType.error,
                value: 'Dimension error',
              ),
              const CoreCalculatorChip(
                type: CoreCalculatorChipType.error,
                label: 'Area + length',
                value: 'cannot add',
              ),
            ]),
            Text(
              'Result shares the disabled fill on purpose (prototype .t-result): '
              'the two differ in interactivity, not in colour.',
              style:
                  typography.bodySmallRegular.copyWith(color: colors.textBody),
            ),
          ],
        ),
      ),
    );
  }
}
