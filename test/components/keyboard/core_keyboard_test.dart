import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/keyboard/core_keyboard.dart';

void main() {
  group('CoreKeyboard', () {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: "Basic Geometry"),
        keys: [
          KeyType(id: 'area', label: 'Area', action: () {}),
          KeyType(id: 'perimeter', label: 'Perimeter', action: () {}),
        ],
      ),
    ];

    testWidgets('renders keyboard with all required components',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(label: "Basic Geometry"),
              allGroups: testGroups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );

      // Check that keyboard container is present
      expect(find.byType(CoreKeyboard), findsOneWidget);
    });

    testWidgets('calls onDigitPressed when digit button is tapped',
        (tester) async {
      DigitType? pressedDigit;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(label: "Basic Geometry"),
              allGroups: testGroups,
              onDigitPressed: (digit) => pressedDigit = digit,
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Find and tap a digit button (e.g., "1")
      final digitButton = find.text('1');
      if (digitButton.evaluate().isNotEmpty) {
        await tester.tap(digitButton);
        await tester.pumpAndSettle();
        expect(pressedDigit, equals(DigitType.one));
      }
    });

    testWidgets('calls onOperatorPressed when operator button is tapped',
        (tester) async {
      OperatorType? pressedOperator;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(label: "Basic Geometry"),
              allGroups: testGroups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (op) => pressedOperator = op,
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Find and tap an operator button (e.g., "+")
      final operatorButton = find.text('+');
      if (operatorButton.evaluate().isNotEmpty) {
        await tester.tap(operatorButton);
        await tester.pumpAndSettle();
        expect(pressedOperator, equals(OperatorType.add));
      }
    });

    testWidgets('calls onResultTapped when result button is tapped',
        (tester) async {
      bool resultTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(label: "Basic Geometry"),
              allGroups: testGroups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () => resultTapped = true,
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Find and tap the result button
      final resultButton = find.text('=');
      if (resultButton.evaluate().isNotEmpty) {
        await tester.tap(resultButton);
        await tester.pumpAndSettle();
        expect(resultTapped, isTrue);
      }
    });

    testWidgets('displays correct unit buttons for imperial system',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(label: "Basic Geometry"),
              allGroups: testGroups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
              currentUnitSystem: UnitSystem.imperial,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Check for imperial units
      expect(find.text('Yards'), findsWidgets);
      expect(find.text('Feet'), findsWidgets);
      expect(find.text('Inches'), findsWidgets);
    });

    testWidgets('displays correct unit buttons for metric system',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(label: "Basic Geometry"),
              allGroups: testGroups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
              currentUnitSystem: UnitSystem.metric,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Check for metric units
      expect(find.text('Meters'), findsWidgets);
      expect(find.text('Centimeters'), findsWidgets);
      expect(find.text('Millimeters'), findsWidgets);
    });

    testWidgets('handles empty function groups gracefully', (tester) async {
      final emptyGroups = [
        const FunctionGroup(
          name: const GroupNameType(label: ""),
          keys: [],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(label: ""),
              allGroups: emptyGroups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      // Should render without crashing
      expect(find.byType(CoreKeyboard), findsOneWidget);
    });
  });
}
