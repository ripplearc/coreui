import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreDigitInput', () {
    testWidgets('renders with correct label', (tester) async {
      DigitType? pressedDigit;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.five,
              onDigitPressed: (digit) => pressedDigit = digit,
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('calls onDigitPressed when tapped', (tester) async {
      DigitType? pressedDigit;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.three,
              onDigitPressed: (digit) => pressedDigit = digit,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoreDigitInput));
      await tester.pumpAndSettle();

      expect(pressedDigit, equals(DigitType.three));
    });

    testWidgets('uses emphasized styling when isEmphasized is true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.zero,
              onDigitPressed: (_) {},
              isEmphasized: true,
            ),
          ),
        ),
      );

      final button = tester.widget<Container>(
        find.descendant(
          of: find.byType(CoreDigitInput),
          matching: find.byType(Container).first,
        ),
      );

      expect(button.decoration, isNotNull);
    });

    testWidgets('uses custom size when provided', (tester) async {
      const customSize = 80.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.one,
              onDigitPressed: (_) {},
              size: customSize,
            ),
          ),
        ),
      );

      final sizedBox = tester.getSize(find.byType(CoreDigitInput));
      expect(sizedBox.width, equals(customSize));
      expect(sizedBox.height, equals(customSize));
    });

    testWidgets('has proper semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.seven,
              onDigitPressed: (_) {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreDigitInput));
      expect(semantics.label, contains('7 button'));
      expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);
    });
  });

  group('CoreOperatorButton', () {
    testWidgets('renders with correct operator symbol', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreOperatorButton(
              operatorType: OperatorType.add,
              onOperatorPressed: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('+'), findsOneWidget);
    });

    testWidgets('calls onOperatorPressed when tapped', (tester) async {
      OperatorType? pressedOperator;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreOperatorButton(
              operatorType: OperatorType.multiply,
              onOperatorPressed: (op) => pressedOperator = op,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoreOperatorButton));
      await tester.pumpAndSettle();

      expect(pressedOperator, equals(OperatorType.multiply));
    });

    testWidgets('renders all operator types correctly', (tester) async {
      final operators = [
        OperatorType.add,
        OperatorType.subtract,
        OperatorType.multiply,
        OperatorType.divide,
        OperatorType.percent,
      ];

      for (final op in operators) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: CoreOperatorButton(
                operatorType: op,
                onOperatorPressed: (_) {},
              ),
            ),
          ),
        );

        expect(find.text(op.symbol), findsOneWidget);
      }
    });
  });

  group('CoreUnitButton', () {
    testWidgets('renders with correct unit label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreUnitButton(
              unit: UnitType.feet,
              onUnitSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Feet'), findsOneWidget);
    });

    testWidgets('calls onUnitSelected when tapped', (tester) async {
      UnitType? selectedUnit;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreUnitButton(
              unit: UnitType.meter,
              onUnitSelected: (unit) => selectedUnit = unit,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoreUnitButton));
      await tester.pumpAndSettle();

      expect(selectedUnit, equals(UnitType.meter));
    });

    testWidgets('uses custom width and height when provided', (tester) async {
      const customWidth = 100.0;
      const customHeight = 80.0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreUnitButton(
              unit: UnitType.yards,
              onUnitSelected: (_) {},
              width: customWidth,
              height: customHeight,
            ),
          ),
        ),
      );

      final sizedBox = tester.getSize(find.byType(CoreUnitButton));
      expect(sizedBox.width, equals(customWidth));
      expect(sizedBox.height, equals(customHeight));
    });
  });

  group('CoreControlButton', () {

    testWidgets('renders clear all action correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreControlButton(
              action: ControlAction.clearAll,
              onControlAction: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('C'), findsOneWidget);
    });

    testWidgets('calls onControlAction when tapped', (tester) async {
      ControlAction? pressedAction;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreControlButton(
              action: ControlAction.clearAll,
              onControlAction: (action) => pressedAction = action,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoreControlButton));
      await tester.pumpAndSettle();

      expect(pressedAction, equals(ControlAction.clearAll));
    });

    testWidgets('has proper semantic labels and hints', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreControlButton(
              action: ControlAction.delete,
              onControlAction: (_) {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreControlButton));
      expect(semantics.label, contains('Delete button'));
      expect(semantics.hint, contains('Deletes the last entered character'));
    });
  });

  group('CoreResultButton', () {
    testWidgets('renders equals result type correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreResultButton(
              resultType: ResultType.equals,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('='), findsOneWidget);
    });

    testWidgets('renders area result type correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreResultButton(
              resultType: ResultType.area,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('AREA'), findsOneWidget);
    });

    testWidgets('renders custom result type with custom label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreResultButton(
              resultType: ResultType.custom,
              customLabel: 'Calculate',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('CALCULATE'), findsOneWidget);
    });

    testWidgets('calls onTap when pressed', (tester) async {
      bool wasTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreResultButton(
              resultType: ResultType.equals,
              onTap: () => wasTapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoreResultButton));
      await tester.pumpAndSettle();

      expect(wasTapped, isTrue);
    });

    testWidgets('has proper semantics', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreResultButton(
              resultType: ResultType.volume,
              onTap: () {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreResultButton));
      expect(semantics.label, contains('VOLUME button'));
      expect(semantics.hint, contains('Calculates and displays the result'));
    });
  });
}

