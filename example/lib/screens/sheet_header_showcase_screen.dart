import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A showcase screen that shows [CoreSheetHeader] with and without a
/// subtitle, and opens it inside a [CoreQuickSheet].
class SheetHeaderShowcaseScreen extends StatelessWidget {
  const SheetHeaderShowcaseScreen({super.key});

  void _showBackTapped(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Back tapped')),
    );
  }

  Widget _section(BuildContext context, String title, Widget header) {
    final typography = Theme.of(context).coreTypography;

    return Padding(
      padding: const EdgeInsets.only(bottom: CoreSpacing.space6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
            child: Text(title, style: typography.bodyLargeSemiBold),
          ),
          const SizedBox(height: CoreSpacing.space2),
          header,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Sheet Header', style: typography.bodyLargeSemiBold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _section(
              context,
              'With a subtitle',
              CoreSheetHeader(
                title: 'Excavator',
                subtitle: 'Metered rate',
                backSemanticLabel: 'Back',
                onBack: () => _showBackTapped(context),
              ),
            ),
            _section(
              context,
              'Without a subtitle',
              CoreSheetHeader(
                title: 'Excavator',
                backSemanticLabel: 'Back',
                onBack: () => _showBackTapped(context),
              ),
            ),
            _section(
              context,
              'Long title: cut with an ellipsis',
              CoreSheetHeader(
                title: 'Hydraulic crawler excavator with a long reach boom',
                backSemanticLabel: 'Back',
                onBack: () => _showBackTapped(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CoreSpacing.space4,
              ),
              child: CoreButton(
                label: 'Open in a sheet',
                onPressed: () => CoreQuickSheet.show(
                  context: context,
                  child: Builder(
                    builder: (sheetContext) => Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CoreSheetHeader(
                          title: 'Excavator',
                          subtitle: 'Metered rate',
                          backSemanticLabel: 'Back',
                          onBack: () => Navigator.of(sheetContext).pop(),
                        ),
                        const SizedBox(height: CoreSpacing.space24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
