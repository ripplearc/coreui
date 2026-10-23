import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A selectable list row with a leading widget, a title (and optional
/// subtitle), and a trailing checkbox. Matches the Check row of the Figma List
/// item set.
///
/// Tapping anywhere on the row toggles [selected] via [onChanged]. The leading
/// area defaults to a 40×40 [CoreAvatar] showing the first initial of [title],
/// but any widget can be supplied via [leading]. Designed for multi-select
/// sheets such as an owner / assignee filter or the "Send to" sheet.
///
/// ### Sizes
/// 12 dp padding above and below, 20 dp left and right, 12 dp between the
/// avatar, the text and the checkbox. The row is at least 48 dp high.
///
/// ### States
/// - Default and Selected: [selected] is false or true. The box is `iconGrayMid`
///   when empty and `iconDark` when ticked.
/// - Pressed: the row is filled with `backgroundGrayLight` while held.
/// - Disabled: set [enabled] to false. The row ignores taps, is announced as
///   disabled, and the title, subtitle and initials use `textDisable`. The box
///   keeps its look.
///
/// ### Divider
/// A 1 dp `lineLight` rule inset 20 dp from each edge sits on the bottom edge of
/// the row. Pass `showDivider: false` on the last row of a list.
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

  /// Whether the row reacts to taps.
  ///
  /// When false the row ignores taps, reads as disabled to a screen reader, and
  /// the title, subtitle and default initials use `textDisable`. A custom
  /// [leading] or [avatarTextColor] is not dimmed.
  final bool enabled;

  /// Whether a divider is drawn on the bottom edge of the row.
  ///
  /// Pass false on the last row of a list.
  final bool showDivider;

  /// Leading widget shown before the text.
  ///
  /// Defaults to a 40×40 circle showing the first initial of [title]. When
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
  /// Ignored when [leading] is supplied. Null uses the theme's `bodyLargeSemiBold`.
  /// The effective [avatarTextColor] is always applied on top of this style.
  final TextStyle? avatarTextStyle;

  /// Accessibility label for the row. Defaults to [title].
  final String? semanticLabel;

  static const double _avatarRadius = 20;

  /// Creates a selectable checkbox row.
  const CoreCheckRowItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    this.showDivider = true,
    this.subtitle,
    this.leading,
    this.avatarBackgroundColor,
    this.avatarTextColor,
    this.avatarTextStyle,
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

  Widget _buildDefaultAvatar(
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    final effectiveBackground =
        avatarBackgroundColor ?? colors.backgroundBlueLight;
    final effectiveTextColor = avatarTextColor ??
        (enabled ? colors.textLink : colors.textDisable);
    final effectiveStyle = (avatarTextStyle ?? typography.bodyLargeSemiBold)
        .copyWith(color: effectiveTextColor);
    final initial = initialFor(title);

    return CoreAvatar(
      radius: _avatarRadius,
      backgroundColor: effectiveBackground,
      child: initial.isEmpty
          ? null
          : Text(initial, style: effectiveStyle),
    );
  }

  Widget _buildText(
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    final titleText = Text(
      title,
      style: typography.bodyLargeMedium.copyWith(
        color: enabled ? colors.textHeadline : colors.textDisable,
      ),
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
          style: typography.bodyMediumRegular.copyWith(
            color: enabled ? colors.textBody : colors.textDisable,
          ),
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
      enabled: enabled,
      checked: selected,
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: enabled ? () => onChanged(!selected) : null,
          splashFactory: NoSplash.splashFactory,
          highlightColor: colors.backgroundGrayLight,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: CoreSpacing.space12),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CoreSpacing.space5,
                    vertical: CoreSpacing.space3,
                  ),
                  child: Row(
                    children: [
                      ExcludeSemantics(child: effectiveLeading),
                      const SizedBox(width: CoreSpacing.space3),
                      Expanded(
                        child: ExcludeSemantics(
                          child: _buildText(colors, typography),
                        ),
                      ),
                      const SizedBox(width: CoreSpacing.space3),
                      ExcludeSemantics(
                        child: CoreIconWidget(
                          icon:
                              selected ? CoreIcons.check : CoreIcons.checkBlank,
                          size: CoreIconSize.size24,
                          color:
                              selected ? colors.iconDark : colors.iconGrayMid,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showDivider)
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: CoreDivider(
                      indent: CoreSpacing.space5,
                      endIndent: CoreSpacing.space5,
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
