import 'package:core_ui/core_ui.dart';
import 'package:example/screens/color_showcase_screen.dart';
import 'package:example/screens/shadow_showcase_screen.dart';
import 'package:example/screens/typography_showcase_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Core UI Demo',
      theme: CoreTheme.light(),
      darkTheme: CoreTheme.dark(),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    print('Font family from context: ${textTheme.bodyLarge?.fontFamily}');
    // print('Font family from context (theme): ${Theme.of(context).fontFamily}');

    return Scaffold(
      appBar: AppBar(
        title: Text('Core UI Components', style: textTheme.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Component Showcases',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildShowcaseButton(
              context,
              'Color Showcase',
              const ColorShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Shadow Showcase',
              const ShadowShowcaseScreen(),
            ),
            const SizedBox(height: 16),
            _buildShowcaseButton(
              context,
              'Typography Showcase',
              const TypographyShowcaseScreen(),
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
