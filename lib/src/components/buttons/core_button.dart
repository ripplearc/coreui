import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

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
/// - [social]: Button styled for social media actions.
enum CoreButtonVariant { primary, secondary, social }

/// A customizable button widget that supports flexible content.
/// Either [label] or [child] must be provided.
///
/// - [label] is the text displayed on the button.
/// - [child] is an optional custom widget displayed in place of the label.
/// - [onPressed] is the callback function when the button is pressed.
/// - [size] determines the height of the button.
/// - [variant] determines the button's style.
/// - [icon] is an optional icon displayed on the button.
/// - [isDisabled] indicates whether the button is disabled.
/// - [fullWidth] makes the button take the full width of its parent.
/// - [borderRadius] sets the button's border radius.
/// - [centerAlign] aligns the content in the center.
/// - [spaceOut] adds spacing between the icon and text.
/// - [trailing] places the icon at the end of the button.
/// - [shadows] is an optional list of box shadows applied to the button.
/// - [semanticsLabel] overrides the accessible label; defaults to [label].
/// - [focusNode] used to control button focus state.
/// - [autofocus] determines whether the button should be auto focused.
class CoreButton extends StatefulWidget {
  final String? label;
  final Widget? child;
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
  final List<BoxShadow>? shadows;
  final String? semanticsLabel;

  const CoreButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.size = CoreButtonSize.large,
    this.variant = CoreButtonVariant.primary,
    this.icon,
    this.isDisabled = false,
    this.fullWidth = true,
    this.borderRadius = CoreSpacing.space10,
    this.spaceOut = false,
    this.trailing = false,
    this.centerAlign = true,
    this.focusNode,
    this.autofocus = false,
    this.shadows,
    this.semanticsLabel,
  }) : assert(
          label != null || child != null,
          'Either label or child must be provided',
        );

  @override
  State<CoreButton> createState() => _CoreButtonState();
}

class _CoreButtonState extends State<CoreButton> {
  bool isPressed = false;
  bool isFocused = false;

  late FocusNode _focusNode;
  late final bool _isExternalFocusNode;

  double get _height {
    switch (widget.size) {
      case CoreButtonSize.large:
        return CoreSpacing.space12;
      case CoreButtonSize.medium:
        return CoreSpacing.space10;
      case CoreButtonSize.small:
        return CoreSpacing.space9;
    }
  }

