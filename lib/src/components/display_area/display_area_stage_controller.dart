import 'package:flutter/services.dart';

import 'display_area_stage.dart';

/// Encapsulates the logic for stage transitions in [CoreDisplayArea].
class DisplayAreaStageController {
  /// Returns the next stage when swiping down.
  ///
  /// Triggers haptic feedback if a transition occurs.
  DisplayAreaStage nextStage(
    DisplayAreaStage current, {
    required bool exceedsTwoRows,
  }) {
    switch (current) {
      case DisplayAreaStage.collapsed:
        final next = exceedsTwoRows
            ? DisplayAreaStage.expandedCurrent
            : DisplayAreaStage.expandedPrevious;
        HapticFeedback.mediumImpact();
        return next;

      case DisplayAreaStage.expandedCurrent:
        HapticFeedback.mediumImpact();
        return DisplayAreaStage.expandedPrevious;

      case DisplayAreaStage.expandedPrevious:
        return DisplayAreaStage.fullScreen;

      case DisplayAreaStage.fullScreen:
        return current;
    }
  }

  /// Returns the next stage when swiping up.
  ///
  /// Triggers haptic feedback if a transition occurs.
  DisplayAreaStage previousStage(
    DisplayAreaStage current, {
    required bool exceedsTwoRows,
  }) {
    switch (current) {
      case DisplayAreaStage.fullScreen:
        HapticFeedback.lightImpact();
        return DisplayAreaStage.expandedPrevious;

      case DisplayAreaStage.expandedPrevious:
        if (exceedsTwoRows) {
          HapticFeedback.lightImpact();
          return DisplayAreaStage.expandedCurrent;
        } else {
          return DisplayAreaStage.collapsed;
        }

      case DisplayAreaStage.expandedCurrent:
        return DisplayAreaStage.collapsed;

      case DisplayAreaStage.collapsed:
        return current;
    }
  }
}
