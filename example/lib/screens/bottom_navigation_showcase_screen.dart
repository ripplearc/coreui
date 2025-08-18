import 'package:flutter/material.dart';
import 'package:core_ui/core_ui.dart';

class BottomNavigationShowcaseScreen extends StatefulWidget {
  const BottomNavigationShowcaseScreen({super.key});

  @override
  State<BottomNavigationShowcaseScreen> createState() =>
      _BottomNavigationShowcaseScreenState();
}

class _BottomNavigationShowcaseScreenState
    extends State<BottomNavigationShowcaseScreen> {
  int _index = 0;

  // Stable, compile-time list to avoid rebuilding tab configs every frame.
  static const List<BottomNavTab> _tabs = [
    BottomNavTab(icon: CoreIcons.home, label: 'Home'),
    BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
    BottomNavTab(icon: CoreIcons.cost, label: 'Estimation'),
    BottomNavTab(icon: CoreIcons.members, label: 'Members'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bottom Navigation Showcase')),
      body: IndexedStack(
        index: _index,
        children: const [
          _DemoPage(title: 'Home'),
          _DemoPage(title: 'Calculations'),
          _DemoPage(title: 'Estimation'),
          _DemoPage(title: 'Members'),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: CoreBottomNavBar(
          tabs: _tabs,
          selectedIndex: _index,
          onTabSelected: (i) => setState(() => _index = i),
          onActionButtonPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Action button pressed')),
            );
          },
        ),
      ),
    );
  }
}

class _DemoPage extends StatelessWidget {
  const _DemoPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Selected: $title',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
