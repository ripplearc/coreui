part of '../../core_geometry_area.dart';

class _SizesHeader extends StatelessWidget {
  const _SizesHeader({
    required this.titleLabel,
    required this.addSizeLabel,
    this.onAddTap,
  });

  final String titleLabel;
  final String addSizeLabel;
  final VoidCallback? onAddTap;

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
              onTap: onAddTap,
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
