import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

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
  ///
  /// [CoreCalculatorChipType.result] deliberately shares the muted grey of
  /// [CoreCalculatorChipType.disabled] (prototype `.t-result`): the two differ
  /// in interactivity, not in fill.
  static Color background({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable => colors.pageBackground,
      CoreCalculatorChipType.disabled => colors.backgroundGrayMid,
      CoreCalculatorChipType.active => colors.backgroundGreenMid,
      CoreCalculatorChipType.result => colors.backgroundGrayMid,
      CoreCalculatorChipType.dashed => colors.backgroundBlueLight,
      CoreCalculatorChipType.error => colors.alertRed,
    };
  }

  /// Returns the solid border color for a calculator chip given its [type]
  /// and the current [colors] theme.
  ///
  /// [CoreCalculatorChipType.dashed] resolves to `transparent`: its outline is
  /// painted by [dashedOutline] instead, and the transparent side keeps the
  /// border width in the layout so every variant measures the same.
  static Color borderColor({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable => colors.outlineFocus,
      CoreCalculatorChipType.disabled => colors.lineMid,
      CoreCalculatorChipType.active => colors.lineMid,
      CoreCalculatorChipType.result => colors.lineMid,
      CoreCalculatorChipType.dashed => colors.transparent,
      CoreCalculatorChipType.error => colors.alertRed,
    };
  }

  /// Returns the dashed outline for a calculator chip given its [type] and
  /// the current [colors] theme, or `null` when the variant has a solid
  /// border. [CoreCalculatorChip] applies it as its `foregroundDecoration`.
  static CoreDashedBorderDecoration? dashedOutline({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    if (type != CoreCalculatorChipType.dashed) return null;
    return CoreDashedBorderDecoration(
      color: colors.outlineFocus,
      strokeWidth: borderWidth,
      radius: CoreSpacing.space6,
      dashLength: dashLength,
      gapLength: gapLength,
    );
  }

  /// Returns the label text style for a calculator chip given its [type],
  /// current [colors] theme, and [typography].
  static TextStyle labelStyle({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
    required AppTypographyExtension typography,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable ||
      CoreCalculatorChipType.dashed =>
        typography.bodySmallRegular.copyWith(color: colors.textLink),
      CoreCalculatorChipType.disabled ||
      CoreCalculatorChipType.active ||
      CoreCalculatorChipType.result ||
      CoreCalculatorChipType.error =>
        typography.bodySmallRegular.copyWith(color: colors.textDark),
    };
  }

  /// Returns the value text style for a calculator chip given its [type],
  /// current [colors] theme, and [typography].
  ///
  /// [CoreCalculatorChipType.error] drops to regular weight: the chip carries
  /// a sentence ("Dimension error"), not a number.
  static TextStyle valueStyle({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
    required AppTypographyExtension typography,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable ||
      CoreCalculatorChipType.dashed =>
        typography.bodyMediumSemiBold.copyWith(color: colors.textLink),
      CoreCalculatorChipType.disabled ||
      CoreCalculatorChipType.active ||
      CoreCalculatorChipType.result =>
        typography.bodyMediumSemiBold.copyWith(color: colors.textDark),
      CoreCalculatorChipType.error =>
        typography.bodyMediumRegular.copyWith(color: colors.textDark),
    };
  }

  /// Returns the factor icon color for a calculator chip given its [type]
  /// and the current [colors] theme.
  static Color factorColor({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable ||
      CoreCalculatorChipType.dashed =>
        colors.iconOrient,
      CoreCalculatorChipType.disabled => colors.iconGrayMid,
      CoreCalculatorChipType.active ||
      CoreCalculatorChipType.result =>
        colors.iconGrayDark,
      CoreCalculatorChipType.error => colors.iconRed,
    };
  }

  /// Returns the shadow list for a calculator chip.
  /// No shadow is defined for calculator chips by default except for editable chips.
  static List<BoxShadow>? shadow(CoreCalculatorChipType type) =>
      type == CoreCalculatorChipType.editable ? CoreShadows.small : null;

  /// The standard border radius for all calculator chips.
  static BorderRadius get borderRadius =>
      BorderRadius.circular(CoreSpacing.space6);

  /// The default border width for all calculator chips.
  static const double borderWidth = 1;

  /// Dash length of the [CoreCalculatorChipType.dashed] outline.
  static const double dashLength = CoreSpacing.space1;

  /// Gap length between dashes of the [CoreCalculatorChipType.dashed] outline.
  static const double gapLength = CoreSpacing.space1;
}
