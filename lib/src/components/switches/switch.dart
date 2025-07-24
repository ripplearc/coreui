import 'package:flutter/material.dart';

import '../../../core_ui.dart';

enum CoreSwitchType {
  normal,
  lock,
  imperial,
}

// Switch component constants
class _SwitchConstants {
  static const double widthNormal = 71.0; // Normal and lock switch width
  static const double widthImperial = 77.0; // Imperial switch width
  static const double widthCompact = 32.0; // Compact switch width (no labels)
  static const double heightLabeled = 24.0; // Labeled switch height
  static const double heightCompact = 18.0; // Compact switch height
  static const double thumbSizeLargeActive = 18.0; // Large thumb when active
  static const double thumbSizeLargeInactive =
      14.0; // Large thumb when inactive
  static const double thumbSizeSmallActive = 14.0; // Small thumb when active
  static const double thumbSizeSmallInactive =
      10.0; // Small thumb when inactive
  static const double thumbPaddingLargeActive =
      3.0; // Large thumb padding when active
  static const double thumbPaddingLargeInactive =
      5.0; // Large thumb padding when inactive
  static const double thumbPaddingSmallActive =
      2.0; // Small thumb padding when active
  static const double thumbPaddingSmallInactive =
      4.0; // Small thumb padding when inactive
}

class CoreSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final CoreSwitchType type;

  final String? activeLabel;
  final String? inactiveLabel;

  final Color? inactiveColor;

  const CoreSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.type = CoreSwitchType.normal,
    this.activeLabel,
    this.inactiveLabel,
    this.inactiveColor,
  });

  bool get _hasLabels =>
      (activeLabel?.isNotEmpty ?? false) ||
      (inactiveLabel?.isNotEmpty ?? false);

  Color get _getInactiveColor {
    if (inactiveColor != null) return inactiveColor!;
    switch (type) {
      case CoreSwitchType.lock:
        return CoreIconColors.red;
      case CoreSwitchType.imperial:
        return CoreTextColors.success;
      case CoreSwitchType.normal:
        return CoreBorderColors.lineDarkOutline;
    }
  }

  Color get _getBorderColor {
    if (inactiveColor != null) return inactiveColor!;
    switch (type) {
      case CoreSwitchType.lock:
        return CoreIconColors.red;
      case CoreSwitchType.imperial:
        return CoreIconColors.green;
      case CoreSwitchType.normal:
        return CoreIconColors.grayMid;
    }
  }

  // Get dimensions based on switch type
  double get _getSwitchWidth {
    if (!_hasLabels) return _SwitchConstants.widthCompact;
    switch (type) {
      case CoreSwitchType.lock:
      case CoreSwitchType.normal:
        return _SwitchConstants.widthNormal;
      case CoreSwitchType.imperial:
        return _SwitchConstants.widthImperial;
    }
  }

  double get _getSwitchHeight {
    return _hasLabels
        ? _SwitchConstants.heightLabeled
        : _SwitchConstants.heightCompact;
  }

  @override
  Widget build(BuildContext context) {
    final double switchHeight = _getSwitchHeight;
    final double switchWidth = _getSwitchWidth;
    final double thumbSize = _hasLabels
        ? value
            ? _SwitchConstants.thumbSizeLargeActive
            : _SwitchConstants.thumbSizeLargeInactive
        : value
            ? _SwitchConstants.thumbSizeSmallActive
            : _SwitchConstants.thumbSizeSmallInactive;
    final double thumbPadding = _hasLabels
        ? value
            ? _SwitchConstants.thumbPaddingLargeActive
            : _SwitchConstants.thumbPaddingLargeInactive
        : value
            ? _SwitchConstants.thumbPaddingSmallActive
            : _SwitchConstants.thumbPaddingSmallInactive;

    final Color effectiveActiveColor = CoreIconColors.dark;
    final Color effectiveInactiveColor = _getInactiveColor;

    // Background and border colors based on state
    final backgroundColor =
        value ? effectiveActiveColor : CoreBackgroundColors.backgroundGrayLight;
    final borderColor = value ? effectiveActiveColor : _getBorderColor;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: switchHeight,
        width: switchWidth,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: value ? null : Border.all(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(CoreSpacing.space6),
        ),
        child: Stack(
          children: [
            // Label text (if present)
            if (_hasLabels)
              Positioned(
                  right: value ? thumbSize + thumbPadding * 1.4 : thumbPadding,
                  left: value ? thumbPadding : thumbSize + thumbPadding * 1.4,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Text(
                      value ? (activeLabel ?? '') : (inactiveLabel ?? ''),
                      style: CoreTypography.bodySmallRegular(
                        color: value
                            ? CoreTextColors.inverse
                            : effectiveInactiveColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )),

            // Animated thumb
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left:
                  value ? switchWidth - thumbSize - thumbPadding : thumbPadding,
              top: 0,
              bottom: 0,
              child: Container(
                width: thumbSize,
                decoration: BoxDecoration(
                  color:
                      value ? CoreTextColors.inverse : effectiveInactiveColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
