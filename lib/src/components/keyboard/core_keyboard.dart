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
  // Layout constants
  static const double _keyboardHeightRatio = 0.6;

  static const double _smallScreenThreshold = 500.0;

  static const double _estimatedHeaderHeight = CoreSpacing.space8;

  static const double _estimatedFunctionStripHeight = CoreSpacing.space10;

  static const double _smallScreenButtonSpacingRatio = 0.012;

  static const double _normalScreenButtonSpacingRatio = 0.015;

  static const double _column1WidthRatio = 0.22;
  static const double _column2to5WidthRatio = 0.195;

  static const int _keyboardRowCount = 5;

  static const int _keyboardRowGaps = 4;

  static const double _functionKeyTileAspectRatio = 2.4;

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
    final colors = AppColorsExtension.of(context);
    final accent = widget.groupAccentColors[widget.currentGroup] ??
        CoreKeyboardColors.functions;
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = screenHeight * _keyboardHeightRatio;

    return Container(
      height: keyboardHeight,
      decoration: BoxDecoration(
        color: colors.pageBackground,
        borderRadius: const BorderRadius.vertical(
            top: Radius.circular(CoreSpacing.space8)),
        boxShadow: [
          BoxShadow(
            color: CoreShadowColors.shadowGrey6,
            offset: const Offset(0, -2),
            blurRadius: 12,
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableHeight = constraints.maxHeight;
          final availableWidth = constraints.maxWidth;

          const horizontalPadding = CoreSpacing.space3;
          const verticalPadding = CoreSpacing.space3;
          const dragHandleHeight = CoreSpacing.space1;
          const dragHandleSpacing = CoreSpacing.space4;

          final contentHeight = availableHeight -
              (verticalPadding * 2) -
              dragHandleHeight -
              dragHandleSpacing;

          final isSmallScreen = availableHeight < _smallScreenThreshold;
          final headerSpacing =
              isSmallScreen ? CoreSpacing.space2 : CoreSpacing.space3;
          final functionStripSpacing =
              isSmallScreen ? CoreSpacing.space2 : CoreSpacing.space3;
          final keyboardSpacing = CoreSpacing.space2;

          final headerHeight = _estimatedHeaderHeight;
          final functionStripHeight = _estimatedFunctionStripHeight;

          final keyboardAvailableHeight = contentHeight -
              headerHeight -
              headerSpacing -
              functionStripHeight -
              functionStripSpacing -
              keyboardSpacing * _keyboardRowGaps;

          final buttonHeight = keyboardAvailableHeight > 0
              ? keyboardAvailableHeight / _keyboardRowCount
              : CoreSpacing.space12;

          return Padding(
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
                SizedBox(height: keyboardSpacing),
                Expanded(
                  child: _buildColumnLayout(
                    context,
                    buttonHeight: buttonHeight,
                    availableWidth: availableWidth - (horizontalPadding * 2),
                    isSmallScreen: isSmallScreen,
                  ),
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
    required double buttonHeight,
    required double availableWidth,
    required bool isSmallScreen,
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

    final buttonSpacing = isSmallScreen
        ? availableWidth * _smallScreenButtonSpacingRatio
        : availableWidth * _normalScreenButtonSpacingRatio;

    final totalSpacing = buttonSpacing * 4;
    final availableForButtons = availableWidth - totalSpacing;
    final column1Width = availableForButtons * _column1WidthRatio;
    final column2to5Width = availableForButtons * _column2to5WidthRatio;

    return Column(
      children: [
        Expanded(
          child: _buildGridRow(
            children: [
              CoreControlButton(
                action: ControlAction.clearAll,
                onControlAction: widget.onControlAction,
                width: column1Width,
                height: buttonHeight,
              ),
              CoreUnitButton(
                unit: UnitType.divideSymbol,
                onUnitSelected: widget.onUnitSelected,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.percent,
                onOperatorPressed: widget.onOperatorPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.divide,
                onOperatorPressed: widget.onOperatorPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreControlButton(
                action: ControlAction.delete,
                onControlAction: widget.onControlAction,
                width: column2to5Width,
                height: buttonHeight,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        Expanded(
          child: _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[0],
                onUnitSelected: widget.onUnitSelected,
                width: column1Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.seven,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.eight,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.nine,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.multiply,
                onOperatorPressed: widget.onOperatorPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        Expanded(
          child: _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[1],
                onUnitSelected: widget.onUnitSelected,
                width: column1Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.four,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.five,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.six,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.subtract,
                onOperatorPressed: widget.onOperatorPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        Expanded(
          child: _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[2],
                onUnitSelected: widget.onUnitSelected,
                width: column1Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.one,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.two,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.three,
                onDigitPressed: widget.onDigitPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.add,
                onOperatorPressed: widget.onOperatorPressed,
                width: column2to5Width,
                height: buttonHeight,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        Expanded(
          child: _buildBottomRow(
            buttonSpacing: buttonSpacing,
            column1Width: column1Width,
            column2to5Width: column2to5Width,
            buttonHeight: buttonHeight,
          ),
        ),
      ],
    );
  }

  /// Builds a horizontal row of widgets with consistent spacing.
  ///
  /// [children] are the widgets to display in the row.
  /// [spacing] is the spacing between each widget.
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
    required double buttonSpacing,
    required double column1Width,
    required double column2to5Width,
    required double buttonHeight,
  }) {
    final resultButtonWidth = (column2to5Width * 2) + buttonSpacing;

    return Row(
      children: [
        CoreControlButton(
          action: ControlAction.moreOptions,
          onControlAction: widget.onControlAction,
          width: column1Width,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        CoreDigitInput(
          digit: DigitType.zero,
          onDigitPressed: widget.onDigitPressed,
          width: column2to5Width,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        CoreDigitInput(
          digit: DigitType.decimal,
          onDigitPressed: widget.onDigitPressed,
          width: column2to5Width,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        CoreResultButton(
          resultType: widget.result,
          customLabel: widget.customResultLabel,
          onTap: widget.onResultTapped,
          width: resultButtonWidth,
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
    final typography = TypographyExtension.of(context);
    final colors = AppColorsExtension.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${group.name.label} group',
              style: typography.bodySmallMedium.copyWith(
                color: colors.textHeadline,
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
            const Spacer(),
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
        const SizedBox(height: CoreSpacing.space3),
        GridView.count(
          crossAxisCount: 4,
          crossAxisSpacing: CoreSpacing.space1,
          mainAxisSpacing: CoreSpacing.space1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: _CoreKeyboardState._functionKeyTileAspectRatio,
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
