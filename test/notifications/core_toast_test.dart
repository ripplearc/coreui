import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../utils/a11y_guidelines.dart';
import '../utils/test_harness.dart';

void _noop() {}

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

    group('showReceipt', () {
      Widget buildHost({
        VoidCallback onAction = _noop,
        VoidCallback? onSecondary,
        Duration? duration = const Duration(seconds: 5),
      }) {
        return MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => CoreToast.showReceipt(
                  context,
                  'Saved to history',
                  'Undo',
                  onAction,
                  highlight: 'Calc 60ft²',
                  secondaryLabel: onSecondary == null ? null : 'View',
                  onSecondary: onSecondary,
                  duration: duration,
                ),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        );
      }

      testWidgets('displays the receipt with its action', (tester) async {
        await tester.pumpWidget(buildHost());

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsOneWidget);
        expect(find.text('Undo'), findsOneWidget);
      });

      testWidgets('honours disableTimers like every other toast',
          (tester) async {
        await tester.pumpWidget(buildHost());

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 10));

        expect(find.byType(Toast), findsOneWidget);
      });

      testWidgets('cleanup after the receipt is shown leaves no pending '
          'removal', (tester) async {
        CoreToast.enableTimers();
        await tester.pumpWidget(buildHost());

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        CoreToast.cleanup();

        // No frame between the two: the entry is removed but the overlay has
        // not rebuilt, so its `mounted` still reads true. The widget's own
        // timer outlives cleanup(), and removing an entry twice throws.
        await tester.pump(const Duration(seconds: 6));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsNothing);
      });

      testWidgets('dismisses itself once the duration elapses',
          (tester) async {
        CoreToast.enableTimers();
        await tester.pumpWidget(buildHost());

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        expect(find.byType(Toast), findsOneWidget);

        await tester.pump(const Duration(seconds: 6));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsNothing);
      });

      testWidgets('taking the action removes the toast and reports once',
          (tester) async {
        CoreToast.enableTimers();
        var undone = 0;
        await tester.pumpWidget(buildHost(onAction: () => undone++));

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        await tester.tap(find.byKey(const Key('toast_action_button')));
        await tester.pumpAndSettle();

        expect(undone, 1);
        expect(find.byType(Toast), findsNothing);

        // The cancelled timer must not remove the entry a second time.
        await tester.pump(const Duration(seconds: 6));
      });

      testWidgets('taking the secondary action removes the toast once',
          (tester) async {
        CoreToast.enableTimers();
        var viewed = 0;
        var undone = 0;
        await tester.pumpWidget(
          buildHost(onAction: () => undone++, onSecondary: () => viewed++),
        );

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        expect(find.byKey(const Key('toast_secondary_button')), findsOneWidget);

        await tester.tap(find.byKey(const Key('toast_secondary_button')));
        await tester.pumpAndSettle();

        expect(viewed, 1);
        expect(find.byType(Toast), findsNothing);

        // The receipt is answered and gone: the cancelled timer must not
        // remove the entry a second time, and Undo is no longer reachable.
        await tester.pump(const Duration(seconds: 6));
        expect(undone, 0);
      });

      testWidgets('a second receipt replaces the first', (tester) async {
        CoreToast.enableTimers();
        await tester.pumpWidget(buildHost());

        // Both shown in one frame: the first entry is inserted but not yet
        // built, so it would be orphaned in the overlay if it were skipped.
        await tester.tap(find.text('Show Toast'));
        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsOneWidget);

        await tester.pump(const Duration(seconds: 6));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsNothing);
      });

      testWidgets('reads disableTimers when it is called, not when it builds',
          (tester) async {
        await tester.pumpWidget(buildHost());

        // setUp disabled timers. The builder runs on the next frame, so a
        // flag read there would see this enable rather than the state that
        // was in force when the caller asked for the toast.
        await tester.tap(find.text('Show Toast'));
        CoreToast.enableTimers();
        await tester.pumpAndSettle();

        await tester.pump(const Duration(seconds: 10));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsOneWidget);
      });

      testWidgets('the overlay starts no timer of its own', (tester) async {
        CoreToast.enableTimers();
        await tester.pumpWidget(
          buildHost(duration: const Duration(seconds: 10)),
        );

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();

        // Past the 3 s default showCustomToast would otherwise apply. Two
        // timers cannot be told apart once both have fired, so the gap
        // between them is where the claim is provable at all.
        await tester.pump(const Duration(seconds: 4));
        expect(find.byType(Toast), findsOneWidget);

        await tester.pump(const Duration(seconds: 7));
        await tester.pumpAndSettle();
        expect(find.byType(Toast), findsNothing);
      });

      testWidgets('answering a replaced receipt leaves the new one on screen',
          (tester) async {
        CoreToast.enableTimers();
        var shown = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => CoreToast.showReceipt(
                    context,
                    'Receipt ${++shown}',
                    'Undo',
                    _noop,
                  ),
                  child: const Text('Show Toast'),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();

        // Replace it, then answer the old one in the frame before the overlay
        // rebuilds without it. Its Undo carries the entry it was built with.
        await tester.tap(find.text('Show Toast'));
        await tester.tap(
          find.byKey(const Key('toast_action_button')),
          warnIfMissed: false,
        );
        await tester.pumpAndSettle();

        expect(find.text('Receipt 2'), findsOneWidget);

        await tester.pump(const Duration(seconds: 6));
        await tester.pumpAndSettle();
      });
    });

    group('overlay entry lifecycle', () {
      Widget buildHost() {
        return MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () =>
                    CoreToast.showError(context, 'Something went wrong', 'Close'),
                child: const Text('Show Toast'),
              ),
            ),
          ),
        );
      }

      testWidgets('a second toast shown in the same frame replaces the first',
          (tester) async {
        await tester.pumpWidget(buildHost());

        // Both in one frame: the first entry is inserted but has not built,
        // so skipping it for being unmounted orphans it in the overlay.
        await tester.tap(find.text('Show Toast'));
        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsOneWidget);
      });

      testWidgets('cleanup leaves no entry for the next toast to remove twice',
          (tester) async {
        await tester.pumpWidget(buildHost());

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        expect(find.byType(Toast), findsOneWidget);

        // Deliberately no pump in between: an entry stays mounted until the
        // overlay rebuilds without it, so a stale reference still looks
        // removable, and an OverlayEntry may only be removed once.
        CoreToast.cleanup();
        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsOneWidget);
      });

      testWidgets('the timer takes the toast off the screen', (tester) async {
        CoreToast.enableTimers();
        await tester.pumpWidget(buildHost());

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        expect(find.byType(Toast), findsOneWidget);

        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();

        expect(find.byType(Toast), findsNothing);
      });

      testWidgets('closing a replaced toast leaves the new one on screen',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => Column(
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          CoreToast.showError(context, 'First toast', 'Close'),
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

        await tester.tap(find.text('Show First'));
        await tester.pumpAndSettle();
        expect(find.text('First toast'), findsOneWidget);

        // One frame, two events: the second toast takes the overlay, and the
        // first — still on screen until the overlay rebuilds — has its Close
        // tapped. That tap carries the entry it was built with, not whichever
        // entry is current.
        await tester.tap(find.text('Show Second'));
        await tester.tap(find.text('Close'), warnIfMissed: false);
        await tester.pumpAndSettle();

        expect(find.text('Second toast'), findsOneWidget);
      });

      testWidgets('the error toast closes from its own button', (tester) async {
        await tester.pumpWidget(buildHost());

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        expect(find.text('Something went wrong'), findsOneWidget);

        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(find.text('Something went wrong'), findsNothing);
      });

      testWidgets('the warning toast closes from its own button',
          (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () =>
                      CoreToast.showWarning(context, 'Check the input', 'Close'),
                  child: const Text('Show Toast'),
                ),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Show Toast'));
        await tester.pumpAndSettle();
        expect(find.text('Check the input'), findsOneWidget);

        await tester.tap(find.text('Close'));
        await tester.pumpAndSettle();

        expect(find.text('Check the input'), findsNothing);
      });
    });
  });
}
