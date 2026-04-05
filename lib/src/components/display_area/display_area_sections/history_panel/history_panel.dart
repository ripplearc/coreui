part of '../../core_display_area.dart';

/// Upper section in display area,
/// It contains close button and history chips
class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({this.onClose});

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

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
            semanticLabel: 'Close',
          ),
        )
      ],
    );
  }
}
