import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  final theme = CoreTheme.light();
  final typography = theme.extension<AppTypographyExtension>()!;

  group('CoreTabs Widget Tests', () {
    testWidgets('does not call onChanged on initial render', (tester) async {
      bool called = false;
      await tester.pumpWidget(MaterialApp(
        theme: theme,
        home: Scaffold(
            body: CoreTabs(
          tabs: ['A', 'B'],
          onChanged: (_) => called = true,
        )),
      ));
      await tester.pumpAndSettle();
      expect(called, isFalse);
    });

    testWidgets('renders tabs correctly with initial index',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreTabs(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 0,
            ),
          ),
        ),
      );

      expect(find.byType(CoreTabs), findsOneWidget);
      expect(find.byType(TabBar), findsOneWidget);

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('renders with 2 tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreTabs(
              tabs: ['Tab 1', 'Tab 2'],
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
    });

    testWidgets('renders with 5 tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreTabs(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
      expect(find.text('Tab 4'), findsOneWidget);
      expect(find.text('Tab 5'), findsOneWidget);
    });

    testWidgets('respects selectedIndex parameter',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreTabs(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 1,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final tabBarFinder = find.byType(TabBar);
      expect(tabBarFinder, findsOneWidget);

      final tabBar = tester.widget<TabBar>(tabBarFinder);

      final controller = tabBar.controller;

      expect(controller, isNotNull);
      expect(controller!.index, equals(1));
    });

    testWidgets('updates labels when tab content changes with same count',
        (tester) async {
      List<String> tabs = ['Home', 'Profile'];
      await tester.pumpWidget(MaterialApp(
        theme: CoreTheme.light(),
        home: StatefulBuilder(builder: (context, setState) {
          return Scaffold(
              body: Column(children: [
            CoreTabs(tabs: tabs),
            ElevatedButton(
              onPressed: () => setState(() => tabs = ['Feed', 'Search']),
              child: const Text('Swap'),
            ),
          ]));
        }),
      ));
      expect(find.text('Home'), findsOneWidget);
      await tester.tap(find.text('Swap'));
      await tester.pumpAndSettle();
      expect(find.text('Feed'), findsOneWidget);
      expect(find.text('Home'), findsNothing);
    });

    testWidgets('updates when tabs list changes', (WidgetTester tester) async {
      List<String> tabs = ['Tab 1', 'Tab 2'];

      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    CoreTabs(tabs: tabs),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          tabs = ['Tab A', 'Tab B', 'Tab C'];
                        });
                      },
                      child: const Text('Update'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab C'), findsNothing);

      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      expect(find.text('Tab A'), findsOneWidget);
      expect(find.text('Tab B'), findsOneWidget);
      expect(find.text('Tab C'), findsOneWidget);
      expect(find.text('Tab 1'), findsNothing);
      expect(find.text('Tab 2'), findsNothing);
    });

    testWidgets('applies correct label styles to TabBar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreTabs(
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: 0,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));

      expect(
        tabBar.labelStyle,
        equals(typography.bodyMediumSemiBold),
      );

      expect(
        tabBar.unselectedLabelStyle,
        equals(typography.bodyMediumRegular),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Accessibility Tests
  // ---------------------------------------------------------------------------

  group('CoreTabs – accessibility', () {
    const tabs = ['Home', 'Profile', 'Settings'];

    testWidgets('exposes semantic label', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreTabs(
            tabs: tabs,
            selectedIndex: 0,
          ),
          theme: theme,
        ),
      );
      final semantics = tester.getSemantics(find.text('Home'));
      expect(semantics.label, contains('Home'));

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreTabs(
          tabs: tabs,
          selectedIndex: 0,
        ),
        find.text('Home'),
      );
    });
  });
}
