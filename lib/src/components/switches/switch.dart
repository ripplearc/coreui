import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// Defines the type and behavior of the switch component.
/// - [normal]: Standard switch with grey colors (width: 71px with labels, 32px compact).
/// - [lock]: Security-focused switch with red colors for lock/unlock states (width: 71px).
/// - [imperial]: Unit system switch with green colors for imperial/metric toggle (width: 77px).
enum CoreSwitchType {
  normal,
  lock,
  imperial,
}

/// Internal constants for switch component dimensions and sizing.
/// These values define the visual appearance and behavior of different switch types.
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

/// A customizable switch widget that supports different types, labels, and colors.
///
/// The CoreSwitch provides three distinct types:
/// - Normal: Standard toggle switch with grey styling
/// - Lock: Security switch with red styling for lock/unlock states
/// - Imperial: Unit system switch with green styling for imperial/metric toggle
///
/// ## Basic Usage
///
/// ```dart
/// // Simple switch without labels
/// CoreSwitch(
///   value: isEnabled,
///   onChanged: (value) => setState(() => isEnabled = value),
/// )
/// ```
///
/// ## Switch with Labels
///
/// ```dart
/// // Normal switch with custom labels
/// CoreSwitch(
///   type: CoreSwitchType.normal,
///   value: isPrivate,
///   onChanged: (value) => setState(() => isPrivate = value),
///   activeLabel: 'Public',
///   inactiveLabel: 'Private',
/// )
/// ```
///
/// ## Lock Switch
///
/// ```dart
/// // Security lock switch
/// CoreSwitch(
///   type: CoreSwitchType.lock,
///   value: isLocked,
///   onChanged: (value) => setState(() => isLocked = value),
///   activeLabel: 'Lock',
///   inactiveLabel: 'Unlock',
/// )
/// ```
///
/// ## Imperial Switch
///
/// ```dart
/// // Unit system toggle
/// CoreSwitch(
///   type: CoreSwitchType.imperial,
///   value: useImperial,
///   onChanged: (value) => setState(() => useImperial = value),
///   activeLabel: 'Metric',
///   inactiveLabel: 'Imperial',
/// )
/// ```
///
/// ## Custom Colors
///
/// ```dart
/// // Switch with custom inactive color
/// CoreSwitch(
///   value: isCustom,
///   onChanged: (value) => setState(() => isCustom = value),
///   inactiveColor: Colors.purple,
/// )
/// ```
///
/// [value] is the current state of the switch (true = active/on, false = inactive/off).
/// [onChanged] is the callback function when the switch is toggled.
/// [type] determines the switch's visual style and default colors.
/// [activeLabel] is the text displayed when the switch is in the active state.
/// [inactiveLabel] is the text displayed when the switch is in the inactive state.
/// [inactiveColor] overrides the default inactive color for the switch type.
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

  /// Returns true if the switch has any labels (active or inactive).
  bool get _hasLabels =>
      (activeLabel?.isNotEmpty ?? false) ||
      (inactiveLabel?.isNotEmpty ?? false);

  Color _getInactiveBorderColor(AppColorsExtension colors) {
    return inactiveColor ??
        (switch (type) {
          CoreSwitchType.lock => colors.iconRed,
          CoreSwitchType.imperial => colors.iconGreen,
          CoreSwitchType.normal => colors.lineDarkOutline,
        });
  }

  Color _getInactiveTextColor(AppColorsExtension colors) {
    return inactiveColor ??
        (switch (type) {
          CoreSwitchType.lock => colors.textError,
          CoreSwitchType.imperial => colors.textSuccess,
          CoreSwitchType.normal => colors.textBody,
        });
  }

  Color _getBorderColor(AppColorsExtension colors) {
    return inactiveColor ??
        (switch (type) {
          CoreSwitchType.lock => colors.iconRed,
          CoreSwitchType.imperial => colors.iconGreen,
          CoreSwitchType.normal => colors.iconGrayMid,
        });
  }

  /// Gets the switch width based on type and label presence.
  /// Returns 32px for compact (no labels), 71px for normal/lock, 77px for imperial.
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

  /// Gets the switch height based on label presence.
  /// Returns 24px for labeled switches, 18px for compact switches.
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

    final colors = Theme.of(context).coreColors;

    final Color effectiveActiveColor = colors.iconDark;
    final Color effectiveInactiveBorderColor = _getInactiveBorderColor(colors);
    final Color effectiveInactiveTextColor = _getInactiveTextColor(colors);

    // Background and border colors based on state
    final typography = Theme.of(context).coreTypography;
    final backgroundColor =
        value ? effectiveActiveColor : colors.backgroundGrayLight;
    final borderColor = value ? effectiveActiveColor : _getBorderColor(colors);

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
                      style: typography.bodySmallRegular.copyWith(
                        color: value
                            ? colors.textInverse
                            : effectiveInactiveTextColor,
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
                  color: value
                      ? colors.textInverse
                      : effectiveInactiveBorderColor,
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
