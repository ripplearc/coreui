import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A selectable list row with a leading widget, a title (and optional
/// subtitle), and a trailing checkbox.
///
/// Tapping anywhere on the row toggles [selected] via [onChanged]. The leading
/// area defaults to a 24×24 [CoreAvatar] showing the first initial of [title],
/// but any widget can be supplied via [leading]. Designed for multi-select
/// sheets such as an owner / assignee filter.
class CoreCheckRowItem extends StatelessWidget {
  /// Primary text for the row (e.g. an owner name).
  ///
  /// Also used to derive the default leading avatar's initial and the default
  /// semantic label.
  final String title;

  /// Optional secondary line shown below [title] (e.g. an email address).
  final String? subtitle;

  /// Whether the row is currently checked.
  final bool selected;

  /// Called with the toggled value when the row or checkbox is activated.
  final ValueChanged<bool> onChanged;

  /// Leading widget shown before the text.
  ///
  /// Defaults to a 24×24 circle showing the first initial of [title]. When
  /// provided, [avatarBackgroundColor] and [avatarTextColor] are ignored.
  final Widget? leading;

  /// Background color for the default leading avatar.
  ///
  /// Ignored when [leading] is supplied. Null uses the avatar's themed default.
  final Color? avatarBackgroundColor;

  /// Initial-text color for the default leading avatar.
  ///
  /// Ignored when [leading] is supplied. Null uses the avatar's themed default.
  final Color? avatarTextColor;

  /// Full override of the default leading avatar's initial text style.
  ///
  /// Ignored when [leading] is supplied. Null uses the theme's `bodySmallMedium`.
  /// The effective [avatarTextColor] is always applied on top of this style.
  final TextStyle? avatarTextStyle;

  /// Accessibility label for the row. Defaults to [title].
  final String? semanticLabel;

  /// Creates a selectable checkbox row.
  const CoreCheckRowItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
    this.subtitle,
    this.leading,
    this.avatarBackgroundColor,
    this.avatarTextColor,
    this.avatarTextStyle,
    this.semanticLabel,
  });

  static const double _rowRadius = CoreSpacing.space12;

  /// Derives the displayed initial: first character of the first
  /// whitespace-delimited token, uppercased. Blank names yield an empty string.
  static String initialFor(String name) {
    final trimmed = name.trimLeft();
    if (trimmed.isEmpty) {
      return '';
    }
    return trimmed.characters.first.toUpperCase();
  }

  Widget _buildDefaultAvatar(
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    final effectiveBackground = avatarBackgroundColor ?? colors.backgroundBlueMid;
    final effectiveTextColor = avatarTextColor ?? colors.textHeadline;
    final effectiveStyle = (avatarTextStyle ?? typography.bodySmallMedium)
        .copyWith(color: effectiveTextColor);
    final initial = initialFor(title);

    return CoreAvatar(
      radius: 12,
      backgroundColor: effectiveBackground,
      // Scales down so a large text size keeps the initial inside the 24 dp
      // circle instead of cutting it.
      child: initial.isEmpty
          ? null
          : FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(initial, style: effectiveStyle),
            ),
    );
  }

  Widget _buildText(
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    final titleText = Text(
      title,
      style: typography.bodyMediumRegular.copyWith(color: colors.textDark),
    );

    final subtitleValue = subtitle;
    if (subtitleValue == null) {
      return titleText;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        titleText,
        Text(
          subtitleValue,
          style: typography.bodySmallRegular.copyWith(color: colors.textBody),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final effectiveLeading = leading ?? _buildDefaultAvatar(colors, typography);

    return Semantics(
      label: semanticLabel ?? title,
      button: true,
      checked: selected,
      child: Material(
        color: selected ? colors.backgroundBlueLight : colors.transparent,
        borderRadius: BorderRadius.circular(_rowRadius),
        child: InkWell(
          onTap: () => onChanged(!selected),
          borderRadius: BorderRadius.circular(_rowRadius),
          splashFactory: NoSplash.splashFactory,
          // The library Dropdown cell has no pressed or hover state.
          highlightColor: colors.transparent,
          hoverColor: colors.transparent,
          // The whole row is the tap target: 12 dp padding around the 24 dp
          // check box keeps it at least 48 dp high.
          child: Padding(
            padding: const EdgeInsets.all(CoreSpacing.space3),
            child: Row(
              children: [
                ExcludeSemantics(child: effectiveLeading),
                const SizedBox(width: CoreSpacing.space2),
                Expanded(
                  child: ExcludeSemantics(
                    child: _buildText(colors, typography),
                  ),
                ),
                ExcludeSemantics(
                  child: CoreIconWidget(
                    icon: selected ? CoreIcons.check : CoreIcons.checkBlank,
                    size: CoreIconSize.size24,
                    color: selected ? colors.outlineFocus : colors.iconGrayMid,
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
