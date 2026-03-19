import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class TabsShowcaseScreen extends StatelessWidget {
  TabsShowcaseScreen({super.key});

  final ValueNotifier<int> selectedTab = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInteractiveTabs(context),
            const SizedBox(height: CoreSpacing.space8),
            _buildTabsSection(
              context: context,
              title: '2 Tabs',
              tabs: const ['Tab 1', 'Tab 2'],
            ),
            const SizedBox(height: CoreSpacing.space8),
            _buildTabsSection(
              context: context,
              title: '3 Tabs',
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
            ),
            const SizedBox(height: CoreSpacing.space8),
            _buildTabsSection(
              context: context,
              title: '4 Tabs',
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'],
            ),
            const SizedBox(height: CoreSpacing.space8),
            _buildTabsSection(
              context: context,
              title: '5 Tabs',
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveTabs(BuildContext context) {
    final typography = AppTypographyExtension.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Interactive Example',
          style: typography.bodyLargeSemiBold,
        ),
        const SizedBox(height: CoreSpacing.space3),
        ValueListenableBuilder<int>(
          valueListenable: selectedTab,
          builder: (context, index, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CoreTabs(
                  tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
                  selectedIndex: index,
                  onChanged: (i) => selectedTab.value = i,
                ),
                const SizedBox(height: CoreSpacing.space3),
                Text(
                  'Selected: Tab ${index + 1}',
                  style: typography.bodyMediumMedium,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTabsSection({
    required BuildContext context,
    required String title,
    required List<String> tabs,
  }) {
    final typography = AppTypographyExtension.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: typography.bodyLargeSemiBold,
        ),
        const SizedBox(height: CoreSpacing.space3),
        Padding(
          padding: const EdgeInsets.only(bottom: CoreSpacing.space4),
          child: CoreTabs(
            tabs: tabs,
          ),
        ),
      ],
    );
  }
}
