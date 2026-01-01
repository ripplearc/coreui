import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class TooltipShowcaseScreen extends StatelessWidget {
  const TooltipShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tooltip Components'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: CoreSpacing.space6),

            // First tooltip - arrow pointing down (tooltip above)
            const _TooltipBubble(
              arrowPosition: TooltipArrowPosition.bottom,
            ),

            const SizedBox(height: CoreSpacing.space12),

            // Second tooltip - arrow pointing up (tooltip below)
            const _TooltipBubble(
              arrowPosition: TooltipArrowPosition.top,
            ),

            const SizedBox(height: CoreSpacing.space12),

            // Third tooltip - arrow pointing down (tooltip above)
            const _TooltipBubble(
              arrowPosition: TooltipArrowPosition.bottom,
            ),

            const SizedBox(height: CoreSpacing.space12),

            // Fourth tooltip - arrow pointing right (tooltip left)
            const _TooltipBubble(
              arrowPosition: TooltipArrowPosition.right,
            ),

            const SizedBox(height: CoreSpacing.space12),

            // Fifth tooltip - no arrow
            const _TooltipBubble(
              arrowPosition: TooltipArrowPosition.none,
            ),
          ],
        ),
      ),
    );
  }
}

class _TooltipBubble extends StatelessWidget {
  final TooltipArrowPosition arrowPosition;

  const _TooltipBubble({
    required this.arrowPosition,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>()!;

    const arrowWidth = 12.0;
    const arrowHeight = 8.0;

    final tooltipBody = Container(
      padding: const EdgeInsets.symmetric(
        vertical: CoreSpacing.space2,
        horizontal: CoreSpacing.space4,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundDarkGray,
        borderRadius: BorderRadius.circular(CoreSpacing.space2),
      ),
      child: Text(
        'My Tooltip',
        style: CoreTypography.bodyMediumRegular(color: colors.textInverse),
      ),
    );

    final arrow = CustomPaint(
      size: const Size(arrowWidth, arrowHeight),
      painter: _ArrowPainter(
        color: colors.backgroundDarkGray,
        position: arrowPosition,
      ),
    );

    if (arrowPosition == TooltipArrowPosition.none) {
      return tooltipBody;
    }

    switch (arrowPosition) {
      case TooltipArrowPosition.bottom:
        // Arrow points down
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            tooltipBody,
            arrow,
          ],
        );
      case TooltipArrowPosition.top:
        // Arrow points up
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            arrow,
            tooltipBody,
          ],
        );
      case TooltipArrowPosition.right:
        // Arrow points right
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            tooltipBody,
            arrow,
          ],
        );
      case TooltipArrowPosition.left:
        // Arrow points left
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            arrow,
            tooltipBody,
          ],
        );
      case TooltipArrowPosition.none:
        return tooltipBody;
    }
  }
}

class _ArrowPainter extends CustomPainter {
  final Color color;
  final TooltipArrowPosition position;

  _ArrowPainter({
    required this.color,
    required this.position,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();

    switch (position) {
      case TooltipArrowPosition.bottom:
        // Arrow points down
        path.moveTo(0, 0);
        path.lineTo(size.width / 2, size.height);
        path.lineTo(size.width, 0);
        break;
      case TooltipArrowPosition.top:
        // Arrow points up
        path.moveTo(0, size.height);
        path.lineTo(size.width / 2, 0);
        path.lineTo(size.width, size.height);
        break;
      case TooltipArrowPosition.left:
        // Arrow points left
        path.moveTo(size.width, 0);
        path.lineTo(0, size.height / 2);
        path.lineTo(size.width, size.height);
        break;
      case TooltipArrowPosition.right:
        // Arrow points right
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
  bool shouldRepaint(_ArrowPainter oldDelegate) => false;
}
