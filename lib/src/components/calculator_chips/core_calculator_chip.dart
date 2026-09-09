import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'core_calculator_chip_theme.dart';

/// The type variant of a [CoreCalculatorChip].
///
/// On the calculator tape an outlined chip is something the user typed and a
/// filled chip is something the app worked out; the remaining variants mark
/// the in-between states (entry in progress, a tentative value, a mistake).
enum CoreCalculatorChipType {
  /// A value the user typed. Outlined, interactive.
  editable,

  /// Non-interactive, muted. Ignores [CoreCalculatorChip.onTap] and
  /// [CoreCalculatorChip.onLongPress]; requires a label.
  disabled,

  /// The value currently being entered. Highlighted.
  active,

  /// An answer the app computed. Filled; stays interactive so a long-press
  /// can open provenance (which chips produced it).
  result,

  /// A tentative value — a bind offer ("Height: 8ft ?") or a chip being
  /// edited in place. Dashed outline.
  dashed,

  /// A dimension error ("area + length") the user repairs with backspace.
  error,
}

/// A chip component specifically designed for calculator or input-driven
/// interfaces. It displays a value and an optional label and takes one of
/// six [CoreCalculatorChipType] looks.
///
/// ## Interaction
/// Every variant except [CoreCalculatorChipType.disabled] responds to [onTap]
/// and [onLongPress]. Long-press is how the calculator opens provenance for a
/// result; the callback is the whole contract, so the app can also offer the
/// same action through a menu.
///
/// ## Accessibility
/// Automatically provides a combined semantic label for [label] and [value],
/// and exposes [longPressSemanticLabel] as the long-press hint while
/// [onLongPress] is set.
///
/// ## Example
/// ```dart
/// CoreCalculatorChip(
///   type: CoreCalculatorChipType.result,
///   label: 'Area',
///   value: '410.67ft²',
///   onLongPress: () => showProvenance(),
///   longPressSemanticLabel: 'show which chips produced this result',
/// )
/// ```
class CoreCalculatorChip extends StatelessWidget {
  const CoreCalculatorChip({
    super.key,
    required this.type,
    this.value,
    this.onTap,
    this.onLongPress,
    this.longPressSemanticLabel,
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

  /// An optional factor icon (e.g., +, -, ×) displayed before the chip content.
  ///
  /// Not rendered when [type] is [CoreCalculatorChipType.disabled].
  final CoreIconData? factor;

  /// Called when the user taps the chip.
  ///
  /// Ignored when [type] is [CoreCalculatorChipType.disabled].
  final VoidCallback? onTap;

  /// Called when the user long-presses the chip.
  ///
  /// Ignored when [type] is [CoreCalculatorChipType.disabled].
  final VoidCallback? onLongPress;

  /// Screen-reader hint for the long-press action (announced as "double tap
  /// and hold to …"). Exposed only while [onLongPress] is set.
  ///
  /// Pass a localised string from the app layer:
  /// ```dart
  /// longPressSemanticLabel: AppLocalizations.of(context).showProvenance,
  /// ```
  final String? longPressSemanticLabel;

  bool get _isInteractive => type != CoreCalculatorChipType.disabled;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final value = this.value;
    final factor = this.factor;
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final semanticsLabel = label != null
        ? '$label${value != null ? ', $value' : ''}'
        : value ?? 'Factor chip';
    final effectiveOnLongPress = _isInteractive ? onLongPress : null;

    return Semantics(
      label: semanticsLabel,
      button: true,
      container: true,
      enabled: _isInteractive,
      onLongPressHint:
          effectiveOnLongPress != null ? longPressSemanticLabel : null,
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: _isInteractive ? onTap : null,
          onLongPress: effectiveOnLongPress,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(
            colors.transparent,
          ),
          borderRadius: CoreCalculatorChipTheme.borderRadius,
          child: Container(
            padding: CoreCalculatorChipTheme.padding,
            foregroundDecoration: CoreCalculatorChipTheme.dashedOutline(
              type: type,
              colors: colors,
            ),
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
                if (factor != null && _isInteractive)
                  ExcludeSemantics(
                    child: Center(
                      child: CoreIconWidget(
                        icon: factor,
                        size: CoreSpacing.space5,
                        color: CoreCalculatorChipTheme.factorColor(
                            type: type, colors: colors),
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
