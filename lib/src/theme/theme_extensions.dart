import 'package:flutter/material.dart';
import 'color_tokens.dart';

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

  // Utility Colors
  final Color transparent;

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
    required this.transparent,
  });

  /// Static method to get the current AppColorsExtension from context.
  static AppColorsExtension of(BuildContext context) {
    final AppColorsExtension? extension =
        Theme.of(context).extension<AppColorsExtension>();
    if (extension == null) {
      throw FlutterError(
        'AppColorsExtension not found in Theme. '
        'Did you wrap your widget tree with a Theme that includes this extension?',
      );
    }
    return extension;
  }

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
    Color? transparent,
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
        transparent: transparent ?? this.transparent);
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      ThemeExtension<AppColorsExtension>? other, double t) {
    if (other is! AppColorsExtension) {
      return this;
    }
    return AppColorsExtension(
      textHeadline:
          Color.lerp(textHeadline, other.textHeadline, t) ?? textHeadline,
      textDark: Color.lerp(textDark, other.textDark, t) ?? textDark,
      textBody: Color.lerp(textBody, other.textBody, t) ?? textBody,
      textDisable: Color.lerp(textDisable, other.textDisable, t) ?? textDisable,
      textInverse: Color.lerp(textInverse, other.textInverse, t) ?? textInverse,
      textLink: Color.lerp(textLink, other.textLink, t) ?? textLink,
      textInfo: Color.lerp(textInfo, other.textInfo, t) ?? textInfo,
      textWarning: Color.lerp(textWarning, other.textWarning, t) ?? textWarning,
      textError: Color.lerp(textError, other.textError, t) ?? textError,
      textSuccess: Color.lerp(textSuccess, other.textSuccess, t) ?? textSuccess,
      pageBackground:
          Color.lerp(pageBackground, other.pageBackground, t) ?? pageBackground,
      backgroundGrayLight:
          Color.lerp(backgroundGrayLight, other.backgroundGrayLight, t) ??
              backgroundGrayLight,
      backgroundGrayMid:
          Color.lerp(backgroundGrayMid, other.backgroundGrayMid, t) ??
              backgroundGrayMid,
      backgroundBlueLight:
          Color.lerp(backgroundBlueLight, other.backgroundBlueLight, t) ??
              backgroundBlueLight,
      backgroundBlueMid:
          Color.lerp(backgroundBlueMid, other.backgroundBlueMid, t) ??
              backgroundBlueMid,
      backgroundGreenLight:
          Color.lerp(backgroundGreenLight, other.backgroundGreenLight, t) ??
              backgroundGreenLight,
      backgroundGreenMid:
          Color.lerp(backgroundGreenMid, other.backgroundGreenMid, t) ??
              backgroundGreenMid,
      backgroundRedLight:
          Color.lerp(backgroundRedLight, other.backgroundRedLight, t) ??
              backgroundRedLight,
      backgroundRedMid:
          Color.lerp(backgroundRedMid, other.backgroundRedMid, t) ??
              backgroundRedMid,
      backgroundOrangeLight:
          Color.lerp(backgroundOrangeLight, other.backgroundOrangeLight, t) ??
              backgroundOrangeLight,
      backgroundOrangeMid:
          Color.lerp(backgroundOrangeMid, other.backgroundOrangeMid, t) ??
              backgroundOrangeMid,
      backgroundDarkGray:
          Color.lerp(backgroundDarkGray, other.backgroundDarkGray, t) ??
              backgroundDarkGray,
      backgroundDarkOrient:
          Color.lerp(backgroundDarkOrient, other.backgroundDarkOrient, t) ??
              backgroundDarkOrient,
      orientLight: Color.lerp(orientLight, other.orientLight, t) ?? orientLight,
      orientMid: Color.lerp(orientMid, other.orientMid, t) ?? orientMid,
      lineLight: Color.lerp(lineLight, other.lineLight, t) ?? lineLight,
      lineMid: Color.lerp(lineMid, other.lineMid, t) ?? lineMid,
      lineDarkOutline: Color.lerp(lineDarkOutline, other.lineDarkOutline, t) ??
          lineDarkOutline,
      lineHighlight:
          Color.lerp(lineHighlight, other.lineHighlight, t) ?? lineHighlight,
      outlineHover:
          Color.lerp(outlineHover, other.outlineHover, t) ?? outlineHover,
      outlineFocus:
          Color.lerp(outlineFocus, other.outlineFocus, t) ?? outlineFocus,
      tabsHighlight:
          Color.lerp(tabsHighlight, other.tabsHighlight, t) ?? tabsHighlight,
      statusError: Color.lerp(statusError, other.statusError, t) ?? statusError,
      statusSuccess:
          Color.lerp(statusSuccess, other.statusSuccess, t) ?? statusSuccess,
      buttonSurface:
          Color.lerp(buttonSurface, other.buttonSurface, t) ?? buttonSurface,
      buttonHover: Color.lerp(buttonHover, other.buttonHover, t) ?? buttonHover,
      buttonDisable:
          Color.lerp(buttonDisable, other.buttonDisable, t) ?? buttonDisable,
      buttonPress: Color.lerp(buttonPress, other.buttonPress, t) ?? buttonPress,
      iconDark: Color.lerp(iconDark, other.iconDark, t) ?? iconDark,
      iconGrayDark:
          Color.lerp(iconGrayDark, other.iconGrayDark, t) ?? iconGrayDark,
      iconGrayMid: Color.lerp(iconGrayMid, other.iconGrayMid, t) ?? iconGrayMid,
      iconGrayLight:
          Color.lerp(iconGrayLight, other.iconGrayLight, t) ?? iconGrayLight,
      iconWhite: Color.lerp(iconWhite, other.iconWhite, t) ?? iconWhite,
      iconRed: Color.lerp(iconRed, other.iconRed, t) ?? iconRed,
      iconGreen: Color.lerp(iconGreen, other.iconGreen, t) ?? iconGreen,
      iconOrange: Color.lerp(iconOrange, other.iconOrange, t) ?? iconOrange,
      iconBlue: Color.lerp(iconBlue, other.iconBlue, t) ?? iconBlue,
      iconOrient: Color.lerp(iconOrient, other.iconOrient, t) ?? iconOrient,
      chipGrey: Color.lerp(chipGrey, other.chipGrey, t) ?? chipGrey,
      chipPrimary: Color.lerp(chipPrimary, other.chipPrimary, t) ?? chipPrimary,
      chipRed: Color.lerp(chipRed, other.chipRed, t) ?? chipRed,
      chipOrange: Color.lerp(chipOrange, other.chipOrange, t) ?? chipOrange,
      chipBlue: Color.lerp(chipBlue, other.chipBlue, t) ?? chipBlue,
      chipGreen: Color.lerp(chipGreen, other.chipGreen, t) ?? chipGreen,
      alertRed: Color.lerp(alertRed, other.alertRed, t) ?? alertRed,
      alertOrange: Color.lerp(alertOrange, other.alertOrange, t) ?? alertOrange,
      alertBlue: Color.lerp(alertBlue, other.alertBlue, t) ?? alertBlue,
      alertGreen: Color.lerp(alertGreen, other.alertGreen, t) ?? alertGreen,
      keyboardNumbers: Color.lerp(keyboardNumbers, other.keyboardNumbers, t) ??
          keyboardNumbers,
      keyboardCalculate:
          Color.lerp(keyboardCalculate, other.keyboardCalculate, t) ??
              keyboardCalculate,
      keyboardUnits:
          Color.lerp(keyboardUnits, other.keyboardUnits, t) ?? keyboardUnits,
      keyboardFunctions:
          Color.lerp(keyboardFunctions, other.keyboardFunctions, t) ??
              keyboardFunctions,
      keyboardActions: Color.lerp(keyboardActions, other.keyboardActions, t) ??
          keyboardActions,
      keyboardMain:
          Color.lerp(keyboardMain, other.keyboardMain, t) ?? keyboardMain,
      transparent: Color.lerp(transparent, other.transparent, t) ?? transparent,
    );
  }

  static AppColorsExtension create() {
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
      tabsHighlight: CoreBorderColors.tabsHighlight,
      
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

      // Utility Colors
      transparent: CoreUtilityColors.transparent,
    );
  }
}

extension AppColorsTheme on ThemeData {
  AppColorsExtension get coreColors =>
      extension<AppColorsExtension>() ?? AppColorsExtension.create();
}
