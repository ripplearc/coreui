// test/helpers/core_test_typography.dart

import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

TypographyExtension overrideTypographyFont(
  TypographyExtension base, {
  required String fontFamily,
}) {
  TextStyle withFont(TextStyle style) => style.copyWith(fontFamily: fontFamily);

  return base.copyWith(
    headlineLargeRegular: withFont(base.headlineLargeRegular),
    headlineLargeSemiBold: withFont(base.headlineLargeSemiBold),
    headlineMediumRegular: withFont(base.headlineMediumRegular),
    headlineMediumSemiBold: withFont(base.headlineMediumSemiBold),
    titleLargeRegular: withFont(base.titleLargeRegular),
    titleLargeMedium: withFont(base.titleLargeMedium),
    titleLargeSemiBold: withFont(base.titleLargeSemiBold),
    titleMediumRegular: withFont(base.titleMediumRegular),
    titleMediumMedium: withFont(base.titleMediumMedium),
    titleMediumSemiBold: withFont(base.titleMediumSemiBold),
    bodyLargeRegular: withFont(base.bodyLargeRegular),
    bodyLargeMedium: withFont(base.bodyLargeMedium),
    bodyLargeSemiBold: withFont(base.bodyLargeSemiBold),
    bodyMediumRegular: withFont(base.bodyMediumRegular),
    bodyMediumMedium: withFont(base.bodyMediumMedium),
    bodyMediumSemiBold: withFont(base.bodyMediumSemiBold),
    bodySmallRegular: withFont(base.bodySmallRegular),
    bodySmallMedium: withFont(base.bodySmallMedium),
    bodySmallSemiBold: withFont(base.bodySmallSemiBold),
  );
}
