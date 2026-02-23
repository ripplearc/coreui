import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Resolves all visual tokens for a [CoreChip] given its current state.
///
/// Keeping token resolution here means [CoreChip] contains zero hard-coded
/// colours or spacing — swap this class to re-theme the entire chip family.
abstract final class CoreChipTheme {
  static EdgeInsets padding(CoreChipSize size) => switch (size) {
        CoreChipSize.small => const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space2,
            vertical: 2,
          ),
        CoreChipSize.medium => const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: 6,
          ),
        CoreChipSize.large => const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: CoreSpacing.space3,
          ),
      };

  static Color background({
    required CoreChipSize size,
    required bool isSelected,
    required bool isPressed,
    required AppColorsExtension colors,
  }) {
    if (isSelected || isPressed || size == CoreChipSize.large) {
      return colors.textInverse;
    }
    return colors.chipGrey;
  }

  static Color borderColor({
    required CoreChipSize size,
    required bool isSelected,
    required bool isPressed,
    required AppColorsExtension colors,
  }) {
    if (isSelected) return colors.outlineHover;
    if (isPressed) return colors.lineDarkOutline;
    return size == CoreChipSize.large ? colors.lineMid : colors.chipGrey;
  }

  static const double borderWidth = 1;

  static List<BoxShadow>? shadow(CoreChipSize size) =>
      size == CoreChipSize.large ? CoreShadows.medium : null;

  static const Duration animationDuration = Duration(milliseconds: 120);
}
