import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class DetailsRowShowcaseScreen extends StatefulWidget {
  const DetailsRowShowcaseScreen({super.key});

  @override
  State<DetailsRowShowcaseScreen> createState() =>
      _DetailsRowShowcaseScreenState();
}

class _DetailsRowShowcaseScreenState extends State<DetailsRowShowcaseScreen> {
  bool _deliveryOpen = false;
  bool _wasteOpen = false;

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;

    return Scaffold(
      appBar: AppBar(
        title: Text('Details Row', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CoreDetailsRow(
              label: 'Delivery',
              value: r'$150',
              expanded: _deliveryOpen,
              onToggle: () => setState(() => _deliveryOpen = !_deliveryOpen),
              actionLabel: 'Add note',
              onAction: () => setState(() => _deliveryOpen = true),
              child: Text(
                'The delivery fee and note fields go here.',
                style: typography.bodyMediumRegular.copyWith(
                  color: colors.textBody,
                ),
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreDetailsRow(
              label: 'Waste',
              value: '10%',
              expanded: _wasteOpen,
              onToggle: () => setState(() => _wasteOpen = !_wasteOpen),
              child: Text(
                'The waste field goes here.',
                style: typography.bodyMediumRegular.copyWith(
                  color: colors.textBody,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
