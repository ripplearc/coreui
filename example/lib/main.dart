import 'package:core_ui/core_ui.dart';
import 'package:example/screens/color_showcase_screen.dart';
import 'package:example/screens/shadow_showcase_screen.dart';
import 'package:example/screens/spacing_showcase_screen.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Core UI Components'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ColorShowcaseScreen(),
                  ),
                );
              },
              child: const Text('Color Showcase'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ShadowShowcaseScreen(),
                  ),
                );
              },
              child: const Text('Shadow Showcase'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SpacingShowcaseScreen(),
                  ),
                );
              },
              child: const Text('Spacing Showcase'),
            ),
          ],
        ),
      ),
    );
  }
}
