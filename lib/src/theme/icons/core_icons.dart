import 'icon_data.dart';
import 'material_icons.dart';
import 'svg_icons.dart';

/// Main icon class that combines both Material and SVG icons
/// https://www.figma.com/design/vugaGpii5HfgEQHPbrS3mU/Construculator-Visual-Design?node-id=4-173&t=zZdz9haSNp4XklEm-4
class CoreIcons {
  // Brand & Services (SVG)
  static const microsoft = CoreIconData.svg(CoreSvgIcons.microsoft);
  static const onedrive = CoreIconData.svg(CoreSvgIcons.onedrive);
  static const dropbox = CoreIconData.svg(CoreSvgIcons.dropbox);
  static const googleDrive = CoreIconData.svg(CoreSvgIcons.googleDrive);
  static const google = CoreIconData.svg(CoreSvgIcons.google);
  static const facebook = CoreMaterialIcons.facebook;

  // Math & Calculation (SVG)
  static const calculate = CoreIconData.svg(CoreSvgIcons.calculate);
  static const calculator = CoreIconData.svg(CoreSvgIcons.calculator);
  static const divide = CoreIconData.svg(CoreSvgIcons.divide);
  static const plusMinus = CoreIconData.svg(CoreSvgIcons.plusMinus);
  static const slash = CoreIconData.svg(CoreSvgIcons.slash);

  // Navigation (Material)
  static const backspaceLeft = CoreMaterialIcons.backspaceLeft;
  static const arrowRight = CoreMaterialIcons.arrowRight;
  static const arrowLeft = CoreMaterialIcons.arrowLeft;
  static const arrowUp = CoreMaterialIcons.arrowUp;
  static const arrowDown = CoreMaterialIcons.arrowDown;
  static const arrowDropDown = CoreMaterialIcons.arrowDropDown;
  static const arrowDropUp = CoreMaterialIcons.arrowDropUp;
  static const moreVert = CoreMaterialIcons.moreVert;
  static const moreHoriz = CoreMaterialIcons.moreHoriz;

  // Actions
  static const add = CoreMaterialIcons.add;
  static const remove = CoreMaterialIcons.remove;
  static const edit = CoreMaterialIcons.edit;
  static const delete = CoreIconData.svg(CoreSvgIcons.delete); // SVG version
  static const rename = CoreIconData.svg(CoreSvgIcons.rename); // SVG version
  static const close = CoreMaterialIcons.close;
  static const search = CoreMaterialIcons.search;
  static const refresh = CoreMaterialIcons.refresh;
  static const settings = CoreMaterialIcons.settings;
  static const download = CoreMaterialIcons.download;
  static const share = CoreMaterialIcons.share;
  static const copy = CoreMaterialIcons.copy;
  static const launch = CoreMaterialIcons.launch;
  static const plagiarism = CoreMaterialIcons.plagiarism;

  // Status
  static const info = CoreMaterialIcons.info;
  static const warning = CoreMaterialIcons.warning;
  static const error = CoreMaterialIcons.error;
  static const success = CoreMaterialIcons.success;
  static const help = CoreMaterialIcons.help;

  // Communication
  static const email = CoreMaterialIcons.email;
  static const message = CoreMaterialIcons.message;
  static const chat = CoreMaterialIcons.chat;
  static const notification = CoreMaterialIcons.notification;
  static const phone = CoreIconData.svg(CoreSvgIcons.phone); // SVG version

  // Files & Media
  static const file = CoreMaterialIcons.file;
  static const image = CoreMaterialIcons.image;
  static const camera = CoreMaterialIcons.camera;

  // Interface
  static const home = CoreMaterialIcons.home;
  static const list = CoreMaterialIcons.list;
  static const placeholder = CoreIconData.svg(CoreSvgIcons.placeholder);

  // User Management
  static const person = CoreMaterialIcons.person;
  static const people = CoreMaterialIcons.people;
  static const personAdd = CoreMaterialIcons.personAdd;
  static const members = CoreIconData.svg(CoreSvgIcons.members);

  // Security
  static const lock = CoreMaterialIcons.lock;
  static const unlock = CoreMaterialIcons.unlock;

  // Date & Time
  static const calendar = CoreMaterialIcons.calendar;
  static const history = CoreMaterialIcons.history;

  // Business
  static const cost = CoreIconData.svg(CoreSvgIcons.cost);
}
