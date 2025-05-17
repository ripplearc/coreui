import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

enum SwitchVariant {
  basic,
  lockUnlock,
  showHide,
  privatePublic,
}

class CustomSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final SwitchVariant variant;
  final Color? activeColor;
  final Color? inactiveColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeTextColor;
  final Color? inactiveTextColor;
  final Color? inactiveTrackOutlineColor;

  const CustomSwitch(
      {Key? key,
      required this.value,
      required this.onChanged,
      this.variant = SwitchVariant.basic,
      this.activeColor,
      this.inactiveColor,
      this.activeTrackColor,
      this.inactiveTrackColor,
      this.activeTextColor,
      this.inactiveTextColor,
      this.inactiveTrackOutlineColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultActiveColor = activeColor ?? CoreIconColors.white;
    final defaultInactiveColor =
        inactiveColor ?? CoreBorderColors.lineDarkOutline;
    final defaultActiveTrackColor = activeTrackColor ?? CoreButtonColors.hover;
    final defaultInactiveTrackColor =
        inactiveTrackColor ?? CoreBackgroundColors.backgroundGrayLight;
    final defaultTextColor = activeTextColor ?? Colors.white;

    Widget switchWidget;

    switch (variant) {
      case SwitchVariant.basic:
        switchWidget = Switch(
          value: value,
          onChanged: onChanged,
          activeColor: activeColor,
          inactiveThumbColor: defaultInactiveColor,
          activeTrackColor: defaultActiveTrackColor,
          inactiveTrackColor: defaultInactiveTrackColor,
          trackOutlineColor: WidgetStatePropertyAll(
              value ? defaultActiveTrackColor : CoreIconColors.grayDark),
          trackOutlineWidth: WidgetStatePropertyAll(1),
        );
        break;

      case SwitchVariant.lockUnlock:
        final String activeText = _getActiveText(variant);
        final String inactiveText = _getInactiveText(variant);

        switchWidget = Container(
          height: 40,
          width: 100,
          padding: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  value ? defaultActiveTrackColor : defaultInactiveTrackColor,
              border: Border.all(
                  width: 1,
                  color: value ? defaultInactiveColor : CoreIconColors.red)),
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (value) ...[
                  _buildText(inactiveText, value, defaultTextColor),
                  const SizedBox(width: 8),
                  _buildThumb(value, defaultActiveColor, defaultInactiveColor,
                      isRed: true),
                ] else ...[
                  _buildThumb(value, defaultActiveColor, defaultInactiveColor),
                  const SizedBox(width: 8),
                  _buildText(activeText, value, defaultTextColor),
                ],
              ],
            ),
          ),
        );
        break;
      case SwitchVariant.showHide:
      case SwitchVariant.privatePublic:
        final String activeText = _getActiveText(variant);
        final String inactiveText = _getInactiveText(variant);

        switchWidget = Container(
          height: 40,
          width: 100,
          padding: EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color:
                  value ? defaultActiveTrackColor : defaultInactiveTrackColor,
              border: Border.all(
                  width: 1,
                  color:
                      value ? defaultInactiveColor : CoreIconColors.grayDark)),
          child: GestureDetector(
            onTap: () => onChanged(!value),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (value) ...[
                  _buildText(inactiveText, value, defaultTextColor),
                  const SizedBox(width: 8),
                  _buildThumb(value, defaultActiveColor, defaultInactiveColor),
                ] else ...[
                  _buildThumb(value, defaultActiveColor, defaultInactiveColor),
                  const SizedBox(width: 8),
                  _buildText(activeText, value, defaultTextColor),
                ],
              ],
            ),
          ),
        );
        break;
    }

    return switchWidget;
  }

  String _getActiveText(SwitchVariant variant) {
    switch (variant) {
      case SwitchVariant.lockUnlock:
        return 'Lock';
      case SwitchVariant.showHide:
        return 'Show';
      case SwitchVariant.privatePublic:
        return 'Public';
      default:
        return '';
    }
  }

  String _getInactiveText(SwitchVariant variant) {
    switch (variant) {
      case SwitchVariant.lockUnlock:
        return 'Unlock';
      case SwitchVariant.showHide:
        return 'Hide';
      case SwitchVariant.privatePublic:
        return 'Private';
      default:
        return '';
    }
  }

  Widget _buildThumb(bool value, Color activeColor, Color inactiveColor,
      {isRed = false}) {
    final double thumbLength = value ? 28 : 24;
    return Container(
      width: thumbLength,
      height: thumbLength,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isRed
            ? CoreStatusColors.error
            : value
                ? activeColor
                : inactiveColor,
      ),
    );
  }

  Widget _buildText(String text, bool value, Color textColor) {
    return Text(
      text,
      style: CoreTypography.bodyLargeRegular(
          color: value ? CoreTextColors.inverse : CoreTextColors.body),
    );
  }
}
