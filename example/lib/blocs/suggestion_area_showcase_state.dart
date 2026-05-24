part of 'suggestion_area_showcase_bloc.dart';

/// Represents the current state of the suggestion area showcase calculator.
class SuggestionAreaShowcaseState {
  /// Whether the suggestion area is currently expanded.
  final bool isSuggestionExpanded;

  /// The label of the input currently being entered, or `null` if idle.
  final String? activeInputLabel;

  /// The raw string value being typed by the user, including units.
  final String currentInputValue;

  /// The purely numeric portion of the current input.
  final String currentNumericValue;

  /// Whether the user is currently in the middle of an active input sequence.
  final bool isTyping;

  /// The list of inputs that have been finalized and converted into history chips.
  final List<CoreCalculatorChip> completedChips;

  /// Map of finalized labels to their numeric values.
  final Map<String, double> finalizedValues;

  /// The label for the computed result, or `null` if none.
  final String? resultLabel;

  /// The value for the computed result, or `null` if none.
  final String? resultValue;

  /// A standalone chip representing the final computed result.
  final CoreCalculatorChip? resultChip;

  /// The list of AI-generated suggestion chips.
  final List<SuggestionData> aiSuggestions;

  /// The list of unit conversion suggestion chips.
  final List<SuggestionData> conversionSuggestions;

  /// Creates a [SuggestionAreaShowcaseState].
  const SuggestionAreaShowcaseState({
    this.isSuggestionExpanded = false,
    this.activeInputLabel,
    this.currentInputValue = '',
    this.currentNumericValue = '',
    this.isTyping = false,
    this.completedChips = const [],
    this.finalizedValues = const {},
    this.resultLabel,
    this.resultValue,
    this.resultChip,
    required this.aiSuggestions,
    required this.conversionSuggestions,
  });

  /// Returns an empty [SuggestionAreaShowcaseState] with zero state properties.
  factory SuggestionAreaShowcaseState.empty() {
    return const SuggestionAreaShowcaseState(
      aiSuggestions: [],
      conversionSuggestions: [],
    );
  }

  /// Returns the initial [SuggestionAreaShowcaseState] with default configuration.
  factory SuggestionAreaShowcaseState.initial(
      void Function(String label, String value, String? unit) onChipTap) {
    return const SuggestionAreaShowcaseState(
      aiSuggestions: [],
      conversionSuggestions: [],
    );
  }

  /// Returns a copy of this state with the specified fields replaced.
  ///
  /// Nullable fields ([activeInputLabel], [resultLabel], [resultValue],
  /// [resultChip]) use a `Function()?` wrapper to distinguish `null`
  /// (clear the field) from an absent argument (keep the current value).
  SuggestionAreaShowcaseState copyWith({
    bool? isSuggestionExpanded,
    String? Function()? activeInputLabel,
    String? currentInputValue,
    String? currentNumericValue,
    bool? isTyping,
    List<CoreCalculatorChip>? completedChips,
    Map<String, double>? finalizedValues,
    String? Function()? resultLabel,
    String? Function()? resultValue,
    CoreCalculatorChip? Function()? resultChip,
    List<SuggestionData>? aiSuggestions,
    List<SuggestionData>? conversionSuggestions,
  }) {
    return SuggestionAreaShowcaseState(
      isSuggestionExpanded: isSuggestionExpanded ?? this.isSuggestionExpanded,
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
      aiSuggestions: aiSuggestions ?? this.aiSuggestions,
      conversionSuggestions:
          conversionSuggestions ?? this.conversionSuggestions,
    );
  }
}