  EdgeInsets get _padding {
    switch (widget.size) {
      case CoreButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: CoreSpacing.space6);
      case CoreButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: CoreSpacing.space5);
      case CoreButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: CoreSpacing.space4);
    }
  }

  Color _getBackgroundColor({
    required bool isEnabled,
    required CoreButtonVariant variant,
    required AppColorsExtension colors,
  }) {
    if (!isEnabled) {
      return variant == CoreButtonVariant.secondary
          ? colors.buttonInverse
          : colors.buttonDisable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
        return isPressed
            ? colors.buttonPress
            : isFocused
                ? colors.buttonHover
                : colors.buttonSurface;
      case CoreButtonVariant.secondary:
        return colors.transparent;
      case CoreButtonVariant.social:
        return colors.textInverse;
    }
  }

  Color _getBorderColor(
    bool isEnabled,
    CoreButtonVariant variant,
    AppColorsExtension colors,
  ) {
    if (!isEnabled) {
      return colors.buttonDisable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
      case CoreButtonVariant.secondary:
        return isPressed
            ? colors.buttonPress
            : isFocused
                ? colors.buttonHover
                : colors.buttonSurface;
      case CoreButtonVariant.social:
        return isPressed
            ? colors.outlineHover
            : isFocused
                ? colors.lineDarkOutline
                : colors.lineMid;
    }
  }

  Color _getContentColor({
    required bool isEnabled,
    required CoreButtonVariant variant,
    required AppColorsExtension colors,
  }) {
    if (!isEnabled) {
      return variant == CoreButtonVariant.secondary
          ? colors.textDisable
          : colors.textBody;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
        return colors.textInverse;
      case CoreButtonVariant.secondary:
        return isPressed
            ? colors.buttonPress
            : isFocused
                ? colors.buttonHover
                : colors.buttonSurface;
      case CoreButtonVariant.social:
        return colors.textHeadline;
    }
  }

  // Builds the label text or returns the custom child if provided.
  Widget _buildLabel(bool isEnabled, AppColorsExtension colors) {
    final child = widget.child;
    if (child != null) return child;

    final typography = Theme.of(context).coreTypography;
    final label = widget.label;

    return Text(
      label ?? '',
      style: typography.bodyLargeSemiBold.copyWith(
        color: _getContentColor(
          isEnabled: isEnabled,
          variant: widget.variant,
          colors: colors,
        ),
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  // Builds the internal content row including icon and label/child.
  Widget _buildContentRow() {
    final colors = Theme.of(context).coreColors;
    final isEnabled = !widget.isDisabled && widget.onPressed != null;

    final labelWidget = _buildLabel(isEnabled, colors);
    final icon = widget.icon;

    return Row(
      mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: (widget.centerAlign && !widget.spaceOut)
          ? MainAxisAlignment.center
          : (widget.centerAlign && widget.spaceOut)
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
      children: [
        if (!widget.trailing && icon != null) icon,
        if (!widget.trailing && icon != null && !widget.spaceOut)
          const SizedBox(width: CoreSpacing.space2),
        if (widget.trailing && widget.spaceOut)
          const SizedBox(width: CoreSpacing.space6, height: CoreSpacing.space6),
        Flexible(
          fit: FlexFit.loose,
          child: labelWidget,
        ),
        if (widget.trailing && icon != null && !widget.spaceOut)
          const SizedBox(width: CoreSpacing.space2),
        if (widget.trailing && icon != null) icon,
        if (!widget.trailing && widget.spaceOut)
          const SizedBox(width: CoreSpacing.space6, height: CoreSpacing.space6),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _isExternalFocusNode = widget.focusNode != null;
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
    if (!_isExternalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == CoreButtonVariant.social &&
        widget.size != CoreButtonSize.large) {
      throw ArgumentError('Social button variant must be large size');
    }

    final isEnabled = !widget.isDisabled && widget.onPressed != null;
    final colors = Theme.of(context).coreColors;

    final buttonBody = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.shadows,
      ),
      child: Material(
        color: colors.transparent,
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          height: _height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: _getBackgroundColor(
                isEnabled: isEnabled,
                variant: widget.variant,
                colors: colors,
              ),
              border: Border.all(
                color: _getBorderColor(isEnabled, widget.variant, colors),
                width: widget.variant == CoreButtonVariant.primary ? 0 : 2,
              ),
            ),
            child: Padding(
              padding: widget.variant == CoreButtonVariant.social
                  ? const EdgeInsets.symmetric(
                      vertical: CoreSpacing.space3,
                      horizontal: CoreSpacing.space6,
                    )
                  : _padding,
              child: Center(
                widthFactor: widget.fullWidth ? null : 1.0,
                child: _buildContentRow(),
              ),
            ),
          ),
        ),
      ),
    );

    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      button: true,
      enabled: isEnabled,
      // Exclude semantics from children to ensure the button is treated as a
      // single interactive unit with a clean label, preventing icons or
      // formatted text fragments from being read individually.
      excludeSemantics: true,
      child: Focus(
        focusNode: _focusNode,
        autofocus: widget.autofocus,
        onFocusChange: (focused) => setState(() => isFocused = focused),
        child: GestureDetector(
          onTap: isEnabled ? widget.onPressed : null,
          onTapDown: isEnabled ? (_) => setState(() => isPressed = true) : null,
          onTapUp: isEnabled ? (_) => setState(() => isPressed = false) : null,
          onTapCancel:
              isEnabled ? () => setState(() => isPressed = false) : null,
          child: buttonBody,
        ),
      ),
    );
  }
}
