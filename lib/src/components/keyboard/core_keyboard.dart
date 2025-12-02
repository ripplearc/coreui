import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/shadows.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/typography.dart';
import '../../theme/typography_extension.dart';
import 'function_bottom_sheet.dart';
import 'keyboard_buttons.dart';
import 'keyboard_models.dart';

class CoreKeyboard extends StatelessWidget {
  CoreKeyboard({
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
    this.result = ResultType.equals,
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
    final group = allGroups
        .firstWhere(
          (g) => g.name == currentGroup,
          orElse: () => allGroups.isNotEmpty
              ? allGroups.first
              : const FunctionGroup(name: GroupNameType.basicGeometry, keys: []),
        );
    final accent = groupAccentColors[currentGroup] ?? CoreKeyboardColors.units;

    final colors = Theme.of(context).extension<AppColorsExtension>();
    
    // Get screen height and set keyboard to 60% of screen
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = screenHeight * 0.6;

    return Container(
      height: keyboardHeight,
      decoration: BoxDecoration(
        color: colors?.pageBackground!,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
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
          
          // Calculate padding
          const horizontalPadding = 12.0;
          const verticalPadding = 12.0;
          const dragHandleHeight = 4.0;
          const dragHandleSpacing = 16.0;
          
          // Calculate available space for content
          final contentHeight = availableHeight - (verticalPadding * 2) - dragHandleHeight - dragHandleSpacing;
          
          // Calculate adaptive spacing - use smaller values on small screens
          final isSmallScreen = availableHeight < 500;
          final headerSpacing = isSmallScreen ? 8.0 : 12.0;
          final functionStripSpacing = isSmallScreen ? 8.0 : 12.0;
          final keyboardSpacing = isSmallScreen ? 6.0 : 8.0;
          
          // Estimate header and function strip heights
          final headerHeight = 32.0;
          final functionStripHeight = 40.0;
          
          // Calculate available height for keyboard grid (5 rows)
          final keyboardAvailableHeight = contentHeight - 
              headerHeight - headerSpacing - 
              functionStripHeight - functionStripSpacing - 
              keyboardSpacing * 4; // 4 gaps between 5 rows
          
          // Calculate button height based on available space
          final buttonHeight = keyboardAvailableHeight / 5; // 5 rows
          
          return Padding(
            padding: const EdgeInsets.fromLTRB(horizontalPadding, verticalPadding, horizontalPadding, verticalPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 56,
                  height: dragHandleHeight,
                  decoration: BoxDecoration(
                    color: CoreBorderColors.lineMid,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: headerSpacing),
                _FunctionKeyStrip(
                  group: group,
                  onKeyTapped: onKeyTapped,
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
      const metricUnitsOrder = [UnitType.meter, UnitType.centimeter, UnitType.millimeter];
      final activeUnits = currentUnitSystem == UnitSystem.imperial ? imperialUnitsOrder : metricUnitsOrder;
    
    // Calculate button spacing
    final buttonSpacing = isSmallScreen 
        ? availableWidth * 0.012 
        : availableWidth * 0.015;
    
    // Calculate button sizes for 5-column grid
    // Total spacing: 4 gaps between 5 columns = 4 * buttonSpacing
    final totalSpacing = buttonSpacing * 4;
    final availableForButtons = availableWidth - totalSpacing;
    // Column 1 (units) is wider: ~22%, columns 2-5 are equal: ~19.5% each
    final column1Width = availableForButtons * 0.22;
    final column2to5Width = availableForButtons * 0.195;
    
    // For circular buttons, use the minimum of width-based size and height
    // This ensures buttons maintain circular shape while fitting in the layout
    final buttonSize = column2to5Width < buttonHeight 
        ? column2to5Width 
        : buttonHeight;
    
    // Recalculate column1Width to fit properly with the actual buttonSize
    // If buttonSize was constrained, we need to adjust column1Width
    final spaceForCircularButtons = (buttonSize * 4) + (buttonSpacing * 3);
    final adjustedColumn1Width = availableWidth - spaceForCircularButtons - buttonSpacing;
    // Use the larger of calculated width or minimum, but prefer the original proportion
    final finalColumn1Width = adjustedColumn1Width > column1Width * 0.8
        ? adjustedColumn1Width
        : column1Width;
        
    return Column(
      children: [
        // Row 1: C, /, %, ÷, backspace
        Expanded(
          child: _buildGridRow(
            children: [
              ControlButton(
                action: ControlAction.clearAll,
                onControlAction: onControlAction,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              DigitInput(
                digit: DigitType.divideSymbol,
                onDigitPressed: onDigitPressed,
                isEmphasized: true,
                radius: buttonSize,
              ),
              OperatorButton(
                operatorType: OperatorType.percent,
                onOperatorPressed: onOperatorPressed,
                radius: buttonSize,
              ),
              OperatorButton(
                operatorType: OperatorType.divide,
                onOperatorPressed: onOperatorPressed,
                radius: buttonSize,

              ),
              ControlButton(
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
              UnitButton(
                unit: activeUnits[0],
                onUnitSelected: onUnitSelected,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              DigitInput(
                digit: DigitType.seven,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              DigitInput(
                digit: DigitType.eight,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              DigitInput(
                digit: DigitType.nine,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              OperatorButton(
                operatorType: OperatorType.multiply,
                onOperatorPressed: onOperatorPressed,
                radius: buttonSize,
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
              UnitButton(
                unit: activeUnits[1],
                onUnitSelected: onUnitSelected,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              DigitInput(
                digit: DigitType.four,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              DigitInput(
                digit: DigitType.five,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              DigitInput(
                digit: DigitType.six,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              OperatorButton(
                operatorType: OperatorType.subtract,
                onOperatorPressed: onOperatorPressed,
                radius: buttonSize,
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
              UnitButton(
                unit: activeUnits[2],
                onUnitSelected: onUnitSelected,
                width: finalColumn1Width,
                height: buttonHeight,
              ),
              DigitInput(
                digit: DigitType.one,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              DigitInput(
                digit: DigitType.two,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              DigitInput(
                digit: DigitType.three,
                onDigitPressed: onDigitPressed,
                radius: buttonSize,
              ),
              OperatorButton(
                operatorType: OperatorType.add,
                onOperatorPressed: onOperatorPressed,
                radius: buttonSize,
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
    required double buttonSize,
    required double buttonHeight,
  }) {
    // Result button spans 2 columns (columns 4-5)
    final resultButtonWidth = (buttonSize * 2) + buttonSpacing;
    
    return Row(
      children: [
        // Column 1: moreOptions
        ControlButton(
          action: ControlAction.moreOptions,
          onControlAction: onControlAction,
          width: column1Width,
          height: buttonHeight,
        ),
        SizedBox(width: buttonSpacing),
        // Column 2: 0
        DigitInput(
          digit: DigitType.zero,
          onDigitPressed: onDigitPressed,
          radius: buttonSize,
        ),
        SizedBox(width: buttonSpacing),
        // Column 3: .
        DigitInput(
          digit: DigitType.decimal,
          onDigitPressed: onDigitPressed,
          radius: buttonSize,
        ),
        SizedBox(width: buttonSpacing),
        // Columns 4-5: Result button (spans 2 columns)
        ResultButton(
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
    final colors = Theme.of(context).extension<AppColorsExtension>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: colors?.pageBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return FunctionBottomSheet(
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
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    
    // Split keys into rows of 4 (2 rows × 4 columns grid)
    final rows = <List<KeyType>>[];
    for (var i = 0; i < group.keys.length && i < 8; i += 4) {
      rows.add(group.keys.sublist(
        i,
        i + 4 > group.keys.length ? group.keys.length : i + 4,
      ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header: Group name with dot + "View all" link
        Row(
          children: [
            Text(
              '${group.name.label} group',
              style: typography?.bodySmallMedium.copyWith(
                color: colors?.textHeadline ?? CoreTextColors.headline,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const Spacer(),
            TextButton(
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
                    style: typography?.bodySmallMedium.copyWith(
                      color: colors?.buttonSurface
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: colors?.buttonSurface,
                  ),
                ],
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
          childAspectRatio: 2.4,
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
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: CoreSpacing.space1,
          vertical: CoreSpacing.space1,
        ),  
        
        decoration: BoxDecoration(
          color: colors?.backgroundGrayMid,
          borderRadius: BorderRadius.circular(CoreSpacing.space2),
        ),
        child: Center(child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (keyType.icon != null) ...[
              Icon(
                keyType.icon,
                color: colors?.textHeadline,
                size: 16,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              keyType.label,
              style: typography?.bodyMediumRegular.copyWith(
                color: colors?.textHeadline,
              ),
            ),
          ],
        ),)
       ,
      ),
    );
  }
}




