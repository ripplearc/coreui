import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A horizontal tab selection component that displays multiple options
/// with smooth animated transitions between selections.
///
/// This is a **controlled** widget — the parent is responsible for tracking
/// the selected index and passing it via [selectedIndex]. When the user taps
/// a tab, [onChanged] is called with the new index, and the parent should
/// update [selectedIndex] accordingly to reflect the change visually.
///
/// Example:
/// ```dart
/// CoreSelectButton(
///   tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
///   selectedIndex: _selectedIndex,
///   onChanged: (index) => setState(() => _selectedIndex = index),
/// )
/// ```
class CoreSelectButton extends StatelessWidget {
  /// The list of tab labels to display.
  final List<String> tabs;

  /// The index of the currently selected tab (0-based).
  ///
  /// This is a controlled property — the parent must update this value
  /// in response to [onChanged] to reflect the new selection visually.
  final int selectedIndex;

  /// Called when the user taps a tab. The tapped tab's index is passed
  /// as the argument. If null, taps are still registered but have no effect.
  final ValueChanged<int>? onChanged;

  const CoreSelectButton({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    this.onChanged,
  })  : assert(selectedIndex >= 0, 'selectedIndex must be >= 0'),
        assert(tabs.length == 0 || selectedIndex < tabs.length,
            'selectedIndex must be < tabs.length');

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);

    return Container(
      key: const Key('core_select_button_outer'),
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: BorderRadius.circular(CoreSpacing.space12),
        boxShadow: CoreShadows.small,
      ),
      padding: const EdgeInsets.all(CoreSpacing.space2),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            tabs.isEmpty ? 0 : tabs.length * 2 - 1,
            (index) {
              if (index.isOdd) {
                return const SizedBox(width: CoreSpacing.space2);
              }
              final tabIndex = index ~/ 2;
              return _buildTab(
                context,
                label: tabs[tabIndex],
                selected: tabIndex == selectedIndex,
                onTap: () {
                  if (tabIndex != selectedIndex) {
                    onChanged?.call(tabIndex);
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  static const Duration _kTabTransitionDuration = Duration(milliseconds: 200);

  Widget _buildTab(
    BuildContext context, {
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: BorderRadius.circular(CoreSpacing.space12),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(CoreSpacing.space12),
          ),
          onTap: onTap,
          child: AnimatedContainer(
            duration: _kTabTransitionDuration,
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space5,
              vertical: CoreSpacing.space2,
            ),
            decoration: BoxDecoration(
              color: selected ? colors.tabsHighlight : colors.transparent,
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
      ),
    );
  }
}
