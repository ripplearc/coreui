import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void _noop() {}

void main() {
  group('Toast - accessibility', () {
    const description = 'Saved to history';
    const highlight = 'Calc 60ft²';
    final actionFinder = find.byKey(const Key('toast_action_button'));
    final secondaryFinder = find.byKey(const Key('toast_secondary_button'));

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

    testWidgets('the action meets accessibility guidelines',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => Toast.receipt(
          description: description,
          highlight: highlight,
          actionLabel: 'Undo',
          onAction: _noop,
          onClose: _noop,
          duration: null,
        ),
        actionFinder,
      );
    });

    testWidgets('the secondary action meets accessibility guidelines',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => Toast.receipt(
          description: description,
          highlight: highlight,
          actionLabel: 'Undo',
          onAction: () {},
          secondaryLabel: 'View',
          onSecondary: _noop,
          onClose: _noop,
          duration: null,
        ),
        secondaryFinder,
      );
    });
  });
}
