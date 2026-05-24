import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'suggestion_area_showcase_event.dart';
part 'suggestion_area_showcase_state.dart';

/// A BLoC that manages the logic for the suggestion area showcase.
///
/// It handles key selections, digit presses, unit selections, and operators,
/// automatically computes Area suggestions when both "Length" and "Width" are
/// provided, and generates unit conversion chips dynamically.

class SuggestionAreaShowcaseBloc
    extends Bloc<SuggestionAreaShowcaseEvent, SuggestionAreaShowcaseState> {
  /// Creates a [SuggestionAreaShowcaseBloc].
  SuggestionAreaShowcaseBloc() : super(SuggestionAreaShowcaseState.empty()) {
    on<_InitializeEvent>((event, emit) {
      emit(SuggestionAreaShowcaseState.initial((label, value, unit) {
        add(SuggestionChipTapped(label, value, unit));
      }));
    });

    on<SuggestionAreaExpanded>((event, emit) {
      emit(state.copyWith(isSuggestionExpanded: event.isExpanded));
    });

    on<SuggestionChipTapped>((event, emit) {
      final unitStr = event.unit != null ? ' ${event.unit}' : '';
      final chipValueStr = '${event.value}$unitStr';

      if (event.label == 'Area:') {
        final finalizedState = _finalizeCurrentInput(state);

        final areaChip = CoreCalculatorChip(
          label: 'Area',
          value: chipValueStr,
          type: CoreCalculatorChipType.disabled,
        );

        final updatedChips =
            List<CoreCalculatorChip>.from(finalizedState.completedChips)
              ..add(areaChip);
        final updatedValues =
            Map<String, double>.from(finalizedState.finalizedValues)
              ..['Area'] = double.tryParse(event.value) ?? 0.0;

        final newState = finalizedState.copyWith(
          activeInputLabel: () => 'Area',
          currentInputValue: chipValueStr,
          currentNumericValue: event.value,
          isTyping: false,
          completedChips: updatedChips,
          finalizedValues: updatedValues,
        );
        _updateSuggestions(newState, emit);
      } else {
        final newState = state.copyWith(
          currentInputValue: chipValueStr,
          currentNumericValue: event.value,
        );
        _updateSuggestions(newState, emit);
      }
    });

    on<KeySelected>(_onKeySelected);
    on<DigitPressed>(_onDigitPressed);
    on<UnitSelected>(_onUnitSelected);
    on<OperatorPressed>(_onOperatorPressed);
    on<ResetRequested>(_onResetRequested);

    add(const _InitializeEvent());
  }

  void _onKeySelected(
      KeySelected event, Emitter<SuggestionAreaShowcaseState> emit) {
    final finalizedState = _finalizeCurrentInput(state);
    final newState = finalizedState.copyWith(
      activeInputLabel: () => event.label,
      currentInputValue: '',
      currentNumericValue: '',
      isTyping: true,
      resultLabel: () => null,
      resultValue: () => null,
      resultChip: () => null,
      aiSuggestions: [],
      conversionSuggestions: [],
    );
    _updateSuggestions(newState, emit);
  }

  void _onDigitPressed(
      DigitPressed event, Emitter<SuggestionAreaShowcaseState> emit) {
    if (!state.isTyping) return;
    final newValue = state.currentInputValue + event.digit;
    final newNumericValue = state.currentNumericValue + event.digit;
    final newState = state.copyWith(
      currentInputValue: newValue,
      currentNumericValue: newNumericValue,
    );
    _updateSuggestions(newState, emit);
  }

  void _onUnitSelected(
      UnitSelected event, Emitter<SuggestionAreaShowcaseState> emit) {
    if (!state.isTyping) return;
    final unit = event.unit.toLowerCase() == 'feet' ? 'ft' : event.unit;
    final newValue = state.currentInputValue.isEmpty
        ? unit
        : '${state.currentInputValue} $unit';
    final newState = state.copyWith(currentInputValue: newValue);
    _updateSuggestions(newState, emit);
  }

  void _onOperatorPressed(
      OperatorPressed event, Emitter<SuggestionAreaShowcaseState> emit) {
    if (event.operator == '=') {
      final newState = _finalizeCurrentInput(state);
      _updateSuggestions(newState, emit);
    }
  }

  void _onResetRequested(
      ResetRequested event, Emitter<SuggestionAreaShowcaseState> emit) {
    emit(SuggestionAreaShowcaseState.initial((label, value, unit) {
      add(SuggestionChipTapped(label, value, unit));
    }));
  }

  SuggestionAreaShowcaseState _finalizeCurrentInput(
      SuggestionAreaShowcaseState currentState) {
    final activeInputLabel = currentState.activeInputLabel;
    if (currentState.isTyping &&
        activeInputLabel != null &&
        currentState.currentInputValue.isNotEmpty) {
      final newChip = CoreCalculatorChip(
        label: activeInputLabel,
        value: currentState.currentInputValue,
        type: CoreCalculatorChipType.editable,
      );

      final updatedChips =
          List<CoreCalculatorChip>.from(currentState.completedChips)
            ..add(newChip);
      final updatedNumericValues =
          Map<String, double>.from(currentState.finalizedValues)
            ..[activeInputLabel] =
                double.tryParse(currentState.currentNumericValue) ?? 0.0;

      return currentState.copyWith(
        isTyping: false,
        completedChips: updatedChips,
        finalizedValues: updatedNumericValues,
      );
    }
    return currentState;
  }

  void _updateSuggestions(SuggestionAreaShowcaseState newState,
      Emitter<SuggestionAreaShowcaseState> emit) {
    // Preserve existing lists instead of clearing them
    List<SuggestionData> conv = List.from(newState.conversionSuggestions);
    List<SuggestionData> ai = List.from(newState.aiSuggestions);

    if (newState.isTyping && newState.activeInputLabel != null) {
      final match = RegExp(r'^([\d.]+)\s*([a-zA-Z]+)$')
          .firstMatch(newState.currentInputValue);
      if (match != null) {
        final numberStr = match.group(1);
        final unitStr = match.group(2);
        if (numberStr != null && unitStr != null) {
          final number = double.tryParse(numberStr);
          if (number != null && unitStr.toLowerCase() == 'ft') {
            final convIn = number * 12;
            final convYd = number / 3;
            conv = [
              SuggestionData(
                label: 'Conv:',
                value: convIn.toStringAsFixed(0),
                unit: 'in',
                onTap: () => add(SuggestionChipTapped(
                    'Conv:', convIn.toStringAsFixed(0), 'in')),
              ),
              SuggestionData(
                label: 'Conv:',
                value: convYd.toStringAsFixed(2),
                unit: 'yd',
                onTap: () => add(SuggestionChipTapped(
                    'Conv:', convYd.toStringAsFixed(2), 'yd')),
              ),
            ];
          }
        }
      }

      final lengthVal = newState.finalizedValues['Length'];
      final widthVal = newState.finalizedValues['Width'];
      final isTypingWidthWithUnit = newState.isTyping &&
          newState.activeInputLabel == 'Width' &&
          RegExp(r'^([\d.]+)\s*([a-zA-Z]+)$')
              .hasMatch(newState.currentInputValue);

      if (lengthVal != null && (widthVal != null || isTypingWidthWithUnit)) {
        double currentWidth = widthVal ?? 0.0;
        if (isTypingWidthWithUnit) {
          final match = RegExp(r'^([\d.]+)\s*([a-zA-Z]+)$')
              .firstMatch(newState.currentInputValue);
          if (match != null) {
            final widthStr = match.group(1);
            if (widthStr != null) {
              currentWidth = double.tryParse(widthStr) ?? 0.0;
            }
          }
        }
        final areaSqFt = lengthVal * currentWidth;
        ai = [
          SuggestionData(
            label: 'Area:',
            value: areaSqFt.toStringAsFixed(2),
            unit: 'sq ft',
            onTap: () => add(SuggestionChipTapped(
                'Area:', areaSqFt.toStringAsFixed(2), 'sq ft')),
          ),
          SuggestionData(
            label: 'Area:',
            value: (areaSqFt / 9.0).toStringAsFixed(2),
            unit: 'sq yd',
            onTap: () => add(SuggestionChipTapped(
                'Area:', (areaSqFt / 9.0).toStringAsFixed(2), 'sq yd')),
          ),
        ];
      }

      emit(newState.copyWith(
        conversionSuggestions: conv,
        aiSuggestions: ai,
      ));
    }
  }
}
