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
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startPressFeedback(TapDownDetails details) {
    if (!_isPressed) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapDown(TapDownDetails details) => _startPressFeedback(details);

  void _endPressFeedback(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapUp(TapUpDetails details) => _endPressFeedback(details);

  void _cancelPressFeedback() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() => _cancelPressFeedback();

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
              child: Center(
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
              ),
            ),
          );
        },
      ),
    );
  }
}
