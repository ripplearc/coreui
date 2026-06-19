import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

part 'parts/calendar_grid.dart';
part 'parts/date_picker_action_button.dart';
part 'parts/date_picker_header.dart';
part 'parts/day_cell.dart';
part 'parts/month_selector_row.dart';

/// Truncates [date] to midnight, dropping any time-of-day component so date
/// range comparisons (`isBefore`/`isAfter`) only consider the calendar date.
DateTime _dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// A modal calendar widget for picking a single date.
///
/// Shows a header with [label] and the currently selected date spelled out,
/// a month selector with previous/next navigation, a day grid, and
/// Cancel/OK actions. The caller owns the selected date; [onDateChanged] is
/// invoked whenever the user taps a day, and [onCancel]/[onConfirm] are
/// invoked when the corresponding action button is tapped.
///
/// Use [CoreDatePicker.show] to present this inside a themed dialog.
class CoreDatePicker extends StatefulWidget {
  /// The currently selected date.
  final DateTime selectedDate;

  /// Called with the newly selected date when the user taps a day cell.
  final ValueChanged<DateTime> onDateChanged;

  /// Called when the user taps the cancel action.
  final VoidCallback onCancel;

  /// Called when the user taps the confirm (OK) action.
  final VoidCallback onConfirm;

  /// The earliest selectable date, inclusive. Earlier months are still
  /// reachable for context but their days are disabled.
  final DateTime? firstDate;

  /// The latest selectable date, inclusive.
  final DateTime? lastDate;

  /// Label shown above the selected date (e.g. "Select date").
  final String label;

  /// Cancel button label.
  final String cancelLabel;

  /// Confirm button label.
  final String confirmLabel;

  /// Accessibility label for the previous-month control.
  final String previousMonthSemanticLabel;

  /// Accessibility label for the next-month control.
  final String nextMonthSemanticLabel;

  /// Formats the large date shown in the header. Defaults to a
  /// `"Mon, Aug 17"`-style abbreviated format.
  final String Function(DateTime date)? dateLabelBuilder;

  /// Formats the "August 2025"-style label in the month selector.
  final String Function(DateTime month)? monthLabelBuilder;

  /// Seven single-letter weekday labels starting from Sunday (S M T W T F S).
  final List<String>? weekdayLabels;

  /// Overrides "today" for testing; defaults to [DateTime.now].
  final DateTime? today;

  const CoreDatePicker({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
    required this.onCancel,
    required this.onConfirm,
    this.firstDate,
    this.lastDate,
    this.label = 'Select date',
    this.cancelLabel = 'Cancel',
    this.confirmLabel = 'OK',
    this.previousMonthSemanticLabel = 'Previous month',
    this.nextMonthSemanticLabel = 'Next month',
    this.dateLabelBuilder,
    this.monthLabelBuilder,
    this.weekdayLabels,
    this.today,
  });

  /// Shows [CoreDatePicker] inside a rounded dialog and resolves with the
  /// confirmed date, or `null` if the user cancels/dismisses.
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String label = 'Select date',
    String cancelLabel = 'Cancel',
    String confirmLabel = 'OK',
  }) {
    final colors = AppColorsExtension.of(context);
    var selected = initialDate;

    return showDialog<DateTime>(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space6,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(CoreSpacing.space3),
                child: ColoredBox(
                  color: colors.pageBackground,
                  child: CoreDatePicker(
                    selectedDate: selected,
                    firstDate: firstDate,
                    lastDate: lastDate,
                    label: label,
                    cancelLabel: cancelLabel,
                    confirmLabel: confirmLabel,
                    onDateChanged: (date) => setState(() => selected = date),
                    onCancel: () => Navigator.of(dialogContext).pop(),
                    onConfirm: () =>
                        Navigator.of(dialogContext).pop(selected),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  State<CoreDatePicker> createState() => _CoreDatePickerState();
}

class _CoreDatePickerState extends State<CoreDatePicker> {
  late DateTime _displayedMonth;

  static const List<String> _defaultWeekdayLabels = [
    'S',
    'M',
    'T',
    'W',
    'T',
    'F',
    'S',
  ];

  @override
  void initState() {
    super.initState();
    _displayedMonth = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
    );
  }

  @override
  void didUpdateWidget(covariant CoreDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate.year != widget.selectedDate.year ||
        oldWidget.selectedDate.month != widget.selectedDate.month) {
      _displayedMonth = DateTime(
        widget.selectedDate.year,
        widget.selectedDate.month,
      );
    }
  }

  String _defaultDateLabel(DateTime date) {
    const weekdays = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
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
    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekday, $month ${date.day}';
  }

  String _defaultMonthLabel(DateTime month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month.month - 1]} ${month.year}';
  }

  bool get _canGoToPreviousMonth {
    final first = widget.firstDate;
    if (first == null) return true;
    final previousMonthEnd =
        DateTime(_displayedMonth.year, _displayedMonth.month, 0);
    return !previousMonthEnd.isBefore(_dateOnly(first));
  }

  bool get _canGoToNextMonth {
    final last = widget.lastDate;
    if (last == null) return true;
    final nextMonthStart =
        DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    return !nextMonthStart.isAfter(_dateOnly(last));
  }

  void _goToPreviousMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _displayedMonth =
          DateTime(_displayedMonth.year, _displayedMonth.month + 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final today = widget.today ?? DateTime.now();
    final dateLabelBuilder = widget.dateLabelBuilder ?? _defaultDateLabel;
    final monthLabelBuilder = widget.monthLabelBuilder ?? _defaultMonthLabel;
    final weekdayLabels = widget.weekdayLabels ?? _defaultWeekdayLabels;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _DatePickerHeader(
          label: widget.label,
          dateLabel: dateLabelBuilder(widget.selectedDate),
        ),
        _MonthSelectorRow(
          monthLabel: monthLabelBuilder(_displayedMonth),
          onPreviousMonth: _goToPreviousMonth,
          onNextMonth: _goToNextMonth,
          isPreviousEnabled: _canGoToPreviousMonth,
          isNextEnabled: _canGoToNextMonth,
          previousMonthSemanticLabel: widget.previousMonthSemanticLabel,
          nextMonthSemanticLabel: widget.nextMonthSemanticLabel,
        ),
        _CalendarGrid(
          displayedMonth: _displayedMonth,
          selectedDate: widget.selectedDate,
          today: today,
          weekdayLabels: weekdayLabels,
          firstDate: widget.firstDate,
          lastDate: widget.lastDate,
          onDaySelected: widget.onDateChanged,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            CoreSpacing.space3,
            CoreSpacing.space2,
            CoreSpacing.space3,
            CoreSpacing.space3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _DatePickerActionButton(
                label: widget.cancelLabel,
                onPressed: widget.onCancel,
              ),
              _DatePickerActionButton(
                label: widget.confirmLabel,
                onPressed: widget.onConfirm,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
