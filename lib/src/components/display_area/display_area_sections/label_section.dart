part of '../core_display_area.dart';

/// A widget that displays the main text label in the display area.
///
/// It optionally shows a typing animation indicator next to the label
/// if [isTyping] is set to true.
class _LabelSection extends StatelessWidget {
  /// Creates a [_LabelSection].
  const _LabelSection({
    required this.label,
    this.isTyping = false,
  });

  /// The main text label to be displayed.
  final String label;

  /// Whether to show the typing indicator animation next to the label.
  /// Defaults to false.
  final bool isTyping;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Row(
      children: [
        Text(label,
            style: typography.titleMediumSemiBold
                .copyWith(color: colors.textDark)),
        if (isTyping)
          const Padding(
            padding: EdgeInsets.only(top: CoreSpacing.space2),
            child: CoreWritingDots(
              size: CoreSpacing.space6,
            ),
          ),
      ],
    );
  }
}
