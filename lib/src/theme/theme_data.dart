import 'package:flutter/material.dart';
import 'color_tokens.dart';

class CoreTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: const ColorScheme.light(
        // Primary
        primary: CoreColorTokens.orient600,
        onPrimary: CoreColorTokens.gray25,
        primaryContainer: CoreColorTokens.orient100,
        onPrimaryContainer: CoreColorTokens.orient900,

        // Secondary
        secondary: CoreColorTokens.blue600,
        onSecondary: CoreColorTokens.gray25,
        secondaryContainer: CoreColorTokens.blue100,
        onSecondaryContainer: CoreColorTokens.blue900,

        // Error
        error: CoreColorTokens.red600,
        onError: CoreColorTokens.gray25,
        errorContainer: CoreColorTokens.red100,
        onErrorContainer: CoreColorTokens.red900,

        // Background
        surface: CoreColorTokens.pageBg,
        onSurface: CoreColorTokens.textBody,

        // Surface Variant
        onSurfaceVariant: CoreColorTokens.textBody,
        outline: CoreColorTokens.lineMid,
        outlineVariant: CoreColorTokens.lineLight,

        // Other
        inverseSurface: CoreColorTokens.darkGrey,
        onInverseSurface: CoreColorTokens.textInverse,
        inversePrimary: CoreColorTokens.orient200,
      ),
    );
  }

  //Update when dark mode will be implemented.
  static ThemeData dark() {
    return ThemeData(
      colorScheme: const ColorScheme.dark(
        // Primary
        primary: CoreColorTokens.orient600,
        onPrimary: CoreColorTokens.gray25,
        primaryContainer: CoreColorTokens.orient100,
        onPrimaryContainer: CoreColorTokens.orient900,

        // Secondary
        secondary: CoreColorTokens.blue600,
        onSecondary: CoreColorTokens.gray25,
        secondaryContainer: CoreColorTokens.blue100,
        onSecondaryContainer: CoreColorTokens.blue900,

        // Error
        error: CoreColorTokens.red600,
        onError: CoreColorTokens.gray25,
        errorContainer: CoreColorTokens.red100,
        onErrorContainer: CoreColorTokens.red900,

        // Background
        surface: CoreColorTokens.pageBg,
        onSurface: CoreColorTokens.textBody,

        // Surface Variant
        onSurfaceVariant: CoreColorTokens.textBody,
        outline: CoreColorTokens.lineMid,
        outlineVariant: CoreColorTokens.lineLight,

        // Other
        inverseSurface: CoreColorTokens.darkGrey,
        onInverseSurface: CoreColorTokens.textInverse,
        inversePrimary: CoreColorTokens.orient200,
      ),
    );
  }
}
