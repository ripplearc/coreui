import 'package:example/screens/color_showcase_screen.dart';
import 'package:example/screens/icon_showcase_screen.dart';
import 'package:example/screens/shadow_showcase_screen.dart';
import 'package:example/screens/spacing_showcase_screen.dart';
import 'package:example/screens/typography_showcase_screen.dart';
import 'package:flutter/material.dart';

class TokensScreen extends StatelessWidget {
  const TokensScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Design Tokens', style: textTheme.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Design Token Showcases',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildShowcaseButton(
              context,
              'Color Tokens',
              const ColorShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Typography Tokens',
              const TypographyShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Spacing Tokens',
              const SpacingShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Shadow Tokens',
              const ShadowShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Icon Tokens',
              const IconShowcaseScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowcaseButton(
      BuildContext context, String label, Widget screen) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
