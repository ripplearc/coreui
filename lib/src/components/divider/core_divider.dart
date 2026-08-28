import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A 1px hairline rule that separates content, wired to the CoreUI theme.
///
/// Replaces the hand-tokened Material [Divider] call sites in the consuming
/// app, which each re-applied the same hairline recipe (`thickness: 1`,
/// `lineLight`) with private constants.
///
/// ### Sizing
/// The rule is exactly [thickness] tall and owns no whitespace of its own:
/// unlike Material's [Divider], whose default 16px `height` hides vertical
/// rhythm inside the widget, all spacing around a [CoreDivider] is the
/// caller's job, made explicit with [CoreSpacing] tokens. Horizontally it
/// expands to fill its parent, minus [indent] and [endIndent].
///
/// In a `Row` via `Expanded` — the label-separator composition on the auth
/// pages — the rule adds no vertical extent of its own, so the row is sized
/// by the text alone. Material's `Divider` also paints its line centered at
/// any height; the hairline height removes the hidden slot, not a centering
/// defect.
///
/// ### Where the defaults come from
/// Measured from the two consumer call-site families named in CA-1016, not
/// chosen freehand:
///
/// | Call site                              | Thickness | Color       |
/// |----------------------------------------|-----------|-------------|
/// | Search results end-of-results footer   | 1         | `lineLight` |
/// | Auth pages "or" separator rows (x2)    | 1         | `lineLight` |
///
/// Caveat: the table measures the consuming app's *code*. CA-1016 points at
/// the Figma pagination-footer frame (`65869:151824`) as the design source;
/// the values here are code-derived and have not been verified against that
/// frame directly.
///
/// ### Theming
/// The hairline color resolves from the theme extension, so the rule tracks
/// [CoreTheme.light] and [CoreTheme.dark] without per-site work. Ambient
/// [DividerTheme]s are deliberately ignored: every Material [Divider]
/// parameter is pinned, so a consuming app's `DividerThemeData` cannot
/// restyle the rule.
///
/// ### Accessibility
/// The rule is purely decorative and exposes no semantic node, matching
/// Material's [Divider].
///
/// ---
/// ## Examples
///
/// ### 1) Full-bleed rule above a list footer
/// ```dart
/// Column(
///   children: [
///     const CoreDivider(),
///     const SizedBox(height: CoreSpacing.space6),
///     footerCaption,
///   ],
/// )
/// ```
///
/// ### 2) Inset rule
/// ```dart
/// CoreDivider(
///   indent: CoreSpacing.space4,
///   endIndent: CoreSpacing.space4,
/// )
/// ```
///
/// ### 3) Label separator
/// ```dart
/// Row(
///   children: [
///     const Expanded(child: CoreDivider()),
///     Padding(
///       padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space2),
///       child: Text(context.l10n.or),
///     ),
///     const Expanded(child: CoreDivider()),
///   ],
/// )
/// ```
class CoreDivider extends StatelessWidget {
  /// Overrides the hairline color.
  ///
  /// Defaults to the theme extension's `lineLight`.
  final Color? color;

  /// Empty space to the leading edge of the rule.
  ///
  /// Pass a [CoreSpacing] token. Defaults to zero (full bleed).
  final double indent;

  /// Empty space to the trailing edge of the rule.
  ///
  /// Pass a [CoreSpacing] token. Defaults to zero (full bleed).
  final double endIndent;

  /// The rule's thickness, which is also its total layout height.
  ///
  /// One logical pixel — not Flutter's `thickness: 0` device-pixel hairline —
  /// so high-DPR screens paint it several device pixels tall, matching the
  /// migrated call sites.
  static const double thickness = 1.0;

  const CoreDivider({
    super.key,
    this.color,
    this.indent = 0,
    this.endIndent = 0,
  });

  /// The color [build] paints, resolved from [color] and the theme.
  ///
  /// Exposed so tests can assert color resolution without reaching into the
  /// widget tree for the rendered line.
  @visibleForTesting
  Color resolvedColor(BuildContext context) =>
      color ?? Theme.of(context).coreColors.lineLight;

  @override
  Widget build(BuildContext context) {
    return Divider(
      // Height equals thickness so the rule owns no hidden whitespace;
      // vertical rhythm stays at the call site as CoreSpacing tokens.
      height: thickness,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: resolvedColor(context),
      // Pinned so an ambient DividerThemeData.radius from the consuming app
      // cannot round the rule's end-caps.
      radius: BorderRadius.zero,
    );
  }
}
