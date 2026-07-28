import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

const List<BottomNavTab> _tabs = [
  BottomNavTab(icon: CoreIcons.home, label: 'Home'),
  BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
  BottomNavTab(icon: CoreIcons.cost, label: 'Estimation'),
  BottomNavTab(icon: CoreIcons.members, label: 'Members'),
];

const List<BottomNavTab> _tabs2 = [
  BottomNavTab(icon: CoreIcons.calculation, label: 'Calculations'),
  BottomNavTab(icon: CoreIcons.cost, label: 'Estimates'),
];

const List<BottomNavTab> _tabs3 = [
  BottomNavTab(icon: CoreIcons.home, label: 'Home'),
  BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
  BottomNavTab(icon: CoreIcons.cost, label: 'Estimation'),
];

class _Harness extends StatelessWidget {
  const _Harness({
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.create();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: const SizedBox.shrink(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: CoreBottomNavBar(
            tabs: _tabs,
            selectedIndex: selectedIndex,
            onTabSelected: (_) {},
            animationDuration: const Duration(milliseconds: 1),
            onActionButtonPressed: () {},
          ),
        ),
      ),
    );
  }
}

class _Harness2Tab extends StatelessWidget {
  const _Harness2Tab({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.create();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: const SizedBox.shrink(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: CoreBottomNavBar(
            tabs: _tabs2,
            selectedIndex: selectedIndex,
            onTabSelected: (_) {},
            animationDuration: const Duration(milliseconds: 1),
            onActionButtonPressed: () {},
          ),
        ),
      ),
    );
  }
}

class _Harness3Tab extends StatelessWidget {
  const _Harness3Tab({required this.selectedIndex});

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.create();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: colors.pageBackground,
        body: const SizedBox.shrink(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: CoreBottomNavBar(
            tabs: _tabs3,
            selectedIndex: selectedIndex,
            onTabSelected: (_) {},
            animationDuration: const Duration(milliseconds: 1),
            onActionButtonPressed: () {},
          ),
        ),
      ),
    );
  }
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await loadFonts();
  });

  testWidgets('CoreBottomNavBar ', (tester) async {
    await tester.pumpWidget(const _Harness(selectedIndex: 0));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreBottomNavBar),
      matchesGoldenFile('goldens/core_bottom_nav_bar_default.png'),
    );
  });

  testWidgets('CoreBottomNavBar 2-tab default', (tester) async {
    await tester.pumpWidget(const _Harness2Tab(selectedIndex: 0));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreBottomNavBar),
      matchesGoldenFile('goldens/core_bottom_nav_bar_2tab_default.png'),
    );
  });

  testWidgets('CoreBottomNavBar 3-tab default', (tester) async {
    await tester.pumpWidget(const _Harness3Tab(selectedIndex: 0));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(CoreBottomNavBar),
      matchesGoldenFile('goldens/core_bottom_nav_bar_3tab_default.png'),
    );
  });
}
