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
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        title: const Text('Select Button Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Select Button',
              style: typography.titleMediumSemiBold,
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
              style: typography.bodyMediumRegular,
            ),
            const SizedBox(height: 32),
            Text(
              'Two Tabs',
              style: typography.titleMediumSemiBold,
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
              style: typography.bodyMediumRegular,
            ),
            const SizedBox(height: 32),
            Text(
              'Multiple Tabs',
              style: typography.titleMediumSemiBold,
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
              style: typography.bodyMediumRegular,
            ),
            const SizedBox(height: 32),
            Text(
              'Content Display',
              style: typography.titleMediumSemiBold,
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
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final contents = [
      'Profile Content - View and edit your profile information',
      'Settings Content - Manage your application settings',
      'Notifications Content - Configure your notification preferences',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colors.lineLight,
        ),
      ),
      child: Text(
        contents[index],
        style: typography.bodyMediumRegular,
      ),
    );
  }
}
