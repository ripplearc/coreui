import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A bottom sheet widget that displays function key groups for the keyboard.
///
/// The sheet renders [groups] in the order it is given and holds no order of
/// its own: dragging a group's handle reports the move through
/// [onGroupsReordered], and the consumer — who owns the order as a stored
/// preference — reorders [groups] and rebuilds. Handles render only when the
/// callback is set, so a read-only sheet offers no gesture it cannot honour.
///
/// [groups] is the list of function groups to display.
/// [groupAccentColors] is a map of group names to their accent colors.
/// [selectedGroup] is the currently selected function group.
/// [onGroupSelected] is called when a group is selected.
/// [onKeyTapped] is called when a function key is tapped.
/// [showUnitToggle] determines whether to show the unit system toggle.
/// [currentUnitSystem] is the current unit system (imperial or metric).
/// [onUnitSystemChanged] is called when the unit system is changed.
/// [semantics] supplies the screen-reader strings of the unit system switch,
/// the group headers and their drag handles; see [CoreKeyboardSemantics].
/// [labels] supplies the visible "Function keys" title, "Measurement System",
/// the switch's "Imperial" / "Metric" faces and the "… group" headers; see
/// [CoreKeyboardLabels].
class CoreFunctionKeyBottomSheet extends StatefulWidget {
  final List<FunctionGroup> groups;
  final Map<GroupNameType, Color> groupAccentColors;
  final GroupNameType selectedGroup;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;

  /// Called with the dragged group's old index and its final index once it
  /// is dropped. `newIndex` is already adjusted for the removal and both
  /// indices are in range for [groups], so
  /// `groups.insert(newIndex, groups.removeAt(oldIndex))` applies it. Drag
  /// handles render only while this is set.
  final void Function(int oldIndex, int newIndex)? onGroupsReordered;

  /// Builds the drag handle's screen-reader label from the group label, in
  /// place of [CoreKeyboardSemantics.reorderHandle].
  final String Function(String groupLabel)? reorderSemanticsLabelBuilder;

  /// The screen-reader strings of the sheet. Defaults to
  /// [CoreKeyboardSemantics.english]; an app passes its own localised set.
  final CoreKeyboardSemantics semantics;

  /// The visible words of the sheet that are not a key's face. Defaults to
  /// [CoreKeyboardLabels.english]; an app passes its own localised set.
  final CoreKeyboardLabels labels;

  final bool showUnitToggle;
  final UnitSystem currentUnitSystem;
  final ValueChanged<UnitSystem>? onUnitSystemChanged;

  const CoreFunctionKeyBottomSheet({
    super.key,
    required this.groups,
    required this.groupAccentColors,
    required this.selectedGroup,
    required this.onGroupSelected,
    required this.onKeyTapped,
    this.onGroupsReordered,
    this.reorderSemanticsLabelBuilder,
    this.semantics = CoreKeyboardSemantics.english,
    this.labels = CoreKeyboardLabels.english,
    this.showUnitToggle = true,
    this.currentUnitSystem = UnitSystem.imperial,
    this.onUnitSystemChanged,
  });

  /// The English drag handle label, [CoreKeyboardSemantics.reorderHandle] of
  /// [CoreKeyboardSemantics.english], which is where to read it from now.
  @Deprecated('Read CoreKeyboardSemantics.english.reorderHandle instead')
  static String defaultReorderSemanticsLabel(String groupLabel) =>
      CoreKeyboardSemantics.english.reorderHandle(groupLabel);

  @override
  State<CoreFunctionKeyBottomSheet> createState() =>
      _CoreFunctionKeyBottomSheetState();
}

