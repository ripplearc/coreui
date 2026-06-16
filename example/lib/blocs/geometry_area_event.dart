part of 'geometry_area_bloc.dart';

sealed class GeometryAreaEvent extends Equatable {
  const GeometryAreaEvent();

  @override
  List<Object?> get props => [];
}

class SizeSaved extends GeometryAreaEvent {
  final SizeEntryResult result;

  const SizeSaved(this.result);

  @override
  List<Object?> get props => [result];
}

class SizeDeleted extends GeometryAreaEvent {
  final String id;

  const SizeDeleted(this.id);

  @override
  List<Object?> get props => [id];
}

class SizesReordered extends GeometryAreaEvent {
  final int oldIndex;
  final int newIndex;

  const SizesReordered(this.oldIndex, this.newIndex);

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
