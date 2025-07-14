import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/icons/icon_data.dart';

/// Core icon widget that supports both Material and SVG icons
/// [icon] is the icon data to be displayed
/// [size] is the size of the icon
/// [color] is the color of the icon
/// [semanticLabel] is the semantic label for the icon
/// [onTap] is the callback function when the icon is tapped
/// [padding] is the padding around the icon
class CoreIconWidget extends StatelessWidget {
  final CoreIconData icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const CoreIconWidget({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.semanticLabel,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;

    if (icon.isSvg) {
      iconWidget = SvgPicture.asset(
        icon.svgPath!,
        width: size,
        height: size,
        colorFilter:
            color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
        fit: BoxFit.contain,
      );
    } else {
      iconWidget = Icon(
        icon.materialIcon,
        size: size,
        color: color,
        semanticLabel: semanticLabel,
      );
    }

    if (padding != null) {
      iconWidget = Padding(padding: padding!, child: iconWidget);
    }

    if (onTap != null) {
      return IconButton(
        icon: iconWidget,
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      );
    }

    return iconWidget;
  }
}
