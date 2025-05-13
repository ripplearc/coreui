import 'package:flutter/material.dart';
import 'color_tokens.dart';

class CoreTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.light(
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
        background: CoreColorTokens.pageBg,
        onBackground: CoreColorTokens.textBody,
        surface: CoreColorTokens.pageBg,
        onSurface: CoreColorTokens.textBody,
        
        // Surface Variant
        surfaceVariant: CoreColorTokens.greyLight,
        onSurfaceVariant: CoreColorTokens.textBody,
        outline: CoreColorTokens.lineMid,
        outlineVariant: CoreColorTokens.lineLight,
        
        // Other
        shadow: CoreColorTokens.gray900.withOpacity(0.2),
        scrim: CoreColorTokens.gray900.withOpacity(0.5),
        inverseSurface: CoreColorTokens.darkGrey,
        onInverseSurface: CoreColorTokens.textInverse,
        inversePrimary: CoreColorTokens.orient200,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: CoreColorTokens.textHeadline),
        headlineMedium: TextStyle(color: CoreColorTokens.textHeadline),
        headlineSmall: TextStyle(color: CoreColorTokens.textHeadline),
        bodyLarge: TextStyle(color: CoreColorTokens.textBody),
        bodyMedium: TextStyle(color: CoreColorTokens.textBody),
        bodySmall: TextStyle(color: CoreColorTokens.textBody),
        labelLarge: TextStyle(color: CoreColorTokens.textDark),
        labelMedium: TextStyle(color: CoreColorTokens.textDark),
        labelSmall: TextStyle(color: CoreColorTokens.textDark),
      ),

      // Component Themes
      appBarTheme: AppBarTheme(
        backgroundColor: CoreColorTokens.pageBg,
        foregroundColor: CoreColorTokens.textDark,
        elevation: 0,
      ),

      tabBarTheme: TabBarTheme(
        labelColor: CoreColorTokens.textDark,
        unselectedLabelColor: CoreColorTokens.textBody,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: CoreColorTokens.tabsHighlight, width: 2),
        ),
      ),

      buttonTheme: ButtonThemeData(
        buttonColor: CoreColorTokens.btnSurface,
        disabledColor: CoreColorTokens.btnDisable,
      ),

      iconTheme: IconThemeData(
        color: CoreColorTokens.iconDark,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: CoreColorTokens.chipGrey,
        disabledColor: CoreColorTokens.chipGrey.withOpacity(0.5),
        selectedColor: CoreColorTokens.chipPrimary,
        secondarySelectedColor: CoreColorTokens.chipPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      dividerTheme: DividerThemeData(
        color: CoreColorTokens.lineLight,
        thickness: 1,
      ),
    );
  }


  //Update when dark mode will be implemented.
  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.dark(
        // Primary
        primary: CoreColorTokens.orient400,
        onPrimary: CoreColorTokens.gray25,
        primaryContainer: CoreColorTokens.orient800,
        onPrimaryContainer: CoreColorTokens.orient100,
        
        // Secondary
        secondary: CoreColorTokens.blue400,
        onSecondary: CoreColorTokens.gray25,
        secondaryContainer: CoreColorTokens.blue800,
        onSecondaryContainer: CoreColorTokens.blue100,
        
        // Error
        error: CoreColorTokens.red400,
        onError: CoreColorTokens.gray25,
        errorContainer: CoreColorTokens.red800,
        onErrorContainer: CoreColorTokens.red100,
        
        // Background
        background: CoreColorTokens.darkGrey,
        onBackground: CoreColorTokens.textInverse,
        surface: CoreColorTokens.darkGrey,
        onSurface: CoreColorTokens.textInverse,
        
        // Surface Variant
        surfaceVariant: CoreColorTokens.gray800,
        onSurfaceVariant: CoreColorTokens.textInverse,
        outline: CoreColorTokens.lineDark,
        outlineVariant: CoreColorTokens.lineMid,
        
        // Other
        shadow: CoreColorTokens.gray900.withOpacity(0.4),
        scrim: CoreColorTokens.gray900.withOpacity(0.7),
        inverseSurface: CoreColorTokens.pageBg,
        onInverseSurface: CoreColorTokens.textDark,
        inversePrimary: CoreColorTokens.orient600,
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(color: CoreColorTokens.textInverse),
        headlineMedium: TextStyle(color: CoreColorTokens.textInverse),
        headlineSmall: TextStyle(color: CoreColorTokens.textInverse),
        bodyLarge: TextStyle(color: CoreColorTokens.textInverse),
        bodyMedium: TextStyle(color: CoreColorTokens.textInverse),
        bodySmall: TextStyle(color: CoreColorTokens.textInverse),
        labelLarge: TextStyle(color: CoreColorTokens.textInverse),
        labelMedium: TextStyle(color: CoreColorTokens.textInverse),
        labelSmall: TextStyle(color: CoreColorTokens.textInverse),
      ),

      // Component Themes
      appBarTheme: AppBarTheme(
        backgroundColor: CoreColorTokens.darkGrey,
        foregroundColor: CoreColorTokens.textInverse,
        elevation: 0,
      ),

      tabBarTheme: TabBarTheme(
        labelColor: CoreColorTokens.textInverse,
        unselectedLabelColor: CoreColorTokens.textDisable,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: CoreColorTokens.tabsHighlight, width: 2),
        ),
      ),

      buttonTheme: ButtonThemeData(
        buttonColor: CoreColorTokens.btnSurface,
        disabledColor: CoreColorTokens.btnDisable,
      ),

      iconTheme: IconThemeData(
        color: CoreColorTokens.iconWhite,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: CoreColorTokens.gray800,
        disabledColor: CoreColorTokens.gray800.withOpacity(0.5),
        selectedColor: CoreColorTokens.chipPrimary,
        secondarySelectedColor: CoreColorTokens.chipPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),

      dividerTheme: DividerThemeData(
        color: CoreColorTokens.lineDark,
        thickness: 1,
      ),
    );
  }
}
