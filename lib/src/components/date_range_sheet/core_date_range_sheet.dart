import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// The selectable options of a [CoreDateRangeSheet].
enum _PredefinedRange {
  /// Today only (start == end == today).
  today,

  /// The last 7 days, ending today.
  last7Days,

  /// The last 30 days, ending today.
  last30Days,

  /// From the 1st of the current month through today.
  thisMonth,

  /// A user-picked start/end chosen via two [CoreDatePicker]s.
  custom,
}

/// A modal bottom sheet for picking a date range.
///
/// Offers predefined ranges (today, last 7/30 days, this month) plus a
/// Custom range option that opens [CoreDatePicker] twice — once for the
/// start date, once for the end date — since [CoreDatePicker] only selects a
/// single date. The sheet owns no external state: it resolves with the chosen
/// [DateRange], or `null` if the user cancels/dismisses.
///
/// All user-visible strings are English by default and can be overridden via
/// the label parameters for localization.
class CoreDateRangeSheet extends StatefulWidget {
  /// The range already applied when the sheet opens, if any.
  final DateRange? initialRange;

  /// Title shown at the top of the sheet.
  final String title;

  /// Label of the option selecting today only.
  final String todayLabel;

  /// Label of the option selecting the last 7 days.
  final String last7DaysLabel;

  /// Label of the option selecting the last 30 days.
  final String last30DaysLabel;

  /// Label of the option selecting the current month so far.
  final String thisMonthLabel;

  /// Label of the option opening the custom start/end date pickers.
  final String customRangeLabel;

  /// Label of the [CoreDatePicker] shown for the custom start date.
  final String startDateLabel;

  /// Label of the [CoreDatePicker] shown for the custom end date.
  final String endDateLabel;

  /// Label of the Cancel button, also forwarded to the custom-range
  /// [CoreDatePicker]s.
  final String cancelLabel;

  /// Label of the Apply button.
  final String applyLabel;

  /// Confirm (OK) button label of the custom-range [CoreDatePicker]s.
  final String confirmLabel;

  /// Overrides "today" for testing; defaults to [DateTime.now].
  final DateTime? today;

  /// Creates a [CoreDateRangeSheet].
  const CoreDateRangeSheet({
    super.key,
    this.initialRange,
    this.title = 'Date range',
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
    this.today,
  });

  /// Shows [CoreDateRangeSheet] inside a [CoreQuickSheet] and resolves with
  /// the chosen [DateRange], or `null` if the user cancels/dismisses.
  static Future<DateRange?> show({
    required BuildContext context,
    DateRange? initialRange,
    String title = 'Date range',
    String todayLabel = 'Today',
    String last7DaysLabel = 'Last 7 days',
    String last30DaysLabel = 'Last 30 days',
    String thisMonthLabel = 'This month',
    String customRangeLabel = 'Custom range',
    String startDateLabel = 'Start date',
    String endDateLabel = 'End date',
    String cancelLabel = 'Cancel',
    String applyLabel = 'Apply',
    String confirmLabel = 'OK',
    DateTime? today,
  }) {
    return CoreQuickSheet.show<DateRange?>(
      context: context,
      child: CoreDateRangeSheet(
        initialRange: initialRange,
        title: title,
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
        today: today,
      ),
    );
  }

  @override
  State<CoreDateRangeSheet> createState() => _CoreDateRangeSheetState();
}

class _CoreDateRangeSheetState extends State<CoreDateRangeSheet> {
  late _PredefinedRange _selected;
  DateTime? _customStart;
  DateTime? _customEnd;

  @override
  void initState() {
    super.initState();
    _customStart = widget.initialRange?.start;
    _customEnd = widget.initialRange?.end;
    _selected = widget.initialRange == null
        ? _PredefinedRange.today
        : _PredefinedRange.custom;
  }

  DateRange _rangeFor(_PredefinedRange range, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    switch (range) {
      case _PredefinedRange.today:
        return DateRange(start: today, end: today);
      // Subtract via the DateTime constructor (which normalizes out-of-range
      // days) rather than Duration: a fixed-hours Duration crossing a DST
      // transition lands off midnight or on the wrong calendar day.
      case _PredefinedRange.last7Days:
        return DateRange(
          start: DateTime(today.year, today.month, today.day - 6),
          end: today,
        );
      case _PredefinedRange.last30Days:
        return DateRange(
          start: DateTime(today.year, today.month, today.day - 29),
          end: today,
        );
      case _PredefinedRange.thisMonth:
        return DateRange(
          start: DateTime(today.year, today.month, 1),
          end: today,
        );
      case _PredefinedRange.custom:
        return DateRange(
          start: _customStart ?? today,
          end: _customEnd ?? today,
        );
    }
  }

