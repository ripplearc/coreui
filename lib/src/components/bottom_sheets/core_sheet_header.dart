import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// The header at the top of a bottom sheet: a back arrow, a title, and an
/// optional subtitle under the title.
///
/// Place it as the first child of the content passed to
/// [CoreQuickSheet.show], under the drag handle the sheet draws itself.
///
/// The header owns no navigation. Tapping the arrow calls [onBack], so the
/// caller decides whether that pops the sheet or steps back inside it.
///
/// Built by hand rather than with [CoreAppBar] for the same reason as the
/// preferences sheet's header: a Material `AppBar` brings an elevation and
/// shadow meant for the top of a `Scaffold`, and a sheet draws its own
/// surface.
///
/// ```dart
/// CoreSheetHeader(
///   title: 'Excavator',
///   subtitle: 'Metered rate',
///   backSemanticLabel: 'Back',
///   onBack: () => Navigator.of(context).pop(),
/// )
/// ```
class CoreSheetHeader extends StatelessWidget {
  /// The main line, cut with an ellipsis when it does not fit.
  final String title;

  /// An optional second line under [title]. When null, no second line is
  /// drawn.
  final String? subtitle;

  /// Called when the back arrow is tapped.
  final VoidCallback onBack;

  /// What a screen reader announces for the back arrow.
  final String backSemanticLabel;

  /// Creates a sheet header.
  const CoreSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    required this.onBack,
    required this.backSemanticLabel,
  });

  // Figma draws 1 dp above the 24 dp arrow, which centres it on the 26 dp
  // title line that starts at the same 11 dp top padding.
  static const double _arrowTop = CoreSpacing.px11 + 1;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final subtitle = this.subtitle;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CoreIconWidget(
          icon: CoreIcons.arrowLeft,
          size: CoreIconSize.size24,
          color: colors.textLink,
          semanticLabel: backSemanticLabel,
          onTap: onBack,
          // Figma has 10 dp on the right. 12 makes the tap area 48 dp wide,
          // the Android minimum.
          padding: const EdgeInsets.fromLTRB(
            CoreSpacing.space3,
            _arrowTop,
            CoreSpacing.space3,
            CoreSpacing.space3,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: CoreSpacing.px11,
              right: CoreSpacing.space5,
              bottom: CoreSpacing.px15,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.titleMediumSemiBold.copyWith(
                      color: colors.textHeadline,
                    ),
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: typography.bodyMediumRegular.copyWith(
                      color: colors.textBody,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
