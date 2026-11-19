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
  final String? label;

  /// Whether to show the typing indicator animation next to the label.
  /// Defaults to false.
  final bool isTyping;

  static const double _dotsBoxHeight = CoreSpacing.space2 + CoreSpacing.space6;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final style =
        typography.titleMediumSemiBold.copyWith(color: colors.textDark);
    final text = Text(
      label ?? '',
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textWidthBasis: TextWidthBasis.longestLine,
      style: style,
    );
    if (!isTyping) {
      return Row(children: [Flexible(child: text)]);
    }
    final lineHeight =
        MediaQuery.textScalerOf(context).scale(style.fontSize ?? 0) *
            (style.height ?? 1);
    final lastLineHeight =
        lineHeight > _dotsBoxHeight ? lineHeight : _dotsBoxHeight;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Flexible(
          child: Padding(
            padding: EdgeInsets.only(bottom: (lastLineHeight - lineHeight) / 2),
            child: text,
          ),
        ),
        SizedBox(
          height: lastLineHeight,
          child: const Center(
            child: Padding(
              padding: EdgeInsets.only(top: CoreSpacing.space2),
              child: CoreWritingDots(size: CoreSpacing.space6),
            ),
          ),
        ),
      ],
    );
  }
}
