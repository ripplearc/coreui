import 'package:flutter/material.dart';

// Base color palette
abstract class _CoreColorPalette {
  // Brand Colour
  static const Color brandOrient = Color(0xFF015B7C);

  // Gray
  static const Color gray25 = Color(0xFFFFFFFF);
  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray100 = Color(0xFFF2F4F7);
  static const Color gray200 = Color(0xFFEAECF0);
  static const Color gray300 = Color(0xFFD0D5DD);
  static const Color gray400 = Color(0xFF98A2B3);
  static const Color gray500 = Color(0xFF667085);
  static const Color gray600 = Color(0xFF475467);
  static const Color gray700 = Color(0xFF344054);
  static const Color gray800 = Color(0xFF1D2939);
  static const Color gray900 = Color(0xFF101828);

  // Orient
  static const Color orient25 = Color(0xFFE7FFFF);
  static const Color orient50 = Color(0xFFC2FFFF);
  static const Color orient100 = Color(0xFF8DFFFE);
  static const Color orient200 = Color(0xFF00FDFF);
  static const Color orient300 = Color(0xFF00DFFF);
  static const Color orient400 = Color(0xFF00AEE0);
  static const Color orient500 = Color(0xFF00AEE0);
  static const Color orient600 = Color(0xFF0089B4);
  static const Color orient700 = Color(0xFF006D8F);
  static const Color orient800 = Color(0xFF015B7C);
  static const Color orient900 = Color(0xFF003A54);

  // Blue
  static const Color blue25 = Color(0xFFEEFAFF);
  static const Color blue50 = Color(0xFFDCF5FF);
  static const Color blue100 = Color(0xFFB2EEFF);
  static const Color blue200 = Color(0xFF6DE3FF);
  static const Color blue300 = Color(0xFF20D5FF);
  static const Color blue400 = Color(0xFF00C0FF);
  static const Color blue500 = Color(0xFF009BDF);
  static const Color blue600 = Color(0xFF007BB4);
  static const Color blue700 = Color(0xFF006B95);
  static const Color blue800 = Color(0xFF00557A);
  static const Color blue900 = Color(0xFF00344E);

  // Red
  static const Color red25 = Color(0xFFFEF3F2);
  static const Color red50 = Color(0xFFFEF3F2);
  static const Color red100 = Color(0xFFFEE4E2);
  static const Color red200 = Color(0xFFFECDCA);
  static const Color red300 = Color(0xFFFDA29B);
  static const Color red400 = Color(0xFFF97066);
  static const Color red500 = Color(0xFFF04438);
  static const Color red600 = Color(0xFFD92D20);
  static const Color red700 = Color(0xFFBC3324);
  static const Color red800 = Color(0xFF80231C);
  static const Color red900 = Color(0xFF460D09);

  // Orange
  static const Color orange25 = Color(0xFFFFF6F2);
  static const Color orange50 = Color(0xFFFFF0E9);
  static const Color orange100 = Color(0xFFFAE0D4);
  static const Color orange200 = Color(0xFFF7B999);
  static const Color orange300 = Color(0xFFF39B65);
  static const Color orange400 = Color(0xFFEF7333);
  static const Color orange500 = Color(0xFFEB5000);
  static const Color orange600 = Color(0xFFCD5000);
  static const Color orange700 = Color(0xFFB03C00);
  static const Color orange800 = Color(0xFF822A0C);
  static const Color orange900 = Color(0xFF461204);

  // Green
  static const Color green25 = Color(0xFFEBFEF5);
  static const Color green50 = Color(0xFFCFFCE4);
  static const Color green100 = Color(0xFFA3F7CE);
  static const Color green200 = Color(0xFF68EDB5);
  static const Color green300 = Color(0xFF2CDB97);
  static const Color green400 = Color(0xFF07C280);
  static const Color green500 = Color(0xFF009E69);
  static const Color green600 = Color(0xFF007E57);
  static const Color green700 = Color(0xFF106446);
  static const Color green800 = Color(0xFF02523B);
  static const Color green900 = Color(0xFF002E22);
}

// Text-related color tokens
// https://www.figma.com/design/vugaGpii5HfgEQHPbrS3mU/Construculator-Visual-Design?node-id=1-601&t=TW26RstPBOLMrBqw-4

class CoreTextColors {
  static const Color headline = _CoreColorPalette.gray900;
  static const Color dark = _CoreColorPalette.gray800;
  static const Color body = _CoreColorPalette.gray600;
  static const Color disable = _CoreColorPalette.gray400;
  static const Color inverse = _CoreColorPalette.gray25;
  static const Color link = _CoreColorPalette.orient600;
  static const Color info = _CoreColorPalette.blue600;
  static const Color warning = _CoreColorPalette.orange600;
  static const Color error = _CoreColorPalette.red600;
  static const Color success = _CoreColorPalette.green600;
}

