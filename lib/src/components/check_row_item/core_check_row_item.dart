import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A selectable list row with a leading widget, a title (and optional
/// subtitle), and a trailing checkbox.
///
/// Tapping anywhere on the row toggles [selected] via [onChanged]. The leading
/// area defaults to a [CoreInitialAvatar] derived from [title], but any widget
/// can be supplied via [leading]. Designed for multi-select sheets such as an
/// owner / assignee filter.
class CoreCheckRowItem extends StatelessWidget {
  /// Primary text for the row (e.g. an owner name).
  ///
  /// Also used to build the default leading avatar and the default semantic
  /// label.
  final String title;

  /// Optional secondary line shown below [title] (e.g. an email address).
  final String? subtitle;

  /// Whether the row is currently checked.
  final bool selected;

  /// Called with the toggled value when the row or checkbox is activated.
  final ValueChanged<bool> onChanged;

  /// Leading widget shown before the text.
  ///
  /// Defaults to a 24×24 [CoreInitialAvatar] built from [title]. When provided,
  /// [avatarBackgroundColor] and [avatarTextColor] are ignored.
  final Widget? leading;

  /// Background color for the default leading avatar.
  ///
  /// Ignored when [leading] is supplied. Null uses the avatar's themed default.
  final Color? avatarBackgroundColor;

  /// Initial-text color for the default leading avatar.
  ///
  /// Ignored when [leading] is supplied. Null uses the avatar's themed default.
  final Color? avatarTextColor;

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
    this.semanticLabel,
  });

  Widget _buildText(BuildContext context) {
    final typography = AppTypographyExtension.of(context);
    final colors = AppColorsExtension.of(context);

    final titleText = Text(
      title,
      style: typography.bodyLargeRegular.copyWith(color: colors.textDark),
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

    final effectiveLeading = leading ??
        CoreInitialAvatar(
          name: title,
          backgroundColor: avatarBackgroundColor,
          textColor: avatarTextColor,
        );

    return Semantics(
      label: semanticLabel ?? title,
      button: true,
      checked: selected,
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: () => onChanged(!selected),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space4,
              vertical: CoreSpacing.space3,
            ),
            child: Row(
              children: [
                ExcludeSemantics(child: effectiveLeading),
                const SizedBox(width: CoreSpacing.space3),
                Expanded(
                  child: ExcludeSemantics(child: _buildText(context)),
                ),
                ExcludeSemantics(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: CoreSpacing.space12,
                      minHeight: CoreSpacing.space12,
                    ),
                    child: Center(
                      child: CoreIconWidget(
                        icon: selected ? CoreIcons.check : CoreIcons.checkBlank,
                        size: CoreIconSize.size24,
                        color:
                            selected ? colors.outlineFocus : colors.iconGrayMid,
                      ),
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
