part of '../../core_geometry_area.dart';

class _SizesHeader extends StatelessWidget {
  const _SizesHeader({
    required this.titleLabel,
    required this.addSizeLabel,
  });

  final String titleLabel;
  final String addSizeLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space4,
        vertical: CoreSpacing.space1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              titleLabel,
              style: typography.bodyLargeSemiBold.copyWith(
                color: colors.textHeadline,
              ),
            ),
          ),
          const SizedBox(width: CoreSpacing.space1),
          Semantics(
            button: true,
            label: addSizeLabel,
            excludeSemantics: true,
            child: GestureDetector(
              onTap: () {
                // TODO: [CA-682] [Geometry Area] Size Bottom Sheet (Add/Edit). https://ripplearc.youtrack.cloud/issue/CA-682
              },
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExcludeSemantics(
                    child: CoreIconWidget(
                      icon: CoreIcons.add,
                      color: colors.iconDark,
                      size: CoreIconSize.size24,
                    ),
                  ),
                  Text(
                    addSizeLabel,
                    style: typography.bodyMediumSemiBold.copyWith(
                      color: colors.textLink,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
