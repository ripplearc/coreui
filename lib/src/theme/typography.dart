import 'package:flutter/material.dart';

import 'color_tokens.dart';

/// Core Typography class that defines text styles for the application
class CoreTypography {
  static const String _fontFamily = 'IBMPlexSansHebrew';

  // Font Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;

  // Headline Large (32/40)
  static TextStyle headlineLargeRegular({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        height: 40 / 32,
        // line height
        fontWeight: regular,
        color: color ?? CoreTextColors.headline,
      );

  static TextStyle headlineLargeSemiBold({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 32,
        height: 40 / 32,
        // line height
        fontWeight: semiBold,
        color: color ?? CoreTextColors.headline,
      );

  // Headline Medium (24/32)
  static TextStyle headlineMediumRegular({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        height: 32 / 24,
        // line height
        fontWeight: regular,
        color: color ?? CoreTextColors.headline,
      );

  static TextStyle headlineMediumSemiBold({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 24,
        height: 32 / 24,
        // line height
        fontWeight: semiBold,
        color: color ?? CoreTextColors.headline,
      );

  // Title Large (20/28)
  static TextStyle titleLargeRegular({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        height: 28 / 20,
        // line height
        fontWeight: regular,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleLargeMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        height: 28 / 20,
        // line height
        fontWeight: medium,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleLargeSemiBold({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 20,
        height: 28 / 20,
        // line height
        fontWeight: semiBold,
        color: color ?? CoreTextColors.dark,
      );

  // Title Medium (18/26)
  static TextStyle titleMediumRegular({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        height: 26 / 18,
        // line height
        fontWeight: regular,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleMediumMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        height: 26 / 18,
        // line height
        fontWeight: medium,
        color: color ?? CoreTextColors.dark,
      );

  static TextStyle titleMediumSemiBold({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 18,
        height: 26 / 18,
        // line height
        fontWeight: semiBold,
        color: color ?? CoreTextColors.dark,
      );

  // Body Large (16/24)
  static TextStyle bodyLargeRegular({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        height: 24 / 16,
        // line height
        fontWeight: regular,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyLargeMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        height: 24 / 16,
        // line height
        fontWeight: medium,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyLargeSemiBold({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 16,
        height: 24 / 16,
        // line height
        fontWeight: semiBold,
        color: color ?? CoreTextColors.body,
      );

  // Body Medium (14/20)
  static TextStyle bodyMediumRegular({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        height: 20 / 14,
        // line height
        fontWeight: regular,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyMediumMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        height: 20 / 14,
        // line height
        fontWeight: medium,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodyMediumSemiBold({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 14,
        height: 20 / 14,
        // line height
        fontWeight: semiBold,
        color: color ?? CoreTextColors.body,
      );

  // Body Small (12/16)
  static TextStyle bodySmallRegular({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        height: 16 / 12,
        // line height
        fontWeight: regular,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodySmallMedium({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        height: 16 / 12,
        // line height
        fontWeight: medium,
        color: color ?? CoreTextColors.body,
      );

  static TextStyle bodySmallSemiBold({Color? color}) => TextStyle(
        fontFamily: _fontFamily,
        fontSize: 12,
        height: 16 / 12,
        // line height
        fontWeight: semiBold,
        color: color ?? CoreTextColors.body,
      );
}
