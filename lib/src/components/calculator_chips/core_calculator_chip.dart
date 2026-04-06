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
///   factor: CoreIcons.addOperator,
/// )
/// ```
class CoreCalculatorChip extends StatelessWidget {
  const CoreCalculatorChip({
    super.key,
    required this.type,
    this.value,
    this.onTap,
    this.label,
    this.factor,
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

  /// The value displayed on the chip.
  final String? value;

  /// An optional factor icon (e.g., +, -, x) displayed before the chip content.
  final CoreIconData? factor;

  /// Called when the user taps the chip.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final value = this.value;
    final factor = this.factor;
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final semanticsParts = [
      if (label != null && label.isNotEmpty) label,
      if (value != null && value.isNotEmpty) value,
    ];
    final semanticsLabel = semanticsParts.join(', ');

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
                if (factor != null && type != CoreCalculatorChipType.disabled)
                  Center(
                    child: CoreIconWidget(
                      icon: factor,
                      size: CoreSpacing.space5,
                      color: CoreCalculatorChipTheme.factorColor(
                        type: type,
                        colors: colors,
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
                if (value != null) ...[
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
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
