import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A small pill that tags a value with its status, such as the orange
/// "Sample rate" tag on a looked-up rate (Figma Rate Status, component set
/// `65685:147068`).
///
/// The badge is 24 dp tall and as wide as its [label]. It draws a 1 dp
/// `lineOrange` outline over a `backgroundOrangeMid` fill, with the label in
/// the 12/16 semibold body-small style and the `textWarningStrong` colour.
///
/// A [label] wider than the space it is given is cut with an ellipsis.
///
/// ## Info icon
/// [showInfoIcon] adds a 14 dp info icon after the label. Without [onInfoTap]
/// the icon is decorative and hidden from screen readers. With [onInfoTap]
/// the icon becomes a button announced as [infoSemanticLabel]; the app uses it
/// to open the explanation of the tag. The tap area is the icon plus the
/// badge's right padding, as tall as the badge. A badge this small cannot
/// reach the 44 to 48 dp tap target on its own, so place it where a missed tap
/// is harmless.
///
/// [label] and [infoSemanticLabel] are passed in by the caller, so the app
/// localises them. The badge itself announces [label] as one text node.
///
/// ## Example
/// ```dart
/// CoreStatusBadge(
///   label: context.l10n.sampleRate,
///   showInfoIcon: true,
///   onInfoTap: showSampleRateExplanation,
///   infoSemanticLabel: context.l10n.aboutSampleRate,
/// )
/// ```
class CoreStatusBadge extends StatelessWidget {
  /// The text shown in the badge.
  final String label;

  /// Whether a 14 dp info icon follows the [label].
  ///
  /// Defaults to `false`.
  final bool showInfoIcon;

  /// Called when the info icon is tapped.
  ///
  /// Requires [showInfoIcon] and [infoSemanticLabel]. When null the icon is
  /// decorative.
  final VoidCallback? onInfoTap;

  /// What a screen reader announces for the info icon button, for example
  /// "About sample rates". Required when [onInfoTap] is set.
  final String? infoSemanticLabel;

  const CoreStatusBadge({
    super.key,
    required this.label,
    this.showInfoIcon = false,
    this.onInfoTap,
    this.infoSemanticLabel,
  })  : assert(
          onInfoTap == null || showInfoIcon,
          'onInfoTap needs showInfoIcon to be true.',
        ),
        assert(
          onInfoTap == null || infoSemanticLabel != null,
          'A tappable info icon needs an infoSemanticLabel.',
        );

  // TODO (CA-1238): CoreSpacing has no 10 step. Replace with a token once it
  // exists. https://ripplearc.youtrack.cloud/issue/CA-1238
  static const double _horizontalPadding = 10;

  static const double _height = CoreSpacing.space6;
  static const double _borderWidth = 1;

  Widget _buildInfoIcon(Color color) {
    final icon = CoreIconWidget(
      icon: CoreIcons.info,
      size: CoreIconSize.size14,
      color: color,
    );
    final onTap = onInfoTap;
    if (onTap == null) {
      return Padding(
        padding: const EdgeInsets.only(left: CoreSpacing.space1),
        child: ExcludeSemantics(child: icon),
      );
    }

    return Semantics(
      button: true,
      label: infoSemanticLabel,
      excludeSemantics: true,
      onTap: onTap,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          height: _height - 2 * _borderWidth,
          child: Padding(
            padding: const EdgeInsets.only(
              left: CoreSpacing.space1,
              right: _horizontalPadding,
            ),
            child: Center(child: icon),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.coreColors;
    final textColor = colors.textWarningStrong;
    final rightPadding = onInfoTap == null ? _horizontalPadding : 0.0;

    return Container(
      constraints: const BoxConstraints.tightFor(height: _height),
      padding: EdgeInsets.only(
        left: _horizontalPadding,
        right: rightPadding,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundOrangeMid,
        borderRadius: BorderRadius.circular(CoreRadius.radius8),
        border: Border.all(color: colors.lineOrange, width: _borderWidth),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.coreTypography.bodySmallSemiBold
                  .copyWith(color: textColor),
            ),
          ),
          if (showInfoIcon) _buildInfoIcon(textColor),
        ],
      ),
    );
  }
}
