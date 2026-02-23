import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Resolves all visual tokens for a [CoreChip] given its current state.
///
/// Keeping token resolution here means [CoreChip] contains zero hard-coded
/// colors or spacing — swap this class to re-theme the entire chip family.
abstract final class CoreChipTheme {
  /// Returns the padding for a chip of a given [size].
  static EdgeInsets padding(CoreChipSize size) => switch (size) {
        CoreChipSize.small => const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space2,
            vertical: CoreSpacing.space3 / CoreSpacing.space2,
          ),
        CoreChipSize.medium => const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: CoreSpacing.space2,
          ),
        CoreChipSize.large => const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: CoreSpacing.space3,
          ),
      };

  /// Returns the background color for a chip given its [size], [isSelected],
  /// [isPressed] state, and the current [colors] theme.
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

  /// Returns the border color for a chip given its [size], [isSelected],
  /// [isPressed] state, and the current [colors] theme.
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

  /// The default border width for all chip sizes.
  static const double borderWidth = 1;

  /// Returns the shadow list for a chip of a given [size].
  /// Only [CoreChipSize.large] has a shadow; others return null.
  static List<BoxShadow>? shadow(CoreChipSize size) =>
      size == CoreChipSize.large ? CoreShadows.medium : null;

  /// The default animation duration for pressed/selected transitions.
  static const Duration animationDuration = Duration(milliseconds: 120);
}
