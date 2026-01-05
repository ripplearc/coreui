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
      expect(UnitType.meter.label, equals('M'));
      expect(UnitType.centimeter.label, equals('CM'));
      expect(UnitType.millimeter.label, equals('MM'));
      expect(UnitType.divideSymbol.label, equals('/'));
    });
  });

  group('UnitSystem', () {
    test('label returns correct string for all unit systems', () {
      expect(UnitSystem.imperial.label, equals('Imperial'));
      expect(UnitSystem.metric.label, equals('Metric'));
    });
  });
}
