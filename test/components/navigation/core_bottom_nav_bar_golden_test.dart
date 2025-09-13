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

class _Harness extends StatelessWidget {
  const _Harness({
    required this.selectedIndex,
  });

  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
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
}
