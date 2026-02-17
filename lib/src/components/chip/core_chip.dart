import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

enum CoreChipSize { small, medium, large }

class CoreChip extends StatelessWidget {
  final String label;
  final ValueNotifier<bool> selected;
  final CoreChipSize size;
  final CoreIconData? icon;
  final VoidCallback? onTap;

  const CoreChip({
    super.key,
    required this.label,
    required this.selected,
    this.size = CoreChipSize.medium,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> highlight = ValueNotifier(false);
    final ValueNotifier<bool> pressed = ValueNotifier(false);

    return Semantics(
      label: label,
      button: true,
      selected: selected.value,
      child: ExcludeSemantics(
        child: GestureDetector(
          onTapDown: (_) {
            highlight.value = true;
            pressed.value = true;
          },
          onTapUp: (_) {
            pressed.value = false;
            highlight.value = false;
            selected.value = !selected.value;
            onTap?.call();
          },
          onTapCancel: () {
            pressed.value = false;
            highlight.value = false;
          },
          child: ValueListenableBuilder<bool>(
            valueListenable: selected,
            builder: (_, isSelected, __) {
              return ValueListenableBuilder<bool>(
                valueListenable: highlight,
                builder: (_, isHighlight, __) {
                  return ValueListenableBuilder<bool>(
                    valueListenable: pressed,
                    builder: (_, isPressed, __) {
                      return _buildChip(
                          context, isSelected, isHighlight, isPressed);
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChip(
      BuildContext context, bool selected, bool highlight, bool pressed) {
    final bool isLarge = size == CoreChipSize.large;
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    final textStyle = typography.bodyMediumRegular;

    final defaultBackground = isLarge ? colors.textInverse : colors.chipGrey;

    final defaultBorder = isLarge ? colors.lineMid : colors.chipGrey;
    final highlightBorder = colors.lineHighlight;
    final pressedBorder = colors.lineDarkOutline;
    final selectedBorder = colors.outlineHover;

    Color background = defaultBackground;
    Color borderColor = defaultBorder;

    if (pressed) {
      borderColor = pressedBorder;
    } else if (highlight) {
      borderColor = highlightBorder;
    }

    if (selected) {
      borderColor = selectedBorder;
    }

    final border = BorderSide(color: borderColor, width: 1.3);
    final shadow = isLarge ? CoreShadows.medium : null;

    final padding = switch (size) {
      CoreChipSize.small =>
        const EdgeInsets.symmetric(horizontal: CoreSpacing.space2, vertical: 2),
      CoreChipSize.medium =>
        const EdgeInsets.symmetric(horizontal: CoreSpacing.space3, vertical: 6),
      CoreChipSize.large => const EdgeInsets.symmetric(
          horizontal: CoreSpacing.space3, vertical: CoreSpacing.space3),
    };

    // Accessibility: ensure minimum tap target size
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 48.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(100),
          border: Border.fromBorderSide(border),
          boxShadow: shadow,
        ),
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              CoreIconWidget(
                icon: icon!,
                size: CoreSpacing.space5,
                color: colors.outlineFocus,
              ),
            ],
            Padding(
              padding: EdgeInsetsDirectional.only(
                  start: icon != null ? CoreSpacing.space2 : 0,
                  end: CoreSpacing.space2),
              child: Text(label, style: textStyle),
            ),
            CoreIconWidget(
              icon: CoreIcons.close,
              size: CoreSpacing.space5,
              color: colors.iconGrayMid,
            ),
          ],
        ),
      ),
    );
  }
}
