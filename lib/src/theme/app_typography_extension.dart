import 'package:flutter/material.dart';

import 'typography.dart';

/// Extension for the Typography system that provides all text styles
/// with different weights (Regular, Medium, SemiBold)
class AppTypographyExtension extends ThemeExtension<AppTypographyExtension> {
  // Headline Large
  final TextStyle headlineLargeRegular;
  final TextStyle headlineLargeSemiBold;

  // Headline Medium
  final TextStyle headlineMediumRegular;
  final TextStyle headlineMediumSemiBold;

  // Title Large
  final TextStyle titleLargeRegular;
  final TextStyle titleLargeMedium;
  final TextStyle titleLargeSemiBold;

  // Title Medium
  final TextStyle titleMediumRegular;
  final TextStyle titleMediumMedium;
  final TextStyle titleMediumSemiBold;

  // Body Large
  final TextStyle bodyLargeRegular;
  final TextStyle bodyLargeMedium;
  final TextStyle bodyLargeSemiBold;

  // Body Medium
  final TextStyle bodyMediumRegular;
  final TextStyle bodyMediumMedium;
  final TextStyle bodyMediumSemiBold;

  // Body Small
  final TextStyle bodySmallRegular;
  final TextStyle bodySmallMedium;
  final TextStyle bodySmallSemiBold;

  const AppTypographyExtension({
    required this.headlineLargeRegular,
    required this.headlineLargeSemiBold,
    required this.headlineMediumRegular,
    required this.headlineMediumSemiBold,
    required this.titleLargeRegular,
    required this.titleLargeMedium,
    required this.titleLargeSemiBold,
    required this.titleMediumRegular,
    required this.titleMediumMedium,
    required this.titleMediumSemiBold,
    required this.bodyLargeRegular,
    required this.bodyLargeMedium,
    required this.bodyLargeSemiBold,
    required this.bodyMediumRegular,
    required this.bodyMediumMedium,
    required this.bodyMediumSemiBold,
    required this.bodySmallRegular,
    required this.bodySmallMedium,
    required this.bodySmallSemiBold,
  });

  /// Static method to get the extension from the current theme
  static AppTypographyExtension of(BuildContext context) {
    final AppTypographyExtension? extension = Theme.of(
      context,
    ).extension<AppTypographyExtension>();
    if (extension == null) {
      throw FlutterError(
        'AppTypographyExtension not found in Theme. Did you wrap your widget tree '
        'with a Theme that includes this extension?',
      );
    }
    return extension;
  }

  @override
  AppTypographyExtension copyWith({
    TextStyle? headlineLargeRegular,
    TextStyle? headlineLargeSemiBold,
    TextStyle? headlineMediumRegular,
    TextStyle? headlineMediumSemiBold,
    TextStyle? titleLargeRegular,
    TextStyle? titleLargeMedium,
    TextStyle? titleLargeSemiBold,
    TextStyle? titleMediumRegular,
    TextStyle? titleMediumMedium,
    TextStyle? titleMediumSemiBold,
    TextStyle? bodyLargeRegular,
    TextStyle? bodyLargeMedium,
    TextStyle? bodyLargeSemiBold,
    TextStyle? bodyMediumRegular,
    TextStyle? bodyMediumMedium,
    TextStyle? bodyMediumSemiBold,
    TextStyle? bodySmallRegular,
    TextStyle? bodySmallMedium,
    TextStyle? bodySmallSemiBold,
  }) {
    return AppTypographyExtension(
      headlineLargeRegular: headlineLargeRegular ?? this.headlineLargeRegular,
      headlineLargeSemiBold:
          headlineLargeSemiBold ?? this.headlineLargeSemiBold,
      headlineMediumRegular:
          headlineMediumRegular ?? this.headlineMediumRegular,
      headlineMediumSemiBold:
          headlineMediumSemiBold ?? this.headlineMediumSemiBold,
      titleLargeRegular: titleLargeRegular ?? this.titleLargeRegular,
      titleLargeMedium: titleLargeMedium ?? this.titleLargeMedium,
      titleLargeSemiBold: titleLargeSemiBold ?? this.titleLargeSemiBold,
      titleMediumRegular: titleMediumRegular ?? this.titleMediumRegular,
      titleMediumMedium: titleMediumMedium ?? this.titleMediumMedium,
      titleMediumSemiBold: titleMediumSemiBold ?? this.titleMediumSemiBold,
      bodyLargeRegular: bodyLargeRegular ?? this.bodyLargeRegular,
      bodyLargeMedium: bodyLargeMedium ?? this.bodyLargeMedium,
      bodyLargeSemiBold: bodyLargeSemiBold ?? this.bodyLargeSemiBold,
      bodyMediumRegular: bodyMediumRegular ?? this.bodyMediumRegular,
      bodyMediumMedium: bodyMediumMedium ?? this.bodyMediumMedium,
      bodyMediumSemiBold: bodyMediumSemiBold ?? this.bodyMediumSemiBold,
      bodySmallRegular: bodySmallRegular ?? this.bodySmallRegular,
      bodySmallMedium: bodySmallMedium ?? this.bodySmallMedium,
      bodySmallSemiBold: bodySmallSemiBold ?? this.bodySmallSemiBold,
    );
  }

