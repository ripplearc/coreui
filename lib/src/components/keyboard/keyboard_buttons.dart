import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A button widget for numeric digit input on the keyboard.
///
/// [digit] is the type of digit to display (0-9, decimal, or divide symbol).
/// [onDigitPressed] is called when the button is pressed.
/// [isEmphasized] determines if the button uses emphasized styling.
/// [size] is the width and height of the button (defaults to 64px).
/// [textStyle] replaces the label style, which by default is
/// `titleLargeMedium` scaled to the button's height. The colour stays
/// `textHeadline` either way.
/// [semantics] supplies the screen-reader label through
/// [CoreKeyboardSemantics.digitLabel]; it defaults to
/// [CoreKeyboardSemantics.english].
///
/// The rendered button carries [DigitTypeX.testKey] (`calc_key_seven`) for
/// Patrol and widget tests.
class CoreDigitInput extends StatelessWidget {
  final DigitType digit;
  final ValueChanged<DigitType> onDigitPressed;
  final bool isEmphasized;
  final double? size;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final CoreKeyboardSemantics semantics;

  const CoreDigitInput({
    super.key,
    required this.digit,
    required this.onDigitPressed,
    this.isEmphasized = false,
    this.size,
    this.width,
    this.height,
    this.textStyle,
    this.semantics = CoreKeyboardSemantics.english,
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
      label: semantics.digitLabel(digit),
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
/// [operatorType] is the type of operator to display (+, −, ×, ÷, %).
/// [onOperatorPressed] is called when the button is pressed.
/// [size] is the width and height of the button (defaults to 64px).
/// [semantics] supplies the screen-reader label through
/// [CoreKeyboardSemantics.operatorLabel]; it defaults to
/// [CoreKeyboardSemantics.english].
///
/// The rendered button carries [OperatorTypeX.testKey] (`calc_key_add`) for
/// Patrol and widget tests.
class CoreOperatorButton extends StatelessWidget {
  final OperatorType operatorType;
  final ValueChanged<OperatorType> onOperatorPressed;
  final double? size;
  final double? width;
  final double? height;
  final CoreKeyboardSemantics semantics;

  const CoreOperatorButton({
    super.key,
    required this.operatorType,
    required this.onOperatorPressed,
    this.size,
    this.width,
    this.height,
    this.semantics = CoreKeyboardSemantics.english,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final effectiveSize = size ?? CoreSpacing.space16;
    final effectiveWidth = width ?? effectiveSize;
    final effectiveHeight = height ?? effectiveSize;
    final backgroundColor = colors.keyboardCalculate;
    return Semantics(
      label: semantics.operatorLabel(operatorType),
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
/// [unit] is the type of unit to display (yards, feet, inch, meters, etc.).
/// [onUnitSelected] is called when the button is pressed.
/// [width] is the width of the button.
/// [height] is the height of the button. If not provided, defaults to 78% of width or 60px.
/// [semantics] supplies the screen-reader label through
/// [CoreKeyboardSemantics.unitLabel]; it defaults to
/// [CoreKeyboardSemantics.english].
///
/// The rendered button carries [UnitTypeX.testKey] (`calc_key_feet`) for
/// Patrol and widget tests.
class CoreUnitButton extends StatelessWidget {
  final UnitType unit;
  final ValueChanged<UnitType> onUnitSelected;
  final double? width;
  final double? height;
  final CoreKeyboardSemantics semantics;

  const CoreUnitButton({
    super.key,
    required this.unit,
    required this.onUnitSelected,
    this.width,
    this.height,
    this.semantics = CoreKeyboardSemantics.english,
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
      label: semantics.unitLabel(unit),
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
/// [action] is the type of control action (delete, clear all, bracket).
/// [onControlAction] is called when the button is pressed.
/// [enabled] is whether the button answers taps; `false` dims it, drops its
/// tap action and reports it disabled to a screen reader.
/// [isNeutral] draws the button on the digit keys' grey with a dark grey
/// face, in place of its action's colour, so it does not compete with a
/// filled commit button beside it.
/// [semantics] supplies the screen-reader label and hint through
/// [CoreKeyboardSemantics.controlLabel] and
/// [CoreKeyboardSemantics.controlHint]; it defaults to
/// [CoreKeyboardSemantics.english].
/// [semanticLabel] replaces the label [semantics] would build for this one
/// [action].
/// [semanticHint] does the same for the hint. Either hint is withheld while
/// the button is not [enabled].
/// [width] is the width of the button.
/// [height] is the height of the button.
///
/// The rendered button carries [ControlActionX.testKey] (`calc_key_clearAll`)
/// for Patrol and widget tests.
class CoreControlButton extends StatelessWidget {
  final ControlAction action;
  final ValueChanged<ControlAction> onControlAction;
  final bool enabled;
  final bool isNeutral;
  final CoreKeyboardSemantics semantics;
  final String? semanticLabel;
  final String? semanticHint;
  final double? width;
  final double? height;

  const CoreControlButton({
    super.key,
    required this.action,
    required this.onControlAction,
    this.enabled = true,
    this.isNeutral = false,
    this.semantics = CoreKeyboardSemantics.english,
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
      label: semanticLabel ?? semantics.controlLabel(action),
      button: true,
      enabled: enabled,
      hint: enabled ? semanticHint ?? semantics.controlHint(action) : null,
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
}

/// A button widget for result actions on the keyboard.
///
/// [resultType] is the type of result to display (equals, area, volume, density, or custom).
/// [onTap] is called when the button is pressed.
/// [customLabel] overrides [resultType]'s label and is rendered verbatim.
/// [semantics] supplies the screen-reader label and hint through
/// [CoreKeyboardSemantics.resultLabel], built from the face the key shows,
/// and [CoreKeyboardSemantics.resultHint]; it defaults to
/// [CoreKeyboardSemantics.english].
/// [width] is the width of the button.
/// [height] is the height of the button. If not provided, defaults to 53% of width or 56px.
///
/// The rendered button carries [testKey] for Patrol and widget tests.
class CoreResultButton extends StatelessWidget {
  /// The [Key] the rendered result button carries: `calc_key_result`.
  static const Key testKey = ValueKey('calc_key_result');

  final ResultType resultType;
  final VoidCallback onTap;
  final String? customLabel;
  final CoreKeyboardSemantics semantics;
  final double? width;
  final double? height;

  const CoreResultButton({
    super.key,
    required this.resultType,
    required this.onTap,
    this.customLabel,
    this.semantics = CoreKeyboardSemantics.english,
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
      label: semantics.resultLabel(label),
      button: true,
      // A commit key reading "Update" does not calculate anything, so the
      // result hint would announce something untrue. Its label already says
      // what it does.
      hint: isCustom ? null : semantics.resultHint,
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
