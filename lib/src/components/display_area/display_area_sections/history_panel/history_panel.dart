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
  });

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

  /// The semantic label for the close button, used for accessibility.
  final String closeSemanticLabel;

  /// The width of the close button's border.
  static const double _closeBorderWidth = 1.5;

  /// The list of items (chips) to be displayed in the history section.
  final List<CoreCalculatorChip> chipsList;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: CoreSpacing.space3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
              size: CoreSpacing.space6,
              color: colors.iconDark,
              padding: const EdgeInsets.all(CoreSpacing.space2),
              onTap: onClose,
              semanticLabel: closeSemanticLabel,
            ),
          ),
          const SizedBox(width: CoreSpacing.space2),
          _HistoryChips(
            chipsList: chipsList,
          )
        ],
      ),
    );
  }
}
