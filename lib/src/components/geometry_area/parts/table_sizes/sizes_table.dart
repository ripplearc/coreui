part of '../../core_geometry_area.dart';

class TableLayout {
  const TableLayout({
    required this.leadingSpace,
    required this.trailingSpace,
    required this.columnWidths,
    required this.endMargin,
  });

  final double leadingSpace;
  final double trailingSpace;
  final double endMargin;
  final List<double> columnWidths;
}

class _SizesTable extends StatelessWidget {
  const _SizesTable({
    required this.sizesTitleLabel,
    required this.addSizeLabel,
    required this.titles,
  });

  final String sizesTitleLabel;
  final String addSizeLabel;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const leadingSpace = CoreSpacing.space12;
        const trailingSpace = CoreSpacing.space4;
        final columnWidth = CoreSpacing.space16;
        final endMargin = CoreSpacing.space1;

        final totalWidth = leadingSpace +
            trailingSpace +
            ((columnWidth + endMargin) * titles.length);
        final containerWidth = math.max(constraints.maxWidth, totalWidth);

        final layout = TableLayout(
          leadingSpace: leadingSpace,
          trailingSpace: trailingSpace,
          endMargin: endMargin,
          columnWidths: List.filled(
            titles.length,
            columnWidth,
          ),
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
                    // TODO: [CA-679] [Geometry Area] Sizes table Row Card. https://ripplearc.youtrack.cloud/agiles/176-9/179-52?issue=CA-679
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
