import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class DateFilterChipShowcaseScreen extends StatefulWidget {
  const DateFilterChipShowcaseScreen({super.key});

  @override
  State<DateFilterChipShowcaseScreen> createState() =>
      _DateFilterChipShowcaseScreenState();
}

class _DateFilterChipShowcaseScreenState
    extends State<DateFilterChipShowcaseScreen> {
  DateRange? _selectedRange;
  DateRange? _customLabelRange;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        title: const Text('CoreDateFilterChip Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Default – tap to pick a range, tap the pill to clear',
              style: typography.titleMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const SizedBox(height: CoreSpacing.space2),
            CoreDateFilterChip(
              selectedDateRange: _selectedRange,
              label: 'Modified',
              onApply: (range) => setState(() => _selectedRange = range),
              onClear: () => setState(() => _selectedRange = null),
            ),
            const SizedBox(height: CoreSpacing.space6),
            Text(
              'Custom dateLabelBuilder – day/month/year pill format',
              style: typography.titleMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const SizedBox(height: CoreSpacing.space2),
            CoreDateFilterChip(
              selectedDateRange: _customLabelRange,
              label: 'Created',
              dateLabelBuilder: (date) =>
                  '${date.day}/${date.month}/${date.year}',
              onApply: (range) => setState(() => _customLabelRange = range),
              onClear: () => setState(() => _customLabelRange = null),
            ),
          ],
        ),
      ),
    );
  }
}
