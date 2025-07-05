import 'package:core_ui/src/theme/typography_extension.dart';
import 'package:flutter/material.dart';

import 'color_tokens.dart';
import 'theme_extensions.dart';

class CoreTheme {
  static AppColorsExtension _getAppColors() {
    return const AppColorsExtension(
      // Text Colors
      textHeadline: CoreTextColors.headline,
      textDark: CoreTextColors.dark,
      textBody: CoreTextColors.body,
      textDisable: CoreTextColors.disable,
      textInverse: CoreTextColors.inverse,
      textLink: CoreTextColors.link,
      textInfo: CoreTextColors.info,
      textWarning: CoreTextColors.warning,
      textError: CoreTextColors.error,
      textSuccess: CoreTextColors.success,

      // Background Colors
      pageBackground: CoreBackgroundColors.pageBackground,
      backgroundGrayLight: CoreBackgroundColors.backgroundGrayLight,
      backgroundGrayMid: CoreBackgroundColors.backgroundGrayMid,
      backgroundBlueLight: CoreBackgroundColors.backgroundBlueLight,
      backgroundBlueMid: CoreBackgroundColors.backgroundBlueMid,
      backgroundGreenLight: CoreBackgroundColors.backgroundGreenLight,
      backgroundGreenMid: CoreBackgroundColors.backgroundGreenMid,
      backgroundRedLight: CoreBackgroundColors.backgroundRedLight,
      backgroundRedMid: CoreBackgroundColors.backgroundRedMid,
      backgroundOrangeLight: CoreBackgroundColors.backgroundOrangeLight,
      backgroundOrangeMid: CoreBackgroundColors.backgroundOrangeMid,
      backgroundDarkGray: CoreBackgroundColors.backgroundDarkGray,
      backgroundDarkOrient: CoreBackgroundColors.backgroundDarkOrient,
      orientLight: CoreBackgroundColors.backgroundOrientLight,
      orientMid: CoreBackgroundColors.backgroundOrientMid,

      // Border Colors
      lineLight: CoreBorderColors.lineLight,
      lineMid: CoreBorderColors.lineMid,
      lineDarkOutline: CoreBorderColors.lineDarkOutline,
      lineHighlight: CoreBorderColors.lineHighlight,
      outlineHover: CoreBorderColors.outlineHover,
      outlineFocus: CoreBorderColors.outlineFocus,

      // Status Colors
      statusError: CoreStatusColors.error,
      statusSuccess: CoreStatusColors.success,

      // Button Colors
      buttonSurface: CoreButtonColors.surface,
      buttonHover: CoreButtonColors.hover,
      buttonDisable: CoreButtonColors.disable,
      buttonPress: CoreButtonColors.press,

      // Icon Colors
      iconDark: CoreIconColors.dark,
      iconGrayDark: CoreIconColors.grayDark,
      iconGrayMid: CoreIconColors.grayMid,
      iconGrayLight: CoreIconColors.grayLight,
      iconWhite: CoreIconColors.white,
      iconRed: CoreIconColors.red,
      iconGreen: CoreIconColors.green,
      iconOrange: CoreIconColors.orange,
      iconBlue: CoreIconColors.blue,
      iconOrient: CoreIconColors.orient,

      // Chip Colors
      chipGrey: CoreChipColors.gray,
      chipPrimary: CoreChipColors.primary,
      chipRed: CoreChipColors.red,
      chipOrange: CoreChipColors.orange,
      chipBlue: CoreChipColors.blue,
      chipGreen: CoreChipColors.green,

      // Alert Colors
      alertRed: CoreAlertColors.red,
      alertOrange: CoreAlertColors.orange,
      alertBlue: CoreAlertColors.blue,
      alertGreen: CoreAlertColors.green,

      // Keyboard Colors
      keyboardNumbers: CoreKeyboardColors.numbers,
      keyboardCalculate: CoreKeyboardColors.calculate,
      keyboardUnits: CoreKeyboardColors.units,
      keyboardFunctions: CoreKeyboardColors.functions,
      keyboardActions: CoreKeyboardColors.actions,
      keyboardMain: CoreKeyboardColors.main,
      tabsHighlight: CoreBorderColors.tabsHighlight,
    );
  }

  static ThemeData light() => _buildTheme(isDark: false);

  static ThemeData dark() => _buildTheme(isDark: true); // Future implementation

  static ThemeData _buildTheme({required bool isDark}) {
    return ThemeData(
      package: 'core_ui', //It's necessary for the assets.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [
        _getAppColors(),
        TypographyExtension.create(),
      ],
    );
  }
}
