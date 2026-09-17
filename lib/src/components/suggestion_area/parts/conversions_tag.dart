part of '../core_suggestion_area.dart';

class _ConversionsTag extends StatelessWidget {
  final String label;

  const _ConversionsTag({required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CoreIconWidget(
            icon: CoreIcons.ruler,
            size: CoreSpacing.space4,
            color: colors.iconGrayMid,
          ),
          const SizedBox(width: CoreSpacing.space1),
          Text(
            label,
            style: typography.bodySmallRegular.copyWith(color: colors.textBody),
          ),
        ],
      ),
    );
  }
}
