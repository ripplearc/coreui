// File: test/components/navigation/core_bottom_nav_bar_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';

const _tabs = <BottomNavTab>[
  BottomNavTab(icon: CoreIcons.home, label: 'Home'),
  BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
  BottomNavTab(icon: CoreIcons.cost, label: 'Estimation'),
  BottomNavTab(icon: CoreIcons.members, label: 'Members'),
];

const _tabs2 = <BottomNavTab>[
  BottomNavTab(icon: CoreIcons.calculation, label: 'Calculations'),
  BottomNavTab(icon: CoreIcons.cost, label: 'Estimates'),
];

class _Harness extends StatelessWidget {
  const _Harness({
    required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: CoreTheme.light(),
      home: Scaffold(
        body: Center(
          child: child,
        ),
      ),
    );
  }
}

Future<void> _mount(
  WidgetTester tester, {
  required int selectedIndex,
  VoidCallback? onAction,
  ValueChanged<int>? onTabSelected,
}) async {
  await tester.pumpWidget(
    _Harness(
      child: CoreBottomNavBar(
        tabs: _tabs,
        selectedIndex: selectedIndex,
        onTabSelected: onTabSelected ?? (_) {},
        onActionButtonPressed: onAction,
      ),
    ),
  );
  await tester.pump(); 
}

void main() {
  setUpAll(() async {
    try {
      await loadFonts();
    } catch (_) {}
  });

  group('CoreBottomNavBar – API contract', () {
    test('asserts on fewer than 2 tabs', () {
      expect(
        () => CoreBottomNavBar(
          tabs: const [BottomNavTab(icon: CoreIcons.home, label: 'Home')],
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
        throwsAssertionError,
      );
    });

    test('asserts on more than 4 tabs', () {
      expect(
        () => CoreBottomNavBar(
          tabs: List.filled(
            5,
            const BottomNavTab(icon: CoreIcons.home, label: 'Home'),
          ),
          selectedIndex: 0,
          onTabSelected: (_) {},
        ),
        throwsAssertionError,
      );
    });
  });

  group('CoreBottomNavBar – rendering', () {
    testWidgets('renders with CoreTheme.light() and shows only active label', (tester) async {
      await _mount(tester, selectedIndex: 0);

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Calculations'), findsNothing);
      expect(find.text('Estimation'), findsNothing);
      expect(find.text('Members'), findsNothing);
    });

    testWidgets('renders 4 tabs + trailing action button', (tester) async {
      await _mount(tester, selectedIndex: 0);

      expect(find.byType(CoreIconWidget), findsNWidgets(5));
    });

    testWidgets('2-tab: shows only active label', (tester) async {
      await tester.pumpWidget(
        _Harness(
          child: CoreBottomNavBar(
            tabs: _tabs2,
            selectedIndex: 0,
            onTabSelected: (_) {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Calculations'), findsOneWidget);
      expect(find.text('Estimates'), findsNothing);
    });

    testWidgets('2-tab: renders 2 tab icons + trailing action button', (tester) async {
      await tester.pumpWidget(
        _Harness(
          child: CoreBottomNavBar(
            tabs: _tabs2,
            selectedIndex: 0,
            onTabSelected: (_) {},
            onActionButtonPressed: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CoreIconWidget), findsNWidgets(3));
    });
  });

  group('CoreBottomNavBar – interactions', () {
    testWidgets('tapping a tab calls onTabSelected with correct index', (tester) async {
      int? tapped;
      await _mount(tester, selectedIndex: 0, onTabSelected: (i) => tapped = i);

      await tester.tap(find.byType(InkWell).at(2));
      await tester.pumpAndSettle();

      expect(tapped, 2);
    });

    testWidgets('trailing action button invokes callback', (tester) async {
      bool fired = false;
      await _mount(tester, selectedIndex: 0, onAction: () => fired = true);

      final trailing = find.byType(CoreIconWidget).last;
      await tester.tap(trailing);
      await tester.pumpAndSettle();

      expect(fired, isTrue);
    });

    testWidgets('2-tab: tapping second tab calls onTabSelected(1)', (tester) async {
      int? tapped;
      await tester.pumpWidget(
        _Harness(
          child: CoreBottomNavBar(
            tabs: _tabs2,
            selectedIndex: 0,
            onTabSelected: (i) => tapped = i,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(InkWell).at(1));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });
  });

  group('CoreBottomNavBar – accessibility', () {
    testWidgets(
        'meets tap target, label and contrast guidelines for tabs and action button', (tester) async {
      await setupA11yTest(tester);
      await _mount(tester, selectedIndex: 0);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreBottomNavBar(
          tabs: _tabs,
          selectedIndex: 0,
          onTabSelected: (_) {},
          onActionButtonPressed: null,
        ),
        find.byType(CoreBottomNavBar),
      );
    });

    testWidgets('2-tab: meets tap target, label and contrast guidelines', (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreBottomNavBar(
          tabs: _tabs2,
          selectedIndex: 0,
          onTabSelected: (_) {},
          onActionButtonPressed: null,
        ),
        find.byType(CoreBottomNavBar),
      );
    });
  });
}
