import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// The screen-reader strings the showcase hands to every keyboard it shows,
/// the way an app passes its localised ones.
const CoreKeyboardSemantics showcaseKeyboardSemantics = CoreKeyboardSemantics(
  digitLabel: _digitLabel,
  operatorLabel: _operatorLabel,
  unitLabel: _unitLabel,
  controlLabel: _controlLabel,
  controlHint: _controlHint,
  resultLabel: _resultLabel,
  resultHint: 'Works out the result',
  dragHandle: 'Keyboard handle, drag to collapse or expand',
  viewAllLabel: 'All function keys',
  viewAllHint: 'Opens the sheet with every function key group',
  unitSystemSwitch: 'Imperial or metric',
  groupHeader: _groupHeader,
  reorderHandle: _reorderHandle,
);

String _digitLabel(DigitType digit) =>
    digit == DigitType.decimal ? 'Decimal point' : 'Digit ${digit.label}';

String _operatorLabel(OperatorType operatorType) => switch (operatorType) {
      OperatorType.add => 'Plus',
      OperatorType.subtract => 'Minus',
      OperatorType.multiply => 'Times',
      OperatorType.divide => 'Divided by',
      OperatorType.percent => 'Percent',
    };

String _unitLabel(UnitType unit) =>
    unit == UnitType.divideSymbol ? 'Fraction bar' : '${unit.label} unit';

String _controlLabel(ControlAction action) => switch (action) {
      ControlAction.delete => 'Backspace',
      ControlAction.clearAll => 'Clear everything',
      ControlAction.paren => 'Bracket',
      // ignore: deprecated_member_use
      ControlAction.moreOptions => 'More',
    };

String _controlHint(ControlAction action) => switch (action) {
      ControlAction.delete => 'Removes the last character',
      ControlAction.clearAll => 'Empties the tape',
      ControlAction.paren => 'Opens a bracket, or closes the open one',
      // ignore: deprecated_member_use
      ControlAction.moreOptions => 'Shows more',
    };

String _resultLabel(String face) => face == '=' ? 'Equals' : face;

String _groupHeader(String groupLabel) => '$groupLabel group, selects it';

String _reorderHandle(String groupLabel) => 'Reorder $groupLabel group';
