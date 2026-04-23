import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'display_area_event.dart';
part 'display_area_state.dart';

class DisplayAreaBloc extends Bloc<DisplayAreaEvent, DisplayAreaState> {
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
      isTyping: true,
      resultLabel: () => null,
      resultValue: () => null,
      resultChip: () => null,
    ));
  }

  void _onDigitPressed(DigitPressed event, Emitter<DisplayAreaState> emit) {
    if (!state.isTyping) return;

    final newValue = state.currentInputValue + event.digit;
    emit(state.copyWith(currentInputValue: newValue));
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

      var newState = currentState.copyWith(
        isTyping: false,
        completedChips: updatedChips,
      );

      if (updatedChips.any((c) => c.label == 'Rise') &&
          updatedChips.any((c) => c.label == 'Run')) {
        newState = _computePitch(newState);
      }

      return newState;
    }
    return currentState;
  }

  DisplayAreaState _computePitch(DisplayAreaState currentState) {
    final chips = currentState.completedChips;
    final riseChip = chips.firstWhere((c) => c.label == 'Rise');
    final runChip = chips.firstWhere((c) => c.label == 'Run');

    final riseValue = _parseValue(riseChip.value ?? '');
    final runValue = _parseValue(runChip.value ?? '');

    if (riseValue != null && runValue != null && runValue != 0) {
      final pitchDecimal = riseValue / runValue;
      final pitchString =
          double.parse(pitchDecimal.toStringAsFixed(2)).toString();

      return currentState.copyWith(
        resultLabel: () => 'Pitch-rise per 12in run',
        resultValue: () => pitchString,
        resultChip: () => CoreCalculatorChip(
          label: 'Pitch-rise per 12in run',
          value: pitchString,
          type: CoreCalculatorChipType.disabled,
        ),
      );
    }

    return currentState;
  }

  double? _parseValue(String value) {
    final regex = RegExp(r'(\d+\.?\d*)');
    final match = regex.firstMatch(value);
    if (match != null) {
      final groupValue = match.group(1);
      if (groupValue != null) {
        return double.tryParse(groupValue);
      }
    }
    return null;
  }

  void _onResetRequested(ResetRequested event, Emitter<DisplayAreaState> emit) {
    emit(DisplayAreaState.initial());
  }
}
