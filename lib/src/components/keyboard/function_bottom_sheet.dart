import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../../theme/typography.dart';
import '../../theme/typography_extension.dart';
import 'keyboard_models.dart';

class FunctionBottomSheet extends StatelessWidget {
  final List<FunctionGroup> groups;
  final Map<GroupNameType, Color> groupAccentColors;
  final GroupNameType selectedGroup;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;
  final bool showUnitToggle;
  final UnitSystem currentUnitSystem;
  final ValueChanged<UnitSystem>? onUnitSystemChanged;

  const FunctionBottomSheet({
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
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: colors?.lineMid,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
              ),
            ),
            const SizedBox(height: CoreSpacing.space3),
            _Header(
              unitSystem: currentUnitSystem,
              onUnitSystemChanged: onUnitSystemChanged,
            ),
            const SizedBox(height: CoreSpacing.space3),

            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: groups.length,
                separatorBuilder: (_, __) => const SizedBox(height: CoreSpacing.space3),
                itemBuilder: (context, index) {
                  final group = groups[index];
                  final accent = groupAccentColors[group.name] ??
                      colors?.keyboardUnits;
                  return _FunctionGroupSection(
                    group: group,
                    accentColor: accent,
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

class _FunctionGroupSection extends StatelessWidget {
  final FunctionGroup group;
  final Color? accentColor;
  final ValueChanged<GroupNameType> onGroupSelected;
  final ValueChanged<KeyType> onKeyTapped;

  const _FunctionGroupSection({
    required this.group,
    this.accentColor,
    required this.onGroupSelected,
    required this.onKeyTapped,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _GroupHeader(
          name: group.name.label,
          accentColor: accentColor!,
        ),
        const SizedBox(height: 12),
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

class _UnitSystemToggle extends StatelessWidget {
  final UnitSystem unitSystem;
  final ValueChanged<UnitSystem> onChanged;

  const _UnitSystemToggle({
    required this.unitSystem,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();

    final bool isImperial = unitSystem == UnitSystem.imperial;
   
    Color? activeColor = isImperial ? colors?.iconGreen : colors?.iconBlue;
    Color? backgroundColor = isImperial ? colors?.pageBackground : colors?.iconBlue;

    return GestureDetector(
      onTap: () {
        final nextSystem = isImperial ? UnitSystem.metric : UnitSystem.imperial;
        onChanged(nextSystem);
      },
      child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space1,
              vertical: CoreSpacing.space1,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
            border: Border.all(
            color: activeColor!,),
              borderRadius: BorderRadius.circular(CoreSpacing.space6),),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: isImperial ? TextDirection.ltr : TextDirection.rtl,
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: isImperial ? activeColor: colors?.pageBackground,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: CoreSpacing.space1),
                Text(
                  isImperial ? UnitSystem.imperial.label : UnitSystem.metric.label,
                  style: typography?.bodySmallSemiBold.copyWith(
                    color: isImperial ? activeColor:  colors?.textInverse
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

class _Header extends StatelessWidget {
  final UnitSystem unitSystem;
  final ValueChanged<UnitSystem>? onUnitSystemChanged;

  const _Header({
    required this.unitSystem,
    required this.onUnitSystemChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Function keys',
              style: typography?.titleMediumSemiBold.copyWith(
                color: colors?.textHeadline
              ),
            ),
            const Spacer(),
              _UnitSystemToggle(
                unitSystem: unitSystem,
                onChanged: onUnitSystemChanged!,
              ),
          ],
        ),
        const SizedBox(height: 8),
          Text(
            'Measurement System',
            style:typography?.bodyMediumSemiBold.copyWith(
              color: colors?.textHeadline)
          ),
      ],
    );
  }
}

class _GroupHeader extends StatelessWidget {
  final String name;
  final Color? accentColor;

  const _GroupHeader({
    required this.name,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return Row(
      children: [
        RotatedBox(
          quarterTurns:1,
          child: Icon(
            Icons.drag_indicator,
            color: colors?.iconGrayMid,
          ),
        ),
        const SizedBox(width: CoreSpacing.space2),
        Text(
          '$name group',
          style: typography?.bodyMediumSemiBold.copyWith(
            color: colors?.textHeadline
          ),
        ),
        const SizedBox(width:  CoreSpacing.space2),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: accentColor!,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

class _FunctionKeyTile extends StatelessWidget {
  final KeyType keyType;
  final VoidCallback onTap;


  const _FunctionKeyTile({
    required this.keyType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColorsExtension>();
    final typography = Theme.of(context).extension<TypographyExtension>();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors?.backgroundGrayMid,
          borderRadius: BorderRadius.circular(CoreSpacing.space2),
        ),
        child: Center(child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (keyType.icon != null) ...[
              Icon(
                keyType.icon,
                color: colors?.textHeadline,
                size: 16,
              ),
              const SizedBox(width: CoreSpacing.space1),
            ],
            Text(
              keyType.label,
              style: typography?.bodyMediumRegular.copyWith(
                color: colors?.textHeadline,
              ),
            ),
          ],
        ),)
       ,
      ),
    );
  }
}

