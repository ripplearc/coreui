import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../blocs/geometry_area_bloc.dart';

/// it would be for CoreGeometryArea component
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

  String _currentInputValue = '';
  bool _isKeyboardCollapsed = false;

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
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        CoreDisplayArea(
                          label: 'Length',
                          value: _currentInputValue.isEmpty
                              ? '0'
                              : _currentInputValue,
                          hasError: false,
                          isTyping: _currentInputValue.isNotEmpty,
                          onClose: () {
                            setState(() {
                              _currentInputValue = '';
                            });
                          },
                          onStageChanged: (stage) {},
                          dependentKeyLabel: null,
                          dependentKeyValue: null,
                          onPressedDependentKey: () {},
                          chipsList: const [],
                          previousSessions: const [],
                        ),
                        CoreSuggestionArea(
                          conversionSuggestions: [
                            SuggestionData(
                                label: 'Metric Area',
                                value: '13.3',
                                unit: 'sq m',
                                onTap: () {}),
                          ],
                          hiddenChipsTextBuilder: (count) => '+$count',
                          expandToggleSemanticsLabelBuilder: (count) =>
                              'Expand $count more suggestions',
                          collapseToggleSemanticsLabel: 'Collapse suggestions',
                        ),
                        if (_isKeyboardCollapsed)
                          BlocBuilder<GeometryAreaBloc, GeometryAreaState>(
                            builder: (context, state) {
                              return CoreGeometryArea(
                                isCollapsed: true,
                                sizesTitleLabel: 'Concrete volumes for 70ft',
                                addSizeLabel: 'Add size',
                                editSizeLabel: 'Edit size',
                                sizesTableTitles: const [
                                  'Rails /section',
                                  'O.C.',
                                  'No. of posts',
                                  'No. of rails',
                                  'No. of brackets',
                                  'No. of screws',
                                ],
                                sizesTableData: state.sizesTableData,
                                onSizeDeleted: (id) {
                                  context
                                      .read<GeometryAreaBloc>()
                                      .add(SizeDeleted(id));
                                },
                                onSizesReordered: (oldIndex, newIndex) {
                                  context
                                      .read<GeometryAreaBloc>()
                                      .add(SizesReordered(oldIndex, newIndex));
                                },
                                onSizeSaved: (result) {
                                  context
                                      .read<GeometryAreaBloc>()
                                      .add(SizeSaved(result));
                                },
                                dimensions: const [
                                  CoreDimensionData(
                                      label: 'Area', value: '50.27ft²'),
                                  CoreDimensionData(
                                      label: 'Diameter', value: '8ft'),
                                  CoreDimensionData(
                                      label: 'Radius', value: '4ft'),
                                  CoreDimensionData(
                                      label: 'Circumference', value: '25.13ft'),
                                ],
                                onViewAllAttachmentsPressed: () {},
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
                CoreKeyboard(
                  currentGroup: _basicGeometryGroup,
                  allGroups: _groups,
                  onDigitPressed: (digit) {
                    setState(() {
                      _currentInputValue += digit.label;
                    });
                  },
                  onUnitSelected: (unit) {},
                  onOperatorPressed: (op) {},
                  onControlAction: (action) {
                    if (action == ControlAction.delete &&
                        _currentInputValue.isNotEmpty) {
                      setState(() {
                        _currentInputValue = _currentInputValue.substring(
                            0, _currentInputValue.length - 1);
                      });
                    } else if (action == ControlAction.clearAll) {
                      setState(() {
                        _currentInputValue = '';
                      });
                    }
                  },
                  onResultTapped: () {},
                  onGroupSelected: (_) {},
                  currentUnitSystem: UnitSystem.imperial,
                  onKeyTapped: (key) {},
                  onUnitSystemChanged: (_) {},
                  groupAccentColors: groupAccentColors,
                  result: const ResultType(label: '='),
                  onCollapseChanged: (collapsed) {
                    setState(() {
                      _isKeyboardCollapsed = collapsed;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
