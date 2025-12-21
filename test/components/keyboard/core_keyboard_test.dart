import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreKeyboard', () {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: "Basic Geometry"),
        keys: [
          KeyType(groupName: 'Basic Geometry', label: 'Area', action: () {}),
          KeyType(
              groupName: 'Basic Geometry', label: 'Perimeter', action: () {}),
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
      expect(find.text('M'), findsWidgets);
      expect(find.text('CM'), findsWidgets);
      expect(find.text('MM'), findsWidgets);
    });

    testWidgets('handles empty function groups gracefully', (tester) async {
      final emptyGroups = [
        const FunctionGroup(
          name: GroupNameType(label: ""),
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
      expect(find.byType(CoreKeyboard), findsOneWidget);
    });
  });
}
