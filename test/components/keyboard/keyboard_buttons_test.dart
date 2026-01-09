import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreDigitInput', () {
    testWidgets('renders with correct label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.five,
              onDigitPressed: (_) {},
              height: 40.0,
              width: 40.0,
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.three,
              onDigitPressed: (digit) => pressedDigit = digit,
              height: 40.0,
              width: 40.0,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CoreDigitInput));
      await tester.pumpAndSettle();

      expect(pressedDigit, equals(DigitType.three));
    });

    testWidgets('uses emphasized styling when isEmphasized is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDigitInput(
              digit: DigitType.zero,
              onDigitPressed: (_) {},
              isEmphasized: true,
              height: 40.0,
              width: 40.0,
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
          theme: CoreTheme.light(),
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
          theme: CoreTheme.light(),
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
    });
  });

  group('CoreOperatorButton', () {
    testWidgets('renders with correct operator symbol', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreOperatorButton(
              operatorType: OperatorType.add,
              onOperatorPressed: (_) {},
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('calls onOperatorPressed when tapped', (tester) async {
      OperatorType? pressedOperator;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
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
            theme: CoreTheme.light(),
            home: Scaffold(
              body: CoreOperatorButton(
                operatorType: op,
                onOperatorPressed: (_) {},
              ),
            ),
          ),
        );

        expect(find.byType(CoreIconWidget), findsOneWidget);
      }
    });
  });

  group('CoreUnitButton', () {
    testWidgets('renders with correct unit label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreUnitButton(
              unit: UnitType.feet,
              onUnitSelected: (_) {},
              height: 60.0,
              width: 80.0,
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreUnitButton(
              unit: UnitType.meter,
              onUnitSelected: (unit) => selectedUnit = unit,
              height: 60.0,
              width: 80.0,
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
          theme: CoreTheme.light(),
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreControlButton(
              action: ControlAction.clearAll,
              onControlAction: (_) {},
              height: 40.0,
              width: 40.0,
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('calls onControlAction when tapped', (tester) async {
      ControlAction? pressedAction;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreControlButton(
              action: ControlAction.clearAll,
              onControlAction: (action) => pressedAction = action,
              height: 40.0,
              width: 40.0,
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreControlButton(
              action: ControlAction.delete,
              onControlAction: (_) {},
              height: 40.0,
              width: 40.0,
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreResultButton(
              resultType: const ResultType(label: '='),
              onTap: () {},
              height: 40.0,
              width: 40.0,
            ),
          ),
        ),
      );

      expect(find.text('='), findsOneWidget);
    });

    testWidgets('renders area result type correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreResultButton(
              resultType: const ResultType(label: 'Area'),
              onTap: () {},
              height: 40.0,
              width: 40.0,
            ),
          ),
        ),
      );

      expect(find.text('AREA'), findsOneWidget);
    });

    testWidgets('renders custom result type with custom label', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreResultButton(
              resultType: const ResultType(label: 'Calculate'),
              customLabel: 'Calculate',
              onTap: () {},
              height: 40.0,
              width: 40.0,
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreResultButton(
              resultType: const ResultType(label: 'Volume'),
              onTap: () => wasTapped = true,
              height: 40.0,
              width: 40.0,
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreResultButton(
              resultType: const ResultType(label: 'Volume'),
              onTap: () {},
              height: 40.0,
              width: 40.0,
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreResultButton));
      expect(semantics.label, contains('VOLUME button'));
      expect(semantics.hint, contains('Calculates and displays the result'));
    });
  });

  group('Keyboard Buttons Grid View', () {
    testWidgets('displays all button types in a grid layout', (tester) async {
      final buttons = <Widget>[
        CoreDigitInput(
          digit: DigitType.zero,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.one,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.two,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.three,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.four,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.five,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.six,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.seven,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.eight,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.nine,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.decimal,
          onDigitPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreDigitInput(
          digit: DigitType.zero,
          onDigitPressed: (_) {},
          isEmphasized: true,
          height: 60,
          width: 60,
        ),
        CoreOperatorButton(
          operatorType: OperatorType.add,
          onOperatorPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreOperatorButton(
          operatorType: OperatorType.subtract,
          onOperatorPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreOperatorButton(
          operatorType: OperatorType.multiply,
          onOperatorPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreOperatorButton(
          operatorType: OperatorType.divide,
          onOperatorPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreOperatorButton(
          operatorType: OperatorType.percent,
          onOperatorPressed: (_) {},
          height: 60,
          width: 60,
        ),
        CoreUnitButton(
          unit: UnitType.feet,
          onUnitSelected: (_) {},
          height: 60,
          width: 80,
        ),
        CoreUnitButton(
          unit: UnitType.yards,
          onUnitSelected: (_) {},
          height: 60,
          width: 80,
        ),
        CoreUnitButton(
          unit: UnitType.inch,
          onUnitSelected: (_) {},
          height: 60,
          width: 80,
        ),
        CoreUnitButton(
          unit: UnitType.meter,
          onUnitSelected: (_) {},
          height: 60,
          width: 80,
        ),
        CoreUnitButton(
          unit: UnitType.centimeter,
          onUnitSelected: (_) {},
          height: 60,
          width: 80,
        ),
        CoreUnitButton(
          unit: UnitType.millimeter,
          onUnitSelected: (_) {},
          height: 60,
          width: 80,
        ),
        CoreUnitButton(
          unit: UnitType.divideSymbol,
          onUnitSelected: (_) {},
          height: 60,
          width: 60,
        ),
        CoreControlButton(
          action: ControlAction.delete,
          onControlAction: (_) {},
          height: 60,
          width: 60,
        ),
        CoreControlButton(
          action: ControlAction.clearAll,
          onControlAction: (_) {},
          height: 60,
          width: 60,
        ),
        CoreControlButton(
          action: ControlAction.moreOptions,
          onControlAction: (_) {},
          height: 60,
          width: 60,
        ),
        CoreResultButton(
          resultType: const ResultType(label: '='),
          onTap: () {},
          height: 60,
          width: 60,
        ),
        CoreResultButton(
          resultType: const ResultType(label: 'Area'),
          onTap: () {},
          height: 60,
          width: 80,
        ),
        CoreResultButton(
          resultType: const ResultType(label: 'Volume'),
          onTap: () {},
          height: 60,
          width: 80,
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            backgroundColor: AppColorsExtension.create().pageBackground,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Keyboard Buttons Grid View',
                    style: CoreTheme.light()
                        .extension<AppTypographyExtension>()!
                        .titleLargeSemiBold,
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                    children: buttons,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.byType(CoreDigitInput), findsWidgets);
      expect(find.byType(CoreOperatorButton), findsWidgets);
      expect(find.byType(CoreUnitButton), findsWidgets);
      expect(find.byType(CoreControlButton), findsWidgets);
      expect(find.byType(CoreResultButton), findsWidgets);
    });
  });
}
