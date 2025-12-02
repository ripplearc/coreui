import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/typography.dart';
import '../../theme/typography_extension.dart';
import 'keyboard_models.dart';

class DigitInput extends StatelessWidget {
  final DigitType digit;
  final ValueChanged<DigitType> onDigitPressed;
  final bool isEmphasized;
  final double? radius;


  const DigitInput({
    super.key,
    required this.digit,
    required this.onDigitPressed,
    this.isEmphasized = false,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return _KeyboardButton(
      label: digit.label,
      backgroundColor: isEmphasized
          ? colors?.keyboardCalculate 
          : colors?.keyboardNumbers,
      onPressed: () => onDigitPressed(digit),
      textStyle: typography?.titleLargeSemiBold.copyWith(
        color: colors?.textHeadline,
      ),
        width: radius!,
        height: radius!,
    );
  }
}

class OperatorButton extends StatelessWidget {
  final OperatorType operatorType;
  final ValueChanged<OperatorType> onOperatorPressed;
  final double? radius;

  const OperatorButton({
    super.key,
    required this.operatorType,
    required this.onOperatorPressed,
    this.radius,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return _KeyboardButton(
      label: operatorType.symbol,
      backgroundColor: colors?.keyboardCalculate!,
      onPressed: () => onOperatorPressed(operatorType),
      textStyle: typography?.titleLargeMedium.copyWith(
        color: colors?.textHeadline,
      ),
      width: radius,
      height: radius,
    );
  }
}

class UnitButton extends StatelessWidget {
  final UnitType unit;
  final ValueChanged<UnitType> onUnitSelected;
  final double? width;
  final double? height;
  

  const UnitButton({
    super.key,
    required this.unit,
    required this.onUnitSelected,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return _KeyboardButton(
      label: unit.label,
      backgroundColor: colors?.keyboardUnits,
      onPressed: () => onUnitSelected(unit),
      width: width,
      height: height ?? (width != null ? width! * 0.78 : 60),
      borderRadius: BorderRadius.circular(CoreSpacing.space6),
      textStyle: typography?.bodyLargeMedium.copyWith(
        color: colors?.textHeadline,
      ),
    );
  }
}

class ControlButton extends StatelessWidget {
  final ControlAction action;
  final ValueChanged<ControlAction> onControlAction;
  final double? width;
  final double? height;

  const ControlButton({
    super.key,
    required this.action,
    required this.onControlAction,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    final backgroundColor = switch (action) {
      ControlAction.clearAll => colors?.keyboardActions, 
      ControlAction.delete => colors?.keyboardMain ,
      ControlAction.moreOptions => colors?.keyboardCalculate,
    };
    final isMoreAction = action ==  ControlAction.moreOptions;
    
    return _KeyboardButton(
      label: action.label,
      icon:  action.icon != null
          ? Icon(action.icon, 
          color: isMoreAction ? colors?.keyboardActions : colors?.textInverse
          )
          : null,
      borderColor: isMoreAction ? colors?.keyboardActions : null,
      backgroundColor: backgroundColor!,
      onPressed: () => onControlAction(action),
      textStyle: typography?.bodyLargeMedium.copyWith(
        color: colors?.textInverse,
      ),
      width: width,
      height: height,
    );
  }
}

class ResultButton extends StatelessWidget {
  final ResultType resultType;
  final VoidCallback onTap;
  final String? customLabel;
  final double? width;
  final double? height;

  const ResultButton({
    super.key,
    required this.resultType,
    required this.onTap,
    this.customLabel,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return _KeyboardButton(
      label: resultType.label(customLabel).toUpperCase(),
      backgroundColor: colors?.keyboardMain,
      onPressed: onTap,
      height: height ?? (width != null ? width! * 0.53 : 56),
      width: width,
      borderRadius: BorderRadius.circular(CoreSpacing.space8),
      textStyle: typography?.titleLargeSemiBold.copyWith(
        color: colors?.textInverse ,
      ),
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  final String? label;
  final Widget? icon;
  final Color? borderColor;
  final Color? backgroundColor;
  final VoidCallback onPressed;
  final TextStyle? textStyle;
  final double? width;
  final double? height;
  final BorderRadius borderRadius;

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
  }) : borderRadius = borderRadius ?? const BorderRadius.all(Radius.circular(32));

  @override
  Widget build(BuildContext context) {
    final effectiveWidth = width ?? 64;
    final effectiveHeight = height ?? effectiveWidth;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color:borderColor ?? backgroundColor!,width:2),
        borderRadius: borderRadius,
        color: backgroundColor!,
      ),
      width: effectiveWidth,
      height: effectiveHeight,
      child: Material(
        color: backgroundColor!,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onPressed,
          child: Center(
            child: icon ??
                Text(
                  label ?? '',
                  style: textStyle,
                ),
          ),
        ),
      ),
    );
  }
}

