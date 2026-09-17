part of '../../core_geometry_area.dart';

class _SizeCard extends StatelessWidget {
  // No `key` param: always constructed without one internally. If this
  // widget is ever promoted to public, restore `super.key` so callers can
  // control identity in the reorderable list.
  _SizeCard({
    required this.index,
    required this.layout,
    required this.values,
    required this.dragHandleLabel,
    required this.isReorderable,
    this.editSemanticsLabel,
    this.deleteSemanticsLabel,
    this.onEdit,
    this.onDelete,
    this.isHighlighted = false,
  }) : assert(
          values.length == layout.columnWidths.length,
          '_SizeCard: values.length (${values.length}) must equal '
          'columnWidths.length (${layout.columnWidths.length})',
        );

  final int index;
  final _TableLayout layout;
  final List<String> values;
  final String? dragHandleLabel;
  final bool isReorderable;
  final String? editSemanticsLabel;
  final String? deleteSemanticsLabel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isHighlighted;

  static const _borderWidth = 1.5;

  // A 48 dp box around a 20 px icon: the box is invisible and only sets the tap
  // target, which CoreIconWidget(onTap:) cannot do — it builds an IconButton
  // with zero padding and empty constraints.
  Widget _actionButton({
    required CoreIconData icon,
    required Color color,
    required String? semanticLabel,
    required VoidCallback onTap,
  }) {
    return Semantics(
      button: true,
      label: semanticLabel,
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        // Claims horizontal drags that start on the button so a sloppy swipe
        // here cannot reach the row's Dismissible and delete by gesture.
        onHorizontalDragStart: (_) {},
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: CoreSpacing.space12,
            minHeight: CoreSpacing.space12,
          ),
          child: Center(
            child: CoreIconWidget(
              icon: icon,
              size: CoreIconSize.size20,
              color: color,
            ),
          ),
        ),
      ),
    );
  }

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
        color: Theme.of(context).brightness == Brightness.dark
            ? colors.backgroundGrayLight
            : colors.buttonInverse,
        borderRadius: BorderRadius.circular(CoreSpacing.space2),
        boxShadow: CoreShadows.small,
        border: isHighlighted
            ? Border.all(color: colors.lineHighlight, width: _borderWidth)
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isReorderable)
            ReorderableDragStartListener(
              index: index,
              child: MouseRegion(
                cursor: SystemMouseCursors.grab,
                child: SizedBox(
                  width: layout.leadingSpace - CoreSpacing.space4,
                  child: Center(
                    child: RotatedBox(
                      quarterTurns: 1,
                      child: CoreIconWidget(
                        icon: CoreIcons.dragIndicator,
                        size: CoreIconSize.size20,
                        color: colors.lineDarkOutline,
                        semanticLabel: dragHandleLabel,
                      ),
                    ),
                  ),
                ),
              ),
            )
          else
            // Keeps the value columns aligned with the header, which always
            // indents by the full leading space.
            SizedBox(width: layout.leadingSpace - CoreSpacing.space4),
          ...values.asMap().entries.map(
                (entry) => Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                      start: CoreSpacing.space1,
                    ),
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
          if (onEdit case final onEdit?)
            _actionButton(
              icon: CoreIcons.edit,
              color: colors.textLink,
              semanticLabel: editSemanticsLabel,
              onTap: onEdit,
            ),
          if (onDelete case final onDelete?)
            _actionButton(
              icon: CoreIcons.delete,
              color: colors.iconRed,
              semanticLabel: deleteSemanticsLabel,
              onTap: onDelete,
            ),
          SizedBox(width: layout.isScrollable ? 0 : CoreSpacing.space3),
        ],
      ),
    );
  }
}
