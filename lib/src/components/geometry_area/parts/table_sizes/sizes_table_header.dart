part of '../../core_geometry_area.dart';

class _SizesTableHeader extends StatelessWidget {
  const _SizesTableHeader({
    required this.layout,
    required this.titles,
  });

  final _TableLayout layout;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Padding(
      padding: EdgeInsetsDirectional.only(start: layout.leadingSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ...titles.asMap().entries.map(
                (entry) => Container(
                  margin: EdgeInsetsDirectional.only(end: layout.endMargin),
                  width: layout.columnWidths[entry.key],
                  child: Text(
                    entry.value,
                    style: typography.bodyMediumSemiBold.copyWith(
                      color: colors.textHeadline,
                    ),
                  ),
                ),
              ),
          SizedBox(width: layout.trailingSpace),
          // right-edge guard so last column isn't flush
        ],
      ),
    );
  }
}
