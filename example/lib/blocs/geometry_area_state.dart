part of 'geometry_area_bloc.dart';

class GeometryAreaState extends Equatable {
  /// The list of saved size rows shown in the geometry table.
  final List<CoreSizeCardData> sizesTableData;

  /// The label of the input currently being entered, or `null` if idle.
  final String? activeInputLabel;

  /// The raw string value being typed by the user, including units.
  final String currentInputValue;

  /// The purely numeric portion of the current input (no unit suffix).
  final String currentNumericValue;

  /// Whether the user is currently in the middle of an active input sequence.
  final bool isTyping;

  /// Chips for inputs that have been finalized.
  final List<CoreCalculatorChip> completedChips;

  /// Map of finalized input labels to their numeric values.
  final Map<String, double> finalizedValues;

  /// AI-generated suggestions (e.g. Area, Radius, Diameter, Circumference).
  final List<SuggestionData> aiSuggestions;

  /// Unit-conversion suggestions (e.g. ft → in, ft → yd).
  final List<SuggestionData> conversionSuggestions;

  /// Dynamic dimensions for the circle measurements table.
  final List<CoreDimensionData> dimensions;

  const GeometryAreaState({
    this.sizesTableData = const [],
    this.activeInputLabel,
    this.currentInputValue = '',
    this.currentNumericValue = '',
    this.isTyping = false,
    this.completedChips = const [],
    this.finalizedValues = const {},
    this.aiSuggestions = const [],
    this.conversionSuggestions = const [],
    this.dimensions = const [],
  });

  GeometryAreaState copyWith({
    List<CoreSizeCardData>? sizesTableData,
    String? Function()? activeInputLabel,
    String? currentInputValue,
    String? currentNumericValue,
    bool? isTyping,
    List<CoreCalculatorChip>? completedChips,
    Map<String, double>? finalizedValues,
    List<SuggestionData>? aiSuggestions,
    List<SuggestionData>? conversionSuggestions,
    List<CoreDimensionData>? dimensions,
  }) {
    return GeometryAreaState(
      sizesTableData: sizesTableData ?? this.sizesTableData,
      activeInputLabel:
          activeInputLabel != null ? activeInputLabel() : this.activeInputLabel,
      currentInputValue: currentInputValue ?? this.currentInputValue,
      currentNumericValue: currentNumericValue ?? this.currentNumericValue,
      isTyping: isTyping ?? this.isTyping,
      completedChips: completedChips ?? this.completedChips,
      finalizedValues: finalizedValues ?? this.finalizedValues,
      aiSuggestions: aiSuggestions ?? this.aiSuggestions,
      conversionSuggestions:
          conversionSuggestions ?? this.conversionSuggestions,
      dimensions: dimensions ?? this.dimensions,
    );
  }

  @override
  List<Object?> get props => [
        sizesTableData,
        activeInputLabel,
        currentInputValue,
        currentNumericValue,
        isTyping,
        completedChips,
        finalizedValues,
        aiSuggestions,
        conversionSuggestions,
        dimensions,
      ];
}
