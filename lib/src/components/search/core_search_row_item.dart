import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import '../core_icon.dart';

/// A single-row item used in search screens for both recent searches and
/// search suggestions.
///
/// Use the named constructors [CoreSearchRowItem.recentSearch] and
/// [CoreSearchRowItem.suggestion] for the two standard variants, or supply
/// your own [leadingIcon] and [label] for a fully custom row.
///
/// ## Recent search example
/// ```dart
/// CoreSearchRowItem.recentSearch(
///   text: '#Carpentry',
///   onTap: () => runSearch('#Carpentry'),
///   onTrailingTap: () => fillSearchField('#Carpentry'),
/// )
/// ```
///
/// ## Search suggestion example
/// ```dart
/// CoreSearchRowItem.suggestion(
///   text: '#Carpentry',
///   query: 'Car',
///   onTap: () => runSearch('#Carpentry'),
///   onTrailingTap: () => fillSearchField('#Carpentry'),
/// )
/// ```
class CoreSearchRowItem extends StatelessWidget {
  /// Fully custom row — caller supplies [leadingIcon] and a pre-built [label].
  const CoreSearchRowItem({
    super.key,
    required this.leadingIcon,
    required this.label,
    required this.onTap,
    this.showTrailingIcon = true,
    this.onTrailingTap,
    this.semanticLabel,
    this.trailingSemanticLabel,
  }) : _text = null,
       _query = null;

  const CoreSearchRowItem._recentSearch({
    super.key,
    required String text,
    required this.onTap,
    this.onTrailingTap,
    this.trailingSemanticLabel,
  }) : leadingIcon = CoreIcons.history,
       label = null,
       showTrailingIcon = true,
       semanticLabel = text,
       _text = text,
       _query = null;

  const CoreSearchRowItem._suggestion({
    super.key,
    required String text,
    required String query,
    required this.onTap,
    this.onTrailingTap,
    this.trailingSemanticLabel,
  }) : leadingIcon = CoreIcons.search,
       label = null,
       showTrailingIcon = true,
       semanticLabel = text,
       _text = text,
       _query = query;

  /// Recent search variant: history icon on the left, plain text label.
  ///
  /// Supply [trailingSemanticLabel] with a localized string to describe the
  /// trailing action to screen-reader users.
  static CoreSearchRowItem recentSearch({
    Key? key,
    required String text,
    required VoidCallback onTap,
    VoidCallback? onTrailingTap,
    String? trailingSemanticLabel,
  }) {
    return CoreSearchRowItem._recentSearch(
      key: key,
      text: text,
      onTap: onTap,
      onTrailingTap: onTrailingTap,
      trailingSemanticLabel: trailingSemanticLabel,
    );
  }

  /// Suggestion variant: search icon on the left, label with the matching
  /// [query] prefix rendered in bold.
  ///
  /// Supply [trailingSemanticLabel] with a localized string to describe the
  /// trailing action to screen-reader users.
  static CoreSearchRowItem suggestion({
    Key? key,
    required String text,
    required String query,
    required VoidCallback onTap,
    VoidCallback? onTrailingTap,
    String? trailingSemanticLabel,
  }) {
    return CoreSearchRowItem._suggestion(
      key: key,
      text: text,
      query: query,
      onTap: onTap,
      onTrailingTap: onTrailingTap,
      trailingSemanticLabel: trailingSemanticLabel,
    );
  }

  final CoreIconData leadingIcon;

  /// Pre-built label widget. Null only when using the named constructors,
  /// which build the label from [_text] and [_query] at runtime.
  final Widget? label;

  /// Called when the user taps the row body.
  final VoidCallback onTap;

  /// Whether to show the ↗ trailing icon. Pass `false` to hide it.
  final bool showTrailingIcon;

  /// Called when the user taps the trailing icon (e.g. to fill the search
  /// field without immediately running a search).
  final VoidCallback? onTrailingTap;

  /// Accessibility label for the row itself.
  final String? semanticLabel;

  /// Accessibility label for the trailing icon button.
  final String? trailingSemanticLabel;

  final String? _text;
  final String? _query;

  Widget _buildLabel(BuildContext context) {
    final text = _text;
    if (text == null) {
      assert(label != null, 'label must be provided when _text is null');
      return label ?? const SizedBox.shrink();
    }

    final typography = AppTypographyExtension.of(context);
    final colors = AppColorsExtension.of(context);
    final regular = typography.bodyLargeRegular.copyWith(color: colors.textDark);

    final query = _query;
    if (query == null || query.isEmpty || query.length > text.length) {
      return Text(text, style: regular);
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();

    if (!lowerText.startsWith(lowerQuery)) {
      return Text(text, style: regular);
    }

    final bold = typography.bodyLargeSemiBold.copyWith(color: colors.textDark);
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: text.substring(0, query.length), style: bold),
          TextSpan(text: text.substring(query.length), style: regular),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);

    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: onTap,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: CoreSpacing.space4,
                    top: CoreSpacing.space4,
                    bottom: CoreSpacing.space4,
                  ),
                  child: Row(
                    children: [
                      CoreIconWidget(
                        icon: leadingIcon,
                        size: CoreIconSize.size20,
                        color: colors.iconGrayMid,
                      ),
                      const SizedBox(width: CoreSpacing.space3),
                      Expanded(child: _buildLabel(context)),
                    ],
                  ),
                ),
              ),
              if (showTrailingIcon)
                Semantics(
                  label: trailingSemanticLabel,
                  button: true,
                  excludeSemantics: trailingSemanticLabel == null,
                  child: GestureDetector(
                    key: const Key('trailing_icon'),
                    behavior: HitTestBehavior.opaque,
                    onTap: onTrailingTap,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: CoreSpacing.space12,
                        minHeight: CoreSpacing.space12,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.north_west,
                          size: CoreIconSize.size20,
                          color: colors.outlineFocus,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
