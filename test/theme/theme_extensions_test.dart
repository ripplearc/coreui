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
    'lineBlue': colors.lineBlue,
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
    'keyboardGroupGeometry': colors.keyboardGroupGeometry,
    'keyboardGroupShapes': colors.keyboardGroupShapes,
    'keyboardGroupMaterials': colors.keyboardGroupMaterials,
    'keyboardGroupUnit': colors.keyboardGroupUnit,
    'keyboardGroupTrigonometry': colors.keyboardGroupTrigonometry,
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

    test('copyWith replaces each of the three tokens it is given', () {
      final changed = light.copyWith(
        lineOrange: const Color(0xFF000001),
        textGrayMid: const Color(0xFF000002),
        textWarningStrong: const Color(0xFF000003),
      ) as AppColorsExtension;

      expect(changed.lineOrange, const Color(0xFF000001));
      expect(changed.textGrayMid, const Color(0xFF000002));
      expect(changed.textWarningStrong, const Color(0xFF000003));
    });

    test('copyWith with no arguments keeps all three tokens', () {
      final same = light.copyWith() as AppColorsExtension;

      expect(same.lineOrange, light.lineOrange);
      expect(same.textGrayMid, light.textGrayMid);
      expect(same.textWarningStrong, light.textWarningStrong);
    });

    test('lerp blends all three tokens between the two themes', () {
      final halfway = light.lerp(dark, 0.5) as AppColorsExtension;

      expect(
        halfway.lineOrange,
        Color.lerp(light.lineOrange, dark.lineOrange, 0.5),
      );
      expect(
        halfway.textGrayMid,
        Color.lerp(light.textGrayMid, dark.textGrayMid, 0.5),
      );
      expect(
        halfway.textWarningStrong,
        Color.lerp(light.textWarningStrong, dark.textWarningStrong, 0.5),
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

  group('function-key group dot tokens', () {
    final light = AppColorsExtension.create();
    final dark = AppColorsExtension.createDark();

    List<Color> dots(AppColorsExtension colors) => [
          colors.keyboardGroupGeometry,
          colors.keyboardGroupShapes,
          colors.keyboardGroupMaterials,
          colors.keyboardGroupUnit,
          colors.keyboardGroupTrigonometry,
        ];

    test('light theme resolves the five dots', () {
      expect(light.keyboardGroupGeometry, const Color(0xFF015B7C));
      expect(light.keyboardGroupShapes, const Color(0xFF7A5AF8));
      expect(light.keyboardGroupMaterials, const Color(0xFFEB5000));
      expect(light.keyboardGroupUnit, const Color(0xFF2970FF));
      expect(light.keyboardGroupTrigonometry, const Color(0xFF009E69));
    });

    test('dark theme resolves the five dots', () {
      expect(dark.keyboardGroupGeometry, const Color(0xFF00AEE0));
      expect(dark.keyboardGroupShapes, const Color(0xFF7A5AF8));
      expect(dark.keyboardGroupMaterials, const Color(0xFFF79009));
      expect(dark.keyboardGroupUnit, const Color(0xFF2970FF));
      expect(dark.keyboardGroupTrigonometry, const Color(0xFF12B76A));
    });

    test('every dot reaches 3:1 on the page background in each theme', () {
      for (final colors in [light, dark]) {
        for (final dot in dots(colors)) {
          expect(
            contrastRatio(dot, colors.pageBackground),
            greaterThanOrEqualTo(3.0),
            reason: '$dot on ${colors.pageBackground}',
          );
        }
      }
    });

    test('no two dots look the same in either theme', () {
      for (final colors in [light, dark]) {
        expect(dots(colors).toSet().length, 5);
      }
    });

    test('copyWith replaces each dot it is given and keeps the rest', () {
      final changed = light.copyWith(
        keyboardGroupGeometry: const Color(0xFF000001),
        keyboardGroupShapes: const Color(0xFF000002),
        keyboardGroupMaterials: const Color(0xFF000003),
        keyboardGroupUnit: const Color(0xFF000004),
        keyboardGroupTrigonometry: const Color(0xFF000005),
      ) as AppColorsExtension;
      final same = light.copyWith() as AppColorsExtension;

      expect(dots(changed), [
        const Color(0xFF000001),
        const Color(0xFF000002),
        const Color(0xFF000003),
        const Color(0xFF000004),
        const Color(0xFF000005),
      ]);
      expect(dots(same), dots(light));
    });

    test('lerp blends every dot between the two themes', () {
      final halfway = light.lerp(dark, 0.5) as AppColorsExtension;

      for (var i = 0; i < 5; i++) {
        expect(
            dots(halfway)[i], Color.lerp(dots(light)[i], dots(dark)[i], 0.5));
      }
    });
  });
}
