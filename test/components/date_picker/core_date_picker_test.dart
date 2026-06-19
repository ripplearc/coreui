import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreDatePicker – general', () {
    testWidgets('renders header label and selected date', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Select date'), findsOneWidget);
      expect(find.text('Sun, Aug 17'), findsOneWidget);
      expect(find.text('August 2025'), findsOneWidget);
    });

    testWidgets('renders all days of the displayed month', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('1'), findsOneWidget);
      expect(find.text('31'), findsOneWidget);
    });

    testWidgets('tapping a day calls onDateChanged with that date',
        (tester) async {
      DateTime? changedTo;

      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (date) => changedTo = date,
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.text('12'));
      await tester.pump();

      expect(changedTo, DateTime(2025, 8, 12));
    });

    testWidgets('next month arrow advances the displayed month',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pump();

      expect(find.text('September 2025'), findsOneWidget);
    });

    testWidgets('previous month arrow rewinds the displayed month',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Previous month'));
      await tester.pump();

      expect(find.text('July 2025'), findsOneWidget);
    });

    testWidgets('changing month does not change the selected date header',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pump();

      expect(find.text('Sun, Aug 17'), findsOneWidget);
    });

    testWidgets('cancel button fires onCancel', (tester) async {
      var cancelled = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () => cancelled = true,
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.text('Cancel'));
      await tester.pump();

      expect(cancelled, isTrue);
    });

    testWidgets('confirm button fires onConfirm', (tester) async {
      var confirmed = false;

      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () => confirmed = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.text('OK'));
      await tester.pump();

      expect(confirmed, isTrue);
    });

    testWidgets('custom labels override defaults', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
            label: 'Choose a date',
            cancelLabel: 'Dismiss',
            confirmLabel: 'Done',
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Choose a date'), findsOneWidget);
      expect(find.text('Dismiss'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);
    });

    testWidgets('dateLabelBuilder and monthLabelBuilder override formatting',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
            dateLabelBuilder: (date) => 'Custom ${date.day}',
            monthLabelBuilder: (month) => 'Custom month ${month.month}',
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Custom 17'), findsOneWidget);
      expect(find.text('Custom month 8'), findsOneWidget);
    });

    testWidgets('weekdayLabels overrides the weekday header', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
            weekdayLabels: const ['D', 'L', 'M', 'M', 'J', 'V', 'S'],
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('D'), findsOneWidget);
      expect(find.text('L'), findsOneWidget);
    });
  });

  group('CoreDatePicker – bounds', () {
    testWidgets('days before firstDate are disabled', (tester) async {
      DateTime? changedTo;

      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            firstDate: DateTime(2025, 8, 10),
            onDateChanged: (date) => changedTo = date,
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.text('5'));
      await tester.pump();

      expect(changedTo, isNull);
    });

    testWidgets('days after lastDate are disabled', (tester) async {
      DateTime? changedTo;

      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            lastDate: DateTime(2025, 8, 20),
            onDateChanged: (date) => changedTo = date,
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.text('25'));
      await tester.pump();

      expect(changedTo, isNull);
    });

    testWidgets('days within bounds remain tappable', (tester) async {
      DateTime? changedTo;

      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            firstDate: DateTime(2025, 8, 10),
            lastDate: DateTime(2025, 8, 20),
            onDateChanged: (date) => changedTo = date,
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.text('15'));
      await tester.pump();

      expect(changedTo, DateTime(2025, 8, 15));
    });

    testWidgets('previous month arrow disabled when entirely before firstDate',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            firstDate: DateTime(2025, 8, 1),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Previous month'));
      await tester.pump();

      expect(find.text('August 2025'), findsOneWidget);
    });

    testWidgets('next month arrow disabled when entirely after lastDate',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreDatePicker(
            selectedDate: DateTime(2025, 8, 17),
            today: DateTime(2025, 8, 5),
            lastDate: DateTime(2025, 8, 31),
            onDateChanged: (_) {},
            onCancel: () {},
            onConfirm: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Next month'));
      await tester.pump();

      expect(find.text('August 2025'), findsOneWidget);
    });
  });

  group('CoreDatePicker.show', () {
    testWidgets('resolves with confirmed date', (tester) async {
      DateTime? result;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await CoreDatePicker.show(
                    context: context,
                    initialDate: DateTime(2025, 8, 17),
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('12'));
      await tester.pump();

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(result, DateTime(2025, 8, 12));
    });

    testWidgets('resolves with null when cancelled', (tester) async {
      DateTime? result = DateTime(1999, 1, 1);
      var resolved = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  result = await CoreDatePicker.show(
                    context: context,
                    initialDate: DateTime(2025, 8, 17),
                  );
                  resolved = true;
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(resolved, isTrue);
      expect(result, isNull);
    });
  });
}
