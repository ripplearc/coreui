import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../utils/a11y_guidelines.dart';
import '../utils/test_harness.dart';

void main() {
  group('CoreToast', () {
    setUp(() {
      // Disable timers for testing and clean up any existing toasts
      CoreToast.disableTimers();
      CoreToast.cleanup();
    });

    tearDown(() {
      // Re-enable timers and clean up after each test
      CoreToast.enableTimers();
      CoreToast.cleanup();
    });

    final colors = AppColorsExtension.create();
    testWidgets('showSuccess displays success toast with default message',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showSuccess(
                    context, 'Request Successful', 'Close'),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      // Check that the success toast is displayed
      expect(find.text('Request Successful'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('showSuccess displays success toast with title',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showSuccess(
                  context,
                  'Your changes have been saved successfully',
                  'Close',
                  title: 'Success',
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Success'), findsOneWidget);
      expect(find.text('Your changes have been saved successfully'),
          findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('showSuccess displays no separate title when title is omitted',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showSuccess(
                  context,
                  'Request Successful',
                  'Close',
                  // title intentionally omitted
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Request Successful'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(Toast), findsOneWidget);
    });

    testWidgets('showError displays error toast with custom message',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showError(
                    context, 'Custom error message', 'Close'),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Custom error message'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('showError displays error toast with title', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showError(
                  context,
                  'Something went wrong processing your request',
                  'Close',
                  title: 'Error',
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Something went wrong processing your request'),
          findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('showError displays no separate title when title is omitted',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showError(
                  context,
                  'Custom error message',
                  'Close',
                  // title intentionally omitted
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Custom error message'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(Toast), findsOneWidget);
    });

    testWidgets('showWarning displays warning toast with custom message',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showWarning(
                    context, 'Custom warning message', 'Close'),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Custom warning message'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('showWarning displays warning toast with title',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showWarning(
                  context,
                  'Please review your settings before continuing',
                  'Close',
                  title: 'Warning',
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Warning'), findsOneWidget);
      expect(find.text('Please review your settings before continuing'),
          findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
    });

    testWidgets('showWarning displays no separate title when title is omitted',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showWarning(
                  context,
                  'Custom warning message',
                  'Close',
                  // title intentionally omitted
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Custom warning message'), findsOneWidget);
      expect(find.text('Close'), findsOneWidget);
      expect(find.byType(Toast), findsOneWidget);
    });

    testWidgets('showCustomToast displays custom toast', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showCustomToast(
                  context,
                  (ctx) => Container(
                    padding: const EdgeInsets.all(16),
                    color: colors.iconBlue,
                    child: const Text('Custom Toast'),
                  ),
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Custom Toast'), findsOneWidget);
    });

    testWidgets('new toast replaces previous toast', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        CoreToast.showSuccess(context, 'First toast', 'Close'),
                    child: const Text('Show First'),
                  ),
                  ElevatedButton(
                    onPressed: () =>
                        CoreToast.showError(context, 'Second toast', 'Close'),
                    child: const Text('Show Second'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Show first toast
      await tester.tap(find.text('Show First'));
      await tester.pumpAndSettle();
      expect(find.text('First toast'), findsOneWidget);

      // Show second toast
      await tester.tap(find.text('Show Second'));
      await tester.pumpAndSettle();

      // First toast should be gone, second should be visible
      expect(find.text('First toast'), findsNothing);
      expect(find.text('Second toast'), findsOneWidget);
    });

    testWidgets('toast can be closed manually', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    CoreToast.showSuccess(context, 'Test toast', 'Close'),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Test toast'), findsOneWidget);

      // Close the toast
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      expect(find.text('Test toast'), findsNothing);
    });

    testWidgets('cleanup removes active toast', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    CoreToast.showSuccess(context, 'Test toast', 'Close'),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Show Toast'));
      await tester.pumpAndSettle();

      expect(find.text('Test toast'), findsOneWidget);

      // Clean up
      CoreToast.cleanup();
      await tester.pumpAndSettle();

      expect(find.text('Test toast'), findsNothing);
    });

    group('accessibility guidelines', () {
      testWidgets(
          'displayed toast close button meets tap target and label guidelines',
          (tester) async {
        await setupA11yTest(tester);

        for (final theme in kA11yTestThemes) {
          await tester.pumpWidget(
            buildTestApp(
              Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => CoreToast.showSuccess(
                    context,
                    'Request successful',
                    'Close',
                  ),
                  child: const Text('Show Toast'),
                ),
              ),
              theme: theme,
            ),
          );

          await tester.tap(find.text('Show Toast'));
          await tester.pumpAndSettle();

          expect(find.byType(Toast), findsOneWidget);

          await expectMeetsTapTargetAndLabelGuidelines(
            tester,
            find.byKey(const Key('toast_close_button')),
          );

          CoreToast.cleanup();
          await tester.pumpAndSettle();
        }
      });
    });
  });
}
