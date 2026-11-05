import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A one-line error under or inside a form or list: a red error icon, the
/// message in the error colour and, optionally, a link-style action such as
/// "Try again".
///
/// The icon and message are one live region, so a screen reader announces the
/// message when the row appears. The action is its own button; its tap zone is
/// at least 48 dp square. The row knows nothing about what failed: the caller
/// passes the already localised [message] and decides what [onAction] does.
class CoreInlineErrorRow extends StatelessWidget {
  /// The error text, already localised. Wraps onto more lines when long.
  final String message;

  /// Link-style text after the message, e.g. "Try again"; given with
  /// [onAction] or not at all.
  final String? actionLabel;

  /// Called when [actionLabel] is tapped.
  final VoidCallback? onAction;

  /// Key of the action's tap zone, so a test can find the action.
  final Key? actionKey;

  /// Creates an inline error row.
  const CoreInlineErrorRow({
    super.key,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.actionKey,
  }) : assert((actionLabel == null) == (onAction == null));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.coreColors;
    final typography = theme.coreTypography;
    final action = actionLabel;
    final messageStyle = typography.bodySmallRegular.copyWith(
      color: colors.textError,
    );
    final firstLineHeight =
        (messageStyle.fontSize ?? 0) * (messageStyle.height ?? 1);

    return LayoutBuilder(
      builder: (context, constraints) => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Semantics(
              container: true,
              liveRegion: true,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: firstLineHeight,
                    child: Center(
                      child: CoreIconWidget(
                        icon: CoreIcons.error,
                        size: CoreIconSize.size14,
                        color: colors.textError,
                      ),
                    ),
                  ),
                  const SizedBox(width: CoreSpacing.space2),
                  Expanded(
                    child: Text(
                      message,
                      style: messageStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (action != null)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth / 2),
              child: _InlineErrorAction(
                key: actionKey,
                label: action,
                onTap: onAction,
              ),
            ),
        ],
      ),
    );
  }
}

class _InlineErrorAction extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;

  const _InlineErrorAction({super.key, required this.label, this.onTap});

  @override
  State<_InlineErrorAction> createState() => _InlineErrorActionState();
}

class _InlineErrorActionState extends State<_InlineErrorAction> {
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.coreColors;
    final typography = theme.coreTypography;

    return Semantics(
      container: true,
      button: true,
      label: widget.label,
      child: Material(
        type: MaterialType.transparency,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: CoreSpacing.space12,
            minHeight: CoreSpacing.space12,
          ),
          child: InkWell(
            onTap: widget.onTap,
            onFocusChange: (focused) => setState(() => _focused = focused),
            onHighlightChanged: (pressed) => setState(() => _pressed = pressed),
            overlayColor: WidgetStatePropertyAll(colors.transparent),
            splashFactory: NoSplash.splashFactory,
            child: CustomPaint(
              painter: _ActionHighlightPainter(
                color: _pressed ? colors.backgroundGrayMid : null,
              ),
              foregroundPainter: _ActionHighlightPainter(
                ringColor: _focused ? colors.outlineFocus : null,
              ),
              child: ExcludeSemantics(
                child: Center(
                  widthFactor: 1,
                  heightFactor: 1,
                  child: Text(
                    widget.label,
                    style: typography.bodyLargeSemiBold.copyWith(
                      color: colors.textLink,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionHighlightPainter extends CustomPainter {
  static const double _reach = CoreSpacing.space2;
  static const double _ringWidth = 2;

  static final _radius = BorderRadius.circular(CoreSpacing.space2);

  final Color? color;
  final Color? ringColor;

  const _ActionHighlightPainter({this.color, this.ringColor});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = _radius.toRRect(
      Rect.fromLTWH(-_reach, 0, size.width + 2 * _reach, size.height),
    );
    final fill = color;
    if (fill != null) {
      canvas.drawRRect(rect, Paint()..color = fill);
    }
    final ring = ringColor;
    if (ring != null) {
      canvas.drawRRect(
        rect.deflate(_ringWidth / 2),
        Paint()
          ..color = ring
          ..style = PaintingStyle.stroke
          ..strokeWidth = _ringWidth,
      );
    }
  }

  @override
  bool shouldRepaint(_ActionHighlightPainter old) =>
      old.color != color || old.ringColor != ringColor;
}
