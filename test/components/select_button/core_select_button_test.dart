import 'dart:ui';

import 'package:flutter/material.dart';
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
          home: const Scaffold(
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

    testWidgets('highlights selected tab via semantics',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 1,
            ),
          ),
        ),
      );

      final tab1Semantics = tester.getSemantics(find.text('Tab 1'));
      final tab2Semantics = tester.getSemantics(find.text('Tab 2'));

      expect(tab1Semantics.hasFlag(SemanticsFlag.isSelected), isFalse);
      expect(tab2Semantics.hasFlag(SemanticsFlag.isSelected), isTrue);
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
          home: const Scaffold(
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
          home: const Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2'],
              selectedIndex: 0,
            ),
          ),
        ),
      );

      final outerContainer = tester.widget<Container>(
        find.descendant(
          of: find.byType(CoreSelectButton),
          matching: find.byType(Container).first,
        ),
      );

      expect(outerContainer.decoration, isA<BoxDecoration>());

      final decoration = outerContainer.decoration as BoxDecoration;

      expect(
        decoration.borderRadius,
        equals(BorderRadius.circular(CoreSpacing.space12)),
      );
    });

    testWidgets('handles null onChanged callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
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

  group('CoreSelectButton – accessibility', () {
    const tabs = ['Tab 1', 'Tab 2', 'Tab 3'];

    testWidgets('exposes semantic label', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreSelectButton(
            tabs: tabs,
            selectedIndex: 0,
          ),
          theme: CoreTheme.light(),
        ),
      );
      final semantics = tester.getSemantics(find.text('Tab 1'));
      expect(semantics.label, contains('Tab 1'));

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreSelectButton(
          tabs: tabs,
          selectedIndex: 0,
        ),
        find.text('Tab 1'),
      );
    });
  });
}
