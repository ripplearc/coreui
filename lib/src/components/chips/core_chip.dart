// ignore_for_file: avoid_static_colors
import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'core_chip_theme.dart';

/// The size variant of a [CoreChip].
///
/// [small] and [medium] share the same visual appearance (light grey
/// background, no shadow). [large] uses a white/inverse background with a
/// drop shadow.
enum CoreChipSize {
  small,
  medium,
  large,
}

/// A selectable chip that supports three sizes, an optional leading icon,
/// a persistent close (×) button, and animated visual feedback for default,
/// pressed, and selected states.
///
/// ## Sizes
/// [CoreChipSize.small] and [CoreChipSize.medium] share the same visual.
/// [CoreChipSize.large] uses a white surface with a drop shadow.
///
/// ## State ownership
/// The caller owns **selection** via [selected] ([ValueNotifier<bool>]).
/// The ephemeral pressed state is managed internally.
///
/// ## Example
/// ```dart
/// final isSelected = ValueNotifier<bool>(false);
///
/// CoreChip(
///   label: 'Filter',
///   selected: isSelected,
///   size: CoreChipSize.medium,
///   icon: CoreIcons.check,
///   onTap: () => debugPrint('toggled'),
///   onRemove: () => debugPrint('removed'),
/// )
/// ```
class CoreChip extends StatefulWidget {
  const CoreChip({
    super.key,
    required this.label,
    required this.selected,
    this.size = CoreChipSize.medium,
    this.icon,
    this.onTap,
    this.onRemove,
    this.withCloseIcon = false,
    this.focusNode,
    this.autofocus = false,
  });

  /// An optional focus node to use as the focus node for this widget.
  final FocusNode? focusNode;

  /// True if this widget will be selected as the initial focus when no other
  /// node in its scope is currently focused.
  final bool autofocus;

  /// The text label displayed on the chip.
  final String label;

  /// Controls and reflects the selected state of the chip.
  ///
  /// The chip toggles this value on tap and notifies [onTap] afterwards.
  final ValueNotifier<bool> selected;

  /// The size variant of the chip. Defaults to [CoreChipSize.medium].
  final CoreChipSize size;

  /// Optional leading icon displayed before the label.
  final CoreIconData? icon;

  /// Called after the chip is tapped and [selected] has been toggled.
  final VoidCallback? onTap;

  /// Called when the user taps the close (×) icon.
  ///
  /// The caller is responsible for removing the chip from the widget tree.
  final VoidCallback? onRemove;

  final bool withCloseIcon;

  @override
  State<CoreChip> createState() => _CoreChipState();
}

class _CoreChipState extends State<CoreChip> {
  final ValueNotifier<bool> _pressed = ValueNotifier(false);
  late final FocusNode _focusNode;
  final ValueNotifier<bool> _focused = ValueNotifier(false);

  void _handleTap() {
    widget.selected.value = !widget.selected.value;
    widget.onTap?.call();
  }

  void _handleFocusChange() {
    _focused.value = _focusNode.hasFocus;
  }

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_handleFocusChange);
    _focused.value = _focusNode.hasFocus;
  }

  @override
  void dispose() {
    _pressed.dispose();
    _focusNode.removeListener(_handleFocusChange);
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    _focused.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final chipRadius = BorderRadius.circular(CoreSpacing.space6);
    return ValueListenableBuilder<bool>(
      valueListenable: widget.selected,
      builder: (context, isSelected, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: _pressed,
          builder: (context, isPressed, __) {
            return ValueListenableBuilder<bool>(
              valueListenable: _focused,
              builder: (context, isFocused, ___) {
                return Semantics(
                  label: widget.label,
                  button: true,
                  container: true,
                  selected: isSelected,
                  child: Material(
                    color: Colors.transparent, // ignore: avoid_static_colors
                    child: InkWell(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: WidgetStateProperty.all(
                        // ignore: avoid_static_colors
                        Colors.transparent,
                      ),
                      focusNode: _focusNode,
                      autofocus: widget.autofocus,
                      onFocusChange: (value) => _focused.value = value,
                      onHighlightChanged: (value) => _pressed.value = value,
                      borderRadius: chipRadius,
                      onTap: _handleTap,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: CoreSpacing.space2,
                        ),
                        child: AnimatedContainer(
                          duration: CoreChipTheme.animationDuration,
                          padding: CoreChipTheme.padding(widget.size),
                          decoration: BoxDecoration(
                            color: CoreChipTheme.background(
                              size: widget.size,
                              isSelected: isSelected,
                              isPressed: isPressed,
                              isFocused: isFocused,
                              colors: colors,
                            ),
                            borderRadius: chipRadius,
                            border: Border.fromBorderSide(
                              BorderSide(
                                color: CoreChipTheme.borderColor(
                                  size: widget.size,
                                  isSelected: isSelected,
                                  isPressed: isPressed,
                                  isFocused: isFocused,
                                  colors: colors,
                                ),
                                width: CoreChipTheme.borderWidthFor(
                                  isFocused: isFocused,
                                ),
                              ),
                            ),
                            boxShadow: CoreChipTheme.shadow(widget.size),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon case final icon?) ...[
                                CoreIconWidget(
                                  icon: icon,
                                  size: CoreSpacing.space5,
                                  color: colors.outlineFocus,
                                ),
                                const SizedBox(width: CoreSpacing.space2),
                              ],
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: CoreSpacing.space2,
                                ),
                                child: ExcludeSemantics(
                                  child: Text(
                                    widget.label,
                                    style: typography.bodyMediumRegular,
                                  ),
                                ),
                              ),
                              if (widget.withCloseIcon &&
                                  widget.onRemove != null)
                                Semantics(
                                  button: true,
                                  label: 'Remove ${widget.label}',
                                  child: GestureDetector(
                                    behavior: HitTestBehavior.opaque,
                                    key: const Key('close_icon'),
                                    onTap: widget.onRemove,
                                    child: CoreIconWidget(
                                      icon: CoreIcons.close,
                                      size: CoreSpacing.space5,
                                      color: colors.iconGrayMid,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
