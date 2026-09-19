import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'preference_row_tile.dart';

/// One group of settings rows, under its heading when it has one.
///
/// The sheet owns the deep-link state and the scroll anchors, so this view is
/// handed [emphasisKey] and [anchorOf] rather than tracking either itself.
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceSectionView extends StatelessWidget {
  /// The group to render.
  final CorePreferenceSection section;

  /// Key of the row currently marked as the deep-link target, if any.
  final String? emphasisKey;

  /// How long a row's mark takes to fade out.
  final Duration emphasisDuration;

  /// Builds the key for the row with the given preference key.
  final Key Function(String key)? rowKeyOf;

  /// Supplies the anchor the sheet scrolls to for the given preference key.
  final Key Function(String key) anchorOf;

  /// Called when a row that offers a choice is tapped.
  final void Function(CorePreferenceRow row) onRowTap;

  /// Creates a section view.
  const PreferenceSectionView({
    super.key,
    required this.section,
    required this.emphasisDuration,
    required this.anchorOf,
    required this.onRowTap,
    this.emphasisKey,
    this.rowKeyOf,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final title = section.title;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              0,
              CoreSpacing.space4,
              0,
              CoreSpacing.space2,
            ),
            child: Text(
              title,
              style: typography.bodyMediumSemiBold.copyWith(
                color: colors.textBody,
              ),
            ),
          ),
        for (final row in section.rows)
          Padding(
            padding: const EdgeInsets.only(bottom: CoreSpacing.space1),
            child: PreferenceRowTile(
              key: rowKeyOf?.call(row.key),
              row: row,
              isEmphasised: row.key == emphasisKey,
              emphasisDuration: emphasisDuration,
              anchorKey: anchorOf(row.key),
              onTap: row.isSelectable ? () => onRowTap(row) : null,
            ),
          ),
        const SizedBox(height: CoreSpacing.space2),
      ],
    );
  }
}
