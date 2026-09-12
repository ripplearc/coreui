import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A comprehensive keyboard widget for calculator input with unit selection, operators, and function keys.
///
/// [currentGroup] is the currently active function group.
/// [allGroups] is the list of all available function groups.
/// [onDigitPressed] is called when a digit button is pressed.
/// [onUnitSelected] is called when a unit button is selected.
/// [onOperatorPressed] is called when an operator button is pressed.
/// [onControlAction] is called when a control action is triggered.
/// [onResultTapped] is called when the result button is tapped.
/// [onGroupSelected] is called when a function group is selected.
/// [onKeyTapped] is called when a function key is tapped.
/// [onUnitSystemChanged] is called when the unit system changes.
/// [result] is the type of result to display on the result button.
/// [currentUnitSystem] is the current unit system (imperial or metric).
/// [groupAccentColors] is a map of group names to their accent colors.
/// [customResultLabel] is an optional custom label for the result button.
///
/// ## Group swipe
/// A horizontal swipe on the function-key strip selects the previous (swipe
/// right) or next (swipe left) group in [allGroups] through [onGroupSelected],
/// wrapping at either end. One gesture selects one group, a drag shorter than
/// [groupSwipeThreshold] is ignored, and a tap on a key never counts as a
/// swipe. The "View all" sheet stays the non-gesture equivalent, and the
/// keyboard holds no group order of its own: a reorder made in that sheet
/// reaches the consumer through [onGroupsReordered].
class CoreKeyboard extends StatefulWidget {
  const CoreKeyboard({
    super.key,
    required this.currentGroup,
    required this.allGroups,
    required this.onDigitPressed,
    required this.onUnitSelected,
    required this.onOperatorPressed,
    required this.onControlAction,
    required this.onResultTapped,
    required this.onGroupSelected,
    required this.onKeyTapped,
    required this.onUnitSystemChanged,
    this.result = const ResultType(label: '='),
    this.currentUnitSystem = UnitSystem.imperial,
    this.groupAccentColors = const {},
    this.customResultLabel,
    this.onCollapseChanged,
    this.onGroupsReordered,
    this.reorderSemanticsLabelBuilder,
  });

  /// Minimum horizontal travel for a drag on the function-key strip to count
  /// as a group swipe; anything shorter is ignored so a wobbly tap never
  /// changes the group.
  static const double groupSwipeThreshold = CoreSpacing.space16;

  final GroupNameType currentGroup;
  final List<FunctionGroup> allGroups;
  final ValueChanged<DigitType> onDigitPressed;
  final ValueChanged<UnitType> onUnitSelected;
  final ValueChanged<OperatorType> onOperatorPressed;
  final ValueChanged<ControlAction> onControlAction;
  final VoidCallback onResultTapped;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;
  final ResultType result;
  final UnitSystem currentUnitSystem;
  final ValueChanged<UnitSystem> onUnitSystemChanged;
  final Map<GroupNameType, Color> groupAccentColors;
  final String? customResultLabel;
  final ValueChanged<bool>? onCollapseChanged;

  /// Called when the user drags a group to a new position in the "View all"
  /// sheet, with its old index and its final index; both are in range for
  /// [allGroups]. The consumer reorders [allGroups] — in place or as a new
  /// list — and rebuilds; the sheet re-renders while open whenever
  /// [allGroups] or the order of its groups changes.
  final void Function(int oldIndex, int newIndex)? onGroupsReordered;

  /// Builds the screen-reader label of a group's drag handle in the "View
  /// all" sheet from the group label. Defaults to
  /// [CoreFunctionKeyBottomSheet.defaultReorderSemanticsLabel].
  final String Function(String groupLabel)? reorderSemanticsLabelBuilder;

  @override
  State<CoreKeyboard> createState() => _CoreKeyboardState();
}

