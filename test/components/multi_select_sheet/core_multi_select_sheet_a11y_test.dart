import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  const items = [
    CoreMultiSelectItem(id: 'roofing', label: 'Roofing'),
    CoreMultiSelectItem(id: 'wall', label: 'Wall'),
  ];

  CoreMultiSelectSheet buildSheet() {
    return CoreMultiSelectSheet(
      title: 'Tags',
      searchHint: 'Search by tag name',
      emptyLabel: 'No tags found.',
      initialSelectedIds: const {'roofing'},
      listData: const CoreMultiSelectListData(isLoading: false, items: items),
      onSearchQueryChanged: (_) {},
      onApply: (_) {},
    );
  }

  group('CoreMultiSelectSheet – accessibility', () {
    testWidgets('meets a11y guidelines for an item row', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => buildSheet(),
        find.text('Roofing'),
      );
    });

    testWidgets('meets a11y guidelines for the Clear all button', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => buildSheet(),
        find.text('Clear all'),
      );
    });

    testWidgets('meets a11y guidelines for the Apply button', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => buildSheet(),
        find.text('Apply'),
      );
    });
  });
}
