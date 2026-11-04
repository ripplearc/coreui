import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A button widget for numeric digit input on the keyboard.
///
/// The rendered button carries [DigitTypeX.testKey] (`calc_key_seven`) for
/// Patrol and widget tests.
class CoreDigitInput extends StatelessWidget {
  /// The key's digit, decimal point or divide sign, shown as its label.
  final DigitType digit;

  /// Called with [digit] when the key is tapped.
  final ValueChanged<DigitType> onDigitPressed;

  /// Draws the key in the operator keys' `keyboardCalculate` colour in place
  /// of the digit grey. Defaults to false.
  final bool isEmphasized;

  /// Width and height in px when [width] or [height] is null. Defaults to
  /// 64.
  final double? size;

  /// Width in px. When null the key is [size] wide.
  final double? width;

  /// Height in px. When null the key is [size] tall.
  final double? height;

  /// Replaces the label style, which by default is `titleLargeMedium`
  /// scaled to the key's height. The colour stays `textHeadline` either way.
  final TextStyle? textStyle;

  /// Creates a round digit key.
  const CoreDigitInput({
    super.key,
    required this.digit,
    required this.onDigitPressed,
    this.isEmphasized = false,
    this.size,
    this.width,
    this.height,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final effectiveSize = size ?? CoreSpacing.space16;
    final effectiveWidth = width ?? effectiveSize;
    final effectiveHeight = height ?? effectiveSize;
    final backgroundColor =
        isEmphasized ? colors.keyboardCalculate : colors.keyboardNumbers;
    final textColor = colors.textHeadline;

    return Semantics(
      label: '${digit.label} button',
      button: true,
      child: _KeyboardButton(
        key: digit.testKey,
        isLabel: true,
        label: digit.label,
        backgroundColor: backgroundColor,
        onPressed: () => onDigitPressed(digit),
        textStyle: (textStyle ??
                typography.titleLargeMedium.copyWith(
                  fontSize:
                      effectiveHeight * _KeyboardButton._largeFontSizeRatio,
                ))
            .copyWith(color: textColor),
        width: effectiveWidth,
        height: effectiveHeight,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
      ),
    );
  }
}

/// A button widget for mathematical operators on the keyboard.
///
/// The rendered button carries [OperatorTypeX.testKey] (`calc_key_add`) for
/// Patrol and widget tests.
class CoreOperatorButton extends StatelessWidget {
  /// The operator the key shows as its icon: +, −, ×, ÷ or %.
  final OperatorType operatorType;

  /// Called with [operatorType] when the key is tapped.
  final ValueChanged<OperatorType> onOperatorPressed;

  /// Width and height in px when [width] or [height] is null. Defaults to
  /// 64.
  final double? size;

  /// Width in px. When null the key is [size] wide.
  final double? width;

  /// Height in px. When null the key is [size] tall.
  final double? height;

  /// Creates a round operator key.
  const CoreOperatorButton({
    super.key,
    required this.operatorType,
    required this.onOperatorPressed,
    this.size,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final effectiveSize = size ?? CoreSpacing.space16;
    final effectiveWidth = width ?? effectiveSize;
    final effectiveHeight = height ?? effectiveSize;
    final backgroundColor = colors.keyboardCalculate;
    return Semantics(
      label: '${operatorType.symbol} operator button',
      button: true,
      child: _KeyboardButton(
        key: operatorType.testKey,
        isLabel: false,
        icon: operatorType.icon,
        backgroundColor: backgroundColor,
        onPressed: () => onOperatorPressed(operatorType),
        width: effectiveWidth,
        height: effectiveHeight,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
      ),
    );
  }
}

/// A button widget for measurement units on the keyboard.
///
/// The rendered button carries [UnitTypeX.testKey] (`calc_key_feet`) for
/// Patrol and widget tests.
class CoreUnitButton extends StatelessWidget {
  /// The unit the key shows, such as Feet or M. [UnitType.divideSymbol]
  /// draws a round key with a slash icon in place of a label.
  final UnitType unit;

  /// Called with [unit] when the key is tapped.
  final ValueChanged<UnitType> onUnitSelected;

  /// Width in px. When null the key is 64 px wide.
  final double? width;

  /// Height in px. When null the key takes the height its parent gives,
  /// and the label keeps its theme size.
  final double? height;

