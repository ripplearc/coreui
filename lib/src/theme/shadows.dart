import 'package:flutter/material.dart';
import 'color_tokens.dart';

/// Core Shadows class that defines shadow styles for the application
class CoreShadows {
  // Shadow colors
  static final Color _shadowColor10 =
      CoreColorTokens.gray900.withValues(alpha: 0.1);
  static final Color _shadowColor8 =
      CoreColorTokens.gray900.withValues(alpha: 0.08);
  static final Color _shadowColor5 =
      CoreColorTokens.gray900.withValues(alpha: 0.05);
  static final Color _shadowColor6 =
      CoreColorTokens.gray900.withValues(alpha: 0.06);
  static final Color _shadowColor3 =
      CoreColorTokens.gray900.withValues(alpha: 0.03);
  static final Color _shadowColor18 =
      CoreColorTokens.gray900.withValues(alpha: 0.18);
  static final Color _shadowColor7 =
      CoreColorTokens.gray900.withValues(alpha: 0.07);

  // Extra Small Shadow (xs)
  static List<BoxShadow> xs = [
    BoxShadow(
      color: _shadowColor5,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  // Small Shadow (sm)
  static List<BoxShadow> sm = [
    BoxShadow(
      color: _shadowColor5,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: _shadowColor6,
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  // Medium Shadow (md)
  static List<BoxShadow> md = [
    BoxShadow(
      color: _shadowColor6,
      blurRadius: 4,
      spreadRadius: -2,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: _shadowColor10,
      blurRadius: 8,
      spreadRadius: -2,
      offset: const Offset(0, 4),
    ),
  ];

  // Large Shadow (lg)
  static List<BoxShadow> lg = [
    BoxShadow(
      color: _shadowColor3,
      blurRadius: 6,
      spreadRadius: -2,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: _shadowColor8,
      blurRadius: 16,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
  ];

  // Extra Large Shadow (xl)
  static List<BoxShadow> xl = [
    BoxShadow(
      color: _shadowColor3,
      blurRadius: 8,
      spreadRadius: -4,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: _shadowColor8,
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 20),
    ),
  ];

  // Double Extra Large Shadow (2xl)
  static List<BoxShadow> xxl = [
    BoxShadow(
      color: _shadowColor18,
      blurRadius: 48,
      spreadRadius: -12,
      offset: const Offset(0, 24),
    ),
  ];

  static List<BoxShadow> sticky = [
    BoxShadow(
      color: _shadowColor6,
      blurRadius: 4,
      offset: const Offset(0, -2),
    ),
    BoxShadow(
      color: _shadowColor7,
      blurRadius: 8,
      offset: const Offset(0, -4),
    ),
  ];
}
