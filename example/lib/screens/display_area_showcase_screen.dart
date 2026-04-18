import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A showcase screen demonstrating [CoreKeyboard] with multiple function
/// groups, accent colour theming, and imperial/metric unit configurations.
class DisplayAreaShowcaseScreen extends StatelessWidget {
  const DisplayAreaShowcaseScreen({super.key});

  static const GroupNameType _basicGeometryGroup =
      GroupNameType(label: 'Basic Geometry');
  static const GroupNameType _materialsGroup =
      GroupNameType(label: 'Materials');
  static const GroupNameType _trigonometryGroup =
      GroupNameType(label: 'Trigonometry');

  static final List<FunctionGroup> _groups = [
    FunctionGroup(
      name: _basicGeometryGroup,
      keys: [
        KeyType(groupName: 'Basic Geometry', label: 'Width'),
        KeyType(groupName: 'Basic Geometry', label: 'Length'),
        KeyType(groupName: 'Basic Geometry', label: 'Height'),
        KeyType(groupName: 'Basic Geometry', label: 'Pitch'),
        KeyType(groupName: 'Basic Geometry', label: 'Circle'),
        KeyType(groupName: 'Basic Geometry', label: 'Rise'),
        KeyType(groupName: 'Basic Geometry', label: 'Run'),
        KeyType(groupName: 'Basic Geometry', label: 'Radius'),
      ],
    ),
    FunctionGroup(
      name: _materialsGroup,
      keys: [
        KeyType(groupName: 'Materials', label: 'Lbs'),
        KeyType(groupName: 'Materials', label: 'Kg'),
        KeyType(groupName: 'Materials', label: 'Tons'),
        KeyType(groupName: 'Materials', label: 'Drywall'),
      ],
    ),
    FunctionGroup(
      name: _trigonometryGroup,
      keys: [
        KeyType(groupName: 'Trigonometry', label: 'SIN'),
        KeyType(groupName: 'Trigonometry', label: 'COS'),
        KeyType(groupName: 'Trigonometry', label: 'TAN'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    // Intentionally recreated on each build since it depends on theme.
    // Map identity is not relied upon by CoreKeyboard.
    final Map<GroupNameType, Color> groupAccentColors = {
      _basicGeometryGroup: colors.keyboardFunctions,
      _materialsGroup: colors.keyboardUnits,
      _trigonometryGroup: colors.textSuccess,
    };

    return Scaffold(
      backgroundColor: colors.backgroundBlueLight,
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.pageBackground),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CoreDisplayArea(
                label: 'Length',
                value: '16ft 14in',
                hasError: true,
                isTyping: true,
                dependentKeyLabel: 'O.C',
                dependentKeyValue: '16in',
                onPressedDependentKey: () {},
                chipsList: const [
                  CoreCalculatorChip(
                    label: "Length",
                    value: "16ft 14in",
                    type: CoreCalculatorChipType.editable,
                  ),
                  CoreCalculatorChip(
                    label: "Length",
                    value: "16ft 14in",
                    type: CoreCalculatorChipType.active,
                  ),
                  CoreCalculatorChip(
                    label: "Length",
                    value: "16ft 14in",
                    type: CoreCalculatorChipType.disabled,
                  ),
                  CoreCalculatorChip(
                    label: "Width",
                    value: "10ft",
                    type: CoreCalculatorChipType.editable,
                  ),
                  CoreCalculatorChip(
                    label: "Height",
                    value: "8ft",
                    type: CoreCalculatorChipType.active,
                  ),
                  CoreCalculatorChip(
                    label: "Weight",
                    value: "20lbs",
                    type: CoreCalculatorChipType.disabled,
                  ),
                  CoreCalculatorChip(
                    label: "Volume",
                    value: "100gal",
                    type: CoreCalculatorChipType.editable,
                  ),
                  CoreCalculatorChip(
                    label: "Width",
                    value: "10ft",
                    type: CoreCalculatorChipType.editable,
                  ),
                  CoreCalculatorChip(
                    label: "Width",
                    value: "10ft",
                    type: CoreCalculatorChipType.editable,
                  ),
                ],
              ),
              Spacer(),
              CoreKeyboard(
                currentGroup: _basicGeometryGroup,
                allGroups: _groups,
                onDigitPressed: (_) {},
                onUnitSelected: (_) {},
                onOperatorPressed: (_) {},
                onControlAction: (_) {},
                onResultTapped: () {},
                onGroupSelected: (_) {},
                currentUnitSystem: UnitSystem.imperial,
                onKeyTapped: (_) {},
                onUnitSystemChanged: (_) {},
                groupAccentColors: groupAccentColors,
                result: ResultType(label: '='),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
