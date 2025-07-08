import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

/// Defines the size of the button.
/// - [large]: 48px height.
/// - [medium]: 40px height.
/// - [small]: 36px height.
enum CoreButtonSize {
  large,
  medium,
  small,
}

/// Determines the presentation style of the button.
/// - [primary]: Default button style with a solid background.
/// - [secondary]: Button with a white background and border.
/// - [social]: Button styled for social media actions, typically with a white background and the social media [CoreIconWidget] passed.
enum CoreButtonVariant { primary, secondary, social }

/// A customizable button widget that supports different sizes, variants, and icons.
/// [label] is the text displayed on the button.
/// [onPressed] is the callback function when the button is pressed.
/// [size] determines the height of the button.
/// [variant] determines the button's style.
/// [icon] is an optional icon displayed on the button.
/// [isDisabled] indicates whether the button is disabled.
/// [fullWidth] makes the button take the full width of its parent.
/// [borderRadius] sets the button's border radius.
/// [centerAlign] aligns the content in the center.
/// [spaceOut] adds spacing between the icon and text.
/// [trailing] places the icon at the end of the button.
class CoreButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final CoreButtonSize size;
  final CoreButtonVariant variant;
  final CoreIconWidget? icon;
  final bool isDisabled;
  final bool fullWidth;
  final double borderRadius;
  final bool centerAlign;
  final bool spaceOut;
  final bool trailing;

  const CoreButton({
    super.key,
    required this.label,
    this.onPressed,
    this.size = CoreButtonSize.large,
    this.variant = CoreButtonVariant.primary,
    this.icon,
    this.isDisabled = false,
    this.fullWidth = true,
    this.borderRadius = 40.0,
    this.spaceOut = false,
    this.trailing = false,
    this.centerAlign = true,
  });

  double get _height {
    switch (size) {
      case CoreButtonSize.large:
        return 48;
      case CoreButtonSize.medium:
        return 40;
      case CoreButtonSize.small:
        return 36;
    }
  }

  EdgeInsets get _padding {
    switch (size) {
      case CoreButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 24);
      case CoreButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 20);
      case CoreButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16);
    }
  }

  Color _getBackgroundColor({
    required bool isEnabled,
    required CoreButtonVariant variant,
  }) {
    if (!isEnabled) {
      return variant == CoreButtonVariant.secondary
          ? Colors.white.withOpacity(0.5)
          : CoreButtonColors.disable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
        return CoreButtonColors.surface;
      case CoreButtonVariant.secondary:
        return CoreTextColors.inverse;
      case CoreButtonVariant.social:
        return CoreTextColors.inverse;
    }
  }

  Color _getBorderColor(bool isEnabled, CoreButtonVariant variant) {
    if (!isEnabled) {
      return variant == CoreButtonVariant.secondary
          ? CoreTextColors.disable
          : CoreButtonColors.disable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
      case CoreButtonVariant.secondary:
        return CoreButtonColors.surface;
      case CoreButtonVariant.social:
        return CoreBorderColors.lineDarkOutline;
    }
  }

  Color _getContentColor({
    required bool isEnabled,
    required CoreButtonVariant variant,
  }) {
    if (!isEnabled) {
      return variant == CoreButtonVariant.secondary
          ? CoreTextColors.disable
          : CoreTextColors.body;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
        return CoreTextColors.inverse;
      case CoreButtonVariant.secondary:
        return CoreButtonColors.surface;
      case CoreButtonVariant.social:
        return CoreTextColors.headline;
    }
  }

  Widget _buildContentRow() {
    final isEnabled = !isDisabled && onPressed != null;
    final textWidget = Text(label,
        style: CoreTypography.bodyLargeSemiBold(
          color: _getContentColor(isEnabled: isEnabled, variant: variant),
        ));

    return Row(
      mainAxisAlignment:
          centerAlign ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        if (!trailing && icon != null) icon!,
        if (!trailing && icon != null && !spaceOut) const SizedBox(width: 8),
        if (spaceOut)
          Expanded(child: Center(child: textWidget))
        else
          textWidget,
        if (trailing && icon != null && !spaceOut) const SizedBox(width: 8),
        if (trailing && icon != null) icon!,
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEnabled = !isDisabled && onPressed != null;

    return Container(
      width: fullWidth ? double.infinity : null,
      height: variant == CoreButtonVariant.social ? null : _height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: _getBackgroundColor(
          isEnabled: isEnabled,
          variant: variant,
        ),
        border: Border.all(
          color: _getBorderColor(isEnabled, variant),
          width: variant == CoreButtonVariant.social ? 1 : 0,
        ),
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          splashColor: variant == CoreButtonVariant.primary
              ? CoreButtonColors.press
              : _getBackgroundColor(isEnabled: isEnabled, variant: variant),
          highlightColor: variant == CoreButtonVariant.primary
              ? CoreButtonColors.surface
              : _getBackgroundColor(isEnabled: isEnabled, variant: variant),
          onTap: isEnabled ? onPressed : null,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: variant == CoreButtonVariant.social
                ? const EdgeInsets.symmetric(vertical: 12, horizontal: 24)
                : _padding,
            child: _buildContentRow(),
          ),
        ),
      ),
    );
  }
}
