import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A filter chip for a date-range filter.
///
/// Renders a plain [CoreFilterChip] that opens a [CoreDateRangeSheet] when no
/// range is selected, or an active pill showing the selected range with a
/// clear × when one is. The chip is surface-agnostic: each caller supplies its
/// own [label], accessibility labels, and widget [Key]s so the same widget can
/// back any screen with a date filter without hardcoding its localization.
///
/// Callers that intend to widget-test the chip should supply both
/// [inactiveChipKey] and [activeChipKey]; without them the two chip variants
/// have no stable finder targets.
class CoreDateFilterChip extends StatelessWidget {
  /// The currently selected date range, or `null` if no filter is active.
  final DateRange? selectedDateRange;

  /// Called with the newly chosen range when the user applies a selection.
  final ValueChanged<DateRange> onApply;

  /// Called when the user taps the × to clear the active filter.
  final VoidCallback onClear;

  /// Label shown on the chip when no range is selected.
  final String label;

  /// Accessibility label for the chip when no range is selected.
  /// Defaults to [label] when null.
  final String? semanticLabel;

  /// Accessibility label for the active pill that clears the filter on tap.
  final String clearSemanticLabel;

  /// Formats the dates shown on the active pill. Defaults to a
  /// `"Jan 05, 2026"`-style English format.
  final String Function(DateTime date)? dateLabelBuilder;

  /// Title of the [CoreDateRangeSheet] the chip opens.
  final String sheetTitle;

  /// Label of the sheet option selecting today only.
  final String todayLabel;

  /// Label of the sheet option selecting the last 7 days.
  final String last7DaysLabel;

  /// Label of the sheet option selecting the last 30 days.
  final String last30DaysLabel;

  /// Label of the sheet option selecting the current month so far.
  final String thisMonthLabel;

  /// Label of the sheet option opening the custom start/end date pickers.
  final String customRangeLabel;

  /// Label of the date picker shown for the custom start date.
  final String startDateLabel;

  /// Label of the date picker shown for the custom end date.
  final String endDateLabel;

  /// Label of the sheet's Cancel button, also used by its date pickers.
  final String cancelLabel;

  /// Label of the sheet's Apply button.
  final String applyLabel;

  /// Confirm (OK) button label of the sheet's date pickers.
  final String confirmLabel;

  /// Key applied to the inactive chip (no range selected).
  final Key? inactiveChipKey;

  /// Key applied to the active pill (a range is selected).
  final Key? activeChipKey;

  /// Creates a [CoreDateFilterChip].
  const CoreDateFilterChip({
    super.key,
    required this.selectedDateRange,
    required this.onApply,
    required this.onClear,
    required this.label,
    this.semanticLabel,
    this.clearSemanticLabel = 'Clear date filter',
    this.dateLabelBuilder,
    this.sheetTitle = 'Date range',
    this.todayLabel = 'Today',
    this.last7DaysLabel = 'Last 7 days',
    this.last30DaysLabel = 'Last 30 days',
    this.thisMonthLabel = 'This month',
    this.customRangeLabel = 'Custom range',
    this.startDateLabel = 'Start date',
    this.endDateLabel = 'End date',
    this.cancelLabel = 'Cancel',
    this.applyLabel = 'Apply',
    this.confirmLabel = 'OK',
    this.inactiveChipKey,
    this.activeChipKey,
  });

  Future<void> _showSheet(BuildContext context) async {
    final range = await CoreDateRangeSheet.show(
      context: context,
      initialRange: selectedDateRange,
      title: sheetTitle,
      todayLabel: todayLabel,
      last7DaysLabel: last7DaysLabel,
      last30DaysLabel: last30DaysLabel,
      thisMonthLabel: thisMonthLabel,
      customRangeLabel: customRangeLabel,
      startDateLabel: startDateLabel,
      endDateLabel: endDateLabel,
      cancelLabel: cancelLabel,
      applyLabel: applyLabel,
      confirmLabel: confirmLabel,
    );
    if (range != null) {
      onApply(range);
    }
  }

  // English-only default; callers localise via [dateLabelBuilder].
  String _defaultDateLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    final day = date.day.toString().padLeft(2, '0');
    return '$month $day, ${date.year}';
  }

  String _formatRange(DateRange range) {
    final formatDate = dateLabelBuilder ?? _defaultDateLabel;
    final start = formatDate(range.start);
    if (range.start == range.end) return start;
    final end = formatDate(range.end);
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final range = selectedDateRange;

    if (range == null) {
      return CoreFilterChip(
        key: inactiveChipKey,
        label: label,
        semanticLabel: semanticLabel,
        onTap: () => _showSheet(context),
      );
    }

    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    // TODO: [CA-830] Replace this hand-built active pill with a chip-family
    // primitive (e.g. a CoreInputChip variant with whole-chip tap-to-remove).
    return Semantics(
      label: clearSemanticLabel,
      button: true,
      child: InkWell(
        key: activeChipKey,
        onTap: onClear,
        borderRadius: BorderRadius.circular(CoreSpacing.space3),
        child: Container(
          // Guarantee a 48dp-tall tap target to meet the Android/iOS minimum
          // tap-target accessibility guideline; the symmetric padding alone
          // leaves the pill shorter than 48dp.
          constraints: const BoxConstraints(minHeight: CoreSpacing.space12),
          padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: CoreSpacing.space2,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CoreSpacing.space3),
            color: colors.backgroundGrayMid,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Flexible + ellipsis keeps a long formatted range from
              // overflowing the pill on narrow screens (same treatment as
              // CoreInputChip's label).
              Flexible(
                child: ExcludeSemantics(
                  child: Text(
                    _formatRange(range),
                    overflow: TextOverflow.ellipsis,
                    style: typography.bodyMediumRegular.copyWith(
                      color: colors.textDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: CoreSpacing.space2),
              ExcludeSemantics(
                child: CoreIconWidget(
                  icon: CoreIcons.close,
                  color: colors.iconDark,
                  size: CoreSpacing.space4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
