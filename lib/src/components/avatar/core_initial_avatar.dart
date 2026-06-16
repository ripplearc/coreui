import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A circular avatar that displays a single initial derived from a [name].
///
/// Thin, purpose-built wrapper over [CoreAvatar] for the common "owner row"
/// pattern: a small circle showing the first initial of a name on a themed
/// background. Colours default to design-system tokens (so dark mode is handled
/// by the theme) but every colour is overridable so callers can theme the
/// avatar independently.
class CoreInitialAvatar extends StatelessWidget {
  /// The name the initial is derived from.
  ///
  /// The initial is the first character of the first whitespace-delimited
  /// token, uppercased (e.g. `"John Doe"` → `"J"`). A blank name renders an
  /// empty circle.
  final String name;

  /// Radius of the circle. Diameter = `radius * 2`.
  ///
  /// Defaults to `12`, producing a 24×24 avatar.
  final double radius;

  /// Background colour of the circle.
  ///
  /// When null, falls back to the theme's `backgroundBlueMid` token.
  final Color? backgroundColor;

  /// Colour of the initial.
  ///
  /// When null, falls back to the theme's `iconOrient` token. This is the
  /// single source of truth for the glyph colour — it is applied last, even
  /// when [textStyle] is provided.
  final Color? textColor;

  /// Full override of the initial's text style.
  ///
  /// When null, the theme's `bodySmallMedium` style is used. The effective
  /// [textColor] is always applied on top of this style.
  final TextStyle? textStyle;

  /// Semantic label for screen readers.
  ///
  /// Defaults to `"Avatar for {name}"`.
  final String? semanticLabel;

  /// Creates a circular avatar showing the first initial of [name].
  const CoreInitialAvatar({
    super.key,
    required this.name,
    this.radius = 12,
    this.backgroundColor,
    this.textColor,
    this.textStyle,
    this.semanticLabel,
  });

  /// Derives the displayed initial: first character of the first
  /// whitespace-delimited token, uppercased. Blank names yield an empty string.
  static String initialFor(String name) {
    final trimmed = name.trimLeft();
    if (trimmed.isEmpty) {
      return '';
    }
    return trimmed.characters.first.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final typography = Theme.of(context).coreTypography;

    final effectiveBackground = backgroundColor ?? colors.backgroundBlueMid;
    final effectiveTextColor = textColor ?? colors.iconOrient;
    final effectiveStyle = (textStyle ?? typography.bodySmallMedium)
        .copyWith(color: effectiveTextColor);

    final initial = initialFor(name);

    return CoreAvatar(
      radius: radius,
      backgroundColor: effectiveBackground,
      semanticLabel: semanticLabel ?? 'Avatar for $name',
      child: initial.isEmpty
          ? null
          : Center(
              child: Text(initial, style: effectiveStyle),
            ),
    );
  }
}
