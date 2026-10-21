import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class SpacingShowcaseScreen extends StatelessWidget {
  const SpacingShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spacing Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Spacing System',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Our spacing system is based on a 4px grid (0.25rem with 16px base).',
              style: Theme.of(context).coreTypography.bodyLargeRegular,
            ),
            const SizedBox(height: 24),

            // Base spacing values
            _buildSpacingVisuals(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSpacingVisuals(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSpacingSection(context, '1', '0.25rem', '4px', CoreSpacing.space1),
        _buildSpacingSection(context, '2', '0.5rem', '8px', CoreSpacing.space2),
        _buildSpacingSection(context, '3', '0.75rem', '12px', CoreSpacing.space3),
        _buildSpacingSection(context, '4', '1rem', '16px', CoreSpacing.space4),
        _buildSpacingSection(context, '5', '1.25rem', '20px', CoreSpacing.space5),
        _buildSpacingSection(context, '6', '1.5rem', '24px', CoreSpacing.space6),
        _buildSpacingSection(context, '8', '2rem', '32px', CoreSpacing.space8),
        _buildSpacingSection(context, '10', '2.5rem', '40px', CoreSpacing.space10),
        _buildSpacingSection(context, '12', '3rem', '48px', CoreSpacing.space12),
        _buildSpacingSection(context, '16', '4rem', '64px', CoreSpacing.space16),
        _buildSpacingSection(context, '20', '5rem', '80px', CoreSpacing.space20),
        _buildSpacingSection(context, '24', '6rem', '96px', CoreSpacing.space24),
        _buildSpacingSection(context, '32', '8rem', '128px', CoreSpacing.space32),
        _buildSpacingSection(context, '40', '10rem', '160px', CoreSpacing.space40),
        _buildSpacingSection(context, '48', '12rem', '192px', CoreSpacing.space48),
        _buildSpacingSection(context, '56', '14rem', '224px', CoreSpacing.space56),
        _buildSpacingSection(context, '64', '16rem', '256px', CoreSpacing.space64),
        _buildSpacingSection(context, 'px2', '0.125rem', '2px', CoreSpacing.px2),
        _buildSpacingSection(context, 'px3', '0.1875rem', '3px', CoreSpacing.px3),
        _buildSpacingSection(context, 'px5', '0.3125rem', '5px', CoreSpacing.px5),
        _buildSpacingSection(context, 'px6', '0.375rem', '6px', CoreSpacing.px6),
        _buildSpacingSection(context, 'px10', '0.625rem', '10px', CoreSpacing.px10),
        _buildSpacingSection(context, 'px11', '0.6875rem', '11px', CoreSpacing.px11),
        _buildSpacingSection(context, 'px15', '0.9375rem', '15px', CoreSpacing.px15),
        _buildSpacingSection(context, 'px17', '1.0625rem', '17px', CoreSpacing.px17),
      ],
    );
  }

  Widget _buildSpacingSection(BuildContext context, String name,
      String remValue, String pixelValue, double size) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 36,
            child: Text(
              name,
              style: theme.coreTypography.bodyMediumSemiBold,
            ),
          ),
          SizedBox(
            width: 64,
            child: Text(remValue),
          ),
          SizedBox(
            width: 40,
            child: Text(pixelValue),
          ),
          Container(
            height: 24,
            width: size,
            color: theme.coreColors.backgroundBlueLight,
          ),
        ],
      ),
    );
  }
}
