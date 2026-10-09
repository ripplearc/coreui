import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class ListRowShowcaseScreen extends StatefulWidget {
  const ListRowShowcaseScreen({super.key});

  @override
  State<ListRowShowcaseScreen> createState() => _ListRowShowcaseScreenState();
}

class _ListRowShowcaseScreenState extends State<ListRowShowcaseScreen> {
  String _pickedRate = 'Mini excavator — 1.5 ton';

  static const _rates = [
    ('Mini excavator — 1.5 ton', 'Compact, tight-access digging', r'$145.00'),
    ('Skid steer — track', 'Loader attachment ready', r'$165.00'),
  ];

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
            const SizedBox(height: CoreSpacing.space6),
            Text('Selectable rows (tap to pick)',
                style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            for (final (title, subtitle, value) in _rates)
              CoreListRow.selectable(
                title: title,
                subtitle: subtitle,
                value: value,
                unit: '/day',
                selected: _pickedRate == title,
                onTap: () => setState(() => _pickedRate = title),
              ),
          ],
        ),
      ),
    );
  }
}
