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
class CoreKeyboard extends StatelessWidget {
  // Layout constants
  /// Keyboard height as percentage of screen height
  static const double _keyboardHeightRatio = 0.6;

  /// Minimum height to be considered a small screen (in logical pixels)
  static const double _smallScreenThreshold = 500.0;

  /// Estimated header height in logical pixels
  static const double _estimatedHeaderHeight = CoreSpacing.space8;

  /// Estimated function strip height in logical pixels
  static const double _estimatedFunctionStripHeight = CoreSpacing.space10;

  /// Button spacing as percentage of available width for small screens
  static const double _smallScreenButtonSpacingRatio = 0.012;

  /// Button spacing as percentage of available width for normal screens
  static const double _normalScreenButtonSpacingRatio = 0.015;

  /// Column width ratios for 5-column grid
  static const double _column1WidthRatio = 0.22;
  static const double _column2to5WidthRatio = 0.195;

  /// Minimum column width ratio threshold
  static const double _minColumnWidthRatio = 0.8;

  /// Number of keyboard rows
  static const int _keyboardRowCount = 5;

  /// Number of gaps between rows
  static const int _keyboardRowGaps = 4;

  /// Drag handle width
  static final double _dragHandleWidth = CoreSpacing.space12; // 48px

  /// Aspect ratio for function key tiles in grid
  static const double _functionKeyTileAspectRatio = 2.4;
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
  Widget build(BuildContext context) {
    final group = allGroups.firstWhere(
      (g) => g.name == currentGroup,
      orElse: () => allGroups.isNotEmpty
          ? allGroups.first
          : const FunctionGroup(
              name: GroupNameType(label: "Basic Geometry"), keys: []),
    );
    final colors = AppColorsExtension.of(context);
    final accent =
        groupAccentColors[currentGroup] ?? colors.backgroundBlueLight;
    // Get screen height and set keyboard to configured percentage of screen
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

          // Calculate padding using design tokens
          const horizontalPadding = CoreSpacing.space3;
          const verticalPadding = CoreSpacing.space3;
          const dragHandleHeight = CoreSpacing.space1;
          const dragHandleSpacing = CoreSpacing.space4;

          // Calculate available space for content
          final contentHeight = availableHeight -
              (verticalPadding * 2) -
              dragHandleHeight -
              dragHandleSpacing;

          // Calculate adaptive spacing - use smaller values on small screens
          final isSmallScreen = availableHeight < _smallScreenThreshold;
          final headerSpacing =
              isSmallScreen ? CoreSpacing.space2 : CoreSpacing.space3;
          final functionStripSpacing =
              isSmallScreen ? CoreSpacing.space2 : CoreSpacing.space3;
          final keyboardSpacing = CoreSpacing.space2;

          // Estimate header and function strip heights
          final headerHeight = _estimatedHeaderHeight;
          final functionStripHeight = _estimatedFunctionStripHeight;

          // Calculate available height for keyboard grid
          final keyboardAvailableHeight = contentHeight -
              headerHeight -
              headerSpacing -
              functionStripHeight -
              functionStripSpacing -
              keyboardSpacing * _keyboardRowGaps;

          // Calculate button height based on available space with safety check
          final buttonHeight = keyboardAvailableHeight > 0
              ? keyboardAvailableHeight / _keyboardRowCount
              : CoreSpacing.space12; // Fallback to minimum button height

          return Padding(
            padding: const EdgeInsets.fromLTRB(horizontalPadding,
                verticalPadding, horizontalPadding, verticalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Semantics(
                  label: 'Keyboard drag handle',
                  child: Container(
                    width: _dragHandleWidth,
                    height: dragHandleHeight,
                    decoration: BoxDecoration(
                      color: CoreBorderColors.lineMid,
                      borderRadius: BorderRadius.circular(CoreSpacing.space1),
                    ),
                  ),
                ),
                SizedBox(height: headerSpacing),
                _FunctionKeyStrip(
                  group: group,
                  onKeyTapped: onKeyTapped,
                  accentColor: accent!,
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

  /// Builds the column layout for the keyboard grid.
  ///
  /// Calculates button sizes and spacing based on available width and screen size.
  /// Handles a 5-column grid where column 1 (units) is wider than columns 2-5.
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
    final activeUnits = currentUnitSystem == UnitSystem.imperial
        ? imperialUnitsOrder
        : metricUnitsOrder;

    // Calculate button spacing based on screen size
    final buttonSpacing = isSmallScreen
        ? availableWidth * _smallScreenButtonSpacingRatio
        : availableWidth * _normalScreenButtonSpacingRatio;

    // Calculate button sizes for 5-column grid
    // Total spacing: 4 gaps between 5 columns = 4 * buttonSpacing
    final totalSpacing = buttonSpacing * 4;
    final availableForButtons = availableWidth - totalSpacing;
    // Column 1 (units) is wider: ~22%, columns 2-5 are equal: ~19.5% each
    final column1Width = availableForButtons * _column1WidthRatio;
    final column2to5Width = availableForButtons * _column2to5WidthRatio;

    // For circular buttons, use the minimum of width-based size and height
    // This ensures buttons maintain circular shape while fitting in the layout
    final buttonSize =
        column2to5Width < buttonHeight ? column2to5Width : buttonHeight;

    // Recalculate column1Width to fit properly with the actual buttonSize
    // If buttonSize was constrained, we need to adjust column1Width
    final spaceForCircularButtons = (buttonSize * 4) + (buttonSpacing * 3);
    final adjustedColumn1Width =
        availableWidth - spaceForCircularButtons - buttonSpacing;
    // Use the larger of calculated width or minimum, but prefer the original proportion
    final finalColumn1Width =
        adjustedColumn1Width > column1Width * _minColumnWidthRatio
            ? adjustedColumn1Width
            : column1Width;

    return Column(
      children: [
        // Row 1: C, /, %, ÷, backspace
        Expanded(
          child: _buildGridRow(
            children: [
              CoreControlButton(
                action: ControlAction.clearAll,
                onControlAction: onControlAction,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              CoreUnitButton(
                  unit: UnitType.divideSymbol,
                  onUnitSelected: onUnitSelected,
                  height: buttonSize,
                  width: buttonSize),
              CoreOperatorButton(
                operatorType: OperatorType.percent,
                onOperatorPressed: onOperatorPressed,
                size: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.divide,
                onOperatorPressed: onOperatorPressed,
                size: buttonSize,
              ),
              CoreControlButton(
                action: ControlAction.delete,
                onControlAction: onControlAction,
                width: buttonSize,
                height: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        // Row 2: Yards, 7, 8, 9, ×
        Expanded(
          child: _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[0],
                onUnitSelected: onUnitSelected,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.seven,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.eight,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.nine,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.multiply,
                onOperatorPressed: onOperatorPressed,
                size: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        // Row 3: Feet, 4, 5, 6, -
        Expanded(
          child: _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[1],
                onUnitSelected: onUnitSelected,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.four,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.five,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.six,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.subtract,
                onOperatorPressed: onOperatorPressed,
                size: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        // Row 4: Inch, 1, 2, 3, +
        Expanded(
          child: _buildGridRow(
            children: [
              CoreUnitButton(
                unit: activeUnits[2],
                onUnitSelected: onUnitSelected,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              CoreDigitInput(
                digit: DigitType.one,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.two,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreDigitInput(
                digit: DigitType.three,
                onDigitPressed: onDigitPressed,
                size: buttonSize,
              ),
              CoreOperatorButton(
                operatorType: OperatorType.add,
                onOperatorPressed: onOperatorPressed,
                size: buttonSize,
              ),
            ],
            spacing: buttonSpacing,
          ),
        ),
        SizedBox(height: buttonSpacing),
        // Row 5: ..., 0, ., Area (Area spans 2 columns)
        Expanded(
          child: _buildBottomRow(
            buttonSpacing: buttonSpacing,
            column1Width: finalColumn1Width,
            buttonSize: buttonSize,
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

  /// Builds the bottom row of the keyboard with result button spanning 2 columns.
  ///
  /// The result button takes up columns 4-5, while columns 1-3 contain
  /// more options, zero, and decimal buttons respectively.
  Widget _buildBottomRow({
    required double buttonSpacing,
    required double column1Width,
    required double buttonSize,
    required double buttonHeight,
  }) {
    // Result button spans 2 columns (columns 4-5)
    final resultButtonWidth = (buttonSize * 2) + buttonSpacing;

    return Row(
      children: [
        // Column 1: moreOptions
        CoreControlButton(
          action: ControlAction.moreOptions,
          onControlAction: onControlAction,
          width: column1Width,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        // Column 2: 0
        CoreDigitInput(
          digit: DigitType.zero,
          onDigitPressed: onDigitPressed,
          size: buttonSize,
        ),
        SizedBox(width: buttonSpacing),
        // Column 3: .
        CoreDigitInput(
          digit: DigitType.decimal,
          onDigitPressed: onDigitPressed,
          size: buttonSize,
        ),
        SizedBox(width: buttonSpacing),
        // Columns 4-5: Result button (spans 2 columns)
        CoreResultButton(
          resultType: result,
          customLabel: customResultLabel,
          onTap: onResultTapped,
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
        return CoreFunctionBottomSheet(
          groups: allGroups,
          groupAccentColors: groupAccentColors,
          selectedGroup: currentGroup,
          onGroupSelected: (groupName) {
            onGroupSelected(groupName);
            Navigator.of(context).pop();
          },
          onKeyTapped: (key) {
            onKeyTapped(key);
            Navigator.of(context).pop();
          },
          currentUnitSystem: currentUnitSystem,
          onUnitSystemChanged: (system) {
            onUnitSystemChanged(system);
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
        // Header: Group name with dot + "View all" link
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
          childAspectRatio: CoreKeyboard._functionKeyTileAspectRatio,
          children: group.keys.map((key) {
            return _FunctionKeyTile(
              keyType: key,
              onTap: () {
                onKeyTapped(key);
                key.action?.call();
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FunctionKeyTile extends StatelessWidget {
  final KeyType keyType;
  final VoidCallback onTap;

  const _FunctionKeyTile({
    required this.keyType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = TypographyExtension.of(context);
    return Semantics(
      label: '${keyType.label} function key',
      button: true,
      hint: keyType.action != null ? 'Tap to execute ${keyType.label}' : null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space1,
            vertical: CoreSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: colors.backgroundGrayMid,
            borderRadius: BorderRadius.circular(CoreSpacing.space2),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (keyType.icon != null) ...[
                  Icon(
                    keyType.icon,
                    color: colors.textHeadline,
                    size: CoreSpacing.space4,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                ],
                Text(
                  keyType.label,
                  style: typography.bodyMediumRegular.copyWith(
                    color: colors.textHeadline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
