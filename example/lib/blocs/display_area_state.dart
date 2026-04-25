part of 'display_area_bloc.dart';

/// Represents the current state of the display area calculator.
class DisplayAreaState extends Equatable {
  /// The label of the input currently being entered, or `null` if idle.
  final String? activeInputLabel;

  /// The raw string value being typed by the user.
  final String currentInputValue;

  /// The numeric portion of the current input, stored separately to avoid
  /// round-trip parsing.
  final String currentNumericValue;

  /// Whether the user is currently in the middle of an input sequence.

  final bool isTyping;

  /// The list of inputs that have been finalized and converted into chips.
  final List<CoreCalculatorChip> completedChips;

  /// Map of finalized labels to their numeric values, avoiding regex parsing.
  final Map<String, double> finalizedValues;

  /// The label for the computed result (e.g. "Pitch"), or `null` if none.

  final String? resultLabel;

  /// The value for the computed result, or `null` if none.
  final String? resultValue;

  /// A standalone chip representing the final computed result.
  final CoreCalculatorChip? resultChip;

  /// Creates a [DisplayAreaState].
  const DisplayAreaState({
    this.activeInputLabel,
    this.currentInputValue = '',
    this.currentNumericValue = '',
    this.isTyping = false,
    this.completedChips = const [],
    this.finalizedValues = const {},
    this.resultLabel,
    this.resultValue,
    this.resultChip,
  });

  factory DisplayAreaState.initial() => const DisplayAreaState();

  DisplayAreaState copyWith({
    String? Function()? activeInputLabel,
    String? currentInputValue,
    String? currentNumericValue,
    bool? isTyping,
    List<CoreCalculatorChip>? completedChips,
    Map<String, double>? finalizedValues,
    String? Function()? resultLabel,
    String? Function()? resultValue,
    CoreCalculatorChip? Function()? resultChip,
  }) {
    return DisplayAreaState(
      activeInputLabel:
          activeInputLabel != null ? activeInputLabel() : this.activeInputLabel,
      currentInputValue: currentInputValue ?? this.currentInputValue,
      currentNumericValue: currentNumericValue ?? this.currentNumericValue,
      isTyping: isTyping ?? this.isTyping,
      completedChips: completedChips ?? this.completedChips,
      finalizedValues: finalizedValues ?? this.finalizedValues,
      resultLabel: resultLabel != null ? resultLabel() : this.resultLabel,
      resultValue: resultValue != null ? resultValue() : this.resultValue,
      resultChip: resultChip != null ? resultChip() : this.resultChip,
    );
  }

  @override
  List<Object?> get props => [
        activeInputLabel,
        currentInputValue,
        currentNumericValue,
        isTyping,
        completedChips,
        finalizedValues,
        resultLabel,
        resultValue,
        resultChip,
      ];
}
