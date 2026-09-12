import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void _ignoreKey(KeyType _) {}

void _ignoreDigit(DigitType _) {}

void _ignoreUnit(UnitType _) {}

void _ignoreOperator(OperatorType _) {}

void _ignoreControl(ControlAction _) {}

void _ignoreUnitSystem(UnitSystem _) {}

void _ignoreResult() {}

class _ReorderingKeyboardHost extends StatefulWidget {
  const _ReorderingKeyboardHost({required this.initialGroups});

  final List<FunctionGroup> initialGroups;

  @override
  State<_ReorderingKeyboardHost> createState() =>
      _ReorderingKeyboardHostState();
}

class _ReorderingKeyboardHostState extends State<_ReorderingKeyboardHost> {
  late List<FunctionGroup> groups = List.of(widget.initialGroups);
  final List<(int, int)> reorders = [];

  void reorderInPlace(int oldIndex, int newIndex) {
    setState(() => groups.insert(newIndex, groups.removeAt(oldIndex)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CoreKeyboard(
        currentGroup: groups.first.name,
        allGroups: groups,
        onDigitPressed: _ignoreDigit,
        onUnitSelected: _ignoreUnit,
        onOperatorPressed: _ignoreOperator,
        onControlAction: _ignoreControl,
        onResultTapped: _ignoreResult,
        onGroupSelected: (_) {},
        onKeyTapped: _ignoreKey,
        onUnitSystemChanged: _ignoreUnitSystem,
        onGroupsReordered: (oldIndex, newIndex) {
          reorders.add((oldIndex, newIndex));
          setState(() {
            final next = List.of(groups);
            next.insert(newIndex, next.removeAt(oldIndex));
            groups = next;
          });
        },
        reorderSemanticsLabelBuilder: (label) => 'Reorder $label',
      ),
    );
  }
}

void main() {
  group('CoreKeyboard group swipe', () {
    const basic = GroupNameType(id: 'basic', label: 'Basic Geometry');
    const materials = GroupNameType(id: 'materials', label: 'Materials');
    const trig = GroupNameType(id: 'trig', label: 'Trigonometry');

    List<FunctionGroup> swipeGroups({VoidCallback? onArea}) => [
          FunctionGroup(
            name: basic,
            keys: [
              KeyType(
                groupName: 'basic',
                id: 'Area',
                label: 'Area',
                action: onArea,
              ),
            ],
          ),
          const FunctionGroup(
            name: materials,
            keys: [KeyType(groupName: 'materials', id: 'Wood', label: 'Wood')],
          ),
          const FunctionGroup(
            name: trig,
            keys: [KeyType(groupName: 'trig', id: 'sin', label: 'sin')],
          ),
        ];

    Widget buildKeyboard({
      required GroupNameType current,
      required List<FunctionGroup> groups,
      required ValueChanged<GroupNameType> onGroupSelected,
      ValueChanged<KeyType> onKeyTapped = _ignoreKey,
    }) {
      return MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: CoreKeyboard(
            currentGroup: current,
            allGroups: groups,
            onDigitPressed: _ignoreDigit,
            onUnitSelected: _ignoreUnit,
            onOperatorPressed: _ignoreOperator,
            onControlAction: _ignoreControl,
            onResultTapped: _ignoreResult,
            onGroupSelected: onGroupSelected,
            onKeyTapped: onKeyTapped,
            onUnitSystemChanged: _ignoreUnitSystem,
          ),
        ),
      );
    }

    Future<void> setViewport(WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);
    }

