import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class CheckRowItemShowcaseScreen extends StatefulWidget {
  const CheckRowItemShowcaseScreen({super.key});

  @override
  State<CheckRowItemShowcaseScreen> createState() =>
      _CheckRowItemShowcaseScreenState();
}

class _CheckRowItemShowcaseScreenState
    extends State<CheckRowItemShowcaseScreen> {
  final Set<String> _selectedOwners = {'John Doe'};
  bool _customLeadingSelected = false;
  bool _customAvatarColorsSelected = false;

  static const _owners = [
    'John Doe',
    'Floyd Miles',
    'Marvin McKinney',
    'Esther Howard',
  ];

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Check Row Item', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Owner list (default avatar)',
                style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            for (final owner in _owners)
              CoreCheckRowItem(
                title: owner,
                selected: _selectedOwners.contains(owner),
                onChanged: (value) {
                  setState(() {
                    if (value) {
                      _selectedOwners.add(owner);
                    } else {
                      _selectedOwners.remove(owner);
                    }
                  });
                },
              ),
            const SizedBox(height: CoreSpacing.space6),
            Text('With subtitle', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            CoreCheckRowItem(
              title: 'Savannah Nguyen',
              subtitle: 'savannah@acme.com',
              selected: _selectedOwners.contains('Savannah Nguyen'),
              onChanged: (value) {
                setState(() {
                  if (value) {
                    _selectedOwners.add('Savannah Nguyen');
                  } else {
                    _selectedOwners.remove('Savannah Nguyen');
                  }
                });
              },
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Custom avatar colors', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            CoreCheckRowItem(
              title: 'Leslie Alexander',
              avatarBackgroundColor:
                  Theme.of(context).coreColors.backgroundGreenLight,
              avatarTextColor: Theme.of(context).coreColors.iconGreen,
              selected: _customAvatarColorsSelected,
              onChanged: (value) =>
                  setState(() => _customAvatarColorsSelected = value),
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Custom leading widget', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            CoreCheckRowItem(
              title: 'Darrell Steward',
              leading: CoreAvatar(
                radius: 12,
                backgroundColor: Theme.of(context).coreColors.iconBlue,
                child: CoreIconWidget(
                  icon: CoreIcons.person,
                  size: CoreIconSize.size16,
                  color: Theme.of(context).coreColors.iconWhite,
                ),
              ),
              selected: _customLeadingSelected,
              onChanged: (value) =>
                  setState(() => _customLeadingSelected = value),
            ),
          ],
        ),
      ),
    );
  }
}
