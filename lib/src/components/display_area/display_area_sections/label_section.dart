part of '../core_display_area.dart';

/// A widget that displays the main text label in the display area.
///
/// It optionally shows a typing animation indicator next to the label
/// if [isTyping] is set to true. A label longer than the row wraps onto a
/// second line and ends in an ellipsis after that, so a name such as
/// "Pitch-rise per 12in run" stays inside a phone's width instead of running
/// past its edge. The dots stay centred on the label block: a two-line label
/// puts them between its lines, which keeps every one-line label row where it
/// was.
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Row(
      children: [
        Flexible(
          child: Text(label ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: typography.titleMediumSemiBold
                  .copyWith(color: colors.textDark)),
        ),
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
