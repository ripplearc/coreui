import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import 'keyboard_models.dart';

/// A tile widget for displaying a single function key.
///
/// [keyType] is the key data to display.
/// [onTap] is called when the key is tapped.
/// [hasPadding] determines whether to add padding around the key (default: false).
/// [customHint] is an optional custom semantic hint. If not provided, uses keyType.semanticLabel.
class FunctionKeyTile extends StatefulWidget {
  final KeyType keyType;
  final VoidCallback onTap;
  final bool hasPadding;
  final String? customHint;

  const FunctionKeyTile({
    super.key,
    required this.keyType,
    required this.onTap,
    this.hasPadding = false,
    this.customHint,
  });

  @override
  State<FunctionKeyTile> createState() => _FunctionKeyTileState();
}

class _FunctionKeyTileState extends State<FunctionKeyTile> {
  bool _isPressed = false;
  static const double _tweenBegin = 0.0;
  static const double _tweenEndPressed = 1.0;
  static const double _tweenEndUnpressed = 0.0;
  static const Duration _tweenDuration = Duration(milliseconds: 200);

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final semanticHint = widget.customHint ??
        widget.keyType.semanticLabel ??
        'Tap to use ${widget.keyType.label} function';

    final semanticLabel = widget.keyType.semanticLabel != null
        ? '${widget.keyType.label} function key'
        : 'Function key ${widget.keyType.label}';

    final staticChild = Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.keyType.icon != null) ...[
            Icon(
              widget.keyType.icon,
              color: colors.textHeadline,
              size: CoreSpacing.space4,
            ),
            const SizedBox(width: CoreSpacing.space1),
          ],
          Flexible(
            child: Text(
              widget.keyType.label,
              style: typography.bodyMediumRegular.copyWith(
                color: colors.textHeadline,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );

    return Semantics(
      label: semanticLabel,
      button: true,
      hint: semanticHint,
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(
            begin: _tweenBegin,
            end: _isPressed ? _tweenEndPressed : _tweenEndUnpressed),
        duration: _tweenDuration,
        curve: Curves.easeInOut,
        builder: (context, animationValue, child) {
          final currentBorderRadius = BorderRadius.lerp(
                BorderRadius.circular(CoreSpacing.space2),
                BorderRadius.circular(100.0),
                animationValue,
              ) ??
              BorderRadius.circular(CoreSpacing.space2);

          return GestureDetector(
            onTap: widget.onTap,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            child: Container(
              decoration: BoxDecoration(
                color: colors.backgroundGrayMid,
                borderRadius: currentBorderRadius,
              ),
              child: child,
            ),
          );
        },
        child: staticChild,
      ),
    );
  }
}
