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
  static const cChar = CoreIconData.svg(CoreSvgIcons.cChar);

  // Navigation (Material)
  static const backspaceLeft = CoreMaterialIcons.backspaceLeft;
  static const arrowRight = CoreMaterialIcons.arrowRight;
  static const arrowLeft = CoreMaterialIcons.arrowLeft;
  static const arrowUp = CoreMaterialIcons.arrowUp;
  static const arrowDown = CoreMaterialIcons.arrowDown;
  static const arrowDropDown = CoreMaterialIcons.arrowDropDown;
  static const arrowDropUp = CoreMaterialIcons.arrowDropUp;
  static const unfoldLess = CoreMaterialIcons.unfoldLess;
  static const unfoldMore = CoreMaterialIcons.unfoldMore;
  static const moreVert = CoreMaterialIcons.moreVert;
  static const moreHoriz = CoreMaterialIcons.moreHoriz;

  // Actions
  static const add = CoreMaterialIcons.add;
  static const minus = CoreMaterialIcons.minus;
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
  static const backSpace = CoreMaterialIcons.backSpace;

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
  static const notification = CoreMaterialIcons.notification;
  static const phone = CoreIconData.svg(CoreSvgIcons.phone); // SVG version

  // Files & Media
  static const file = CoreMaterialIcons.file;
  static const image = CoreMaterialIcons.image;
  static const camera = CoreMaterialIcons.camera;

  // Interface
  static const home =  CoreIconData.svg(CoreSvgIcons.home);
  static const calculation =  CoreIconData.svg(CoreSvgIcons.calculation);
  static const list = CoreMaterialIcons.list;
  static const placeholder = CoreIconData.svg(CoreSvgIcons.placeholder);
  static const emptyEstimation = CoreIconData.svg(CoreSvgIcons.emptyEstimation);

  // User Management
  static const person = CoreMaterialIcons.person;
  static const people = CoreMaterialIcons.people;
  static const personAdd = CoreMaterialIcons.personAdd;
  static const members = CoreIconData.svg(CoreSvgIcons.members);

  // Security
  static const lock = CoreMaterialIcons.lock;
  static const unlock = CoreMaterialIcons.unlock;

  // Date & Time
  static const calendar = CoreIconData.svg(CoreSvgIcons.calendar);
  static const history = CoreMaterialIcons.history;

  // Business
  static const cost = CoreIconData.svg(CoreSvgIcons.cost);

  // Missed icons
  static const tabDuplicate = CoreIconData.svg(CoreSvgIcons.tabDuplicate);

  static const percent = CoreMaterialIcons.percent;
  static const cross = CoreMaterialIcons.cross;
  static const link = CoreMaterialIcons.link;
  static const check = CoreMaterialIcons.check;
  static const checkBlank = CoreMaterialIcons.checkBlank;
  static const checkCircle = CoreMaterialIcons.checkCircle;
  static const favorite = CoreMaterialIcons.favorite;
  static const eye = CoreMaterialIcons.eye;
  static const eyeOff = CoreMaterialIcons.eyeOff;
  static const apple = CoreMaterialIcons.apple;
  static const mathOperations = CoreMaterialIcons.mathOperations;
  static const fileSearch = CoreMaterialIcons.fileSearch;
  static const editDocument = CoreIconData.svg(CoreSvgIcons.editDocument);
  static const emptyFile = CoreMaterialIcons.emptyFile;
  static const addComment = CoreMaterialIcons.addComment;
  static const radioChecked = CoreMaterialIcons.radioChecked;
  static const radio = CoreMaterialIcons.radio;
  static const indeterminateCheckBox = CoreMaterialIcons.indeterminateCheckBox;
  static const dollar = CoreMaterialIcons.dollar;
  static const cloudOff = CoreMaterialIcons.cloudOff;
  static const play = CoreMaterialIcons.play;
  static const cameraSwitch = CoreMaterialIcons.cameraSwitch;
  static const block = CoreMaterialIcons.block;
  static const checkMark = CoreMaterialIcons.checkMark;
  static const tag = CoreIconData.svg(CoreSvgIcons.tag);
  static const verified = CoreMaterialIcons.verified;
  static const addFile = CoreMaterialIcons.addFile;
  static const docs = CoreIconData.svg(CoreSvgIcons.docs);
}
