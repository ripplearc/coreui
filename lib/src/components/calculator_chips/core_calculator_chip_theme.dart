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
  /// in interactivity, not in fill. [CoreCalculatorChipType.bracketOpen]
  /// wears the live green of [CoreCalculatorChipType.active] (prototype
  /// `.t-group-open`), because it is the chip being typed into.
  static Color background({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable => colors.pageBackground,
      CoreCalculatorChipType.disabled => colors.backgroundGrayMid,
      CoreCalculatorChipType.active ||
      CoreCalculatorChipType.bracketOpen =>
        colors.backgroundGreenMid,
      CoreCalculatorChipType.result => colors.backgroundGrayMid,
      CoreCalculatorChipType.dashed => colors.backgroundBlueLight,
      CoreCalculatorChipType.bracketClosed => colors.backgroundBlueMid,
      CoreCalculatorChipType.error => colors.alertRed,
    };
  }

  /// Whether [type] paints its edge as a dash rather than a solid border.
  /// The dash means one thing on the tape: this chip is not settled yet — a
  /// tentative value, or a bracket still open. [borderColor] and
  /// [dashedOutline] both read it, so a variant is never solid and dashed at
  /// once, or neither.
  static bool isDashed(CoreCalculatorChipType type) => switch (type) {
        CoreCalculatorChipType.dashed ||
        CoreCalculatorChipType.bracketOpen =>
          true,
        CoreCalculatorChipType.editable ||
        CoreCalculatorChipType.disabled ||
        CoreCalculatorChipType.active ||
        CoreCalculatorChipType.result ||
        CoreCalculatorChipType.error ||
        CoreCalculatorChipType.bracketClosed =>
          false,
      };

  /// Returns the edge color of a calculator chip given its [type] and the
  /// current [colors] theme — the solid border, or the dash for a variant
  /// that [isDashed].
  static Color edgeColor({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    return switch (type) {
      CoreCalculatorChipType.editable ||
      CoreCalculatorChipType.dashed ||
      CoreCalculatorChipType.bracketOpen ||
      CoreCalculatorChipType.bracketClosed =>
        colors.outlineFocus,
      CoreCalculatorChipType.disabled ||
      CoreCalculatorChipType.active ||
      CoreCalculatorChipType.result =>
        colors.lineMid,
      CoreCalculatorChipType.error => colors.alertRedOutline,
    };
  }

  /// Returns the solid border color for a calculator chip given its [type]
  /// and the current [colors] theme.
  ///
  /// A variant that [isDashed] resolves to `transparent`: its outline is
  /// painted by [dashedOutline] instead, and the transparent side keeps the
  /// border width in the layout so every variant measures the same.
  static Color borderColor({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) =>
      isDashed(type)
          ? colors.transparent
          : edgeColor(type: type, colors: colors);

  /// Returns the dashed outline for a calculator chip given its [type] and
  /// the current [colors] theme, or `null` unless the variant [isDashed].
  /// [CoreCalculatorChip] applies it as its `foregroundDecoration`.
  static CoreDashedBorderDecoration? dashedOutline({
    required CoreCalculatorChipType type,
    required AppColorsExtension colors,
  }) {
    if (!isDashed(type)) return null;
    return CoreDashedBorderDecoration(
      color: edgeColor(type: type, colors: colors),
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
      CoreCalculatorChipType.dashed ||
      CoreCalculatorChipType.bracketOpen ||
      CoreCalculatorChipType.bracketClosed =>
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
      CoreCalculatorChipType.dashed ||
      CoreCalculatorChipType.bracketOpen ||
      CoreCalculatorChipType.bracketClosed =>
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
      CoreCalculatorChipType.dashed ||
      CoreCalculatorChipType.bracketOpen ||
      CoreCalculatorChipType.bracketClosed =>
        colors.iconOrient,
      CoreCalculatorChipType.disabled => colors.iconGrayMid,
      CoreCalculatorChipType.active ||
      CoreCalculatorChipType.result =>
        colors.iconGrayDark,
      CoreCalculatorChipType.error => colors.iconRed,
    };
  }

  /// Returns the shadow list for a calculator chip, or `null` for the flat
  /// variants.
  ///
  /// The Figma Calculator Chip spec raises the outlined chips —
  /// [CoreCalculatorChipType.editable], [CoreCalculatorChipType.dashed] and
  /// [CoreCalculatorChipType.error] — with [CoreShadows.small]; the filled
  /// `disabled`, `active` and `result` chips sit flat on the tape, and so do
  /// the two bracket chips, whose fills carry their meaning.
  static List<BoxShadow>? shadow(CoreCalculatorChipType type) => switch (type) {
        CoreCalculatorChipType.editable ||
        CoreCalculatorChipType.dashed ||
        CoreCalculatorChipType.error =>
          CoreShadows.small,
        CoreCalculatorChipType.disabled ||
        CoreCalculatorChipType.active ||
        CoreCalculatorChipType.result ||
        CoreCalculatorChipType.bracketOpen ||
        CoreCalculatorChipType.bracketClosed =>
          null,
      };

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
