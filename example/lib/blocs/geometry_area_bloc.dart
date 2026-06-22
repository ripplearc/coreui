import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'geometry_area_event.dart';

part 'geometry_area_state.dart';

/// BLoC for the Geometry Area showcase screen.
///
/// Handles the full calculator flow:
///   1. User taps a key (e.g. "Length") → [GeometryKeySelected]
///   2. User types digits              → [GeometryDigitPressed]
///   3. User selects a unit            → [GeometryUnitSelected]
///   4. Repeat for "Width"
///   5. After both are entered the bloc automatically computes circle
///      dimensions (Area, Radius, Diameter, Circumference) and surfaces
///      them as [SuggestionData] in [GeometryAreaState.aiSuggestions].
///
/// It also manages the sizes table via [SizeSaved], [SizeDeleted], and
/// [SizesReordered].
class GeometryAreaBloc extends Bloc<GeometryAreaEvent, GeometryAreaState> {
  static final RegExp _unitRegExp = RegExp(r'^([\d.]+)\s*([a-zA-Z]+)$');

  int _nextId = 4;

  GeometryAreaBloc()
      : super(const GeometryAreaState(
          sizesTableData: [
            CoreSizeCardData(id: 'row1', values: ['8ft', '8ft']),
            CoreSizeCardData(id: 'row2', values: ['6ft', '6ft']),
            CoreSizeCardData(id: 'row3', values: ['10ft', '10ft']),
          ],
        )) {
    on<SizeSaved>(_onSizeSaved);
    on<SizeDeleted>(_onSizeDeleted);
    on<SizesReordered>(_onSizesReordered);
    on<GeometryKeySelected>(_onKeySelected);
    on<GeometryDigitPressed>(_onDigitPressed);
    on<GeometryUnitSelected>(_onUnitSelected);
    on<GeometryOperatorPressed>(_onOperatorPressed);
    on<GeometryResetRequested>(_onResetRequested);
    on<GeometrySuggestionChipTapped>(_onSuggestionChipTapped);
    on<GeometryDeletePressed>(_onDeletePressed);
  }

  // ── Sizes-table CRUD ────────────────────────────────────────────────────

  void _onSizeSaved(SizeSaved event, Emitter<GeometryAreaState> emit) {
    final updatedList = List<CoreSizeCardData>.from(state.sizesTableData);

    if (event.result.intent == SizeOperationIntent.add) {
      final newId = 'row${_nextId++}';
      updatedList.add(CoreSizeCardData(id: newId, values: event.result.values));
    } else if (event.result.intent == SizeOperationIntent.edit) {
      final targetIndex = event.result.index;
      if (targetIndex != null && targetIndex < updatedList.length) {
        final existingItem = updatedList[targetIndex];
        updatedList[targetIndex] = CoreSizeCardData(
          id: existingItem.id,
          values: event.result.values,
        );
      }
    }

    emit(state.copyWith(sizesTableData: updatedList));
  }

  void _onSizeDeleted(SizeDeleted event, Emitter<GeometryAreaState> emit) {
    final updatedList = List<CoreSizeCardData>.from(state.sizesTableData)
      ..removeWhere((item) => item.id == event.id);
    emit(state.copyWith(sizesTableData: updatedList));
  }

  void _onSizesReordered(
      SizesReordered event, Emitter<GeometryAreaState> emit) {
    final updatedList = List<CoreSizeCardData>.from(state.sizesTableData);
    final item = updatedList.removeAt(event.oldIndex);
    updatedList.insert(event.newIndex, item);
    emit(state.copyWith(sizesTableData: updatedList));
  }

  // ── Keyboard flow ────────────────────────────────────────────────────────

  void _onSuggestionChipTapped(
      GeometrySuggestionChipTapped event, Emitter<GeometryAreaState> emit) {
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
  }

  void _onKeySelected(
      GeometryKeySelected event, Emitter<GeometryAreaState> emit) {
    final finalizedState = _finalizeCurrentInput(state);
    final newState = finalizedState.copyWith(
      activeInputLabel: () => event.label,
      currentInputValue: '',
      currentNumericValue: '',
      isTyping: true,
      aiSuggestions: [],
      conversionSuggestions: [],
      dimensions: [],
    );
    _updateSuggestions(newState, emit);
  }

  void _onDigitPressed(
      GeometryDigitPressed event, Emitter<GeometryAreaState> emit) {
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
      GeometryUnitSelected event, Emitter<GeometryAreaState> emit) {
    if (!state.isTyping) return;
    final unit = event.unit.toLowerCase() == 'feet' ? 'ft' : event.unit;
    final newValue = state.currentInputValue.isEmpty
        ? unit
        : '${state.currentInputValue} $unit';
    final newState = state.copyWith(currentInputValue: newValue);
    _updateSuggestions(newState, emit);
  }

  void _onOperatorPressed(
      GeometryOperatorPressed event, Emitter<GeometryAreaState> emit) {
    if (event.operator == '=') {
      final newState = _finalizeCurrentInput(state);
      _updateSuggestions(newState, emit);
    }
  }

  void _onDeletePressed(
      GeometryDeletePressed event, Emitter<GeometryAreaState> emit) {
    if (!state.isTyping || state.currentInputValue.isEmpty) return;

    final unitMatch = _unitRegExp.firstMatch(state.currentInputValue);
    if (unitMatch != null) {
      _updateSuggestions(
        state.copyWith(currentInputValue: unitMatch.group(1) ?? ''),
        emit,
      );
      return;
    }

    final newValue = state.currentInputValue
        .substring(0, state.currentInputValue.length - 1);
    final newNumericValue = state.currentNumericValue.isEmpty
        ? ''
        : state.currentNumericValue
            .substring(0, state.currentNumericValue.length - 1);
    _updateSuggestions(
      state.copyWith(
        currentInputValue: newValue,
        currentNumericValue: newNumericValue,
      ),
      emit,
    );
  }

