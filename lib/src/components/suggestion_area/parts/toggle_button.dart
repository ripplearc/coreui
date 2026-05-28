part of '../core_suggestion_area.dart';

class _ToggleButton extends StatelessWidget {
  final int hiddenCount;
  final bool isExpanded;
  final VoidCallback onTap;
  final String Function(int count) textBuilder;
  final String Function(int hiddenCount) expandSemanticsLabelBuilder;
  final String collapseSemanticsLabel;
  final bool excludeFromSemantics;

  const _ToggleButton({
    required this.hiddenCount,
    required this.isExpanded,
    required this.onTap,
    required this.textBuilder,
    required this.expandSemanticsLabelBuilder,
    required this.collapseSemanticsLabel,
    this.excludeFromSemantics = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final chipRadius = BorderRadius.circular(CoreSpacing.space6);
    final semanticsLabel = isExpanded
        ? collapseSemanticsLabel
        : expandSemanticsLabelBuilder(hiddenCount);

    return Semantics(
      label: semanticsLabel,
      button: true,
      expanded: isExpanded,
      excludeSemantics: excludeFromSemantics,
      child: Material(
        color: colors.transparent,
        child: InkWell(
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          borderRadius: chipRadius,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: CoreSpacing.space12,
              minHeight: CoreSpacing.space12,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CoreSpacing.space3,
                vertical: CoreSpacing.space3,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (!isExpanded) ...[
                    Text(
                      textBuilder(hiddenCount),
                      style: typography.bodySmallSemiBold.copyWith(
                        color: colors.textLink,
                      ),
                    ),
                    const SizedBox(width: CoreSpacing.space1),
                    ExcludeSemantics(
                      child: CoreIconWidget(
                        icon: CoreIcons.arrowDown,
                        size: CoreSpacing.space5,
                        color: colors.iconGrayMid,
                      ),
                    ),
                  ] else
                    ExcludeSemantics(
                      child: CoreIconWidget(
                        icon: CoreIcons.arrowUp,
                        size: CoreSpacing.space5,
                        color: colors.iconGrayMid,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
