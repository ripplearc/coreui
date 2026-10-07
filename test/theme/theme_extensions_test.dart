import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/src/theme/theme_data.dart';
import 'package:ripplearc_coreui/src/theme/theme_extensions.dart';

double contrastRatio(Color foreground, Color background) {
  double channel(double value) {
    return value <= 0.03928
        ? value / 12.92
        : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  double luminance(Color color) {
    return 0.2126 * channel(color.r) +
        0.7152 * channel(color.g) +
        0.0722 * channel(color.b);
  }

  final a = luminance(foreground);
  final b = luminance(background);
  return ((a > b ? a : b) + 0.05) / ((a > b ? b : a) + 0.05);
}

Map<String, Color> fieldMap(AppColorsExtension colors) {
  return <String, Color>{
    'textHeadline': colors.textHeadline,
    'textDark': colors.textDark,
    'textBody': colors.textBody,
    'textDisable': colors.textDisable,
    'textGrayMid': colors.textGrayMid,
    'textInverse': colors.textInverse,
    'textLink': colors.textLink,
    'textInfo': colors.textInfo,
    'textWarning': colors.textWarning,
    'textWarningStrong': colors.textWarningStrong,
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
    'lineOrange': colors.lineOrange,
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
    'alertRedOutline': colors.alertRedOutline,
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

  group('status badge colour tokens', () {
    final light = AppColorsExtension.create();
    final dark = AppColorsExtension.createDark();

    test(
        'light theme resolves lineOrange to orange200 and textGrayMid to gray500',
        () {
      expect(light.lineOrange, const Color(0xFFF7B999));
      expect(light.textGrayMid, const Color(0xFF667085));
    });

    test('light theme resolves textWarningStrong to orange700 (#B03C00)', () {
      expect(light.textWarningStrong, const Color(0xFFB03C00));
    });

    test(
        'dark theme resolves lineOrange to orange300 and textGrayMid to gray300',
        () {
      expect(dark.lineOrange, const Color(0xFFF39B65));
      expect(dark.textGrayMid, const Color(0xFFD0D5DD));
    });

    test('dark theme resolves textWarningStrong to orange200 (#F7B999)', () {
      expect(dark.textWarningStrong, const Color(0xFFF7B999));
    });

    test('copyWith replaces only the token it is given', () {
      final changed = light.copyWith(lineOrange: const Color(0xFF000001))
          as AppColorsExtension;

      expect(changed.lineOrange, const Color(0xFF000001));
      expect(changed.textGrayMid, light.textGrayMid);
      expect(changed.textWarningStrong, light.textWarningStrong);
    });

    test('lerp blends both tokens between the two themes', () {
      final halfway = light.lerp(dark, 0.5) as AppColorsExtension;

      expect(
        halfway.lineOrange,
        Color.lerp(light.lineOrange, dark.lineOrange, 0.5),
      );
      expect(
        halfway.textGrayMid,
        Color.lerp(light.textGrayMid, dark.textGrayMid, 0.5),
      );
    });

    test('textWarningStrong meets 4.5:1 on both orange fills in each theme',
        () {
      for (final colors in [light, dark]) {
        expect(
          contrastRatio(colors.textWarningStrong, colors.backgroundOrangeMid),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          contrastRatio(colors.textWarningStrong, colors.backgroundOrangeLight),
          greaterThanOrEqualTo(4.5),
        );
      }
    });

    test('textGrayMid meets 4.5:1 on the grey fill in each theme', () {
      for (final colors in [light, dark]) {
        expect(
          contrastRatio(colors.textGrayMid, colors.backgroundGrayMid),
          greaterThanOrEqualTo(4.5),
        );
      }
    });
  });
}
