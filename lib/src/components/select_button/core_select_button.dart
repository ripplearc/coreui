import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class CoreSelectButton extends StatelessWidget {
  final List<String> tabs;
  final int initialIndex;
  final ValueChanged<int>? onChanged;

  const CoreSelectButton({
    super.key,
    required this.tabs,
    required this.initialIndex,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Container(
      decoration: BoxDecoration(
        color: colors.textInverse,
        borderRadius: BorderRadius.circular(CoreSpacing.space12),
        boxShadow: CoreShadows.small,
      ),
      padding: const EdgeInsets.all(CoreSpacing.space2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            tabs.length * 2 - 1,
            (index) {
              if (index.isOdd) {
                // Add spacing between tabs
                return const SizedBox(width: CoreSpacing.space2);
              }
              final i = index ~/ 2;
              return _buildTab(
                context,
                label: tabs[i],
                selected: i == initialIndex,
                onTap: () => onChanged?.call(i),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    return Semantics(
      label: label,
      selected: selected,
      button: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(CoreSpacing.space12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space5,
            vertical: CoreSpacing.space2,
          ),
          decoration: BoxDecoration(
            color: selected ? colors.tabsHighlight : Colors.transparent,
            borderRadius: BorderRadius.circular(CoreSpacing.space12),
            boxShadow: selected ? CoreShadows.medium : null,
          ),
          child: Text(
            label,
            style: selected
                ? CoreTypography.bodyMediumSemiBold(
                    color: colors.textHeadline,
                  )
                : CoreTypography.bodyMediumRegular(
                    color: colors.textBody,
                  ),
          ),
        ),
      ),
    );
  }
}
