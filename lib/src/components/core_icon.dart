import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/icons/icon_data.dart';

/// Core icon widget that supports both Material and SVG icons.
class CoreIconWidget extends StatelessWidget {
  /// The icon to draw, a Material icon or an SVG asset.
  final CoreIconData icon;

  /// Width and height in px. When null a Material icon takes the
  /// [IconTheme] size and an SVG its own size.
  final double? size;

  /// Colour of the icon. When null a Material icon takes the [IconTheme]
  /// colour and an SVG keeps the colours in its file.
  final Color? color;

  /// Screen-reader label. When null the icon has no label.
  final String? semanticLabel;

  /// Called on tap. When set the icon is wrapped in an [IconButton]; when
  /// null it does not react to taps.
  final VoidCallback? onTap;

  /// Space around the icon, inside the tap area when [onTap] is set. Null
  /// adds none.
  final EdgeInsetsGeometry? padding;
  /// Controls the compactness of the [IconButton]. Defaults to null (platform default).
  final VisualDensity? visualDensity;

  /// Creates an icon; it reacts to taps only when [onTap] is set.
  const CoreIconWidget({super.key,
    required this.icon,
    this.size,
    this.color,
    this.semanticLabel,
    this.onTap,
    this.padding,
    this.visualDensity});

  @override
  Widget build(BuildContext context) {
    Widget iconWidget;
    final iconColor = color;

    if (icon.isSvg) {
      iconWidget = SvgPicture.asset(
        icon.svgPath ?? '',
        width: size,
        height: size,
        colorFilter: iconColor != null
            ? ColorFilter.mode(iconColor, BlendMode.srcIn)
            : null,
        fit: BoxFit.contain,
        semanticsLabel: semanticLabel,
      );
    } else {
      iconWidget = Icon(
        icon.materialIcon,
        size: size,
        color: iconColor,
        semanticLabel: semanticLabel,
      );
    }

    final iconPadding = padding;
    if (iconPadding != null) {
      iconWidget = Padding(padding: iconPadding, child: iconWidget);
    }

    if (onTap != null) {
      return IconButton(
        icon: iconWidget,
        onPressed: onTap,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        visualDensity: visualDensity,
      );
    }

    return iconWidget;
  }
}
