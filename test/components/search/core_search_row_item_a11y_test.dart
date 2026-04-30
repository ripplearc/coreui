import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreSearchRowItem – accessibility', () {
    testWidgets('recentSearch meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.recentSearch(
            text: '#Carpentry',
            onTap: () {},
            onTrailingTap: () {},
            trailingSemanticLabel: 'Fill search with #Carpentry',
          ),
          theme: CoreTheme.light(),
        ),
      );

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreSearchRowItem.recentSearch(
          text: '#Carpentry',
          onTap: () {},
          onTrailingTap: () {},
          trailingSemanticLabel: 'Fill search with #Carpentry',
        ),
        find.byType(CoreSearchRowItem),
        checkTapTargetSize: true,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('suggestion meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchRowItem.suggestion(
            text: '#Carpentry',
            query: 'Car',
            onTap: () {},
            onTrailingTap: () {},
            trailingSemanticLabel: 'Fill search with #Carpentry',
          ),
          theme: CoreTheme.light(),
        ),
      );

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreSearchRowItem.suggestion(
          text: '#Carpentry',
          query: 'Car',
          onTap: () {},
          onTrailingTap: () {},
          trailingSemanticLabel: 'Fill search with #Carpentry',
        ),
        find.byType(CoreSearchRowItem),
        checkTapTargetSize: true,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });
  });
}
