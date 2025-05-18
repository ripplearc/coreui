import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_ui/core_ui.dart';

void main() {
  group('Toast Widget Tests', () {
    testWidgets('renders Error Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.error(
              title: 'Error Title',
              description: 'Error Description',
            ),
          ),
        ),
      );

      expect(find.text('Error Title'), findsOneWidget);
      expect(find.text('Error Description'), findsOneWidget);
    });

    testWidgets('renders Warning Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.warning(
              title: 'Warning Title',
              description: 'Warning Description',
            ),
          ),
        ),
      );

      expect(find.text('Warning Title'), findsOneWidget);
      expect(find.text('Warning Description'), findsOneWidget);
    });

    testWidgets('renders Info Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.info(
              title: 'Info Title',
              description: 'Info Description',
            ),
          ),
        ),
      );

      expect(find.text('Info Title'), findsOneWidget);
      expect(find.text('Info Description'), findsOneWidget);
    });

    testWidgets('renders Success Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.success(
              title: 'Success Title',
              description: 'Success Description',
            ),
          ),
        ),
      );

      expect(find.text('Success Title'), findsOneWidget);
      expect(find.text('Success Description'), findsOneWidget);
    });

    testWidgets('onClose callback is triggered when close icon is tapped',
        (WidgetTester tester) async {
      bool wasClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.success(
              title: 'Closable Toast',
              description: 'This toast can be closed',
              onClose: () {
                wasClosed = true;
              },
            ),
          ),
        ),
      );

      // The close icon should exist
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Tap the close icon
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump(); // allow state changes to propagate

      // Verify that the callback was triggered
      expect(wasClosed, isTrue);
    });
  });
}
