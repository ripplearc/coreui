import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A selectable list row with a leading widget, a title (and optional
/// subtitle), and a trailing checkbox.
///
/// Tapping anywhere on the row toggles [selected] via [onChanged]. The leading
/// area defaults to a [CoreAvatar] showing the first initial of [title], but
/// any widget can be supplied via [leading].
///
/// [CoreCheckRowItem.new] draws the library Dropdown cell, for multi-select
/// sheets such as an owner filter. [CoreCheckRowItem.checkRow] draws the
/// library Check row (Figma 62505:74872), for lists such as the "Send to"
/// sheet. Sizes and states of both are in `core_check_row_item.md`.
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

  /// Whether the row reacts to taps. False ignores taps, reads as disabled and
  /// draws the text in `textDisable`; a custom [leading] or [avatarTextColor]
  /// is not dimmed.
  final bool enabled;

  /// Whether a [CoreCheckRowItem.checkRow] draws its divider on the bottom
  /// edge. Always false for the Dropdown cell, which has none.
  final bool showDivider;

  final bool _isCheckRow;

  /// Leading widget shown before the text.
  ///
  /// Defaults to a circle showing the first initial of [title], 24 dp in the
  /// Dropdown cell and 40 dp in the Check row. When
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
  /// Ignored when [leading] is supplied. Null uses the theme's `bodySmallMedium`
  /// (`bodyLargeSemiBold` in the Check row).
  /// The effective [avatarTextColor] is always applied on top of this style.
  final TextStyle? avatarTextStyle;

  /// Accessibility label for the row. Defaults to [title].
  final String? semanticLabel;

  /// Creates a selectable checkbox row drawn as the library Dropdown cell.
  const CoreCheckRowItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onChanged,
    this.enabled = true,
    this.subtitle,
    this.leading,
    this.avatarBackgroundColor,
    this.avatarTextColor,
    this.avatarTextStyle,
    this.semanticLabel,
  })  : showDivider = false,
        _isCheckRow = false;

  /// Creates a selectable checkbox row drawn as the library Check row.
  const CoreCheckRowItem.checkRow({
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
  }) : _isCheckRow = true;

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
    final effectiveBackground = avatarBackgroundColor ??
        (_isCheckRow ? colors.backgroundBlueLight : colors.backgroundBlueMid);
    final effectiveTextColor = avatarTextColor ??
        (!enabled
            ? colors.textDisable
            : _isCheckRow
                ? colors.textLink
                : colors.textHeadline);
    final effectiveStyle = (avatarTextStyle ??
            (_isCheckRow
                ? typography.bodyLargeSemiBold
                : typography.bodySmallMedium))
        .copyWith(color: effectiveTextColor);
    final initial = initialFor(title);

    return CoreAvatar(
      radius: _isCheckRow ? CoreSpacing.space5 : CoreSpacing.space3,
      backgroundColor: effectiveBackground,
      // Scales down so a large text size keeps the initial inside the circle
      // instead of cutting it.
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
    final titleStyle = _isCheckRow
        ? typography.bodyLargeMedium.copyWith(color: colors.textHeadline)
        : typography.bodyMediumRegular.copyWith(color: colors.textDark);
    final subtitleStyle = (_isCheckRow
            ? typography.bodyMediumRegular
            : typography.bodySmallRegular)
        .copyWith(color: colors.textBody);
    final titleText = Text(
      title,
      style: enabled ? titleStyle : titleStyle.copyWith(color: colors.textDisable),
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
          style: enabled
              ? subtitleStyle
              : subtitleStyle.copyWith(color: colors.textDisable),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final effectiveLeading = leading ?? _buildDefaultAvatar(colors, typography);
    final gap = _isCheckRow ? CoreSpacing.space3 : CoreSpacing.space2;
    final checkColor = !selected
        ? colors.iconGrayMid
        : _isCheckRow
            ? colors.iconDark
            : colors.outlineFocus;
    final radius = BorderRadius.circular(_isCheckRow ? 0 : _rowRadius);

    // The whole row is the tap target: 12 dp above and below the 24 dp check
    // box keeps it at least 48 dp high.
    Widget row = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _isCheckRow ? CoreSpacing.space5 : CoreSpacing.space3,
        vertical: CoreSpacing.space3,
      ),
      child: Row(
        children: [
          ExcludeSemantics(child: effectiveLeading),
          SizedBox(width: gap),
          Expanded(
            child: ExcludeSemantics(child: _buildText(colors, typography)),
          ),
          if (_isCheckRow) SizedBox(width: gap),
          ExcludeSemantics(
            child: CoreIconWidget(
              icon: selected ? CoreIcons.check : CoreIcons.checkBlank,
              size: CoreIconSize.size24,
              color: checkColor,
            ),
          ),
        ],
      ),
    );
    // The divider lies over the bottom edge, so it adds no height.
    if (showDivider) {
      row = Stack(
        children: [
          row,
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
      );
    }

    return Semantics(
      label: semanticLabel ?? title,
      button: true,
      enabled: enabled,
      checked: selected,
      child: Material(
        color: selected && !_isCheckRow
            ? colors.backgroundBlueLight
            : colors.transparent,
        borderRadius: radius,
        child: InkWell(
          onTap: enabled ? () => onChanged(!selected) : null,
          canRequestFocus: false,
          borderRadius: radius,
          splashFactory: NoSplash.splashFactory,
          // The library Dropdown cell has no pressed or hover state. The
          // Check row's Grey Light press is the page colour in coreui, so it
          // fills Grey Mid, as the preference rows do.
          highlightColor:
              _isCheckRow ? colors.backgroundGrayMid : colors.transparent,
          hoverColor: colors.transparent,
          // _RowFocus draws the focus look; the ink adds no grey on top.
          focusColor: colors.transparent,
          child: _RowFocus(
            onActivate: enabled ? () => onChanged(!selected) : null,
            radius: radius,
            child: row,
          ),
        ),
      ),
    );
  }
}

class _RowFocus extends StatefulWidget {
  const _RowFocus({
    required this.onActivate,
    required this.radius,
    required this.child,
  });

  final VoidCallback? onActivate;
  final BorderRadius radius;
  final Widget child;

  @override
  State<_RowFocus> createState() => _RowFocusState();
}

class _RowFocusState extends State<_RowFocus> {
  static const double _ringWidth = 2;

  bool _showsRing = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final onActivate = widget.onActivate;

    // Tab reaches the row and Enter or Space toggles it. Keyboard focus draws
    // a 2 dp outlineFocus ring inside the row, as on the other coreui parts.
    return FocusableActionDetector(
      enabled: onActivate != null,
      onShowFocusHighlight: (showsRing) =>
          setState(() => _showsRing = showsRing),
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            onActivate?.call();
            return null;
          },
        ),
      },
      child: Stack(
        children: [
          widget.child,
          if (_showsRing)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: colors.outlineFocus,
                      width: _ringWidth,
                    ),
                    borderRadius: widget.radius,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
