import 'package:flutter/foundation.dart';

import 'keyboard_models.dart';

/// The strings a screen reader announces for a `CoreKeyboard`, its "View
/// all" sheet and a `CoreNumberKeypad`: one object for the whole keyboard,
/// passed as `semantics`, so the app supplies and translates every label and
/// hint in one place. Since 0.15.0 a user-facing string belongs to the
/// consumer, and these are the last ones the keyboard spoke on its own.
///
/// Each field is a string, or a builder that receives what the key shows —
/// a [DigitType], an [OperatorType], a [UnitType], a [ControlAction], the
/// face of the result key or a group label — and returns the announcement.
/// [english] is the set the package shipped before 0.61.0 and the default of
/// every `semantics` parameter, so a caller that passes nothing keeps the
/// English it had. An app passes its own, built from its localisation.
///
/// Function keys are not here: a [KeyType] carries its own
/// [KeyType.semanticLabel]. The `( )` key's `parenSemanticLabel` and
/// `parenSemanticHint` and the sheet's `reorderSemanticsLabelBuilder` stay
/// as they were and, when set, win over [controlLabel], [controlHint] and
/// [reorderHandle].
@immutable
class CoreKeyboardSemantics {
  /// Creates the keyboard's screen-reader strings.
  const CoreKeyboardSemantics({
    required this.digitLabel,
    required this.operatorLabel,
    required this.unitLabel,
    required this.controlLabel,
    required this.controlHint,
    required this.resultLabel,
    required this.resultHint,
    required this.dragHandle,
    required this.viewAllLabel,
    required this.viewAllHint,
    required this.unitSystemSwitch,
    required this.groupHeader,
    required this.reorderHandle,
  });

  /// The label of a digit key, built from its [DigitType]: "7 button".
  final String Function(DigitType digit) digitLabel;

  /// The label of an operator key, built from its [OperatorType]:
  /// "+ operator button".
  final String Function(OperatorType operatorType) operatorLabel;

  /// The label of a unit key, built from its [UnitType]: "Feet unit button".
  final String Function(UnitType unit) unitLabel;

  /// The label of a control key, built from its [ControlAction]: "Delete
  /// button".
  final String Function(ControlAction action) controlLabel;

  /// The hint of a control key, built from its [ControlAction]: "Deletes the
  /// last entered character". Withheld while the key is disabled.
  final String Function(ControlAction action) controlHint;

  /// The label of the result key, built from the face it shows — "=",
  /// "AREA" or a caller-supplied "Update": "= button".
  final String Function(String face) resultLabel;

  /// The hint of the result key when it shows its default face:
  /// "Calculates and displays the result". A key with a caller-supplied face
  /// such as "Update" gets no hint, because its label already says what it
  /// does.
  final String resultHint;

  /// The label of the handle that collapses and expands the keyboard:
  /// "Keyboard drag handle".
  final String dragHandle;

  /// The label of the "View all" button on the function-key strip:
  /// "View all function keys".
  final String viewAllLabel;

  /// The hint of the "View all" button: "Opens a bottom sheet with all
  /// available function keys".
  final String viewAllHint;

  /// The label of the Imperial/Metric switch in the "View all" sheet:
  /// "Unit system switch".
  final String unitSystemSwitch;

  /// The label of a group's header in the "View all" sheet, built from the
  /// group label: "Function group header for Materials".
  final String Function(String groupLabel) groupHeader;

  /// The label of a group's drag handle in the "View all" sheet, built from
  /// the group label: "Drag indicator for Materials group".
  final String Function(String groupLabel) reorderHandle;

  /// The English strings the keyboard announced before 0.61.0, and the
  /// default wherever a `semantics` parameter is left out.
  static const CoreKeyboardSemantics english = CoreKeyboardSemantics(
    digitLabel: _englishDigitLabel,
    operatorLabel: _englishOperatorLabel,
    unitLabel: _englishUnitLabel,
    controlLabel: _englishControlLabel,
    controlHint: _englishControlHint,
    resultLabel: _englishResultLabel,
    resultHint: 'Calculates and displays the result',
    dragHandle: 'Keyboard drag handle',
    viewAllLabel: 'View all function keys',
    viewAllHint: 'Opens a bottom sheet with all available function keys',
    unitSystemSwitch: 'Unit system switch',
    groupHeader: _englishGroupHeader,
    reorderHandle: _englishReorderHandle,
  );

  static String _englishDigitLabel(DigitType digit) => '${digit.label} button';

  static String _englishOperatorLabel(OperatorType operatorType) =>
      '${operatorType.symbol} operator button';

  static String _englishUnitLabel(UnitType unit) => '${unit.label} unit button';

  static String _englishControlLabel(ControlAction action) => switch (action) {
        ControlAction.delete => 'Delete button',
        ControlAction.clearAll => 'Clear all button',
        ControlAction.moreOptions => 'More options button',
        ControlAction.paren => 'Bracket button',
      };

  static String _englishControlHint(ControlAction action) => switch (action) {
        ControlAction.delete => 'Deletes the last entered character',
        ControlAction.clearAll => 'Clears all input',
        ControlAction.moreOptions => 'Shows additional options',
        ControlAction.paren => 'Opens a bracket; the next press closes it',
      };

  static String _englishResultLabel(String face) => '$face button';

  static String _englishGroupHeader(String groupLabel) =>
      'Function group header for $groupLabel';

  static String _englishReorderHandle(String groupLabel) =>
      'Drag indicator for $groupLabel group';
}
