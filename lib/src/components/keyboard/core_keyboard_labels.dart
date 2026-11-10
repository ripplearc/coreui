import 'package:flutter/foundation.dart';

import 'keyboard_models.dart';

/// The words a `CoreKeyboard` and its "View all" sheet show that are not a
/// key's face: the strip's "View all", the "… group" header on the strip and
/// in the sheet, and the sheet's "Function keys" title, "Measurement System"
/// row and "Imperial" / "Metric" switch faces. One object for the whole
/// keyboard, passed as `labels`, so the app supplies and translates them in
/// one place; its screen-reader strings are `CoreKeyboardSemantics`.
///
/// [english] is the set the package showed before 0.98.0 and the default of
/// every `labels` parameter, so a caller that passes nothing keeps the English
/// it had. As with `CoreKeyboardSemantics.english`, that default is an
/// exception to the 0.15.0 rule that a user-facing string reaches the screen
/// only through the app's localisation: CA-1370 allows it so that no existing
/// caller breaks, at the cost that a call site which forgets the set stays
/// English with no warning. An app passes its own, built from its
/// localisation.
///
/// A function key's face and a group's name are not here: a [KeyType] and a
/// [GroupNameType] carry their own labels. Nor are the unit keys' faces,
/// "Feet", "Inch", "Yards", "M", "CM" and "MM": those come from
/// [UnitTypeX.label] and stay English.
@immutable
class CoreKeyboardLabels {
  /// Creates the keyboard's visible words.
  const CoreKeyboardLabels({
    required this.viewAll,
    required this.functionKeys,
    required this.groupHeader,
    required this.measurementSystem,
    required this.imperial,
    required this.metric,
  });

  /// The face of the button on the function-key strip that opens the sheet:
  /// "View all". Keep it to a word or two: the button sits beside the group
  /// header, which gives way first, and a face wider than the strip overflows
  /// it.
  final String viewAll;

  /// The title of the "View all" sheet: "Function keys".
  final String functionKeys;

  /// The header of a group, built from the group's label, on the strip and in
  /// the sheet: "Materials group".
  final String Function(String groupLabel) groupHeader;

  /// The label of the sheet's unit system row: "Measurement System".
  final String measurementSystem;

  /// The face of the unit system switch while it is off: "Imperial". The
  /// switch's track is a fixed width, so keep the face to one short word.
  final String imperial;

  /// The face of the unit system switch while it is on: "Metric". The
  /// switch's track is a fixed width, so keep the face to one short word.
  final String metric;

  /// The English words the keyboard showed before 0.98.0, and the default
  /// wherever a `labels` parameter is left out.
  static const CoreKeyboardLabels english = CoreKeyboardLabels(
    viewAll: 'View all',
    functionKeys: 'Function keys',
    groupHeader: _englishGroupHeader,
    measurementSystem: 'Measurement System',
    imperial: 'Imperial',
    metric: 'Metric',
  );

  static String _englishGroupHeader(String groupLabel) => '$groupLabel group';
}
