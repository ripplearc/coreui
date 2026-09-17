part of '../../core_geometry_area.dart';

class _TableLayout {
  const _TableLayout({
    required this.leadingSpace,
    required this.trailingSpace,
    required this.columnWidths,
    required this.endMargin,
    required this.actionsWidth,
    required this.isScrollable,
  });

  final double leadingSpace;
  final double trailingSpace;
  final double endMargin;
  final List<double> columnWidths;

  /// Width reserved for the row's trailing edit/delete buttons, zero when the
  /// table renders neither. The header reserves the same width so its
  /// fixed-width columns stay aligned with the row's flexible ones.
  final double actionsWidth;

  final bool isScrollable;
}

class _SizesTable extends StatefulWidget {
  const _SizesTable({super.key, required this.table});

  final CoreSizesTableData table;

  @override
  State<_SizesTable> createState() => _SizesTableState();
}

class _SizesTableState extends State<_SizesTable> {
  int? _recentlyDroppedIndex;

  Widget _proxyDecorator(Widget child, int index, Animation<double> animation,
      BuildContext context, _TableLayout layout) {
    final colors = AppColorsExtension.of(context);
    final row = widget.table.rows[index];

    // The proxy must render the same action buttons as the static row. Without
    // them the row keeps layout's reserved actionsWidth but has nothing to put
    // in it, so the value columns stretch into the gap and the text visibly
    // jumps the moment a drag starts.
    final table = widget.table;
    final draggingCard = _SizeCard(
      index: index,
      layout: layout,
      values: row.values,
      dragHandleLabel: table.dragHandleLabel,
      isReorderable: true,
      isHighlighted: true,
      editSemanticsLabel: table.editRowSemanticsLabelBuilder?.call(row),
      deleteSemanticsLabel: table.deleteRowSemanticsLabelBuilder?.call(row),
      onEdit: table.onSaved == null
          ? null
          : () => _openEntrySheet(row: row, index: index),
      onDelete:
          table.onDeleted == null ? null : () => table.onDeleted?.call(row.id),
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

  /// Minimum tap-target edge for the row's action buttons.
  static const double _actionSize = CoreSpacing.space12;

  List<String> get _titles =>
      widget.table.columns.map((column) => column.title).toList();

  Future<void> _openEntrySheet({CoreSizeCardData? row, int? index}) async {
    final table = widget.table;
    final result = await SizeEntryBottomSheet.show(
      context: context,
      addSizeTitle: table.addLabel ?? '',
      editSizeTitle: table.editLabel ?? '',
      initialData: row,
      initialIndex: index,
      titles: _titles,
    );
    if (result != null) {
      table.onSaved?.call(result);
    }
  }

  // Rows keep their Dismissible and semantics wrappers whether or not the
  // table is reorderable, so swipe-to-delete works on static tables too.
  List<Widget> _buildRows(
    BuildContext context,
    _TableLayout layout,
    AppColorsExtension colors,
  ) {
    final table = widget.table;
    final localizations = MaterialLocalizations.of(context);
    final isReorderable = table.onReordered != null;

    return table.rows.asMap().entries.map((entry) {
      final row = entry.value;
      final index = entry.key;

      // Checked here rather than in the const CoreSizesTableData constructor,
      // which cannot inspect the rows and stay const. Without this the
      // mismatch surfaces inside _SizeCard, whose message names columnWidths —
      // an internal the consumer has no name for.
      assert(
        row.values.length == table.columns.length,
        'CoreSizesTableData "${table.id}": row "${row.id}" has '
        '${row.values.length} values but the table declares '
        '${table.columns.length} columns. Every row must supply exactly one '
        'value per column.',
      );

      return Semantics(
        key: ValueKey(row.id),
        // An empty map still sets SemanticsAction.customAction, which makes a
        // read-only row announce "actions available" and open an empty menu,
        // so pass null when there is nothing to offer.
        customSemanticsActions: table.onDeleted == null
            ? null
            : {
                CustomSemanticsAction(label: localizations.deleteButtonTooltip):
                    () => table.onDeleted?.call(row.id),
              },
        child: Dismissible(
          // 'dismiss_' prefix distinguishes Dismissible's key from the inner
          // Semantics key; ReorderableListView uses the Dismissible key for
          // drag identity, so it must be unique at that level.
          key: ValueKey('dismiss_${row.id}'),
          direction: table.onDeleted == null
              ? DismissDirection.none
              : DismissDirection.endToStart,
          background: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space3,
              vertical: CoreSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: colors.statusError,
              borderRadius: BorderRadius.circular(CoreSpacing.space2),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: CoreSpacing.space6),
            child: CoreIconWidget(
              icon: CoreIcons.delete,
              color: colors.iconWhite,
            ),
          ),
          onDismissed: (_) => table.onDeleted?.call(row.id),
          child: GestureDetector(
            onTap: table.onSaved == null
                ? null
                : () => _openEntrySheet(row: row, index: index),
            child: _SizeCard(
              index: index,
              layout: layout,
              values: row.values,
              dragHandleLabel: table.dragHandleLabel,
              isReorderable: isReorderable,
              isHighlighted: index == _recentlyDroppedIndex,
              editSemanticsLabel:
                  table.editRowSemanticsLabelBuilder?.call(row),
              deleteSemanticsLabel:
                  table.deleteRowSemanticsLabelBuilder?.call(row),
              onEdit: table.onSaved == null
                  ? null
                  : () => _openEntrySheet(row: row, index: index),
              onDelete: table.onDeleted == null
                  ? null
                  : () => table.onDeleted?.call(row.id),
            ),
          ),
        ),
      );
    }).toList();
  }

