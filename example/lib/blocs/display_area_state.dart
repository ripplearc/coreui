part of 'display_area_bloc.dart';

/// The three trade spellings of one pitch, cycled by the Shown-as pill.
enum PitchReading {
  /// Rise per 12in of run (`16in/12in`).
  risePerRun,

  /// Degrees (`53.13°`).
  degrees,

  /// Percent grade (`133.3%`).
  grade,
}

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

  /// The dependent-key pills shown under the display area value — the
  /// assumptions, readings and offers the current answer depends on.
  final List<CoreDependentKeyData> dependentKeys;

  /// Fence post spacing in feet, edited through the O.C. pill.
  final double fenceOcFeet;

  /// Cost rate per square foot, edited through the Rate pill.
  final double ratePerSqFt;

  /// Waste allowance in percent, edited through the Waste pill.
  final double wastePercent;

  /// Which spelling of the pitch result is shown, cycled by the Shown-as pill.
  final PitchReading pitchReading;

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
    this.dependentKeys = const [],
    this.fenceOcFeet = 6.0,
    this.ratePerSqFt = 12.3,
    this.wastePercent = 10.0,
    this.pitchReading = PitchReading.risePerRun,
  });

  /// Returns the initial [DisplayAreaState] with all fields at their defaults.
  factory DisplayAreaState.initial() => const DisplayAreaState();

  /// Returns a copy of this state with the specified fields replaced.
  ///
  /// Nullable fields ([activeInputLabel], [resultLabel], [resultValue],
  /// [resultChip]) use a `Function()?` wrapper to distinguish
  /// `null` (clear the field) from absent (keep the current value).
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
    List<CoreDependentKeyData>? dependentKeys,
    double? fenceOcFeet,
    double? ratePerSqFt,
    double? wastePercent,
    PitchReading? pitchReading,
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
      dependentKeys: dependentKeys ?? this.dependentKeys,
      fenceOcFeet: fenceOcFeet ?? this.fenceOcFeet,
      ratePerSqFt: ratePerSqFt ?? this.ratePerSqFt,
      wastePercent: wastePercent ?? this.wastePercent,
      pitchReading: pitchReading ?? this.pitchReading,
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
        dependentKeys,
        fenceOcFeet,
        ratePerSqFt,
        wastePercent,
        pitchReading,
      ];
}
