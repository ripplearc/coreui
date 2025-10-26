import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

enum TooltipArrowPosition { none, top, bottom, left, right }

class CoreTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final TooltipArrowPosition arrowPosition;

  const CoreTooltip({
    super.key,
    required this.child,
    required this.message,
    this.arrowPosition = TooltipArrowPosition.none,
  });

  /// Tooltip positioned above the child with arrow pointing down
  const CoreTooltip.top({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.bottom;

  /// Tooltip positioned below the child with arrow pointing up
  const CoreTooltip.bottom({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.top;

  /// Tooltip positioned to the left of the child with arrow pointing right
  const CoreTooltip.left({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.right;

  /// Tooltip positioned to the right of the child with arrow pointing left
  const CoreTooltip.right({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.left;

  /// Tooltip without arrow, positioned above the child
  const CoreTooltip.none({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.none;

  @override
  State<CoreTooltip> createState() => _CoreTooltipState();
}

class _CoreTooltipState extends State<CoreTooltip>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  bool _isAnimating = false;

  bool get _isVisible => _overlayEntry != null;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  void _showTooltip() {
    if (_isVisible || _isAnimating) return;

    _isAnimating = true;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final targetPosition = renderBox.localToGlobal(Offset.zero);
    final targetSize = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _TooltipOverlayWidget(
        targetPosition: targetPosition,
        targetSize: targetSize,
        message: widget.message,
        arrowPosition: widget.arrowPosition,
        fadeAnimation: _fadeAnimation,
        onDismiss: _hideTooltip,
      ),
    );

    overlay.insert(_overlayEntry!);
    _controller.forward(from: 0).then((_) {
      if (mounted) {
        _isAnimating = false;
      }
    });
  }

  void _hideTooltip() {
    if (!_isVisible || _isAnimating) return;
    _isAnimating = true;

    _controller.reverse().then((_) {
      if (mounted) {
        try {
          _overlayEntry?.remove();
        } catch (e) {
          // Overlay entry might already be removed
        }
        _overlayEntry = null;
        _isAnimating = false;
      }
    }).catchError((e) {
      if (mounted) {
        _isAnimating = false;
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isVisible ? _hideTooltip : _showTooltip,
      onLongPress: _isVisible ? _hideTooltip : _showTooltip,
      child: widget.child,
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  final Offset target;
  final Size targetSize;
  final TooltipArrowPosition arrowPosition;

  _TooltipPositionDelegate({
    required this.target,
    required this.targetSize,
    required this.arrowPosition,
  });

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    late Offset offset;

    switch (arrowPosition) {
      case TooltipArrowPosition.top:
        // Arrow points UP - tooltip is BELOW the target
        offset = Offset(
          target.dx + targetSize.width / 2 - childSize.width / 2,
          target.dy + targetSize.height + 10,
        );
        break;
      case TooltipArrowPosition.bottom:
        // Arrow points DOWN - tooltip is ABOVE the target
        offset = Offset(
          target.dx + targetSize.width / 2 - childSize.width / 2,
          target.dy - childSize.height - 10,
        );
        break;
      case TooltipArrowPosition.left:
        // Arrow points LEFT - tooltip is RIGHT of the target
        offset = Offset(
          target.dx + targetSize.width + 10,
          target.dy + targetSize.height / 2 - childSize.height / 2,
        );
        break;
      case TooltipArrowPosition.right:
        // Arrow points RIGHT - tooltip is LEFT of the target
        offset = Offset(
          target.dx - childSize.width - 10,
          target.dy + targetSize.height / 2 - childSize.height / 2,
        );
        break;
      case TooltipArrowPosition.none:
        // No arrow - tooltip is ABOVE the target
        offset = Offset(
          target.dx + targetSize.width / 2 - childSize.width / 2,
          target.dy - childSize.height - 10,
        );
        break;
    }

    return offset;
  }

  @override
  bool shouldRelayout(_TooltipPositionDelegate oldDelegate) {
    return target != oldDelegate.target ||
        targetSize != oldDelegate.targetSize ||
        arrowPosition != oldDelegate.arrowPosition;
  }
}

class _TooltipBubble extends StatelessWidget {
  final String message;
  final TooltipArrowPosition arrowPosition;

  const _TooltipBubble({
    required this.message,
    required this.arrowPosition,
  });

  @override
  Widget build(BuildContext context) {
    final text = Text(
      message,
      style: CoreTypography.bodySmallRegular(color: CoreTextColors.inverse),
    );

    final tooltipBody = Container(
      padding: const EdgeInsets.symmetric(
        vertical: CoreSpacing.space1,
        horizontal: CoreSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: CoreBackgroundColors.backgroundDarkGray,
        borderRadius: BorderRadius.circular(CoreSpacing.space1),
      ),
      child: text,
    );

    final arrow = CustomPaint(
      size: const Size(12, 6),
      painter: _TooltipArrowPainter(
        color: CoreBackgroundColors.backgroundDarkGray,
        position: arrowPosition,
      ),
    );

    switch (arrowPosition) {
      case TooltipArrowPosition.none:
        return tooltipBody;
      case TooltipArrowPosition.top:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [arrow, tooltipBody],
        );
      case TooltipArrowPosition.bottom:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [tooltipBody, arrow],
        );
      case TooltipArrowPosition.left:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [arrow, tooltipBody],
        );
      case TooltipArrowPosition.right:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [tooltipBody, arrow],
        );
    }
  }
}

class _TooltipArrowPainter extends CustomPainter {
  final Color color;
  final TooltipArrowPosition position;

  const _TooltipArrowPainter({
    required this.color,
    required this.position,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();

    switch (position) {
      case TooltipArrowPosition.top:
        // Arrow points UP (towards child above)
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        break;
      case TooltipArrowPosition.bottom:
        // Arrow points DOWN (towards child below)
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case TooltipArrowPosition.left:
        // Arrow points LEFT (towards child on left)
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      case TooltipArrowPosition.right:
        // Arrow points RIGHT (towards child on right)
        path.moveTo(0, 0);
        path.lineTo(size.width, size.height / 2);
        path.lineTo(0, size.height);
        break;
      case TooltipArrowPosition.none:
        break;
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TooltipArrowPainter oldDelegate) => false;
}

class _TooltipOverlayWidget extends StatelessWidget {
  final Offset targetPosition;
  final Size targetSize;
  final String message;
  final TooltipArrowPosition arrowPosition;
  final Animation<double> fadeAnimation;
  final VoidCallback onDismiss;

  const _TooltipOverlayWidget({
    required this.targetPosition,
    required this.targetSize,
    required this.message,
    required this.arrowPosition,
    required this.fadeAnimation,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: Colors.transparent,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Stack(
                      children: [
                        CustomSingleChildLayout(
                          delegate: _TooltipPositionDelegate(
                            target: targetPosition,
                            targetSize: targetSize,
                            arrowPosition: arrowPosition,
                          ),
                          child: _TooltipBubble(
                            message: message,
                            arrowPosition: arrowPosition,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
