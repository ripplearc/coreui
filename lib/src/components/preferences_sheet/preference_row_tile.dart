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
  ///
  /// Typed `GlobalKey` rather than `Key` because the sheet reaches the row
  /// through `anchorKey.currentContext`, which only a `GlobalKey` carries. A
  /// plain `ValueKey` would compile and render, then leave the deep-link
  /// scroll silently doing nothing.
  final GlobalKey anchorKey;

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

  static const double _bottomLineWidth = 1;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return AnimatedContainer(
      key: anchorKey,
      duration: emphasisDuration,
      decoration: BoxDecoration(
        // pageBackground and backgroundGrayLight are the same token, so the
        // row needs the next step up to read as a surface of its own.
        color: isEmphasised
            ? colors.backgroundBlueLight
            : colors.backgroundGrayMid,
        borderRadius: BorderRadius.circular(CoreSpacing.space2),
        border: Border(
          bottom: BorderSide(color: colors.lineLight, width: _bottomLineWidth),
        ),
      ),
      // On top of the fill, so the press and focus looks can be seen.
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(CoreSpacing.space2),
          highlightColor: colors.backgroundBlueLight,
          // 11 at the bottom: the 1 dp bottom line is added to the padding,
          // and the library row is 48 high with the line inside it.
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              CoreSpacing.space3,
              CoreSpacing.space3,
              CoreSpacing.space3,
              CoreSpacing.space3 - _bottomLineWidth,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    row.label,
                    style: typography.bodyLargeRegular.copyWith(
                      color: row.isDisabled
                          ? colors.textDisable
                          : colors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: CoreSpacing.space3),
                PreferenceValueView(
                  value: row.value,
                  isDisabled: row.isDisabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
