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
  /// states ([isSelected], [isPressed], [isFocused]), [outline], and the
  /// current [colors] theme.
  ///
  /// The resolved color depends on the chip size and interaction priority:
  /// pressed → dashed outline → focused → selected → default.
  ///
  /// Small and medium chips use a grey background by default, while the large
  /// chip uses the page background. Focus, pressed, and selected states
  /// elevate the chip to the page background. A [CoreChipOutline.dashed] chip
  /// sits on `backgroundBlueLight` (prototype `.s-bind`) unless pressed.
  static Color background({
    required CoreChipSize size,
    required bool isSelected,
    required bool isPressed,
    required bool isFocused,
    required AppColorsExtension colors,
    CoreChipOutline outline = CoreChipOutline.solid,
  }) {
    if (isPressed) return colors.pageBackground;

    if (outline == CoreChipOutline.dashed) return colors.backgroundBlueLight;

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
  ///
  /// A [CoreChipOutline.dashed] chip resolves to `transparent` in every state:
  /// its outline is painted by [dashedOutline] instead, and the transparent
  /// side keeps the border width in the layout so the chip measures the same.
  static Color borderColor({
    required CoreChipSize size,
    required bool isSelected,
    required bool isPressed,
    required bool isFocused,
    required AppColorsExtension colors,
    CoreChipOutline outline = CoreChipOutline.solid,
  }) {
    if (outline == CoreChipOutline.dashed) return colors.transparent;
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

  /// Returns the dashed outline for a chip with the given [outline], or
  /// `null` for [CoreChipOutline.solid]. The stroke follows [borderWidthFor]
  /// so a focused dashed chip thickens like a solid one; [CoreChip] applies
  /// it as its `foregroundDecoration`.
  static CoreDashedBorderDecoration? dashedOutline({
    required CoreChipOutline outline,
    required bool isFocused,
    required AppColorsExtension colors,
  }) {
    if (outline != CoreChipOutline.dashed) return null;
    return CoreDashedBorderDecoration(
      color: colors.outlineFocus,
      strokeWidth: borderWidthFor(isFocused: isFocused),
      radius: CoreSpacing.space6,
      dashLength: dashLength,
      gapLength: gapLength,
    );
  }

  /// Dash length of the [CoreChipOutline.dashed] outline.
  static const double dashLength = CoreSpacing.space1;

  /// Gap length between dashes of the [CoreChipOutline.dashed] outline.
  static const double gapLength = CoreSpacing.space1;

  /// Returns the shadow list for a chip of a given [size].
  /// Only [CoreChipSize.large] has a shadow; others return null.
  static List<BoxShadow>? shadow(CoreChipSize size) =>
      size == CoreChipSize.large ? CoreShadows.small : null;

  /// The default animation duration for pressed/selected transitions.
  static const Duration animationDuration = Duration(milliseconds: 120);
}
