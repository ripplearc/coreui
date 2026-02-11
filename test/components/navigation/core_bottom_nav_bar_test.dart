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
    testWidgets('asserts exactly 4 tabs', (tester) async {
      expect(
        () => CoreBottomNavBar(
          tabs: const [BottomNavTab(icon: CoreIcons.home, label: 'Home')],
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
  });

  group('CoreBottomNavBar – accessibility', () {
    testWidgets(
        'meets tap target, label and contrast guidelines for tabs and action button', (tester) async {
      await setupA11yTest(tester);
      await _mount(tester, selectedIndex: 0);

      await tester.pumpAndSettle();

      await expectMeetsTapTargetAndLabelGuidelines(
        tester,
        find.byType(CoreBottomNavBar),
      );
    });
  });
}
