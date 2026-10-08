import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A tappable list row: a title, an optional subtitle under it, and an
/// optional value at the end (e.g. `$145.00 /day`).
///
/// Three looks share one geometry, so the titles of mixed rows line up:
/// - [CoreListRow.new]: a plain row with no leading slot.
/// - [CoreListRow.selectable]: a row in a pick-one list. It reserves a leading
///   check slot even when unselected, so rows don't shift when the pick moves.
/// - [CoreListRow.action]: a leading icon and a label in the link colour,
///   e.g. "+ New equipment cost".
///
/// The row pads its content by [CoreSpacing.space2] on each side; the list
/// around it supplies the page inset.
class CoreListRow extends StatelessWidget {
  /// Primary text, e.g. an item name.
  final String title;

  /// Optional secondary line under [title], e.g. "Used last week".
  final String? subtitle;

  /// Optional value shown at the end of the row, e.g. `$145.00`.
  final String? value;

  /// Optional smaller text after [value], e.g. `/day`. Ignored without [value].
  final String? unit;

  /// Whether this row is the current pick. Only [CoreListRow.selectable] rows
  /// can be selected.
  final bool selected;

  /// Called when the row is tapped. Null disables the row.
  final VoidCallback? onTap;

  /// Accessibility label for the row. Defaults to the visible texts, in order.
  final String? semanticLabel;

  final _CoreListRowKind _kind;
  final CoreIconData? _actionIcon;

  /// Creates a plain row with no leading slot.
  const CoreListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.value,
    this.unit,
    this.onTap,
    this.semanticLabel,
  })  : selected = false,
        _kind = _CoreListRowKind.plain,
        _actionIcon = null;

  /// Creates a row in a pick-one list. When [selected], the row fills light
  /// blue, its title turns the link colour and a check shows in the leading
  /// slot; otherwise the slot stays empty but keeps its width.
  const CoreListRow.selectable({
    super.key,
    required this.title,
    required this.selected,
    this.subtitle,
    this.value,
    this.unit,
    this.onTap,
    this.semanticLabel,
  })  : _kind = _CoreListRowKind.selectable,
        _actionIcon = null;

  /// Creates an action row: [icon] then [title], both in the link colour.
  const CoreListRow.action({
    super.key,
    required CoreIconData icon,
    required this.title,
    required VoidCallback this.onTap,
    this.semanticLabel,
  })  : subtitle = null,
        value = null,
        unit = null,
        selected = false,
        _kind = _CoreListRowKind.action,
        _actionIcon = icon;

  bool get _isAction => _kind == _CoreListRowKind.action;

  String get _defaultSemanticLabel {
    final valueText = [value, if (value != null) unit].nonNulls.join(' ');
    return [title, subtitle, valueText]
        .nonNulls
        .where((text) => text.isNotEmpty)
        .join('. ');
  }

  Widget _buildLeading(AppColorsExtension colors) {
    final (icon, visible) = switch (_kind) {
      _CoreListRowKind.plain => (null, false),
      _CoreListRowKind.selectable => (CoreIcons.checkMark, selected),
      _CoreListRowKind.action => (_actionIcon, true),
    };
    if (icon == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: CoreSpacing.space3),
      child: Opacity(
        opacity: visible ? 1 : 0,
        child: CoreIconWidget(
          icon: icon,
          size: CoreIconSize.size20,
          color: colors.textLink,
        ),
      ),
    );
  }

  Widget _buildText(
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    final titleStyle =
        _isAction ? typography.bodyMediumSemiBold : typography.bodyLargeSemiBold;
    final titleColor =
        _isAction || selected ? colors.textLink : colors.textHeadline;
    final titleText = Text(
      title,
      style: titleStyle.copyWith(color: titleColor),
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
        // 2 dp is the storyboard's gap; CoreSpacing's smallest step is 4.
        const SizedBox(height: 2),
        Text(
          subtitleValue,
          style: typography.bodySmallRegular.copyWith(color: colors.textBody),
        ),
      ],
    );
  }

  Widget _buildValue(
    String value,
    AppColorsExtension colors,
    AppTypographyExtension typography,
  ) {
    final unitValue = unit;
    return Padding(
      padding: const EdgeInsets.only(left: CoreSpacing.space3),
      child: Text.rich(
        TextSpan(
          text: value,
          style: typography.bodyLargeSemiBold.copyWith(
            color: colors.textHeadline,
          ),
          children: [
            if (unitValue != null)
              TextSpan(
                text: ' $unitValue',
                style: typography.bodySmallRegular.copyWith(
                  color: colors.textBody,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final valueText = value;
    final borderRadius = BorderRadius.circular(CoreSpacing.space3);

    return Semantics(
      button: true,
      enabled: onTap != null,
      selected: _kind == _CoreListRowKind.selectable ? selected : null,
      label: semanticLabel ?? _defaultSemanticLabel,
      child: Material(
        color: selected ? colors.backgroundBlueLight : colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius,
          // Excluded inside the InkWell so its tap action stays on the row.
          child: ExcludeSemantics(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: CoreSpacing.space12,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: CoreSpacing.space2,
                  vertical: CoreSpacing.space3,
                ),
                child: Row(
                  children: [
                    _buildLeading(colors),
                    Expanded(child: _buildText(colors, typography)),
                    if (valueText != null)
                      _buildValue(valueText, colors, typography),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _CoreListRowKind { plain, selectable, action }
