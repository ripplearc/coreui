part of 'geometry_area_bloc.dart';

class GeometryAreaState extends Equatable {
  final List<CoreSizeCardData> sizesTableData;

  const GeometryAreaState({
    this.sizesTableData = const [],
  });

  GeometryAreaState copyWith({
    List<CoreSizeCardData>? sizesTableData,
  }) {
    return GeometryAreaState(
      sizesTableData: sizesTableData ?? this.sizesTableData,
    );
  }

  @override
  List<Object?> get props => [sizesTableData];
}
