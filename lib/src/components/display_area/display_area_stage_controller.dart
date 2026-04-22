import 'display_area_stage.dart';

/// Encapsulates the logic for stage transitions in [CoreDisplayArea].
class DisplayAreaStageController {
  const DisplayAreaStageController._();

  /// Returns the next stage when swiping down.
  static DisplayAreaStage next(
    DisplayAreaStage current, {
    required bool exceedsTwoRows,
  }) {
    switch (current) {
      case DisplayAreaStage.collapsed:
        return exceedsTwoRows
            ? DisplayAreaStage.expandedCurrent
            : DisplayAreaStage.expandedPrevious;

      case DisplayAreaStage.expandedCurrent:
        return DisplayAreaStage.expandedPrevious;

      case DisplayAreaStage.expandedPrevious:
        return DisplayAreaStage.fullScreen;

      case DisplayAreaStage.fullScreen:
        return current;
    }
  }

  /// Returns the next stage when swiping up.
  static DisplayAreaStage previous(
    DisplayAreaStage current, {
    required bool exceedsTwoRows,
  }) {
    switch (current) {
      case DisplayAreaStage.fullScreen:
        return DisplayAreaStage.expandedPrevious;

      case DisplayAreaStage.expandedPrevious:
        if (exceedsTwoRows) {
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
