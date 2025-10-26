import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class SelectButtonShowcaseScreen extends StatefulWidget {
  const SelectButtonShowcaseScreen({super.key});

  @override
  State<SelectButtonShowcaseScreen> createState() =>
      _SelectButtonShowcaseScreenState();
}

class _SelectButtonShowcaseScreenState
    extends State<SelectButtonShowcaseScreen> {
  int _selectedIndex = 0;
  int _selectedIndex2 = 1;
  int _selectedIndex3 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CoreTextColors.inverse,
      appBar: AppBar(
        title: const Text('Select Button Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Basic Example
            Text(
              'Basic Select Button',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            CoreSelectButton(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
              initialIndex: _selectedIndex,
              onChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: Tab ${_selectedIndex + 1}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Two Tabs Example
            Text(
              'Two Tabs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            CoreSelectButton(
              tabs: const ['Active', 'Inactive'],
              initialIndex: _selectedIndex2,
              onChanged: (index) {
                setState(() {
                  _selectedIndex2 = index;
                });
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: ${_selectedIndex2 == 0 ? 'Active' : 'Inactive'}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Multiple Tabs Example
            Text(
              'Multiple Tabs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            CoreSelectButton(
              tabs: const [
                'Overview',
                'Details',
                'Settings',
                'Advanced',
              ],
              initialIndex: _selectedIndex3,
              onChanged: (index) {
                setState(() {
                  _selectedIndex3 = index;
                });
              },
            ),
            const SizedBox(height: 8),
            Text(
              'Selected: ${[
                'Overview',
                'Details',
                'Settings',
                'Advanced'
              ][_selectedIndex3]}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 32),

            // Content Display Example
            Text(
              'Content Display',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            CoreSelectButton(
              tabs: const ['Profile', 'Settings', 'Notifications'],
              initialIndex: _selectedIndex,
              onChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 24),
            _buildContentForTab(_selectedIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildContentForTab(int index) {
    final contents = [
      'Profile Content - View and edit your profile information',
      'Settings Content - Manage your application settings',
      'Notifications Content - Configure your notification preferences',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
      child: Text(
        contents[index],
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
