import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Resolves all visual tokens for a [CoreChip] given its current state.
///
/// Keeping token resolution here means [CoreChip] contains zero hard-coded
/// colors or spacing — swap this class to re-theme the entire chip family.
abstract final class CoreChipTheme {
  static const double _smallVerticalPadding = 2.0;
  static const double _largeVerticalPadding = 13.0;

  /// Returns the padding for a chip of a given [size]. [CoreChipSize.mini]
  /// shares the medium padding: it is the large surface at the medium height.
  /// [CoreChipSize.large] is the Figma Suggestion Strip Chip: 48 high with
  /// its 1 px border, and 16 px at each side once the label row's trailing
  /// [CoreSpacing.space2] is counted.
  static EdgeInsetsDirectional padding(CoreChipSize size) => switch (size) {
        CoreChipSize.small => const EdgeInsetsDirectional.symmetric(
            horizontal: CoreSpacing.space2,
            vertical: _smallVerticalPadding,
          ),
        CoreChipSize.medium ||
        CoreChipSize.mini =>
          const EdgeInsetsDirectional.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: CoreSpacing.space2,
          ),
        CoreChipSize.large => const EdgeInsetsDirectional.fromSTEB(
            CoreSpacing.space4,
            _largeVerticalPadding,
            CoreSpacing.space2,
            _largeVerticalPadding,
          ),
      };

  /// Whether a chip of [size] sits on the page background with a `lineMid`
  /// outline ([CoreChipSize.large] and [CoreChipSize.mini]) rather than on
  /// the grey chip surface ([CoreChipSize.small] and [CoreChipSize.medium]).
  static bool onPageSurface(CoreChipSize size) =>
      size == CoreChipSize.large || size == CoreChipSize.mini;

  /// Returns the background color for a chip given its [size], interaction
  /// states ([isSelected], [isPressed], [isFocused]), [outline], and the
  /// current [colors] theme.
  ///
  /// The resolved color depends on the chip size and interaction priority:
  /// pressed → dashed outline → focused → selected → default.
  ///
  /// Small and medium chips use a grey background by default, while the large
  /// and mini chips use the page background ([onPageSurface]). Focus,
  /// pressed, and selected states elevate the chip to the page background.
  /// The outline style does not change the fill: a [CoreChipOutline.dashed]
  /// or [CoreChipOutline.highlight] chip takes the same background as a solid
  /// one of its size (Figma Suggestion Strip Chip).
  static Color background({
    required CoreChipSize size,
    required bool isSelected,
    required bool isPressed,
    required bool isFocused,
    required AppColorsExtension colors,
    CoreChipOutline outline = CoreChipOutline.solid,
  }) {
    if (isPressed) return colors.pageBackground;

    if (isFocused && !onPageSurface(size)) {
      return colors.chipGrey;
    }

    if (isSelected) return colors.pageBackground;

    return onPageSurface(size) ? colors.pageBackground : colors.chipGrey;
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
  /// - **Focused** or [CoreChipOutline.highlight]: uses [colors.lineHighlight].
  /// - **Default**:
  ///   - [CoreChipSize.large] and [CoreChipSize.mini] use [colors.lineMid].
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
    if (isFocused || outline == CoreChipOutline.highlight) {
      return colors.lineHighlight;
    }
    return onPageSurface(size) ? colors.lineMid : colors.chipGrey;
  }

  /// The label's text style: `bodyMediumRegular` in [colors.textDark] for
  /// [CoreChipSize.large] (Figma Suggestion Strip Chip), otherwise
  /// `bodyMediumMedium` in [colors.textBody].
  static TextStyle labelStyle({
    required CoreChipSize size,
    required AppTypographyExtension typography,
    required AppColorsExtension colors,
  }) =>
      size == CoreChipSize.large
          ? typography.bodyMediumRegular.copyWith(color: colors.textDark)
          : typography.bodyMediumMedium.copyWith(color: colors.textBody);

  /// The gap between the label and the value: [CoreSpacing.space2] for
  /// [CoreChipSize.large], [CoreSpacing.space1] otherwise.
  static double labelGap(CoreChipSize size) =>
      size == CoreChipSize.large ? CoreSpacing.space2 : CoreSpacing.space1;

  /// The value's text style in [colors.textDark]: `bodyMediumMedium`;
  /// `bodyMediumSemiBold` for [CoreChipSize.mini], whose whole value reads
  /// semibold instead of ending in a heavy unit; and `bodyMediumSemiBold` at
  /// [unitFontWeight] for [CoreChipSize.large], whose whole value is heavy.
  static TextStyle valueStyle({
    required CoreChipSize size,
    required AppTypographyExtension typography,
    required AppColorsExtension colors,
  }) =>
      switch (size) {
        CoreChipSize.mini => typography.bodyMediumSemiBold,
        CoreChipSize.large => typography.bodyMediumSemiBold.copyWith(
            fontWeight: unitFontWeight,
          ),
        CoreChipSize.small ||
        CoreChipSize.medium =>
          typography.bodyMediumMedium,
      }
          .copyWith(color: colors.textDark);

  /// The unit's text style in [colors.textDark]: `bodyMediumSemiBold` at
  /// [unitFontWeight], or plain `bodyMediumSemiBold` for [CoreChipSize.mini]
  /// so the unit matches its value.
  static TextStyle unitStyle({
    required CoreChipSize size,
    required AppTypographyExtension typography,
    required AppColorsExtension colors,
  }) =>
      typography.bodyMediumSemiBold.copyWith(
        fontWeight: size == CoreChipSize.mini ? null : unitFontWeight,
        color: colors.textDark,
      );

  /// The heavy weight of a unit on every size but [CoreChipSize.mini].
  static const FontWeight unitFontWeight = FontWeight.w800;

  /// The default border width for all chip sizes.
  static const double borderWidth = 1;

  /// Returns the border width for the current interaction state and
  /// [outline].
  ///
  /// Focused chips and [CoreChipOutline.highlight] chips get a double-width
  /// outline; all other states use [borderWidth].
  static double borderWidthFor({
    required bool isFocused,
    CoreChipOutline outline = CoreChipOutline.solid,
  }) =>
      isFocused || outline == CoreChipOutline.highlight
          ? borderWidth * 2
          : borderWidth;

  /// Returns the dashed outline for a chip with the given [outline], or
  /// `null` for [CoreChipOutline.solid]. The stroke follows [borderWidthFor]
  /// when focused, so a focused dashed chip thickens like a solid one, and is
  /// [dashedStrokeWidth] at rest; [CoreChip] applies it as its
  /// `foregroundDecoration`.
  static CoreDashedBorderDecoration? dashedOutline({
    required CoreChipOutline outline,
    required bool isFocused,
    required AppColorsExtension colors,
  }) {
    if (outline != CoreChipOutline.dashed) return null;
    return CoreDashedBorderDecoration(
      color: colors.outlineFocus,
      strokeWidth: isFocused
          ? borderWidthFor(isFocused: isFocused)
          : dashedStrokeWidth,
      radius: CoreSpacing.space6,
      dashLength: dashLength,
      gapLength: gapLength,
    );
  }

  /// Resting stroke width of the [CoreChipOutline.dashed] outline (Figma
  /// Suggestion Strip Chip, Bind).
  static const double dashedStrokeWidth = 1.5;

  /// Dash length of the [CoreChipOutline.dashed] outline.
  static const double dashLength = CoreSpacing.space1;

  /// Gap length between dashes of the [CoreChipOutline.dashed] outline.
  static const double gapLength = CoreSpacing.space1;

  /// The default animation duration for pressed/selected transitions.
  static const Duration animationDuration = Duration(milliseconds: 120);
}
