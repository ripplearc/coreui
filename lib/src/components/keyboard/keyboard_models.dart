import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';


/// Defines the types of digits and symbols available on the keyboard.
/// - [zero] through [nine]: Numeric digits 0-9
/// - [decimal]: Decimal point symbol (.)
/// - [divideSymbol]: Division symbol (/)
enum DigitType {
  zero,
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  decimal,
}

/// Extension providing label strings for [DigitType] enum values.
extension DigitTypeX on DigitType {
  /// Returns the string label representation of the digit type.
  String get label {
    switch (this) {
      case DigitType.zero:
        return '0';
      case DigitType.one:
        return '1';
      case DigitType.two:
        return '2';
      case DigitType.three:
        return '3';
      case DigitType.four:
        return '4';
      case DigitType.five:
        return '5';
      case DigitType.six:
        return '6';
      case DigitType.seven:
        return '7';
      case DigitType.eight:
        return '8';
      case DigitType.nine:
        return '9';
      case DigitType.decimal:
        return '.';
    }
  }
}

/// Defines the types of mathematical operators available on the keyboard.
/// - [add]: Addition operator (+)
/// - [subtract]: Subtraction operator (−)
/// - [multiply]: Multiplication operator (×)
/// - [divide]: Division operator (÷)
/// - [percent]: Percentage operator (%)
enum OperatorType {
  add,
  subtract,
  multiply,
  divide,
  percent,
}

/// Extension providing symbol strings for [OperatorType] enum values.
extension OperatorTypeX on OperatorType {
  /// Returns the string symbol representation of the operator type.
  String get symbol {
    switch (this) {
      case OperatorType.add:
        return '+';
      case OperatorType.subtract:
        return '−';
      case OperatorType.multiply:
        return '×';
      case OperatorType.divide:
        return '÷';
      case OperatorType.percent:
        return '%';
    }
  }
}

/// Defines the types of measurement units available on the keyboard.
/// - [yards]: Yards unit
/// - [feet]: Feet unit
/// - [inch]: Inch unit
/// - [meter]: Meter unit
/// - [centimeter]: Centimeter unit
/// - [millimeter]: Millimeter unit
enum UnitType {
  yards,
  feet,
  inch,
  meter,
  centimeter,
  millimeter,
  divideSymbol,

}

/// Extension providing label strings for [UnitType] enum values.
extension UnitTypeX on UnitType {
  /// Returns the string label representation of the unit type.
  String get label {
    switch (this) {
      case UnitType.yards:
        return 'Yards';
      case UnitType.feet:
        return 'Feet';
      case UnitType.inch:
        return 'Inches';
      case UnitType.meter:
        return 'Meters';
      case UnitType.centimeter:
        return 'Centimeters';
      case UnitType.millimeter:
        return 'Millimeters';
      case UnitType.divideSymbol:
        return '/';
    }
  }
}

/// Defines control actions available on the keyboard.
/// - [delete]: Backspace/delete action
/// - [clearAll]: Clear all input action
/// - [moreOptions]: Show additional options
enum ControlAction {
  delete,
  clearAll,
  moreOptions,
}

/// Extension providing labels and icons for [ControlAction] enum values.
extension ControlActionX on ControlAction {
  /// Returns the string label representation of the control action.
  String get label {
    switch (this) {
      case ControlAction.delete:
        return '⌫';
      case ControlAction.clearAll:
        return 'C';
      case ControlAction.moreOptions:
        return '⋮';
    }
  }

  /// Returns the icon data for the control action, if applicable.
  /// Returns `null` for actions that use text labels instead of icons.
  IconData? get icon {
    switch (this) {
      case ControlAction.delete:
        return CoreIcons.backspaceLeft.materialIcon;
      case ControlAction.moreOptions:
        return CoreIcons.moreVert.materialIcon;
      case ControlAction.clearAll:
        return null;
    }
  }
}

/// Defines the types of function groups available on the keyboard.
/// - [label]: The label of the group

class GroupNameType{
 final String label;
 const GroupNameType({required this.label});

}


/// Defines the types of results that can be displayed on the keyboard.
/// - [label]: The label of the result
class ResultType {
  final String label;
  const ResultType({required this.label});

}

/// Defines the unit system types available on the keyboard.
/// - [imperial]: Imperial unit system
/// - [metric]: Metric unit system
enum UnitSystem { imperial, metric }

/// Extension providing label strings for [UnitSystem] enum values.
extension UnitSystemX on UnitSystem {
  /// Returns the string label representation of the unit system.
  String get label {
    switch (this) {
      case UnitSystem.imperial:
        return 'Imperial';
      case UnitSystem.metric:
        return 'Metric';
    }
  }
}

/// Represents a key on the keyboard with its properties.
/// 
/// [id] is a unique identifier for the key.
/// [label] is the text displayed on the key.
/// [icon] is an optional icon to display instead of or alongside the label.
/// [action] is the callback function executed when the key is pressed.
@immutable
class KeyType {
  /// Unique identifier for the key.
  final String id;
  
  /// Text label displayed on the key.
  final String label;
  
  /// Optional icon to display on the key.
  final IconData? icon;
  
  /// Callback function executed when the key is pressed.
  final VoidCallback? action;

  /// Creates a [KeyType] instance.
  const KeyType({
    required this.id,
    required this.label,
    this.icon,
    this.action,
  });
}

/// Represents a group of function keys on the keyboard.
/// 
/// [name] identifies the type of function group.
/// [keys] is the list of keys belonging to this function group.
/// [unitSystem] is an optional unit system associated with this group.
@immutable
class FunctionGroup {
  /// The type of function group.
  final GroupNameType name;
  
  /// List of keys belonging to this function group.
  final List<KeyType> keys;
  
  /// Optional unit system associated with this function group.
  final UnitSystem? unitSystem;

  /// Creates a [FunctionGroup] instance.
  const FunctionGroup({
    required this.name,
    required this.keys,
    this.unitSystem,
  });
}
