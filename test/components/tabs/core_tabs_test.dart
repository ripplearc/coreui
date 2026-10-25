import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/pixel_reader.dart';
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

    testWidgets('uses the library divider colour and a 4px gap',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreTabs(tabs: ['Tab 1', 'Tab 2'], selectedIndex: 0),
          ),
        ),
      );

      await tester.pumpAndSettle();

      final tabBar = tester.widget<TabBar>(find.byType(TabBar));
      expect(tabBar.dividerColor, theme.coreColors.lineDarkOutline);

      final first = tester.getRect(find.widgetWithText(Tab, 'Tab 1'));
      final second = tester.getRect(find.widgetWithText(Tab, 'Tab 2'));
      // 12 side padding on each tab plus the 4 gap.
      expect(
        second.left - first.right,
        CoreSpacing.space3 * 2 + CoreSpacing.space1,
      );
    });
    testWidgets('draws a square-ended indicator as wide as the selected tab',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CoreTabs(tabs: ['Tab 1', 'Tab 2'], selectedIndex: 0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final bar = tester.getRect(find.byType(TabBar));
      final tab = tester.getRect(find.widgetWithText(Tab, 'Tab 1'));
      // A line, not a rounded rect, so the ends are square. It spans
      // 12 + label + 12, not the 4px gap after it.
      final left = tab.left - CoreSpacing.space3 - bar.left;
      final right = tab.right + CoreSpacing.space3 - bar.left;
      const halfWidth = CoreSpacing.space1 / 2;
      final y = bar.height - halfWidth;

      expect(
        find.byType(TabBar),
        paints
          ..line(color: theme.coreColors.lineDarkOutline)
          ..line(
            p1: Offset(left + halfWidth, y),
            p2: Offset(right - halfWidth, y),
            color: theme.coreColors.tabsHighlight,
            strokeWidth: CoreSpacing.space1,
          ),
      );
    });

    testWidgets('each 40dp tab sits in a 48dp tap area',
        (WidgetTester tester) async {
      final selected = <int>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: CoreTabs(
              tabs: const ['Tab 1', 'Tab 2'],
              onChanged: selected.add,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final tab = tester.getRect(find.widgetWithText(Tab, 'Tab 2'));
      final target = tester.getRect(
        find.ancestor(of: find.text('Tab 2'), matching: find.byType(InkWell)),
      );
      expect(tab.height, CoreSpacing.space10);
      expect(target.height, greaterThanOrEqualTo(CoreSpacing.space12));
      expect(tab.bottom, target.bottom);

      await tester.tapAt(Offset(tab.center.dx, target.top + 1));
      await tester.pumpAndSettle();
      expect(selected, [1]);
    });
  });

  group('CoreTabs – press and focus', () {
    const boundaryKey = Key('tabs_boundary');
    const parentColor = Color(0xFFFFE0B2);
    final colors = theme.coreColors;

    Future<void> pumpTabs(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: boundaryKey,
                child: Container(
                  color: parentColor,
                  child: const CoreTabs(tabs: ['Tab 1', 'Tab 2']),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<Color> pixel(WidgetTester tester, Offset point) =>
        pixelAt(tester, find.byKey(boundaryKey), point);

    Rect faceOf(WidgetTester tester, int index) =>
        tester.getRect(find.byKey(CoreTabs.tabKey(index)));

    testWidgets('fills only the 40 dp face of a pressed tab, also inside a '
        'coloured parent', (WidgetTester tester) async {
      await pumpTabs(tester);
      final face = faceOf(tester, 1);
      expect(face.height, CoreSpacing.space10);

      final gesture = await tester.startGesture(face.center);
      await tester.pumpAndSettle();

      final inFace = Offset(face.left + 4, face.top + 4);
      final aboveFace = Offset(face.left + 4, face.top - 4);
      expect(await pixel(tester, inFace), colors.backgroundGrayMid);
      expect(await pixel(tester, aboveFace), parentColor);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(await pixel(tester, inFace), parentColor);
    });

    testWidgets('a pressed selected tab keeps its underline',
        (WidgetTester tester) async {
      await pumpTabs(tester);
      final face = faceOf(tester, 0);

      final gesture = await tester.startGesture(face.center);
      await tester.pumpAndSettle();

      final onLine = Offset(face.center.dx, face.bottom - 2);
      expect(await pixel(tester, onLine), colors.tabsHighlight);
      await gesture.up();
    });

    testWidgets('Tab draws a 2 dp outlineFocus ring on the face',
        (WidgetTester tester) async {
      await pumpTabs(tester);

      for (final index in [0, 1]) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();
        final face = faceOf(tester, index);

        expect(
          await pixel(tester, Offset(face.left + 1, face.center.dy)),
          colors.outlineFocus,
        );
        expect(
          await pixel(tester, Offset(face.left + 3, face.center.dy)),
          parentColor,
        );
        expect(
          await pixel(tester, Offset(face.left + 4, face.top - 4)),
          parentColor,
        );
        expect(tester.getRect(find.byKey(CoreTabs.tabKey(index))), face);
      }
    });

    testWidgets('a touch tap draws no focus ring', (WidgetTester tester) async {
      await pumpTabs(tester);
      final face = faceOf(tester, 1);

      await tester.tap(find.byKey(CoreTabs.tabKey(1)));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(CoreTabs.tabKey(1)));
      await tester.pumpAndSettle();

      expect(
        await pixel(tester, Offset(face.left + 1, face.center.dy)),
        parentColor,
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
