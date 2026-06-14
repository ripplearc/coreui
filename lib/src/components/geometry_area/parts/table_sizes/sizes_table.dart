part of '../../core_geometry_area.dart';

class _TableLayout {
  const _TableLayout({
    required this.leadingSpace,
    required this.trailingSpace,
    required this.columnWidths,
    required this.endMargin,
    required this.isScrollable,
  });

  final double leadingSpace;
  final double trailingSpace;
  final double endMargin;
  final List<double> columnWidths;
  final bool isScrollable;
}

class _SizesTable extends StatefulWidget {
  const _SizesTable({
    required this.sizesTitleLabel,
    required this.addSizeLabel,
    required this.dragHandleLabel,
    required this.titles,
    required this.sizesTableData,
    this.onSizesReordered,
    this.onSizeDeleted,
  });

  final String sizesTitleLabel;
  final String addSizeLabel;
  final String dragHandleLabel;
  final List<String> titles;
  final List<CoreSizeCardData> sizesTableData;
  final void Function(int oldIndex, int newIndex)? onSizesReordered;
  final void Function(String id)? onSizeDeleted;

  @override
  State<_SizesTable> createState() => _SizesTableState();
}

class _SizesTableState extends State<_SizesTable> {
  int? _recentlyDroppedIndex;

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation,
      BuildContext context, _TableLayout layout) {
    final colors = AppColorsExtension.of(context);
    final row = widget.sizesTableData[index];

    final draggingCard = _SizeCard(
      index: index,
      layout: layout,
      values: row.values,
      dragHandleLabel: widget.dragHandleLabel,
      isHighlighted: true,
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? _) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double scale = ui.lerpDouble(1, 1.02, animValue) ?? 1.0;
        final double elevation = ui.lerpDouble(0, 6, animValue) ?? 0.0;
        return Transform.scale(
          scale: scale,
          child: Material(
            elevation: elevation,
            color: colors.transparent,
            shadowColor: colors.shadowGrey10,
            child: draggingCard,
          ),
        );
      },
    );
  }

  static const _highlightDuration = 500;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        const leadingSpace = CoreSpacing.space12;
        const trailingSpace = CoreSpacing.space4;
        const columnWidth = CoreSpacing.space16;
        const endMargin = CoreSpacing.space1;

        final totalWidth = leadingSpace +
            trailingSpace +
            ((columnWidth + endMargin) * widget.titles.length);
        final bool isScrollable = constraints.maxWidth < totalWidth;
        final containerWidth = math.max(constraints.maxWidth, totalWidth);

        final layout = _TableLayout(
          leadingSpace: leadingSpace,
          trailingSpace: trailingSpace,
          endMargin: endMargin,
          columnWidths: List.filled(
            widget.titles.length,
            columnWidth,
          ),
          isScrollable: isScrollable,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SizesHeader(
              titleLabel: widget.sizesTitleLabel,
              addSizeLabel: widget.addSizeLabel,
            ),
            const SizedBox(height: CoreSpacing.space1),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: CoreSpacing.space1),
                width: containerWidth,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _SizesTableHeader(
                      layout: layout,
                      titles: widget.titles,
                    ),
                    SizedBox(
                      width: containerWidth,
                      child: ReorderableListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        buildDefaultDragHandles: false,
                        proxyDecorator: (child, index, animation) =>
                            _proxyDecorator(
                                child, index, animation, context, layout),
                        onReorder: (oldIndex, newIndex) {
                          if (oldIndex < newIndex) {
                            newIndex -= 1;
                          }
                          HapticFeedback.lightImpact();
                          setState(() {
                            _recentlyDroppedIndex = newIndex;
                          });
                          Future.delayed(
                              const Duration(milliseconds: _highlightDuration),
                              () {
                            if (mounted && _recentlyDroppedIndex == newIndex) {
                              setState(() {
                                _recentlyDroppedIndex = null;
                              });
                            }
                          });
                          widget.onSizesReordered?.call(oldIndex, newIndex);
                        },
                        children:
                            widget.sizesTableData.asMap().entries.map((entry) {
                          final localizations =
                              MaterialLocalizations.of(context);

                          return Semantics(
                            key: ValueKey(entry.value.id),
                            customSemanticsActions: {
                              CustomSemanticsAction(
                                      label: localizations.deleteButtonTooltip):
                                  () {
                                widget.onSizeDeleted?.call(entry.value.id);
                              },
                            },
                            child: Dismissible(
                              // 'dismiss_' prefix distinguishes Dismissible's key from the inner
                              // Semantics key; ReorderableListView uses the Dismissible key for
                              // drag identity, so it must be unique at that level.
                              key: ValueKey('dismiss_${entry.value.id}'),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: CoreSpacing.space3,
                                  vertical: CoreSpacing.space1,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.statusError,
                                  borderRadius:
                                      BorderRadius.circular(CoreSpacing.space2),
                                ),
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(
                                    right: CoreSpacing.space6),
                                child: CoreIconWidget(
                                  icon: CoreIcons.delete,
                                  color: colors.iconWhite,
                                ),
                              ),
                              onDismissed: (_) {
                                widget.onSizeDeleted?.call(entry.value.id);
                              },
                              child: _SizeCard(
                                index: entry.key,
                                layout: layout,
                                values: entry.value.values,
                                dragHandleLabel: widget.dragHandleLabel,
                                isHighlighted:
                                    entry.key == _recentlyDroppedIndex,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
