import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/typography_extension.dart';
import 'keyboard_models.dart';

/// A bottom sheet widget that displays function key groups for the keyboard.
///
/// This component provides a modal bottom sheet interface for displaying
/// organized groups of function keys with optional unit system toggle.
///
/// Example usage:
/// ```dart
/// CoreFunctionBottomSheet(
///   groups: functionGroups,
///   groupAccentColors: accentColorMap,
///   selectedGroup: GroupNameType.trigonometry,
///   onGroupSelected: (group) => print('Selected: $group'),
///   onKeyTapped: (key) => print('Tapped: ${key.label}'),
///   showUnitToggle: true,
///   currentUnitSystem: UnitSystem.imperial,
///   onUnitSystemChanged: (system) => print('Unit system: $system'),
/// )
/// ```
///
/// [groups] is the list of function groups to display.
/// [groupAccentColors] is a map of group names to their accent colors.
/// [selectedGroup] is the currently selected function group.
/// [onGroupSelected] is called when a group is selected.
/// [onKeyTapped] is called when a function key is tapped.
/// [showUnitToggle] determines whether to show the unit system toggle.
/// [currentUnitSystem] is the current unit system (imperial or metric).
/// [onUnitSystemChanged] is called when the unit system is changed.
class CoreFunctionBottomSheet extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          CoreSpacing.space6,
          CoreSpacing.space4,
          CoreSpacing.space6,
          CoreSpacing.space8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
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
            if (showUnitToggle)
              _Header(
                unitSystem: currentUnitSystem,
                onUnitSystemChanged: onUnitSystemChanged,
              ),
            if (showUnitToggle) const SizedBox(height: CoreSpacing.space3),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: groups.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: CoreSpacing.space3),
                itemBuilder: (context, index) {
                  final group = groups[index];
                  final accent = groupAccentColors[group.name] ??
                      colors?.keyboardUnits ??
                      CoreKeyboardColors.units;
                  final isSelected = group.name == selectedGroup;
                  return _FunctionGroupSection(
                    group: group,
                    accentColor: accent,
                    isSelected: isSelected,
                    onGroupSelected: onGroupSelected,
                    onKeyTapped: onKeyTapped,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A section widget that displays a single function group.
class _FunctionGroupSection extends StatelessWidget {
  final FunctionGroup group;
  final Color accentColor;
  final bool isSelected;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;

  const _FunctionGroupSection({
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

/// A toggle widget for switching between unit systems.
class _UnitSystemToggle extends StatelessWidget {
  final UnitSystem unitSystem;
  final ValueChanged<UnitSystem> onChanged;

  const _UnitSystemToggle({
    required this.unitSystem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = TypographyExtension.of(context);

    final bool isImperial = unitSystem == UnitSystem.imperial;

    final activeColor = isImperial ? colors.iconGreen : colors.iconBlue;
    final backgroundColor =
        isImperial ? colors.pageBackground : colors.iconBlue;
    return Semantics(
      label: 'Unit system toggle, currently ${unitSystem.label}',
      button: true,
      hint:
          'Tap to switch between ${UnitSystem.imperial.label} and ${UnitSystem.metric.label}',
      child: GestureDetector(
        onTap: () {
          final nextSystem =
              isImperial ? UnitSystem.metric : UnitSystem.imperial;
          onChanged(nextSystem);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space1,
            vertical: CoreSpacing.space1,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: activeColor),
            borderRadius: BorderRadius.circular(CoreSpacing.space6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            textDirection: isImperial ? TextDirection.ltr : TextDirection.rtl,
            children: [
              Container(
                width: CoreSpacing.space3 + CoreSpacing.space1,
                height: CoreSpacing.space3 + CoreSpacing.space1,
                decoration: BoxDecoration(
                  color: isImperial ? activeColor : colors.pageBackground,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: CoreSpacing.space1),
              Text(
                isImperial
                    ? UnitSystem.imperial.label
                    : UnitSystem.metric.label,
                style: typography.bodySmallSemiBold.copyWith(
                  color: isImperial ? activeColor : colors.textInverse,
                ),
              ),
            ],
          ),
        ),
      ),
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
                unitSystem: unitSystem,
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
  final String name;
  final Color accentColor;
  final bool isSelected;
  final VoidCallback onTap;

  const _GroupHeader({
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
            RotatedBox(
              quarterTurns: 1,
              child: Icon(
                Icons.drag_indicator,
                color: colors.iconGrayMid,
                semanticLabel: 'Drag indicator for $name group',
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
