import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreCheckRowItem – accessibility', () {
    testWidgets('unselected row meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCheckRowItem(
          title: 'John Doe',
          selected: false,
          onChanged: (_) {},
        ),
        find.byType(CoreCheckRowItem),
        checkTapTargetSize: true,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('selected row meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: true,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCheckRowItem(
          title: 'John Doe',
          selected: true,
          onChanged: (_) {},
        ),
        find.byType(CoreCheckRowItem),
        checkTapTargetSize: true,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });
  });
}