  @override
  ThemeExtension<AppTypographyExtension> lerp(
    ThemeExtension<AppTypographyExtension>? other,
    double t,
  ) {
    if (other is! AppTypographyExtension) {
      return this;
    }

    return AppTypographyExtension(
      headlineLargeRegular:
          TextStyle.lerp(headlineLargeRegular, other.headlineLargeRegular, t) ??
              headlineLargeRegular,
      headlineLargeSemiBold: TextStyle.lerp(
            headlineLargeSemiBold,
            other.headlineLargeSemiBold,
            t,
          ) ??
          headlineLargeSemiBold,
      headlineMediumRegular: TextStyle.lerp(
            headlineMediumRegular,
            other.headlineMediumRegular,
            t,
          ) ??
          headlineMediumRegular,
      headlineMediumSemiBold: TextStyle.lerp(
            headlineMediumSemiBold,
            other.headlineMediumSemiBold,
            t,
          ) ??
          headlineMediumSemiBold,
      titleLargeRegular:
          TextStyle.lerp(titleLargeRegular, other.titleLargeRegular, t) ??
              titleLargeRegular,
      titleLargeMedium:
          TextStyle.lerp(titleLargeMedium, other.titleLargeMedium, t) ??
              titleLargeMedium,
      titleLargeSemiBold:
          TextStyle.lerp(titleLargeSemiBold, other.titleLargeSemiBold, t) ??
              titleLargeSemiBold,
      titleMediumRegular:
          TextStyle.lerp(titleMediumRegular, other.titleMediumRegular, t) ??
              titleMediumRegular,
      titleMediumMedium:
          TextStyle.lerp(titleMediumMedium, other.titleMediumMedium, t) ??
              titleMediumMedium,
      titleMediumSemiBold:
          TextStyle.lerp(titleMediumSemiBold, other.titleMediumSemiBold, t) ??
              titleMediumSemiBold,
      bodyLargeRegular:
          TextStyle.lerp(bodyLargeRegular, other.bodyLargeRegular, t) ??
              bodyLargeRegular,
      bodyLargeMedium:
          TextStyle.lerp(bodyLargeMedium, other.bodyLargeMedium, t) ??
              bodyLargeMedium,
      bodyLargeSemiBold:
          TextStyle.lerp(bodyLargeSemiBold, other.bodyLargeSemiBold, t) ??
              bodyLargeSemiBold,
      bodyMediumRegular:
          TextStyle.lerp(bodyMediumRegular, other.bodyMediumRegular, t) ??
              bodyMediumRegular,
      bodyMediumMedium:
          TextStyle.lerp(bodyMediumMedium, other.bodyMediumMedium, t) ??
              bodyMediumMedium,
      bodyMediumSemiBold:
          TextStyle.lerp(bodyMediumSemiBold, other.bodyMediumSemiBold, t) ??
              bodyMediumSemiBold,
      bodySmallRegular:
          TextStyle.lerp(bodySmallRegular, other.bodySmallRegular, t) ??
              bodySmallRegular,
      bodySmallMedium:
          TextStyle.lerp(bodySmallMedium, other.bodySmallMedium, t) ??
              bodySmallMedium,
      bodySmallSemiBold:
          TextStyle.lerp(bodySmallSemiBold, other.bodySmallSemiBold, t) ??
              bodySmallSemiBold,
    );
  }

  // Factory method to create the extension with all styles
  static AppTypographyExtension create() {
    return AppTypographyExtension(
      // Headline Large - 32/40
      headlineLargeRegular: CoreTypography.headlineLargeRegular(),
      headlineLargeSemiBold: CoreTypography.headlineLargeSemiBold(),

      // Headline Medium - 24/32
      headlineMediumRegular: CoreTypography.headlineMediumRegular(),
      headlineMediumSemiBold: CoreTypography.headlineMediumSemiBold(),

      // Title Large - 20/28
      titleLargeRegular: CoreTypography.titleLargeRegular(),
      titleLargeMedium: CoreTypography.titleLargeMedium(),
      titleLargeSemiBold: CoreTypography.titleLargeSemiBold(),

      // Title Medium - 18/26
      titleMediumRegular: CoreTypography.titleMediumRegular(),
      titleMediumMedium: CoreTypography.titleMediumMedium(),
      titleMediumSemiBold: CoreTypography.titleMediumSemiBold(),

      // Body Large - 16/24
      bodyLargeRegular: CoreTypography.bodyLargeRegular(),
      bodyLargeMedium: CoreTypography.bodyLargeMedium(),
      bodyLargeSemiBold: CoreTypography.bodyLargeSemiBold(),

      // Body Medium - 14/20
      bodyMediumRegular: CoreTypography.bodyMediumRegular(),
      bodyMediumMedium: CoreTypography.bodyMediumMedium(),
      bodyMediumSemiBold: CoreTypography.bodyMediumSemiBold(),

      // Body Small - 12/16
      bodySmallRegular: CoreTypography.bodySmallRegular(),
      bodySmallMedium: CoreTypography.bodySmallMedium(),
      bodySmallSemiBold: CoreTypography.bodySmallSemiBold(),
    );
  }
}

extension TypographyTheme on ThemeData {
  AppTypographyExtension get coreTypography =>
      extension<AppTypographyExtension>() ?? AppTypographyExtension.create();
}
