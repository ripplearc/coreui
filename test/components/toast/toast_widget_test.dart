import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

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
  });
}
