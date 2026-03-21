import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'core_calculator_chip_theme.dart';

enum CoreCalculatorChipType {
  editable,
  disabled,
  active,
}

class CoreCalculatorChip extends StatelessWidget {
  const CoreCalculatorChip({
    super.key,
    required this.type,
    required this.value,
    this.onTap,
    this.label,
    this.withCloseIcon = false,
    this.onClose,
  }) : assert(
          !(type == CoreCalculatorChipType.disabled && label == null),
          'Label must not be null when type is disabled',
        );

  final CoreCalculatorChipType type;
  final String? label;
  final String value;
  final bool withCloseIcon;
  final VoidCallback? onClose;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final semanticsLabel = label != null ? '$label, $value' : value;

    return Semantics(
      label: semanticsLabel,
      button: true,
      container: true,
      enabled: type != CoreCalculatorChipType.disabled,
      child: Material(
        color: colors.transparent,
        child: InkWell(
          onTap: type != CoreCalculatorChipType.disabled ? onTap : null,
          splashFactory: NoSplash.splashFactory,
          overlayColor: WidgetStateProperty.all(
            colors.transparent,
          ),
          borderRadius: CoreCalculatorChipTheme.borderRadius,
          child: Container(
            padding: CoreCalculatorChipTheme.padding,
            decoration: BoxDecoration(
              color: CoreCalculatorChipTheme.background(
                type: type,
                colors: colors,
              ),
              borderRadius: CoreCalculatorChipTheme.borderRadius,
              boxShadow: CoreCalculatorChipTheme.shadow(type),
              border: Border.fromBorderSide(
                BorderSide(
                    color: CoreCalculatorChipTheme.borderColor(
                      type: type,
                      colors: colors,
                    ),
                    width: CoreCalculatorChipTheme.borderWidth),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (withCloseIcon && type != CoreCalculatorChipType.disabled)
                  Semantics(
                    button: true,
                    label: 'Close $semanticsLabel',
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onClose,
                      child: Center(
                        child: CoreIconWidget(
                          icon: CoreIcons.cross,
                          size: CoreSpacing.space5,
                          color: CoreCalculatorChipTheme.iconColor(
                            type: type,
                            colors: colors,
                          ),
                        ),
                      ),
                    ),
                  ),
                if (label != null)
                  ExcludeSemantics(
                    child: Text(
                      label,
                      style: CoreCalculatorChipTheme.labelStyle(
                        type: type,
                        colors: colors,
                        typography: typography,
                      ),
                    ),
                  ),
                const SizedBox(width: CoreSpacing.space1),
                ExcludeSemantics(
                  child: Text(
                    value,
                    style: CoreCalculatorChipTheme.valueStyle(
                      type: type,
                      colors: colors,
                      typography: typography,
                    ),
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
