import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class StatusBadgeShowcaseScreen extends StatelessWidget {
  const StatusBadgeShowcaseScreen({super.key});

  Widget _section(
    BuildContext context,
    String title,
    Widget badge,
  ) {
    final typography = Theme.of(context).coreTypography;

    return Padding(
      padding: const EdgeInsets.only(bottom: CoreSpacing.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typography.bodyLargeSemiBold),
          const SizedBox(height: CoreSpacing.space2),
          badge,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Status Badge', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              context,
              'Warning',
              const CoreStatusBadge(label: 'Sample rate'),
            ),
            _section(
              context,
              'Warning with info icon',
              const CoreStatusBadge(label: 'Sample rate', showInfoIcon: true),
            ),
            _section(
              context,
              'Warning with tappable info icon',
              CoreStatusBadge(
                label: 'Sample rate',
                showInfoIcon: true,
                onInfoTap: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Info icon tapped')),
                ),
                infoSemanticLabel: 'About sample rates',
              ),
            ),
            _section(
              context,
              'Warning compact',
              const CoreStatusBadge(
                label: 'Sample rate',
                size: CoreStatusBadgeSize.compact,
              ),
            ),
            _section(
              context,
              'Neutral',
              const CoreStatusBadge(
                label: 'After first send',
                variant: CoreStatusBadgeVariant.neutral,
              ),
            ),
            _section(
              context,
              'Squeezed: the label is cut with an ellipsis',
              const SizedBox(
                width: 80,
                child: CoreStatusBadge(label: 'Sample rate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
