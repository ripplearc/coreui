import 'package:flutter/material.dart';

import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/typography_extension.dart';
import 'keyboard_models.dart';

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
    final typography = TypographyExtension.of(context);
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
        label: digit.label,
        backgroundColor: backgroundColor,
        onPressed: () => onDigitPressed(digit),
        textStyle: typography.titleLargeSemiBold.copyWith(
          color: textColor,
          fontSize: effectiveHeight * _KeyboardButton._largeFontSizeRatio,
        ),
        width: effectiveWidth,
        height: effectiveHeight,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space3),
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
    final typography = TypographyExtension.of(context);
    final effectiveSize = size ?? CoreSpacing.space16;
    final effectiveWidth = width ?? effectiveSize;
    final effectiveHeight = height ?? effectiveSize;
    final backgroundColor = colors.keyboardCalculate;
    final textColor = colors.textHeadline;
    return Semantics(
      label: '${operatorType.symbol} operator button',
      button: true,
      child: _KeyboardButton(
        label: operatorType.symbol,
        backgroundColor: backgroundColor,
        onPressed: () => onOperatorPressed(operatorType),
        textStyle: typography.titleLargeMedium.copyWith(
          color: textColor,
          fontSize: effectiveHeight * _KeyboardButton._largeFontSizeRatio,
        ),
        width: effectiveWidth,
        height: effectiveHeight,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space3),
      ),
    );
  }
}

/// A button widget for measurement units on the keyboard.
///
/// [unit] is the type of unit to display (yards, feet, inches, meters, etc.).
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
    final typography = TypographyExtension.of(context);
    final effectiveHeight = height;
    final backgroundColor = colors.keyboardUnits;
    final textColor = colors.textHeadline;

    return Semantics(
      label: '${unit.label} unit button',
      button: true,
      child: _KeyboardButton(
        label: unit.label,
        backgroundColor: backgroundColor,
        onPressed: () => onUnitSelected(unit),
        width: width,
        height: effectiveHeight,
        borderRadius: unit == UnitType.divideSymbol
            ? BorderRadius.circular(_KeyboardButton._circularBorderRadius)
            : BorderRadius.circular(CoreSpacing.space6),
        pressedBorderRadius: unit == UnitType.divideSymbol
            ? BorderRadius.circular(CoreSpacing.space3)
            : BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        textStyle: typography.bodyLargeMedium.copyWith(
          color: textColor,
          fontSize: unit == UnitType.divideSymbol
              ? effectiveHeight! * _KeyboardButton._largeFontSizeRatio
              : effectiveHeight! * _KeyboardButton._smallFontSizeRatio,
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
    final typography = TypographyExtension.of(context);
    final backgroundColor = switch (action) {
      ControlAction.clearAll => colors.keyboardActions,
      ControlAction.delete => colors.keyboardMain,
      ControlAction.moreOptions => colors.keyboardCalculate,
    };
    final isMoreAction = action == ControlAction.moreOptions;
    final iconColor =
        isMoreAction ? colors.keyboardActions : colors.textInverse;
    final textColor =
        isMoreAction ? colors.keyboardActions : colors.textInverse;
    final borderColor = isMoreAction ? colors.keyboardActions : null;

    return Semantics(
      label: _getSemanticLabel(action),
      button: true,
      hint: _getSemanticHint(action),
      child: _KeyboardButton(
        label: action.label,
        icon: Icon(
          action.icon,
          color: iconColor,
          size: height! * _KeyboardButton._largeFontSizeRatio,
        ),
        borderColor: borderColor,
        backgroundColor: backgroundColor,
        onPressed: () => onControlAction(action),
        textStyle: typography.bodySmallRegular.copyWith(
          color: textColor,
          fontSize: height! * _KeyboardButton._smallFontSizeRatio,
        ),
        width: width,
        height: height,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space3),
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
    final typography = TypographyExtension.of(context);
    final effectiveHeight = height;
    final backgroundColor = colors.keyboardMain;
    final textColor = colors.textInverse;
    final label = resultType.label.toUpperCase();

    return Semantics(
      label: '$label button',
      button: true,
      hint: 'Calculates and displays the result',
      child: _KeyboardButton(
        label: label,
        backgroundColor: backgroundColor,
        onPressed: onTap,
        height: effectiveHeight,
        width: width,
        borderRadius:
            BorderRadius.circular(_KeyboardButton._circularBorderRadius),
        pressedBorderRadius: BorderRadius.circular(CoreSpacing.space3),
        textStyle: typography.titleLargeSemiBold.copyWith(
          color: textColor,
          fontSize: effectiveHeight! * _KeyboardButton._largeFontSizeRatio,
        ),
      ),
    );
  }
}

class _KeyboardButton extends StatefulWidget {
  final String? label;
  final Widget? icon;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;
  final BorderRadius? pressedBorderRadius;

  static const double _defaultSize = CoreSpacing.space16;
  static const double _defaultBorderWidth = 2.0;

  static const double _largeFontSizeRatio = 0.35;

  static const double _smallFontSizeRatio = 0.25;

  static const double _circularBorderRadius = 100.0;

  const _KeyboardButton({
    this.label,
    this.icon,
    this.borderColor,
    required this.backgroundColor,
    required this.onPressed,
    this.textStyle,
    this.width,
    this.height,
    BorderRadius? borderRadius,
    this.pressedBorderRadius,
  }) : borderRadius = borderRadius ??
            const BorderRadius.all(Radius.circular(CoreSpacing.space8));

  @override
  State<_KeyboardButton> createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<_KeyboardButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startPressAnimation(TapDownDetails details) {
    if (!_isPressed) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _endPressAnimation(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _cancelPressAnimation() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapDown(TapDownDetails details) => _startPressAnimation(details);
  void _handleTapUp(TapUpDetails details) => _endPressAnimation(details);
  void _handleTapCancel() => _cancelPressAnimation();

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final effectiveWidth = widget.width ?? _KeyboardButton._defaultSize;
    final effectiveHeight = widget.height;
    final effectiveBackgroundColor =
        widget.backgroundColor ?? colors.transparent;
    final effectiveBorderColor = widget.borderColor ?? effectiveBackgroundColor;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentBorderRadius = BorderRadius.lerp(
          widget.borderRadius,
          widget.pressedBorderRadius ?? widget.borderRadius,
          _animation.value,
        )!;

        return Container(
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
          child: Material(
            color: colors.transparent,
            borderRadius: currentBorderRadius,
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              borderRadius: currentBorderRadius,
              splashColor: colors.transparent,
              highlightColor: colors.transparent,
              hoverColor: colors.transparent,
              focusColor: colors.transparent,
              onTap: widget.onPressed,
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              child: Center(
                  child: Text(
                widget.label!,
                style: widget.textStyle,
              )),
            ),
          ),
        );
      },
    );
  }
}