  void _onResetRequested(
      GeometryResetRequested event, Emitter<GeometryAreaState> emit) {
    emit(GeometryAreaState(sizesTableData: state.sizesTableData));
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  GeometryAreaState _finalizeCurrentInput(GeometryAreaState currentState) {
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

  void _updateSuggestions(
      GeometryAreaState newState, Emitter<GeometryAreaState> emit) {
    if (!newState.isTyping || newState.activeInputLabel == null) {
      emit(newState);
      return;
    }

    List<SuggestionData> conv = _generateUnitConversions(newState);
    final circleResult = _generateCircleSuggestions(newState);

    if (circleResult != null) {
      emit(newState.copyWith(
        conversionSuggestions: conv,
        aiSuggestions: circleResult.aiSuggestions,
        dimensions: circleResult.dimensions,
      ));
      return;
    }

    emit(newState.copyWith(
      conversionSuggestions: conv,
      aiSuggestions: newState.aiSuggestions,
    ));
  }

  List<SuggestionData> _generateUnitConversions(GeometryAreaState state) {
    final unitMatch = _unitRegExp.firstMatch(state.currentInputValue);
    if (unitMatch == null) return List.from(state.conversionSuggestions);

    final numberStr = unitMatch.group(1);
    final unitStr = unitMatch.group(2);

    if (numberStr != null && unitStr != null) {
      final number = double.tryParse(numberStr);
      if (number != null && unitStr.toLowerCase() == 'ft') {
        final convIn = number * 12;
        final convYd = number / 3;
        return [
          SuggestionData(
            label: 'Conv:',
            value: convIn.toStringAsFixed(0),
            unit: 'in',
            onTap: () => add(GeometrySuggestionChipTapped(
                'Conv:', convIn.toStringAsFixed(0), 'in')),
          ),
          SuggestionData(
            label: 'Conv:',
            value: convYd.toStringAsFixed(2),
            unit: 'yd',
            onTap: () => add(GeometrySuggestionChipTapped(
                'Conv:', convYd.toStringAsFixed(2), 'yd')),
          ),
        ];
      }
    }
    return List.from(state.conversionSuggestions);
  }

  _CircleSuggestionResult? _generateCircleSuggestions(GeometryAreaState state) {
    final lengthVal = state.finalizedValues['Length'];
    final widthVal = state.finalizedValues['Width'];
    final isTypingWidthWithUnit = state.isTyping &&
        state.activeInputLabel == 'Width' &&
        _unitRegExp.hasMatch(state.currentInputValue);

    if (lengthVal == null || (widthVal == null && !isTypingWidthWithUnit)) {
      return null;
    }

    double currentWidth = widthVal ?? 0.0;
    if (isTypingWidthWithUnit) {
      final m = _unitRegExp.firstMatch(state.currentInputValue);
      if (m != null) {
        final widthStr = m.group(1);
        if (widthStr != null) {
          currentWidth = double.tryParse(widthStr) ?? 0.0;
        }
      }
    }

    final diameter = (lengthVal + currentWidth) / 2;
    final radius = diameter / 2;
    final area = math.pi * radius * radius;
    final circumference = math.pi * diameter;

    final ai = [
      SuggestionData(
        label: 'Area:',
        value: area.toStringAsFixed(2),
        unit: 'ft²',
        onTap: () => add(GeometrySuggestionChipTapped(
            'Area:', area.toStringAsFixed(2), 'ft²')),
      ),
      SuggestionData(
        label: 'Radius:',
        value: radius.toStringAsFixed(2),
        unit: 'ft',
        onTap: () => add(GeometrySuggestionChipTapped(
            'Radius:', radius.toStringAsFixed(2), 'ft')),
      ),
      SuggestionData(
        label: 'Diameter:',
        value: diameter.toStringAsFixed(0),
        unit: 'ft',
        onTap: () => add(GeometrySuggestionChipTapped(
            'Diameter:', diameter.toStringAsFixed(0), 'ft')),
      ),
      SuggestionData(
        label: 'Circumference:',
        value: circumference.toStringAsFixed(2),
        unit: 'ft',
        onTap: () => add(GeometrySuggestionChipTapped(
            'Circumference:', circumference.toStringAsFixed(2), 'ft')),
      ),
    ];

    final newDimensions = [
      CoreDimensionData(label: 'Area', value: '${area.toStringAsFixed(2)}ft²'),
      CoreDimensionData(
          label: 'Diameter', value: '${diameter.toStringAsFixed(0)}ft'),
      CoreDimensionData(
          label: 'Radius', value: '${radius.toStringAsFixed(2)}ft'),
      CoreDimensionData(
          label: 'Circumference',
          value: '${circumference.toStringAsFixed(2)}ft'),
    ];

    return _CircleSuggestionResult(
        aiSuggestions: ai, dimensions: newDimensions);
  }
}

class _CircleSuggestionResult {
  final List<SuggestionData> aiSuggestions;
  final List<CoreDimensionData> dimensions;

  _CircleSuggestionResult({
    required this.aiSuggestions,
    required this.dimensions,
  });
}
