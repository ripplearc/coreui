import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A showcase screen demonstrating [CoreSuggestionArea]
class SuggestionAreaShowcaseScreen extends StatefulWidget {
  const SuggestionAreaShowcaseScreen({super.key});

  @override
  State<SuggestionAreaShowcaseScreen> createState() =>
      _SuggestionAreaShowcaseScreenState();
}

class _SuggestionAreaShowcaseScreenState
    extends State<SuggestionAreaShowcaseScreen> {
  final DisplayAreaStage _currentStage = DisplayAreaStage.collapsed;

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
        KeyType(groupName: 'Materials', label: 'Fence'),
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
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: _currentStage != DisplayAreaStage.collapsed
                          ? const NeverScrollableScrollPhysics()
                          : const AlwaysScrollableScrollPhysics(),
                      child: CoreDisplayArea(
                        label: 'Length',
                        value: '10ft',
                        hasError: false,
                        isTyping: false,
                        onClose: () {},
                        onStageChanged: (stage) {},
                        chipsList: [
                          const CoreCalculatorChip(
                            type: CoreCalculatorChipType.disabled,
                            label: 'Length',
                            value: '10 ft',
                          ),
                          const CoreCalculatorChip(
                            type: CoreCalculatorChipType.disabled,
                            label: 'Width',
                            value: '12 ft',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const CoreSuggestionArea(
                    isEmpty: false,
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.95,
                      end: switch (_currentStage) {
                        DisplayAreaStage.collapsed => 0.95,
                        DisplayAreaStage.expandedCurrent => 0.95,
                        DisplayAreaStage.expandedPrevious => 0.75,
                        DisplayAreaStage.fullScreen => 0.0,
                      },
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, factor, child) {
                      return ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: factor,
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(top: CoreSpacing.space1),
                      child: CoreKeyboard(
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
                        result: const ResultType(label: '='),
                      ),
                    ),
                  ),
                ],
              )),
        ));
  }
}