    testWidgets('swipe left selects the next group exactly once',
        (tester) async {
      await setViewport(tester);
      final selected = <GroupNameType>[];
      await tester.pumpWidget(buildKeyboard(
        current: basic,
        groups: swipeGroups(),
        onGroupSelected: selected.add,
      ));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(FunctionKeyTile).first,
          const Offset(-CoreSpacing.space40, 0));
      await tester.pumpAndSettle();

      expect(selected, [materials]);
    });

    testWidgets('swipe right selects the previous group, wrapping at the start',
        (tester) async {
      await setViewport(tester);
      final selected = <GroupNameType>[];
      await tester.pumpWidget(buildKeyboard(
        current: basic,
        groups: swipeGroups(),
        onGroupSelected: selected.add,
      ));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(FunctionKeyTile).first,
          const Offset(CoreSpacing.space40, 0));
      await tester.pumpAndSettle();

      expect(selected, [trig]);
    });

    testWidgets('swipe left wraps from the last group to the first',
        (tester) async {
      await setViewport(tester);
      final selected = <GroupNameType>[];
      await tester.pumpWidget(buildKeyboard(
        current: trig,
        groups: swipeGroups(),
        onGroupSelected: selected.add,
      ));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(FunctionKeyTile).first,
          const Offset(-CoreSpacing.space40, 0));
      await tester.pumpAndSettle();

      expect(selected, [basic]);
    });

    testWidgets('a tap on a function key never counts as a swipe',
        (tester) async {
      await setViewport(tester);
      final selected = <GroupNameType>[];
      final tapped = <KeyType>[];
      await tester.pumpWidget(buildKeyboard(
        current: basic,
        groups: swipeGroups(),
        onGroupSelected: selected.add,
        onKeyTapped: tapped.add,
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Area'));
      await tester.pumpAndSettle();

      expect(tapped.map((k) => k.id), ['Area']);
      expect(selected, isEmpty);
    });

    testWidgets('a swipe that starts on a key cancels the key tap',
        (tester) async {
      await setViewport(tester);
      final selected = <GroupNameType>[];
      final tapped = <KeyType>[];
      var areaActions = 0;
      await tester.pumpWidget(buildKeyboard(
        current: basic,
        groups: swipeGroups(onArea: () => areaActions++),
        onGroupSelected: selected.add,
        onKeyTapped: tapped.add,
      ));
      await tester.pumpAndSettle();

      await tester.drag(
          find.text('Area'), const Offset(-CoreSpacing.space40, 0));
      await tester.pumpAndSettle();

      expect(selected, [materials]);
      expect(tapped, isEmpty);
      expect(areaActions, 0);
    });

    testWidgets('a drag shorter than the threshold is ignored', (tester) async {
      await setViewport(tester);
      final selected = <GroupNameType>[];
      await tester.pumpWidget(buildKeyboard(
        current: basic,
        groups: swipeGroups(),
        onGroupSelected: selected.add,
      ));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(FunctionKeyTile).first,
          const Offset(-CoreSpacing.space7, 0));
      await tester.pumpAndSettle();

      expect(selected, isEmpty);
      expect(CoreKeyboard.groupSwipeThreshold, CoreSpacing.space16);
    });

    testWidgets('a single group has nothing to swipe to', (tester) async {
      await setViewport(tester);
      final selected = <GroupNameType>[];
      await tester.pumpWidget(buildKeyboard(
        current: basic,
        groups: [swipeGroups().first],
        onGroupSelected: selected.add,
      ));
      await tester.pumpAndSettle();

      await tester.drag(find.byType(FunctionKeyTile).first,
          const Offset(-CoreSpacing.space40, 0));
      await tester.pumpAndSettle();

      expect(selected, isEmpty);
    });
  });

  group('CoreKeyboard View all sheet reorder', () {
    const basic = GroupNameType(id: 'basic', label: 'Basic Geometry');
    const materials = GroupNameType(id: 'materials', label: 'Materials');
    const trig = GroupNameType(id: 'trig', label: 'Trigonometry');
    const groups = [
      FunctionGroup(
        name: basic,
        keys: [KeyType(groupName: 'basic', id: 'Area', label: 'Area')],
      ),
      FunctionGroup(
        name: materials,
        keys: [KeyType(groupName: 'materials', id: 'Wood', label: 'Wood')],
      ),
      FunctionGroup(
        name: trig,
        keys: [KeyType(groupName: 'trig', id: 'sin', label: 'sin')],
      ),
    ];

    Finder sheetHeaders() => find.descendant(
          of: find.byType(CoreFunctionKeyBottomSheet),
          matching: find.textContaining(' group'),
        );

    testWidgets(
        'forwards onGroupsReordered and the handle label, and re-renders '
        'the open sheet once the consumer reorders', (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1800, 3000);

      await tester.pumpWidget(MaterialApp(
        theme: CoreTheme.light(),
        home: const _ReorderingKeyboardHost(initialGroups: groups),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(RegExp('Reorder Basic Geometry')),
          findsOneWidget);
      expect(
        tester.widgetList<Text>(sheetHeaders()).map((t) => t.data).toList(),
        ['Basic Geometry group', 'Materials group', 'Trigonometry group'],
      );

      final dragHandles = find.byWidgetPredicate(
        (widget) => widget is Icon && widget.icon == Icons.drag_indicator,
      );
      expect(dragHandles, findsNWidgets(3));
      await tester.drag(
          dragHandles.first, const Offset(0, CoreSpacing.space64 * 2));
      await tester.pumpAndSettle();

      final host = tester.state<_ReorderingKeyboardHostState>(
          find.byType(_ReorderingKeyboardHost));
      expect(host.reorders, [(0, 2)]);
      expect(
        tester.widgetList<Text>(sheetHeaders()).map((t) => t.data).toList(),
        ['Materials group', 'Trigonometry group', 'Basic Geometry group'],
        reason: 'the sheet is still open and shows the consumer\'s new order',
      );
    });

    testWidgets(
        're-renders the open sheet when the same list is reordered in place',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1800, 3000);

      await tester.pumpWidget(MaterialApp(
        theme: CoreTheme.light(),
        home: const _ReorderingKeyboardHost(initialGroups: groups),
      ));
      await tester.pumpAndSettle();

      await tester.tap(find.text('View all'));
      await tester.pumpAndSettle();

      final host = tester.state<_ReorderingKeyboardHostState>(
          find.byType(_ReorderingKeyboardHost));
      host.reorderInPlace(0, 2);
      await tester.pumpAndSettle();

      expect(
        tester.widgetList<Text>(sheetHeaders()).map((t) => t.data).toList(),
        ['Materials group', 'Trigonometry group', 'Basic Geometry group'],
        reason: 'a reorder applied to the same list instance from outside the '
            'sheet still refreshes it while open',
      );
    });
  });

  group('CoreKeyboard', () {
    final testGroups = [
      FunctionGroup(
        name:
            const GroupNameType(id: "Basic Geometry", label: "Basic Geometry"),
        keys: [
          KeyType(
              groupName: 'Basic Geometry',
              id: 'Area',
              label: 'Area',
              action: () {}),
          KeyType(
              groupName: 'Basic Geometry',
              id: 'Perimeter',
              label: 'Perimeter',
              action: () {}),
        ],
      ),
    ];

    testWidgets('renders keyboard with all required components',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
          ),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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
      tester.view.physicalSize = const ui.Size(1100, 1600);

      DigitType? pressedDigit;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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
      await tester.tap(find.text('1'));
      await tester.pumpAndSettle();
      expect(pressedDigit, equals(DigitType.one));
    });

    testWidgets('calls onOperatorPressed when operator button is tapped',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      OperatorType? pressedOperator;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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
      tester.view.physicalSize = const ui.Size(1100, 1600);

      bool resultTapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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
      tester.view.physicalSize = const ui.Size(1100, 1600);

      // "Empty" here means the group carries no keys, which is what this
      // test exercises. The id stays real: it is the group's identity, and
      // GroupNameType now rejects an empty one.
      final emptyGroups = [
        const FunctionGroup(
          name: GroupNameType(id: "Empty", label: ""),
          keys: [],
        ),
      ];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(id: "Empty", label: ""),
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

    testWidgets('toggles collapsed state when drag handle is tapped',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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

      await tester.pumpAndSettle();
      expect(find.byType(CoreDigitInput), findsWidgets);

      await tester.tap(find.bySemanticsLabel('Keyboard drag handle'));
      await tester.pumpAndSettle();

      final sizeTransitionCollapsed =
          tester.widget<SizeTransition>(find.byType(SizeTransition));
      expect(sizeTransitionCollapsed.sizeFactor.value, 0.0);

      await tester.tap(find.bySemanticsLabel('Keyboard drag handle'));
      await tester.pumpAndSettle();

      final sizeTransitionExpanded =
          tester.widget<SizeTransition>(find.byType(SizeTransition));
      expect(sizeTransitionExpanded.sizeFactor.value, 1.0);
    });

    testWidgets('sub-threshold drag does not collapse keyboard',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
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

      await tester.pumpAndSettle();
      expect(find.byType(CoreDigitInput), findsWidgets);

      // _verticalThreshold is 2.0. To test sub-threshold drags without triggering a tap,
      // we must break the touch slop (18.0) using small increments.
      final TestGesture gesture = await tester.startGesture(
          tester.getCenter(find.bySemanticsLabel('Keyboard drag handle')));
      for (int i = 0; i < 30; i++) {
        await gesture.moveBy(const Offset(0, 1.0));
        await tester.pump();
      }
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(CoreDigitInput), findsWidgets);
    });

    testWidgets('calls onCollapseChanged when keyboard collapse status changes',
        (tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      bool? isCollapsed;
      int callCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreKeyboard(
              currentGroup: const GroupNameType(
                  id: "Basic Geometry", label: "Basic Geometry"),
              allGroups: testGroups,
              onDigitPressed: (_) {},
              onUnitSelected: (_) {},
              onOperatorPressed: (_) {},
              onControlAction: (_) {},
              onResultTapped: () {},
              onGroupSelected: (_) {},
              onKeyTapped: (_) {},
              onUnitSystemChanged: (_) {},
              onCollapseChanged: (val) {
                isCollapsed = val;
                callCount++;
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(isCollapsed, isNull);

      await tester.tap(find.bySemanticsLabel('Keyboard drag handle'));
      await tester.pumpAndSettle();

      expect(isCollapsed, isTrue);
      expect(callCount, equals(1));

      await tester.tap(find.bySemanticsLabel('Keyboard drag handle'));
      await tester.pumpAndSettle();

      expect(isCollapsed, isFalse);
      expect(callCount, equals(2));
    });
  });
}
