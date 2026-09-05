import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreFunctionKeyBottomSheet', () {
    final testGroups = [
      FunctionGroup(
        name: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
        keys: [
          KeyType(groupName: 'Trigonomety', id: 'sin', label: 'sin', action: () {}),
          KeyType(groupName: 'Trigonomety', id: 'cos', label: 'cos', action: () {}),
        ],
      ),
      FunctionGroup(
        name: const GroupNameType(id: 'Materials', label: 'Materials'),
        keys: [
          KeyType(groupName: 'Materials', id: 'Wood', label: 'Wood', action: () {}),
        ],
      ),
    ];

    final colors = AppColorsExtension.create();
    final testAccentColors = {
      const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'): colors.backgroundDarkGray,
      const GroupNameType(id: 'Materials', label: 'Materials'): colors.orientMid,
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
              selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
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
              selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
              onGroupSelected: (group) => selectedGroup = group,
              onKeyTapped: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Materials group'));
      await tester.pumpAndSettle();

      expect(selectedGroup, equals(const GroupNameType(id: 'Materials', label: 'Materials')));
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
              selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
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
              selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
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
              selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
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
              selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
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

    testWidgets(
        'dragging a group to a later, non-adjacent position drops it at '
        'the correct final index', (tester) async {
      final reorderGroups = [
        FunctionGroup(
          name: const GroupNameType(id: 'Group A', label: 'Group A'),
          keys: [KeyType(groupName: 'Group A', id: 'A1', label: 'A1', action: () {})],
        ),
        FunctionGroup(
          name: const GroupNameType(id: 'Group B', label: 'Group B'),
          keys: [KeyType(groupName: 'Group B', id: 'B1', label: 'B1', action: () {})],
        ),
        FunctionGroup(
          name: const GroupNameType(id: 'Group C', label: 'Group C'),
          keys: [KeyType(groupName: 'Group C', id: 'C1', label: 'C1', action: () {})],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
              groups: reorderGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(id: 'Group A', label: 'Group A'),
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              showUnitToggle: false,
            ),
          ),
        ),
      );

      final dragHandles = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.drag_indicator,
      );
      expect(dragHandles, findsNWidgets(3));

      // Drag the first group past the second so it lands on the last slot,
      // not just the adjacent one.
      await tester.drag(dragHandles.first, const Offset(0, 220));
      await tester.pumpAndSettle();

      final groupHeaders = tester
          .widgetList<Text>(find.textContaining(' group'))
          .map((t) => t.data)
          .toList();
      expect(groupHeaders, ['Group B group', 'Group C group', 'Group A group']);
    });

    testWidgets('has proper semantics for unit toggle', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
              groups: testGroups,
              groupAccentColors: testAccentColors,
              selectedGroup: const GroupNameType(id: 'Trigonomety', label: 'Trigonomety'),
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

    // The regression CA-898 exists to close, exercised through the widget
    // rather than only through GroupNameType's == / hashCode. Every other
    // fixture in this suite sets id == label, so reverting the wiring here to
    // match on `group.name.label` leaves the whole suite green -- verified.
    // This case diverges the two: the sheet is handed groups whose labels are
    // localized while the caller still holds the un-localized selectedGroup,
    // exactly the state a locale switch produces mid-session.
    testWidgets('selection survives a locale switch that changes only labels',
        (tester) async {
      final localizedGroups = [
        FunctionGroup(
          name: const GroupNameType(id: 'Trigonomety', label: 'Trigonometria'),
          keys: [
            KeyType(
                groupName: 'Trigonomety',
                id: 'sin',
                label: 'sen',
                action: () {}),
          ],
        ),
        FunctionGroup(
          name: const GroupNameType(id: 'Materials', label: 'Materiales'),
          keys: [
            KeyType(
                groupName: 'Materials',
                id: 'Wood',
                label: 'Madera',
                action: () {}),
          ],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreFunctionKeyBottomSheet(
              groups: localizedGroups,
              groupAccentColors: testAccentColors,
              // Still the pre-switch instance: same id, un-localized label.
              selectedGroup:
                  const GroupNameType(id: 'Materials', label: 'Materials'),
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              currentUnitSystem: UnitSystem.imperial,
              onUnitSystemChanged: (_) {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Headers render as '<label> group' (_GroupHeader), and the keys carry
      // their own localized labels.
      expect(find.text('Materiales group'), findsOneWidget);
      expect(find.text('Trigonometria group'), findsOneWidget);
      expect(find.text('Madera'), findsOneWidget);

      // The reorder key tracks the stable id, not the label that just changed.
      expect(
        find.byKey(const ValueKey('Materials')),
        findsOneWidget,
        reason: 'the list key must be the id, so the row is not rebuilt as a '
            'new item when the locale changes',
      );

      // The accent map is keyed on GroupNameType; a localized instance must
      // still hit the entry registered under the un-localized one.
      expect(
        testAccentColors[localizedGroups[1].name],
        equals(colors.orientMid),
        reason: 'a re-localized group must resolve as the same Map key',
      );
    });
  });
}
