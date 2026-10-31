import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// The two looks of the library Sheet Header.
enum CoreSheetHeaderStyle {
  /// A step of a form sheet: 20 dp at the sides.
  standard,

  /// A sheet that lists records, such as Logs: 16 dp at the sides, and the
  /// subtitle is the meta line under the title.
  metaLine,
}

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

  /// An optional second line under [title]: the subtitle, or the meta line
  /// for [CoreSheetHeaderStyle.metaLine]. When null, no second line is drawn.
  final String? subtitle;

  /// Called when the back arrow is tapped. When null, the header is the
  /// library Back=Off variant, for the first step of a sheet: no arrow.
  final VoidCallback? onBack;

  /// What a screen reader announces for the back arrow. Required with
  /// [onBack].
  final String? backSemanticLabel;

  /// The look of the header.
  final CoreSheetHeaderStyle style;

  /// Draws a 1 dp `lineLight` line under the header. Turn it on only when
  /// the content under the header scrolls.
  final bool showBottomLine;

  /// Creates a sheet header.
  const CoreSheetHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.backSemanticLabel,
    this.style = CoreSheetHeaderStyle.standard,
    this.showBottomLine = false,
  }) : assert(
          onBack == null || backSemanticLabel != null,
          'A back arrow needs a backSemanticLabel for screen readers.',
        );

  /// The key of the back arrow, for widget tests.
  static const Key backButtonKey = Key('core_sheet_header_back_button');

  /// The key of the column holding the title and subtitle, for widget tests.
  static const Key textColumnKey = Key('core_sheet_header_text_column');

  static const double _arrowNudgeDown = 1;
  static const double _arrowTopCentredOnTitleLine =
      CoreSpacing.space1 + _arrowNudgeDown;
  static const double _arrowBottomForA48TapArea = CoreSpacing.space12 -
      CoreIconSize.size24 -
      _arrowTopCentredOnTitleLine;

  double get _sidePadding => style == CoreSheetHeaderStyle.metaLine
      ? CoreSpacing.space4
      : CoreSpacing.space5;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final subtitle = this.subtitle;
    final onBack = this.onBack;
    // A later step shows the price the user acts on, so its subtitle is
    // larger; the first step and the meta line use Body Small.
    final subtitleStyle = onBack != null
        ? typography.bodyMediumRegular
        : typography.bodySmallRegular;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: showBottomLine
            ? Border(bottom: BorderSide(color: colors.lineLight))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (onBack != null)
            CoreIconWidget(
              key: backButtonKey,
              icon: CoreIcons.arrowLeft,
              size: CoreIconSize.size24,
              color: colors.textLink,
              semanticLabel: backSemanticLabel,
              onTap: onBack,
              // The library Sheet Header (set 66335:151191, Back=On) draws
              // the arrow box as one 48 dp wide layer, so the title starts at
              // x 48 and the arrow's tap area is 48 dp wide.
              padding: const EdgeInsets.fromLTRB(
                CoreSpacing.space3,
                _arrowTopCentredOnTitleLine,
                CoreSpacing.space3,
                _arrowBottomForA48TapArea,
              ),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: onBack == null ? _sidePadding : 0,
                top: CoreSpacing.space1,
                right: _sidePadding,
                bottom: CoreSpacing.space2,
              ),
              child: Column(
                key: textColumnKey,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Focus lands on the title when a step opens, as the
                  // library asks.
                  Focus(
                    autofocus: true,
                    child: Semantics(
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
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: subtitleStyle.copyWith(color: colors.textBody),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
