import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A reusable loading indicator widget that displays a Lottie animation.
///
/// This widget wraps a Lottie animation file and provides consistent sizing
/// and centering across the application.
///
/// Example:
/// ```dart
/// CoreLoadingIndicator()
/// CoreLoadingIndicator(size: 100)
/// ```
class CoreLoadingIndicator extends StatelessWidget {
  /// Creates a [CoreLoadingIndicator].
  ///
  /// The [size] parameter controls both width and height of the animation.
  /// The [fit] parameter determines how the animation should be inscribed into the space.
  const CoreLoadingIndicator({
    super.key,
    this.size = 80.0,
    this.fit = BoxFit.contain,
  });

  /// The width and height of the loading indicator.
  ///
  /// Defaults to 80.0, which matches the native size of the loading animation.
  final double size;

  /// How the animation should be inscribed into the allocated space.
  ///
  /// Defaults to [BoxFit.contain].
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Loading',
      child: Center(
        child: SizedBox(
          width: size,
          height: size,
          child: Lottie.asset(
            'assets/animations/loading.json',
            package: 'ripplearc_coreui',
            fit: fit,
          ),
        ),
      ),
    );
  }
}
