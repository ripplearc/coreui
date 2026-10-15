import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A square icon button drawn as a 36 dp box with a 1 dp light edge, e.g.
/// the magnifier that opens a rate look-up beside a form field.
///
/// The box sits centred in a 48 dp square that takes the taps, so the hit
/// area meets the 48 dp minimum while the drawn box stays 36 dp.
class CoreOutlinedIconButton extends StatelessWidget {
  /// The icon drawn in the box, at 20 dp in [AppColorsExtension.iconGrayMid].
  final CoreIconData icon;

  /// Called when the button is tapped.
  final VoidCallback onTap;

  /// Screen-reader label, e.g. "Look up a rate". The button has no visible
  /// text, so this is the only name a screen reader can give it.
  final String semanticLabel;

  /// The side of the drawn box.
  static const double boxSize = CoreSpacing.space9;

  /// The side of the square that takes taps.
  static const double tapTargetSize = CoreSpacing.space12;

  /// The corner radius of the box, from the storyboard's `.iconbtn`.
  /// [CoreSpacing] has no 9 dp step.
  static const double borderRadius = 9;

  /// Creates an outlined icon button.
  const CoreOutlinedIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final radius = BorderRadius.circular(borderRadius);

    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        // Excluded inside the detector so its tap action stays on the button.
        child: ExcludeSemantics(
          child: SizedBox.square(
            dimension: tapTargetSize,
            child: Center(
              child: Material(
                color: colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: radius,
                  side: BorderSide(color: colors.lineMid),
                ),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: radius,
                  child: SizedBox.square(
                    dimension: boxSize,
                    child: Center(
                      child: CoreIconWidget(
                        icon: icon,
                        size: CoreIconSize.size20,
                        color: colors.iconGrayMid,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
