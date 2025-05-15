import 'package:flutter/material.dart';

/// Represents either a Material icon or an SVG icon path
class CoreIconData {
  final IconData? materialIcon;
  final String? svgPath;

  const CoreIconData.material(this.materialIcon) : svgPath = null;

  const CoreIconData.svg(this.svgPath) : materialIcon = null;

  bool get isSvg => svgPath != null;
}
