import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class TabsShowcaseScreen extends StatefulWidget {
  const TabsShowcaseScreen({super.key});

  @override
  State<TabsShowcaseScreen> createState() => _TabsShowcaseScreenState();
}

class _TabsShowcaseScreenState extends State<TabsShowcaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tabs Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2 Tabs
            _buildTabsSection(
              title: '2 Tabs',
              tabs: ['Tab 1', 'Tab 2'],
            ),
            const SizedBox(height: 32),

            // 3 Tabs
            _buildTabsSection(
              title: '3 Tabs',
              tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
            ),
            const SizedBox(height: 32),

            // 4 Tabs
            _buildTabsSection(
              title: '4 Tabs',
              tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'],
            ),
            const SizedBox(height: 32),

            // 5 Tabs
            _buildTabsSection(
              title: '5 Tabs',
              tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabsSection({
    required String title,
    required List<String> tabs,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 12),
        // Show each tab as selected
        for (int i = 0; i < tabs.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: CoreTabs(
              tabs: tabs,
              initialIndex: i,
            ),
          ),
      ],
    );
  }
}
