import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreCheckRowItem – accessibility', () {
    testWidgets('unselected row meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCheckRowItem(
          title: 'John Doe',
          selected: false,
          onChanged: (_) {},
        ),
        find.byType(CoreCheckRowItem),
        // The single Semantics node on the row covers both label and tap
        // target; there is no separately-labeled tap target to check.
        checkLabeledTapTarget: false,
      );
    });

    testWidgets('selected row meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCheckRowItem(
          title: 'John Doe',
          selected: true,
          onChanged: (_) {},
        ),
        find.byType(CoreCheckRowItem),
        // The single Semantics node on the row covers both label and tap
        // target; there is no separately-labeled tap target to check.
        checkLabeledTapTarget: false,
      );
    });

    for (final selected in [false, true]) {
      testWidgets(
          'Check row ${selected ? 'selected' : 'unselected'} meets tap target '
          'and label guidelines', (tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => Padding(
            // The tap target guideline skips a node at the screen edge.
            padding: const EdgeInsets.all(16),
            child: CoreCheckRowItem.checkRow(
              title: 'John Doe',
              subtitle: 'john@acme.com',
              selected: selected,
              onChanged: (_) {},
            ),
          ),
          find.byType(CoreCheckRowItem),
          checkLabeledTapTarget: false,
        );
      });
    }

    testWidgets('disabled Check row text meets the contrast guideline',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCheckRowItem.checkRow(
          title: 'John Doe',
          selected: false,
          enabled: false,
          onChanged: (_) {},
        ),
        find.byType(CoreCheckRowItem),
        checkLabeledTapTarget: false,
      );
    });
  });
}
