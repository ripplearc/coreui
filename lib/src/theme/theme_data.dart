import 'package:flutter/material.dart';
import 'color_tokens.dart';
import 'typography.dart';

class CoreTheme {
  // Create a single ThemeData instance to be used for both light and dark themes
  static ThemeData _createThemeData() {
    return ThemeData(
      // Typography
      textTheme: TextTheme(
        // Headline styles
        headlineLarge: CoreTypography.headlineLargeRegular(),
        headlineMedium: CoreTypography.headlineMediumRegular(),
        headlineSmall: CoreTypography.titleLargeRegular(),

        // Title styles
        titleLarge: CoreTypography.titleLargeRegular(),
        titleMedium: CoreTypography.titleMediumRegular(),
        titleSmall: CoreTypography.bodyLargeRegular(),

        // Body styles
        bodyLarge: CoreTypography.bodyLargeRegular(),
        bodyMedium: CoreTypography.bodyMediumRegular(),
        bodySmall: CoreTypography.bodySmallRegular(),

        // Label styles
        labelLarge: CoreTypography.bodyLargeRegular(),
        labelMedium: CoreTypography.bodyMediumRegular(),
        labelSmall: CoreTypography.bodySmallRegular(),

        // Display styles
        displayLarge: CoreTypography.headlineLargeSemiBold(),
        displayMedium: CoreTypography.headlineMediumSemiBold(),
        displaySmall: CoreTypography.titleLargeSemiBold(),
      ),

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

  // Light theme
  static ThemeData light() {
    return _createThemeData();
  }

  // Dark theme (currently same as light theme)
  // Update when dark mode will be implemented
  static ThemeData dark() {
    return _createThemeData(); // Using same theme as light for now
  }
}
