part of '../core_geometry_area.dart';

class _DimensionsSection extends StatelessWidget {
  const _DimensionsSection({
    required this.dimensionsLabel,
    required this.expandLabel,
  });

  final String dimensionsLabel;
  final String expandLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space4,
        vertical: CoreSpacing.space1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            dimensionsLabel,
            style: typography.bodyLargeSemiBold.copyWith(
              color: colors.textHeadline,
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CoreIconWidget(
                icon: CoreIcons.unfoldMore,
                color: colors.iconDark,
                size: CoreIconSize.size24,
                semanticLabel: expandLabel,
              ),
              Text(
                expandLabel,
                style: typography.bodyMediumSemiBold.copyWith(
                  color: colors.textLink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
