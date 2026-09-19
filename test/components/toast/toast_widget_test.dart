import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('Toast Widget Tests', () {
    final closeButtonFinder = find.byKey(const Key('toast_close_button'));
    final errorTitleFinder = find.text('Error Title');
    final errorDescriptionFinder = find.text('Error Description');
    final warningTitleFinder = find.text('Warning Title');
    final warningDescriptionFinder = find.text('Warning Description');
    final infoTitleFinder = find.text('Info Title');
    final infoDescriptionFinder = find.text('Info Description');
    final successTitleFinder = find.text('Success Title');
    final successDescriptionFinder = find.text('Success Description');
    final closeLabelFinder = find.text('Close');
    final closableToastTitleFinder = find.text('Closable Toast');
    final closableToastDescriptionFinder =
        find.text('This toast can be closed');

    testWidgets('renders Error Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.error(
              title: 'Error Title',
              description: 'Error Description',
              closeLabel: 'Close',
            ),
          ),
        ),
      );

      expect(errorTitleFinder, findsOneWidget);
      expect(errorDescriptionFinder, findsOneWidget);
      expect(closeLabelFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);
    });

    testWidgets('renders Warning Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.warning(
              title: 'Warning Title',
              description: 'Warning Description',
              closeLabel: 'Close',
            ),
          ),
        ),
      );

      expect(warningTitleFinder, findsOneWidget);
      expect(warningDescriptionFinder, findsOneWidget);
      expect(closeLabelFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);
    });

    testWidgets('renders Info Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.info(
              title: 'Info Title',
              description: 'Info Description',
              closeLabel: 'Close',
            ),
          ),
        ),
      );

      expect(infoTitleFinder, findsOneWidget);
      expect(infoDescriptionFinder, findsOneWidget);
      expect(closeLabelFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);
    });

    testWidgets('renders Success Toast correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.success(
              title: 'Success Title',
              description: 'Success Description',
              closeLabel: 'Close',
            ),
          ),
        ),
      );

      expect(successTitleFinder, findsOneWidget);
      expect(successDescriptionFinder, findsOneWidget);
      expect(closeLabelFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);
    });

    testWidgets('onClose callback is triggered when close button is tapped',
        (WidgetTester tester) async {
      bool wasClosed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Toast.success(
              title: 'Closable Toast',
              description: 'This toast can be closed',
              closeLabel: 'Close',
              onClose: () {
                wasClosed = true;
              },
            ),
          ),
        ),
      );

      // The close button should exist
      expect(closeLabelFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);
      expect(closableToastTitleFinder, findsOneWidget);
      expect(closableToastDescriptionFinder, findsOneWidget);

      // Tap the close button
      await tester.tap(closeButtonFinder);
      await tester.pump(); // allow state changes to propagate

      // Verify that the callback was triggered
      expect(wasClosed, isTrue);
    });

    group('accessibility guidelines', () {
      testWidgets('error toast meets accessibility guidelines',
          (WidgetTester tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => Toast.error(
            description: 'Something went wrong',
            closeLabel: 'Close',
          ),
          find.byKey(const Key('toast_close_button')),
        );

        await tester.pumpAndSettle();
        final semantics = tester.getSemantics(find.byType(Toast));
        expect(semantics.label, contains('Something went wrong'));
      });

      testWidgets('warning toast meets accessibility guidelines',
          (WidgetTester tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => Toast.warning(
            description: 'Please review your settings',
            closeLabel: 'Close',
          ),
          find.byKey(const Key('toast_close_button')),
        );

        await tester.pumpAndSettle();
        final semantics = tester.getSemantics(find.byType(Toast));
        expect(semantics.label, contains('Please review your settings'));
      });

      testWidgets('info toast meets accessibility guidelines',
          (WidgetTester tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => Toast.info(
            description: 'New updates are available',
            closeLabel: 'Dismiss',
          ),
          find.byKey(const Key('toast_close_button')),
        );

        await tester.pumpAndSettle();
        final semantics = tester.getSemantics(find.byType(Toast));
        expect(semantics.label, contains('New updates are available'));
      });

      testWidgets('toast with title exposes title as label and description as hint',
          (WidgetTester tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => Toast.success(
            title: 'Saved',
            description: 'Your changes have been saved.',
            closeLabel: 'Dismiss',
          ),
          find.byKey(const Key('toast_close_button')),
        );

        await tester.pumpAndSettle();
        final semantics = tester.getSemantics(find.byType(Toast));
        expect(semantics.label, contains('Saved'));
        expect(semantics.label, contains('Your changes have been saved.'));
        expect(semantics.hint, contains('Your changes have been saved.'));
      });
    });

    group('Receipt Toast', () {
      const description = 'Saved to history';
      const highlight = 'Calc 60ft²';
      final actionFinder = find.byKey(const Key('toast_action_button'));

      Widget buildReceipt({
        required VoidCallback onAction,
        VoidCallback? onClose,
        Duration? duration,
      }) {
        return MaterialApp(
          home: Scaffold(
            body: Toast.receipt(
              description: description,
              highlight: highlight,
              actionLabel: 'Undo',
              onAction: onAction,
              onClose: onClose,
              duration: duration,
            ),
          ),
        );
      }

      testWidgets('renders the lead, the highlight and the action',
          (WidgetTester tester) async {
        await tester.pumpWidget(buildReceipt(onAction: () {}));

        expect(find.textContaining(description, findRichText: true),
            findsOneWidget);
        expect(
            find.textContaining(highlight, findRichText: true), findsOneWidget);
        expect(actionFinder, findsOneWidget);
      });

      testWidgets('carries no close button', (WidgetTester tester) async {
        await tester.pumpWidget(buildReceipt(onAction: () {}));

        expect(find.byKey(const Key('toast_close_button')), findsNothing);
      });

      testWidgets('fires the action at most once',
          (WidgetTester tester) async {
        var actionCount = 0;
        await tester.pumpWidget(buildReceipt(onAction: () => actionCount++));

        await tester.tap(actionFinder);
        await tester.pump();
        await tester.tap(actionFinder);
        await tester.pump();

        expect(actionCount, 1);
      });

      testWidgets('dismisses itself once the duration elapses',
          (WidgetTester tester) async {
        var closed = false;
        await tester.pumpWidget(
          buildReceipt(
            onAction: () {},
            onClose: () => closed = true,
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.pump(const Duration(seconds: 4));
        expect(closed, isFalse);

        await tester.pump(const Duration(seconds: 1));
        expect(closed, isTrue);
      });

      testWidgets('taking the action dismisses the toast exactly once',
          (WidgetTester tester) async {
        var closeCount = 0;
        await tester.pumpWidget(
          buildReceipt(
            onAction: () {},
            onClose: () => closeCount++,
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.tap(actionFinder);
        await tester.pump();
        expect(closeCount, 1);

        // The cancelled timer must not ask for a second dismissal.
        await tester.pump(const Duration(seconds: 6));
        expect(closeCount, 1);
      });

      testWidgets('an auto-dismissed receipt stays answered',
          (WidgetTester tester) async {
        var actionCount = 0;
        var closeCount = 0;
        await tester.pumpWidget(
          buildReceipt(
            onAction: () => actionCount++,
            onClose: () => closeCount++,
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.pump(const Duration(seconds: 6));
        expect(closeCount, 1);

        // The host keeps the widget up after onClose in this fixture, so the
        // button is still tappable. A receipt that already answered itself
        // must not undo a session the user never asked to undo.
        await tester.tap(actionFinder);
        await tester.pump();

        expect(actionCount, 0);
        expect(closeCount, 1);
      });

      testWidgets('keeps its action alive when nobody can dismiss it',
          (WidgetTester tester) async {
        var actionCount = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Toast.receipt(
                description: description,
                actionLabel: 'Undo',
                onAction: () => actionCount++,
              ),
            ),
          ),
        );

        // The default duration with no onClose: the widget cannot take
        // itself off the screen, so it must not answer itself either and
        // leave a live-looking toast with a dead Undo.
        await tester.pump(const Duration(seconds: 6));
        await tester.tap(actionFinder);
        await tester.pump();

        expect(actionCount, 1);
      });

      testWidgets('fits a narrow screen with a long translated label',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 360,
                  child: Toast.receipt(
                    description: 'Im Verlauf gespeichert',
                    highlight: 'Berechnung 60ft²',
                    actionLabel: 'Rückgängig machen',
                    onAction: () {},
                    duration: null,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);
      });

      testWidgets('announces itself as a live region',
          (WidgetTester tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(buildReceipt(onAction: () {}));

        // A timed, actionable toast that is never announced closes its own
        // Undo window before a screen-reader user knows it opened.
        final semantics = tester.getSemantics(find.byType(Toast));
        expect(semantics.flagsCollection.isLiveRegion, isTrue);
        handle.dispose();
      });

      testWidgets('stays on screen when no duration is given',
          (WidgetTester tester) async {
        var closed = false;
        await tester.pumpWidget(
          buildReceipt(onAction: () {}, onClose: () => closed = true),
        );

        await tester.pump(const Duration(minutes: 1));

        expect(closed, isFalse);
      });

      testWidgets('the action meets accessibility guidelines',
          (WidgetTester tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => Toast.receipt(
            description: description,
            highlight: highlight,
            actionLabel: 'Undo',
            onAction: () {},
            duration: null,
          ),
          actionFinder,
        );
      });

      // androidTapTargetGuideline does not fire on CoreButton's semantics
      // node, so the height is asserted directly rather than assumed covered.
      testWidgets('the action stands a full tap target tall',
          (WidgetTester tester) async {
        await tester.pumpWidget(buildReceipt(onAction: () {}));

        expect(tester.getSize(actionFinder).height, CoreSpacing.space12);
      });

      testWidgets('reads the lead and the highlight as one label',
          (WidgetTester tester) async {
        await setupA11yTest(tester);
        await tester.pumpWidget(
          buildReceipt(onAction: () {}),
        );
        await tester.pumpAndSettle();

        final semantics = tester.getSemantics(find.byType(Toast));
        expect(semantics.label, contains(description));
        expect(semantics.label, contains(highlight));
      });
    });
  });
}
