import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A typing indicator widget that displays an animated "writing dots" pattern.
///
/// This widget wraps a Lottie animation to convey that another participant
/// (e.g. a remote user or an AI assistant) is composing a message. It is
/// commonly placed inside a chat bubble or an input area.
///
/// The size of the animation can be adjusted via [size].
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
  });

  /// The width and height of the writing dots indicator.
  ///
  /// Defaults to CoreSpacing.space3 = 12, which provides a comfortable viewing size inside
  /// a chat bubble or loading container.
  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Writing',
      child: Lottie.asset(
        'assets/animations/writing_dots.json',
        package: 'ripplearc_coreui',
        height: size,
        width: size,
        fit: BoxFit.contain,
      ),
    );
  }
}
