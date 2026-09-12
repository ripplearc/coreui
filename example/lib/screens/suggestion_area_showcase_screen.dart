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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SuggestionAreaShowcaseBloc(),
      child: const _SuggestionAreaShowcaseView(),
    );
  }
}

class _SuggestionAreaShowcaseView extends StatefulWidget {
  const _SuggestionAreaShowcaseView();

  @override
  State<_SuggestionAreaShowcaseView> createState() =>
      _SuggestionAreaShowcaseViewState();
}

class _SuggestionAreaShowcaseViewState
    extends State<_SuggestionAreaShowcaseView> {
  CoreSuggestionLayout _layout = CoreSuggestionLayout.twoRows;
  bool _secondRowHidden = false;
  GroupNameType _currentGroup =
      SuggestionAreaShowcaseScreen._basicGeometryGroup;
  List<FunctionGroup> _groups = [
    FunctionGroup(
      name: SuggestionAreaShowcaseScreen._basicGeometryGroup,
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
      name: SuggestionAreaShowcaseScreen._materialsGroup,
      keys: [
        KeyType(groupName: 'Materials', id: 'Lbs', label: 'Lbs'),
        KeyType(groupName: 'Materials', id: 'Kg', label: 'Kg'),
        KeyType(groupName: 'Materials', id: 'Tons', label: 'Tons'),
        KeyType(groupName: 'Materials', id: 'Drywall', label: 'Drywall'),
        KeyType(groupName: 'Materials', id: 'Fence', label: 'Fence'),
      ],
    ),
    FunctionGroup(
      name: SuggestionAreaShowcaseScreen._trigonometryGroup,
      keys: [
        KeyType(groupName: 'Trigonometry', id: 'SIN', label: 'SIN'),
        KeyType(groupName: 'Trigonometry', id: 'COS', label: 'COS'),
        KeyType(groupName: 'Trigonometry', id: 'TAN', label: 'TAN'),
      ],
    ),
  ];

  Widget _layoutControls(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final labelStyle =
        typography.bodySmallRegular.copyWith(color: colors.textBody);
    final isTwoRows = _layout == CoreSuggestionLayout.twoRows;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space4,
        CoreSpacing.space2,
        CoreSpacing.space4,
        0,
      ),
      child: Wrap(
        spacing: CoreSpacing.space4,
        runSpacing: CoreSpacing.space2,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Two rows', style: labelStyle),
              const SizedBox(width: CoreSpacing.space2),
              CoreSwitch(
                value: isTwoRows,
                onChanged: (value) => setState(() {
                  _layout = value
                      ? CoreSuggestionLayout.twoRows
                      : CoreSuggestionLayout.toggle;
                }),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Hide conversions row', style: labelStyle),
              const SizedBox(width: CoreSpacing.space2),
              CoreSwitch(
                value: _secondRowHidden,
                onChanged: (value) => setState(() => _secondRowHidden = value),
              ),
            ],
          ),
        ],
      ),
    );
  }

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
                          CoreCalculatorChip(
                            label: state.activeInputLabel,
                            value: state.currentInputValue,
                            type: CoreCalculatorChipType.active,
                          ),
                        if (state.resultChip case final resultChip?) resultChip,
                      ],
                    ),
                    _layoutControls(context),
                    AnimatedContainer(
                      duration: CoreSuggestionArea.animationDuration,
                      curve: Curves.easeInOut,
                      child: ClipRect(
                        child: SingleChildScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CoreSuggestionArea(
                                layout: _layout,
                                secondRowHidden: _secondRowHidden,
                                aiSuggestions: state.aiSuggestions,
                                conversionSuggestions:
                                    state.conversionSuggestions,
                                hiddenChipsTextBuilder: (count) => '+$count',
                                expandToggleSemanticsLabelBuilder: (count) =>
                                    'Show $count more suggestions',
                                collapseToggleSemanticsLabel:
                                    'Show fewer suggestions',
                                conversionsExpandToggleSemanticsLabelBuilder:
                                    (count) => 'Show $count more conversions',
                                conversionsCollapseToggleSemanticsLabel:
                                    'Show fewer conversions',
                                toggleSemanticsLabel: 'Toggle suggestion mode',
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: CoreSpacing.space1),
                                child: CoreKeyboard(
                                  currentGroup: _currentGroup,
                                  allGroups: _groups,
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
                                  onGroupSelected: (group) =>
                                      setState(() => _currentGroup = group),
                                  onGroupsReordered: (oldIndex, newIndex) =>
                                      setState(() {
                                    final next = List.of(_groups);
                                    next.insert(
                                        newIndex, next.removeAt(oldIndex));
                                    _groups = next;
                                  }),
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
