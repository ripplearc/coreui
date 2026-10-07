import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// The colour family of a [CoreStatusBadge].
enum CoreStatusBadgeVariant {
  /// An orange pill for a value that needs attention, such as the "Sample
  /// rate" tag on a rate that is not yet the user's own.
  warning,

  /// A grey pill with no outline, such as the "After first send" tag
  /// (Figma Tag). It exists in [CoreStatusBadgeSize.regular] only.
  neutral,
}

/// The size of a [CoreStatusBadge].
enum CoreStatusBadgeSize {
  /// 24 dp tall for [CoreStatusBadgeVariant.warning] and 22 dp tall for
  /// [CoreStatusBadgeVariant.neutral], as Figma draws them.
  regular,

  /// 20 dp tall with a 6 dp radius and a lighter orange fill: the badge in a
  /// text field's label row (Figma Text Field, Label row, Badge). Only
  /// [CoreStatusBadgeVariant.warning] has this size.
  compact,
}

/// A small pill that tags a value with its status, such as the orange
/// "Sample rate" tag on a looked-up rate (Figma Rate Status, component set
/// `65685:147068`).
///
/// ## Variants and sizes
/// | Variant   | Size      | Height | Radius | Fill                    | Outline      | Text                |
/// |-----------|-----------|--------|--------|-------------------------|--------------|---------------------|
/// | `warning` | `regular` | 24     | 8      | `backgroundOrangeMid`   | `lineOrange` | `textWarningStrong` |
/// | `warning` | `compact` | 20     | 6      | `backgroundOrangeLight` | `lineOrange` | `textWarningStrong` |
/// | `neutral` | `regular` | 22     | 6      | `backgroundGrayMid`     | none         | `textGrayMid`       |
///
/// These are the only combinations Figma draws. Any other pairing is refused
/// by an assert, which a release build skips, so the badge would then draw
/// with the nearest look. The label is the 12/16 semibold body-small style,
/// and a label wider than the space it is given is cut with an ellipsis.
///
/// ## Info icon
/// [showInfoIcon] adds a 14 dp info icon after the label. Figma shows it on
/// the regular warning pill only. Without [onInfoTap] the icon is decorative
/// and hidden from screen readers. With [onInfoTap] the icon becomes a button
/// announced as [infoSemanticLabel]; the app uses it to open the explanation
/// of the tag. The tap area is the icon plus the badge's right padding, as
/// tall as the badge. A badge this small cannot reach the 44 to 48 dp tap
/// target on its own, so place it where a missed tap is harmless.
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
///
/// CoreStatusBadge(
///   label: context.l10n.afterFirstSend,
///   variant: CoreStatusBadgeVariant.neutral,
/// )
/// ```
class CoreStatusBadge extends StatelessWidget {
  /// The text shown in the badge.
  final String label;

  /// The colour family. Defaults to [CoreStatusBadgeVariant.warning].
  final CoreStatusBadgeVariant variant;

  /// The size. Defaults to [CoreStatusBadgeSize.regular].
  final CoreStatusBadgeSize size;

  /// Whether a 14 dp info icon follows the [label].
  ///
  /// Only the regular warning badge has one. Defaults to `false`.
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
    this.variant = CoreStatusBadgeVariant.warning,
    this.size = CoreStatusBadgeSize.regular,
    this.showInfoIcon = false,
    this.onInfoTap,
    this.infoSemanticLabel,
  })  : assert(
          variant == CoreStatusBadgeVariant.warning ||
              size == CoreStatusBadgeSize.regular,
          'The neutral badge has no compact size.',
        ),
        assert(
          !showInfoIcon ||
              (variant == CoreStatusBadgeVariant.warning &&
                  size == CoreStatusBadgeSize.regular),
          'Only the regular warning badge has an info icon.',
        ),
        assert(
          onInfoTap == null || showInfoIcon,
          'onInfoTap needs showInfoIcon to be true.',
        ),
        assert(
          onInfoTap == null || infoSemanticLabel != null,
          'A tappable info icon needs an infoSemanticLabel.',
        );

  // TODO (CA-1238): CoreSpacing has no 10 or 11 step. Replace these with
  // tokens once they exist. https://ripplearc.youtrack.cloud/issue/CA-1238
  static const double _padding10 = 10;
  static const double _padding11 = 11;

  static const double _neutralHeight = 22;
  static const double _borderWidth = 1;

  bool get _isCompact => size == CoreStatusBadgeSize.compact;
  bool get _isNeutral => variant == CoreStatusBadgeVariant.neutral;

  double get _height {
    if (_isNeutral) return _neutralHeight;
    return _isCompact ? CoreSpacing.space5 : CoreSpacing.space6;
  }

  double get _radius =>
      _isCompact || _isNeutral ? CoreRadius.radius6 : CoreRadius.radius8;

  double get _horizontalPadding {
    if (_isNeutral) return _padding11;
    return _isCompact ? CoreSpacing.space2 : _padding10;
  }

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
              right: _padding10,
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
    final textColor =
        _isNeutral ? colors.textGrayMid : colors.textWarningStrong;

    final Color fill;
    if (_isNeutral) {
      fill = colors.backgroundGrayMid;
    } else {
      fill = _isCompact
          ? colors.backgroundOrangeLight
          : colors.backgroundOrangeMid;
    }

    final rightPadding = onInfoTap == null ? _horizontalPadding : 0.0;

    return Container(
      constraints: BoxConstraints.tightFor(height: _height),
      padding: EdgeInsets.only(
        left: _horizontalPadding,
        right: rightPadding,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(_radius),
        border: _isNeutral
            ? null
            : Border.all(color: colors.lineOrange, width: _borderWidth),
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
