import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reads the colour drawn at the global [point] inside the RepaintBoundary
/// that [boundary] finds, as a 32-bit ARGB value. Use it to check what the
/// user sees, for example a press fill that a coloured parent would hide:
/// compare it with a theme colour's `toARGB32()`.
Future<int> pixelAt(
  WidgetTester tester,
  Finder boundary,
  Offset point,
) async {
  final renderBoundary = tester.renderObject<RenderRepaintBoundary>(boundary);
  final origin = tester.getTopLeft(boundary);
  final rgba = await tester.runAsync(() async {
    final image = await renderBoundary.toImage();
    final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    final x = (point.dx - origin.dx).floor();
    final y = (point.dy - origin.dy).floor();
    final i = (y * image.width + x) * 4;
    return [for (var c = 0; c < 4; c++) data!.getUint8(i + c)];
  });
  return rgba![3] << 24 | rgba[0] << 16 | rgba[1] << 8 | rgba[2];
}
