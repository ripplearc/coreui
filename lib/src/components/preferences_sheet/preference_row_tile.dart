import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'preference_value_view.dart';

/// One settings row: label at the start, current value at the end, tappable
/// when the preference offers a choice.
///
/// A deep-linked row is marked by [isEmphasised]. The mark fades out over
/// [emphasisDuration] rather than blinking off; it does not fade in, because
/// a deep-linked row is already marked on its first build and an
/// [AnimatedContainer] has nothing to animate from.
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceRowTile extends StatelessWidget {
  /// The row to render.
  final CorePreferenceRow row;

  /// Whether this row is the deep-link target and should be marked.
  final bool isEmphasised;

  /// How long the mark takes to fade out.
  final Duration emphasisDuration;

  /// Anchor used by the sheet to scroll this row into view.
  final Key anchorKey;

  /// Called when the row is tapped; null makes the row inert.
  final VoidCallback? onTap;

  /// Creates a preference row tile.
  const PreferenceRowTile({
    super.key,
    required this.row,
    required this.isEmphasised,
    required this.emphasisDuration,
    required this.anchorKey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(CoreSpacing.space2),
      child: AnimatedContainer(
        key: anchorKey,
        duration: emphasisDuration,
        decoration: BoxDecoration(
          // pageBackground and backgroundGrayLight are the same token, so the
          // row needs the next step up to read as a surface of its own.
          color: isEmphasised
              ? colors.backgroundBlueLight
              : colors.backgroundGrayMid,
          borderRadius: BorderRadius.circular(CoreSpacing.space2),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: CoreSpacing.space4,
          vertical: CoreSpacing.space3,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                row.label,
                style: typography.bodyLargeRegular.copyWith(
                  color: colors.textHeadline,
                ),
              ),
            ),
            const SizedBox(width: CoreSpacing.space2),
            PreferenceValueView(value: row.value),
          ],
        ),
      ),
    );
  }
}