  /// Creates a unit key.
  const CoreUnitButton({
    super.key,
    required this.unit,
    required this.onUnitSelected,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final effectiveHeight = height;
    final backgroundColor = colors.keyboardUnits;
    final textColor = colors.textHeadline;

    final fontSize = effectiveHeight != null
        ? (unit == UnitType.divideSymbol
            ? effectiveHeight * _KeyboardButton._largeFontSizeRatio
            : effectiveHeight * _KeyboardButton._smallFontSizeRatio)
        : null;

    return Semantics(
      label: '${unit.label} unit button',
      button: true,
      child: _KeyboardButton(
        key: unit.testKey,
        label: unit == UnitType.divideSymbol ? null : unit.label,
        icon: unit == UnitType.divideSymbol ? CoreIcons.slash : null,
        isLabel: unit != UnitType.divideSymbol,
        backgroundColor: backgroundColor,
        onPressed: () => onUnitSelected(unit),
        width: width,
        height: effectiveHeight,
        borderRadius: BorderRadius.circular(unit == UnitType.divideSymbol
            ? _KeyboardButton._circularBorderRadius
            : CoreSpacing.space5),
        textStyle: fontSize != null
            ? typography.bodyLargeMedium.copyWith(
                color: textColor,
                fontSize: fontSize,
              )
            : typography.bodyLargeMedium.copyWith(
                color: textColor,
              ),
      ),
    );
  }
}

/// A button widget for control actions on the keyboard.
///
/// The rendered button carries [ControlActionX.testKey] (`calc_key_clearAll`)
/// for Patrol and widget tests.
class CoreControlButton extends StatelessWidget {
  /// What the key does: delete, clear all, more options or bracket. It also
  /// picks the key's colour, label or icon.
  final ControlAction action;

  /// Called with [action] when the key is tapped.
  final ValueChanged<ControlAction> onControlAction;

  /// Whether the key answers taps; `false` dims it, drops its tap action
  /// and reports it disabled to a screen reader. Defaults to true.
  final bool enabled;

  /// Draws the key on the digit keys' grey with a dark grey face, in place
  /// of its action's colour, so it does not compete with a filled commit
  /// key beside it. Defaults to false.
  final bool isNeutral;

  /// Replaces the English screen-reader label built for [action] with the
  /// app's localised one.
  final String? semanticLabel;

  /// Replaces the English screen-reader hint built for [action]. No hint
  /// is announced while the key is not [enabled].
  final String? semanticHint;

  /// Width in px. When null the key is 64 px wide.
  final double? width;

  /// Height in px. When null the key takes the height its parent gives,
  /// and the label keeps its theme size.
  final double? height;

  /// Creates a round control key.
  const CoreControlButton({
    super.key,
    required this.action,
    required this.onControlAction,
    this.enabled = true,
    this.isNeutral = false,
    this.semanticLabel,
    this.semanticHint,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final (backgroundColor, isOutlined) = switch (action) {
      _ when isNeutral => (colors.keyboardNumbers, false),
      ControlAction.clearAll => (colors.keyboardActions, false),
      ControlAction.delete => (colors.keyboardMain, false),
      ControlAction.moreOptions || ControlAction.paren => (
          colors.keyboardCalculate,
          true
        ),
    };
    final textColor = isNeutral
        ? colors.iconGrayDark
        : isOutlined
            ? colors.keyboardActions
            : colors.textInverse;
    final borderColor = isOutlined ? colors.keyboardActions : null;
    final label = action.label;

    final h = height;
    final textStyle = label != null
        ? typography.titleLargeSemiBold.copyWith(
            color: textColor,
            fontSize:
                h != null ? h * _KeyboardButton._largeFontSizeRatio : null,
          )
        : typography.bodySmallRegular.copyWith(
            color: textColor,
            fontSize:
                h != null ? h * _KeyboardButton._smallFontSizeRatio : null,
          );

    return Semantics(
      label: semanticLabel ?? _getSemanticLabel(action),
      button: true,
      enabled: enabled,
      hint: enabled ? semanticHint ?? _getSemanticHint(action) : null,
      child: _KeyboardButton(
        key: action.testKey,
        isLabel: label != null,
        label: label,
        icon: action.icon,
        enabled: enabled,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        onPressed: () => onControlAction(action),
        textStyle: textStyle,
        width: width,
        height: height,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
      ),
    );
  }

  // TODO: [CA-1198] https://ripplearc.youtrack.cloud/issue/CA-1198
  // Take every key's screen-reader label and hint from the app.
  String _getSemanticLabel(ControlAction action) {
    return switch (action) {
      ControlAction.delete => 'Delete button',
      ControlAction.clearAll => 'Clear all button',
      ControlAction.moreOptions => 'More options button',
      ControlAction.paren => 'Bracket button',
    };
  }

  String _getSemanticHint(ControlAction action) {
    return switch (action) {
      ControlAction.delete => 'Deletes the last entered character',
      ControlAction.clearAll => 'Clears all input',
      ControlAction.moreOptions => 'Shows additional options',
      ControlAction.paren => 'Opens a bracket; the next press closes it',
    };
  }
}

/// A button widget for result actions on the keyboard.
///
/// The rendered button carries [testKey] for Patrol and widget tests.
class CoreResultButton extends StatelessWidget {
  /// The [Key] the rendered result button carries: `calc_key_result`.
  static const Key testKey = ValueKey('calc_key_result');

  /// The result the key computes; its label is shown in capitals.
  final ResultType resultType;

  /// Called when the key is tapped.
  final VoidCallback onTap;

  /// Replaces [resultType]'s label and is shown as written, for a commit
  /// key such as "Update". An empty string counts as null.
  final String? customLabel;

  /// Width in px. When null the key is 64 px wide.
  final double? width;

  /// Height in px. When null the key takes the height its parent gives,
  /// and the label keeps its theme size.
  final double? height;

