import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

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

  // Flutter's tap target, labelled tap target and contrast guidelines skip a
  // disabled node, so the size and the label are asserted directly in each
  // theme. textDisable on pageBackground measures 2.46:1 in light and 3.57:1
  // in dark.
  for (final theme in kA11yTestThemes) {
    testWidgets(
        'the disabled action stays a labelled 48 dp button in '
        '${theme.brightness.name}', (tester) async {
      await setupA11yTest(tester);
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          buildTestApp(
            CoreInlineErrorRow(
              message: 'Could not load your rates',
              actionLabel: 'Try again',
              onAction: () {},
              actionKey: const Key('retry'),
              isActionDisabled: true,
            ),
            theme: theme,
          ),
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
}
