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

class _FunctionKeyTileState extends State<FunctionKeyTile>
    with SingleTickerProviderStateMixin {
  static const Duration _animationDuration = Duration(milliseconds: 200);

  late final AnimationController _animationController;
  late final Animation<double> _animation;
  bool _didFireFromTapUp = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _didFireFromTapUp = false;
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    _didFireFromTapUp = true;
    widget.onTap();
  }

  void _handleTapCancel() {
    _animationController.reverse();
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
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final currentBorderRadius = BorderRadius.lerp(
                BorderRadius.circular(CoreSpacing.space2),
                BorderRadius.circular(100.0),
                _animation.value,
              ) ??
              BorderRadius.circular(CoreSpacing.space2);

          return Listener(
            onPointerDown: (_) => _animationController.forward(),
            onPointerUp: (_) => _animationController.reverse(),
            onPointerCancel: (_) => _animationController.reverse(),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: _handleTapDown,
              onTapUp: _handleTapUp,
              onTapCancel: _handleTapCancel,
              onTap: () {
                if (!_didFireFromTapUp) {
                  _animationController.forward().then((_) {
                    _animationController.reverse();
                  });
                  widget.onTap();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: colors.backgroundGrayMid,
                  borderRadius: currentBorderRadius,
                ),
                child: child,
              ),
            ),
          );
        },
        child: staticChild,
      ),
    );
  }
}
