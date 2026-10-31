import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'core_chip_theme.dart';

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

  /// Called when the user taps the active pill's × to clear the filter.
  /// Tapping the pill itself reopens the sheet.
  final VoidCallback onClear;

  /// Label shown on the chip when no range is selected.
  final String label;

  /// Accessibility label for the chip when no range is selected.
  /// Defaults to [label] when null.
  final String? semanticLabel;

  /// Accessibility label for the × that clears the filter.
  final String clearSemanticLabel;

  /// Accessibility hint for the active pill, which reopens the date sheet.
  final String rangeSemanticHint;

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

  /// Key of the active pill's clear × button.
  static const Key clearButtonKey = Key('core_date_filter_chip_clear_button');

  /// Key of the active pill's grey fill, for widget-test finders.
  static const Key pillKey = Key('core_date_filter_chip_pill');

  /// Creates a [CoreDateFilterChip].
  const CoreDateFilterChip({
    super.key,
    required this.selectedDateRange,
    required this.onApply,
    required this.onClear,
    required this.label,
    this.semanticLabel,
    this.clearSemanticLabel = 'Clear date filter',
    this.rangeSemanticHint = 'Opens the date range sheet',
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

    return _ActiveDateChip(
      key: activeChipKey,
      label: _formatRange(range),
      clearSemanticLabel: clearSemanticLabel,
      rangeSemanticHint: rangeSemanticHint,
      onTap: () => _showSheet(context),
      onClear: onClear,
    );
  }
}

class _ActiveDateChip extends StatefulWidget {
  const _ActiveDateChip({
    super.key,
    required this.label,
    required this.clearSemanticLabel,
    required this.rangeSemanticHint,
    required this.onTap,
    required this.onClear,
  });

  final String label;
  final String clearSemanticLabel;
  final String rangeSemanticHint;
  final VoidCallback onTap;
  final VoidCallback onClear;

  @override
  State<_ActiveDateChip> createState() => _ActiveDateChipState();
}

class _ActiveDateChipState extends State<_ActiveDateChip> {
  bool _isPressed = false;
  bool _isRangeFocused = false;
  bool _isClearFocused = false;

  BoxBorder? _pillBorder(AppColorsExtension colors) {
    if (_isPressed) return Border.all(color: colors.lineDarkOutline);
    if (!_isRangeFocused && !_isClearFocused) return null;
    return Border.all(
      color: colors.outlineFocus,
      width: CoreChipTheme.borderWidthFor(isFocused: true),
    );
  }

  static const double _pillHeight = CoreSpacing.space8;
  static const double _bodyMediumLineHeight = CoreSpacing.space5;
  static const double _pillVerticalPadding =
      (_pillHeight - _bodyMediumLineHeight) / 2;

  void _setPressed(bool isPressed) => setState(() => _isPressed = isPressed);

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final noTint = WidgetStateProperty.all(colors.transparent);
    const pillInset = (CoreSpacing.space12 - _pillHeight) / 2;
    const datesInset = pillInset + _pillVerticalPadding;
    // The × target is wider than the icon plus the pill's 12 dp end padding,
    // so the pill stops short of the target's end edge by the difference.
    const clearTargetOverhang =
        (CoreSpacing.space12 - CoreIconSize.size20) / 2 - CoreSpacing.space3;
    // The × target overlaps the range so the dates end 8 dp before the ×,
    // as Figma's gap is, while the target stays 48 dp wide.
    const clearTargetWidthBesideRange = CoreSpacing.space12 -
        ((CoreSpacing.space12 - CoreIconSize.size20) / 2 - CoreSpacing.space2);

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          PositionedDirectional(
            start: 0,
            top: pillInset,
            end: clearTargetOverhang,
            bottom: pillInset,
            child: DecoratedBox(
              key: CoreDateFilterChip.pillKey,
              decoration: BoxDecoration(
                color: _isPressed ? colors.pageBackground : colors.chipGrey,
                borderRadius: BorderRadius.circular(CoreSpacing.space5),
                border: _pillBorder(colors),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Semantics(
                  label: widget.label,
                  hint: widget.rangeSemanticHint,
                  button: true,
                  container: true,
                  child: InkWell(
                    onTap: widget.onTap,
                    onFocusChange: (isFocused) =>
                        setState(() => _isRangeFocused = isFocused),
                    onHighlightChanged: _setPressed,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: noTint,
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: CoreSpacing.space12,
                      ),
                      padding: const EdgeInsetsDirectional.only(
                        start: CoreSpacing.space3,
                        top: datesInset,
                        end: clearTargetWidthBesideRange,
                        bottom: datesInset,
                      ),
                      child: Center(
                        widthFactor: 1,
                        heightFactor: 1,
                        child: ExcludeSemantics(
                          child: Text(
                            widget.label,
                            style: typography.bodyMediumRegular.copyWith(
                              color: colors.textDark,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          PositionedDirectional(
            top: 0,
            end: 0,
            bottom: 0,
            child: Semantics(
              label: widget.clearSemanticLabel,
              button: true,
              container: true,
              child: InkWell(
                key: CoreDateFilterChip.clearButtonKey,
                onTap: widget.onClear,
                onFocusChange: (isFocused) =>
                    setState(() => _isClearFocused = isFocused),
                onHighlightChanged: _setPressed,
                splashFactory: NoSplash.splashFactory,
                overlayColor: noTint,
                child: SizedBox.square(
                  dimension: CoreSpacing.space12,
                  child: Center(
                    child: CoreIconWidget(
                      icon: CoreIcons.close,
                      color: colors.iconGrayMid,
                      size: CoreIconSize.size20,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
