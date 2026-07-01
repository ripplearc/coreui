import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../blocs/geometry_area_bloc.dart';

/// Showcase screen for [CoreGeometryArea].
///
/// Demonstrates the full circle-calculation flow:
///   Length key → number → unit → Width key → same number → unit
///   → AI suggestions: Area, Radius, Diameter, Circumference
class GeometryAreaShowcaseScreen extends StatefulWidget {
  const GeometryAreaShowcaseScreen({super.key});

  @override
  State<GeometryAreaShowcaseScreen> createState() =>
      _GeometryAreaShowcaseScreenState();
}

class _GeometryAreaShowcaseScreenState
    extends State<GeometryAreaShowcaseScreen> {
  static const GroupNameType _basicGeometryGroup =
      GroupNameType(label: 'Basic Geometry');
  static const GroupNameType _materialsGroup =
      GroupNameType(label: 'Materials');
  static const GroupNameType _trigonometryGroup =
      GroupNameType(label: 'Trigonometry');

  static final List<FunctionGroup> _groups = List.unmodifiable([
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
  ]);

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final Map<GroupNameType, Color> groupAccentColors = {
      _basicGeometryGroup: colors.keyboardFunctions,
      _materialsGroup: colors.keyboardUnits,
      _trigonometryGroup: colors.textSuccess,
    };

    return BlocProvider(
      create: (context) => GeometryAreaBloc(),
      child: Scaffold(
        backgroundColor: colors.backgroundBlueLight,
        body: SafeArea(
          child: DecoratedBox(
            decoration: BoxDecoration(color: colors.pageBackground),
            child: BlocBuilder<GeometryAreaBloc, GeometryAreaState>(
              builder: (context, state) {
                final bloc = context.read<GeometryAreaBloc>();

                return Column(
                  children: [
                    CoreDisplayArea(
                      label: state.activeInputLabel ?? 'Length',
                      value: state.currentInputValue.isEmpty
                          ? '0'
                          : state.currentInputValue,
                      hasError: false,
                      isTyping: state.isTyping,
                      onClose: () => bloc.add(const GeometryResetRequested()),
                      onStageChanged: (stage) {},
                      dependentKeyLabel: null,
                      dependentKeyValue: null,
                      onPressedDependentKey: () {},
                      chipsList: [
                        ...state.completedChips,
                        if (state.isTyping && state.activeInputLabel != null)
                          CoreCalculatorChip(
                            label: state.activeInputLabel ?? '',
                            value: state.currentInputValue,
                            type: CoreCalculatorChipType.active,
                          ),
                      ],
                      previousSessions: const [],
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CoreSuggestionArea(
                                    aiSuggestions: state.aiSuggestions,
                                    conversionSuggestions:
                                        state.conversionSuggestions,
                                    hiddenChipsTextBuilder: (count) =>
                                        '+$count',
                                    expandToggleSemanticsLabelBuilder:
                                        (count) =>
                                            'Expand $count more suggestions',
                                    collapseToggleSemanticsLabel:
                                        'Collapse suggestions',
                                  ),
                                  CoreGeometryArea(
                                    isCollapsed: false,
                                    sizesTitleLabel: 'Circle measurements',
                                    addSizeLabel: 'Add size',
                                    editSizeLabel: 'Edit size',
                                    sizesTableTitles: const ['Length', 'Width'],
                                    sizesTableData: state.sizesTableData,
                                    onSizeDeleted: (id) =>
                                        bloc.add(SizeDeleted(id)),
                                    onSizesReordered: (oldIndex, newIndex) =>
                                        bloc.add(
                                            SizesReordered(oldIndex, newIndex)),
                                    onSizeSaved: (result) =>
                                        bloc.add(SizeSaved(result)),
                                    dimensions: state.dimensions,
                                    onViewAllAttachmentsPressed: () {},
                                    onMediaButtonPressed: () {},
                                    onDocumentButtonPressed: () {},
                                  ),
                                  const SizedBox(
                                      height:
                                          350), // Allows scrolling content above keyboard
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: CoreKeyboard(
                              currentGroup: _basicGeometryGroup,
                              allGroups: _groups,
                              onDigitPressed: (digit) =>
                                  bloc.add(GeometryDigitPressed(digit.label)),
                              onUnitSelected: (unit) =>
                                  bloc.add(GeometryUnitSelected(unit.label)),
                              onOperatorPressed: (op) =>
                                  bloc.add(GeometryOperatorPressed(op.symbol)),
                              onControlAction: (action) {
                                if (action == ControlAction.delete) {
                                  bloc.add(const GeometryDeletePressed());
                                } else if (action == ControlAction.clearAll) {
                                  bloc.add(const GeometryResetRequested());
                                }
                              },
                              onResultTapped: () =>
                                  bloc.add(const GeometryOperatorPressed('=')),
                              onGroupSelected: (_) {},
                              currentUnitSystem: UnitSystem.imperial,
                              onKeyTapped: (key) =>
                                  bloc.add(GeometryKeySelected(key.label)),
                              onUnitSystemChanged: (_) {},
                              groupAccentColors: groupAccentColors,
                              result: const ResultType(label: '='),
                            ),
                          ),
                        ],
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
