import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  testWidgets('the action meets tap target, label and contrast guidelines',
      (tester) async {
    await setupA11yTest(tester);
    await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
      tester,
      (theme) => CoreInlineErrorRow(
        message: 'Could not load your rates',
        actionLabel: 'Try again',
        onAction: () {},
      ),
      find.text('Try again'),
    );
  });

  testWidgets('the message meets the text contrast guideline', (tester) async {
    await setupA11yTest(tester);
    await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
      tester,
      (theme) => const CoreInlineErrorRow(message: 'Could not load your rates'),
      find.byType(CoreInlineErrorRow),
      checkTapTargetSize: false,
    );
  });

  testWidgets(
      'the disabled action stays a labelled 48 dp button; contrast is not '
      'checked for a disabled node', (tester) async {
    await setupA11yTest(tester);
    final handle = tester.ensureSemantics();
    try {
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreInlineErrorRow(
          message: 'Could not load your rates',
          actionLabel: 'Try again',
          onAction: () {},
          actionKey: const Key('retry'),
          isActionDisabled: true,
        ),
        find.text('Try again'),
        // textDisable on pageBackground measures 2.46:1 in light and 3.57:1
        // in dark, and Flutter's contrast guideline skips disabled nodes.
        checkTextContrast: false,
      );
      final zone = tester.getSize(find.byKey(const Key('retry')));
      expect(zone.width, greaterThanOrEqualTo(48));
      expect(zone.height, greaterThanOrEqualTo(48));
      expect(find.bySemanticsLabel('Try again'), findsOneWidget);
    } finally {
      handle.dispose();
    }
  });
}
