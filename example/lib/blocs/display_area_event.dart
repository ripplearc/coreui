part of 'display_area_bloc.dart';

sealed class DisplayAreaEvent extends Equatable {
  const DisplayAreaEvent();

  @override
  List<Object?> get props => [];
}

class KeySelected extends DisplayAreaEvent {
  final String label;

  const KeySelected(this.label);

  @override
  List<Object?> get props => [label];
}

class DigitPressed extends DisplayAreaEvent {
  final String digit;

  const DigitPressed(this.digit);

  @override
  List<Object?> get props => [digit];
}

class UnitSelected extends DisplayAreaEvent {
  final String unit;

  const UnitSelected(this.unit);

  @override
  List<Object?> get props => [unit];
}

class OperatorPressed extends DisplayAreaEvent {
  final String operator;

  const OperatorPressed(this.operator);

  @override
  List<Object?> get props => [operator];
}

class ResetRequested extends DisplayAreaEvent {
  const ResetRequested();
}
