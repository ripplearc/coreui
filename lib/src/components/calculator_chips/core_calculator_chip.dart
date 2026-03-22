import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'core_calculator_chip_theme.dart';

/// The type variant of a [CoreCalculatorChip].
///
/// [editable] represents a state that can be interacted with, [disabled] is for
/// non-interactive states, and [active] is for highlighted or currently
/// selected states.
enum CoreCalculatorChipType {
  editable,
  disabled,
  active,
}

/// A chip component specifically designed for calculator or input-driven
/// interfaces. It displays a value and an optional label, supporting
/// interactive, disabled, and active states.
///
/// ## Types
/// [CoreCalculatorChipType.editable] is interactive and typically features a
/// shadow to indicate elevation.
/// [CoreCalculatorChipType.disabled] is non-interactive and visually muted.
/// [CoreCalculatorChipType.active] represents a highlighted or selected state.
///
/// ## Accessibility
/// Automatically provides a combined semantic label for [label] and [value].
///
/// ## Example
/// ```dart
/// CoreCalculatorChip(
///   type: CoreCalculatorChipType.editable,
///   label: 'Amount',
///   value: '123.45',
///   onTap: () => debugPrint('Chip tapped'),
///   withCloseIcon: true,
///   onClose: () => debugPrint('Close tapped'),
/// )
/// ```
class CoreCalculatorChip extends StatelessWidget {
  const CoreCalculatorChip({
    super.key,
    required this.type,
    required this.value,
    this.onTap,
    this.label,
    this.withCloseIcon = false,
    this.onClose,
  }) : assert(
          !(type == CoreCalculatorChipType.disabled && label == null),
          'Label must not be null when type is disabled',
        );

  /// The type variant determining the chip's visual and interactive behavior.
  final CoreCalculatorChipType type;

  /// An optional text label displayed before the [value].
  ///
  /// Must be non-null if [type] is [CoreCalculatorChipType.disabled].
  final String? label;

  /// The main text value displayed on the chip.
  final String value;

  /// Whether to show a close (×) icon.
  final bool withCloseIcon;

  /// Called when the user taps the close icon.
  final VoidCallback? onClose;

  /// Called when the user taps the chip.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final semanticsLabel = label != null ? '$label, $value' : value;

    return Semantics(
      label: semanticsLabel,
      button: true,
      container: true,
      enabled: type != CoreCalculatorChipType.disabled,
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: type != CoreCalculatorChipType.disabled ? onTap : null,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(
            colors.transparent,
          ),
          borderRadius: CoreCalculatorChipTheme.borderRadius,
          child: Container(
            padding: CoreCalculatorChipTheme.padding,
            decoration: BoxDecoration(
              color: CoreCalculatorChipTheme.background(
                type: type,
                colors: colors,
              ),
              borderRadius: CoreCalculatorChipTheme.borderRadius,
              boxShadow: CoreCalculatorChipTheme.shadow(type),
              border: Border.fromBorderSide(
                BorderSide(
                    color: CoreCalculatorChipTheme.borderColor(
                      type: type,
                      colors: colors,
                    ),
                    width: CoreCalculatorChipTheme.borderWidth),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (withCloseIcon && type != CoreCalculatorChipType.disabled)
                  Semantics(
                    button: true,
                    label: 'Close $semanticsLabel',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onClose,
                      child: Center(
                        child: CoreIconWidget(
                          icon: CoreIcons.cross,
                          size: CoreSpacing.space5,
                          color: CoreCalculatorChipTheme.iconColor(
                            type: type,
                            colors: colors,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (label != null)
                  ExcludeSemantics(
                    child: Text(
                      label,
                      style: CoreCalculatorChipTheme.labelStyle(
                        type: type,
                        colors: colors,
                        typography: typography,
                      ),
                    ),
                  ),
                const SizedBox(width: CoreSpacing.space1),
                ExcludeSemantics(
                  child: Text(
                    value,
                    style: CoreCalculatorChipTheme.valueStyle(
                      type: type,
                      colors: colors,
                      typography: typography,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
