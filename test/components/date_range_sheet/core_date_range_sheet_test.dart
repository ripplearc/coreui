import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Captures the result resolved by [CoreDateRangeSheet.show], since the
/// sheet is opened and closed across separate `pump` calls in a test body.
class _ResultHolder {
  DateRange? value;
  bool resolved = false;
}

void main() {
  // Fixed mid-month "today" so range math and the custom-picker flows are
  // deterministic regardless of the real clock, timezone, or DST.
  final fixedToday = DateTime(2026, 3, 15);

  Future<_ResultHolder> pumpAndShow(
    WidgetTester tester, {
    DateRange? initialRange,
    DateTime? today,
  }) async {
    final holder = _ResultHolder();
    await tester.pumpWidget(
      MaterialApp(
        theme: CoreTheme.light(),
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                holder.value = await CoreDateRangeSheet.show(
                  context: context,
                  initialRange: initialRange,
                  today: today,
                );
                holder.resolved = true;
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return holder;
  }

  group('CoreDateRangeSheet', () {
    testWidgets('shows the title and all predefined range options', (
      tester,
    ) async {
      await pumpAndShow(tester);

      expect(find.text('Date range'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Last 7 days'), findsOneWidget);
      expect(find.text('Last 30 days'), findsOneWidget);
      expect(find.text('This month'), findsOneWidget);
      expect(find.text('Custom range'), findsOneWidget);
    });

    testWidgets('defaults to Today selected when no initial range is given', (
      tester,
    ) async {
      await pumpAndShow(tester);

      final todayTile = tester.widget<RadioListTile<Object?>>(
        find.byKey(const Key('date_range_option_today')),
      );
      expect(todayTile.groupValue, todayTile.value);
    });

    testWidgets('applying Today resolves with start == end == today', (
      tester,
    ) async {
      final holder = await pumpAndShow(tester, today: fixedToday);

      await tester.tap(find.byKey(const Key('date_range_apply_button')));
      await tester.pumpAndSettle();

      expect(holder.resolved, isTrue);
      expect(holder.value!.start, fixedToday);
      expect(holder.value!.end, fixedToday);
    });

    testWidgets('selecting Last 7 days resolves with a 7-day span', (
      tester,
    ) async {
      final holder = await pumpAndShow(tester, today: fixedToday);

      await tester.tap(find.byKey(const Key('date_range_option_last7Days')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('date_range_apply_button')));
      await tester.pumpAndSettle();

      expect(holder.resolved, isTrue);
      expect(holder.value!.start, DateTime(2026, 3, 9));
      expect(holder.value!.end, fixedToday);
    });

    testWidgets('selecting Last 30 days resolves with a 30-day span', (
      tester,
    ) async {
      final holder = await pumpAndShow(tester, today: fixedToday);

      await tester.tap(find.byKey(const Key('date_range_option_last30Days')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('date_range_apply_button')));
      await tester.pumpAndSettle();

      expect(holder.resolved, isTrue);
      expect(holder.value!.start, DateTime(2026, 2, 14));
      expect(holder.value!.end, fixedToday);
    });

    testWidgets('selecting This month resolves with start on the 1st', (
      tester,
    ) async {
      final holder = await pumpAndShow(tester, today: fixedToday);

      await tester.tap(find.byKey(const Key('date_range_option_thisMonth')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('date_range_apply_button')));
      await tester.pumpAndSettle();

      expect(holder.resolved, isTrue);
      expect(holder.value!.start, DateTime(2026, 3, 1));
      expect(holder.value!.end, fixedToday);
    });

    testWidgets(
      'selecting Custom range opens the date picker twice and resolves with the chosen span',
      (tester) async {
        final holder = await pumpAndShow(tester, today: fixedToday);

        await tester.tap(find.byKey(const Key('date_range_option_custom')));
        await tester.pumpAndSettle();

        // Navigate to the previous month (February 2026) so days 12 and 15 are
        // not disabled by the lastDate: today constraint.
        await tester.tap(find.bySemanticsLabel('Previous month'));
        await tester.pump();

        // Start date picker: tap day 12 then confirm.
        await tester.tap(find.text('12').first);
        await tester.pump();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // End date picker opens showing the same previous month (initialDate = start).
        // Day 15 is enabled: it falls between firstDate (12th) and lastDate (today).
        await tester.tap(find.text('15').first);
        await tester.pump();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        final customTile = tester.widget<RadioListTile<Object?>>(
          find.byKey(const Key('date_range_option_custom')),
        );
        expect(customTile.groupValue, customTile.value);

        await tester.tap(find.byKey(const Key('date_range_apply_button')));
        await tester.pumpAndSettle();

        expect(holder.resolved, isTrue);
        expect(holder.value!.start, DateTime(2026, 2, 12));
        expect(holder.value!.end, DateTime(2026, 2, 15));
      },
    );

    testWidgets(
      'cancelling the start date picker leaves the previous selection unchanged',
      (tester) async {
        await pumpAndShow(tester);

        await tester.tap(find.byKey(const Key('date_range_option_custom')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Cancel').last);
        await tester.pumpAndSettle();

        final todayTile = tester.widget<RadioListTile<Object?>>(
          find.byKey(const Key('date_range_option_today')),
        );
        expect(todayTile.groupValue, todayTile.value);
      },
    );

    testWidgets('Cancel resolves with null and does not apply a selection', (
      tester,
    ) async {
      final holder = await pumpAndShow(tester);

      await tester.tap(find.byKey(const Key('date_range_option_last7Days')));
      await tester.pump();
      await tester.tap(find.byKey(const Key('date_range_cancel_button')));
      await tester.pumpAndSettle();

      expect(holder.resolved, isTrue);
      expect(holder.value, isNull);
    });

    testWidgets('pre-selects Custom range when reopened with an initial range',
        (
      tester,
    ) async {
      final initial = DateRange(
        start: DateTime(2026, 1, 1),
        end: DateTime(2026, 1, 5),
      );

      await pumpAndShow(tester, initialRange: initial);

      final customTile = tester.widget<RadioListTile<Object?>>(
        find.byKey(const Key('date_range_option_custom')),
      );
      expect(customTile.groupValue, customTile.value);
    });

    testWidgets(
      'reapplying without changing the selection keeps the initial custom range',
      (tester) async {
        final initial = DateRange(
          start: DateTime(2026, 1, 1),
          end: DateTime(2026, 1, 5),
        );

        final holder = await pumpAndShow(tester, initialRange: initial);

        await tester.tap(find.byKey(const Key('date_range_apply_button')));
        await tester.pumpAndSettle();

        expect(holder.resolved, isTrue);
        expect(holder.value, initial);
      },
    );

    testWidgets(
      'cancelling Custom keeps Today selected and applying resolves with today, '
      'never a silent custom fallback',
      (tester) async {
        final holder = await pumpAndShow(tester, today: fixedToday);

        // Select Custom then cancel the start picker. The selection falls back to
        // Today (Custom is only committed once both dates are picked), so the
        // _onApply guard never lets an unpicked Custom resolve as today→today.
        await tester.tap(find.byKey(const Key('date_range_option_custom')));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel').last);
        await tester.pumpAndSettle();

        final todayTile = tester.widget<RadioListTile<Object?>>(
          find.byKey(const Key('date_range_option_today')),
        );
        expect(todayTile.groupValue, todayTile.value);

        await tester.tap(find.byKey(const Key('date_range_apply_button')));
        await tester.pumpAndSettle();

        expect(holder.resolved, isTrue);
        expect(holder.value!.start, fixedToday);
        expect(holder.value!.end, fixedToday);
      },
    );

    testWidgets(
      're-tapping Custom with a complete range does not reopen the pickers',
      (tester) async {
        final initial = DateRange(
          start: DateTime(2026, 1, 1),
          end: DateTime(2026, 1, 5),
        );

        final holder = await pumpAndShow(tester, initialRange: initial);

        // Custom is already selected with a complete initial range; re-tapping it
        // must keep the range without opening any CoreDatePicker dialog.
        await tester.tap(find.byKey(const Key('date_range_option_custom')));
        await tester.pumpAndSettle();

        // No picker dialog opened (no OK/Cancel buttons present), and applying
        // still resolves with the untouched initial range.
        expect(find.text('OK'), findsNothing);

        await tester.tap(find.byKey(const Key('date_range_apply_button')));
        await tester.pumpAndSettle();

        expect(holder.resolved, isTrue);
        expect(holder.value, initial);
      },
    );

    testWidgets(
      're-picking a start after the old end clamps the end picker seed, '
      'never resolving an inverted range',
      (tester) async {
        final initial = DateRange(
          start: DateTime(2026, 2, 1),
          end: DateTime(2026, 2, 3),
        );
        final holder = await pumpAndShow(
          tester,
          initialRange: initial,
          today: fixedToday,
        );

        // Custom is pre-selected with a complete range; switch away and back to
        // force the pickers open for a re-pick.
        await tester.tap(find.byKey(const Key('date_range_option_today')));
        await tester.pump();
        await tester.tap(find.byKey(const Key('date_range_option_custom')));
        await tester.pumpAndSettle();

        // Start picker opens on February (initialDate = old start, Feb 1);
        // pick day 20 — later than the old end (Feb 3).
        await tester.tap(find.text('20').first);
        await tester.pump();
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // The end picker seed is clamped to the new start (Feb 20), not the
        // stale Feb 3; confirming immediately must not produce end < start.
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        await tester.tap(find.byKey(const Key('date_range_apply_button')));
        await tester.pumpAndSettle();

        expect(holder.resolved, isTrue);
        expect(holder.value!.start, DateTime(2026, 2, 20));
        expect(holder.value!.end, DateTime(2026, 2, 20));
      },
    );

    testWidgets('overridden labels replace the English defaults', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () => CoreDateRangeSheet.show(
                  context: context,
                  title: 'Période',
                  todayLabel: "Aujourd'hui",
                  applyLabel: 'Appliquer',
                ),
                child: const Text('open'),
              );
            },
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('Période'), findsOneWidget);
      expect(find.text("Aujourd'hui"), findsOneWidget);
      expect(find.text('Appliquer'), findsOneWidget);
      expect(find.text('Date range'), findsNothing);
    });
  });
}
