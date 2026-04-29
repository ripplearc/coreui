import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'display_area_event.dart';
part 'display_area_state.dart';

/// A BLoC that manages the logic for the calculator display area.
///
/// It handles key selections, digit presses, unit selections, and operators,
/// and automatically computes a "Pitch" result when both "Rise" and "Run"
/// are provided.
class DisplayAreaBloc extends Bloc<DisplayAreaEvent, DisplayAreaState> {
  static const String _riseLabel = 'Rise';
  static const String _runLabel = 'Run';
  static const String _pitchLabel = 'Pitch-rise per 12in run';

  /// Creates a [DisplayAreaBloc].
  DisplayAreaBloc() : super(DisplayAreaState.initial()) {
    on<KeySelected>(_onKeySelected);
    on<DigitPressed>(_onDigitPressed);
    on<UnitSelected>(_onUnitSelected);
    on<OperatorPressed>(_onOperatorPressed);
    on<ResetRequested>(_onResetRequested);
  }

  void _onKeySelected(KeySelected event, Emitter<DisplayAreaState> emit) {
    final finalizedState = _finalizeCurrentInput(state);

    emit(finalizedState.copyWith(
      activeInputLabel: () => event.label,
      currentInputValue: '',
      currentNumericValue: '',
      isTyping: true,
      resultLabel: () => null,
      resultValue: () => null,
      resultChip: () => null,
    ));
  }

  void _onDigitPressed(DigitPressed event, Emitter<DisplayAreaState> emit) {
    if (!state.isTyping) return;

    final newValue = state.currentInputValue + event.digit;
    final newNumericValue = state.currentNumericValue + event.digit;
    emit(state.copyWith(
      currentInputValue: newValue,
      currentNumericValue: newNumericValue,
    ));
  }

  void _onUnitSelected(UnitSelected event, Emitter<DisplayAreaState> emit) {
    if (!state.isTyping) return;

    final unit = event.unit.toLowerCase() == 'feet' ? 'ft' : event.unit;

    final newValue = state.currentInputValue.isEmpty
        ? unit
        : '${state.currentInputValue} $unit';

    emit(state.copyWith(currentInputValue: newValue));
  }

  void _onOperatorPressed(
      OperatorPressed event, Emitter<DisplayAreaState> emit) {
    if (event.operator == '=') {
      _handleEquals(emit);
    }
  }

  void _handleEquals(Emitter<DisplayAreaState> emit) {
    emit(_finalizeCurrentInput(state));
  }

  DisplayAreaState _finalizeCurrentInput(DisplayAreaState currentState) {
    final activeInputLabel = currentState.activeInputLabel;
    if (currentState.isTyping &&
        activeInputLabel != null &&
        currentState.currentInputValue.isNotEmpty) {
      final completedInputLabel = activeInputLabel;
      final completedInputValue = currentState.currentInputValue;

      final newChip = CoreCalculatorChip(
        label: completedInputLabel,
        value: completedInputValue,
        type: CoreCalculatorChipType.editable,
      );

      final updatedChips =
          List<CoreCalculatorChip>.from(currentState.completedChips)
            ..add(newChip);

      final updatedNumericValues =
          Map<String, double>.from(currentState.finalizedValues)
            ..[completedInputLabel] =
                double.tryParse(currentState.currentNumericValue) ?? 0.0;

      var newState = currentState.copyWith(
        isTyping: false,
        completedChips: updatedChips,
        finalizedValues: updatedNumericValues,
      );

      if (updatedNumericValues.containsKey(_riseLabel) &&
          updatedNumericValues.containsKey(_runLabel)) {
        newState = _computePitch(newState);
      }

      return newState;
    }
    return currentState;
  }

  DisplayAreaState _computePitch(DisplayAreaState currentState) {
    final values = currentState.finalizedValues;
    final riseValue = values[_riseLabel];
    final runValue = values[_runLabel];

    if (riseValue != null && runValue != null && runValue != 0) {
      final pitchDecimal = riseValue / runValue;
      final pitchString =
          double.parse(pitchDecimal.toStringAsFixed(2)).toString();

      return currentState.copyWith(
        resultLabel: () => _pitchLabel,
        resultValue: () => pitchString,
        resultChip: () => CoreCalculatorChip(
          label: _pitchLabel,
          value: pitchString,
          type: CoreCalculatorChipType.disabled,
        ),
      );
    }

    return currentState;
  }

  void _onResetRequested(ResetRequested event, Emitter<DisplayAreaState> emit) {
    emit(DisplayAreaState.initial());
  }
}
