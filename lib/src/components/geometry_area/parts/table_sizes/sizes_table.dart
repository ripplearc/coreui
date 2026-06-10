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

class _SizesTable extends StatelessWidget {
  const _SizesTable({
    required this.sizesTitleLabel,
    required this.addSizeLabel,
    required this.titles,
    required this.sizesTableData,
  });

  final String sizesTitleLabel;
  final String addSizeLabel;
  final List<String> titles;
  final List<CoreSizeCardData> sizesTableData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const leadingSpace = CoreSpacing.space12;
        const trailingSpace = CoreSpacing.space4;
        const columnWidth = CoreSpacing.space16;
        const endMargin = CoreSpacing.space1;

        final totalWidth = leadingSpace +
            trailingSpace +
            ((columnWidth + endMargin) * titles.length);
        final containerWidth = math.max(constraints.maxWidth, totalWidth);

        final bool isScrollable = containerWidth < totalWidth;

        final layout = _TableLayout(
          leadingSpace: leadingSpace,
          trailingSpace: trailingSpace,
          endMargin: endMargin,
          columnWidths: List.filled(
            titles.length,
            columnWidth,
          ),
          isScrollable: isScrollable,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SizesHeader(
              titleLabel: sizesTitleLabel,
              addSizeLabel: addSizeLabel,
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
                      titles: titles,
                    ),
                    ...sizesTableData.map(
                      (row) => _SizeCard(
                        layout: layout,
                        values: row.values,
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
