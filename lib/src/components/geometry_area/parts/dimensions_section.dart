part of '../core_geometry_area.dart';

class _DimensionsSection extends StatefulWidget {
  const _DimensionsSection({
    required this.dimensionsLabel,
    required this.expandLabel,
    required this.collapseLabel,
    required this.dimensions,
    required this.isCollapsed,
  });

  final String dimensionsLabel;
  final String expandLabel;
  final String collapseLabel;
  final List<CoreDimensionData> dimensions;
  final bool isCollapsed;

  @override
  State<_DimensionsSection> createState() => _DimensionsSectionState();
}

class _DimensionsSectionState extends State<_DimensionsSection> {
  late bool _isCollapsed;

  @override
  void initState() {
    super.initState();
    _isCollapsed = widget.isCollapsed;
  }

  @override
  void didUpdateWidget(covariant _DimensionsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isCollapsed != widget.isCollapsed) {
      _isCollapsed = widget.isCollapsed;
    }
  }

  void _toggleCollapse() {
    setState(() {
      _isCollapsed = !_isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final actionLabel =
        _isCollapsed ? widget.expandLabel : widget.collapseLabel;
    final actionIcon =
        _isCollapsed ? CoreIcons.unfoldMore : CoreIcons.unfoldLess;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space4,
            vertical: CoreSpacing.space1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.dimensionsLabel,
                style: typography.bodyLargeSemiBold.copyWith(
                  color: colors.textHeadline,
                ),
              ),
              Semantics(
                button: true,
                label: actionLabel,
                excludeSemantics: true,
                child: GestureDetector(
                  onTap: _toggleCollapse,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ExcludeSemantics(
                        child: CoreIconWidget(
                          icon: actionIcon,
                          color: colors.iconDark,
                          size: CoreIconSize.size24,
                        ),
                      ),
                      Text(
                        actionLabel,
                        style: typography.bodyMediumSemiBold.copyWith(
                          color: colors.textLink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (widget.dimensions.isNotEmpty)
          _DimensionsGrid(
            dimensions: widget.dimensions,
            isCollapsed: _isCollapsed,
          ),
      ],
    );
  }
}

class _DimensionsGrid extends StatelessWidget {
  const _DimensionsGrid({
    required this.dimensions,
    required this.isCollapsed,
  });

  final List<CoreDimensionData> dimensions;
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    const double cardHeight = CoreSpacing.space16;
    const double mainAxisSpacing = CoreSpacing.space2;
    const double topPadding = CoreSpacing.space2;

    // Collapsed peek: show first row fully + half of the second row
    // so the user can see more items are available below.
    const double collapsedHeight =
        topPadding + cardHeight + mainAxisSpacing + (cardHeight / 2);

    Widget grid = GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space4,
        CoreSpacing.space2,
        CoreSpacing.space4,
        CoreSpacing.space4,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: cardHeight,
        crossAxisSpacing: CoreSpacing.space2,
        mainAxisSpacing: mainAxisSpacing,
      ),
      itemCount: dimensions.length,
      itemBuilder: (context, index) {
        final dim = dimensions[index];
        return _DimensionCard(
          data: dim,
          colors: colors,
          typography: typography,
        );
      },
    );

    const int maxVisibleCollapsedItems = 2;
    const double gradientAlpha = 0.2;

    if (isCollapsed && dimensions.length > maxVisibleCollapsedItems) {
      return SizedBox(
        // Extra space2 gives breathing room below the half-visible
        // second row before the ShaderMask fade begins.
        height: collapsedHeight + CoreSpacing.space2,
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.buttonInverse,
                colors.buttonInverse.withValues(alpha: gradientAlpha),
              ],
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn,
          child: grid,
        ),
      );
    }

    return grid;
  }
}
