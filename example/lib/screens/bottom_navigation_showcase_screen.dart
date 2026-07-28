import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class BottomNavigationShowcaseScreen extends StatefulWidget {
  const BottomNavigationShowcaseScreen({super.key});

  @override
  State<BottomNavigationShowcaseScreen> createState() =>
      _BottomNavigationShowcaseScreenState();
}

class _BottomNavigationShowcaseScreenState
    extends State<BottomNavigationShowcaseScreen> {
  final _twoTabIndex = ValueNotifier(0);
  final _threeTabIndex = ValueNotifier(0);
  final _fourTabIndex = ValueNotifier(0);
  final _withActionIndex = ValueNotifier(0);

  static const _twoTabs = [
    BottomNavTab(icon: CoreIcons.calculation, label: 'Calculations'),
    BottomNavTab(icon: CoreIcons.cost, label: 'Estimates'),
  ];

  static const _threeTabs = [
    BottomNavTab(icon: CoreIcons.calculation, label: 'Calculations'),
    BottomNavTab(icon: CoreIcons.cost, label: 'Estimates'),
    BottomNavTab(icon: CoreIcons.members, label: 'Members'),
  ];

  static const _fourTabs = [
    BottomNavTab(icon: CoreIcons.home, label: 'Home'),
    BottomNavTab(icon: CoreIcons.calculate, label: 'Calculations'),
    BottomNavTab(icon: CoreIcons.cost, label: 'Estimation'),
    BottomNavTab(icon: CoreIcons.members, label: 'Members'),
  ];

  @override
  void dispose() {
    _twoTabIndex.dispose();
    _threeTabIndex.dispose();
    _fourTabIndex.dispose();
    _withActionIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bottom Navigation Showcase')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              context: context,
              title: '2 Tabs',
              notifier: _twoTabIndex,
              tabs: _twoTabs,
            ),
            const SizedBox(height: CoreSpacing.space8),
            _buildSection(
              context: context,
              title: '3 Tabs',
              notifier: _threeTabIndex,
              tabs: _threeTabs,
            ),
            const SizedBox(height: CoreSpacing.space8),
            _buildSection(
              context: context,
              title: '4 Tabs',
              notifier: _fourTabIndex,
              tabs: _fourTabs,
            ),
            const SizedBox(height: CoreSpacing.space8),
            _buildSection(
              context: context,
              title: '4 Tabs + Action Button',
              notifier: _withActionIndex,
              tabs: _fourTabs,
              onActionButtonPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Action button pressed')),
                );
              },
            ),
            const SizedBox(height: CoreSpacing.space8),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required BuildContext context,
    required String title,
    required ValueNotifier<int> notifier,
    required List<BottomNavTab> tabs,
    VoidCallback? onActionButtonPressed,
  }) {
    final typography = AppTypographyExtension.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: typography.bodyLargeSemiBold),
        const SizedBox(height: CoreSpacing.space3),
        ValueListenableBuilder<int>(
          valueListenable: notifier,
          builder: (context, index, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SafeArea(
                    bottom: false,
                    child: CoreBottomNavBar(
                      tabs: tabs,
                      selectedIndex: index,
                      onTabSelected: (i) => notifier.value = i,
                      onActionButtonPressed: onActionButtonPressed,
                    ),
                  ),
                ),
                const SizedBox(height: CoreSpacing.space3),
                Text(
                  'Selected: ${tabs[index].label}',
                  style: typography.bodyMediumMedium,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
