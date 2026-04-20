import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'display_area_expansion_event.dart';
import 'display_area_expansion_state.dart';

/// Controls the swipe-driven multi-stage expansion of [CoreDisplayArea].
///
/// **Two-stage interaction** (chips fit within two rows):
/// `collapsed` → `expandedPrevious` → `fullScreen`
///
/// **Three-stage interaction** (chips exceed two rows):
/// `collapsed` → `expandedCurrent` → `expandedPrevious` → `fullScreen`
///
/// Haptic feedback is emitted on the first and second forward swipes.
class DisplayAreaExpansionBloc
    extends Bloc<DisplayAreaExpansionEvent, DisplayAreaExpansionState> {
  DisplayAreaExpansionBloc() : super(const DisplayAreaExpansionState()) {
    on<SwipeDownEvent>(_onSwipeDown);
    on<SwipeUpEvent>(_onSwipeUp);
    on<CollapseEvent>(_onCollapse);
  }

  void _onSwipeDown(
      SwipeDownEvent event, Emitter<DisplayAreaExpansionState> emit) {
    switch (state.stage) {
      case DisplayAreaStage.collapsed:
        final next = event.exceedsTwoRows
            ? DisplayAreaStage.expandedCurrent
            : DisplayAreaStage.expandedPrevious;
        emit(state.copyWith(stage: next));
        HapticFeedback.mediumImpact();
        break;

      case DisplayAreaStage.expandedCurrent:
        emit(state.copyWith(stage: DisplayAreaStage.expandedPrevious));
        HapticFeedback.mediumImpact();
        break;

      case DisplayAreaStage.expandedPrevious:
        emit(state.copyWith(stage: DisplayAreaStage.fullScreen));
        break;

      case DisplayAreaStage.fullScreen:
        break;
    }
  }

  void _onSwipeUp(SwipeUpEvent event, Emitter<DisplayAreaExpansionState> emit) {
    switch (state.stage) {
      case DisplayAreaStage.fullScreen:
        emit(state.copyWith(stage: DisplayAreaStage.expandedPrevious));
        HapticFeedback.lightImpact();
        break;
      case DisplayAreaStage.expandedPrevious:
        if (event.exceedsTwoRows) {
          emit(state.copyWith(stage: DisplayAreaStage.expandedCurrent));
          HapticFeedback.lightImpact();
        } else {
          emit(const DisplayAreaExpansionState());
        }
        break;
      case DisplayAreaStage.expandedCurrent:
        emit(const DisplayAreaExpansionState());
        break;
      case DisplayAreaStage.collapsed:
        break;
    }
  }

  void _onCollapse(
      CollapseEvent event, Emitter<DisplayAreaExpansionState> emit) {
    emit(const DisplayAreaExpansionState());
  }
}
