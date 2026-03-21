import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class CalculatorChipShowcaseScreen extends StatelessWidget {
  const CalculatorChipShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator Chip Showcase')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(CoreSpacing.space4),
          child: Wrap(
            spacing: CoreSpacing.space2,
            runSpacing: CoreSpacing.space2,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              CoreCalculatorChip(
                type: CoreCalculatorChipType.editable,
                label: 'Length',
                value: '22ft',
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.disable,
                label: 'Area',
                value: '410.67ft²',
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.active,
                label: 'Area',
                value: '410.67ft²',
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.editable,
                value: '4in',
                withCloseIcon: true,
                onClose: () {},
                onTap: () {},
              ),
              CoreCalculatorChip(
                type: CoreCalculatorChipType.active,
                value: '4in',
                withCloseIcon: true,
                onClose: () {},
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
