import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Resolves all visual tokens for a [CoreChip] given its current state.
///
/// Keeping token resolution here means [CoreChip] contains zero hard-coded
/// colors or spacing — swap this class to re-theme the entire chip family.
abstract final class CoreChipTheme {
  static const double _smallVerticalPadding = 2.0;

  /// Returns the padding for a chip of a given [size].
  static EdgeInsets padding(CoreChipSize size) => switch (size) {
        CoreChipSize.small => const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space2,
            vertical: _smallVerticalPadding,
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

  /// Returns the background color for a chip given its [size], interaction
  /// states ([isSelected], [isPressed], [isFocused]), and the current [colors]
  /// theme.
  ///
  /// The resolved color depends on the chip size and interaction priority:
  /// pressed → focused → selected → default.
  ///
  /// Small and medium chips use a grey background by default, while the large
  /// chip uses the page background. Focus, pressed, and selected states
  /// elevate the chip to the page background.
  static Color background({
    required CoreChipSize size,
    required bool isSelected,
    required bool isPressed,
    required bool isFocused,
    required AppColorsExtension colors,
  }) {
    if (isPressed) return colors.pageBackground;

    if (isFocused &&
        (size == CoreChipSize.small || size == CoreChipSize.medium)) {
      return colors.chipGrey;
    }

    if (isSelected) return colors.pageBackground;

    return size == CoreChipSize.large ? colors.pageBackground : colors.chipGrey;
  }

  /// Returns the border color for a chip given its [size] and interaction
  /// states ([isSelected], [isPressed], [isFocused]), using the provided
  /// [colors] theme.
  ///
  /// State priority is resolved in the following order:
  /// selected → pressed → focused → default.
  ///
  /// - **Selected**: uses [colors.outlineHover].
  /// - **Pressed**: uses [colors.lineDarkOutline].
  /// - **Focused**: uses [colors.lineHighlight].
  /// - **Default**:
  ///   - [CoreChipSize.large] uses [colors.lineMid].
  ///   - [CoreChipSize.small] and [CoreChipSize.medium] use [colors.chipGrey].
  static Color borderColor({
    required CoreChipSize size,
    required bool isSelected,
    required bool isPressed,
    required bool isFocused,
    required AppColorsExtension colors,
  }) {
    if (isSelected) return colors.outlineHover;
    if (isPressed) return colors.lineDarkOutline;
    if (isFocused) return colors.lineHighlight;
    return size == CoreChipSize.large ? colors.lineMid : colors.chipGrey;
  }

  /// The default border width for all chip sizes.
  static const double borderWidth = 1;

  /// Returns the border width for the current interaction state.
  ///
  /// Focused chips get a thicker outline; all other states use
  /// [borderWidth].
  static double borderWidthFor({required bool isFocused}) =>
      isFocused ? borderWidth * 2 : borderWidth;

  /// Returns the shadow list for a chip of a given [size].
  /// Only [CoreChipSize.large] has a shadow; others return null.
  static List<BoxShadow>? shadow(CoreChipSize size) =>
      size == CoreChipSize.large ? CoreShadows.small : null;

  /// The default animation duration for pressed/selected transitions.
  static const Duration animationDuration = Duration(milliseconds: 120);
}
