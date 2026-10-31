import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  final march = DateRange(
    start: DateTime(2024, 3, 1),
    end: DateTime(2024, 3, 31),
  );

  BoxDecoration pillDecoration(WidgetTester tester) {
    final pill = find.byKey(CoreDateFilterChip.pillKey);
    return tester.widget<DecoratedBox>(pill).decoration as BoxDecoration;
  }

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

    testWidgets('opens the sheet, not onClear, when the active pill is tapped',
        (tester) async {
      var clearCalled = false;
      await pumpChip(
        tester,
        selectedDateRange: DateRange(
          start: DateTime(2024, 3, 1),
          end: DateTime(2024, 3, 31),
        ),
        onClear: () => clearCalled = true,
      );

      await tester.tap(find.text('Mar 01, 2024 - Mar 31, 2024'));
      await tester.pumpAndSettle();

      expect(find.text('Date range'), findsOneWidget);
      expect(clearCalled, isFalse);
    });

    testWidgets('calls onClear and shows the inactive chip when × is tapped',
        (tester) async {
      DateRange? range = DateRange(
        start: DateTime(2024, 3, 1),
        end: DateTime(2024, 3, 31),
      );
      await tester.pumpWidget(
        buildTestApp(
          StatefulBuilder(
            builder: (context, setState) => CoreDateFilterChip(
              selectedDateRange: range,
              label: 'Modified',
              inactiveChipKey: const Key('date_filter_chip'),
              onApply: (_) {},
              onClear: () => setState(() => range = null),
            ),
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.byKey(CoreDateFilterChip.clearButtonKey));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('date_filter_chip')), findsOneWidget);
    });

    testWidgets('calls onClear on each tap of × while the range is kept', (
      tester,
    ) async {
      var clears = 0;
      await pumpChip(tester, selectedDateRange: march, onClear: () => clears++);

      await tester.tap(find.byKey(CoreDateFilterChip.clearButtonKey));
      await tester.pump();
      await tester.tap(find.byKey(CoreDateFilterChip.clearButtonKey));
      await tester.pump();

      expect(clears, 2);
    });

    testWidgets('keeps the dates inside the pill at 200% text', (
      tester,
    ) async {
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: buildTestApp(
            CoreDateFilterChip(
              selectedDateRange: march,
              label: 'Modified',
              onApply: (_) {},
              onClear: () {},
            ),
            theme: CoreTheme.light(),
          ),
        ),
      );

      final pill = tester.getRect(find.byKey(CoreDateFilterChip.pillKey));
      final dates = find.descendant(
        of: find.byType(CoreDateFilterChip),
        matching: find.byType(Text),
      );
      final text = tester.renderObject<RenderBox>(dates);
      final textRect = tester.getRect(dates);
      expect(
        text.size.height,
        greaterThanOrEqualTo(text.getMinIntrinsicHeight(text.size.width)),
      );
      expect(pill.top, lessThanOrEqualTo(textRect.top));
      expect(pill.bottom, greaterThanOrEqualTo(textRect.bottom));
    });

    testWidgets('keeps both active pill targets at least 48 dp high', (
      tester,
    ) async {
      await pumpChip(
        tester,
        selectedDateRange: DateRange(
          start: DateTime(2024, 3, 1),
          end: DateTime(2024, 3, 31),
        ),
      );

      final clearSize =
          tester.getSize(find.byKey(CoreDateFilterChip.clearButtonKey));
      expect(clearSize.width, CoreSpacing.space12);
      expect(clearSize.height, CoreSpacing.space12);
      expect(
        tester.getSize(find.byKey(const Key('active_date_filter_chip'))).height,
        CoreSpacing.space12,
      );
    });

    testWidgets('ends the dates 8 dp before the ×, as Figma does', (
      tester,
    ) async {
      await pumpChip(tester, selectedDateRange: march);

      final textRight =
          tester.getRect(find.text('Mar 01, 2024 - Mar 31, 2024')).right;
      final iconLeft = tester
          .getRect(find.descendant(
            of: find.byKey(CoreDateFilterChip.clearButtonKey),
            matching: find.byType(CoreIconWidget),
          ))
          .left;
      expect(iconLeft - textRight, moreOrLessEquals(CoreSpacing.space2));
      expect(
        tester.getSize(find.byKey(CoreDateFilterChip.clearButtonKey)).width,
        CoreSpacing.space12,
      );
    });

    testWidgets('puts the × at the start in a right-to-left app', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          Directionality(
            textDirection: TextDirection.rtl,
            child: CoreDateFilterChip(
              selectedDateRange: march,
              label: 'Modified',
              activeChipKey: const Key('active_date_filter_chip'),
              onApply: (_) {},
              onClear: () {},
            ),
          ),
          theme: CoreTheme.light(),
        ),
      );

      final chip =
          tester.getRect(find.byKey(const Key('active_date_filter_chip')));
      final clear =
          tester.getRect(find.byKey(CoreDateFilterChip.clearButtonKey));
      final dates = tester.getRect(find.text('Mar 01, 2024 - Mar 31, 2024'));
      final pill = tester.getRect(find.byKey(CoreDateFilterChip.pillKey));
      expect(clear.left, chip.left);
      expect(dates.left, greaterThan(clear.left));
      expect(pill.right, chip.right);
    });

    testWidgets('draws the range focus on the pill border', (tester) async {
      await pumpChip(tester, selectedDateRange: march);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final colors = AppColorsExtension.of(
        tester.element(find.byKey(CoreDateFilterChip.pillKey)),
      );
      expect(
        pillDecoration(tester).border,
        Border.all(color: colors.outlineFocus, width: 2),
      );
    });

    testWidgets('keeps the focus border on the pill when Tab moves to the ×', (
      tester,
    ) async {
      await pumpChip(tester, selectedDateRange: march);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();

      final colors = AppColorsExtension.of(
        tester.element(find.byKey(CoreDateFilterChip.pillKey)),
      );
      expect(
        pillDecoration(tester).border,
        Border.all(color: colors.outlineFocus, width: 2),
      );
      final focused = FocusManager.instance.primaryFocus as FocusNode;
      expect(
        find.descendant(
          of: find.byKey(CoreDateFilterChip.clearButtonKey),
          matching: find.byElementPredicate((e) => e == focused.context),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows the library press look while the range is held', (
      tester,
    ) async {
      await pumpChip(tester, selectedDateRange: march);

      final gesture = await tester.press(
        find.text('Mar 01, 2024 - Mar 31, 2024'),
      );
      await tester.pump();

      final colors = AppColorsExtension.of(
        tester.element(find.byKey(CoreDateFilterChip.pillKey)),
      );
      expect(pillDecoration(tester).color, colors.pageBackground);
      expect(
        pillDecoration(tester).border,
        Border.all(color: colors.lineDarkOutline),
      );
      await gesture.cancel();
    });

    testWidgets('works with no Material above the active pill', (
      tester,
    ) async {
      var clearCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Center(
            child: CoreDateFilterChip(
              selectedDateRange: march,
              label: 'Modified',
              onApply: (_) {},
              onClear: () => clearCalled = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byKey(CoreDateFilterChip.clearButtonKey));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(clearCalled, isTrue);
    });
  });
}
