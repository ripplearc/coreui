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

    testWidgets('announces the range and the clear × as separate buttons', (
      tester,
    ) async {
      const rangeLabel = 'Jan 01, 2026 - Jan 05, 2026';
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Material(
            child: CoreDateFilterChip(
              selectedDateRange: DateRange(
                start: DateTime(2026, 1, 1),
                end: DateTime(2026, 1, 5),
              ),
              label: 'Modified',
              clearSemanticLabel: 'Clear date filter',
              onApply: (_) {},
              onClear: () {},
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel(rangeLabel)),
        matchesSemantics(
          label: rangeLabel,
          hint: 'Opens the date range sheet',
          isButton: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );
      expect(
        tester.getSemantics(find.byKey(CoreDateFilterChip.clearButtonKey)),
        matchesSemantics(
          label: 'Clear date filter',
          isButton: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );
      handle.dispose();
    });
  });
}
