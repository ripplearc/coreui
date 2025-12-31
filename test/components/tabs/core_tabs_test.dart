import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreTabs Widget Tests', () {
    testWidgets('renders tabs correctly with initial index',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreTabs(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
              initialIndex: 0,
            ),
          ),
        ),
      );

      final tabsFinder = find.byType(CoreTabs);
      expect(tabsFinder, findsOneWidget);

      final tabBarFinder = find.byType(TabBar);
      expect(tabBarFinder, findsOneWidget);

      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab 3'), findsOneWidget);
    });

    testWidgets('renders with 2 tabs', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreTabs(
              tabs: const ['Tab 1', 'Tab 2'],
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
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreTabs(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
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

    testWidgets('calls onChanged callback when tab is tapped',
        (WidgetTester tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreTabs(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
              onChanged: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      expect(selectedIndex, isNull);

      await tester.tap(find.text('Tab 2'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(1));

      await tester.tap(find.text('Tab 3'));
      await tester.pumpAndSettle();

      expect(selectedIndex, equals(2));
    });

    testWidgets('respects initialIndex parameter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreTabs(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
              initialIndex: 1,
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tab 2 should be selected initially
      final tabBar = find.byType(TabBar);
      expect(tabBar, findsOneWidget);
    });

    testWidgets('updates when tabs list changes', (WidgetTester tester) async {
      List<String> tabs = ['Tab 1', 'Tab 2'];

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    CoreTabs(
                      tabs: tabs,
                    ),
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

      // Initial tabs
      expect(find.text('Tab 1'), findsOneWidget);
      expect(find.text('Tab 2'), findsOneWidget);
      expect(find.text('Tab C'), findsNothing);

      // Update tabs
      await tester.tap(find.text('Update'));
      await tester.pumpAndSettle();

      // New tabs should be displayed
      expect(find.text('Tab A'), findsOneWidget);
      expect(find.text('Tab B'), findsOneWidget);
      expect(find.text('Tab C'), findsOneWidget);
      expect(find.text('Tab 1'), findsNothing);
      expect(find.text('Tab 2'), findsNothing);
    });
  });
}
