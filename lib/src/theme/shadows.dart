import 'package:flutter/material.dart';

import 'color_tokens.dart';

/// Core Shadows class that defines shadow styles for the application
/// https://www.figma.com/design/vugaGpii5HfgEQHPbrS3mU/Construculator-Visual-Design?node-id=4-84&t=zZdz9haSNp4XklEm-4
class CoreShadows {
  // Extra Small Shadow (xs)
  static List<BoxShadow> extraSmall = [
    BoxShadow(
      color: CoreShadowColors.shadowGrey5,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
  ];

  // Small Shadow (sm)
  static List<BoxShadow> small = [
    BoxShadow(
      color: CoreShadowColors.shadowGrey5,
      blurRadius: 2,
      offset: const Offset(0, 1),
    ),
    BoxShadow(
      color: CoreShadowColors.shadowGrey6,
      blurRadius: 3,
      offset: const Offset(0, 1),
    ),
  ];

  // Medium Shadow (md)
  static List<BoxShadow> medium = [
    BoxShadow(
      color: CoreShadowColors.shadowGrey6,
      blurRadius: 4,
      spreadRadius: -2,
      offset: const Offset(0, 2),
    ),
    BoxShadow(
      color: CoreShadowColors.shadowGrey10,
      blurRadius: 8,
      spreadRadius: -2,
      offset: const Offset(0, 4),
    ),
  ];

  // Large Shadow (lg)
  static List<BoxShadow> large = [
    BoxShadow(
      color: CoreShadowColors.shadowGrey3,
      blurRadius: 6,
      spreadRadius: -2,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: CoreShadowColors.shadowGrey8,
      blurRadius: 16,
      spreadRadius: -4,
      offset: const Offset(0, 12),
    ),
  ];

  // Extra Large Shadow (xl)
  static List<BoxShadow> extraLarge = [
    BoxShadow(
      color: CoreShadowColors.shadowGrey3,
      blurRadius: 8,
      spreadRadius: -4,
      offset: const Offset(0, 8),
    ),
    BoxShadow(
      color: CoreShadowColors.shadowGrey8,
      blurRadius: 24,
      spreadRadius: -4,
      offset: const Offset(0, 20),
    ),
  ];

  // Double Extra Large Shadow (2xl)
  static List<BoxShadow> doubleExtraLarge = [
    BoxShadow(
      color: CoreShadowColors.shadowGrey18,
      blurRadius: 48,
      spreadRadius: -12,
      offset: const Offset(0, 24),
    ),
  ];

  static List<BoxShadow> sticky = [
    BoxShadow(
      color: CoreShadowColors.shadowGrey6,
      blurRadius: 4,
      offset: const Offset(0, -2),
    ),
    BoxShadow(
      color: CoreShadowColors.shadowGrey7,
      blurRadius: 8,
      offset: const Offset(0, -4),
    ),
  ];
}
