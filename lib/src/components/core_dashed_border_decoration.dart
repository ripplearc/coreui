import 'dart:math' as math;

import 'package:flutter/material.dart';

/// A dashed rounded-rectangle outline, painted along the inside edge of the
/// box it decorates.
///
/// It is a [Decoration] so a [Container] or [AnimatedContainer] can layer it
/// over its solid decoration through `foregroundDecoration`: layout and the
/// solid border keep animating, and the dashes track the same rectangle a
/// solid border of the same width would occupy.
///
/// Shared by [CoreCalculatorChip]'s dashed variant and any other chip that
/// needs a tentative or offer outline.
@immutable
class CoreDashedBorderDecoration extends Decoration {
  const CoreDashedBorderDecoration({
    required this.color,
    required this.strokeWidth,
    required this.radius,
    required this.dashLength,
    required this.gapLength,
  });

  /// Stroke color of the dashes.
  final Color color;

  /// Stroke width. The outline is inset by half of it so it stays inside the
  /// decorated box.
  final double strokeWidth;

  /// Corner radius of the rounded rectangle the dashes follow.
  final double radius;

  /// Length of each painted dash along the outline.
  final double dashLength;

  /// Length of the gap between consecutive dashes.
  final double gapLength;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _CoreDashedBorderPainter(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoreDashedBorderDecoration &&
          color == other.color &&
          strokeWidth == other.strokeWidth &&
          radius == other.radius &&
          dashLength == other.dashLength &&
          gapLength == other.gapLength;

  @override
  int get hashCode =>
      Object.hash(color, strokeWidth, radius, dashLength, gapLength);
}

class _CoreDashedBorderPainter extends BoxPainter {
  _CoreDashedBorderPainter(this.decoration);

  final CoreDashedBorderDecoration decoration;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final size = configuration.size;
    if (size == null) return;
    final paint = Paint()
      ..color = decoration.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = decoration.strokeWidth;
    final rect = (offset & size).deflate(decoration.strokeWidth / 2);
    final path = Path()
      ..addRRect(
          RRect.fromRectAndRadius(rect, Radius.circular(decoration.radius)));
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final end = math.min(distance + decoration.dashLength, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + decoration.gapLength;
      }
    }
  }
}
