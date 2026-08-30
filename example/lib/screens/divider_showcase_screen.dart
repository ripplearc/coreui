import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class DividerShowcaseScreen extends StatelessWidget {
  const DividerShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;

    return Scaffold(
      appBar: AppBar(
        title: Text('Divider', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Full-bleed hairline', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            const CoreDivider(),
            const SizedBox(height: CoreSpacing.space6),
            Text('Inset hairline', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            const CoreDivider(
              indent: CoreSpacing.space4,
              endIndent: CoreSpacing.space4,
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Custom color', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            CoreDivider(color: colors.lineMid),
            const SizedBox(height: CoreSpacing.space6),
            Text('Label separator', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            Row(
              children: [
                const Expanded(child: CoreDivider()),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CoreSpacing.space2,
                  ),
                  child: Text(
                    'or',
                    style: typography.bodyMediumRegular.copyWith(
                      color: colors.textBody,
                    ),
                  ),
                ),
                const Expanded(child: CoreDivider()),
              ],
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('End-of-list footer', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            Column(
              children: [
                const CoreDivider(),
                const SizedBox(height: CoreSpacing.space6),
                Text(
                  'End of results',
                  style: typography.bodyMediumRegular.copyWith(
                    color: colors.textBody,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