  void _handleReorder(int oldIndex, int newIndex) {
    HapticFeedback.lightImpact();
    setState(() {
      _recentlyDroppedIndex = newIndex;
    });
    Future.delayed(const Duration(milliseconds: _highlightDuration), () {
      if (mounted && _recentlyDroppedIndex == newIndex) {
        setState(() {
          _recentlyDroppedIndex = null;
        });
      }
    });
    widget.table.onReordered?.call(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final table = widget.table;
    final isReorderable = table.onReordered != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        const leadingSpace = CoreSpacing.space12;
        const trailingSpace = CoreSpacing.space4;
        const columnWidth = CoreSpacing.space16;
        const endMargin = CoreSpacing.space1;

        // Each button is a full 48 dp tap target, so the slot is sized by how
        // many of them the table's callbacks actually render.
        final actionsWidth = (table.onSaved == null ? 0.0 : _actionSize) +
            (table.onDeleted == null ? 0.0 : _actionSize);

        final totalWidth = leadingSpace +
            trailingSpace +
            actionsWidth +
            ((columnWidth + endMargin) * table.columns.length);
        final bool isScrollable = constraints.maxWidth < totalWidth;
        final containerWidth = math.max(constraints.maxWidth, totalWidth);

        final layout = _TableLayout(
          leadingSpace: leadingSpace,
          trailingSpace: trailingSpace,
          endMargin: endMargin,
          columnWidths: List.filled(
            table.columns.length,
            columnWidth,
          ),
          actionsWidth: actionsWidth,
          isScrollable: isScrollable,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SizesHeader(
              titleLabel: table.title,
              addSizeLabel: table.addLabel,
              // An explicit [onAdd] means the app owns the add flow; otherwise
              // the built-in entry sheet handles it and reports via [onSaved].
              onAddTap: table.addLabel == null
                  ? null
                  : table.onAdd ??
                      (table.onSaved == null ? null : _openEntrySheet),
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
                      titles: _titles,
                    ),
                    SizedBox(
                      width: containerWidth,
                      child: isReorderable
                          ? ReorderableListView(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              buildDefaultDragHandles: false,
                              proxyDecorator: (child, index, animation) =>
                                  _proxyDecorator(
                                      child, index, animation, context, layout),
                              onReorderItem: _handleReorder,
                              children: _buildRows(context, layout, colors),
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisSize: MainAxisSize.min,
                              children: _buildRows(context, layout, colors),
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
