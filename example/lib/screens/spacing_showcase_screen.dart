import 'package:flutter/material.dart';
import 'package:ripplearc_core_ui/core_ui.dart';

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
            const Text(
              'Our spacing system is based on a 4px grid (0.25rem with 16px base).',
              style: TextStyle(fontSize: 16),
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
        _buildSpacingSection('1', '0.25rem', '4px', CoreSpacing.space1),
        _buildSpacingSection('2', '0.5rem', '8px', CoreSpacing.space2),
        _buildSpacingSection('3', '0.75rem', '12px', CoreSpacing.space3),
        _buildSpacingSection('4', '1rem', '16px', CoreSpacing.space4),
        _buildSpacingSection('5', '1.25rem', '20px', CoreSpacing.space5),
        _buildSpacingSection('6', '1.5rem', '24px', CoreSpacing.space6),
        _buildSpacingSection('8', '2rem', '32px', CoreSpacing.space8),
        _buildSpacingSection('10', '2.5rem', '40px', CoreSpacing.space10),
        _buildSpacingSection('12', '3rem', '48px', CoreSpacing.space12),
        _buildSpacingSection('16', '4rem', '64px', CoreSpacing.space16),
        _buildSpacingSection('20', '5rem', '80px', CoreSpacing.space20),
        _buildSpacingSection('24', '6rem', '96px', CoreSpacing.space24),
        _buildSpacingSection('32', '8rem', '128px', CoreSpacing.space32),
        _buildSpacingSection('40', '10rem', '160px', CoreSpacing.space40),
        _buildSpacingSection('48', '12rem', '192px', CoreSpacing.space48),
        _buildSpacingSection('56', '14rem', '224px', CoreSpacing.space56),
        _buildSpacingSection('64', '16rem', '256px', CoreSpacing.space64),
      ],
    );
  }

  Widget _buildSpacingSection(
      String name, String remValue, String pixelValue, double size) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 50,
            child: Text(remValue),
          ),
          SizedBox(
            width: 32,
            child: Text(pixelValue),
          ),
          Container(
            height: 24,
            width: size,
            color: Colors.blue.shade200,
          ),
        ],
      ),
    );
  }
}
