part of '../core_date_picker.dart';

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.isSelected,
    required this.isToday,
    required this.isEnabled,
    required this.onTap,
    required this.semanticLabel,
  });

  /// Null renders an empty, non-interactive cell (e.g. padding before the
  /// 1st of the month).
  final int? day;
  final bool isSelected;
  final bool isToday;
  final bool isEnabled;
  final VoidCallback onTap;
  final String semanticLabel;

  static const double _cellSize = CoreSpacing.space10;

  @override
  Widget build(BuildContext context) {
    final dayValue = day;
    if (dayValue == null) {
      return const SizedBox(width: _cellSize, height: _cellSize);
    }
    // dayValue is non-null past this point.

    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final textColor = !isEnabled
        ? colors.textDisable
        : isSelected
            ? colors.textInverse
            : colors.textDark;

    final textStyle = isSelected
        ? typography.bodyLargeMedium.copyWith(color: textColor)
        : typography.bodyLargeRegular.copyWith(color: textColor);

    final decoration = BoxDecoration(
      shape: BoxShape.circle,
      color: isSelected ? colors.outlineFocus : colors.transparent,
      border: !isSelected && isToday
          ? Border.all(color: colors.lineHighlight)
          : null,
    );

    return Semantics(
      label: semanticLabel,
      button: true,
      selected: isSelected,
      enabled: isEnabled,
      excludeSemantics: true,
      child: Material(
        color: colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          customBorder: const CircleBorder(),
          child: Container(
            width: _cellSize,
            height: _cellSize,
            decoration: decoration,
            alignment: Alignment.center,
            child: Text('$dayValue', style: textStyle),
          ),
        ),
      ),
    );
  }
}
