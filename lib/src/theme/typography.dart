import 'package:flutter/material.dart';

import 'color_tokens.dart';

/// Core Typography class that defines text styles for the application
class CoreTypography {

  // Font Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;

  // Helper method to create text styles
  static TextStyle _createStyle({
    required double fontSize,
    required double height,
    required FontWeight weight,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      height: height / fontSize,
      fontWeight: weight,
      color: color,
    );
  }

  // Headline Large (32/40)
  static TextStyle headlineLargeRegular({Color? color}) => _createStyle(
        fontSize: 32,
        height: 40,
        weight: regular,
        color: color ?? CoreTextColors.headline,
      );

  static TextStyle headlineLargeSemiBold({Color? color}) => _createStyle(
        fontSize: 32,
        height: 40,
        weight: semiBold,
        color: color ?? CoreTextColors.headline,
      );

  // Headline Medium (24/32)
  static TextStyle headlineMediumRegular({Color? color}) => _createStyle(
        fontSize: 24,
        height: 32,
        weight: regular,
        color: color ?? CoreTextColors.headline,
      );

  static TextStyle headlineMediumSemiBold({Color? color}) => _createStyle(
        fontSize: 24,
        height: 32,
        weight: semiBold,
        color: color ?? CoreTextColors.headline,
      );

  // Title Large (20/28)
  static TextStyle titleLargeRegular({Color? color}) => _createStyle(
        fontSize: 20,
        height: 28,
        weight: regular,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleLargeMedium({Color? color}) => _createStyle(
        fontSize: 20,
        height: 28,
        weight: medium,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleLargeSemiBold({Color? color}) => _createStyle(
        fontSize: 20,
        height: 28,
        weight: semiBold,
        color: color ?? CoreTextColors.dark,
      );

  // Title Medium (18/26)
  static TextStyle titleMediumRegular({Color? color}) => _createStyle(
        fontSize: 18,
        height: 26,
        weight: regular,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleMediumMedium({Color? color}) => _createStyle(
        fontSize: 18,
        height: 26,
        weight: medium,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleMediumSemiBold({Color? color}) => _createStyle(
        fontSize: 18,
        height: 26,
        weight: semiBold,
        color: color ?? CoreTextColors.dark,
      );

  // Body Large (16/24)
  static TextStyle bodyLargeRegular({Color? color}) => _createStyle(
        fontSize: 16,
        height: 24,
        weight: regular,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyLargeMedium({Color? color}) => _createStyle(
        fontSize: 16,
        height: 24,
        weight: medium,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyLargeSemiBold({Color? color}) => _createStyle(
        fontSize: 16,
        height: 24,
        weight: semiBold,
        color: color ?? CoreTextColors.body,
      );

  // Body Medium (14/20)
  static TextStyle bodyMediumRegular({Color? color}) => _createStyle(
        fontSize: 14,
        height: 20,
        weight: regular,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyMediumMedium({Color? color}) => _createStyle(
        fontSize: 14,
        height: 20,
        weight: medium,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyMediumSemiBold({Color? color}) => _createStyle(
        fontSize: 14,
        height: 20,
        weight: semiBold,
        color: color ?? CoreTextColors.body,
      );

  // Body Small (12/16)
  static TextStyle bodySmallRegular({Color? color}) => _createStyle(
        fontSize: 12,
        height: 16,
        weight: regular,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodySmallMedium({Color? color}) => _createStyle(
        fontSize: 12,
        height: 16,
        weight: medium,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodySmallSemiBold({Color? color}) => _createStyle(
        fontSize: 12,
        height: 16,
        weight: semiBold,
        color: color ?? CoreTextColors.body,
      );
}
