part of 'display_area_bloc.dart';

/// Base class for all events related to the display area.
sealed class DisplayAreaEvent extends Equatable {
  /// Creates a [DisplayAreaEvent].
  const DisplayAreaEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when the user taps a calculator key to begin entering a new input.
///
/// [label] identifies which key was selected (e.g. "Rise", "Run").
class KeySelected extends DisplayAreaEvent {
  /// The label of the key that was selected.
  final String label;

  /// Creates a [KeySelected] event.
  const KeySelected(this.label);

  @override
  List<Object?> get props => [label];
}

/// Fired when the user taps a digit or decimal key.
class DigitPressed extends DisplayAreaEvent {
  /// The digit or decimal string that was pressed.
  final String digit;

  /// Creates a [DigitPressed] event.
  const DigitPressed(this.digit);

  @override
  List<Object?> get props => [digit];
}

/// Fired when the user selects a unit from a bottom sheet or menu.
class UnitSelected extends DisplayAreaEvent {
  /// The unit string that was selected (e.g. "feet", "inches").
  final String unit;

  /// Creates a [UnitSelected] event.
  const UnitSelected(this.unit);

  @override
  List<Object?> get props => [unit];
}

/// Fired when the user taps an operator key (e.g. "+", "-", "=").
class OperatorPressed extends DisplayAreaEvent {
  /// The operator string that was pressed.
  final String operator;

  /// Creates an [OperatorPressed] event.
  const OperatorPressed(this.operator);

  @override
  List<Object?> get props => [operator];
}

/// Fired when the user requests to reset the calculator state.
class ResetRequested extends DisplayAreaEvent {
  /// Creates a [ResetRequested] event.
  const ResetRequested();
}
