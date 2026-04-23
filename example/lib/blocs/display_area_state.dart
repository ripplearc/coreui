part of 'display_area_bloc.dart';

class DisplayAreaState extends Equatable {
  final String? activeInputLabel;
  final String currentInputValue;
  final bool isTyping;
  final List<CoreCalculatorChip> completedChips;
  final String? resultLabel;
  final String? resultValue;
  final CoreCalculatorChip? resultChip;

  const DisplayAreaState({
    this.activeInputLabel,
    this.currentInputValue = '',
    this.isTyping = false,
    this.completedChips = const [],
    this.resultLabel,
    this.resultValue,
    this.resultChip,
  });

  factory DisplayAreaState.initial() => const DisplayAreaState();

  DisplayAreaState copyWith({
    String? Function()? activeInputLabel,
    String? currentInputValue,
    bool? isTyping,
    List<CoreCalculatorChip>? completedChips,
    String? Function()? resultLabel,
    String? Function()? resultValue,
    CoreCalculatorChip? Function()? resultChip,
  }) {
    return DisplayAreaState(
      activeInputLabel:
          activeInputLabel != null ? activeInputLabel() : this.activeInputLabel,
      currentInputValue: currentInputValue ?? this.currentInputValue,
      isTyping: isTyping ?? this.isTyping,
      completedChips: completedChips ?? this.completedChips,
      resultLabel: resultLabel != null ? resultLabel() : this.resultLabel,
      resultValue: resultValue != null ? resultValue() : this.resultValue,
      resultChip: resultChip != null ? resultChip() : this.resultChip,
    );
  }

  @override
  List<Object?> get props => [
        activeInputLabel,
        currentInputValue,
        isTyping,
        completedChips,
        resultLabel,
        resultValue,
        resultChip,
      ];
}
