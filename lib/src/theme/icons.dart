import 'package:flutter/material.dart';

/// Core icon system that provides standardized icons in different sizes
///
/// The icon system provides icons in 4 standard sizes:
/// - 16x16 (small)
/// - 20x20 (medium)
/// - 24x24 (large - default in Material)
/// - 32x32 (extra large)
class CoreIcons {
  // Icon sizes
  static const double sizeSmall = 16.0;
  static const double sizeMedium = 20.0;
  static const double sizeLarge = 24.0;
  static const double sizeExtraLarge = 32.0;

  // 16x16 icons
  static const IconData infoSmall = Icons.info_outline;
  static const IconData warningSmall = Icons.warning_amber_outlined;
  static const IconData errorSmall = Icons.error_outline;
  static const IconData calendarSmall = Icons.calendar_today_outlined;
  static const IconData gridSmall = Icons.grid_view_outlined;
  static const IconData closeSmall = Icons.close;
  static const IconData arrowRightSmall = Icons.arrow_forward;

  // 20x20 icons
  static const IconData closeMedium = Icons.close;
  static const IconData gridMedium = Icons.grid_view_outlined;
  static const IconData expandMoreMedium = Icons.expand_more;
  static const IconData editMedium = Icons.edit_outlined;
  static const IconData infoMedium = Icons.info_outline;
  static const IconData helpMedium = Icons.help_outline;
  static const IconData expandLessMedium = Icons.expand_less;
  static const IconData collapseMedium = Icons.unfold_less;
  static const IconData personMedium = Icons.person_outline;
  static const IconData emailMedium = Icons.email_outlined;
  static const IconData percentMedium = Icons.percent;
  static const IconData minusMedium = Icons.remove;
  static const IconData slashMedium = Icons.close;
  // static const IconData divideMedium = Icons.division;
  static const IconData cancelMedium = Icons.cancel_outlined;
  static const IconData addMedium = Icons.add;
  static const IconData plusMinusMedium = Icons.exposure;
  static const IconData arrowRightMedium = Icons.arrow_forward;
  static const IconData linkMedium = Icons.link;
  static const IconData deleteMedium = Icons.delete_outline;
  static const IconData checkboxMedium = Icons.check_box_outline_blank;
  static const IconData calendarMedium = Icons.calendar_today_outlined;
  static const IconData moreMedium = Icons.more_vert;
  static const IconData clockMedium = Icons.access_time;
  static const IconData backMedium = Icons.arrow_back;
  static const IconData searchMedium = Icons.search;
  static const IconData settingsMedium = Icons.settings;
  static const IconData codeMedium = Icons.code;
  static const IconData imageMedium = Icons.image_outlined;
  static const IconData favoriteMedium = Icons.favorite_border;

  // 24x24 icons (default Material size)
  static const IconData visibility = Icons.visibility_outlined;
  static const IconData visibilityOff = Icons.visibility_off_outlined;
  static const IconData info = Icons.info_outline;
  static const IconData warning = Icons.warning_amber_outlined;
  static const IconData error = Icons.error_outline;
  static const IconData help = Icons.help_outline;
  static const IconData expandMore = Icons.expand_more;
  static const IconData check = Icons.check;
  static const IconData email = Icons.email_outlined;
  static const IconData google = Icons.g_mobiledata;
  static const IconData facebook = Icons.facebook_outlined;
  static const IconData arrowBack = Icons.arrow_back;
  static const IconData apple = Icons.apple;
  static const IconData microsoft = Icons.window;
  static const IconData mobile = Icons.smartphone;
  static const IconData person = Icons.person_outline;
  static const IconData add = Icons.add;
  static const IconData square = Icons.crop_square;
  static const IconData checkSquare = Icons.check_box_outlined;
  static const IconData bell = Icons.notifications_none_outlined;
  static const IconData search = Icons.search;
  static const IconData list = Icons.list_alt_outlined;
  static const IconData grid = Icons.grid_view_outlined;
  static const IconData user = Icons.person_outline;
  static const IconData home = Icons.home_outlined;
  static const IconData image = Icons.image_outlined;
  static const IconData more = Icons.more_horiz;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline;
  static const IconData favorite = Icons.favorite_border;
  static const IconData file = Icons.insert_drive_file_outlined;
  static const IconData copy = Icons.content_copy_outlined;
  static const IconData calendar = Icons.calendar_today_outlined;
  static const IconData clock = Icons.access_time;
  static const IconData download = Icons.download_outlined;
  static const IconData calculator = Icons.calculate_outlined;
  static const IconData dollar = Icons.attach_money;
  static const IconData camera = Icons.camera_alt_outlined;
  static const IconData chart = Icons.bar_chart_outlined;
  static const IconData arrowUp = Icons.arrow_upward;
  static const IconData percent = Icons.percent;
  static const IconData document = Icons.description_outlined;
  static const IconData dropbox = Icons.cloud_outlined;
  static const IconData googleDrive = Icons.drive_folder_upload_outlined;
  static const IconData cloud = Icons.cloud_outlined;
  static const IconData link = Icons.link;
  static const IconData arrowLeft = Icons.arrow_back;
  static const IconData play = Icons.play_arrow_outlined;
  static const IconData checkCircle = Icons.check_circle_outline;
  static const IconData edit2 = Icons.edit_note;

  // 32x32 icons
  static const IconData documentLarge = Icons.description_outlined;

  /// Helper method to get an icon with a specific size
  static Widget getIcon(IconData icon,
      {double size = sizeLarge, Color? color}) {
    return Icon(
      icon,
      size: size,
      color: color,
    );
  }

  /// Helper method to get a small icon (16x16)
  static Widget getSmallIcon(IconData icon, {Color? color}) {
    return getIcon(icon, size: sizeSmall, color: color);
  }

  /// Helper method to get a medium icon (20x20)
  static Widget getMediumIcon(IconData icon, {Color? color}) {
    return getIcon(icon, size: sizeMedium, color: color);
  }

  /// Helper method to get a large icon (24x24)
  static Widget getLargeIcon(IconData icon, {Color? color}) {
    return getIcon(icon, size: sizeLarge, color: color);
  }

  /// Helper method to get an extra large icon (32x32)
  static Widget getExtraLargeIcon(IconData icon, {Color? color}) {
    return getIcon(icon, size: sizeExtraLarge, color: color);
  }
}
