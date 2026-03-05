import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class QuickSheetShowcaseScreen extends StatelessWidget {
  const QuickSheetShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        title: const Text('CoreQuickSheet Examples'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _showBasicSheet(context),
              child: const Text('Basic Bottom Sheet'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            ElevatedButton(
              onPressed: () => _showListSheet(context),
              child: const Text('List Bottom Sheet'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            ElevatedButton(
              onPressed: () => _showFormSheet(context),
              child: const Text('Form Bottom Sheet'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            ElevatedButton(
              onPressed: () => _showCustomColorSheet(context),
              child: const Text('Custom Background Sheet'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            ElevatedButton(
              onPressed: () => _showNonDismissibleSheet(context),
              child: const Text('Non-Dismissible Sheet'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            ElevatedButton(
              onPressed: () => _showSafeAreaSheet(context),
              child: const Text('Safe Area Sheet'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBasicSheet(BuildContext context) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();

    CoreQuickSheet.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome!',
              style: typography?.titleLargeMedium,
            ),
            const SizedBox(height: CoreSpacing.space4),
            Text(
              'This is a basic bottom sheet with minimal content.',
              style: typography?.bodyLargeMedium,
            ),
            const SizedBox(height: CoreSpacing.space6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Got it!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showListSheet(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = Theme.of(context).extension<AppTypographyExtension>();

    CoreQuickSheet.show(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(CoreSpacing.space6),
            child: Text(
              'Select an Option',
              style: typography?.titleLargeMedium,
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 25,
              itemBuilder: (context, index) => ListTile(
                leading: Icon(
                  Icons.check_circle_outline,
                  color: colors.iconBlue,
                ),
                title: Text('Option ${index + 1}'),
                subtitle: Text('Description for option ${index + 1}'),
                onTap: () {
                  Navigator.pop(context, 'Option ${index + 1}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFormSheet(BuildContext context) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();

    CoreQuickSheet.show(
      context: context,
      child: Padding(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Form',
              style: typography?.titleLargeMedium,
            ),
            const SizedBox(height: CoreSpacing.space6),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
            const TextField(
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: CoreSpacing.space6),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: CoreSpacing.space4),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, 'Submitted'),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomColorSheet(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = Theme.of(context).extension<AppTypographyExtension>();

    CoreQuickSheet.show(
      context: context,
      backgroundColor: colors.backgroundBlueLight,
      child: Padding(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.info_outline,
              size: 48,
              color: colors.iconBlue,
            ),
            const SizedBox(height: CoreSpacing.space4),
            Text(
              'Custom Background',
              style: typography?.titleLargeMedium,
            ),
            const SizedBox(height: CoreSpacing.space4),
            Text(
              'This sheet has a custom background color!',
              style: typography?.bodyLargeMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CoreSpacing.space6),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNonDismissibleSheet(BuildContext context) {
    final typography = Theme.of(context).extension<AppTypographyExtension>();

    CoreQuickSheet.show(
      context: context,
      isDismissible: false,
      enableDrag: false,
      child: Padding(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Important Message',
              style: typography?.titleLargeMedium,
            ),
            const SizedBox(height: CoreSpacing.space4),
            Text(
              'This sheet cannot be dismissed by tapping outside or dragging. You must click the button below.',
              style: typography?.bodyLargeMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CoreSpacing.space6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('I Understand'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSafeAreaSheet(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = Theme.of(context).extension<AppTypographyExtension>();

    CoreQuickSheet.show(
      context: context,
      useSafeArea: true,
      child: Padding(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.safety_check,
              size: 48,
              color: colors.iconGreen,
            ),
            const SizedBox(height: CoreSpacing.space4),
            Text(
              'Safe Area Sheet',
              style: typography?.titleLargeMedium,
            ),
            const SizedBox(height: CoreSpacing.space4),
            Text(
              'This sheet respects safe area insets, ensuring content is not obscured by device notches, home indicators, or rounded corners.',
              style: typography?.bodyLargeMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: CoreSpacing.space6),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
