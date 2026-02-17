import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A customizable tab selection component that displays multiple options
/// in a horizontal layout with smooth animations.
///
/// The selected tab is highlighted with a distinct background color and
/// shadow effect, following the Core UI design system.
///
/// ## Example
///
/// ```dart
/// CoreSelectButton(
///   tabs: ['All', 'Active', 'Archived'],
///   initialIndex: 0,
///   onChanged: (index) {
///     setState(() {
///       selectedIndex = index;
///     });
///   },
/// )
/// ```
///
/// ## Features
///
/// - Horizontal scrollable layout for many tabs
/// - Smooth 200ms animation when switching tabs
/// - Visual feedback with highlight color and shadow on selected tab
/// - Automatic spacing between tabs
/// - Accessibility support with semantic labels
///
/// See also:
/// * [AppColorsExtension.tabsHighlight], which defines the selected tab color
/// * [CoreShadows], which provides the shadow styling
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
    final colors = AppColorsExtension.of(context);

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
                return const SizedBox(width: CoreSpacing.space2);
              }
              final tabIndex = index ~/ 2;
              return _buildTab(
                context,
                label: tabs[tabIndex],
                selected: tabIndex == initialIndex,
                onTap: () => onChanged?.call(tabIndex),
              );
            },
          ),
        ),
      ),
    );
  }

  // Builds an individual tab widget with proper styling and interaction.
  Widget _buildTab(
      BuildContext context, {
        required String label,
        required bool selected,
        required VoidCallback onTap,
      }) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

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
            color: selected
                ? colors.tabsHighlight
                : colors.transparent,
            borderRadius: BorderRadius.circular(CoreSpacing.space12),
            boxShadow: selected ? CoreShadows.medium : null,
          ),
          child: Text(
            label,
            style: selected
                ? typography.bodyMediumSemiBold.copyWith(
              color: colors.textHeadline,
            )
                : typography.bodyMediumRegular.copyWith(
              color: colors.textBody,
            ),
          ),
        ),
      ),
    );
  }
}
