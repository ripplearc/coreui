import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/src/theme/app_typography_extension.dart';

import 'color_tokens.dart';
import 'theme_extensions.dart';

class CoreTheme {
  static AppColorsExtension _getLightAppColors() {
    return AppColorsExtension(
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
      tabsHighlight: CoreBorderColors.tabsHighlight,

      // Status Colors
      statusError: CoreStatusColors.error,
      statusSuccess: CoreStatusColors.success,

      // Button Colors
      buttonInverse: CoreButtonColors.inverse,
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
      transparent: CorePrimitiveColors.transparent,

      // Shadow Colors
      shadowGrey3: CoreShadowColors.shadowGrey3,
      shadowGrey5: CoreShadowColors.shadowGrey5,
      shadowGrey6: CoreShadowColors.shadowGrey6,
      shadowGrey7: CoreShadowColors.shadowGrey7,
      shadowGrey8: CoreShadowColors.shadowGrey8,
      shadowGrey10: CoreShadowColors.shadowGrey10,
      shadowGrey18: CoreShadowColors.shadowGrey18,

      // Accents
      indigo: CoreAccentsColors.indigo,
    );
  }

  static AppColorsExtension _getDarkAppColors() {
    return AppColorsExtension(
      // Text Colors
      textHeadline: CoreDarkTextColors.headline,
      textDark: CoreDarkTextColors.dark,
      textBody: CoreDarkTextColors.body,
      textDisable: CoreDarkTextColors.disable,
      textInverse: CoreDarkTextColors.inverse,
      textLink: CoreDarkTextColors.link,
      textInfo: CoreDarkTextColors.info,
      textWarning: CoreDarkTextColors.warning,
      textError: CoreDarkTextColors.error,
      textSuccess: CoreDarkTextColors.success,

      // Background Colors
      pageBackground: CoreDarkBackgroundColors.pageBackground,
      backgroundGrayLight: CoreDarkBackgroundColors.backgroundGrayLight,
      backgroundGrayMid: CoreDarkBackgroundColors.backgroundGrayMid,
      backgroundBlueLight: CoreDarkBackgroundColors.backgroundBlueLight,
      backgroundBlueMid: CoreDarkBackgroundColors.backgroundBlueMid,
      backgroundGreenLight: CoreDarkBackgroundColors.backgroundGreenLight,
      backgroundGreenMid: CoreDarkBackgroundColors.backgroundGreenMid,
      backgroundRedLight: CoreDarkBackgroundColors.backgroundRedLight,
      backgroundRedMid: CoreDarkBackgroundColors.backgroundRedMid,
      backgroundOrangeLight: CoreDarkBackgroundColors.backgroundOrangeLight,
      backgroundOrangeMid: CoreDarkBackgroundColors.backgroundOrangeMid,
      backgroundDarkGray: CoreDarkBackgroundColors.backgroundDarkGray,
      backgroundDarkOrient: CoreDarkBackgroundColors.backgroundDarkOrient,
      orientLight: CoreDarkBackgroundColors.backgroundOrientLight,
      orientMid: CoreDarkBackgroundColors.backgroundOrientMid,

      // Border Colors
      lineLight: CoreDarkBorderColors.lineLight,
      lineMid: CoreDarkBorderColors.lineMid,
      lineDarkOutline: CoreDarkBorderColors.lineDarkOutline,
      lineHighlight: CoreDarkBorderColors.lineHighlight,
      outlineHover: CoreDarkBorderColors.outlineHover,
      outlineFocus: CoreDarkBorderColors.outlineFocus,
      tabsHighlight: CoreDarkBorderColors.tabsHighlight,

      // Status Colors
      statusError: CoreDarkStatusColors.error,
      statusSuccess: CoreDarkStatusColors.success,

      // Button Colors
      buttonInverse: CoreDarkButtonColors.inverse,
      buttonSurface: CoreDarkButtonColors.surface,
      buttonHover: CoreDarkButtonColors.hover,
      buttonDisable: CoreDarkButtonColors.disable,
      buttonPress: CoreDarkButtonColors.press,

      // Icon Colors
      iconDark: CoreDarkIconColors.dark,
      iconGrayDark: CoreDarkIconColors.grayDark,
      iconGrayMid: CoreDarkIconColors.grayMid,
      iconGrayLight: CoreDarkIconColors.grayLight,
      iconWhite: CoreDarkIconColors.white,
      iconRed: CoreDarkIconColors.red,
      iconGreen: CoreDarkIconColors.green,
      iconOrange: CoreDarkIconColors.orange,
      iconBlue: CoreDarkIconColors.blue,
      iconOrient: CoreDarkIconColors.orient,

      // Chip Colors
      chipGrey: CoreDarkChipColors.gray,
      chipPrimary: CoreDarkChipColors.primary,
      chipRed: CoreDarkChipColors.red,
      chipOrange: CoreDarkChipColors.orange,
      chipBlue: CoreDarkChipColors.blue,
      chipGreen: CoreDarkChipColors.green,

      // Alert Colors
      alertRed: CoreDarkAlertColors.red,
      alertOrange: CoreDarkAlertColors.orange,
      alertBlue: CoreDarkAlertColors.blue,
      alertGreen: CoreDarkAlertColors.green,

      // Keyboard Colors
      keyboardNumbers: CoreDarkKeyboardColors.numbers,
      keyboardCalculate: CoreDarkKeyboardColors.calculate,
      keyboardUnits: CoreDarkKeyboardColors.units,
      keyboardFunctions: CoreDarkKeyboardColors.functions,
      keyboardActions: CoreDarkKeyboardColors.actions,
      keyboardMain: CoreDarkKeyboardColors.main,
      transparent: CoreDarkKeyboardColors.transparent,

      // Shadow Colors (unchanged — alpha overlays render correctly on any bg)
      shadowGrey3: CoreShadowColors.shadowGrey3,
      shadowGrey5: CoreShadowColors.shadowGrey5,
      shadowGrey6: CoreShadowColors.shadowGrey6,
      shadowGrey7: CoreShadowColors.shadowGrey7,
      shadowGrey8: CoreShadowColors.shadowGrey8,
      shadowGrey10: CoreShadowColors.shadowGrey10,
      shadowGrey18: CoreShadowColors.shadowGrey18,

      // Accents
      indigo: CoreAccentsColors.indigo,
    );
  }

  static ThemeData light() => _buildTheme(isDark: false);

  static ThemeData dark() => _buildTheme(isDark: true);

  static ThemeData _buildTheme({required bool isDark}) {
    return ThemeData(
      package: 'ripplearc_coreui',
      brightness: isDark ? Brightness.dark : Brightness.light,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      primaryColor: CoreBrandColors.orient,
      scaffoldBackgroundColor: isDark
          ? CoreDarkBackgroundColors.pageBackground
          : CoreBackgroundColors.pageBackground,
      extensions: [
        isDark ? _getDarkAppColors() : _getLightAppColors(),
        isDark ? AppTypographyExtension.createDark() : AppTypographyExtension.create(),
      ],
    );
  }
}
