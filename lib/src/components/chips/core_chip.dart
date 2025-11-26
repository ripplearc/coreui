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

    return GestureDetector(
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
    );
  }

  // ----------------------------------------------------------------------
  //                           BUILD CHIP
  // ----------------------------------------------------------------------

  Widget _buildChip(
    BuildContext context,
    bool selected,
    bool highlight,
    bool pressed,
  ) {
    final bool isLarge = size == CoreChipSize.large;

    // ---------------- TEXT STYLE ----------------
    final textStyle = isLarge
        ? CoreTypography.bodySmallRegular()
        : CoreTypography.bodyLargeRegular();

    // ---- COLORS ----
    final bgDefault = isLarge ? CoreButtonColors.inverse : CoreChipColors.gray;
    final bgHighlight =
        isLarge ? CoreButtonColors.inverse : CoreChipColors.gray;
    final bgPressed = CoreButtonColors.inverse;
    final bgSelected = CoreButtonColors.inverse;

    final borderDefault =
        isLarge ? CoreBorderColors.lineMid : CoreChipColors.gray;
    final borderHighlight = CoreBorderColors.lineHighlight;
    final borderPressed = CoreBorderColors.lineDarkOutline;
    final borderSelected = CoreBorderColors.outlineHover;

    // ---------------- BACKGROUNDS ----------------
    Color background = bgDefault;
    Color borderColor = borderDefault;

    if (pressed) {
      background = bgPressed;
      borderColor = borderPressed;
    } else if (highlight) {
      background = bgHighlight;
      borderColor = borderHighlight;
    }

    if (selected) {
      background = bgSelected;
      borderColor = borderSelected;
    }

    // ---------------- BORDER ----------------
    final border = BorderSide(color: borderColor, width: 1.3);

    // ---------------- SHADOW (large only) ----------------
    final shadow = isLarge ? CoreShadows.medium : null;

    // ---------------- PADDING (by size) ----------------
    final padding = size == CoreChipSize.small
        ? const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space2, vertical: 2)
        : size == CoreChipSize.medium
            ? const EdgeInsets.symmetric(
                horizontal: CoreSpacing.space3, vertical: 6)
            : const EdgeInsets.symmetric(
                horizontal: CoreSpacing.space3, vertical: CoreSpacing.space3);

    return AnimatedContainer(
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
              color: CoreBorderColors.outlineFocus,
            ),
          ],
          Padding(
            padding: EdgeInsetsDirectional.only(
                start: icon != null ? CoreSpacing.space2 : 0,
                end: CoreSpacing.space2),
            child: Text(label, style: textStyle),
          ),
          const CoreIconWidget(
            icon: CoreIcons.close,
            size: CoreSpacing.space5,
            color: CoreIconColors.grayMid,
          ),
        ],
      ),
    );
  }
}
