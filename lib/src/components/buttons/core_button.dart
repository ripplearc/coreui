import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Defines the size of the button.
enum CoreButtonSize {
  /// 48px height.
  large,

  /// 40px height.
  medium,

  /// 36px height.
  small,
}

/// Determines the presentation style of the button.
enum CoreButtonVariant {
  /// Default button style with a solid background.
  primary,

  /// Button with a white background and border.
  secondary,

  /// Button styled for social media actions.
  social,
}

/// A customizable button widget that supports flexible content.
///
/// Either [label] or [child] must be provided.
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

  /// Screen-reader hint announced after the label — what a tap does
  /// (`'Edits the rate'`). Pass a localised string; `null` announces none.
  final String? semanticsHint;

  /// Overrides the border colour the [variant] resolves for every state.
  /// `null` keeps the variant's own pressed / focused / resting colours.
  final Color? borderColor;

  /// Overrides the border width the [variant] resolves (`0` for
  /// [CoreButtonVariant.primary], `1` for [CoreButtonVariant.social], `2`
  /// for [CoreButtonVariant.secondary]). Pass
  /// [hairlineBorderWidth] for a chip-style 1 px edge.
  final double? borderWidth;

  /// A 1 px [borderWidth] — the hairline the chips and the display area's
  /// dependent-key pills draw (Figma Dependent Key Chip).
  static const double hairlineBorderWidth = 1;

  /// Width of the focus ring a focused [CoreButtonVariant.primary] draws.
  static const double focusRingWidth = 3;

  /// How far the outer edge of the focus ring sits outside the button. The
  /// 2 px between the button and the ring stay transparent (Figma Focus ring).
  static const double focusRingOffset = 5;

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
    this.semanticsHint,
    this.borderColor,
    this.borderWidth,
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
        return const EdgeInsets.symmetric(horizontal: CoreSpacing.space5);
      case CoreButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: CoreSpacing.space5);
      case CoreButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: CoreSpacing.space4);
    }
  }

  double get _defaultBorderWidth {
    switch (widget.variant) {
      case CoreButtonVariant.primary:
        return 0;
      case CoreButtonVariant.secondary:
        return 2;
      case CoreButtonVariant.social:
        return CoreButton.hairlineBorderWidth;
    }
  }

  Color _getBackgroundColor({
    required bool isEnabled,
    required CoreButtonVariant variant,
    required AppColorsExtension colors,
    required bool isDark,
  }) {
    if (!isEnabled) {
      switch (variant) {
        case CoreButtonVariant.primary:
          return colors.buttonDisable;
        case CoreButtonVariant.secondary:
        case CoreButtonVariant.social:
          return colors.transparent;
      }
    }
    switch (variant) {
      case CoreButtonVariant.primary:
        return isPressed ? colors.buttonPress : colors.buttonSurface;
      case CoreButtonVariant.secondary:
        if (widget.shadows == null) return colors.transparent;
        return isDark ? colors.backgroundGrayLight : colors.buttonInverse;
      case CoreButtonVariant.social:
        if (isPressed) return colors.backgroundGrayMid;
        return isDark ? colors.backgroundGrayLight : colors.buttonInverse;
    }
  }

  Color _getBorderColor(
    bool isEnabled,
    CoreButtonVariant variant,
    AppColorsExtension colors,
  ) {
    if (!isEnabled) {
      return variant == CoreButtonVariant.social
          ? colors.lineMid
          : colors.buttonDisable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
      case CoreButtonVariant.secondary:
        return isPressed ? colors.buttonPress : colors.buttonSurface;
      case CoreButtonVariant.social:
        return isFocused && !isPressed
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
      return variant == CoreButtonVariant.primary
          ? colors.textBody
          : colors.textDisable;
    }
    switch (variant) {
      case CoreButtonVariant.primary:
        return colors.textInverse;
      case CoreButtonVariant.secondary:
        return isPressed ? colors.buttonPress : colors.buttonSurface;
      case CoreButtonVariant.social:
        return colors.textHeadline;
    }
  }

  Widget _buildLabel(bool isEnabled, AppColorsExtension colors) {
    final child = widget.child;
    if (child != null) return child;

    final typography = Theme.of(context).coreTypography;
    final label = widget.label;
    final style = widget.variant == CoreButtonVariant.social
        ? typography.bodyLargeMedium
        : widget.size == CoreButtonSize.small
            ? typography.bodyMediumSemiBold
            : typography.bodyLargeSemiBold;

    return Text(
      label ?? '',
      style: style.copyWith(
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

  Widget _buildContentRow() {
    final colors = Theme.of(context).coreColors;
    final isEnabled = !widget.isDisabled && widget.onPressed != null;

    final labelWidget = _buildLabel(isEnabled, colors);
    final icon = widget.icon;

    if (widget.variant == CoreButtonVariant.social) {
      const logoWithGap = CoreSpacing.space6 + CoreSpacing.space2;
      final content = Stack(
        alignment: Alignment.center,
        children: [
          if (icon != null) Align(alignment: Alignment.centerLeft, child: icon),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: icon == null ? 0 : logoWithGap,
            ),
            child: labelWidget,
          ),
        ],
      );
      return widget.fullWidth ? content : IntrinsicWidth(child: content);
    }

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final buttonBody = DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        boxShadow: widget.shadows,
      ),
      child: Material(
        color: colors.transparent,
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          height: widget.variant == CoreButtonVariant.social ? null : _height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              color: _getBackgroundColor(
                isEnabled: isEnabled,
                variant: widget.variant,
                colors: colors,
                isDark: isDark,
              ),
              border: Border.all(
                color: widget.borderColor ??
                    _getBorderColor(isEnabled, widget.variant, colors),
                width: widget.borderWidth ?? _defaultBorderWidth,
              ),
            ),
            child: Padding(
              padding: widget.variant == CoreButtonVariant.social
                  ? const EdgeInsets.symmetric(
                      vertical: CoreSpacing.space3,
                      horizontal: CoreSpacing.space5,
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

    final showFocusRing = isFocused &&
        isEnabled &&
        (widget.variant == CoreButtonVariant.primary ||
            widget.variant == CoreButtonVariant.secondary);
    final buttonWithFocusRing = Stack(
      fit: StackFit.passthrough,
      clipBehavior: Clip.none,
      children: [
        buttonBody,
        if (showFocusRing)
          Positioned.fill(
            left: -CoreButton.focusRingOffset,
            top: -CoreButton.focusRingOffset,
            right: -CoreButton.focusRingOffset,
            bottom: -CoreButton.focusRingOffset,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    widget.borderRadius + CoreButton.focusRingOffset,
                  ),
                  border: Border.all(
                    color: colors.outlineFocus,
                    width: CoreButton.focusRingWidth,
                  ),
                ),
              ),
            ),
          ),
      ],
    );

    return Semantics(
      label: widget.semanticsLabel ?? widget.label,
      hint: widget.semanticsHint,
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
          child: buttonWithFocusRing,
        ),
      ),
    );
  }
}
