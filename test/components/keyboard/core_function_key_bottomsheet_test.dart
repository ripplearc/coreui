import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreFunctionKeyBottomSheet', () {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(label: 'Trigonomety'),
        keys: [
          KeyType(groupName: 'Trigonomety', label: 'sin', action: () {}),
          KeyType(groupName: 'Trigonomety', label: 'cos', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(label: 'Materials'),
        keys: [
          KeyType(groupName: 'Materials', label: 'Wood', action: () {}),
        ],
      ),
    ];

    final testAccentColors = {
      const GroupNameType(label: 'Trigonomety'):
          CoreBackgroundColors.backgroundDarkGray,
      const GroupNameType(label: 'Materials'):
          CoreBackgroundColors.backgroundOrientMid,
    };

    testWidgets('calls onKeyTapped when key is tapped', (tester) async {
      KeyType? tappedKey;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
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
      expect(tappedKey!.groupName, equals('Trigonomety'));
    });

    testWidgets('calls onGroupSelected when group header is tapped',
        (tester) async {
      GroupNameType? selectedGroup;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
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

      final imperialText = find.text('Imperial');
      expect(imperialText, findsOneWidget);

      final toggleGesture = find.ancestor(
        of: imperialText,
        matching: find.byType(GestureDetector),
      );

      await tester.tap(toggleGesture.first);
      await tester.pumpAndSettle();

      expect(changedSystem, equals(UnitSystem.metric));
    });

    testWidgets('has proper semantics for function keys', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
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
      expect(semantics.hint, isNotNull);
    });
  });
}