class _CoreFunctionKeyBottomSheetState
    extends State<CoreFunctionKeyBottomSheet> {
  static const double _maxHeightRatio = 0.7;

  void _handleGroupReorder(int oldIndex, int newIndex) {
    assert(
      oldIndex >= 0 &&
          oldIndex < widget.groups.length &&
          newIndex >= 0 &&
          newIndex < widget.groups.length,
      'Reorder indices must be in range for groups',
    );
    widget.onGroupsReordered?.call(oldIndex, newIndex);
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: screenHeight * _maxHeightRatio),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            CoreSpacing.space6,
            CoreSpacing.space4,
            CoreSpacing.space6,
            CoreSpacing.space8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Center(
                child: Container(
                  width: CoreSpacing.space10,
                  height: CoreSpacing.space1,
                  decoration: BoxDecoration(
                    color: colors.lineMid,
                    borderRadius: BorderRadius.circular(CoreSpacing.space2),
                  ),
                ),
              ),
              const SizedBox(height: CoreSpacing.space3),
              if (widget.showUnitToggle)
                _Header(
                  unitSystem: widget.currentUnitSystem,
                  onUnitSystemChanged: widget.onUnitSystemChanged,
                  switchSemanticsLabel: widget.semantics.unitSystemSwitch,
                  labels: widget.labels,
                ),
              if (widget.showUnitToggle)
                const SizedBox(height: CoreSpacing.space3),
              Flexible(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemCount: widget.groups.length,
                  onReorderItem: _handleGroupReorder,
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return Material(
                      color: colors.pageBackground,
                      elevation: 6.0,
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final group = widget.groups[index];
                    final accent = widget.groupAccentColors[group.name] ??
                        colors.keyboardUnits;
                    final isSelected = group.name == widget.selectedGroup;
                    return Padding(
                      key: ValueKey(group.name.id),
                      padding: const EdgeInsets.only(
                        bottom: CoreSpacing.space3,
                      ),
                      child: _FunctionGroupSection(
                        index: index,
                        group: group,
                        headerText: widget.labels.groupHeader(group.name.label),
                        accentColor: accent,
                        isSelected: isSelected,
                        onGroupSelected: widget.onGroupSelected,
                        onKeyTapped: widget.onKeyTapped,
                        showDragHandle: widget.onGroupsReordered != null,
                        headerSemanticsLabel:
                            widget.semantics.groupHeader(group.name.label),
                        dragHandleSemanticsLabel:
                            (widget.reorderSemanticsLabelBuilder ??
                                widget.semantics.reorderHandle)(
                          group.name.label,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FunctionGroupSection extends StatelessWidget {
  final int index;
  final FunctionGroup group;
  final String headerText;
  final Color accentColor;
  final bool isSelected;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;
  final bool showDragHandle;
  final String headerSemanticsLabel;
  final String dragHandleSemanticsLabel;

  const _FunctionGroupSection({
    required this.index,
    required this.group,
    required this.headerText,
    required this.accentColor,
    required this.isSelected,
    required this.onGroupSelected,
    required this.onKeyTapped,
    required this.showDragHandle,
    required this.headerSemanticsLabel,
    required this.dragHandleSemanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupHeader(
          index: index,
          text: headerText,
          accentColor: accentColor,
          isSelected: isSelected,
          onTap: () => onGroupSelected(group.name),
          showDragHandle: showDragHandle,
          semanticsLabel: headerSemanticsLabel,
          dragHandleSemanticsLabel: dragHandleSemanticsLabel,
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
            return FunctionKeyTile(
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

class _Header extends StatefulWidget {
  final UnitSystem unitSystem;
  final ValueChanged<UnitSystem>? onUnitSystemChanged;
  final String switchSemanticsLabel;
  final CoreKeyboardLabels labels;

  const _Header({
    required this.unitSystem,
    required this.switchSemanticsLabel,
    required this.labels,
    this.onUnitSystemChanged,
  });
  @override
  State<_Header> createState() => _HeaderState();
}

class _HeaderState extends State<_Header> {
  ValueChanged<UnitSystem>? get onUnitSystemChanged =>
      widget.onUnitSystemChanged;
  late bool isMetric;

  @override
  void initState() {
    super.initState();
    isMetric = widget.unitSystem == UnitSystem.metric;
  }

  @override
  void didUpdateWidget(covariant _Header oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.unitSystem != widget.unitSystem) {
      setState(() {
        isMetric = widget.unitSystem == UnitSystem.metric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labels.functionKeys,
          style: typography.titleMediumSemiBold.copyWith(
            color: colors.textHeadline,
          ),
        ),
        const SizedBox(height: CoreSpacing.space2),
        Row(
          children: [
            Expanded(
              child: Text(
                widget.labels.measurementSystem,
                overflow: TextOverflow.ellipsis,
                style: typography.bodyMediumMedium.copyWith(
                  color: colors.textHeadline,
                ),
              ),
            ),
            if (onUnitSystemChanged case final callback?)
              Semantics(
                label: widget.switchSemanticsLabel,
                toggled: isMetric,
                child: CoreSwitch(
                  type: CoreSwitchType.imperial,
                  value: isMetric,
                  onChanged: (bool newValue) {
                    setState(() {
                      isMetric = newValue;
                    });
                    callback(
                        newValue ? UnitSystem.metric : UnitSystem.imperial);
                  },
                  activeLabel: widget.labels.metric,
                  inactiveLabel: widget.labels.imperial,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final int index;
  final String text;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showDragHandle;
  final String semanticsLabel;
  final String dragHandleSemanticsLabel;

  const _GroupHeader({
    required this.index,
    required this.text,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
    required this.showDragHandle,
    required this.semanticsLabel,
    required this.dragHandleSemanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Semantics(
      label: semanticsLabel,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            if (showDragHandle) ...[
              ReorderableDragStartListener(
                index: index,
                child: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(
                    Icons.drag_indicator,
                    color: colors.iconGrayMid,
                    semanticLabel: dragHandleSemanticsLabel,
                  ),
                ),
              ),
              const SizedBox(width: CoreSpacing.space2),
            ],
            Flexible(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: typography.bodyMediumSemiBold.copyWith(
                  color: colors.textHeadline,
                ),
              ),
            ),
            const SizedBox(width: CoreSpacing.space2),
            Container(
              width: CoreSpacing.space2,
              height: CoreSpacing.space2,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
