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
  /// Keeps the tape's button semantics on purpose: like every variant but
  /// [disabled] it stays interactive, so the app can attach a repair action
  /// to [CoreCalculatorChip.onTap] or [CoreCalculatorChip.onLongPress].
  error,

  /// A bracket the user is still typing inside. One chip holds the operator
  /// before the bracket (the [CoreCalculatorChip.factor]) and everything
  /// typed inside it, drawn without its closing bracket: `+(3×4`. The live
  /// green fill of [active] under a dashed teal edge.
  bracketOpen,

  /// A closed bracket, drawn with its closing bracket: `+(3×4)`. Solid teal
  /// edge on a blue fill; a tap reopens it for editing.
  bracketClosed,

  /// An answer that is out of date because a chip before it is being edited:
  /// a reopened bracket, or a value changed in place. The [result] fill under
  /// a dashed grey edge, showing [CoreCalculatorChip.stalePlaceholder] in
  /// place of a number so no out-of-date figure can be read; the label
  /// (`Calc`) stays. Takes no [CoreCalculatorChip.value].
  stale,
}

/// A chip component specifically designed for calculator or input-driven
/// interfaces. It displays a value and an optional label and takes one of
/// the [CoreCalculatorChipType] looks.
///
/// ## Brackets
/// A bracket is one chip from its first key to its last (UX design doc, term
/// 2.22). The chip draws the brackets itself, so [value] is what sits inside
/// them: `3×4` renders as `(3×4` while [CoreCalculatorChipType.bracketOpen]
/// and as `(3×4)` once [CoreCalculatorChipType.bracketClosed]. The missing
/// closing bracket is what tells the open chip from the closed one, so it
/// cannot be left to the caller to remember.
///
/// While a bracket is open the chips before it wait, and while a reopened
/// bracket is edited the chips after it wait too: [inert] dims a chip of any
/// type and makes it ignore taps until the bracket closes, and an answer after
/// a reopened bracket takes [CoreCalculatorChipType.stale] so its number is
/// replaced by [stalePlaceholder] (UX design doc Section 7, "Editing a
/// bracket"; walkthrough 12.8).
///
/// ## Interaction
/// Every variant except [CoreCalculatorChipType.disabled] responds to [onTap]
/// and [onLongPress] unless it is [inert]. Long-press is how the calculator
/// opens provenance for a result; the callback is the whole contract, so the
/// app can also offer the same action through a menu.
///
/// ## Accessibility
/// Automatically provides a combined semantic label for [label] and [value],
/// and exposes [longPressSemanticLabel] as the long-press hint while
/// [onLongPress] is set. A bracket's state lives in punctuation a screen
/// reader skips and coreui has no localised words of its own, so a bracket
/// chip left without a [semanticsLabel] announces only what is inside it: the
/// app must pass [semanticsLabel] to say the state in words
/// ("open bracket, 3 times 4") and [tapSemanticLabel] to say what a tap does
/// ("reopen the bracket"). A stale answer's placeholder is a dash a screen
/// reader skips too, so the app passes [semanticsLabel] for it as well
/// ("Calc, pending"). An [inert] chip reports itself disabled and carries no
/// tap or long-press action. It is dimmed to
/// [CoreCalculatorChipTheme.inertOpacity], chosen so the dimmed text keeps at
/// least the 3:1 contrast WCAG 1.4.11 asks of a user-interface component;
/// WCAG 1.4.3 exempts an inactive control from the 4.5:1 text floor.
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
    this.tapSemanticLabel,
    this.onLongPress,
    this.longPressSemanticLabel,
    this.semanticsLabel,
    this.label,
    this.factor,
    this.inert = false,
  })  : assert(
          !(type == CoreCalculatorChipType.disabled && label == null),
          'Label must not be null when type is disabled',
        ),
        assert(
          !(type == CoreCalculatorChipType.stale && value != null),
          'A stale chip shows the placeholder; pass no value',
        ),
        assert(
          !(type == CoreCalculatorChipType.bracketClosed && value == null),
          'A closed bracket holds what was typed inside it; pass a value',
        ),
        assert(
          tapSemanticLabel == null || onTap != null,
          'tapSemanticLabel needs an onTap to describe',
        ),
        assert(
          longPressSemanticLabel == null || onLongPress != null,
          'longPressSemanticLabel needs an onLongPress to describe',
        );

  /// What a [CoreCalculatorChipType.stale] chip shows in place of its number.
  static const String stalePlaceholder = '—';

  /// The type variant determining the chip's visual and interactive behavior.
  final CoreCalculatorChipType type;

  /// An optional text label displayed before the [value].
  ///
  /// Must be non-null if [type] is [CoreCalculatorChipType.disabled].
  final String? label;

  /// The value displayed on the chip. For the bracket variants, the text
  /// inside the brackets; the chip draws the brackets. Must be null for
  /// [CoreCalculatorChipType.stale], which shows [stalePlaceholder].
  final String? value;

  /// An optional factor icon (e.g., +, -, ×) displayed before the chip content.
  ///
  /// Not rendered when [type] is [CoreCalculatorChipType.disabled].
  final CoreIconData? factor;

  /// Called when the user taps the chip.
  ///
  /// Ignored when [type] is [CoreCalculatorChipType.disabled].
  final VoidCallback? onTap;

  /// Screen-reader hint for the tap action (announced as "double tap to …").
  /// Requires [onTap] and is withheld while the chip ignores taps. A closed
  /// bracket reopens on tap, which its look says and its label cannot:
  /// ```dart
  /// tapSemanticLabel: AppLocalizations.of(context).reopenBracket,
  /// ```
  final String? tapSemanticLabel;

  /// Called when the user long-presses the chip.
  ///
  /// Ignored when [type] is [CoreCalculatorChipType.disabled].
  final VoidCallback? onLongPress;

  /// Screen-reader hint for the long-press action (announced as "double tap
  /// and hold to …"). Requires [onLongPress] and is withheld while the chip
  /// is [CoreCalculatorChipType.disabled].
  ///
  /// Pass a localised string from the app layer:
  /// ```dart
  /// longPressSemanticLabel: AppLocalizations.of(context).showProvenance,
  /// ```
  final String? longPressSemanticLabel;

  /// Replaces the label a screen reader is given, which is otherwise built
  /// from [label] and [displayedValue]. Pass a localised string from the app
  /// layer.
  ///
  /// The bracket variants must be given one: their state is the `)` a screen
  /// reader skips, so without it an open and a closed bracket announce the
  /// same text. The app says it in words — "open bracket, 3 times 4" /
  /// "bracket, 3 times 4".
  final String? semanticsLabel;

  /// Whether the chip is waiting on an open bracket: dimmed, deaf to [onTap]
  /// and [onLongPress], and reported disabled to a screen reader, while
  /// keeping the look of its [type] — a `×5` keeps its operator and an answer
  /// keeps its label. Unlike [CoreCalculatorChipType.disabled] it is a state
  /// over any type, not a look of its own. Defaults to `false`.
  final bool inert;

  bool get _isInteractive => type != CoreCalculatorChipType.disabled;

  bool get _acceptsInput => _isInteractive && !inert;

  /// The text the chip draws for [value]: the value itself, or the value
  /// inside its brackets for the bracket variants. The semantics label reads
  /// the same text.
  @visibleForTesting
  String? get displayedValue => switch (type) {
        CoreCalculatorChipType.bracketOpen => '(${value ?? ''}',
        CoreCalculatorChipType.bracketClosed => '(${value ?? ''})',
        CoreCalculatorChipType.stale => stalePlaceholder,
        _ => value,
      };

  /// The opacity the chip is drawn at: [CoreCalculatorChipTheme.inertOpacity]
  /// while [inert], otherwise fully opaque.
  @visibleForTesting
  double get effectiveOpacity =>
      inert ? CoreCalculatorChipTheme.inertOpacity : 1;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final value = displayedValue;
    final factor = this.factor;
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final semanticsLabel = this.semanticsLabel ??
        (label != null
            ? '$label${value != null ? ', $value' : ''}'
            : value ?? 'Factor chip');
    final effectiveOnTap = _acceptsInput ? onTap : null;
    final effectiveOnLongPress = _acceptsInput ? onLongPress : null;
    final hasLeading = (factor != null && _isInteractive) || label != null;

    return Semantics(
      label: semanticsLabel,
      button: true,
      container: true,
      enabled: _acceptsInput,
      onTapHint: effectiveOnTap != null ? tapSemanticLabel : null,
      onLongPressHint:
          effectiveOnLongPress != null ? longPressSemanticLabel : null,
      child: Opacity(
        opacity: effectiveOpacity,
        child: Material(
          color: colors.transparent,
          child: InkWell(
            onTap: effectiveOnTap,
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
                    if (hasLeading) const SizedBox(width: CoreSpacing.space1),
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
      ),
    );
  }
}
