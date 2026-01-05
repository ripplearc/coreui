import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import 'function_key_tile.dart';
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
class CoreFunctionKeyBottomSheet extends StatefulWidget {
  final List<FunctionGroup> groups;
  final Map<GroupNameType, Color> groupAccentColors;
  final GroupNameType selectedGroup;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;
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
    this.showUnitToggle = true,
    this.currentUnitSystem = UnitSystem.imperial,
    this.onUnitSystemChanged,
  });

  @override
  State<CoreFunctionKeyBottomSheet> createState() =>
      _CoreFunctionKeyBottomSheetState();
}

class _CoreFunctionKeyBottomSheetState
    extends State<CoreFunctionKeyBottomSheet> {
  late List<FunctionGroup> _groups;

  static const double _maxHeightRatio = 0.7;

  @override
  void initState() {
    super.initState();
    _groups = List.from(widget.groups);
  }

  void _handleGroupReorder(int oldIndex, int newIndex) {
    if (_groups.isEmpty ||
        oldIndex < 0 ||
        newIndex < 0 ||
        oldIndex >= _groups.length ||
        newIndex >= _groups.length) {
      return;
    }

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
                ),
              if (widget.showUnitToggle)
                const SizedBox(height: CoreSpacing.space3),
              Flexible(
                child: ReorderableListView.builder(
                  buildDefaultDragHandles: false,
                  itemCount: _groups.length,
                  onReorder: _handleGroupReorder,
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return Material(
                      color: colors.pageBackground,
                      elevation: 6.0,
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final group = _groups[index];
                    final accent = widget.groupAccentColors[group.name] ??
                        colors.keyboardUnits;
                    final isSelected = group.name == widget.selectedGroup;
                    return Padding(
                      key: ValueKey(group.name.label),
                      padding: const EdgeInsets.only(
                        bottom: CoreSpacing.space3,
                      ),
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
      ),
    );
  }
}

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

class _Header extends StatelessWidget {
  final UnitSystem unitSystem;
  final ValueChanged<UnitSystem>? onUnitSystemChanged;

  const _Header({required this.unitSystem, required this.onUnitSystemChanged});

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Function keys',
          style: typography.titleMediumSemiBold.copyWith(
            color: colors.textHeadline,
          ),
        ),
        const SizedBox(height: CoreSpacing.space2),
        Row(
          children: [
            Text(
              'Measurement System',
              style: typography.bodyMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const Spacer(),
            if (onUnitSystemChanged case final callback?)
              _UnitSystemToggle(currentSystem: unitSystem, onChanged: callback),
          ],
        ),
      ],
    );
  }
}

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
    final typography = AppTypographyExtension.of(context);
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

/// A toggle widget for switching between unit systems (Imperial and Metric).
///
/// [currentSystem] is the currently selected unit system.
/// [onChanged] is called when the user switches the unit system.
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

  static const Duration _containerAnimationDuration = Duration(
    milliseconds: 300,
  );

  static const Duration _indicatorAnimationDuration = Duration(
    milliseconds: 200,
  );

  static const double _toggleWidth = 80.0;
  static const double _toggleHeight = 24;

  static const double _borderWidth = 1;

  static const double _indicatorSize = 22;

  static const double _indicatorPadding = CoreSpacing.space1;
  static const double _textHorizontalPadding = CoreSpacing.space2;

  static const double _circularBorderRadius = 100.0;

  @override
  void initState() {
    super.initState();
    _isImperial = widget.currentSystem == UnitSystem.imperial;
  }

  @override
  void didUpdateWidget(_UnitSystemToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentSystem != widget.currentSystem) {
      setState(() {
        _isImperial = widget.currentSystem == UnitSystem.imperial;
      });
    }
  }

  Widget _buildToggleContainer(BuildContext context, bool isImperial) {
    final colors = AppColorsExtension.of(context);
    return AnimatedContainer(
      duration: _containerAnimationDuration,
      width: _toggleWidth,
      height: _toggleHeight,
      decoration: BoxDecoration(
        color: isImperial ? colors.textInverse : colors.buttonSurface,
        borderRadius: BorderRadius.circular(_circularBorderRadius),
        border: Border.all(
          color: isImperial ? colors.iconGreen : colors.buttonSurface,
          width: _borderWidth,
        ),
      ),
    );
  }

  Widget _buildImperialText(BuildContext context, bool isImperial) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return AnimatedOpacity(
      duration: _containerAnimationDuration,
      opacity: isImperial ? 1.0 : 0.0,
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: _textHorizontalPadding),
          child: Text(
            'Imperial',
            style: typography.bodySmallRegular.copyWith(
              color: colors.iconGreen,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricText(BuildContext context, bool isImperial) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return AnimatedOpacity(
      duration: _indicatorAnimationDuration,
      opacity: !isImperial ? 1.0 : 0.0,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: _textHorizontalPadding),
          child: Text(
            'Metric',
            style: typography.bodySmallRegular.copyWith(
              color: colors.textInverse,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicatorCircle(BuildContext context, bool isImperial) {
    final colors = AppColorsExtension.of(context);
    return AnimatedAlign(
      duration: _indicatorAnimationDuration,
      alignment: isImperial ? Alignment.centerLeft : Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.all(_indicatorPadding),
        child: Container(
          width: _indicatorSize,
          height: _indicatorSize,
          decoration: BoxDecoration(
            color: isImperial ? colors.iconGreen : colors.textInverse,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isImperial = !_isImperial;
        });
        widget.onChanged(_isImperial ? UnitSystem.imperial : UnitSystem.metric);
      },
      child: SizedBox(
        width: _toggleWidth,
        height: _toggleHeight,
        child: Stack(
          alignment: Alignment.center,
          children: [
            _buildToggleContainer(context, _isImperial),
            _buildImperialText(context, _isImperial),
            _buildMetricText(context, _isImperial),
            _buildIndicatorCircle(context, _isImperial),
          ],
        ),
      ),
    );
  }
}