// Background-related color tokens
class CoreBackgroundColors {
  static const Color pageBackground = _CoreColorPalette.gray50;
  static const Color backgroundGrayLight = _CoreColorPalette.gray50;
  static const Color backgroundGrayMid = _CoreColorPalette.gray100;
  static const Color backgroundBlueLight = _CoreColorPalette.blue25;
  static const Color backgroundBlueMid = _CoreColorPalette.blue50;
  static const Color backgroundGreenLight = _CoreColorPalette.green25;
  static const Color backgroundGreenMid = _CoreColorPalette.green50;
  static const Color backgroundRedLight = _CoreColorPalette.red25;
  static const Color backgroundRedMid = _CoreColorPalette.red50;
  static const Color backgroundOrangeLight = _CoreColorPalette.orange25;
  static const Color backgroundOrangeMid = _CoreColorPalette.orange50;
  static const Color backgroundDarkGray = _CoreColorPalette.gray800;
  static const Color backgroundDarkOrient = _CoreColorPalette.orient900;
  static const Color backgroundOrientLight = _CoreColorPalette.orient25;
  static const Color backgroundOrientMid = _CoreColorPalette.orient50;
}

// Border-related color tokens
class CoreBorderColors {
  static const Color lineLight = _CoreColorPalette.gray200;
  static const Color lineMid = _CoreColorPalette.gray300;
  static const Color lineDarkOutline = _CoreColorPalette.gray400;
  static const Color lineHighlight = _CoreColorPalette.blue200;
  static const Color outlineHover = _CoreColorPalette.orient900;
  static const Color outlineFocus = _CoreColorPalette.orient800;
  static const Color tabsHighlight = _CoreColorPalette.orient500;
}

// Status-related color tokens
class CoreStatusColors {
  static const Color error = _CoreColorPalette.red500;
  static const Color success = _CoreColorPalette.green600;
}

// Keyboard-related color tokens
class CoreKeyboardColors {
  static const Color numbers = _CoreColorPalette.gray200;
  static const Color calculate = _CoreColorPalette.blue50;
  static const Color units = _CoreColorPalette.blue500;
  static const Color functions = _CoreColorPalette.blue600;
  static const Color actions = _CoreColorPalette.blue700;
  static const Color main = _CoreColorPalette.blue800;
}

// Icon-related color tokens
class CoreIconColors {
  static const Color dark = _CoreColorPalette.orient800;
  static const Color grayDark = _CoreColorPalette.gray900;
  static const Color grayMid = _CoreColorPalette.gray500;
  static const Color grayLight = _CoreColorPalette.gray300;
  static const Color white = _CoreColorPalette.gray25;
  static const Color red = _CoreColorPalette.red600;
  static const Color green = _CoreColorPalette.green600;
  static const Color orange = _CoreColorPalette.orange500;
  static const Color blue = _CoreColorPalette.blue600;
  static const Color orient = _CoreColorPalette.orient600;
}

// Chip-related color tokens
class CoreChipColors {
  static const Color gray = _CoreColorPalette.gray100;
  static const Color primary = _CoreColorPalette.orient50;
  static const Color red = _CoreColorPalette.red50;
  static const Color orange = _CoreColorPalette.orange50;
  static const Color blue = _CoreColorPalette.blue50;
  static const Color green = _CoreColorPalette.green50;
}

// Button-related color tokens
class CoreButtonColors {
  static const Color surface = _CoreColorPalette.orient800;
  static const Color hover = _CoreColorPalette.orient700;
  static const Color disable = _CoreColorPalette.gray300;
  static const Color press = _CoreColorPalette.orient600;
}

// Alert-related color tokens
class CoreAlertColors {
  static const Color red = _CoreColorPalette.red100;
  static const Color orange = _CoreColorPalette.orange100;
  static const Color blue = _CoreColorPalette.blue100;
  static const Color green = _CoreColorPalette.green100;
}

class CoreShadowColors {
  static final Color shadowGrey3 =
      _CoreColorPalette.gray900.withValues(alpha: 0.03);
  static final Color shadowGrey5 =
      _CoreColorPalette.gray900.withValues(alpha: 0.05);
  static final Color shadowGrey6 =
      _CoreColorPalette.gray900.withValues(alpha: 0.06);
  static final Color shadowGrey7 =
      _CoreColorPalette.gray900.withValues(alpha: 0.07);
  static final Color shadowGrey8 =
      _CoreColorPalette.gray900.withValues(alpha: 0.08);
  static final Color shadowGrey10 =
      _CoreColorPalette.gray900.withValues(alpha: 0.1);
  static final Color shadowGrey18 =
      _CoreColorPalette.gray900.withValues(alpha: 0.18);
  static const Color shadowGrey = _CoreColorPalette.gray900;
}