  /// Creates the round result key.
  const CoreResultButton({
    super.key,
    required this.resultType,
    required this.onTap,
    this.customLabel,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final effectiveHeight = height;
    final backgroundColor = colors.keyboardMain;
    final textColor = colors.textInverse;
    // A caller-supplied label is shown as written — "Update" and "Add" are
    // sentence case in the design, unlike the upper-cased default. An empty
    // one counts as absent: a caller that forgot to supply a label should get
    // the default, not a commit key with nothing written on it.
    final custom = customLabel;
    final label = (custom != null && custom.isNotEmpty)
        ? custom
        : resultType.label.toUpperCase();

    final h = effectiveHeight;
    final fontSize = h != null ? h * _KeyboardButton._largeFontSizeRatio : null;

    final isCustom = custom != null && custom.isNotEmpty;

    return Semantics(
      label: '$label button',
      button: true,
      // A commit key reading "Update" does not calculate anything, so the
      // default hint would announce something untrue. Its label already says
      // what it does.
      hint: isCustom ? null : 'Calculates and displays the result',
      child: _KeyboardButton(
        key: testKey,
        label: label,
        isLabel: true,
        backgroundColor: backgroundColor,
        onPressed: onTap,
        height: effectiveHeight,
        width: width,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        textStyle: fontSize != null
            ? typography.titleLargeSemiBold.copyWith(
                color: textColor,
                fontSize: fontSize,
              )
            : typography.titleLargeSemiBold.copyWith(
                color: textColor,
              ),
      ),
    );
  }
}

class _KeyboardButton extends StatefulWidget {
  final String? label;
  final CoreIconData? icon;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final bool isLabel;
  final bool enabled;

  static const double _defaultSize = CoreSpacing.space16;
  static const double _defaultBorderWidth = 2.0;
  static const double _disabledOpacity = 0.3;

  static const double _largeFontSizeRatio = 0.35;

  static const double _smallFontSizeRatio = 0.25;

  static const double _circularBorderRadius = 100.0;

  static const double _flashOverlayMaxOpacity = 0.4;

  const _KeyboardButton({
    super.key,
    this.label,
    this.icon,
    this.borderColor,
    required this.backgroundColor,
    required this.onPressed,
    this.textStyle,
    this.width,
    this.height,
    BorderRadius? borderRadius,
    required this.isLabel,
    this.enabled = true,
  }) : borderRadius = borderRadius ??
            const BorderRadius.all(Radius.circular(CoreSpacing.space8));

  @override
  State<_KeyboardButton> createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<_KeyboardButton>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 150);

  late final AnimationController _animationController;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
  }

  @override
  void didUpdateWidget(_KeyboardButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && _isPressed) {
      _isPressed = false;
      _animationController.reverse();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (_isPressed) return;
    HapticFeedback.lightImpact();
    _isPressed = true;
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      _isPressed = false;
      _animationController.reverse();
      widget.onPressed();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      _isPressed = false;
      _animationController.reverse();
    }
  }

  Widget _buildIconContent(AppColorsExtension colors, double? effectiveHeight) {
    final icon = widget.icon;
    if (icon == null || effectiveHeight == null) {
      return const SizedBox.shrink();
    }

    return CoreIconWidget(
      icon: icon,
      size: effectiveHeight * _KeyboardButton._largeFontSizeRatio,
      color: widget.textStyle?.color ?? colors.textHeadline,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final effectiveWidth = widget.width ?? _KeyboardButton._defaultSize;
    final effectiveHeight = widget.height;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colors.transparent;
    final effectiveBorderColor = widget.borderColor;

    final staticChild = Center(
      child: widget.isLabel
          ? Text(
              widget.label ?? '',
              style: widget.textStyle,
            )
          : _buildIconContent(colors, effectiveHeight),
    );

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final t = Curves.ease.transform(_animationController.value);

        return GestureDetector(
          onTapDown: widget.enabled ? _handleTapDown : null,
          onTapUp: widget.enabled ? _handleTapUp : null,
          onTapCancel: widget.enabled ? _handleTapCancel : null,
          child: _dimmedUnlessEnabled(
            Container(
              decoration: BoxDecoration(
                border: effectiveBorderColor != null
                    ? Border.all(
                        color: effectiveBorderColor,
                        width: _KeyboardButton._defaultBorderWidth,
                      )
                    : null,
                borderRadius: widget.borderRadius,
                color: effectiveBackgroundColor,
              ),
              width: effectiveWidth,
              height: effectiveHeight,
              child: ClipRRect(
                borderRadius: widget.borderRadius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    child ?? const SizedBox.shrink(),
                    IgnorePointer(
                      child: Opacity(
                        opacity: t * _KeyboardButton._flashOverlayMaxOpacity,
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.iconGrayLight,
                            borderRadius: widget.borderRadius,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      child: staticChild,
    );
  }

  Widget _dimmedUnlessEnabled(Widget child) => widget.enabled
      ? child
      : Opacity(opacity: _KeyboardButton._disabledOpacity, child: child);
}
