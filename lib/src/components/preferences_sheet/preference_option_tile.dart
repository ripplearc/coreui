import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// One choice in a preference's option sub-sheet: its label, and a tick once
/// it is the choice in force.
///
/// The tile draws the pick rather than the stored preference. A sub-sheet
/// lets the user browse before committing, so a ticked tile means "this is
/// what Update will store", not "this is what is stored now".
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceOptionTile extends StatelessWidget {
  /// The choice to render.
  final CorePreferenceOption option;

  /// Whether this is the choice currently picked.
  final bool isSelected;

  /// Called when the tile is tapped.
  final VoidCallback onTap;

  /// Creates a preference option tile.
  const PreferenceOptionTile({
    super.key,
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CoreSpacing.space2),
      child: Semantics(
        selected: isSelected,
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? colors.backgroundBlueLight : colors.transparent,
            borderRadius: BorderRadius.circular(CoreSpacing.space2),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: CoreSpacing.space3,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.label,
                  style: typography.bodyLargeRegular.copyWith(
                    color: colors.textHeadline,
                  ),
                ),
              ),
              if (isSelected)
                // Decorative: the selected state is already announced by the
                // Semantics(selected:) wrapper above, so announcing the tick
                // too would say it twice.
                ExcludeSemantics(
                  child: CoreIconWidget(
                    icon: CoreIcons.checkMark,
                    size: CoreIconSize.size24,
                    color: colors.textSuccess,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
