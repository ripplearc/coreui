part of '../core_geometry_area.dart';

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({
    required this.data,
    required this.colors,
    required this.typography,
  });

  final CoreDimensionData data;
  final AppColorsExtension colors;
  final AppTypographyExtension typography;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${data.label}: ${data.value}',
      button: false,
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3, vertical: CoreSpacing.space2),
        decoration: BoxDecoration(
          color: colors.buttonInverse,
          borderRadius: BorderRadius.circular(CoreSpacing.space2),
          boxShadow: CoreShadows.small,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    data.label,
                    style: typography.bodySmallRegular.copyWith(
                      color: colors.textBody,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                ExcludeSemantics(
                  child: CoreIconWidget(
                    icon: CoreIcons.arrowRight,
                    color: colors.iconDark,
                    size: CoreIconSize.size20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: CoreSpacing.space1),
            Text(
              data.value,
              style: typography.bodyMediumSemiBold.copyWith(
                color: colors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
