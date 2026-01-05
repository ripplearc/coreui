import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:flutter/material.dart';

class TypographyShowcaseScreen extends StatelessWidget {
  const TypographyShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the typography extension
    final typography = Theme.of(context).extension<AppTypographyExtension>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Typography System'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Typography System',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // Headline Large
            _buildTypographySection(
              context,
              title: 'Headline Large',
              regularStyle: typography.headlineLargeRegular,
              semiBoldStyle: typography.headlineLargeSemiBold,
            ),

            // Headline Medium
            _buildTypographySection(
              context,
              title: 'Headline Medium',
              regularStyle: typography.headlineMediumRegular,
              semiBoldStyle: typography.headlineMediumSemiBold,
            ),

            // Title Large
            _buildTypographySection(
              context,
              title: 'Title Large',
              regularStyle: typography.titleLargeRegular,
              mediumStyle: typography.titleLargeMedium,
              semiBoldStyle: typography.titleLargeSemiBold,
            ),

            // Title Medium
            _buildTypographySection(
              context,
              title: 'Title Medium',
              regularStyle: typography.titleMediumRegular,
              mediumStyle: typography.titleMediumMedium,
              semiBoldStyle: typography.titleMediumSemiBold,
            ),

            // Body Large
            _buildTypographySection(
              context,
              title: 'Body Large',
              regularStyle: typography.bodyLargeRegular,
              mediumStyle: typography.bodyLargeMedium,
              semiBoldStyle: typography.bodyLargeSemiBold,
            ),

            // Body Medium
            _buildTypographySection(
              context,
              title: 'Body Medium',
              regularStyle: typography.bodyMediumRegular,
              mediumStyle: typography.bodyMediumMedium,
              semiBoldStyle: typography.bodyMediumSemiBold,
            ),

            // Body Small
            _buildTypographySection(
              context,
              title: 'Body Small',
              regularStyle: typography.bodySmallRegular,
              mediumStyle: typography.bodySmallMedium,
              semiBoldStyle: typography.bodySmallSemiBold,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypographySection(
    BuildContext context, {
    required String title,
    TextStyle? regularStyle,
    TextStyle? mediumStyle,
    TextStyle? semiBoldStyle,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        if (regularStyle != null)
          _buildTextStyleCard(
            'Regular',
            'The quick brown fox jumps over the lazy dog',
            regularStyle,
          ),
        if (mediumStyle != null)
          _buildTextStyleCard(
            'Medium',
            'The quick brown fox jumps over the lazy dog',
            mediumStyle,
          ),
        if (semiBoldStyle != null)
          _buildTextStyleCard(
            'SemiBold',
            'The quick brown fox jumps over the lazy dog',
            semiBoldStyle,
          ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildTextStyleCard(String weight, String text, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                weight,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(text, style: style),
              const SizedBox(height: 8),
              Text(
                '${style.fontSize}px / ${(style.fontSize! * style.height!).round()}px',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
