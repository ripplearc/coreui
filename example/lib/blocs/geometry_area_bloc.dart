import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

part 'geometry_area_event.dart';
part 'geometry_area_state.dart';

class GeometryAreaBloc extends Bloc<GeometryAreaEvent, GeometryAreaState> {
  int _nextId = 4;

  GeometryAreaBloc()
      : super(const GeometryAreaState(
          sizesTableData: [
            CoreSizeCardData(
                id: 'row1', values: ['3', '8ft', '4', '8', '16', '32']),
            CoreSizeCardData(
                id: 'row2', values: ['3', '8ft', '4', '8', '16', '32']),
            CoreSizeCardData(
                id: 'row3', values: ['3', '8ft', '4', '8', '16', '32']),
          ],
        )) {
    on<SizeSaved>(_onSizeSaved);
    on<SizeDeleted>(_onSizeDeleted);
    on<SizesReordered>(_onSizesReordered);
  }

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
}
