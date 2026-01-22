import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A button widget for numeric digit input on the keyboard.
///
/// [digit] is the type of digit to display (0-9, decimal, or divide symbol).
/// [onDigitPressed] is called when the button is pressed.
/// [isEmphasized] determines if the button uses emphasized styling.
/// [size] is the width and height of the button (defaults to 64px).
class CoreDigitInput extends StatelessWidget {
  final DigitType digit;
  final ValueChanged<DigitType> onDigitPressed;
  final bool isEmphasized;
  final double? size;
  final double? width;
  final double? height;

  const CoreDigitInput({
    super.key,
    required this.digit,
    required this.onDigitPressed,
    this.isEmphasized = false,
    this.size,
    this.width,
    this.height,
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
        islabel: true,
        label: digit.label,
        backgroundColor: backgroundColor,
        onPressed: () => onDigitPressed(digit),
        textStyle: typography.titleLargeRegular.copyWith(
          color: textColor,
          fontSize: effectiveHeight * _KeyboardButton._largeFontSizeRatio,
        ),
        width: effectiveWidth,
        height: effectiveHeight,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space4),
      ),
    );
  }
}

/// A button widget for mathematical operators on the keyboard.
///
/// [operatorType] is the type of operator to display (+, −, ×, ÷, %).
/// [onOperatorPressed] is called when the button is pressed.
/// [size] is the width and height of the button (defaults to 64px).
class CoreOperatorButton extends StatelessWidget {
  final OperatorType operatorType;
  final ValueChanged<OperatorType> onOperatorPressed;
  final double? size;
  final double? width;
  final double? height;

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
        islabel: false,
        icon: operatorType.icon,
        backgroundColor: backgroundColor,
        onPressed: () => onOperatorPressed(operatorType),
        width: effectiveWidth,
        height: effectiveHeight,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space4),
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
class CoreUnitButton extends StatelessWidget {
  final UnitType unit;
  final ValueChanged<UnitType> onUnitSelected;
  final double? width;
  final double? height;

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
        label: unit == UnitType.divideSymbol ? null : unit.label,
        icon: unit == UnitType.divideSymbol ? CoreIcons.slash : null,
        islabel: unit != UnitType.divideSymbol,
        backgroundColor: backgroundColor,
        onPressed: () => onUnitSelected(unit),
        width: width,
        height: effectiveHeight,
        borderRadius: BorderRadius.circular(unit == UnitType.divideSymbol
            ? _KeyboardButton._circularBorderRadius
            : CoreSpacing.space3),
        pressedBorderRadius: BorderRadius.circular(unit == UnitType.divideSymbol
            ? CoreSpacing.space4
            : _KeyboardButton._circularBorderRadius),
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
/// [action] is the type of control action (delete, clear all, more options).
/// [onControlAction] is called when the button is pressed.
/// [width] is the width of the button.
/// [height] is the height of the button.
class CoreControlButton extends StatelessWidget {
  final ControlAction action;
  final ValueChanged<ControlAction> onControlAction;
  final double? width;
  final double? height;

  const CoreControlButton({
    super.key,
    required this.action,
    required this.onControlAction,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final backgroundColor = switch (action) {
      ControlAction.clearAll => colors.keyboardActions,
      ControlAction.delete => colors.keyboardMain,
      ControlAction.moreOptions => colors.keyboardCalculate,
    };
    final isMoreAction = action == ControlAction.moreOptions;
    final textColor =
        isMoreAction ? colors.keyboardActions : colors.textInverse;
    final borderColor = isMoreAction ? colors.keyboardActions : null;

    final h = height;
    double? fontSize;
    if (h != null) {
      fontSize = h * _KeyboardButton._smallFontSizeRatio;
    }

    return Semantics(
      label: _getSemanticLabel(action),
      button: true,
      hint: _getSemanticHint(action),
      child: _KeyboardButton(
        islabel: false,
        icon: action.icon,
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        onPressed: () => onControlAction(action),
        textStyle: fontSize != null
            ? typography.bodySmallRegular.copyWith(
                color: textColor,
                fontSize: fontSize,
              )
            : typography.bodySmallRegular.copyWith(
                color: textColor,
              ),
        width: width,
        height: height,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space4),
      ),
    );
  }

