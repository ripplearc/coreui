import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import 'function_key_tile.dart';

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
  });

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

  @override
  State<CoreKeyboard> createState() => _CoreKeyboardState();
}

class _CoreKeyboardState extends State<CoreKeyboard> {
  static const double _dragIndicatorHeight = 6.0;
  static const double _dragIndicatorWidth = 32.0;

  @override
  Widget build(BuildContext context) {
    final group = widget.allGroups.firstWhere(
      (g) => g.name == widget.currentGroup,
      orElse: () => widget.allGroups.isNotEmpty
          ? widget.allGroups.first
          : const FunctionGroup(
              name: GroupNameType(label: "Basic Geometry"), keys: []),
    );
    final colors = Theme.of(context).coreColors;
    final accent = widget.groupAccentColors[widget.currentGroup] ??
        colors.keyboardFunctions;

    return Container(
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(CoreSpacing.space8)),
        boxShadow: [
          BoxShadow(
            color: colors.shadowGrey6,
            offset: const Offset(0, -2),
            blurRadius: 12,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final headerSpacing = CoreSpacing.space3;
          final functionStripSpacing = CoreSpacing.space4;
          const double horizontalPadding = CoreSpacing.space3;
          const double verticalPadding = CoreSpacing.space3;
          final double maxHeightSpasing = 8.0;
          const int columnCount = 5;
          const double maxButtonSize = 80.0;
          const double minButtonSize = 48.0;
          const double minSpacing = CoreSpacing.space1;

          final availableWidth = constraints.maxWidth;
          final widthForContent = availableWidth - (horizontalPadding * 2);

          final double idealTotalWidth =
              (maxButtonSize * columnCount) + (minSpacing * (columnCount - 1));

          double finalButtonSize;
          double finalSpacing;

          if (widthForContent > idealTotalWidth) {
            finalButtonSize = maxButtonSize;
            finalSpacing = (widthForContent - (finalButtonSize * columnCount)) /
                (columnCount - 1);
          } else {
            finalSpacing = minSpacing;
            finalButtonSize =
                (widthForContent - (finalSpacing * (columnCount - 1))) /
                    columnCount;

            if (finalButtonSize < minButtonSize) {
              finalButtonSize = minButtonSize;
            }
          }

          return Container(
            padding: const EdgeInsets.fromLTRB(horizontalPadding,
                verticalPadding, horizontalPadding, verticalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: 'Keyboard drag handle',
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: CoreSpacing.space2,
                      bottom: CoreSpacing.space1,
                    ),
                    child: CustomPaint(
                      size:
                          const Size(_dragIndicatorWidth, _dragIndicatorHeight),
                      painter: _CurvedDragHandlePainter(
                        color: colors.iconGrayLight,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: headerSpacing),
                _FunctionKeyStrip(
                  group: group,
                  onKeyTapped: widget.onKeyTapped,
                  accentColor: accent,
                  onViewAll: () => _showFunctionsSheet(context),
                ),
                SizedBox(height: functionStripSpacing),
                _buildColumnLayout(
                  context,
                  buttonSize: finalButtonSize,
                  buttonSpacing: finalSpacing,
                  heightSpasing: min(finalSpacing, maxHeightSpasing),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildColumnLayout(
    BuildContext context, {
    required double buttonSize,
    required double buttonSpacing,
    required double heightSpasing,
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

    return SafeArea(
      child: Column(
        children: [
          _buildGridRow(
            children: [
              CoreControlButton(
                action: ControlAction.clearAll,
                onControlAction: widget.onControlAction,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreUnitButton(
                unit: UnitType.divideSymbol,
                onUnitSelected: widget.onUnitSelected,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.percent,
                onOperatorPressed: widget.onOperatorPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.divide,
                onOperatorPressed: widget.onOperatorPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreControlButton(
                action: ControlAction.delete,
                onControlAction: widget.onControlAction,
                width: buttonSize,
                height: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
          SizedBox(height: heightSpasing),
          _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[0],
                onUnitSelected: widget.onUnitSelected,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.seven,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.eight,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.nine,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.multiply,
                onOperatorPressed: widget.onOperatorPressed,
                width: buttonSize,
                height: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
          SizedBox(height: heightSpasing),
          _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[1],
                onUnitSelected: widget.onUnitSelected,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.four,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.five,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.six,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.subtract,
                onOperatorPressed: widget.onOperatorPressed,
                width: buttonSize,
                height: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
          SizedBox(height: heightSpasing),
          _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[2],
                onUnitSelected: widget.onUnitSelected,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.one,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.two,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.three,
                onDigitPressed: widget.onDigitPressed,
                width: buttonSize,
                height: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.add,
                onOperatorPressed: widget.onOperatorPressed,
                width: buttonSize,
                height: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
          SizedBox(height: heightSpasing),
          _buildBottomRow(
            buttonSize: buttonSize,
            buttonSpacing: buttonSpacing,
          ),
        ],
      ),
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
    required double buttonSize,
    required double buttonSpacing,
  }) {
    return Row(
      children: [
        CoreControlButton(
          action: ControlAction.moreOptions,
          onControlAction: widget.onControlAction,
          width: buttonSize,
          height: buttonSize,
        ),
        SizedBox(width: buttonSpacing),
        CoreDigitInput(
          digit: DigitType.zero,
          onDigitPressed: widget.onDigitPressed,
          width: buttonSize,
          height: buttonSize,
        ),
        SizedBox(width: buttonSpacing),
        CoreDigitInput(
          digit: DigitType.decimal,
          onDigitPressed: widget.onDigitPressed,
          width: buttonSize,
          height: buttonSize,
        ),
        SizedBox(width: buttonSpacing),
        CoreResultButton(
          resultType: widget.result,
          customLabel: widget.customResultLabel,
          onTap: widget.onResultTapped,
          width: buttonSize + buttonSize + buttonSpacing,
          height: buttonSize,
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
        return CoreFunctionKeyBottomSheet(
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
          currentUnitSystem: widget.currentUnitSystem,
          onUnitSystemChanged: (system) {
            widget.onUnitSystemChanged(system);
          },
        );
      },
    );
  }
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
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
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
          const SizedBox(height: CoreSpacing.space4),
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

  _CurvedDragHandlePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.2);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height * 0.2,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedDragHandlePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
