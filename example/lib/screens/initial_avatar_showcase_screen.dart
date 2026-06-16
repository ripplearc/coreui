import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class InitialAvatarShowcaseScreen extends StatelessWidget {
  const InitialAvatarShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;

    Widget labeled(String label, Widget avatar) {
      return Row(
        children: [
          avatar,
          const SizedBox(width: CoreSpacing.space4),
          Expanded(
            child: Text(label, style: typography.bodyMediumRegular),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Initial Avatar', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Default (24×24)', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            labeled('John Doe', const CoreInitialAvatar(name: 'John Doe')),
            const SizedBox(height: CoreSpacing.space6),
            Text('Lowercase name', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            labeled(
              'floyd miles → F',
              const CoreInitialAvatar(name: 'floyd miles'),
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Single token', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            labeled('Madonna', const CoreInitialAvatar(name: 'Madonna')),
            const SizedBox(height: CoreSpacing.space6),
            Text('Empty name', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            labeled('(blank → empty circle)', const CoreInitialAvatar(name: '')),
            const SizedBox(height: CoreSpacing.space6),
            Text('Custom colors', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            labeled(
              'Green background + green initial',
              CoreInitialAvatar(
                name: 'Esther Howard',
                backgroundColor: colors.backgroundGreenLight,
                textColor: colors.iconGreen,
              ),
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text('Custom text style', style: typography.bodyLargeSemiBold),
            const SizedBox(height: CoreSpacing.space2),
            labeled(
              'Larger radius + bodyLargeSemiBold',
              CoreInitialAvatar(
                name: 'Savannah Nguyen',
                radius: 20,
                textStyle: typography.bodyLargeSemiBold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
