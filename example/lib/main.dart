import 'package:core_ui/core_ui.dart';
import 'package:example/screens/color_showcase_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Core UI Colors',
      theme: CoreTheme.light(),
      darkTheme: CoreTheme.dark(),
      home: const ColorShowcaseScreen(),
    );
  }
}
