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
/// [focusNode] used to control button focus state
/// [autofocus] determines whether the button should be auto focused
class CoreButton extends StatefulWidget {
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
  final bool autofocus;
  final FocusNode? focusNode;

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
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<CoreButton> createState() => _CoreButtonState();
}

class _CoreButtonState extends State<CoreButton> {
  bool isPressed = false;
  bool isFocused = false;
  late FocusNode _focusNode;

  double get _height {
    switch (widget.size) {
      case CoreButtonSize.large:
        return 48;
      case CoreButtonSize.medium:
        return 40;
      case CoreButtonSize.small:
        return 36;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
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
          ? Colors.transparent
          : CoreButtonColors.disable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
        return isPressed
            ? CoreButtonColors.press
            : isFocused
                ? CoreButtonColors.hover
                : CoreButtonColors.surface;
      case CoreButtonVariant.secondary:
        return Colors.transparent;
      case CoreButtonVariant.social:
        return CoreTextColors.inverse;
    }
  }

  Color _getBorderColor(bool isEnabled, CoreButtonVariant variant) {
    if (!isEnabled) {
      return CoreButtonColors.disable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
      case CoreButtonVariant.secondary:
        return isPressed
            ? CoreButtonColors.press
            : isFocused
                ? CoreButtonColors.hover
                : CoreButtonColors.surface;
      case CoreButtonVariant.social:
        return isPressed
            ? CoreBorderColors.outlineHover
            : isFocused
                ? CoreBorderColors.lineDarkOutline
                : CoreBorderColors.lineMid;
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
        return isPressed
            ? CoreButtonColors.press
            : isFocused
                ? CoreButtonColors.hover
                : CoreButtonColors.surface;
      case CoreButtonVariant.social:
        return CoreTextColors.headline;
    }
  }

  Widget _buildContentRow() {
    final isEnabled = !widget.isDisabled && widget.onPressed != null;
    final textWidget = Text(widget.label,
        style: CoreTypography.bodyLargeSemiBold(
          color:
              _getContentColor(isEnabled: isEnabled, variant: widget.variant),
        ));
    return Row(
      mainAxisAlignment: (widget.centerAlign && !widget.spaceOut)
          ? MainAxisAlignment.center
          : (widget.centerAlign && widget.spaceOut)
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
      children: [
        if (!widget.trailing && widget.icon != null) widget.icon!,
        if (!widget.trailing && widget.icon != null && !widget.spaceOut)
          const SizedBox(width: 8),
        if (widget.trailing && widget.spaceOut)
          const SizedBox(width: 24, height: 24),
        textWidget,
        if (widget.trailing && widget.icon != null && !widget.spaceOut)
          const SizedBox(width: 8),
        if (widget.trailing && widget.icon != null) widget.icon!,
        if (!widget.trailing && widget.spaceOut)
          const SizedBox(width: 24, height: 24),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    isFocused = widget.autofocus;
    _focusNode.addListener(() {
      setState(() {
        isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == CoreButtonVariant.social &&
        widget.size != CoreButtonSize.large) {
      throw ArgumentError('Social button variant must be large size');
    }
    final isEnabled = !widget.isDisabled && widget.onPressed != null;

    return Focus(
      focusNode: _focusNode,
      autofocus: widget.autofocus,
      onFocusChange: (focused) => setState(() => isFocused = focused),
      child: GestureDetector(
        onTap: isEnabled ? widget.onPressed : null,
        onTapDown: isEnabled ? (_) => setState(() => isPressed = true) : null,
        onTapUp: isEnabled ? (_) => setState(() => isPressed = false) : null,
        onTapCancel: isEnabled ? () => setState(() => isPressed = false) : null,
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          height: widget.variant == CoreButtonVariant.social ? null : _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: _getBackgroundColor(
              isEnabled: isEnabled,
              variant: widget.variant,
            ),
            border: Border.all(
              color: _getBorderColor(isEnabled, widget.variant),
              width: widget.variant == CoreButtonVariant.primary
                  ? widget.variant == CoreButtonVariant.social
                      ? 1
                      : 0
                  : 2,
            ),
          ),
          child: Padding(
            padding: widget.variant == CoreButtonVariant.social
                ? const EdgeInsets.symmetric(vertical: 12, horizontal: 24)
                : _padding,
            child: _buildContentRow(),
          ),
        ),
      ),
    );
  }
}
