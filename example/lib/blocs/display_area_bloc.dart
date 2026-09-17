import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'display_area_event.dart';
part 'display_area_state.dart';

/// A BLoC that manages the logic for the calculator display area.
///
/// It handles key selections, digit presses, unit selections, and operators,
/// automatically computes a "Pitch" result when both "Rise" and "Run" are
/// provided, computes a "Fence" post count when the Fence function key is
/// selected after a Length has been entered, and prices the current area when
/// the Cost key is pressed. Each answer keeps its assumptions on screen as
/// dependent-key pills: O.C. under a fence count, Rate + Waste under a cost,
/// and a Shown-as toggle under a pitch.
class DisplayAreaBloc extends Bloc<DisplayAreaEvent, DisplayAreaState> {
  static const String _riseLabel = 'Rise';
  static const String _runLabel = 'Run';
  static const String _pitchLabel = 'Pitch';

  static const String _lengthLabel = 'Length';
  static const String _widthLabel = 'Width';
  static const String _fenceLabel = 'Fence';
  static const String _fenceResultLabel = 'Posts';
  static const String _costLabel = 'Cost';
  static const String _ocLabel = 'O.C';

  static const String _ocPillId = 'oc';
  static const String _ratePillId = 'rate';
  static const String _wastePillId = 'waste';
  static const String _shownAsPillId = 'shownAs';

  static const List<double> _ocOptions = [6.0, 8.0, 10.0];
  static const List<double> _rateOptions = [12.3, 14.5, 10.0];
  static const List<double> _wasteOptions = [10.0, 15.0, 0.0];

  /// Creates a [DisplayAreaBloc].
  DisplayAreaBloc() : super(DisplayAreaState.initial()) {
    on<KeySelected>(_onKeySelected);
    on<DigitPressed>(_onDigitPressed);
    on<UnitSelected>(_onUnitSelected);
    on<OperatorPressed>(_onOperatorPressed);
    on<DependentKeyPressed>(_onDependentKeyPressed);
    on<ResetRequested>(_onResetRequested);
  }

  void _onKeySelected(KeySelected event, Emitter<DisplayAreaState> emit) {
    if (event.label == _fenceLabel) {
      final finalizedState = _finalizeCurrentInput(state);
      emit(_computeFence(finalizedState));
      return;
    }
    if (event.label == _costLabel) {
      final finalizedState = _finalizeCurrentInput(state);
      emit(_computeCost(finalizedState));
      return;
    }

    final finalizedState = _finalizeCurrentInput(state);

    emit(finalizedState.copyWith(
      activeInputLabel: () => event.label,
      currentInputValue: '',
      currentNumericValue: '',
      isTyping: true,
      resultLabel: () => null,
      resultValue: () => null,
      resultChip: () => null,
      dependentKeys: const [],
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

  void _onDependentKeyPressed(
      DependentKeyPressed event, Emitter<DisplayAreaState> emit) {
    switch (event.id) {
      case _ocPillId:
        emit(_computeFence(
            state.copyWith(fenceOcFeet: _next(_ocOptions, state.fenceOcFeet))));
      case _ratePillId:
        emit(_computeCost(state.copyWith(
            ratePerSqFt: _next(_rateOptions, state.ratePerSqFt))));
      case _wastePillId:
        emit(_computeCost(state.copyWith(
            wastePercent: _next(_wasteOptions, state.wastePercent))));
      case _shownAsPillId:
        final readings = PitchReading.values;
        final next = readings[(state.pitchReading.index + 1) % readings.length];
        emit(_computePitch(state.copyWith(pitchReading: next)));
    }
  }

  static double _next(List<double> options, double current) {
    final index = options.indexOf(current);
    return options[(index + 1) % options.length];
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
      final ratio = riseValue / runValue;
      final (pitchString, readingLabel) = switch (currentState.pitchReading) {
        PitchReading.risePerRun => (
            '${_trim(ratio * 12)}in/12in',
            'in/12in',
          ),
        PitchReading.degrees => (
            '${_trim(math.atan(ratio) * 180 / math.pi)}°',
            'degrees',
          ),
        PitchReading.grade => ('${_trim(ratio * 100)}%', 'grade'),
      };

      return currentState.copyWith(
        resultLabel: () => _pitchLabel,
        resultValue: () => pitchString,
        resultChip: () => CoreCalculatorChip(
          label: _pitchLabel,
          value: pitchString,
          type: CoreCalculatorChipType.result,
        ),
        dependentKeys: [
          CoreDependentKeyData(
            label: 'Shown as',
            value: readingLabel,
            kind: CoreDependentKeyKind.toggle,
            onPressed: () => add(const DependentKeyPressed(_shownAsPillId)),
          ),
        ],
      );
    }

    return currentState;
  }

  static String _trim(double value) =>
      double.parse(value.toStringAsFixed(2)).toString();

  DisplayAreaState _computeFence(DisplayAreaState currentState) {
    final length = currentState.finalizedValues[_lengthLabel];
    if (length == null) {
      return currentState;
    }

    final posts = (length / currentState.fenceOcFeet).ceil() + 1;
    final postsString = posts.toString();

    return currentState.copyWith(
      isTyping: false,
      activeInputLabel: () => null,
      resultLabel: () => _fenceResultLabel,
      resultValue: () => postsString,
      resultChip: () => CoreCalculatorChip(
        label: _fenceLabel,
        value: postsString,
        type: CoreCalculatorChipType.result,
      ),
      dependentKeys: [
        CoreDependentKeyData(
          label: _ocLabel,
          value: '${_trim(currentState.fenceOcFeet)}ft',
          kind: CoreDependentKeyKind.editable,
          onPressed: () => add(const DependentKeyPressed(_ocPillId)),
        ),
      ],
    );
  }

  DisplayAreaState _computeCost(DisplayAreaState currentState) {
    final length = currentState.finalizedValues[_lengthLabel];
    final width = currentState.finalizedValues[_widthLabel];
    if (length == null || width == null) {
      return currentState;
    }

    final area = length * width;
    final cost =
        area * currentState.ratePerSqFt * (1 + currentState.wastePercent / 100);
    final costString = '\$${cost.toStringAsFixed(2)}';

    return currentState.copyWith(
      isTyping: false,
      activeInputLabel: () => null,
      resultLabel: () => _costLabel,
      resultValue: () => costString,
      resultChip: () => CoreCalculatorChip(
        label: _costLabel,
        value: costString,
        type: CoreCalculatorChipType.result,
      ),
      dependentKeys: [
        CoreDependentKeyData(
          label: 'Rate',
          value: '\$${_trim(currentState.ratePerSqFt)}/ft²',
          kind: CoreDependentKeyKind.editable,
          onPressed: () => add(const DependentKeyPressed(_ratePillId)),
        ),
        CoreDependentKeyData(
          label: 'Waste',
          value: '${_trim(currentState.wastePercent)}%',
          kind: CoreDependentKeyKind.editable,
          onPressed: () => add(const DependentKeyPressed(_wastePillId)),
        ),
      ],
    );
  }

  void _onResetRequested(ResetRequested event, Emitter<DisplayAreaState> emit) {
    emit(DisplayAreaState.initial());
  }
}
