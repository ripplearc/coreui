import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// The option sub-sheet's header: a back button, the preference's name, and
/// an info button when the preference has an explanation.
///
/// The info button is the only control here that is conditional, and it
/// carries its labels in [CorePreferenceInfo] so it cannot be shown without
/// them — an interactive element with no semantics label is invisible to a
/// screen reader.
///
/// Built by hand rather than with [CoreAppBar], which covers the same
/// back-title-action shape. [CoreAppBar] wraps a Material `AppBar`, whose
/// elevation and shadow model is built for the top of a `Scaffold`; this
/// header sits at the top of a bottom sheet, which draws its own surface and
/// wants no second shadow over it. The row is small enough that borrowing the
/// app bar's surface behaviour costs more than it saves.
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceOptionSheetHeader extends StatelessWidget {
  /// The preference's name.
  final String title;

  /// Accessibility label for the back button.
  final String backSemanticsLabel;

  /// Called when the back button is tapped.
  final VoidCallback onBack;

  /// The explanation behind the info button, or null for a preference that
  /// needs none. The button is shown only when this is set.
  final CorePreferenceInfo? info;

  /// Called when the info button is tapped.
  final VoidCallback? onInfoTap;

  /// Key applied to the info button.
  final Key? infoButtonKey;

  /// Creates an option sub-sheet header.
  const PreferenceOptionSheetHeader({
    super.key,
    required this.title,
    required this.backSemanticsLabel,
    required this.onBack,
    this.info,
    this.onInfoTap,
    this.infoButtonKey,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final info = this.info;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space2,
        0,
        CoreSpacing.space4,
        CoreSpacing.space3,
      ),
      child: Row(
        children: [
          CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            size: CoreIconSize.size24,
            color: colors.iconDark,
            semanticLabel: backSemanticsLabel,
            onTap: onBack,
          ),
          const SizedBox(width: CoreSpacing.space2),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: typography.bodyLargeSemiBold.copyWith(
                color: colors.textHeadline,
              ),
            ),
          ),
          if (info != null)
            CoreIconWidget(
              key: infoButtonKey,
              icon: CoreIcons.info,
              size: CoreIconSize.size24,
              color: colors.iconGrayMid,
              semanticLabel: info.semanticsLabel,
              onTap: onInfoTap,
            ),
        ],
      ),
    );
  }
}