  String _getSemanticLabel(ControlAction action) {
    return switch (action) {
      ControlAction.delete => 'Delete button',
      ControlAction.clearAll => 'Clear all button',
      ControlAction.moreOptions => 'More options button',
    };
  }

  String _getSemanticHint(ControlAction action) {
    return switch (action) {
      ControlAction.delete => 'Deletes the last entered character',
      ControlAction.clearAll => 'Clears all input',
      ControlAction.moreOptions => 'Shows additional options',
    };
  }
}

/// A button widget for result actions on the keyboard.
///
/// [resultType] is the type of result to display (equals, area, volume, density, or custom).
/// [onTap] is called when the button is pressed.
/// [customLabel] is an optional custom label used when [resultType] is [ResultType.custom].
/// [width] is the width of the button.
/// [height] is the height of the button. If not provided, defaults to 53% of width or 56px.
class CoreResultButton extends StatelessWidget {
  final ResultType resultType;
  final VoidCallback onTap;
  final String? customLabel;
  final double? width;
  final double? height;

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
    final label = resultType.label.toUpperCase();

    final h = effectiveHeight;
    final fontSize = h != null ? h * _KeyboardButton._largeFontSizeRatio : null;

    return Semantics(
      label: '$label button',
      button: true,
      hint: 'Calculates and displays the result',
      child: _KeyboardButton(
        label: label,
        islabel: true,
        backgroundColor: backgroundColor,
        onPressed: onTap,
        height: effectiveHeight,
        width: width,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space4),
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
  final BorderRadius? pressedBorderRadius;
  final bool islabel;

  static const double _defaultSize = CoreSpacing.space16;
  static const double _defaultBorderWidth = 2.0;

  static const double _largeFontSizeRatio = 0.35;

  static const double _smallFontSizeRatio = 0.25;

  static const double _circularBorderRadius = 100.0;

  const _KeyboardButton(
      {this.label,
      this.icon,
      this.borderColor,
      required this.backgroundColor,
      required this.onPressed,
      this.textStyle,
      this.width,
      this.height,
      BorderRadius? borderRadius,
      this.pressedBorderRadius,
      required this.islabel})
      : borderRadius = borderRadius ??
            const BorderRadius.all(Radius.circular(CoreSpacing.space8));

  @override
  State<_KeyboardButton> createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<_KeyboardButton> {
  static const double _tweenBegin = 0.0;
  static const double _tweenEndPressed = 1.0;
  static const double _tweenEndUnpressed = 0.0;
  static const Duration _tweenDuration = Duration(milliseconds: 200);

  bool _isPressed = false;

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
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
    final effectiveBorderColor = widget.borderColor ?? effectiveBackgroundColor;

    final staticChild = Center(
      child: widget.islabel
          ? Text(
              widget.label ?? '',
              style: widget.textStyle,
            )
          : _buildIconContent(colors, effectiveHeight),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(
        begin: _tweenBegin,
        end: _isPressed ? _tweenEndPressed : _tweenEndUnpressed,
      ),
      duration: _tweenDuration,
      curve: Curves.easeInOut,
      builder: (context, animationValue, child) {
        final currentBorderRadius = BorderRadius.lerp(
              widget.borderRadius,
              widget.pressedBorderRadius ?? widget.borderRadius,
              animationValue,
            ) ??
            widget.borderRadius;

        return GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: (details) {
            _handleTapUp(details);
            widget.onPressed();
          },
          onTapCancel: _handleTapCancel,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: effectiveBorderColor,
                width: _KeyboardButton._defaultBorderWidth,
              ),
              borderRadius: currentBorderRadius,
              color: effectiveBackgroundColor,
            ),
            width: effectiveWidth,
            height: effectiveHeight,
            child: ClipRRect(
              borderRadius: currentBorderRadius,
              child: child,
            ),
          ),
        );
      },
      child: staticChild,
    );
  }
}
