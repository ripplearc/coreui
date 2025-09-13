import 'package:ripplearc_coreui/core_ui.dart';
import 'package:flutter/material.dart';

class ShadowShowcaseScreen extends StatelessWidget {
  const ShadowShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shadow Showcase'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shadows',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),

            // Extra Small Shadow
            _buildShadowSection(
              context,
              title: 'Extra Small (xs)',
              description: 'Blur: 2px, Y-offset: 1px',
              shadowType: CoreShadows.extraSmall,
            ),
            const SizedBox(height: 32),

            // Small Shadow
            _buildShadowSection(
              context,
              title: 'Small (sm)',
              description: 'Blur: 4px, Y-offset: 2px',
              shadowType: CoreShadows.small,
            ),
            const SizedBox(height: 32),

            // Medium Shadow
            _buildShadowSection(
              context,
              title: 'Medium (md)',
              description: 'Blur: 8px, Y-offset: 4px',
              shadowType: CoreShadows.medium,
            ),
            const SizedBox(height: 32),

            // Large Shadow
            _buildShadowSection(
              context,
              title: 'Large (lg)',
              description: 'Blur: 12px, Y-offset: 6px',
              shadowType: CoreShadows.large,
            ),
            const SizedBox(height: 32),

            // Extra Large Shadow
            _buildShadowSection(
              context,
              title: 'Extra Large (xl)',
              description: 'Blur: 16px, Y-offset: 8px',
              shadowType: CoreShadows.extraLarge,
            ),
            const SizedBox(height: 32),

            // Double Extra Large Shadow
            _buildShadowSection(
              context,
              title: 'Double Extra Large (2xl)',
              description: 'Blur: 24px, Y-offset: 12px',
              shadowType: CoreShadows.doubleExtraLarge,
            ),
            const SizedBox(height: 32),

            // Sticky Shadow
            _buildShadowSection(
              context,
              title: 'Sticky',
              description: 'Combined shadows for sticky elements',
              shadowType: CoreShadows.sticky,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildShadowSection(
    BuildContext context, {
    required String title,
    required String description,
    required List<BoxShadow> shadowType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 200,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: shadowType,
            ),
            child: Center(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
