import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/src/theme/theme_data.dart';
import 'package:ripplearc_coreui/src/theme/theme_extensions.dart';

Map<String, Color> fieldMap(AppColorsExtension colors) {
  return <String, Color>{
    'textHeadline': colors.textHeadline,
    'textDark': colors.textDark,
    'textBody': colors.textBody,
    'textDisable': colors.textDisable,
    'textInverse': colors.textInverse,
    'textLink': colors.textLink,
    'textInfo': colors.textInfo,
    'textWarning': colors.textWarning,
    'textError': colors.textError,
    'textSuccess': colors.textSuccess,
    'pageBackground': colors.pageBackground,
    'backgroundGrayLight': colors.backgroundGrayLight,
    'backgroundGrayMid': colors.backgroundGrayMid,
    'backgroundBlueLight': colors.backgroundBlueLight,
    'backgroundBlueMid': colors.backgroundBlueMid,
    'backgroundGreenLight': colors.backgroundGreenLight,
    'backgroundGreenMid': colors.backgroundGreenMid,
    'backgroundRedLight': colors.backgroundRedLight,
    'backgroundRedMid': colors.backgroundRedMid,
    'backgroundOrangeLight': colors.backgroundOrangeLight,
    'backgroundOrangeMid': colors.backgroundOrangeMid,
    'backgroundDarkGray': colors.backgroundDarkGray,
    'backgroundDarkOrient': colors.backgroundDarkOrient,
    'orientLight': colors.orientLight,
    'orientMid': colors.orientMid,
    'lineLight': colors.lineLight,
    'lineMid': colors.lineMid,
    'lineDarkOutline': colors.lineDarkOutline,
    'lineHighlight': colors.lineHighlight,
    'outlineHover': colors.outlineHover,
    'outlineFocus': colors.outlineFocus,
    'tabsHighlight': colors.tabsHighlight,
    'statusError': colors.statusError,
    'statusSuccess': colors.statusSuccess,
    'buttonInverse': colors.buttonInverse,
    'buttonSurface': colors.buttonSurface,
    'buttonHover': colors.buttonHover,
    'buttonDisable': colors.buttonDisable,
    'buttonPress': colors.buttonPress,
    'iconDark': colors.iconDark,
    'iconGrayDark': colors.iconGrayDark,
    'iconGrayMid': colors.iconGrayMid,
    'iconGrayLight': colors.iconGrayLight,
    'iconWhite': colors.iconWhite,
    'iconRed': colors.iconRed,
    'iconGreen': colors.iconGreen,
    'iconOrange': colors.iconOrange,
    'iconBlue': colors.iconBlue,
    'iconOrient': colors.iconOrient,
    'chipGrey': colors.chipGrey,
    'chipPrimary': colors.chipPrimary,
    'chipRed': colors.chipRed,
    'chipOrange': colors.chipOrange,
    'chipBlue': colors.chipBlue,
    'chipGreen': colors.chipGreen,
    'alertRed': colors.alertRed,
    'alertOrange': colors.alertOrange,
    'alertBlue': colors.alertBlue,
    'alertGreen': colors.alertGreen,
    'keyboardNumbers': colors.keyboardNumbers,
    'keyboardCalculate': colors.keyboardCalculate,
    'keyboardUnits': colors.keyboardUnits,
    'keyboardFunctions': colors.keyboardFunctions,
    'keyboardActions': colors.keyboardActions,
    'keyboardMain': colors.keyboardMain,
    'transparent': colors.transparent,
    'shadowGrey3': colors.shadowGrey3,
    'shadowGrey5': colors.shadowGrey5,
    'shadowGrey6': colors.shadowGrey6,
    'shadowGrey7': colors.shadowGrey7,
    'shadowGrey8': colors.shadowGrey8,
    'shadowGrey10': colors.shadowGrey10,
    'shadowGrey18': colors.shadowGrey18,
    'indigo': colors.indigo,
  };
}

void main() {
  group('AppColorsExtension factories delegate to CoreTheme', () {
    test('create() is field-for-field equal to CoreTheme.lightAppColors()', () {
      expect(
        fieldMap(AppColorsExtension.create()),
        fieldMap(CoreTheme.lightAppColors()),
      );
    });

    test('createDark() is field-for-field equal to CoreTheme.darkAppColors()',
        () {
      expect(
        fieldMap(AppColorsExtension.createDark()),
        fieldMap(CoreTheme.darkAppColors()),
      );
    });

    test('createDark() returns the dark palette, not the light one', () {
      expect(
        fieldMap(AppColorsExtension.createDark()),
        isNot(fieldMap(AppColorsExtension.create())),
      );
    });
  });
}
