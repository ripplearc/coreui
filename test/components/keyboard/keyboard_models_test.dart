import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('DigitType', () {
    test('label returns correct string for all digit types', () {
      expect(DigitType.zero.label, equals('0'));
      expect(DigitType.one.label, equals('1'));
      expect(DigitType.two.label, equals('2'));
      expect(DigitType.three.label, equals('3'));
      expect(DigitType.four.label, equals('4'));
      expect(DigitType.five.label, equals('5'));
      expect(DigitType.six.label, equals('6'));
      expect(DigitType.seven.label, equals('7'));
      expect(DigitType.eight.label, equals('8'));
      expect(DigitType.nine.label, equals('9'));
      expect(DigitType.decimal.label, equals('.'));
    });
  });

  group('OperatorType', () {
    test('symbol returns correct string for all operator types', () {
      expect(OperatorType.add.symbol, equals('+'));
      expect(OperatorType.subtract.symbol, equals('−'));
      expect(OperatorType.multiply.symbol, equals('×'));
      expect(OperatorType.divide.symbol, equals('÷'));
      expect(OperatorType.percent.symbol, equals('%'));
    });
  });

  group('UnitType', () {
    test('label returns correct string for all unit types', () {
      expect(UnitType.yards.label, equals('Yards'));
      expect(UnitType.feet.label, equals('Feet'));
      expect(UnitType.inch.label, equals('Inch'));
      expect(UnitType.meter.label, equals('Meters'));
      expect(UnitType.centimeter.label, equals('Centimeters'));
      expect(UnitType.millimeter.label, equals('Millimeters'));
      expect(UnitType.divideSymbol.label, equals('/'));
    });
  });

  group('ControlAction', () {
    test('label returns correct string for all control actions', () {
      expect(ControlAction.delete.label, equals('⌫'));
      expect(ControlAction.clearAll.label, equals('C'));
      expect(ControlAction.moreOptions.label, equals('⋮'));
    });

    test('icon returns correct IconData for actions with icons', () {
      expect(ControlAction.delete.icon, isNotNull);
      expect(ControlAction.moreOptions.icon, isNotNull);
      expect(ControlAction.clearAll.icon, isNull);
    });

    test('icon returns IconData from CoreMaterialIcons', () {
      final deleteIcon = ControlAction.delete.icon;
      final moreOptionsIcon = ControlAction.moreOptions.icon;
      
      expect(deleteIcon, isNotNull);
      expect(moreOptionsIcon, isNotNull);
      expect(deleteIcon, isA<IconData>());
      expect(moreOptionsIcon, isA<IconData>());
    });
  });


  group('UnitSystem', () {
    test('label returns correct string for all unit systems', () {
      expect(UnitSystem.imperial.label, equals('Imperial'));
      expect(UnitSystem.metric.label, equals('Metric'));
    });
  });

}

