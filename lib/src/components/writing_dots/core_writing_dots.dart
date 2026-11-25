import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A typing indicator widget that displays an animated "writing dots" pattern.
///
/// This widget wraps a Lottie animation to convey that another participant
/// (e.g. a remote user or an AI assistant) is composing a message. It is
/// commonly placed inside a chat bubble or an input area.
///
/// The size of the animation can be adjusted via [size]. The dots take their
/// colour from the theme, [AppColorsExtension.iconDark], so they are visible
/// in both themes: at least 3:1 on the display area's `backgroundBlueLight`
/// (WCAG 1.4.11), where the colour fixed inside the animation file read
/// 1.7:1 in the dark theme. [color] overrides the token.
///
/// Example:
/// ```dart
/// CoreWritingDots()
/// CoreWritingDots(size: CoreSpacing.space5)
/// ```
class CoreWritingDots extends StatelessWidget {
  /// Creates a [CoreWritingDots] indicator.
  ///
  /// The [size] parameter controls both width and height of the animation.
  const CoreWritingDots({
    super.key,
    this.size = CoreSpacing.space3,
    this.color,
  });

  /// The width and height of the writing dots indicator.
  ///
  /// Defaults to CoreSpacing.space3 = 12, which provides a comfortable viewing size inside
  /// a chat bubble or loading container.
  final double size;

  /// The colour of the dots. Defaults to `null`, which draws them in the
  /// theme's [AppColorsExtension.iconDark]: the animation file's own colour
  /// in the light theme, and a colour that meets 3:1 on the display area in
  /// the dark theme. A colour that is partly see-through draws the dots
  /// that much see-through.
  final Color? color;

  static const List<String> _fillsOfEveryDot = ['**', 'Fill'];

  /// The colour the dots are drawn in: [color], else the theme's `iconDark`.
  /// Under a theme without [AppColorsExtension] that is the `iconDark` of
  /// the CoreUI colours that match the theme's brightness, so the dots are
  /// visible on a plain dark theme too.
  static Color resolveColor(BuildContext context, Color? color) {
    if (color != null) return color;
    final theme = Theme.of(context);
    final colors = theme.extension<AppColorsExtension>() ??
        (theme.brightness == Brightness.dark
            ? AppColorsExtension.createDark()
            : AppColorsExtension.create());
    return colors.iconDark;
  }

  @override
  Widget build(BuildContext context) {
    final dotColor = resolveColor(context, color);
    return Semantics(
      label: 'Writing',
      child: Lottie.asset(
        'assets/animations/writing_dots.json',
        package: 'ripplearc_coreui',
        height: size,
        width: size,
        fit: BoxFit.contain,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(
              _fillsOfEveryDot,
              value: dotColor.withValues(alpha: 1),
            ),
            ValueDelegate.opacity(
              _fillsOfEveryDot,
              value: (dotColor.a * 100).round(),
            ),
          ],
        ),
      ),
    );
  }
}
