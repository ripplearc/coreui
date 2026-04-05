part of '../../core_display_area.dart';

/// Upper section in the display area. Currently contains the close button.
/// TODO CA-590 [Display Area] history chips. https://ripplearc.youtrack.cloud/issue/CA-590/Display-Area-history-chips
class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({
    this.onClose,
    this.closeSemanticLabel = 'Close',
  });

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;
  final String closeSemanticLabel;
  static const double _closeBorderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    return Row(
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
        )
      ],
    );
  }
}
