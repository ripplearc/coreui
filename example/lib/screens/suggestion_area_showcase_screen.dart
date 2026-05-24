import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../blocs/suggestion_area_showcase_bloc.dart';

/// A showcase screen demonstrating [CoreSuggestionArea]
class SuggestionAreaShowcaseScreen extends StatelessWidget {
  const SuggestionAreaShowcaseScreen({super.key});

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
                                onExpandedChanged: (expanded) {
                                  bloc.add(SuggestionAreaExpanded(expanded));
                                },
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
