import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

enum CoreButtonSize {
  large,
  medium,
  small,
}

enum CoreButtonVariant {
  primary,
  secondary,
}

class CoreButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final CoreButtonSize size;
  final CoreButtonVariant variant;
  final Widget? icon;
  final bool isDisabled;

  const CoreButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.size = CoreButtonSize.medium,
    this.variant = CoreButtonVariant.primary,
    this.icon,
    this.isDisabled = false,
  }) : super(key: key);

  double get _height {
    switch (size) {
      case CoreButtonSize.large:
        return 48;
      case CoreButtonSize.medium:
        return 40;
      case CoreButtonSize.small:
        return 36;
    }
  }

  Color _getBackgroundColor(
      {required bool isEnabled, required bool isPrimary}) {
    if (!isEnabled) return CoreButtonColors.disable;
    if (!isPrimary) return Colors.transparent;
    return CoreButtonColors.surface;
  }

  Color _getBorderColor(bool isEnabled) {
    if (!isEnabled) return CoreButtonColors.disable;
    return CoreButtonColors.surface;
  }

  Color _getContentColor({required bool isEnabled, required bool isPrimary}) {
    if (!isEnabled) return CoreTextColors.body;
    if (isPrimary) return CoreTextColors.inverse;
    return CoreButtonColors.surface;
  }

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == CoreButtonVariant.primary;
    final bool isEnabled = !isDisabled && onPressed != null;

    return SizedBox(
      height: _height,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color:
                _getBackgroundColor(isEnabled: isEnabled, isPrimary: isPrimary),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: _getBorderColor(isEnabled),
              width: 2,
            ),
          ),
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            focusColor: isPrimary ? CoreButtonColors.hover : Colors.transparent,
            hoverColor: isPrimary ? CoreButtonColors.hover : Colors.transparent,
            splashColor:
                isPrimary ? CoreButtonColors.press : Colors.transparent,
            highlightColor:
                isPrimary ? CoreButtonColors.press : Colors.transparent,
            borderRadius: BorderRadius.circular(40),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsetsDirectional.only(end: 8.0),
                      child: icon!,
                    ),
                  Text(
                    label,
                    style: CoreTypography.bodyLargeSemiBold(
                      color: _getContentColor(
                          isEnabled: isEnabled, isPrimary: isPrimary),
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
