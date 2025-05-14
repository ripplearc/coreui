import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  // Text Colors
  final Color textHeadline;
  final Color textDark;
  final Color textBody;
  final Color textDisable;
  final Color textInverse;
  final Color textLink;
  final Color textInfo;
  final Color textWarning;
  final Color textError;
  final Color textSuccess;

  // Background Colors
  final Color pageBackground;
  final Color backgroundGrayLight;
  final Color backgroundGrayMid;
  final Color backgroundBlueLight;
  final Color backgroundBlueMid;
  final Color backgroundGreenLight;
  final Color backgroundGreenMid;
  final Color backgroundRedLight;
  final Color backgroundRedMid;
  final Color backgroundOrangeLight;
  final Color backgroundOrangeMid;
  final Color backgroundDarkGray;
  final Color backgroundDarkOrient;
  final Color orientLight;
  final Color orientMid;

  // Border Colors
  final Color lineLight;
  final Color lineMid;
  final Color lineDarkOutline;
  final Color lineHighlight;
  final Color outlineHover;
  final Color outlineFocus;
  final Color tabsHighlight;

  // Status Colors
  final Color statusError;
  final Color statusSuccess;

  // Button Colors
  final Color buttonSurface;
  final Color buttonHover;
  final Color buttonDisable;
  final Color buttonPress;

  // Icon Colors
  final Color iconDark;
  final Color iconGrayDark;
  final Color iconGrayMid;
  final Color iconGrayLight;
  final Color iconWhite;
  final Color iconRed;
  final Color iconGreen;
  final Color iconOrange;
  final Color iconBlue;
  final Color iconOrient;

  // Chip Colors
  final Color chipGrey;
  final Color chipPrimary;
  final Color chipRed;
  final Color chipOrange;
  final Color chipBlue;
  final Color chipGreen;

  // Alert Colors
  final Color alertRed;
  final Color alertOrange;
  final Color alertBlue;
  final Color alertGreen;

  // Keyboard Colors
  final Color keyboardNumbers;
  final Color keyboardCalculate;
  final Color keyboardUnits;
  final Color keyboardFunctions;
  final Color keyboardActions;
  final Color keyboardMain;

  const AppColorsExtension({
    required this.textHeadline,
    required this.textDark,
    required this.textBody,
    required this.textDisable,
    required this.textInverse,
    required this.textLink,
    required this.textInfo,
    required this.textWarning,
    required this.textError,
    required this.textSuccess,
    required this.pageBackground,
    required this.backgroundGrayLight,
    required this.backgroundGrayMid,
    required this.backgroundBlueLight,
    required this.backgroundBlueMid,
    required this.backgroundGreenLight,
    required this.backgroundGreenMid,
    required this.backgroundRedLight,
    required this.backgroundRedMid,
    required this.backgroundOrangeLight,
    required this.backgroundOrangeMid,
    required this.backgroundDarkGray,
    required this.backgroundDarkOrient,
    required this.orientLight,
    required this.orientMid,
    required this.lineLight,
    required this.lineMid,
    required this.lineDarkOutline,
    required this.lineHighlight,
    required this.outlineHover,
    required this.outlineFocus,
    required this.tabsHighlight,
    required this.statusError,
    required this.statusSuccess,
    required this.buttonSurface,
    required this.buttonHover,
    required this.buttonDisable,
    required this.buttonPress,
    required this.iconDark,
    required this.iconGrayDark,
    required this.iconGrayMid,
    required this.iconGrayLight,
    required this.iconWhite,
    required this.iconRed,
    required this.iconGreen,
    required this.iconOrange,
    required this.iconBlue,
    required this.iconOrient,
    required this.chipGrey,
    required this.chipPrimary,
    required this.chipRed,
    required this.chipOrange,
    required this.chipBlue,
    required this.chipGreen,
    required this.alertRed,
    required this.alertOrange,
    required this.alertBlue,
    required this.alertGreen,
    required this.keyboardNumbers,
    required this.keyboardCalculate,
    required this.keyboardUnits,
    required this.keyboardFunctions,
    required this.keyboardActions,
    required this.keyboardMain,
  });

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    Color? textHeadline,
    Color? textDark,
    Color? textBody,
    Color? textDisable,
    Color? textInverse,
    Color? textLink,
    Color? textInfo,
    Color? textWarning,
    Color? textError,
    Color? textSuccess,
    Color? pageBackground,
    Color? backgroundGrayLight,
    Color? backgroundGrayMid,
    Color? backgroundBlueLight,
    Color? backgroundBlueMid,
    Color? backgroundGreenLight,
    Color? backgroundGreenMid,
    Color? backgroundRedLight,
    Color? backgroundRedMid,
    Color? backgroundOrangeLight,
    Color? backgroundOrangeMid,
    Color? backgroundDarkGray,
    Color? backgroundDarkOrient,
    Color? orientLight,
    Color? orientMid,
    Color? lineLight,
    Color? lineMid,
    Color? lineDarkOutline,
    Color? lineHighlight,
    Color? outlineHover,
    Color? outlineFocus,
    Color? tabsHighlight,
    Color? statusError,
    Color? statusSuccess,
    Color? buttonSurface,
    Color? buttonHover,
    Color? buttonDisable,
    Color? buttonPress,
    Color? iconDark,
    Color? iconGrayDark,
    Color? iconGrayMid,
    Color? iconGrayLight,
    Color? iconWhite,
    Color? iconRed,
    Color? iconGreen,
    Color? iconOrange,
    Color? iconBlue,
    Color? iconOrient,
    Color? chipGrey,
    Color? chipPrimary,
    Color? chipRed,
    Color? chipOrange,
    Color? chipBlue,
    Color? chipGreen,
    Color? alertRed,
    Color? alertOrange,
    Color? alertBlue,
    Color? alertGreen,
    Color? keyboardNumbers,
    Color? keyboardCalculate,
    Color? keyboardUnits,
    Color? keyboardFunctions,
    Color? keyboardActions,
    Color? keyboardMain,
  }) {
    return AppColorsExtension(
      textHeadline: textHeadline ?? this.textHeadline,
      textDark: textDark ?? this.textDark,
      textBody: textBody ?? this.textBody,
      textDisable: textDisable ?? this.textDisable,
      textInverse: textInverse ?? this.textInverse,
      textLink: textLink ?? this.textLink,
      textInfo: textInfo ?? this.textInfo,
      textWarning: textWarning ?? this.textWarning,
      textError: textError ?? this.textError,
      textSuccess: textSuccess ?? this.textSuccess,
      pageBackground: pageBackground ?? this.pageBackground,
      backgroundGrayLight: backgroundGrayLight ?? this.backgroundGrayLight,
      backgroundGrayMid: backgroundGrayMid ?? this.backgroundGrayMid,
      backgroundBlueLight: backgroundBlueLight ?? this.backgroundBlueLight,
      backgroundBlueMid: backgroundBlueMid ?? this.backgroundBlueMid,
      backgroundGreenLight: backgroundGreenLight ?? this.backgroundGreenLight,
      backgroundGreenMid: backgroundGreenMid ?? this.backgroundGreenMid,
      backgroundRedLight: backgroundRedLight ?? this.backgroundRedLight,
      backgroundRedMid: backgroundRedMid ?? this.backgroundRedMid,
      backgroundOrangeLight:
          backgroundOrangeLight ?? this.backgroundOrangeLight,
      backgroundOrangeMid: backgroundOrangeMid ?? this.backgroundOrangeMid,
      backgroundDarkGray: backgroundDarkGray ?? this.backgroundDarkGray,
      backgroundDarkOrient: backgroundDarkOrient ?? this.backgroundDarkOrient,
      orientLight: orientLight ?? this.orientLight,
      orientMid: orientMid ?? this.orientMid,
      lineLight: lineLight ?? this.lineLight,
      lineMid: lineMid ?? this.lineMid,
      lineDarkOutline: lineDarkOutline ?? this.lineDarkOutline,
      lineHighlight: lineHighlight ?? this.lineHighlight,
      outlineHover: outlineHover ?? this.outlineHover,
      outlineFocus: outlineFocus ?? this.outlineFocus,
      tabsHighlight: tabsHighlight ?? this.tabsHighlight,
      statusError: statusError ?? this.statusError,
      statusSuccess: statusSuccess ?? this.statusSuccess,
      buttonSurface: buttonSurface ?? this.buttonSurface,
      buttonHover: buttonHover ?? this.buttonHover,
      buttonDisable: buttonDisable ?? this.buttonDisable,
      buttonPress: buttonPress ?? this.buttonPress,
      iconDark: iconDark ?? this.iconDark,
      iconGrayDark: iconGrayDark ?? this.iconGrayDark,
      iconGrayMid: iconGrayMid ?? this.iconGrayMid,
      iconGrayLight: iconGrayLight ?? this.iconGrayLight,
      iconWhite: iconWhite ?? this.iconWhite,
      iconRed: iconRed ?? this.iconRed,
      iconGreen: iconGreen ?? this.iconGreen,
      iconOrange: iconOrange ?? this.iconOrange,
      iconBlue: iconBlue ?? this.iconBlue,
      iconOrient: iconOrient ?? this.iconOrient,
      chipGrey: chipGrey ?? this.chipGrey,
      chipPrimary: chipPrimary ?? this.chipPrimary,
      chipRed: chipRed ?? this.chipRed,
      chipOrange: chipOrange ?? this.chipOrange,
      chipBlue: chipBlue ?? this.chipBlue,
      chipGreen: chipGreen ?? this.chipGreen,
      alertRed: alertRed ?? this.alertRed,
      alertOrange: alertOrange ?? this.alertOrange,
      alertBlue: alertBlue ?? this.alertBlue,
      alertGreen: alertGreen ?? this.alertGreen,
      keyboardNumbers: keyboardNumbers ?? this.keyboardNumbers,
      keyboardCalculate: keyboardCalculate ?? this.keyboardCalculate,
      keyboardUnits: keyboardUnits ?? this.keyboardUnits,
      keyboardFunctions: keyboardFunctions ?? this.keyboardFunctions,
      keyboardActions: keyboardActions ?? this.keyboardActions,
      keyboardMain: keyboardMain ?? this.keyboardMain,
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      textHeadline: Color.lerp(textHeadline, other.textHeadline, t)!,
      textDark: Color.lerp(textDark, other.textDark, t)!,
      textBody: Color.lerp(textBody, other.textBody, t)!,
      textDisable: Color.lerp(textDisable, other.textDisable, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textLink: Color.lerp(textLink, other.textLink, t)!,
      textInfo: Color.lerp(textInfo, other.textInfo, t)!,
      textWarning: Color.lerp(textWarning, other.textWarning, t)!,
      textError: Color.lerp(textError, other.textError, t)!,
      textSuccess: Color.lerp(textSuccess, other.textSuccess, t)!,
      pageBackground: Color.lerp(pageBackground, other.pageBackground, t)!,
      backgroundGrayLight:
          Color.lerp(backgroundGrayLight, other.backgroundGrayLight, t)!,
      backgroundGrayMid:
          Color.lerp(backgroundGrayMid, other.backgroundGrayMid, t)!,
      backgroundBlueLight:
          Color.lerp(backgroundBlueLight, other.backgroundBlueLight, t)!,
      backgroundBlueMid:
          Color.lerp(backgroundBlueMid, other.backgroundBlueMid, t)!,
      backgroundGreenLight:
          Color.lerp(backgroundGreenLight, other.backgroundGreenLight, t)!,
      backgroundGreenMid:
          Color.lerp(backgroundGreenMid, other.backgroundGreenMid, t)!,
      backgroundRedLight:
          Color.lerp(backgroundRedLight, other.backgroundRedLight, t)!,
      backgroundRedMid:
          Color.lerp(backgroundRedMid, other.backgroundRedMid, t)!,
      backgroundOrangeLight:
          Color.lerp(backgroundOrangeLight, other.backgroundOrangeLight, t)!,
      backgroundOrangeMid:
          Color.lerp(backgroundOrangeMid, other.backgroundOrangeMid, t)!,
      backgroundDarkGray:
          Color.lerp(backgroundDarkGray, other.backgroundDarkGray, t)!,
      backgroundDarkOrient:
          Color.lerp(backgroundDarkOrient, other.backgroundDarkOrient, t)!,
      orientLight: Color.lerp(orientLight, other.orientLight, t)!,
      orientMid: Color.lerp(orientMid, other.orientMid, t)!,
      lineLight: Color.lerp(lineLight, other.lineLight, t)!,
      lineMid: Color.lerp(lineMid, other.lineMid, t)!,
      lineDarkOutline: Color.lerp(lineDarkOutline, other.lineDarkOutline, t)!,
      lineHighlight: Color.lerp(lineHighlight, other.lineHighlight, t)!,
      outlineHover: Color.lerp(outlineHover, other.outlineHover, t)!,
      outlineFocus: Color.lerp(outlineFocus, other.outlineFocus, t)!,
      tabsHighlight: Color.lerp(tabsHighlight, other.tabsHighlight, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusSuccess: Color.lerp(statusSuccess, other.statusSuccess, t)!,
      buttonSurface: Color.lerp(buttonSurface, other.buttonSurface, t)!,
      buttonHover: Color.lerp(buttonHover, other.buttonHover, t)!,
      buttonDisable: Color.lerp(buttonDisable, other.buttonDisable, t)!,
      buttonPress: Color.lerp(buttonPress, other.buttonPress, t)!,
      iconDark: Color.lerp(iconDark, other.iconDark, t)!,
      iconGrayDark: Color.lerp(iconGrayDark, other.iconGrayDark, t)!,
      iconGrayMid: Color.lerp(iconGrayMid, other.iconGrayMid, t)!,
      iconGrayLight: Color.lerp(iconGrayLight, other.iconGrayLight, t)!,
      iconWhite: Color.lerp(iconWhite, other.iconWhite, t)!,
      iconRed: Color.lerp(iconRed, other.iconRed, t)!,
      iconGreen: Color.lerp(iconGreen, other.iconGreen, t)!,
      iconOrange: Color.lerp(iconOrange, other.iconOrange, t)!,
      iconBlue: Color.lerp(iconBlue, other.iconBlue, t)!,
      iconOrient: Color.lerp(iconOrient, other.iconOrient, t)!,
      chipGrey: Color.lerp(chipGrey, other.chipGrey, t)!,
      chipPrimary: Color.lerp(chipPrimary, other.chipPrimary, t)!,
      chipRed: Color.lerp(chipRed, other.chipRed, t)!,
      chipOrange: Color.lerp(chipOrange, other.chipOrange, t)!,
      chipBlue: Color.lerp(chipBlue, other.chipBlue, t)!,
      chipGreen: Color.lerp(chipGreen, other.chipGreen, t)!,
      alertRed: Color.lerp(alertRed, other.alertRed, t)!,
      alertOrange: Color.lerp(alertOrange, other.alertOrange, t)!,
      alertBlue: Color.lerp(alertBlue, other.alertBlue, t)!,
      alertGreen: Color.lerp(alertGreen, other.alertGreen, t)!,
      keyboardNumbers: Color.lerp(keyboardNumbers, other.keyboardNumbers, t)!,
      keyboardCalculate:
          Color.lerp(keyboardCalculate, other.keyboardCalculate, t)!,
      keyboardUnits: Color.lerp(keyboardUnits, other.keyboardUnits, t)!,
      keyboardFunctions:
          Color.lerp(keyboardFunctions, other.keyboardFunctions, t)!,
      keyboardActions: Color.lerp(keyboardActions, other.keyboardActions, t)!,
      keyboardMain: Color.lerp(keyboardMain, other.keyboardMain, t)!,
    );
  }
}
