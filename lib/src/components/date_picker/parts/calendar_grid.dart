part of '../core_date_picker.dart';

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.displayedMonth,
    required this.selectedDate,
    required this.today,
    required this.weekdayLabels,
    required this.firstDate,
    required this.lastDate,
    required this.onDaySelected,
  });

  /// Any day within the month to render; only year/month are used.
  final DateTime displayedMonth;
  final DateTime selectedDate;
  final DateTime today;

  /// Seven single-letter labels starting from Sunday.
  final List<String> weekdayLabels;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTime> onDaySelected;

  static const double _rowHeight = CoreSpacing.space12;

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isEnabled(DateTime date) {
    final first = firstDate;
    final last = lastDate;
    if (first != null && date.isBefore(_dateOnly(first))) {
      return false;
    }
    if (last != null && date.isAfter(_dateOnly(last))) {
      return false;
    }
    return true;
  }

  List<int?> _buildCells() {
    final firstOfMonth = DateTime(displayedMonth.year, displayedMonth.month, 1);
    final daysInMonth =
        DateTime(displayedMonth.year, displayedMonth.month + 1, 0).day;
    // DateTime.weekday is 1 (Mon) .. 7 (Sun); the grid starts on Sunday.
    final leadingBlanks = firstOfMonth.weekday % 7;

    return [
      ...List<int?>.filled(leadingBlanks, null),
      ...List<int?>.generate(daysInMonth, (index) => index + 1),
    ];
  }

  Widget _buildWeekdayHeader(AppTypographyExtension typography, AppColorsExtension colors) {
    return SizedBox(
      height: CoreSpacing.space12,
      child: Row(
        children: weekdayLabels
            .map(
              (label) => Expanded(
                child: Center(
                  child: ExcludeSemantics(
                    child: Text(
                      label,
                      style: typography.bodyLargeMedium
                          .copyWith(color: colors.textDark),
                    ),
                  ),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypographyExtension.of(context);
    final colors = AppColorsExtension.of(context);
    final cells = _buildCells();
    final weekCount = (cells.length / 7).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildWeekdayHeader(typography, colors),
          for (var week = 0; week < weekCount; week++)
            SizedBox(
              height: _rowHeight,
              child: Row(
                children: List<Widget>.generate(7, (weekday) {
                  final index = week * 7 + weekday;
                  final day = index < cells.length ? cells[index] : null;

                  Widget cell;
                  if (day == null) {
                    cell = const SizedBox.shrink();
                  } else {
                    final date = DateTime(
                      displayedMonth.year,
                      displayedMonth.month,
                      day,
                    );
                    cell = _DayCell(
                      day: day,
                      isSelected: _isSameDay(date, selectedDate),
                      isToday: _isSameDay(date, today),
                      isEnabled: _isEnabled(date),
                      onTap: () => onDaySelected(date),
                      semanticLabel: MaterialLocalizations.of(context)
                          .formatFullDate(date),
                    );
                  }

                  return Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(CoreSpacing.space1),
                        child: cell,
                      ),
                    ),
                  );
                }, growable: false),
              ),
            ),
        ],
      ),
    );
  }
}
