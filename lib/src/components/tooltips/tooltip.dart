import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// An enum that defines the position of the tooltip arrow.
///
/// The arrow position indicates which direction the arrow points,
/// which is opposite to where the tooltip appears relative to the child.
///
/// - [none]: No arrow is displayed, tooltip appears above the child
/// - [top]: Arrow points up, tooltip appears below the child
/// - [bottom]: Arrow points down, tooltip appears above the child
/// - [left]: Arrow points left, tooltip appears to the right of the child
/// - [right]: Arrow points right, tooltip appears to the left of the child
enum TooltipArrowPosition { none, top, bottom, left, right }

/// A tooltip widget that displays contextual information when users
/// interact with the child widget.
///
/// The tooltip appears as an overlay with an optional arrow pointing
/// toward the trigger widget. It supports tap-to-show/hide on mobile
/// and hover interactions on desktop.
///
/// ## Example
///
/// ```dart
/// CoreTooltip.top(
///   message: 'This is helpful information',
///   child: Icon(Icons.info),
/// )
/// ```
///
/// ## Named Constructors
///
/// Use named constructors for intuitive positioning:
/// - [CoreTooltip.top]: Tooltip above the child with arrow pointing down
/// - [CoreTooltip.bottom]: Tooltip below the child with arrow pointing up
/// - [CoreTooltip.left]: Tooltip left of the child with arrow pointing right
/// - [CoreTooltip.right]: Tooltip right of the child with arrow pointing left
/// - [CoreTooltip.none]: Tooltip above the child without arrow
///
/// See also:
/// * [TooltipArrowPosition], which controls the arrow direction
class CoreTooltip extends StatefulWidget {
  /// The widget that triggers the tooltip when interacted with.
  final Widget child;

  /// The text message to display in the tooltip.
  final String message;

  /// The position of the arrow on the tooltip.
  ///
  /// Defaults to [TooltipArrowPosition.none].
  final TooltipArrowPosition arrowPosition;

  /// Creates a tooltip with customizable arrow position.
  ///
  /// For most use cases, prefer using the named constructors
  /// like [CoreTooltip.top], [CoreTooltip.bottom], etc.
  const CoreTooltip({
    super.key,
    required this.child,
    required this.message,
    this.arrowPosition = TooltipArrowPosition.none,
  });

  /// Creates a tooltip positioned above the child with arrow pointing down.
  const CoreTooltip.top({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.bottom;

  /// Creates a tooltip positioned below the child with arrow pointing up.
  const CoreTooltip.bottom({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.top;

  /// Creates a tooltip positioned to the left of the child with arrow pointing right.
  const CoreTooltip.left({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.right;

  /// Creates a tooltip positioned to the right of the child with arrow pointing left.
  const CoreTooltip.right({
    super.key,
    required this.child,
    required this.message,
  }) : arrowPosition = TooltipArrowPosition.left;

  /// Creates a tooltip without arrow, positioned above the child.
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

    final entry = _overlayEntry;
    if (entry != null) {
      overlay.insert(entry);
    }
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
    try {
      _overlayEntry?.remove();
    } catch (e) {
      // Overlay entry might already be removed
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Tooltip: ${widget.message}',
      button: true,
      child: MouseRegion(
        onEnter: (_) => _showTooltip(),
        onExit: (_) => _hideTooltip(),
        child: GestureDetector(
          onTap: _isVisible ? _hideTooltip : _showTooltip,
          onLongPress: _isVisible ? _hideTooltip : _showTooltip,
          child: widget.child,
        ),
      ),
    );
  }
}

class _TooltipPositionDelegate extends SingleChildLayoutDelegate {
  final Offset target;
  final Size targetSize;
  final TooltipArrowPosition arrowPosition;

  /// Gap between the tooltip and the target widget
  static const double _tooltipGap = CoreSpacing.space2 + 2;

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
        offset = Offset(
          target.dx + targetSize.width / 2 - childSize.width / 2,
          target.dy + targetSize.height + _tooltipGap,
        );
        break;
      case TooltipArrowPosition.bottom:
        offset = Offset(
          target.dx + targetSize.width / 2 - childSize.width / 2,
          target.dy - childSize.height - _tooltipGap,
        );
        break;
      case TooltipArrowPosition.left:
        offset = Offset(
          target.dx + targetSize.width + _tooltipGap,
          target.dy + targetSize.height / 2 - childSize.height / 2,
        );
        break;
      case TooltipArrowPosition.right:
        offset = Offset(
          target.dx - childSize.width - _tooltipGap,
          target.dy + targetSize.height / 2 - childSize.height / 2,
        );
        break;
      case TooltipArrowPosition.none:
        offset = Offset(
          target.dx + targetSize.width / 2 - childSize.width / 2,
          target.dy - childSize.height - _tooltipGap,
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

  static const double _arrowWidth = CoreSpacing.space3;

  static const double _arrowHeight = CoreSpacing.space3 / 2;

  const _TooltipBubble({
    required this.message,
    required this.arrowPosition,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final text = Text(
      message,
      style: typography.bodySmallRegular.copyWith(color: colors.textInverse),
    );

    final tooltipBody = Container(
      padding: const EdgeInsets.symmetric(
        vertical: CoreSpacing.space1,
        horizontal: CoreSpacing.space2,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundDarkGray,
        borderRadius: BorderRadius.circular(CoreSpacing.space1),
      ),
      child: text,
    );

    final arrow = CustomPaint(
      size: const Size(_arrowWidth, _arrowHeight),
      painter: _TooltipArrowPainter(
        color: colors.backgroundDarkGray,
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
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        break;
      case TooltipArrowPosition.bottom:
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case TooltipArrowPosition.left:
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      case TooltipArrowPosition.right:
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
    final colorTheme = AppColorsExtension.of(context);
    return GestureDetector(
      onTap: onDismiss,
      behavior: HitTestBehavior.translucent,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: colorTheme.transparent),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Material(
              color: colorTheme.transparent,
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
