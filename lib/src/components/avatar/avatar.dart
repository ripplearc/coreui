import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A circular avatar widget that displays an image from an [ImageProvider].
///
/// This widget is a replacement for Flutter's [CircleAvatar] and is implemented
/// using a [Container] with a circular [BoxDecoration].
class CoreAvatar extends StatelessWidget {
  /// The image to display in the avatar.
  ///
  /// If both [image] and [child] are provided, [image] takes precedence.
  final ImageProvider? image;

  /// The radius of the avatar.
  ///
  /// The avatar will be a circle with diameter equal to `radius * 2`.
  final double? radius;

  /// The minimum radius of the avatar.
  ///
  /// If [radius] is null, the avatar will use [minRadius] as the radius.
  final double? minRadius;

  /// The maximum radius of the avatar.
  ///
  /// If [radius] is null and [minRadius] is also null, the avatar will use
  /// [maxRadius] as the radius.
  final double? maxRadius;

  /// The background color of the avatar.
  ///
  /// This color is shown behind the image or child widget.
  final Color? backgroundColor;

  /// A widget to display in the avatar when [image] is not provided.
  ///
  /// Typically a [Text] widget displaying initials or an [Icon].
  final Widget? child;

  /// Optional semantic label for accessibility.
  ///
  /// This label is used by screen readers to describe the avatar.
  final String? semanticLabel;

  /// Creates a circular avatar widget.
  ///
  /// Either [radius] or both [minRadius] and [maxRadius] must be provided.
  /// If [radius] is provided, it takes precedence.
  ///
  /// If both [image] and [child] are provided, [image] takes precedence.
  const CoreAvatar({
    super.key,
    this.image,
    this.radius,
    this.minRadius,
    this.maxRadius,
    this.backgroundColor,
    this.child,
    this.semanticLabel,
  }) : assert(
          radius != null || (minRadius != null && maxRadius != null),
          'Either radius or both minRadius and maxRadius must be provided',
        );

  double get _effectiveRadius {
    final radiusValue = radius;
    if (radiusValue != null) {
      return radiusValue;
    }

    final minRadiusValue = minRadius;
    final maxRadiusValue = maxRadius;
    if (minRadiusValue != null && maxRadiusValue != null) {
      return (minRadiusValue + maxRadiusValue) / 2;
    }

    return CoreSpacing.space5;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = _effectiveRadius;
    final size = effectiveRadius * 2;
    final imageValue = image;
    final decorationImage = imageValue != null
        ? DecorationImage(
            image: imageValue,
            fit: BoxFit.cover,
          )
        : null;

    return Semantics(
      label: semanticLabel ?? 'Avatar for image or child',
      child: Container(
        width: size,
        height: size,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          image: decorationImage,
        ),
        child: imageValue == null ? child : null,
      ),
    );
  }
}