  Future<void> _pickCustomRange() async {
    final now = widget.today ?? DateTime.now();
    final start = await CoreDatePicker.show(
      context: context,
      initialDate: _customStart ?? now,
      lastDate: now,
      label: widget.startDateLabel,
      cancelLabel: widget.cancelLabel,
      confirmLabel: widget.confirmLabel,
    );
    if (start == null || !mounted) return;

    // When re-picking, the previous end may precede the newly picked start;
    // seeding the picker with it would let the un-gated OK button return an
    // end before start (an inverted range), so clamp it to the new start.
    final previousEnd = _customEnd;
    final endInitial = previousEnd != null && !previousEnd.isBefore(start)
        ? previousEnd
        : start;
    final end = await CoreDatePicker.show(
      context: context,
      initialDate: endInitial,
      firstDate: start,
      lastDate: now,
      label: widget.endDateLabel,
      cancelLabel: widget.cancelLabel,
      confirmLabel: widget.confirmLabel,
    );
    if (end == null || !mounted) return;

    setState(() {
      _selected = _PredefinedRange.custom;
      _customStart = start;
      _customEnd = end;
    });
  }

  void _onApply() {
    // [_selected] is only ever set to custom once both custom dates have been
    // picked (see [_pickCustomRange]); cancelling a picker reverts the
    // selection to its prior value. So the custom branch of [_rangeFor] can
    // never resolve to its today→today fallback at apply time — no extra guard
    // is needed here.
    Navigator.of(context).pop(
      _rangeFor(_selected, widget.today ?? DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypographyExtension.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(typography),
        _buildRangeOptions(typography),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildTitle(AppTypographyExtension typography) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space4,
        vertical: CoreSpacing.space3,
      ),
      child: Text(
        widget.title,
        style: typography.bodyLargeSemiBold,
      ),
    );
  }

  Widget _buildRangeOptions(AppTypographyExtension typography) {
    final options = <_PredefinedRange, String>{
      _PredefinedRange.today: widget.todayLabel,
      _PredefinedRange.last7Days: widget.last7DaysLabel,
      _PredefinedRange.last30Days: widget.last30DaysLabel,
      _PredefinedRange.thisMonth: widget.thisMonthLabel,
      _PredefinedRange.custom: widget.customRangeLabel,
    };

    // The transparent Material gives the RadioListTiles a surface to paint
    // ink on: inside CoreQuickSheet's color-decorated container the nearest
    // Material is behind the sheet background, so without this the splashes
    // are invisible (and Flutter asserts in debug builds).
    return Material(
      type: MaterialType.transparency,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: options.entries.map((entry) {
          final range = entry.key;
          return RadioListTile<_PredefinedRange>(
            key: Key('date_range_option_${range.name}'),
            value: range,
            groupValue: _selected,
            title: Text(entry.value, style: typography.bodyLargeRegular),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (_) {
              if (range == _PredefinedRange.custom) {
                // Only reopen the pickers when there is no complete custom range
                // yet, or the user is switching back to Custom from another
                // option. Re-tapping an already-complete Custom selection just
                // keeps it instead of forcing the pickers open again.
                if (_customStart == null ||
                    _customEnd == null ||
                    _selected != _PredefinedRange.custom) {
                  _pickCustomRange();
                } else {
                  setState(() => _selected = _PredefinedRange.custom);
                }
              } else {
                setState(() => _selected = range);
              }
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space4,
        CoreSpacing.space3,
        CoreSpacing.space4,
        CoreSpacing.space4,
      ),
      child: Row(
        children: [
          Expanded(
            child: CoreButton(
              key: const Key('date_range_cancel_button'),
              label: widget.cancelLabel,
              variant: CoreButtonVariant.secondary,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(width: CoreSpacing.space3),
          Expanded(
            child: CoreButton(
              key: const Key('date_range_apply_button'),
              label: widget.applyLabel,
              onPressed: _onApply,
            ),
          ),
        ],
      ),
    );
  }
}
