import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreSelectButton', () {
    testWidgets('renders all tabs correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 0,
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });
    testWidgets('does not call onChanged when already-selected tab is tapped',
        (tester) async {
      bool called = false;
      await tester.pumpWidget(MaterialApp(
        theme: CoreTheme.light(),
        home: Scaffold(
          body: CoreSelectButton(
            tabs: const ['Tab 1', 'Tab 2'],
            selectedIndex: 0,
            onChanged: (_) => called = true,
          ),
        ),
      ));

      await tester.tap(find.text('Tab 1'));
      await tester.pumpAndSettle();

      expect(called, isFalse);
    });

    testWidgets('does not crash when selectedIndex is out of bounds',
        (tester) async {
      expect(
        () => tester.pumpWidget(MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
              body: CoreSelectButton(
            tabs: ['A', 'B'],
            selectedIndex: 5,
          )),
        )),
        throwsAssertionError,
      );
    });
    testWidgets('highlights selected tab via semantics',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 1,
            ),
          ),
        ),
      );

      final tab1Semantics = tester.getSemantics(find.text('Tab 1'));
      final tab2Semantics = tester.getSemantics(find.text('Tab 2'));

      expect(tab1Semantics.flagsCollection.isSelected, ui.Tristate.isFalse);
      expect(tab2Semantics.flagsCollection.isSelected, ui.Tristate.isTrue);
    });

    testWidgets('calls onChanged when tab is tapped',
        (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 0,
              onChanged: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));
    });

    testWidgets('handles single tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: ['Only Tab'],
              selectedIndex: 0,
            ),
          ),
        ),
      );

      expect(find.text('Only Tab'), findsOneWidget);
    });

    testWidgets('handles multiple tab selections', (WidgetTester tester) async {
      int selectedIndex = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return CoreSelectButton(
                  tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
                  selectedIndex: selectedIndex,
                  onChanged: (index) {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();
      expect(selectedIndex, equals(1));

      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();
      expect(selectedIndex, equals(2));

      await tester.tap(find.text('Tab 1'));
      await tester.pumpAndSettle();
      expect(selectedIndex, equals(0));
    });

    testWidgets('outer container uses design tokens for decoration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2'],
              selectedIndex: 0,
            ),
          ),
        ),
      );

      final outerContainer = tester.widget<Container>(
        find.byKey(const Key('core_select_button_outer')),
      );

      expect(outerContainer.decoration, isA<BoxDecoration>());

      final decoration = outerContainer.decoration as BoxDecoration;

      expect(
        decoration.borderRadius,
        equals(BorderRadius.circular(CoreSpacing.space12)),
      );
    });

    testWidgets('track is 40 high with a 32 high segment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Center(
              child: CoreSelectButton(
                tabs: ['Tab 1', 'Tab 2'],
                selectedIndex: 0,
              ),
            ),
          ),
        ),
      );

      final track = find.byKey(const Key('core_select_button_outer'));
      expect(tester.getSize(track).height, CoreSpacing.space10);

      Finder segment(int index) =>
          find.byKey(Key('core_select_button_segment_$index'));
      expect(tester.getSize(segment(0)).height, CoreSpacing.space8);
      expect(
        tester.getTopLeft(segment(1)).dx - tester.getTopRight(segment(0)).dx,
        CoreSpacing.space1,
      );
    });

    testWidgets('handles null onChanged callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2'],
              selectedIndex: 0,
              onChanged: null,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.byType(CoreSelectButton), findsOneWidget);

      final CoreSelectButton button =
          tester.widget(find.byType(CoreSelectButton));

      // Verifies the tap doesn't throw when onChanged is null.
      // selectedIndex stays 0 because this is a controlled widget with no setState.
      expect(button.selectedIndex, 0);
    });

    testWidgets('gives every segment a 48 dp tap target in the scroll view',
        (WidgetTester tester) async {
      final tabs = List.generate(6, (index) => 'Tab ${index + 1}');
      await tester.pumpWidget(
        buildTestApp(
          CoreSelectButton(tabs: tabs, selectedIndex: 0),
          theme: CoreTheme.light(),
        ),
      );

      for (var i = 0; i < tabs.length; i++) {
        final target = tester.getSize(
          find.byKey(CoreSelectButton.tapTargetKey(i)),
        );
        expect(target.height, greaterThanOrEqualTo(CoreSpacing.space12));
        expect(target.width, greaterThanOrEqualTo(CoreSpacing.space12));
      }
    });

    testWidgets('selects a segment from a tap just above the track',
        (WidgetTester tester) async {
      int? selected;
      await tester.pumpWidget(
        buildTestApp(
          CoreSelectButton(
            tabs: const ['Tab 1', 'Tab 2'],
            selectedIndex: 0,
            onChanged: (index) => selected = index,
          ),
          theme: CoreTheme.light(),
        ),
      );

      final track = tester.getRect(
        find.byKey(const Key('core_select_button_outer')),
      );
      final tab2 = tester.getCenter(find.text('Tab 2'));
      await tester.tapAt(Offset(tab2.dx, track.top - 2));

      expect(selected, 1);
    });

    testWidgets('fills a pressed segment with backgroundGrayMid',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSelectButton(tabs: const ['Tab 1', 'Tab 2'], selectedIndex: 0),
          theme: CoreTheme.light(),
        ),
      );

      final gesture = await tester.press(find.text('Tab 2'));
      await tester.pumpAndSettle();

      final segment = find.byKey(const Key('core_select_button_segment_1'));
      final decoration =
          tester.widget<AnimatedContainer>(segment).decoration as BoxDecoration;
      final colors = AppColorsExtension.of(tester.element(segment));
      expect(decoration.color, colors.backgroundGrayMid);
      await gesture.cancel();
    });

    testWidgets('draws the Tab focus as a border on the segment',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSelectButton(tabs: const ['Tab 1', 'Tab 2'], selectedIndex: 0),
          theme: CoreTheme.light(),
        ),
      );
      final segment = find.byKey(const Key('core_select_button_segment_1'));
      final restingSize = tester.getSize(segment);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      final decoration =
          tester.widget<AnimatedContainer>(segment).decoration as BoxDecoration;
      final colors = AppColorsExtension.of(tester.element(segment));
      expect(
        decoration.border,
        Border.all(color: colors.lineHighlight, width: 2),
      );
      expect(tester.getSize(segment), restingSize);
    });

    testWidgets('renders all tabs when many tabs provided',
        (WidgetTester tester) async {
      final tabs = List.generate(10, (index) => 'Tab ${index + 1}');

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: tabs,
              selectedIndex: 0,
            ),
          ),
        ),
      );

      for (int i = 0; i < tabs.length; i++) {
        expect(find.text(tabs[i]), findsOneWidget);
      }

      expect(
        find.descendant(
          of: find.byType(CoreSelectButton),
          matching: find.byWidgetPredicate(
            (w) =>
                w is SingleChildScrollView &&
                w.scrollDirection == Axis.horizontal,
          ),
        ),
        findsOneWidget,
      );
    });
  });
  group('CoreSelectButton - accessibility', () {
    const tabs = ['Tab 1', 'Tab 2', 'Tab 3'];

    testWidgets('exposes semantic label for selected and unselected tabs',
        (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreSelectButton(
            tabs: tabs,
            selectedIndex: 0,
          ),
          theme: CoreTheme.light(),
        ),
      );
      // The label is surfaced implicitly from the Text child since
      // CoreSelectButton's Semantics node does not set label explicitly.
      final selectedSemantics = tester.getSemantics(find.text('Tab 1'));
      expect(selectedSemantics.label, contains('Tab 1'));
      expect(selectedSemantics.flagsCollection.isSelected, ui.Tristate.isTrue);

      final unselectedSemantics = tester.getSemantics(find.text('Tab 2'));
      expect(unselectedSemantics.label, contains('Tab 2'));
      expect(
          unselectedSemantics.flagsCollection.isSelected, ui.Tristate.isFalse);
      expect(unselectedSemantics.flagsCollection.isButton, isTrue);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreSelectButton(
          tabs: tabs,
          selectedIndex: 0,
        ),
        find.text('Tab 2'),
      );
    });
  });
}
