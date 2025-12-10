import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreFunctionBottomSheet', () {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: 'Trigonomety'),
        keys: [
          KeyType(id: 'sin', label: 'sin', action: () {}),
          KeyType(id: 'cos', label: 'cos', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(label: 'Materials'),
        keys: [
          KeyType(id: 'wood', label: 'Wood', action: () {}),
        ],
      ),
    ];

    final testAccentColors = {
      const GroupNameType(label: 'Trigonomety'): Colors.blue,
      const GroupNameType(label: 'Materials'): Colors.green,
    };

    testWidgets('calls onKeyTapped when key is tapped', (tester) async {
      KeyType? tappedKey;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreFunctionBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(label: 'Trigonomety'),
              onGroupSelected: (_) {},
              onKeyTapped: (key) => tappedKey = key,
            ),
          ),
        ),
      );

      await tester.tap(find.text('sin'));
      await tester.pumpAndSettle();

      expect(tappedKey, isNotNull);
      expect(tappedKey?.id, equals('sin'));
    });

    testWidgets('calls onGroupSelected when group header is tapped',
        (tester) async {
      GroupNameType? selectedGroup;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreFunctionBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(label: 'Trigonomety'),
              onGroupSelected: (group) => selectedGroup = group,
              onKeyTapped: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Materials group'));
      await tester.pumpAndSettle();

      expect(selectedGroup, equals(const GroupNameType(label: 'Materials')));
    });

    testWidgets('shows unit toggle when showUnitToggle is true',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreFunctionBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(label: 'Trigonomety'),
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              showUnitToggle: true,
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Measurement System'), findsOneWidget);
      expect(find.text('Imperial'), findsOneWidget);
    });

    testWidgets('hides unit toggle when showUnitToggle is false',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreFunctionBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(label: 'Trigonomety'),
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              showUnitToggle: false,
            ),
          ),
        ),
      );

      expect(find.text('Measurement System'), findsNothing);
    });

    testWidgets('calls onUnitSystemChanged when toggle is tapped',
        (tester) async {
      UnitSystem? changedSystem;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreFunctionBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(label: 'Trigonomety'),
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              currentUnitSystem: UnitSystem.imperial,
              onUnitSystemChanged: (system) => changedSystem = system,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Imperial'));
      await tester.pumpAndSettle();

      expect(changedSystem, equals(UnitSystem.metric));
    });

    testWidgets('has proper semantics for function keys', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreFunctionBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(label: 'Trigonomety'),
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.text('sin'));
      expect(semantics.label, contains('Function key sin'));
      expect(semantics.hint, contains('Tap to use sin function'));
    });

    testWidgets('has proper semantics for unit toggle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreFunctionBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(label: 'Trigonomety'),
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              currentUnitSystem: UnitSystem.imperial,
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );

      final toggleFinder = find.text('Imperial');
      expect(toggleFinder, findsOneWidget);

      final semantics = tester.getSemantics(toggleFinder);
      expect(semantics.label, contains('Unit system toggle'));
      expect(semantics.hint, isNotNull);
    });
  });
}
