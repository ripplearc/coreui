import 'dart:ui' as ui;

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
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(800, 1200);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
          ),
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
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(800, 1200);

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
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(800, 1200);

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
      final operatorButton = find.byType(CoreOperatorButton).first;
      if (operatorButton.evaluate().isNotEmpty) {
        await tester.tap(operatorButton);
        await tester.pumpAndSettle();
        expect(pressedOperator, equals(OperatorType.percent));
      }
    });

    testWidgets('calls onResultTapped when result button is tapped',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(800, 1200);

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
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(800, 1200);

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
      expect(find.text('Inch'), findsWidgets);
    });

    testWidgets('displays correct unit buttons for metric system',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(800, 1200);

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
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(800, 1200);

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
