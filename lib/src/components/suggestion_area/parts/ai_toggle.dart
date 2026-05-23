part of '../core_suggestion_area.dart';

class _AIToggle extends StatelessWidget {
  const _AIToggle({
    required this.mode,
    required this.onChanged,
  });

  final SuggestionMode mode;
  final ValueChanged<SuggestionMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final isAiMode = mode == SuggestionMode.ai;

    return Semantics(
      label: 'Toggle suggestion mode',
      button: true,
      toggled: isAiMode,
      child: GestureDetector(
        onTap: () =>
            onChanged(isAiMode ? SuggestionMode.conversion : SuggestionMode.ai),
        behavior: HitTestBehavior.opaque,
        child: Container(
          height: CoreSpacing.space12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CoreSpacing.space6),
            gradient: LinearGradient(
              colors: [
                colors.indigo,
                colors.backgroundGrayLight,
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.all(CoreSpacing.space1),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOutCubic,
                  alignment:
                      isAiMode ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    width: CoreSpacing.space10,
                    height: CoreSpacing.space10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colors.iconWhite,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildIconContainer(
                    icon: CoreIcons.stars,
                    isSelected: isAiMode,
                    unselectedColor: colors.orientMid,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                  _buildIconContainer(
                    icon: CoreIcons.ruler,
                    isSelected: !isAiMode,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer({
    required CoreIconData icon,
    required bool isSelected,
    Color? unselectedColor,
  }) {
    return SizedBox(
      width: CoreSpacing.space10,
      height: CoreSpacing.space10,
      child: Center(
        child: CoreIconWidget(
          icon: icon,
          color: isSelected ? null : unselectedColor,
        ),
      ),
    );
  }
}
