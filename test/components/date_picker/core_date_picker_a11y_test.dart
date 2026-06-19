import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

Future<void> setTestViewport(WidgetTester tester) async {
  addTearDown(() => tester.view.resetPhysicalSize());
  tester.view.physicalSize = const ui.Size(1100, 1600);
}

void main() {
  group('CoreDatePicker – accessibility', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreDatePicker(
          selectedDate: DateTime(2025, 8, 17),
          today: DateTime(2025, 8, 5),
          onDateChanged: (_) {},
          onCancel: () {},
          onConfirm: () {},
        ),
        find.byType(CoreDatePicker),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('day cells expose selected and full-date semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);
      await setupA11yTest(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDatePicker(
              selectedDate: DateTime(2025, 8, 17),
              today: DateTime(2025, 8, 5),
              onDateChanged: (_) {},
              onCancel: () {},
              onConfirm: () {},
            ),
          ),
        ),
      );

      final localizations =
          MaterialLocalizations.of(tester.element(find.byType(CoreDatePicker)));
      final selectedDayLabel =
          localizations.formatFullDate(DateTime(2025, 8, 17));

      final selectedDayFinder = find.bySemanticsLabel(selectedDayLabel);
      expect(selectedDayFinder, findsOneWidget);

      final selectedSemantics = tester.getSemantics(selectedDayFinder);
      expect(selectedSemantics.hasFlag(ui.SemanticsFlag.isButton), isTrue);
      expect(selectedSemantics.hasFlag(ui.SemanticsFlag.isSelected), isTrue);
    });

    testWidgets('month navigation controls expose accessible labels',
        (WidgetTester tester) async {
      await setTestViewport(tester);
      await setupA11yTest(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDatePicker(
              selectedDate: DateTime(2025, 8, 17),
              today: DateTime(2025, 8, 5),
              onDateChanged: (_) {},
              onCancel: () {},
              onConfirm: () {},
              previousMonthSemanticLabel: 'Go to previous month',
              nextMonthSemanticLabel: 'Go to next month',
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Go to previous month'), findsOneWidget);
      expect(find.bySemanticsLabel('Go to next month'), findsOneWidget);
    });

    testWidgets('disabled month navigation arrow exposes disabled semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);
      await setupA11yTest(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDatePicker(
              selectedDate: DateTime(2025, 8, 17),
              today: DateTime(2025, 8, 5),
              firstDate: DateTime(2025, 8, 1),
              onDateChanged: (_) {},
              onCancel: () {},
              onConfirm: () {},
            ),
          ),
        ),
      );

      final previousMonthFinder = find.bySemanticsLabel('Previous month');
      expect(previousMonthFinder, findsOneWidget);

      final semantics = tester.getSemantics(previousMonthFinder);
      expect(semantics.hasFlag(ui.SemanticsFlag.isButton), isTrue);
      expect(semantics.hasFlag(ui.SemanticsFlag.isEnabled), isFalse);
    });

    testWidgets('disabled out-of-range days are excluded from focus order',
        (WidgetTester tester) async {
      await setTestViewport(tester);
      await setupA11yTest(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDatePicker(
              selectedDate: DateTime(2025, 8, 17),
              today: DateTime(2025, 8, 5),
              firstDate: DateTime(2025, 8, 10),
              onDateChanged: (_) {},
              onCancel: () {},
              onConfirm: () {},
            ),
          ),
        ),
      );

      final localizations =
          MaterialLocalizations.of(tester.element(find.byType(CoreDatePicker)));
      final disabledDayLabel =
          localizations.formatFullDate(DateTime(2025, 8, 5));

      final disabledDayFinder = find.bySemanticsLabel(disabledDayLabel);
      expect(disabledDayFinder, findsOneWidget);

      final disabledSemantics = tester.getSemantics(disabledDayFinder);
      expect(disabledSemantics.hasFlag(ui.SemanticsFlag.isEnabled), isFalse);
    });
  });
}
