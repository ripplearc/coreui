part of '../../core_display_area.dart';

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
  final bool isCollapsed;

  static const double _runSpacing = CoreSpacing.space2;

  static const double _collapsedVerticalPadding = CoreSpacing.space1;

  static const double _expandedVerticalPadding = CoreSpacing.space3;

  static double largeTextFactor(
    BuildContext context,
    AppTypographyExtension typography,
  ) {
    final fontSize = typography.bodyMediumSemiBold.fontSize;
    if (fontSize == null || fontSize <= 0) return 1;
    return math.max(
      1,
      MediaQuery.textScalerOf(context).scale(fontSize) / fontSize,
    );
  }

  static double oneLineChipHeight(
    BuildContext context,
    AppTypographyExtension typography,
  ) {
    final valueStyle = typography.bodyMediumSemiBold;
    final lineHeight = (valueStyle.fontSize ?? 0) *
        largeTextFactor(context, typography) *
        (valueStyle.height ?? 1);
    return lineHeight +
        CoreCalculatorChipTheme.padding.vertical +
        2 * CoreCalculatorChipTheme.borderWidth;
  }

  static double _twoRowMaxHeight(
    BuildContext context,
    AppTypographyExtension typography,
  ) =>
      2 * oneLineChipHeight(context, typography) + _runSpacing;

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
      runSpacing: _runSpacing,
      children: chipWidgets,
    );

    if (isCollapsed) {
      return ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: _twoRowMaxHeight(context, typography) +
              _collapsedVerticalPadding * 2,
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
