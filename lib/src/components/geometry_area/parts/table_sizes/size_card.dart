part of '../../core_geometry_area.dart';

class _SizeCard extends StatelessWidget {
  _SizeCard({
    required this.layout,
    required this.values,
  }) : assert(
          values.length == layout.columnWidths.length,
          '_SizeCard: values.length (${values.length}) must equal '
          'columnWidths.length (${layout.columnWidths.length})',
        );

  final _TableLayout layout;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space3,
        vertical: CoreSpacing.space1,
      ),
      padding: const EdgeInsets.symmetric(vertical: CoreSpacing.space2),
      decoration: BoxDecoration(
        color: colors.buttonInverse,
        borderRadius: BorderRadius.circular(CoreSpacing.space2),
        boxShadow: CoreShadows.small,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: layout.leadingSpace - CoreSpacing.space4,
            child: Center(
                child: RotatedBox(
              quarterTurns: 1,
              child: CoreIconWidget(
                icon: CoreIcons.dragIndicator,
                size: CoreIconSize.size20,
                color: colors.lineDarkOutline,
              ),
            )),
          ),
          ...values.asMap().entries.map(
                (entry) => Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: CoreSpacing.space1),
                    child: Text(
                      entry.value,
                      style: typography.bodyMediumMedium.copyWith(
                        color: colors.textDark,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
          SizedBox(width: layout.isScrollable ? 0 : CoreSpacing.space3),
        ],
      ),
    );
  }
}
