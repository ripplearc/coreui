import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../blocs/suggestion_area_showcase_bloc.dart';

/// A showcase screen demonstrating [CoreSuggestionArea]
class SuggestionAreaShowcaseScreen extends StatelessWidget {
  const SuggestionAreaShowcaseScreen({super.key});

  static const GroupNameType _basicGeometryGroup =
  GroupNameType(id: 'Basic Geometry', label: 'Basic Geometry');
  static const GroupNameType _materialsGroup =
  GroupNameType(id: 'Materials', label: 'Materials');
  static const GroupNameType _trigonometryGroup =
  GroupNameType(id: 'Trigonometry', label: 'Trigonometry');

  static final List<FunctionGroup> _groups = [
    FunctionGroup(
      name: _basicGeometryGroup,
      keys: [
        KeyType(groupName: 'Basic Geometry', id: 'Width', label: 'Width'),
        KeyType(groupName: 'Basic Geometry', id: 'Length', label: 'Length'),
        KeyType(groupName: 'Basic Geometry', id: 'Height', label: 'Height'),
        KeyType(groupName: 'Basic Geometry', id: 'Pitch', label: 'Pitch'),
        KeyType(groupName: 'Basic Geometry', id: 'Circle', label: 'Circle'),
        KeyType(groupName: 'Basic Geometry', id: 'Rise', label: 'Rise'),
        KeyType(groupName: 'Basic Geometry', id: 'Run', label: 'Run'),
        KeyType(groupName: 'Basic Geometry', id: 'Radius', label: 'Radius'),
      ],
    ),
    FunctionGroup(
      name: _materialsGroup,
      keys: [
        KeyType(groupName: 'Materials', id: 'Lbs', label: 'Lbs'),
        KeyType(groupName: 'Materials', id: 'Kg', label: 'Kg'),
        KeyType(groupName: 'Materials', id: 'Tons', label: 'Tons'),
        KeyType(groupName: 'Materials', id: 'Drywall', label: 'Drywall'),
        KeyType(groupName: 'Materials', id: 'Fence', label: 'Fence'),
      ],
    ),
    FunctionGroup(
      name: _trigonometryGroup,
      keys: [
        KeyType(groupName: 'Trigonometry', id: 'SIN', label: 'SIN'),
        KeyType(groupName: 'Trigonometry', id: 'COS', label: 'COS'),
        KeyType(groupName: 'Trigonometry', id: 'TAN', label: 'TAN'),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SuggestionAreaShowcaseBloc(),
      child: const _SuggestionAreaShowcaseView(),
    );
  }
}

class _SuggestionAreaShowcaseView extends StatelessWidget {
  const _SuggestionAreaShowcaseView();

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final Map<GroupNameType, Color> groupAccentColors = {
      SuggestionAreaShowcaseScreen._basicGeometryGroup:
      colors.keyboardFunctions,
      SuggestionAreaShowcaseScreen._materialsGroup: colors.keyboardUnits,
      SuggestionAreaShowcaseScreen._trigonometryGroup: colors.textSuccess,
    };

    return Scaffold(
      backgroundColor: colors.backgroundBlueLight,
      body: SafeArea(
        child: DecoratedBox(
          decoration: BoxDecoration(color: colors.pageBackground),
          child: BlocBuilder<SuggestionAreaShowcaseBloc,
              SuggestionAreaShowcaseState>(
            builder: (context, state) {
              final bloc = context.read<SuggestionAreaShowcaseBloc>();

              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    CoreDisplayArea(
                      closeSemanticLabel: 'Close',
                      historyPlaceholder: 'Here will show what you type',
                      label: state.resultLabel ?? state.activeInputLabel,
                      value: state.resultValue ?? state.currentInputValue,
                      hasError: false,
                      isTyping: state.isTyping,
                      onClose: () => bloc.add(const ResetRequested()),
                      onStageChanged: (stage) {},
                      chipsList: [
                        ...state.completedChips,
                        if (state.isTyping)
                          if (state.activeInputLabel case final label?)
                            CoreCalculatorChip(
                              label: label,
                              value: state.currentInputValue,
                              type: CoreCalculatorChipType.active,
                            ),
                        if (state.resultChip case final resultChip?) resultChip,
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: ClipRect(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CoreSuggestionArea(
                                aiSuggestions: state.aiSuggestions,
                                conversionSuggestions:
                                state.conversionSuggestions,
                                hiddenChipsTextBuilder: (count) => '+$count',
                                expandToggleSemanticsLabelBuilder: (count) =>
                                'Show $count more suggestions',
                                collapseToggleSemanticsLabel:
                                'Show fewer suggestions',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: CoreSpacing.space1),
                                child: CoreKeyboard(
                                  currentGroup: SuggestionAreaShowcaseScreen
                                      ._basicGeometryGroup,
                                  allGroups:
                                  SuggestionAreaShowcaseScreen._groups,
                                  onDigitPressed: (key) {
                                    bloc.add(DigitPressed(key.label));
                                  },
                                  onUnitSelected: (key) {
                                    bloc.add(UnitSelected(key.label));
                                  },
                                  onOperatorPressed: (key) {
                                    bloc.add(OperatorPressed(key.symbol));
                                  },
                                  onControlAction: (key) {
                                    if (key == ControlAction.clearAll) {
                                      bloc.add(const ResetRequested());
                                    }
                                  },
                                  onResultTapped: () {
                                    bloc.add(const OperatorPressed('='));
                                  },
                                  onGroupSelected: (_) {},
                                  currentUnitSystem: UnitSystem.imperial,
                                  onKeyTapped: (key) {
                                    bloc.add(KeySelected(key.label));
                                  },
                                  onUnitSystemChanged: (_) {},
                                  groupAccentColors: groupAccentColors,
                                  result: const ResultType(label: '='),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
