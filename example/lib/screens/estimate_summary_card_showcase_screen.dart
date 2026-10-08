import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class EstimateSummaryCardShowcaseScreen extends StatelessWidget {
  const EstimateSummaryCardShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Estimate Summary Card',
            style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Totals', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            const CoreEstimateSummaryCard(
              title: 'Adds to this estimate',
              lineTotal: r'$520.00',
              estimateName: 'Bedroom 2',
              totalBeforeSuffix: r' total  $2,993.62 →',
              totalAfter: r'$3,513.62',
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('With an extra charge', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            const CoreEstimateSummaryCard(
              title: 'Adds to this estimate',
              lineTotal: r'$605.00',
              extraCharge: CoreEstimateSummaryCharge(
                label: 'incl. delivery',
                amount: r'+$85.00',
              ),
              estimateName: 'Bedroom 2',
              totalBeforeSuffix: r' total  $2,993.62 →',
              totalAfter: r'$3,598.62',
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Empty', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            const CoreEstimateSummaryCard.empty(
              title: 'Adds to this estimate',
              note: 'Needs a rate before it can total',
            ),
          ],
        ),
      ),
    );
  }
}
