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
  int _selectedIndex4 = 0;
  static const _multipleTabs = ['Overview', 'Details', 'Settings', 'Advanced'];

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
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Select Button',
              style: typography.titleMediumSemiBold,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreSelectButton(
              tabs: const ['Tab 1', 'Tab 2', 'Tab 3'],
              selectedIndex: _selectedIndex,
              onChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: CoreSpacing.space2),
            Text(
              'Selected: Tab ${_selectedIndex + 1}',
              style: typography.bodyMediumRegular,
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text(
              'Two Tabs',
              style: typography.titleMediumSemiBold,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreSelectButton(
              tabs: const ['Active', 'Inactive'],
              selectedIndex: _selectedIndex2,
              onChanged: (index) {
                setState(() {
                  _selectedIndex2 = index;
                });
              },
            ),
            const SizedBox(height: CoreSpacing.space2),
            Text(
              'Selected: ${_selectedIndex2 == 0 ? 'Active' : 'Inactive'}',
              style: typography.bodyMediumRegular,
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text(
              'Multiple Tabs',
              style: typography.titleMediumSemiBold,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreSelectButton(
              tabs: _multipleTabs,
              selectedIndex: _selectedIndex3,
              onChanged: (index) {
                setState(() {
                  _selectedIndex3 = index;
                });
              },
            ),
            const SizedBox(height: CoreSpacing.space2),
            Text(
              'Selected: ${_multipleTabs[_selectedIndex3]}',
              style: typography.bodyMediumRegular,
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text(
              'Content Display',
              style: typography.titleMediumSemiBold,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreSelectButton(
              tabs: const ['Profile', 'Settings', 'Notifications'],
              selectedIndex: _selectedIndex4,
              onChanged: (index) {
                setState(() {
                  _selectedIndex4 = index;
                });
              },
            ),
            const SizedBox(height: CoreSpacing.space6),
            _buildContentForTab(_selectedIndex4),
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
      padding: const EdgeInsets.all(CoreSpacing.space4),
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: BorderRadius.circular(CoreSpacing.space2),
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
