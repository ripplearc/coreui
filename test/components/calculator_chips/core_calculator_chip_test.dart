import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreCalculatorChip Widget Tests', () {
    testWidgets('renders editable chip with label correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              label: 'Test Label',
              value: '100',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.byType(CoreCalculatorChip), findsOneWidget);
      expect(find.byType(CoreIconWidget), findsNothing);
    });

    testWidgets('renders active chip correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.active,
              value: 'Active Val',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Active Val'), findsOneWidget);
      expect(find.byType(CoreIconWidget), findsNothing);
    });

    testWidgets('throws assertion if disable without label',
        (WidgetTester tester) async {
      expect(
        () => CoreCalculatorChip(
          type: CoreCalculatorChipType.disabled,
          value: '100',
          onTap: () {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('calls onTap callback when tapped',
        (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              value: '100',
              onTap: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      expect(wasPressed, isFalse);
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(wasPressed, isTrue);
    });

    testWidgets('does not call onTap when disabled',
        (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.disabled,
              label: 'Label',
              value: '100',
              onTap: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(wasPressed, isFalse);
    });

    testWidgets('displays close icon and triggers onClose',
        (WidgetTester tester) async {
      bool closed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              value: '100',
              withCloseIcon: true,
              onClose: () => closed = true,
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);

      await tester.tap(find.byType(CoreIconWidget));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });
  });

  group('CoreCalculatorChip – accessibility', () {
    testWidgets('exposes semantic label and button role',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      const label = 'Test';
      const value = '100';

      await tester.pumpWidget(
        buildTestApp(
          CoreCalculatorChip(
            type: CoreCalculatorChipType.editable,
            label: label,
            value: value,
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final chipFinder = find.byType(CoreCalculatorChip);
      expect(chipFinder, findsOneWidget);

      final semantics = tester.getSemantics(chipFinder);
      expect(semantics.label, '$label, $value');
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCalculatorChip(
          type: CoreCalculatorChipType.editable,
          label: label,
          value: value,
          onTap: () {},
        ),
        chipFinder,
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });
  });
}
