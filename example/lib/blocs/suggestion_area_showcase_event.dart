part of 'suggestion_area_showcase_bloc.dart';

/// Base class for all events related to the suggestion area showcase.
sealed class SuggestionAreaShowcaseEvent {
  /// Creates a [SuggestionAreaShowcaseEvent].
  const SuggestionAreaShowcaseEvent();
}

/// Fired when the user taps on an AI or conversion suggestion chip.
class SuggestionChipTapped extends SuggestionAreaShowcaseEvent {
  /// The label of the tapped suggestion chip.
  final String label;

  /// The primary value of the tapped suggestion chip.
  final String value;

  /// The unit associated with the tapped suggestion chip, if any.
  final String? unit;

  /// Creates a [SuggestionChipTapped] event.
  const SuggestionChipTapped(this.label, this.value, this.unit);
}

/// Fired when the user taps a calculator key to begin entering a new input.
class KeySelected extends SuggestionAreaShowcaseEvent {
  /// The label of the key that was selected (e.g., "Length", "Width").
  final String label;

  /// Creates a [KeySelected] event.
  const KeySelected(this.label);
}

/// Fired when the user taps a numeric digit or decimal point.
class DigitPressed extends SuggestionAreaShowcaseEvent {
  /// The digit string that was pressed.
  final String digit;

  /// Creates a [DigitPressed] event.
  const DigitPressed(this.digit);
}

/// Fired when the user selects a unit from the keyboard.
class UnitSelected extends SuggestionAreaShowcaseEvent {
  /// The unit string that was selected.
  final String unit;

  /// Creates a [UnitSelected] event.
  const UnitSelected(this.unit);
}

/// Fired when the user presses an operator button.
class OperatorPressed extends SuggestionAreaShowcaseEvent {
  /// The operator symbol that was pressed (e.g., "+", "=").
  final String operator;

  /// Creates an [OperatorPressed] event.
  const OperatorPressed(this.operator);
}

/// Fired when the user requests to clear the current state (e.g., 'AC' or 'C').
class ResetRequested extends SuggestionAreaShowcaseEvent {
  /// Creates a [ResetRequested] event.
  const ResetRequested();
}

class _InitializeEvent extends SuggestionAreaShowcaseEvent {
  const _InitializeEvent();
}
