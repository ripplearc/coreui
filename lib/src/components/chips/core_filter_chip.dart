import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A dropdown-style filter chip used in filter rows.
///
/// Renders as the Figma Filter chip: a 32 dp outlined pill with a label and
/// trailing dropdown arrow, centred in a 48 x 48 dp minimum touch area.
/// When [onTap] is null the chip is rendered in a non-interactive state.
class CoreFilterChip extends StatelessWidget {
  const CoreFilterChip({
    super.key,
    required this.label,
    this.onTap,
    this.semanticLabel,
  });

  /// The text label displayed inside the chip.
  final String label;

  /// Called when the chip is tapped. If null, the chip is non-interactive.
  final VoidCallback? onTap;

  /// Accessibility label for the chip. Defaults to [label].
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final isEnabled = onTap != null;
    final pillRadius = BorderRadius.circular(CoreSpacing.space5);

    return Semantics(
      label: semanticLabel ?? label,
      button: isEnabled,
      enabled: isEnabled,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(colors.transparent),
        borderRadius: pillRadius,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: CoreSpacing.space12,
            minWidth: CoreSpacing.space12,
          ),
          child: Center(
            widthFactor: 1,
            heightFactor: 1,
            child: Container(
              height: CoreSpacing.space8,
              padding: const EdgeInsets.symmetric(
                horizontal: CoreSpacing.space3,
              ),
              decoration: BoxDecoration(
                borderRadius: pillRadius,
                color: colors.pageBackground,
                border: Border.all(color: colors.lineDarkOutline),
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
      ),
    );
  }
}
