// test/helpers/core_test_theme.dart

import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import 'test_typography.dart';

ThemeData coreTestTheme() {
  final baseTheme = CoreTheme.light();
  final baseTypography = baseTheme.extension<TypographyExtension>()!;

  return baseTheme.copyWith(
    extensions: [
      overrideTypographyFont(
        baseTypography,
        fontFamily: 'Roboto',
      ),
      ...baseTheme.extensions.values.where((e) => e is! TypographyExtension),
    ],
  );
}
