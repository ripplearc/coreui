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
              initialIndex: 0,
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('highlights initial selected tab', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
              initialIndex: 1,
            ),
          ),
        ),
      );

      final tab1Finder = find.text('Tab 1');
      final tab2Finder = find.text('Tab 2');

      expect(tab1Finder, findsOneWidget);
      expect(tab2Finder, findsOneWidget);

      final tab2Widget = tester.widget<Text>(tab2Finder);
      expect(tab2Widget.style!.fontWeight, equals(FontWeight.w600));
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
              initialIndex: 0,
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
              initialIndex: 0,
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
                  initialIndex: selectedIndex,
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

    testWidgets('renders with correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2'],
              initialIndex: 0,
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsWidgets);

      expect(find.byType(CoreSelectButton), findsOneWidget);
    });

    testWidgets('handles null onChanged callback', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSelectButton(
              tabs: ['Tab 1', 'Tab 2'],
              initialIndex: 0,
              onChanged: null,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(find.byType(CoreSelectButton), findsOneWidget);
    });

    testWidgets('scrolls horizontally with many tabs',
        (WidgetTester tester) async {
      final tabs = List.generate(10, (index) => 'Tab ${index + 1}');

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSelectButton(
              tabs: tabs,
              initialIndex: 0,
            ),
          ),
        ),
      );

      for (int i = 0; i < tabs.length; i++) {
        expect(find.text(tabs[i]), findsOneWidget);
      }
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
            initialIndex: 0,
          ),
          theme: CoreTheme.light(),
        ),
      );

      // Verify one tab exposes a semantic label
      final semantics = tester.getSemantics(find.text('Tab 1'));
      expect(semantics.label, contains('Tab 1'));

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreSelectButton(
          tabs: tabs,
          initialIndex: 0,
        ),
        find.text('Tab 1'),
      );
    });
  });
}
