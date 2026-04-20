part of '../../core_display_area.dart';

/// Renders a [Wrap] of [CoreCalculatorChip] widgets inside the history panel.
///
/// In [isCollapsed] mode the visible area is capped to two chip rows using a
/// [SingleChildScrollView] anchored at the end (most-recent chips), combined
/// with [NeverScrollableScrollPhysics] so the area is never user-scrollable.
///
/// In expanded modes the chips fill their natural height with no scroll
/// physics; when [DisplayAreaStage.fullScreen] is active the containing
/// [_HistoryPanel] wraps everything in its own [SingleChildScrollView].
class _HistoryChips extends StatelessWidget {
  const _HistoryChips({
    required this.chipsList,
    required this.hasError,
    required this.errorMessage,
    required this.isCollapsed,
  });

  final List<CoreCalculatorChip> chipsList;
  final bool hasError;
  final String errorMessage;

  /// When true, the chips area is height-constrained to [_twoRowMaxHeight]
  /// and anchored at the bottom of the scroll extent (most-recent chips).
  final bool isCollapsed;

  static const double _twoRowMaxHeight = 68.0;

  static const double _collapsedVerticalPadding = CoreSpacing.space1;

  static const double _expandedVerticalPadding = CoreSpacing.space3;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final chipWidgets = <Widget>[
      ...chipsList,
      if (hasError && errorMessage.isNotEmpty)
        Semantics(
          label: errorMessage,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space2,
              vertical: CoreSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: colors.chipRed,
              borderRadius: BorderRadius.circular(CoreSpacing.space5),
            ),
            child: ExcludeSemantics(
              child: Text(
                errorMessage,
                style: typography.bodyMediumRegular
                    .copyWith(color: colors.textDark),
              ),
            ),
          ),
        ),
    ];

    final wrap = Wrap(
      spacing: CoreSpacing.space2,
      runSpacing: CoreSpacing.space2,
      children: chipWidgets,
    );

    if (isCollapsed) {
      return ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: _twoRowMaxHeight + _collapsedVerticalPadding * 2,
        ),
        child: SingleChildScrollView(
          reverse: true,
          physics: const NeverScrollableScrollPhysics(),
          padding:
              const EdgeInsets.symmetric(vertical: _collapsedVerticalPadding),
          child: wrap,
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _expandedVerticalPadding),
      child: wrap,
    );
  }
}
