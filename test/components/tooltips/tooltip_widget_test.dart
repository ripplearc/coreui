import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreTooltip Widget Tests', () {
    const testMessage = 'Test tooltip message';
    const testChild = Icon(Icons.info);

    testWidgets('renders child widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreTooltip(
              message: testMessage,
              child: testChild,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.info), findsOneWidget);
    });

    testWidgets('shows tooltip on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreTooltip(
              message: testMessage,
              child: testChild,
            ),
          ),
        ),
      );

      // Initially, tooltip should not be visible
      expect(find.text(testMessage), findsNothing);

      // Tap the child widget
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester
          .pump(const Duration(milliseconds: 200)); // Wait for animation

      // Tooltip should now be visible
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('hides tooltip on second tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreTooltip(
              message: testMessage,
              child: testChild,
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text(testMessage), findsOneWidget);

      // Hide tooltip by tapping again
      await tester.tap(find.byIcon(Icons.info), warnIfMissed: false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(find.text(testMessage), findsNothing);
    });

    testWidgets('shows tooltip with top position', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: Center(
              child: CoreTooltip.top(
                message: testMessage,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tooltip should be visible
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('shows tooltip with bottom position',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: Center(
              child: CoreTooltip.bottom(
                message: testMessage,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tooltip should be visible
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('shows tooltip with left position',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: Center(
              child: CoreTooltip.left(
                message: testMessage,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tooltip should be visible
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('shows tooltip with right position',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: Center(
              child: CoreTooltip.right(
                message: testMessage,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tooltip should be visible
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('shows tooltip with no arrow', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: Center(
              child: CoreTooltip.none(
                message: testMessage,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Tooltip should be visible
      expect(find.text(testMessage), findsOneWidget);
    });

    testWidgets('displays correct message text', (WidgetTester tester) async {
      const customMessage = 'Custom tooltip message';

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreTooltip.none(
              message: customMessage,
              child: testChild,
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Check that the custom message is displayed
      expect(find.text(customMessage), findsOneWidget);
    });

    testWidgets('tooltip appears above child when using .top()',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: Center(
              child: CoreTooltip.top(
                message: testMessage,
                child: testChild,
              ),
            ),
          ),
        ),
      );

      // Show tooltip
      await tester.tap(find.byIcon(Icons.info));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify tooltip is visible
      expect(find.text(testMessage), findsOneWidget);

      // Get positions
      final childCenter = tester.getCenter(find.byIcon(Icons.info));
      final tooltipCenter = tester.getCenter(find.text(testMessage));

      // Tooltip should be above the child (smaller y coordinate)
      expect(tooltipCenter.dy < childCenter.dy, isTrue);
    });
  });
}
