import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class ListRowShowcaseScreen extends StatelessWidget {
  const ListRowShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('List Row', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Plain rows', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            CoreListRow(
              title: 'Scissor lift — 19ft',
              subtitle: 'Used last week',
              value: r'$120.00',
              unit: '/day',
              onTap: () {},
            ),
            CoreListRow(
              title: 'Dumpster — 30 yd',
              subtitle: 'Used 2 weeks ago',
              value: r'$400.00',
              unit: 'job',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
