part of 'geometry_area_bloc.dart';

sealed class GeometryAreaEvent extends Equatable {
  const GeometryAreaEvent();

  @override
  List<Object?> get props => [];
}

// ── Sizes-table CRUD ───────────────────────────────────────────────────────

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

// ── Calculator keyboard flow ───────────────────────────────────────────────

/// Fired when the user taps a function key (e.g. "Length", "Width").
class GeometryKeySelected extends GeometryAreaEvent {
  final String label;

  const GeometryKeySelected(this.label);

  @override
  List<Object?> get props => [label];
}

/// Fired when the user taps a numeric digit or decimal point.
class GeometryDigitPressed extends GeometryAreaEvent {
  final String digit;

  const GeometryDigitPressed(this.digit);

  @override
  List<Object?> get props => [digit];
}

/// Fired when the user selects a unit (e.g. "ft", "in").
class GeometryUnitSelected extends GeometryAreaEvent {
  final String unit;

  const GeometryUnitSelected(this.unit);

  @override
  List<Object?> get props => [unit];
}

/// Fired when the user presses an operator (e.g. "=").
class GeometryOperatorPressed extends GeometryAreaEvent {
  final String operator;

  const GeometryOperatorPressed(this.operator);

  @override
  List<Object?> get props => [operator];
}

/// Fired when the user requests a full reset (AC / close).
class GeometryResetRequested extends GeometryAreaEvent {
  const GeometryResetRequested();
}

/// Fired when the user taps on an AI or conversion suggestion chip.
class GeometrySuggestionChipTapped extends GeometryAreaEvent {
  final String label;
  final String value;
  final String? unit;

  const GeometrySuggestionChipTapped(this.label, this.value, this.unit);

  @override
  List<Object?> get props => [label, value, unit];
}
