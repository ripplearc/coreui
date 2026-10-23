import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// Defines the type and behavior of the switch component.
/// - [normal]: Standard switch with grey colors (width: 71px with labels, 32px compact).
/// - [lock]: Security-focused switch with red colors for lock/unlock states (width: 71px).
/// - [imperial]: Unit system switch with green colors for imperial/metric toggle (width: 77px).
/// - [showHide]: Visibility switch labelled "Hide" / "Show" (72 x 32px).
enum CoreSwitchType {
  /// Standard switch with grey colors.
  normal,

  /// Security-focused switch with red colors for lock/unlock states.
  lock,

  /// Unit system switch with green colors for imperial/metric toggle.
  imperial,

  /// Visibility switch: a light "Hide" track when off, a filled "Show" track
  /// when on. The label always names the current state.
  showHide,
}

/// Internal constants for switch component dimensions and sizing.
/// These values define the visual appearance and behavior of different switch types.
class _SwitchConstants {
  static const double widthNormal = 71.0; // Normal and lock switch width
  static const double widthImperial = 77.0; // Imperial switch width
  static const double widthCompact = 32.0; // Compact switch width (no labels)
  static const double heightLabeled = 24.0; // Labeled switch height
  static const double heightCompact = 18.0; // Compact switch height
  static const double widthShowHide = 72.0; // Show Hide switch width
  static const double heightShowHide = 32.0; // Show Hide switch height
  static const double thumbSizeShowHide = 14.0; // Show Hide thumb, both states
  static const double thumbPaddingShowHide = 9.0; // Show Hide thumb padding
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
/// The CoreSwitch provides four distinct types:
/// - Normal: Standard toggle switch with grey styling
/// - Lock: Security switch with red styling for lock/unlock states
/// - Imperial: Unit system switch with green styling for imperial/metric toggle
/// - Show Hide: Visibility switch, "Hide" on a light track and "Show" on a
///   filled track
///
/// Tab reaches the switch and Enter or Space toggles it. Keyboard focus draws
/// a 2 px `outlineFocus` ring just outside the track.
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
/// ## Show Hide Switch
///
/// ```dart
/// // Labels default to "Hide" (off) and "Show" (on)
/// CoreSwitch(
///   type: CoreSwitchType.showHide,
///   value: isShown,
///   onChanged: (value) => setState(() => isShown = value),
/// )
/// ```
///
/// ## Disabled Switch
///
/// Pass a null [onChanged] to disable the switch. It ignores taps, is read
/// as disabled by screen readers and draws the same disabled colours for
/// every type. The thumb keeps the side and size of its On or Off state.
///
/// ```dart
/// CoreSwitch(
///   type: CoreSwitchType.showHide,
///   value: false,
///   onChanged: null,
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
/// [onChanged] is the callback function when the switch is toggled. Null
/// disables the switch.
/// [type] determines the switch's visual style and default colors.
/// [activeLabel] is the text displayed when the switch is in the active state.
/// [inactiveLabel] is the text displayed when the switch is in the inactive state.
/// [inactiveColor] overrides the default inactive color for the switch type.
/// The Show Hide defaults ("Hide" and "Show") are English; pass localized
/// [activeLabel] and [inactiveLabel] in a localized app.
/// [semanticLabel] is the name a screen reader reads; without it a labelled
/// switch reads its current label and a compact switch has no name.
class CoreSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final CoreSwitchType type;

  final String? activeLabel;
  final String? inactiveLabel;

  final Color? inactiveColor;
  final String? semanticLabel;

