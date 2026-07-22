import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class DateRangeSheetShowcaseScreen extends StatefulWidget {
  const DateRangeSheetShowcaseScreen({super.key});

  @override
  State<DateRangeSheetShowcaseScreen> createState() =>
      _DateRangeSheetShowcaseScreenState();
}

class _DateRangeSheetShowcaseScreenState
    extends State<DateRangeSheetShowcaseScreen> {
  DateRange? _lastPickedRange;

  String _formatDate(DateTime date) => '${date.year}-${date.month}-${date.day}';

  Future<void> _showSheet(BuildContext context) async {
    final range = await CoreDateRangeSheet.show(
      context: context,
      initialRange: _lastPickedRange,
    );
    if (range != null) {
      setState(() => _lastPickedRange = range);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        title: const Text('CoreDateRangeSheet Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Predefined ranges plus a custom start/end picker',
              style: typography.titleMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const SizedBox(height: CoreSpacing.space2),
            ElevatedButton(
              onPressed: () => _showSheet(context),
              child: const Text('Open date range sheet'),
            ),
            if (_lastPickedRange case final lastPickedRange?) ...[
              const SizedBox(height: CoreSpacing.space2),
              Text(
                'Last picked: ${_formatDate(lastPickedRange.start)} → '
                '${_formatDate(lastPickedRange.end)}',
                style: typography.bodyMediumRegular.copyWith(
                  color: colors.textBody,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
