part of '../../core_display_area.dart';

typedef _BandPaint = ({int start, int end, Color fill, Color edge});

class _BandedWrap extends Wrap {
  const _BandedWrap({
    required super.spacing,
    required super.runSpacing,
    required super.children,
    required this.band,
  });

  final _BandPaint? band;

  @override
  RenderWrap createRenderObject(BuildContext context) {
    return _RenderBandedWrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection ?? Directionality.maybeOf(context),
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      band: band,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderBandedWrap renderObject,
  ) {
    super.updateRenderObject(context, renderObject);
    renderObject.band = band;
  }
}

class _RenderBandedWrap extends RenderWrap {
  _RenderBandedWrap({
    required super.direction,
    required super.alignment,
    required super.spacing,
    required super.runAlignment,
    required super.runSpacing,
    required super.crossAxisAlignment,
    required super.textDirection,
    required super.verticalDirection,
    required super.clipBehavior,
    required _BandPaint? band,
  }) : _band = band;

  static const double sideReach = CoreSpacing.space2 - CoreSpacing.space1 / 2;
  static const EdgeInsets _reach = EdgeInsets.symmetric(
    horizontal: sideReach,
    vertical: CoreSpacing.space1,
  );
  static const double _cornerRadius = CoreSpacing.space3;

  _BandPaint? _band;
  _BandPaint? get band => _band;
  set band(_BandPaint? value) {
    if (value == _band) return;
    _band = value;
    markNeedsPaint();
  }

  List<Rect> get bandRects {
    final band = _band;
    if (band == null) return const [];
    final byRun = <double, Rect>{};
    var index = 0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      final parentData = child.parentData;
      final isUnderTheBand = index >= band.start && index <= band.end;
      if (isUnderTheBand && parentData is WrapParentData) {
        final rect = parentData.offset & child.size;
        final run = byRun[parentData.offset.dy];
        byRun[parentData.offset.dy] =
            run == null ? rect : run.expandToInclude(rect);
      }
      index++;
    }
    return [for (final rect in byRun.values) _reach.inflateRect(rect)];
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final band = _band;
    if (band != null) {
      final fill = Paint()..color = band.fill;
      final edge = Paint()
        ..color = band.edge
        ..style = PaintingStyle.stroke
        ..strokeWidth = CoreStrokes.hairline;
      for (final rect in bandRects) {
        final box = RRect.fromRectAndRadius(
          rect.shift(offset),
          const Radius.circular(_cornerRadius),
        );
        context.canvas.drawRRect(box, fill);
        context.canvas.drawRRect(box.deflate(CoreStrokes.hairline / 2), edge);
      }
    }
    super.paint(context, offset);
  }
}
