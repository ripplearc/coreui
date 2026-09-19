import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// The preferences sheet's heading, above the list.
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceSheetTitle extends StatelessWidget {
  /// The heading text.
  final String title;

  /// Creates a preferences sheet heading.
  const PreferenceSheetTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space4,
        0,
        CoreSpacing.space4,
        CoreSpacing.space3,
      ),
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          title,
          style: typography.bodyLargeSemiBold.copyWith(
            color: colors.textHeadline,
          ),
        ),
      ),
    );
  }
}
