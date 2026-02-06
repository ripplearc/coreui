import 'package:flutter/material.dart';

/// Common wrapper for widget tests to ensure a consistent scaffolded app shell.
///
/// [component] is the widget under test.
/// [theme] can be provided when a specific theme (e.g. `CoreTheme.light()`) is
/// required by the component.
Widget buildTestApp(
  Widget component, {
  ThemeData? theme,
}) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(
      body: Center(child: component),
    ),
  );
}
