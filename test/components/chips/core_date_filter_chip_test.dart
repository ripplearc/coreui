import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  Future<void> pumpChip(
    WidgetTester tester, {
    DateRange? selectedDateRange,
    ValueChanged<DateRange>? onApply,
    VoidCallback? onClear,
    String Function(DateTime date)? dateLabelBuilder,
  }) {
    return tester.pumpWidget(
      buildTestApp(
        CoreDateFilterChip(
          selectedDateRange: selectedDateRange,
          label: 'Modified',
          semanticLabel: 'Filter by modification date',
          clearSemanticLabel: 'Clear date filter',
          dateLabelBuilder: dateLabelBuilder,
          inactiveChipKey: const Key('date_filter_chip'),
          activeChipKey: const Key('active_date_filter_chip'),
          onApply: onApply ?? (_) {},
          onClear: onClear ?? () {},
        ),
        theme: CoreTheme.light(),
      ),
    );
  }

  group('CoreDateFilterChip', () {
    testWidgets(
      'shows the inactive chip with the label when no range is selected',
      (tester) async {
        await pumpChip(tester);

        expect(find.byKey(const Key('date_filter_chip')), findsOneWidget);
        expect(find.byKey(const Key('active_date_filter_chip')), findsNothing);
        expect(find.text('Modified'), findsOneWidget);
      },
    );

    testWidgets('opens CoreDateRangeSheet and applies the chosen range on tap',
        (
      tester,
    ) async {
      DateRange? applied;
      await pumpChip(tester, onApply: (range) => applied = range);

      await tester.tap(find.byKey(const Key('date_filter_chip')));
      await tester.pumpAndSettle();

      expect(find.text('Date range'), findsOneWidget);

      await tester.tap(find.byKey(const Key('date_range_apply_button')));
      await tester.pumpAndSettle();

      expect(applied, isNotNull);
    });

    testWidgets('does not call onApply when the sheet is cancelled', (
      tester,
    ) async {
      var applyCalled = false;
      await pumpChip(tester, onApply: (_) => applyCalled = true);

      await tester.tap(find.byKey(const Key('date_filter_chip')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('date_range_cancel_button')));
      await tester.pumpAndSettle();

      expect(applyCalled, isFalse);
    });

    testWidgets(
      'shows the active pill with the formatted range when a range is selected',
      (tester) async {
        await pumpChip(
          tester,
          selectedDateRange: DateRange(
            start: DateTime(2024, 3, 1),
            end: DateTime(2024, 3, 31),
          ),
        );

        expect(
            find.byKey(const Key('active_date_filter_chip')), findsOneWidget);
        expect(find.byKey(const Key('date_filter_chip')), findsNothing);
        expect(find.text('Mar 01, 2024 - Mar 31, 2024'), findsOneWidget);
      },
    );

    testWidgets('shows a single formatted date when start equals end', (
      tester,
    ) async {
      final today = DateTime(2024, 3, 1);
      await pumpChip(
        tester,
        selectedDateRange: DateRange(start: today, end: today),
      );

      expect(find.text('Mar 01, 2024'), findsOneWidget);
    });

    testWidgets('formats the active pill with a custom dateLabelBuilder', (
      tester,
    ) async {
      await pumpChip(
        tester,
        selectedDateRange: DateRange(
          start: DateTime(2024, 3, 1),
          end: DateTime(2024, 3, 31),
        ),
        dateLabelBuilder: (date) => '${date.day}/${date.month}/${date.year}',
      );

      expect(find.text('1/3/2024 - 31/3/2024'), findsOneWidget);
    });

    testWidgets('calls onClear when the active pill is tapped', (
      tester,
    ) async {
      var clearCalled = false;
      await pumpChip(
        tester,
        selectedDateRange: DateRange(
          start: DateTime(2024, 3, 1),
          end: DateTime(2024, 3, 31),
        ),
        onClear: () => clearCalled = true,
      );

      await tester.tap(find.byKey(const Key('active_date_filter_chip')));
      await tester.pumpAndSettle();

      expect(clearCalled, isTrue);
    });
  });
}