  const CoreSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.type = CoreSwitchType.normal,
    this.activeLabel,
    this.inactiveLabel,
    this.inactiveColor,
    this.semanticLabel,
  });

  bool get _isEnabled => onChanged != null;

  bool get _isShowHide => type == CoreSwitchType.showHide;

  String? get _activeLabel =>
      activeLabel ?? (_isShowHide ? 'Show' : null);

  String? get _inactiveLabel =>
      inactiveLabel ?? (_isShowHide ? 'Hide' : null);

  /// Returns true if the switch has any labels (active or inactive).
  bool get _hasLabels =>
      (_activeLabel?.isNotEmpty ?? false) ||
      (_inactiveLabel?.isNotEmpty ?? false);

  Color _getInactiveThumbColor(AppColorsExtension colors) {
    return inactiveColor ??
        (switch (type) {
          CoreSwitchType.lock => colors.statusError,
          CoreSwitchType.imperial => colors.iconGreen,
          CoreSwitchType.normal => colors.iconGrayMid,
          CoreSwitchType.showHide => colors.iconGrayLight,
        });
  }

  Color _getInactiveTextColor(AppColorsExtension colors) {
    return inactiveColor ??
        (switch (type) {
          CoreSwitchType.lock => colors.textError,
          CoreSwitchType.imperial => colors.textSuccess,
          CoreSwitchType.normal => colors.textBody,
          CoreSwitchType.showHide => colors.textDark,
        });
  }

  Color _getBorderColor(AppColorsExtension colors) {
    return inactiveColor ??
        (switch (type) {
          CoreSwitchType.lock => colors.iconRed,
          CoreSwitchType.imperial => colors.iconGreen,
          CoreSwitchType.normal => colors.iconGrayMid,
          CoreSwitchType.showHide => colors.lineMid,
        });
  }

  /// Gets the switch width based on type and label presence.
  /// Returns 32px for compact (no labels), 71px for normal/lock, 77px for imperial.
  double get _getSwitchWidth {
    if (!_hasLabels && !_isShowHide) return _SwitchConstants.widthCompact;
    switch (type) {
      case CoreSwitchType.lock:
      case CoreSwitchType.normal:
        return _SwitchConstants.widthNormal;
      case CoreSwitchType.imperial:
        return _SwitchConstants.widthImperial;
      case CoreSwitchType.showHide:
        return _SwitchConstants.widthShowHide;
    }
  }

  /// Gets the switch height based on label presence.
  /// Returns 24px for labeled switches, 18px for compact switches.
  double get _getSwitchHeight {
    if (_isShowHide) return _SwitchConstants.heightShowHide;
    return _hasLabels
        ? _SwitchConstants.heightLabeled
        : _SwitchConstants.heightCompact;
  }

  @override
  Widget build(BuildContext context) {
    final double switchHeight = _getSwitchHeight;
    final double switchWidth = _getSwitchWidth;
    final double thumbSize = _isShowHide
        ? _SwitchConstants.thumbSizeShowHide
        : _hasLabels
        ? value
            ? _SwitchConstants.thumbSizeLargeActive
            : _SwitchConstants.thumbSizeLargeInactive
        : value
            ? _SwitchConstants.thumbSizeSmallActive
            : _SwitchConstants.thumbSizeSmallInactive;
    final double thumbPadding = _isShowHide
        ? _SwitchConstants.thumbPaddingShowHide
        : _hasLabels
        ? value
            ? _SwitchConstants.thumbPaddingLargeActive
            : _SwitchConstants.thumbPaddingLargeInactive
        : value
            ? _SwitchConstants.thumbPaddingSmallActive
            : _SwitchConstants.thumbPaddingSmallInactive;

    final colors = Theme.of(context).coreColors;

    final Color effectiveActiveColor =
        _isShowHide ? colors.buttonSurface : colors.iconDark;
    final Color effectiveInactiveThumbColor = _getInactiveThumbColor(colors);
    final Color effectiveInactiveTextColor = _getInactiveTextColor(colors);

    // Background and border colors based on state. A disabled switch uses one
    // set of colours for every type and keeps its border in both states.
    final typography = Theme.of(context).coreTypography;
    final labelStyle = _isShowHide
        ? typography.bodySmallSemiBold
        : typography.bodySmallRegular;
    final Color backgroundColor = !_isEnabled
        ? colors.pageBackground
        : value
            ? effectiveActiveColor
            : colors.backgroundGrayLight;
    final Color borderColor = !_isEnabled
        ? colors.lineMid
        : value
            ? effectiveActiveColor
            : _getBorderColor(colors);
    final bool showBorder = !_isEnabled || !value;
    final Color labelColor = !_isEnabled
        ? colors.textDisable
        : value
            ? colors.textInverse
            : effectiveInactiveTextColor;
    final Color thumbColor = !_isEnabled
        ? colors.iconGrayLight
        : value
            ? (_isShowHide ? colors.iconWhite : colors.textInverse)
            : effectiveInactiveThumbColor;

    final double effectiveWidth = switchWidth < 48.0 ? 48.0 : switchWidth;
    final double effectiveHeight = switchHeight < 48.0 ? 48.0 : switchHeight;

    final onChangedCallback = onChanged;
    final String currentLabel =
        value ? (_activeLabel ?? '') : (_inactiveLabel ?? '');
    final control = Semantics(
      label: semanticLabel ?? (_hasLabels ? currentLabel : null),
      toggled: value,
      enabled: _isEnabled,
      onTap: onChangedCallback == null
          ? null
          : () => onChangedCallback(!value),
      excludeSemantics: true,
      child: GestureDetector(
        onTap: onChangedCallback == null
            ? null
            : () => onChangedCallback(!value),
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: effectiveWidth,
          height: effectiveHeight,
          alignment: Alignment.centerLeft,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: switchHeight,
            width: switchWidth,
            decoration: BoxDecoration(
              color: backgroundColor,
              border:
                  showBorder ? Border.all(color: borderColor, width: 1) : null,
              borderRadius: BorderRadius.circular(CoreSpacing.space6),
            ),
            child: Stack(
              children: [
                if (_hasLabels)
                  Positioned(
                      right:
                          value ? thumbSize + thumbPadding * 1.4 : thumbPadding,
                      left: value
                          ? thumbPadding
                          : thumbSize + thumbPadding * 1.4,
                      top: 0,
                      bottom: 0,
                      child: Center(
                        child: Text(
                          currentLabel,
                          style: labelStyle.copyWith(color: labelColor),
                          textAlign: TextAlign.center,
                        ),
                      )),

                // Animated thumb
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  left: value
                      ? switchWidth - thumbSize - thumbPadding
                      : thumbPadding,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    width: thumbSize,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    return _SwitchFocus(
      trackSize: Size(switchWidth, switchHeight),
      onActivate: onChangedCallback == null
          ? null
          : () => onChangedCallback(!value),
      child: control,
    );
  }
}

class _SwitchFocus extends StatefulWidget {
  const _SwitchFocus({
    required this.trackSize,
    required this.onActivate,
    required this.child,
  });

  final Size trackSize;
  final VoidCallback? onActivate;
  final Widget child;

  @override
  State<_SwitchFocus> createState() => _SwitchFocusState();
}

class _SwitchFocusState extends State<_SwitchFocus> {
  static const double _ringWidth = 2;

  bool _showsRing = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;

    // Tab reaches the switch and Enter or Space toggles it. The ring shows
    // for keyboard focus only; the library draws no press look.
    return FocusableActionDetector(
      enabled: widget.onActivate != null,
      onShowFocusHighlight: (showsRing) =>
          setState(() => _showsRing = showsRing),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onActivate?.call();
            return null;
          },
        ),
      },
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          widget.child,
          if (_showsRing)
            // Outside the track, so the switch keeps its size and look.
            IgnorePointer(
              child: Container(
                width: widget.trackSize.width,
                height: widget.trackSize.height,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colors.outlineFocus,
                    width: _ringWidth,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                  borderRadius: BorderRadius.circular(CoreSpacing.space6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
