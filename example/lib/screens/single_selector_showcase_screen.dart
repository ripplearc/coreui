import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class SingleItemSelectorShowcaseScreen extends StatefulWidget {
  const SingleItemSelectorShowcaseScreen({super.key});

  @override
  State<SingleItemSelectorShowcaseScreen> createState() =>
      _SingleItemSelectorShowcaseScreenState();
}

class _SingleItemSelectorShowcaseScreenState extends State<SingleItemSelectorShowcaseScreen> {
  final List<String> _roles = ['Engineer', 'Designer', 'Manager'];
  String? _selectedRole;
  String? _selectedRoleDisabled = 'Manager';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Single Item Selector', style: CoreTypography.bodyLargeSemiBold()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Default (no selection)', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Choose a Role',
              items: _roles,
              selectedItem: null,
              onItemSelected: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 24),

            Text('Selected', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Choose a Role',
              items: _roles,
              selectedItem: _selectedRole,
              onItemSelected: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            const SizedBox(height: 24),

            Text('Disabled', style: CoreTypography.bodyLargeSemiBold()),
            const SizedBox(height: 8),
            SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Choose a Role',
              items: _roles,
              selectedItem: _selectedRoleDisabled,
              isDisabled: true,
              onItemSelected: (_) {},
            ),
          ],
        ),
      ),
    );
  }
}
