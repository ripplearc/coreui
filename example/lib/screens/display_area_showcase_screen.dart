import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../blocs/display_area_bloc.dart';

/// A showcase screen demonstrating [CoreDisplayArea] with multi-stage
/// swipe-to-expand interaction alongside [CoreKeyboard].
///
/// As the display area expands through its stages the keyboard slides
/// progressively downward, disappearing entirely in the full-screen stage.
class DisplayAreaShowcaseScreen extends StatefulWidget {
  const DisplayAreaShowcaseScreen({super.key});

  @override
  State<DisplayAreaShowcaseScreen> createState() =>
      _DisplayAreaShowcaseScreenState();
}

class _DisplayAreaShowcaseScreenState extends State<DisplayAreaShowcaseScreen> {
  DisplayAreaStage _currentStage = DisplayAreaStage.collapsed;

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
    final Map<GroupNameType, Color> groupAccentColors = {
      _basicGeometryGroup: colors.keyboardFunctions,
      _materialsGroup: colors.keyboardUnits,
      _trigonometryGroup: colors.textSuccess,
    };

    return BlocProvider(
      create: (context) => DisplayAreaBloc(),
      child: Scaffold(
        backgroundColor: colors.backgroundBlueLight,
        body: SafeArea(
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.pageBackground),
            child: BlocBuilder<DisplayAreaBloc, DisplayAreaState>(
              builder: (context, state) {
                final bloc = context.read<DisplayAreaBloc>();

                final chips = [
                  ...state.completedChips,
                  if (state.isTyping)
                    if (state.activeInputLabel case final label?)
                      CoreCalculatorChip(
                        label: label,
                        value: state.currentInputValue,
                        type: CoreCalculatorChipType.active,
                      ),
                  if (state.resultChip case final resultChip?) resultChip,
                ];

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        physics: _currentStage != DisplayAreaStage.collapsed
                            ? const NeverScrollableScrollPhysics()
                            : const AlwaysScrollableScrollPhysics(),
                        child: CoreDisplayArea(
                          label:
                              state.resultLabel ?? state.activeInputLabel ?? '',
                          value: state.resultValue ?? state.currentInputValue,
                          hasError: false,
                          isTyping: state.isTyping,
                          onClose: () => bloc.add(const ResetRequested()),
                          onStageChanged: (stage) {
                            if (_currentStage != stage) {
                              setState(() => _currentStage = stage);
                            }
                          },
                          chipsList: chips,
                          previousSessions: [
                            CoreHistorySessionData(
                              dateLabel: 'May 24, 2026',
                              value: '12.0',
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
                            CoreHistorySessionData(
                              dateLabel: 'Yesterday',
                              value: '10.5',
                              chipsList: [
                                const CoreCalculatorChip(
                                  type: CoreCalculatorChipType.disabled,
                                  label: 'Rise',
                                  value: '8.4 ft',
                                ),
                                const CoreCalculatorChip(
                                  type: CoreCalculatorChipType.disabled,
                                  label: 'Run',
                                  value: '0.8 ft',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 1.0,
                        end: switch (_currentStage) {
                          DisplayAreaStage.collapsed => 1.0,
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
                      child: CoreKeyboard(
                        currentGroup: _basicGeometryGroup,
                        allGroups: _groups,
                        onDigitPressed: (digit) =>
                            bloc.add(DigitPressed(digit.label)),
                        onUnitSelected: (unit) =>
                            bloc.add(UnitSelected(unit.label)),
                        onOperatorPressed: (op) =>
                            bloc.add(OperatorPressed(op.symbol)),
                        onControlAction: (_) {},
                        onResultTapped: () =>
                            bloc.add(const OperatorPressed('=')),
                        onGroupSelected: (_) {},
                        currentUnitSystem: UnitSystem.imperial,
                        onKeyTapped: (key) => bloc.add(KeySelected(key.label)),
                        onUnitSystemChanged: (_) {},
                        groupAccentColors: groupAccentColors,
                        result: const ResultType(label: '='),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
