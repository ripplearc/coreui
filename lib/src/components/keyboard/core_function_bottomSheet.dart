import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/typography_extension.dart';
import 'keyboard_models.dart';

/// A bottom sheet widget that displays function key groups for the keyboard.
///
/// [groups] is the list of function groups to display.
/// [groupAccentColors] is a map of group names to their accent colors.
/// [selectedGroup] is the currently selected function group.
/// [onGroupSelected] is called when a group is selected.
/// [onKeyTapped] is called when a function key is tapped.
/// [showUnitToggle] determines whether to show the unit system toggle.
/// [currentUnitSystem] is the current unit system (imperial or metric).
/// [onUnitSystemChanged] is called when the unit system is changed.
class CoreFunctionBottomSheet extends StatefulWidget {
  final List<FunctionGroup> groups;
  final Map<GroupNameType, Color> groupAccentColors;
  final GroupNameType selectedGroup;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;
  final bool showUnitToggle;
  final UnitSystem currentUnitSystem;
  final ValueChanged<UnitSystem>? onUnitSystemChanged;

  const CoreFunctionBottomSheet({
    super.key,
    required this.groups,
    required this.groupAccentColors,
    required this.selectedGroup,
    required this.onGroupSelected,
    required this.onKeyTapped,
    this.showUnitToggle = true,
    this.currentUnitSystem = UnitSystem.imperial,
    this.onUnitSystemChanged,
  });

  @override
  State<CoreFunctionBottomSheet> createState() =>
      _CoreFunctionBottomSheetState();
}

class _CoreFunctionBottomSheetState extends State<CoreFunctionBottomSheet> {
  late List<FunctionGroup> _groups;

  @override
  void initState() {
    super.initState();
    _groups = List.from(widget.groups);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final FunctionGroup item = _groups.removeAt(oldIndex);
      _groups.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
        child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.7,
      ),
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
                  color: colors?.lineMid,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
              ),
            ),
            const SizedBox(height: CoreSpacing.space3),
            if (widget.showUnitToggle)
              _Header(
                unitSystem: widget.currentUnitSystem,
                onUnitSystemChanged: widget.onUnitSystemChanged,
              ),
            if (widget.showUnitToggle)
              const SizedBox(height: CoreSpacing.space3),
            Flexible(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                itemCount: _groups.length,
                onReorder: _onReorder,
                itemBuilder: (context, index) {
                  final group = _groups[index];
                  final accent = widget.groupAccentColors[group.name] ??
                      colors?.keyboardUnits ??
                      CoreKeyboardColors.units;
                  final isSelected = group.name == widget.selectedGroup;
                  return Padding(
                    key: ValueKey(group.name.label),
                    padding: const EdgeInsets.only(bottom: CoreSpacing.space3),
                    child: _FunctionGroupSection(
                      index: index,
                      group: group,
                      accentColor: accent,
                      isSelected: isSelected,
                      onGroupSelected: widget.onGroupSelected,
                      onKeyTapped: widget.onKeyTapped,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

/// A section widget that displays a single function group.
class _FunctionGroupSection extends StatelessWidget {
  final int index;
  final FunctionGroup group;
  final Color accentColor;
  final bool isSelected;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;

  const _FunctionGroupSection({
    required this.index,
    required this.group,
    required this.accentColor,
    required this.isSelected,
    required this.onGroupSelected,
    required this.onKeyTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupHeader(
          index: index,
          name: group.name.label,
          accentColor: accentColor,
          isSelected: isSelected,
          onTap: () => onGroupSelected(group.name),
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
            return _FunctionKeyTile(
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

/// A header widget for the bottom sheet.
class _Header extends StatelessWidget {
  final UnitSystem unitSystem;
  final ValueChanged<UnitSystem>? onUnitSystemChanged;

  const _Header({
    required this.unitSystem,
    required this.onUnitSystemChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = TypographyExtension.of(context);
    final isImperial = unitSystem == UnitSystem.imperial;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Function keys',
              style: typography.titleMediumSemiBold.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const Spacer(),
            if (onUnitSystemChanged != null)
              _UnitSystemToggle(
                currentSystem: unitSystem,
                onChanged: onUnitSystemChanged!,
              ),
          ],
        ),
        const SizedBox(height: CoreSpacing.space2),
        Text(
          'Measurement System',
          style: typography.bodyMediumSemiBold.copyWith(
            color: colors.textHeadline,
          ),
        ),
      ],
    );
  }
}

/// A header widget for a function group section.
class _GroupHeader extends StatelessWidget {
  final int index;
  final String name;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _GroupHeader({
    required this.index,
    required this.name,
    required this.accentColor,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = TypographyExtension.of(context);
    return Semantics(
      label: 'Function group header for $name',
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: RotatedBox(
                quarterTurns: 1,
                child: Icon(
                  Icons.drag_indicator,
                  color: colors.iconGrayMid,
                  semanticLabel: 'Drag indicator for $name group',
                ),
              ),
            ),
            const SizedBox(width: CoreSpacing.space2),
            Text(
              '$name group',
              style: typography.bodyMediumSemiBold.copyWith(
                color: colors.textHeadline,
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

/// A tile widget for a single function key.
class _FunctionKeyTile extends StatelessWidget {
  final KeyType keyType;
  final VoidCallback onTap;

  const _FunctionKeyTile({
    required this.keyType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = TypographyExtension.of(context);
    return Semantics(
      label: 'Function key ${keyType.label}',
      button: true,
      hint: 'Tap to use ${keyType.label} function',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colors.backgroundGrayMid,
            borderRadius: BorderRadius.circular(CoreSpacing.space2),
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (keyType.icon != null) ...[
                  Icon(
                    keyType.icon,
                    color: colors.textHeadline,
                    size: CoreSpacing.space4,
                  ),
                  const SizedBox(width: CoreSpacing.space1),
                ],
                Text(
                  keyType.label,
                  style: typography.bodyMediumRegular.copyWith(
                    color: colors.textHeadline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnitSystemToggle extends StatefulWidget {
  final UnitSystem currentSystem;
  final ValueChanged<UnitSystem> onChanged;

  const _UnitSystemToggle({
    required this.currentSystem,
    required this.onChanged,
  });

  @override
  State<_UnitSystemToggle> createState() => _UnitSystemToggleState();
}

class _UnitSystemToggleState extends State<_UnitSystemToggle> {
  late bool _isImperial;

  @override
  void initState() {
    super.initState();
    _isImperial = widget.currentSystem == UnitSystem.imperial;
  }

  @override
  void didUpdateWidget(_UnitSystemToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSystem != widget.currentSystem) {
      _isImperial = widget.currentSystem == UnitSystem.imperial;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = TypographyExtension.of(context);

    final greenColor = colors.keyboardUnits ?? CoreKeyboardColors.units;
    final blueColor = colors.buttonSurface;

    return GestureDetector(
      onTap: () {
        setState(() {
          _isImperial = !_isImperial;
        });
        widget.onChanged(_isImperial ? UnitSystem.imperial : UnitSystem.metric);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 110,
        height: 32,
        decoration: BoxDecoration(
          color: _isImperial ? Colors.transparent : blueColor,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: _isImperial ? greenColor : blueColor,
            width: 1.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _isImperial ? 1.0 : 0.0,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    'Imperial',
                    style: typography.bodySmallSemiBold.copyWith(
                      color: greenColor,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: !_isImperial ? 1.0 : 0.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(
                    'Metric',
                    style: typography.bodySmallSemiBold.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: _isImperial ? Alignment.centerLeft : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _isImperial ? greenColor : Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
