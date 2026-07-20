import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreDateFilterChip – accessibility', () {
    testWidgets('meets a11y guidelines for the inactive chip', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreDateFilterChip(
          selectedDateRange: null,
          label: 'Modified',
          semanticLabel: 'Filter by modification date',
          inactiveChipKey: const Key('inactive_chip'),
          onApply: (_) {},
          onClear: () {},
        ),
        find.byKey(const Key('inactive_chip')),
      );
    });

    testWidgets('meets a11y guidelines for the active clearable pill', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreDateFilterChip(
          selectedDateRange: DateRange(
            start: DateTime(2026, 1, 1),
            end: DateTime(2026, 1, 5),
          ),
          label: 'Modified',
          clearSemanticLabel: 'Clear date filter',
          activeChipKey: const Key('active_chip'),
          onApply: (_) {},
          onClear: () {},
        ),
        find.byKey(const Key('active_chip')),
      );
    });
  });
}