class _CoreKeyboardState extends State<CoreKeyboard>
    with SingleTickerProviderStateMixin {
  static const double _dragIndicatorHeight = CoreSpacing.space2;
  static const double _dragIndicatorWidth = CoreSpacing.space8;

  bool _isCollapsed = false;
  double _groupSwipeDistance = 0;
  _FunctionsSheetHostState? _openFunctionsSheet;
  List<GroupNameType> _groupOrder = const [];

  late final AnimationController _controller;
  final GlobalKey _contentKey = GlobalKey();
  double _contentHeight = 300.0;

  @override
  void initState() {
    super.initState();
    _groupOrder = _orderOf(widget.allGroups);
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CoreKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final order = _orderOf(widget.allGroups);
    final groupsChanged = !identical(widget.allGroups, oldWidget.allGroups) ||
        !listEquals(order, _groupOrder);
    _groupOrder = order;
    final sheet = _openFunctionsSheet;
    if (groupsChanged && sheet != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => sheet.refresh());
    }
  }

  static List<GroupNameType> _orderOf(List<FunctionGroup> groups) =>
      [for (final group in groups) group.name];

  void _handleGroupSwipeUpdate(DragUpdateDetails details) {
    _groupSwipeDistance += details.delta.dx;
  }

  void _handleGroupSwipeEnd(DragEndDetails details) {
    final distance = _groupSwipeDistance;
    _groupSwipeDistance = 0;
    if (distance.abs() < CoreKeyboard.groupSwipeThreshold) return;
    _selectNeighborGroup(forward: distance < 0);
  }

  void _handleGroupSwipeCancel() {
    _groupSwipeDistance = 0;
  }

  void _selectNeighborGroup({required bool forward}) {
    final groups = widget.allGroups;
    if (groups.length < 2) return;
    final current = groups.indexWhere((g) => g.name == widget.currentGroup);
    final step = forward ? 1 : groups.length - 1;
    final next = ((current < 0 ? 0 : current) + step) % groups.length;
    widget.onGroupSelected(groups[next].name);
  }

  void _updateContentHeight() {
    final RenderBox? renderBox =
        _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null && renderBox.size.height > 0) {
      _contentHeight = renderBox.size.height;
    }
  }

  void _collapse() {
    _controller.animateTo(0.0, curve: Curves.easeOutCubic);
    if (!_isCollapsed) {
      setState(() => _isCollapsed = true);
      widget.onCollapseChanged?.call(true);
    }
  }

  void _expand() {
    _controller.animateTo(1.0, curve: Curves.easeOutCubic);
    if (_isCollapsed) {
      setState(() => _isCollapsed = false);
      widget.onCollapseChanged?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.allGroups.firstWhere(
      (g) => g.name == widget.currentGroup,
      orElse: () => widget.allGroups.isNotEmpty
          ? widget.allGroups.first
          : const FunctionGroup(
              name: GroupNameType(
                id: "Basic Geometry",
                label: "Basic Geometry",
              ),
              keys: []),
    );
    final colors = Theme.of(context).coreColors;
    final accent = widget.groupAccentColors[widget.currentGroup] ??
        colors.keyboardFunctions;

    return Container(
      decoration: BoxDecoration(
          color: colors.pageBackground,
          borderRadius: const BorderRadius.vertical(
              top: Radius.circular(CoreSpacing.space8)),
          boxShadow: CoreShadows.sticky),
      child: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final functionStripSpacing = CoreSpacing.space3;
            const double horizontalPadding = CoreSpacing.space3;
            const double verticalPadding = CoreSpacing.space3;
            final double maxHeightSpacing = CoreSpacing.space2;
            const int columnCount = 5;
            const double maxButtonSize = CoreSpacing.space20;
            const double minButtonSize = CoreSpacing.space10;
            const double minSpacing = CoreSpacing.space1;
            final availableWidth = constraints.maxWidth;
            final widthForContent = availableWidth - (horizontalPadding * 2);

            final double idealTotalWidth = (maxButtonSize * columnCount) +
                (minSpacing * (columnCount - 1));

            double finalButtonWidth;
            double finalSpacing;

            if (widthForContent > idealTotalWidth) {
              finalButtonWidth = maxButtonSize;
              finalSpacing =
                  (widthForContent - (finalButtonWidth * columnCount)) /
                      (columnCount - 1);
            } else {
              finalSpacing = minSpacing;
              finalButtonWidth =
                  (widthForContent - (finalSpacing * (columnCount - 1))) /
                      columnCount;

              if (finalButtonWidth < minButtonSize) {
                finalButtonWidth = minButtonSize;
              }
            }

            // Fixed at design-token value until PR-116 makes height dynamic.
            final double finalButtonHeight = CoreSpacing.space14;

            return Container(
              padding: const EdgeInsets.fromLTRB(horizontalPadding,
                  verticalPadding, horizontalPadding, verticalPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Semantics(
                    label: 'Keyboard drag handle',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (details) {
                        _updateContentHeight();
                      },
                      onVerticalDragUpdate: (details) {
                        _controller.value -= details.delta.dy / _contentHeight;
                      },
                      onVerticalDragEnd: (details) {
                        final velocity = details.primaryVelocity ?? 0;
                        if (velocity > 300) {
                          _collapse();
                        } else if (velocity < -300) {
                          _expand();
                        } else if (_controller.value < 0.5) {
                          _collapse();
                        } else {
                          _expand();
                        }
                      },
                      child: InkWell(
                        onTap: () {
                          if (_isCollapsed) {
                            _expand();
                          } else {
                            _collapse();
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _controller,
                          builder: (context, child) {
                            return Container(
                              width: double.infinity,
                              padding: EdgeInsets.only(
                                  top: CoreSpacing.space1,
                                  bottom: CoreSpacing.space1 *
                                      (1.0 - _controller.value)),
                              child: Center(
                                child: CustomPaint(
                                  size: const Size(_dragIndicatorWidth,
                                      _dragIndicatorHeight),
                                  painter: _CurvedDragHandlePainter(
                                    color: colors.lineDarkOutline,
                                    collapseProgress: 1.0 - _controller.value,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizeTransition(
                    sizeFactor: _controller,
                    alignment: AlignmentDirectional.topStart,
                    child: Container(
                      key: _contentKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onHorizontalDragUpdate: _handleGroupSwipeUpdate,
                            onHorizontalDragEnd: _handleGroupSwipeEnd,
                            onHorizontalDragCancel: _handleGroupSwipeCancel,
                            child: _FunctionKeyStrip(
                              group: group,
                              onKeyTapped: widget.onKeyTapped,
                              accentColor: accent,
                              onViewAll: () => _showFunctionsSheet(context),
                            ),
                          ),
                          SizedBox(height: functionStripSpacing),
                          _buildColumnLayout(
                            context,
                            buttonWidth: finalButtonWidth,
                            buttonHeight: finalButtonHeight,
                            buttonSpacing: finalSpacing,
                            heightSpacing: min(finalSpacing, maxHeightSpacing),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildColumnLayout(
    BuildContext context, {
    required double buttonWidth,
    required double buttonHeight,
    required double buttonSpacing,
    required double heightSpacing,
  }) {
    const imperialUnitsOrder = [UnitType.yards, UnitType.feet, UnitType.inch];
    const metricUnitsOrder = [
      UnitType.meter,
      UnitType.centimeter,
      UnitType.millimeter
    ];
    final activeUnits = widget.currentUnitSystem == UnitSystem.imperial
        ? imperialUnitsOrder
        : metricUnitsOrder;

    return Column(
      children: [
        _buildGridRow(
          children: [
            CoreControlButton(
              action: ControlAction.clearAll,
              onControlAction: widget.onControlAction,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreUnitButton(
              unit: UnitType.divideSymbol,
              onUnitSelected: widget.onUnitSelected,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreOperatorButton(
              operatorType: OperatorType.percent,
              onOperatorPressed: widget.onOperatorPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreOperatorButton(
              operatorType: OperatorType.divide,
              onOperatorPressed: widget.onOperatorPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreControlButton(
              action: ControlAction.delete,
              onControlAction: widget.onControlAction,
              width: buttonWidth,
              height: buttonHeight,
            ),
          ],
          spacing: buttonSpacing,
        ),
        SizedBox(height: heightSpacing),
        _buildGridRow(
          children: [
            CoreUnitButton(
              unit: activeUnits[0],
              onUnitSelected: widget.onUnitSelected,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.seven,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.eight,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.nine,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreOperatorButton(
              operatorType: OperatorType.multiply,
              onOperatorPressed: widget.onOperatorPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
          ],
          spacing: buttonSpacing,
        ),
        SizedBox(height: heightSpacing),
        _buildGridRow(
          children: [
            CoreUnitButton(
              unit: activeUnits[1],
              onUnitSelected: widget.onUnitSelected,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.four,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.five,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.six,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreOperatorButton(
              operatorType: OperatorType.subtract,
              onOperatorPressed: widget.onOperatorPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
          ],
          spacing: buttonSpacing,
        ),
        SizedBox(height: heightSpacing),
        _buildGridRow(
          children: [
            CoreUnitButton(
              unit: activeUnits[2],
              onUnitSelected: widget.onUnitSelected,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.one,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.two,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreDigitInput(
              digit: DigitType.three,
              onDigitPressed: widget.onDigitPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
            CoreOperatorButton(
              operatorType: OperatorType.add,
              onOperatorPressed: widget.onOperatorPressed,
              width: buttonWidth,
              height: buttonHeight,
            ),
          ],
          spacing: buttonSpacing,
        ),
        SizedBox(height: heightSpacing),
        _buildBottomRow(
          buttonWidth: buttonWidth,
          buttonHeight: buttonHeight,
          buttonSpacing: buttonSpacing,
        ),
      ],
    );
  }

  Widget _buildGridRow({
    required List<Widget> children,
    required double spacing,
  }) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) SizedBox(width: spacing),
        ],
      ],
    );
  }

  Widget _buildBottomRow({
    required double buttonWidth,
    required double buttonHeight,
    required double buttonSpacing,
  }) {
    return Row(
      children: [
        CoreControlButton(
          action: ControlAction.moreOptions,
          onControlAction: widget.onControlAction,
          width: buttonWidth,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        CoreDigitInput(
          digit: DigitType.zero,
          onDigitPressed: widget.onDigitPressed,
          width: buttonWidth,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        CoreDigitInput(
          digit: DigitType.decimal,
          onDigitPressed: widget.onDigitPressed,
          width: buttonWidth,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        CoreResultButton(
          resultType: widget.result,
          customLabel: widget.customResultLabel,
          onTap: widget.onResultTapped,
          width: buttonWidth + buttonWidth + buttonSpacing,
          height: buttonHeight,
        ),
      ],
    );
  }

  void _showFunctionsSheet(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors.pageBackground,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(CoreSpacing.space6)),
      ),
      builder: (context) {
        return _FunctionsSheetHost(
          onAttach: (sheet) => _openFunctionsSheet = sheet,
          onDetach: () => _openFunctionsSheet = null,
          builder: (context) => CoreFunctionKeyBottomSheet(
            groups: widget.allGroups,
            groupAccentColors: widget.groupAccentColors,
            selectedGroup: widget.currentGroup,
            onGroupSelected: (groupName) {
              widget.onGroupSelected(groupName);
              Navigator.of(context).pop();
            },
            onKeyTapped: (key) {
              widget.onKeyTapped(key);
              Navigator.of(context).pop();
            },
            onGroupsReordered: widget.onGroupsReordered,
            reorderSemanticsLabelBuilder: widget.reorderSemanticsLabelBuilder,
            currentUnitSystem: widget.currentUnitSystem,
            onUnitSystemChanged: (system) {
              widget.onUnitSystemChanged(system);
            },
          ),
        );
      },
    );
  }
}

class _FunctionsSheetHost extends StatefulWidget {
  const _FunctionsSheetHost({
    required this.onAttach,
    required this.onDetach,
    required this.builder,
  });

  final ValueChanged<_FunctionsSheetHostState> onAttach;
  final VoidCallback onDetach;
  final WidgetBuilder builder;

  @override
  State<_FunctionsSheetHost> createState() => _FunctionsSheetHostState();
}

class _FunctionsSheetHostState extends State<_FunctionsSheetHost> {
  @override
  void initState() {
    super.initState();
    widget.onAttach(this);
  }

  @override
  void dispose() {
    widget.onDetach();
    super.dispose();
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) => widget.builder(context);
}

class _FunctionKeyStrip extends StatelessWidget {
  final FunctionGroup group;
  final ValueChanged<KeyType> onKeyTapped;
  final Color accentColor;
  final VoidCallback onViewAll;

  const _FunctionKeyStrip({
    required this.group,
    required this.onKeyTapped,
    required this.accentColor,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (group.keys.isEmpty) {
      return const SizedBox.shrink();
    }
    final typography = AppTypographyExtension.of(context);
    final colors = AppColorsExtension.of(context);

    return LayoutBuilder(builder: (context, constraints) {
      const int columnCount = 4;
      const double horizontalPadding = CoreSpacing.space3;

      final availableWidth = constraints.maxWidth;
      final widthForContent = availableWidth - (horizontalPadding * 2);

      const double targetKeyHeight = 48.0;
      const double spacing = CoreSpacing.space1;

      final double columnWidth =
          (widthForContent - (spacing * (columnCount - 1))) / columnCount;
      final double finalAspectRatio = columnWidth / targetKeyHeight;

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: Text(
                        '${group.name.label} group',
                        style: typography.bodySmallMedium.copyWith(
                          color: colors.textHeadline,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: CoreSpacing.space2),
                    Container(
                      width: CoreSpacing.space2,
                      height: CoreSpacing.space2,
                      decoration: BoxDecoration(
                        color: accentColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              Semantics(
                label: 'View all function keys',
                button: true,
                hint: 'Opens a bottom sheet with all available function keys',
                child: TextButton(
                  onPressed: onViewAll,
                  style: TextButton.styleFrom(
                    minimumSize:
                        const Size(CoreSpacing.space10, CoreSpacing.space12),
                    padding: EdgeInsets.zero,
                    tapTargetSize: MaterialTapTargetSize.padded,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View all',
                        style: typography.bodySmallMedium
                            .copyWith(color: colors.buttonSurface),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: CoreSpacing.space1),
                      Icon(
                        Icons.chevron_right,
                        size: CoreSpacing.space4,
                        color: colors.buttonSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          GridView.count(
            padding: EdgeInsets.zero,
            crossAxisCount: 4,
            crossAxisSpacing: CoreSpacing.space1,
            mainAxisSpacing: CoreSpacing.space1,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: finalAspectRatio,
            children: group.keys.map((key) {
              return FunctionKeyTile(
                keyType: key,
                onTap: () {
                  onKeyTapped(key);
                  key.action?.call();
                },
                hasPadding: true,
              );
            }).toList(),
          ),
        ],
      );
    });
  }
}

/// Custom painter that draws a curved drag handle indicator.
class _CurvedDragHandlePainter extends CustomPainter {
  final Color color;
  final double collapseProgress;

  _CurvedDragHandlePainter({
    required this.color,
    this.collapseProgress = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final path = Path();

    final startY = size.height * 0.2 + (size.height * 0.6 * collapseProgress);
    final controlY = size.height - (size.height * collapseProgress);

    path.moveTo(0, startY);
    path.quadraticBezierTo(
      size.width / 2,
      controlY,
      size.width,
      startY,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedDragHandlePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.collapseProgress != collapseProgress;
  }
}
