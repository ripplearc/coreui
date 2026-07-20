import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreDateRangeSheet – accessibility', () {
    testWidgets('meets a11y guidelines for the Today range option', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDateRangeSheet(),
        find.text('Today'),
      );
    });

    testWidgets('meets a11y guidelines for the Custom range option', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDateRangeSheet(),
        find.text('Custom range'),
      );
    });

    testWidgets('meets a11y guidelines for the Cancel button', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDateRangeSheet(),
        find.text('Cancel'),
      );
    });

    testWidgets('meets a11y guidelines for the Apply button', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDateRangeSheet(),
        find.text('Apply'),
      );
    });
  });
}
