import 'package:flutter/foundation.dart';

/// The expansion stage of [CoreDisplayArea].
///
/// Controls which sections are visible, whether the close icon is shown,
/// and whether the history panel is scrollable.
enum DisplayAreaStage {
  /// Collapsed: history chips are capped at two rows, close icon is visible.
  collapsed,

  /// First expanded stage — only reached when chips exceed two rows.
  ///
  /// All current-session chips are revealed; close icon remains visible.
  expandedCurrent,

  /// Previous-session chips are revealed with a distinct background colour.
  ///
  /// The close icon and its reserved layout space are removed at this stage.
  expandedPrevious,

  /// Full-screen scrollable history view.
  ///
  /// Both current and previous chips are presented in a unified scrollable
  /// panel. The close icon is hidden.
  fullScreen,
}

/// Immutable state for [DisplayAreaExpansionBloc].
@immutable
final class DisplayAreaExpansionState {
  const DisplayAreaExpansionState({
    this.stage = DisplayAreaStage.collapsed,
  });

  /// The current expansion stage.
  final DisplayAreaStage stage;

  /// Returns a copy with [stage] replaced.
  DisplayAreaExpansionState copyWith({DisplayAreaStage? stage}) =>
      DisplayAreaExpansionState(stage: stage ?? this.stage);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DisplayAreaExpansionState &&
          runtimeType == other.runtimeType &&
          stage == other.stage;

  @override
  int get hashCode => stage.hashCode;

  @override
  String toString() => 'DisplayAreaExpansionState(stage: $stage)';
}
