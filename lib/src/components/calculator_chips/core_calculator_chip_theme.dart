import 'package:flutter/material.dart';

import '../../../../ripplearc_coreui.dart';

/// Resolves all visual tokens for a [CoreCalculatorChip] given its current state.
///
/// Keeping token resolution here means [CoreCalculatorChip] contains zero hard-coded
/// colors or spacing — swap this class to re-theme the entire calculator chip family.
abstract final class CoreCalculatorChipTheme {
  /// Returns the padding for all calculator chips.
  static EdgeInsets get padding => const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space2,
        vertical: CoreSpacing.space1,
      );

  /// Returns the background color for a calculator chip given its [type]
  /// and the current [colors] theme.
  static Color background({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable => colors.pageBackground,
      CoreCalculatorChipType.disabled => colors.backgroundGrayMid,
      CoreCalculatorChipType.active => colors.backgroundGreenMid,
    };
  }

  /// Returns the border color for a calculator chip given its [type]
  /// and the current [colors] theme.
  static Color borderColor({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable => colors.outlineFocus,
      CoreCalculatorChipType.disabled => colors.lineMid,
      CoreCalculatorChipType.active => colors.lineMid,
    };
  }

  /// Returns the label text style for a calculator chip given its [type],
  /// current [colors] theme, and [typography].
  static TextStyle labelStyle({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
    required AppTypographyExtension typography,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable =>
        typography.bodySmallRegular.copyWith(color: colors.textLink),
      CoreCalculatorChipType.disabled =>
        typography.bodySmallRegular.copyWith(color: colors.textDark),
      CoreCalculatorChipType.active =>
        typography.bodySmallRegular.copyWith(color: colors.textDark),
    };
  }

  /// Returns the value text style for a calculator chip given its [type],
  /// current [colors] theme, and [typography].
  static TextStyle valueStyle({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
    required AppTypographyExtension typography,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable =>
        typography.bodyMediumSemiBold.copyWith(color: colors.textLink),
      CoreCalculatorChipType.disabled =>
        typography.bodyMediumSemiBold.copyWith(color: colors.textDark),
      CoreCalculatorChipType.active =>
        typography.bodyMediumSemiBold.copyWith(color: colors.textDark),
    };
  }

  /// Returns the close icon color for a calculator chip given its [type]
  /// and the current [colors] theme.
  static Color iconColor({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable => colors.iconOrient,
      CoreCalculatorChipType.disabled => colors.iconGrayMid,
      CoreCalculatorChipType.active => colors.iconGrayDark,
    };
  }

  /// Returns the shadow list for a calculator chip.
  /// No shadow is defined for calculator chips by default.
  static List<BoxShadow>? shadow(CoreCalculatorChipType type) => null;

  /// The standard border radius for all calculator chips.
  static BorderRadius get borderRadius =>
      BorderRadius.circular(CoreSpacing.space6);

  /// The default border width for all calculator chips.
  static const double borderWidth = 1;
}
