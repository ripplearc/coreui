part of '../../core_display_area.dart';

/// A widget representing the upper history panel section in the display area.
///
/// This panel includes a close button and a list of history chips.
class _HistoryPanel extends StatelessWidget {
  /// Creates a [_HistoryPanel].
  const _HistoryPanel({
    this.onClose,
    this.closeSemanticLabel = 'Close',
    required this.chipsList,
    this.historyPlaceholder = 'Here will show what you type',
  });

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

  /// The semantic label for the close button, used for accessibility.
  final String closeSemanticLabel;

  /// The width of the close button's border.
  static const double _closeBorderWidth = 1.5;

  /// The list of items (chips) to be displayed in the history section.
  final List<CoreCalculatorChip> chipsList;

  /// The placeholder text to display when the [chipsList] is empty.
  final String historyPlaceholder;

  /// The top space to align with chips single row.
  static const double _topSpace = CoreSpacing.space1;

  /// Fixed height for the history panel (84px).
  /// This is enforced by design specs and may not scale well with large text.
  // TODO: [CA-634] Track a11y improvement to support dynamic height with text scaling.
  // https://ripplearc.youtrack.cloud/issue/CA-634
  static const double _panelHeight = 84;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Container(
      height: _panelHeight,
      margin: const EdgeInsets.only(top: CoreSpacing.space1),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: _topSpace),
            decoration: BoxDecoration(
              color: colors.backgroundBlueMid,
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.outlineFocus,
                width: _closeBorderWidth,
              ),
            ),
            child: CoreIconWidget(
              icon: CoreIcons.cross,
              size: CoreSpacing.space7,
              color: colors.iconDark,
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.all(CoreSpacing.space3),
              onTap: onClose,
              semanticLabel: closeSemanticLabel,
            ),
          ),
          const SizedBox(width: CoreSpacing.space2),
          if (chipsList.isNotEmpty)
            _HistoryChips(
              chipsList: chipsList,
            )
          else
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(top: CoreSpacing.space5),
                child: Text(
                  historyPlaceholder,
                  style: typography.bodyMediumRegular
                      .copyWith(color: colors.textHeadline),
                ),
              ),
            )
        ],
      ),
    );
  }
}
