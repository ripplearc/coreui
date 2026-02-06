import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:example/screens/components_screen.dart';
import 'package:example/screens/tokens_screen.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Core UI Library', style: textTheme.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Core UI Library',
              style: textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildCategoryButton(
              context,
              'Design Tokens',
              const TokensScreen(),
            ),
            const SizedBox(height: 16),
            _buildCategoryButton(
              context,
              'Components',
              const ComponentsScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(
      BuildContext context, String label, Widget screen) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(200, 50),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Text(label, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
