import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'core_chip_theme.dart';

/// A dropdown-style filter chip used in filter rows.
///
/// Renders as the Figma Filter chip: a 32 dp outlined pill with a label and
/// trailing dropdown arrow, centred in a 48 x 48 dp minimum touch area.
/// When [onTap] is null the chip is rendered in a non-interactive state.
/// Keyboard focus draws the pill border in `outlineFocus` at the chip focus
/// width. Pressed, the pill fills `backgroundGrayMid`.
class CoreFilterChip extends StatefulWidget {
  /// Key of the outlined pill, for widget-test finders.
  static const Key pillKey = Key('core_filter_chip_pill');

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
  State<CoreFilterChip> createState() => _CoreFilterChipState();
}

class _CoreFilterChipState extends State<CoreFilterChip> {
  bool _isFocused = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final isEnabled = widget.onTap != null;
    final pillRadius = BorderRadius.circular(CoreSpacing.space5);
    final borderWidth = CoreChipTheme.borderWidthFor(isFocused: _isFocused);

    return Semantics(
      label: widget.semanticLabel ?? widget.label,
      button: isEnabled,
      enabled: isEnabled,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: widget.onTap,
          onFocusChange: (isFocused) => setState(() => _isFocused = isFocused),
          onHighlightChanged: (isPressed) =>
              setState(() => _isPressed = isPressed),
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(colors.transparent),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: CoreSpacing.space12,
              minWidth: CoreSpacing.space12,
            ),
            child: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: Container(
                key: CoreFilterChip.pillKey,
                // A minimum, so a 200% label grows the pill instead of
                // being cut.
                constraints:
                    const BoxConstraints(minHeight: CoreSpacing.space8),
                padding: EdgeInsets.symmetric(
                  horizontal: CoreSpacing.space3 -
                      (borderWidth - CoreChipTheme.borderWidth),
                ),
                decoration: BoxDecoration(
                  borderRadius: pillRadius,
                  color: _isPressed
                      ? colors.backgroundGrayMid
                      : colors.pageBackground,
                  border: Border.all(
                    color: _isFocused
                        ? colors.outlineFocus
                        : colors.lineDarkOutline,
                    width: borderWidth,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ExcludeSemantics(
                      child: Text(
                        widget.label,
                        style: typography.bodyMediumRegular.copyWith(
                          color: colors.textDark,
                        ),
                      ),
                    ),
                    const SizedBox(width: CoreSpacing.space2),
                    ExcludeSemantics(
                      child: CoreIconWidget(
                        icon: CoreIcons.arrowDropDown,
                        color: colors.textDark,
                        size: CoreIconSize.size24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
