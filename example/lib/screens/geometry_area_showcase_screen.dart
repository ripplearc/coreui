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
  /// Extra scroll space reserved so content isn't hidden behind [CoreKeyboard].
  static const double _keyboardScrollBuffer = 350;

  /// A read-only table: with no add, delete or reorder callbacks it renders
  /// without an add action, drag handles or swipe-to-delete.
  static const CoreSizesTableData _ratesAndWasteTable = CoreSizesTableData(
    id: 'rates-and-waste',
    title: 'Rates & waste for 1,750.7yd³',
    columns: [
      CoreSizesColumn(title: 'Per unit'),
      CoreSizesColumn(title: 'Rate'),
      CoreSizesColumn(title: 'Waste'),
      CoreSizesColumn(title: 'Cost'),
    ],
    rows: [
      CoreSizeCardData(
        id: 'ft3',
        values: ['ft³', r'$6.5', '0%', r'$307,247.85'],
      ),
      CoreSizeCardData(
        id: 'yd3',
        values: ['yd³', r'$150', '7%', r'$280,987.35'],
      ),
      CoreSizeCardData(
        id: 'm3',
        values: ['m³', r'$196', '0%', r'$262,346.78'],
      ),
    ],
  );

  static const GroupNameType _basicGeometryGroup = GroupNameType(
    id: 'Basic Geometry',
    label: 'Basic Geometry',
  );
  static const GroupNameType _materialsGroup = GroupNameType(
    id: 'Materials',
    label: 'Materials',
  );
  static const GroupNameType _trigonometryGroup = GroupNameType(
    id: 'Trigonometry',
    label: 'Trigonometry',
  );

  static final List<FunctionGroup> _groups = List.unmodifiable([
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
                      closeSemanticLabel: 'Close',
                      historyPlaceholder: 'Here will show what you type',
                      label: state.activeInputLabel ?? 'Length',
                      value: state.currentInputValue.isEmpty
                          ? '0'
                          : state.currentInputValue,
                      hasError: false,
                      isTyping: state.isTyping,
                      onClose: () => bloc.add(const GeometryResetRequested()),
                      onStageChanged: (stage) {},
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
                                    toggleSemanticsLabel:
                                        'Toggle suggestion mode',
                                  ),
                                  CoreGeometryArea(
                                    isCollapsed: false,
                                    tables: [
                                      CoreSizesTableData(
                                        id: 'circle-measurements',
                                        title: 'Circle measurements',
                                        addLabel: 'Add size',
                                        editLabel: 'Edit size',
                                        dragHandleLabel: 'Reorder',
                                        editRowSemanticsLabelBuilder: (row) =>
                                            'Edit ${row.values.first}',
                                        deleteRowSemanticsLabelBuilder: (row) =>
                                            'Delete ${row.values.first}',
                                        columns: const [
                                          CoreSizesColumn(title: 'Length'),
                                          CoreSizesColumn(title: 'Width'),
                                        ],
                                        rows: state.sizesTableData,
                                        onDeleted: (id) =>
                                            bloc.add(SizeDeleted(id)),
                                        onReordered: (oldIndex, newIndex) =>
                                            bloc.add(
                                          SizesReordered(oldIndex, newIndex),
                                        ),
                                        onSaved: (result) =>
                                            bloc.add(SizeSaved(result)),
                                      ),
                                      // A fixed table: no add, delete or
                                      // reorder callbacks, so none of those
                                      // affordances render.
                                      _ratesAndWasteTable,
                                    ],
                                    dimensions: state.dimensions,
                                    onViewAllAttachmentsPressed: () {},
                                    onMediaButtonPressed: () {},
                                    onDocumentButtonPressed: () {},
                                  ),
                                  const SizedBox(height: _keyboardScrollBuffer),
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
