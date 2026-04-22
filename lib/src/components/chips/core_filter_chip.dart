import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A dropdown-style filter chip used in filter rows.
///
/// Renders as a filled pill with a label and trailing dropdown arrow.
/// When [onTap] is null the chip is rendered in a non-interactive state.
class CoreFilterChip extends StatelessWidget {
  const CoreFilterChip({
    super.key,
    required this.label,
    this.onTap,
  });

  /// The text label displayed inside the chip.
  final String label;

  /// Called when the chip is tapped. If null, the chip is non-interactive.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final isEnabled = onTap != null;

    return Semantics(
      label: label,
      button: isEnabled,
      enabled: isEnabled,
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: CoreSpacing.space12,
            minWidth: CoreSpacing.space12,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: CoreSpacing.space4,
              vertical: CoreSpacing.space2,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(CoreSpacing.space3),
              color: colors.backgroundGrayMid,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ExcludeSemantics(
                  child: Text(
                    label,
                    style: typography.bodyMediumRegular.copyWith(
                      color: colors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: CoreSpacing.space2),
                ExcludeSemantics(
                  child: CoreIconWidget(
                    icon: CoreIcons.arrowDropDown,
                    color: colors.iconDark,
                    size: CoreSpacing.space4,
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
