import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
  divideSymbol,
}

extension DigitTypeX on DigitType {
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
      case DigitType.divideSymbol:
        return '/';
    }
  }
}

enum OperatorType {
  add,
  subtract,
  multiply,
  divide,
  percent,
}

extension OperatorTypeX on OperatorType {
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

enum UnitType {
  yards,
  feet,
  inch,
  meter,
  centimeter,
  millimeter,
}

extension UnitTypeX on UnitType {
  String get label {
    switch (this) {
      case UnitType.yards:
        return 'Yards';
      case UnitType.feet:
        return 'Feet';
      case UnitType.inch:
        return 'Inch';
      case UnitType.meter:
        return 'Meters';
      case UnitType.centimeter:
        return 'Centimeters';
      case UnitType.millimeter:
        return 'Millimeters';
    }
  }
}

enum ControlAction {
  delete,
  clearAll,
  moreOptions,
}

extension ControlActionX on ControlAction {
  String get label {
    switch (this) {
      case ControlAction.delete:
        return '⌫';
      case ControlAction.clearAll:
        return 'C';
      case ControlAction.moreOptions:
        return '⋯';
    }
  }

  IconData? get icon {
    switch (this) {
      case ControlAction.delete:
        return Icons.backspace_outlined;
      case ControlAction.moreOptions:
        return Icons.more_vert;
      case ControlAction.clearAll:
        return null;
    }
  }
}

enum GroupNameType {
  trigonometry,
  materials,
  carpentry,
  memory,
  basicGeometry,
  unit,
}

extension GroupNameTypeX on GroupNameType {
  String get label {
    switch (this) {
      case GroupNameType.trigonometry:
        return 'Trigonometry';
      case GroupNameType.materials:
        return 'Materials';
      case GroupNameType.carpentry:
        return 'Carpentry';
      case GroupNameType.memory:
        return 'Memory';
      case GroupNameType.basicGeometry:
        return 'Basic Geometry';
      case GroupNameType.unit:
        return 'Unit';
    }
  }
}

enum ResultType {
  equals,
  area,
  volume,
  density,
  custom,
}

extension ResultTypeX on ResultType {
  String label([String? customLabel]) {
    switch (this) {
      case ResultType.equals:
        return '=';
      case ResultType.area:
        return 'Area';
      case ResultType.volume:
        return 'Volume';
      case ResultType.density:
        return 'Density';
      case ResultType.custom:
        return customLabel ?? '=';
    }
  }
}

enum UnitSystem { imperial, metric }

extension UnitSystemX on UnitSystem {
  String get label {
    switch (this) {
      case UnitSystem.imperial:
        return 'Imperial';
      case UnitSystem.metric:
        return 'Metric';
    }
  }
}

@immutable
class KeyType {
  final String id;
  final String label;
  final IconData? icon;
  final VoidCallback? action;

  const KeyType({
    required this.id,
    required this.label,
    this.icon,
    this.action,
  });
}

@immutable
class FunctionGroup {
  final GroupNameType name;
  final List<KeyType> keys;
  final UnitSystem? unitSystem;

  const FunctionGroup({
    required this.name,
    required this.keys,
    this.unitSystem,
  });
}

