part of '../../core_display_area.dart';

typedef _BandPaint = ({
  int start,
  int end,
  Color fill,
  Color edge,
  double opacity,
});

_BandPaint? _bandPaintFor(
  CoreWorkedFirstBand? band, {
  required int chipCount,
  required AppColorsExtension colors,
  double opacity = 1,
}) {
  final lastChip = chipCount - 1;
  if (band == null || band.start > lastChip || opacity <= 0) return null;
  return (
    start: band.start,
    end: math.min(band.end, lastChip),
    fill: colors.backgroundWorkedFirstBand,
    edge: colors.lineWorkedFirstBand,
    opacity: opacity,
  );
}

String? _bandLabelToAnnounce(
  CoreWorkedFirstBand? band, {
  required int chipCount,
}) {
  if (band == null || band.start >= chipCount) return null;
  return band.semanticsLabel.isEmpty ? null : band.semanticsLabel;
}

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
      final fill = Paint()
        ..color = band.fill.withValues(alpha: band.fill.a * band.opacity);
      final edge = Paint()
        ..color = band.edge.withValues(alpha: band.edge.a * band.opacity)
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

class _AnnouncedBandedWrap extends StatelessWidget {
  const _AnnouncedBandedWrap({
    required this.spacing,
    required this.runSpacing,
    required this.children,
    required this.band,
    required this.label,
  });

  final double spacing;
  final double runSpacing;
  final List<Widget> children;
  final _BandPaint? band;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final isAnnounced = label != null;
    return Semantics(
      container: isAnnounced,
      explicitChildNodes: isAnnounced,
      label: label,
      child: _BandedWrap(
        spacing: spacing,
        runSpacing: runSpacing,
        band: band,
        children: children,
      ),
    );
  }
}

class _FadingBand extends StatefulWidget {
  const _FadingBand({
    required this.band,
    required this.chips,
    required this.builder,
  });

  final CoreWorkedFirstBand? band;
  final List<CoreCalculatorChip> chips;
  final Widget Function(BuildContext context, _BandPaint? band) builder;

  static const Duration fadeDuration = Duration(milliseconds: 150);

  @override
  State<_FadingBand> createState() => _FadingBandState();
}

class _FadingBandState extends State<_FadingBand> {
  CoreWorkedFirstBand? _shown;

  @override
  void initState() {
    super.initState();
    _shown = widget.band;
  }

  @override
  void didUpdateWidget(_FadingBand oldWidget) {
    super.didUpdateWidget(oldWidget);
    final band = widget.band;
    if (band != null) {
      _shown = band;
    } else if (!_theBandedChipsAreStillThere(oldWidget.chips)) {
      _shown = null;
    }
  }

  bool _theBandedChipsAreStillThere(List<CoreCalculatorChip> before) {
    final shown = _shown;
    final after = widget.chips;
    if (shown == null || shown.start >= after.length) return false;
    final end = math.min(shown.end, before.length - 1);
    if (end >= after.length) return false;
    for (var index = shown.start; index <= end; index++) {
      final was = before[index];
      final now = after[index];
      final isTheSameChip = Widget.canUpdate(was, now) &&
          was.label == now.label &&
          was.value == now.value;
      if (!isTheSameChip) return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(end: widget.band == null ? 0 : 1),
      duration: _FadingBand.fadeDuration,
      builder: (context, opacity, _) => widget.builder(
        context,
        _bandPaintFor(
          _shown,
          chipCount: widget.chips.length,
          colors: colors,
          opacity: opacity,
        ),
      ),
    );
  }
}
