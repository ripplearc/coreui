import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    group('semantics', () {
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

      testWidgets('an untitled toast announces its description once',
          (WidgetTester tester) async {
        final handle = tester.ensureSemantics();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Toast.error(
                description: 'Your changes were not saved.',
                closeLabel: 'Dismiss',
              ),
            ),
          ),
        );

        final semantics = tester.getSemantics(find.byType(Toast));
        expect(
          'Your changes were not saved.'.allMatches(semantics.label).length,
          1,
          reason: 'the description reaches the screen reader through the text '
              'it labels, so the toast node must not repeat it',
        );
        expect(semantics.hint, isEmpty);
        handle.dispose();
      });
    });

    group('Receipt Toast', () {
      const description = 'Saved to history';
      const highlight = 'Calc 60ft²';
      final actionFinder = find.byKey(const Key('toast_action_button'));
      final messageFinder = find.byKey(const Key('toast_receipt_message'));
      final secondaryFinder = find.byKey(const Key('toast_secondary_button'));

      Widget buildReceipt({
        required VoidCallback onAction,
        VoidCallback? onSecondary,
        VoidCallback onClose = _noop,
        Duration? duration,
      }) {
        return MaterialApp(
          home: Scaffold(
            body: Toast.receipt(
              description: description,
              highlight: highlight,
              actionLabel: 'Undo',
              onAction: onAction,
              secondaryLabel: onSecondary == null ? null : 'View',
              onSecondary: onSecondary,
              onClose: onClose,
              duration: duration,
            ),
          ),
        );
      }

      testWidgets('renders the lead, the highlight and both actions',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          buildReceipt(onAction: () {}, onSecondary: () {}),
        );

        expect(find.textContaining(description, findRichText: true),
            findsOneWidget);
        expect(
            find.textContaining(highlight, findRichText: true), findsOneWidget);
        expect(actionFinder, findsOneWidget);
        expect(secondaryFinder, findsOneWidget);
      });

      testWidgets('carries no close button', (WidgetTester tester) async {
        await tester.pumpWidget(buildReceipt(onAction: () {}));

        expect(find.byKey(const Key('toast_close_button')), findsNothing);
      });

      testWidgets('omits the secondary action when it is not given',
          (WidgetTester tester) async {
        await tester.pumpWidget(buildReceipt(onAction: () {}));

        expect(secondaryFinder, findsNothing);
        expect(actionFinder, findsOneWidget);
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

      testWidgets('the secondary action reports and dismisses the toast',
          (WidgetTester tester) async {
        var closeCount = 0;
        var viewed = false;
        await tester.pumpWidget(
          buildReceipt(
            onAction: () {},
            onSecondary: () => viewed = true,
            onClose: () => closeCount++,
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.tap(secondaryFinder);
        await tester.pump();
        await tester.pump(const Duration(seconds: 6));

        expect(viewed, isTrue);
        expect(closeCount, 1);
      });

      testWidgets('answering with one action locks out the other',
          (WidgetTester tester) async {
        var undone = 0;
        var viewed = 0;
        await tester.pumpWidget(
          buildReceipt(
            onAction: () => undone++,
            onSecondary: () => viewed++,
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.tap(actionFinder);
        await tester.pump();
        await tester.tap(secondaryFinder);
        await tester.pump();

        expect(undone, 1);
        expect(viewed, 0);
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
                    onClose: _noop,
                    duration: null,
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.takeException(), isNull);

        // 360 less the surface's 16 dp padding and its hairline border
        // leaves 326 for the row; the icon and its two gaps take 48, so the
        // message and the action share 278. The action may take 60% of that
        // and ellipsises its own label, which leaves the message the other
        // 40% — 111 dp, where a bare intrinsic action left it 57.
        const shared = 326.0 - 48.0;
        expect(tester.getSize(actionFinder).width,
            lessThanOrEqualTo(shared * 0.6));
        expect(tester.getSize(messageFinder).width,
            greaterThanOrEqualTo(shared * 0.4));
      });

      // The width the message shares is the row less the icon column. In a
      // host narrower than that column it went negative, and a negative
      // maxWidth is a non-normalized BoxConstraints, which asserts.
      testWidgets('survives a host narrower than its own icon column',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 40,
                  child: Toast.receipt(
                    description: description,
                    actionLabel: 'Undo',
                    onAction: _noop,
                    onClose: _noop,
                  ),
                ),
              ),
            ),
          ),
        );

        // A 40 dp host cannot hold a 48 dp icon column, so an overflow is
        // the honest complaint. A negative cap asserted before reaching it,
        // and clamping that cap to zero only traded the assert for an Undo
        // nobody can tap.
        expect('${tester.takeException()}', isNot(contains('NOT NORMALIZED')));
        expect(tester.getSize(actionFinder).height, CoreSpacing.space12);
        expect(tester.getSize(actionFinder).width, greaterThan(0));
      });

      testWidgets('a short label is not padded out to the cap',
          (WidgetTester tester) async {
        await tester.pumpWidget(buildReceipt(onAction: _noop));

        // The cap is a ceiling, not a width: English "Undo" stays intrinsic.
        expect(tester.getSize(actionFinder).width, lessThan(120));
      });

      testWidgets('fits a narrow screen at a large text scale with both '
          'actions', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 375,
                    child: Toast.receipt(
                      description: description,
                      highlight: highlight,
                      actionLabel: 'Undo',
                      onAction: () {},
                      secondaryLabel: 'View',
                      onSecondary: _noop,
                      onClose: _noop,
                      duration: null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // Two actions are what pushes the short English labels past the
        // width; one on its own still fits at this scale.
        expect(tester.takeException(), isNull);
      });

      testWidgets('fits a narrow screen with both labels translated',
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
                    secondaryLabel: 'Anzeigen',
                    onSecondary: _noop,
                    onClose: _noop,
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

      // androidTapTargetGuideline does not fire on CoreButton's semantics
      // node, so the height is asserted directly rather than assumed covered.
      testWidgets('the action stands a full tap target tall',
          (WidgetTester tester) async {
        await tester.pumpWidget(buildReceipt(onAction: () {}));

        expect(tester.getSize(actionFinder).height, CoreSpacing.space12);
      });

      // The size above is the layout box. These tap that box near its edges,
      // so a CoreButton that later stops reacting to them cannot pass unseen.
      testWidgets('the action answers a tap just inside its top and bottom',
          (WidgetTester tester) async {
        const insetFromTheEdge = 4.0;

        for (final atTheTop in const [true, false]) {
          var taps = 0;
          // A receipt answers at most once, so each edge needs its own state.
          await tester.pumpWidget(KeyedSubtree(
            key: ValueKey(atTheTop),
            child: buildReceipt(onAction: () => taps++),
          ));

          final box = tester.getRect(actionFinder);
          await tester.tapAt(Offset(
            box.center.dx,
            atTheTop
                ? box.top + insetFromTheEdge
                : box.bottom - insetFromTheEdge,
          ));
          await tester.pump();

          expect(taps, 1,
              reason: atTheTop
                  ? 'the top edge of the tap target is dead'
                  : 'the bottom edge of the tap target is dead');
        }
      });

      testWidgets('the secondary action stands a full tap target tall',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          buildReceipt(onAction: () {}, onSecondary: () {}),
        );

        expect(tester.getSize(secondaryFinder).height, CoreSpacing.space12);
      });

      testWidgets('the secondary action is announced once',
          (WidgetTester tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpWidget(
          buildReceipt(onAction: _noop, onSecondary: _noop),
        );

        // The InkWell's own node merges with the label below it, so a label
        // set here as well as on the Text announces "View View".
        final semantics = tester.getSemantics(secondaryFinder);
        expect(semantics.label, 'View');
        expect(semantics.flagsCollection.isButton, isTrue);
        handle.dispose();
      });

      testWidgets('the secondary action answers a tap at either edge',
          (WidgetTester tester) async {
        var viewed = 0;
        await tester.pumpWidget(
          buildReceipt(onAction: _noop, onSecondary: () => viewed++),
        );

        // The 48 dp box is the whole target, not just the text band inside
        // it: a thumb that lands a little high or low still counts.
        final box = tester.getRect(secondaryFinder);
        await tester.tapAt(Offset(box.center.dx, box.top + 4));
        await tester.pump();

        expect(viewed, 1);
      });

      testWidgets('a tap at the bottom edge answers it too',
          (WidgetTester tester) async {
        var viewed = 0;
        await tester.pumpWidget(
          buildReceipt(onAction: _noop, onSecondary: () => viewed++),
        );

        final box = tester.getRect(secondaryFinder);
        await tester.tapAt(Offset(box.center.dx, box.bottom - 4));
        await tester.pump();

        expect(viewed, 1);
      });

      testWidgets('the secondary action takes keyboard focus',
          (WidgetTester tester) async {
        var viewed = 0;
        await tester.pumpWidget(
          buildReceipt(onAction: _noop, onSecondary: () => viewed++),
        );

        // A GestureDetector cannot be reached by keyboard, D-pad or switch
        // at all, which is why this control is an InkWell.
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();

        expect(viewed, 1);
      });

      testWidgets('a label with no action is rejected',
          (WidgetTester tester) async {
        expect(
          () => Toast.receipt(
            description: description,
            actionLabel: 'Undo',
            onAction: _noop,
            onClose: _noop,
            secondaryLabel: 'View',
          ),
          throwsAssertionError,
        );
      });

      testWidgets('an action with no label is rejected',
          (WidgetTester tester) async {
        expect(
          () => Toast.receipt(
            description: description,
            actionLabel: 'Undo',
            onAction: _noop,
            onClose: _noop,
            onSecondary: _noop,
          ),
          throwsAssertionError,
        );
      });

      testWidgets('View first locks out Undo as well',
          (WidgetTester tester) async {
        var undone = 0;
        var viewed = 0;
        await tester.pumpWidget(
          buildReceipt(
            onAction: () => undone++,
            onSecondary: () => viewed++,
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.tap(secondaryFinder);
        await tester.pump();
        await tester.tap(actionFinder);
        await tester.pump();

        expect(viewed, 1);
        expect(undone, 0);
      });

      testWidgets('reads the lead and the highlight as one label',
          (WidgetTester tester) async {
        await setupA11yTest(tester);
        await tester.pumpWidget(
          buildReceipt(onAction: () {}),
        );
        await tester.pumpAndSettle();

        final semantics = tester.getSemantics(find.byType(Toast));
        // Exact, not contains: the message used to be announced twice, once
        // from the container's own label and once from the text it wraps,
        // and a contains() assertion reads the same either way.
        expect(semantics.label, '$description · $highlight');
      });

      // Voice control taps the centre of a node. Were the action folded into
      // the message's node, that centre would land on the text.
      testWidgets('the action is a node of its own, apart from the message',
          (WidgetTester tester) async {
        await setupA11yTest(tester);
        await tester.pumpWidget(buildReceipt(onAction: () {}));
        await tester.pumpAndSettle();

        final action = tester.getSemantics(actionFinder);
        expect(action.label, 'Undo');
        expect(action.rect.size, tester.getSize(actionFinder));
      });

      testWidgets('reports the action before the dismissal',
          (WidgetTester tester) async {
        final calls = <String>[];
        await tester.pumpWidget(
          buildReceipt(
            onAction: () => calls.add('action'),
            onClose: () => calls.add('close'),
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.tap(actionFinder);
        await tester.pump();

        // CoreToast.showReceipt removes the overlay entry in onClose, so an
        // action reported after it would fire into a torn-down host.
        expect(calls, ['action', 'close']);
      });

      testWidgets('dismisses even when the action throws',
          (WidgetTester tester) async {
        var closeCount = 0;
        await tester.pumpWidget(
          buildReceipt(
            onAction: () => throw StateError('the undo failed'),
            onClose: () => closeCount++,
            duration: const Duration(seconds: 5),
          ),
        );

        await tester.tap(actionFinder);
        await tester.pump();

        // Otherwise the receipt stays up with an Undo that is already spent.
        expect(tester.takeException(), isA<StateError>());
        expect(closeCount, 1);
      });

      testWidgets('a receipt taken off the tree never dismisses late',
          (WidgetTester tester) async {
        var closeCount = 0;
        await tester.pumpWidget(
          buildReceipt(
            onAction: _noop,
            onClose: () => closeCount++,
            duration: const Duration(seconds: 5),
          ),
        );

        // CoreToast replaces a toast by removing its entry, which disposes
        // this state. A timer that outlives it removes the replacement.
        await tester.pumpWidget(
          const MaterialApp(home: Scaffold(body: SizedBox.shrink())),
        );
        await tester.pump(const Duration(seconds: 10));

        expect(closeCount, 0);
      });

      testWidgets('a new receipt in the same slot re-arms its action',
          (WidgetTester tester) async {
        var secondActions = 0;
        var closeCount = 0;

        Widget host(String message, VoidCallback onAction) => MaterialApp(
              home: Scaffold(
                body: Toast.receipt(
                  description: message,
                  actionLabel: 'Undo',
                  onAction: onAction,
                  onClose: () => closeCount++,
                  duration: const Duration(seconds: 5),
                ),
              ),
            );

        await tester.pumpWidget(host('First', _noop));
        await tester.pump(const Duration(seconds: 6));
        expect(closeCount, 1);

        await tester.pumpWidget(host('Second', () => secondActions++));
        await tester.tap(actionFinder);
        await tester.pump();

        expect(secondActions, 1);
        expect(closeCount, 2);
      });

      testWidgets('a new receipt in the same slot starts its own window',
          (WidgetTester tester) async {
        var closeCount = 0;

        Widget host(String message) => MaterialApp(
              home: Scaffold(
                body: Toast.receipt(
                  description: message,
                  actionLabel: 'Undo',
                  onAction: _noop,
                  onClose: () => closeCount++,
                  duration: const Duration(seconds: 5),
                ),
              ),
            );

        await tester.pumpWidget(host('First'));
        await tester.pump(const Duration(seconds: 3));

        await tester.pumpWidget(host('Second'));
        // The first receipt's timer had 2 s left. The second one must not
        // inherit it.
        await tester.pump(const Duration(seconds: 3));
        expect(closeCount, 0);

        await tester.pump(const Duration(seconds: 3));
        expect(closeCount, 1);
      });

      testWidgets('a screen reader keeps the window open',
          (WidgetTester tester) async {
        var closed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(accessibleNavigation: true),
                child: Scaffold(
                  body: Toast.receipt(
                    description: description,
                    actionLabel: 'Undo',
                    onAction: _noop,
                    onClose: () => closed = true,
                    duration: const Duration(seconds: 5),
                  ),
                ),
              ),
            ),
          ),
        );

        // The receipt carries no close button, so the timer is its only exit.
        // A user still hunting for Undo must not lose it mid-search.
        await tester.pump(const Duration(minutes: 1));

        expect(closed, isFalse);
      });

      testWidgets('an older variant still measures inside IntrinsicWidth',
          (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: IntrinsicWidth(
                  child: Toast.success(
                    description: 'Your changes have been saved.',
                    closeLabel: 'Close',
                    onClose: _noop,
                  ),
                ),
              ),
            ),
          ),
        );

        // A LayoutBuilder cannot report an intrinsic width, and AlertDialog
        // asks its content for one.
        expect(tester.takeException(), isNull);
      });
    });
  });
}

void _noop() {}
