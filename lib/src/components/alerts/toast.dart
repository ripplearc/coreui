import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/icon_sizes.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/icons/icon_data.dart';
import '../../theme/shadows.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../core_icon.dart';

/// Defines the type of toast notification and its visual styling.
enum _ToastType {
  /// Error toast with red background and icon for critical issues.
  error,

  /// Warning toast with orange background and icon for cautionary messages.
  warning,

  /// Information toast with blue background and icon for general notifications.
  info,

  /// Success toast with green background and icon for positive confirmations.
  success,
}

/// A notification widget that displays temporary messages to users.
///
/// Use [Toast.error], [Toast.warning], [Toast.info], or [Toast.success]
/// factory constructors to create a toast with the appropriate visual style.
class Toast extends StatefulWidget {
  final String? title;
  final String description;
  final VoidCallback? onClose;
  final String closeLabel;
  final _ToastType _type;

  static const double _radius = CoreSpacing.space2;

  const Toast._({
    required this.description,
    required this.closeLabel,
    required _ToastType type,
    this.title,
    this.onClose,
  }) : _type = type;

  factory Toast.error({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.error,
      onClose: onClose,
    );
  }

  factory Toast.warning({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.warning,
      onClose: onClose,
    );
  }

  factory Toast.info({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.info,
      onClose: onClose,
    );
  }

  factory Toast.success({
    required String description,
    required String closeLabel,
    String? title,
    VoidCallback? onClose,
  }) {
    return Toast._(
      description: description,
      title: title,
      closeLabel: closeLabel,
      type: _ToastType.success,
      onClose: onClose,
    );
  }

  @override
  State<Toast> createState() => _ToastState();
}

class _ToastState extends State<Toast> {
  CoreIconData get _icon {
    switch (widget._type) {
      case _ToastType.error:
        return CoreIcons.error;
      case _ToastType.warning:
        return CoreIcons.warning;
      case _ToastType.info:
        return CoreIcons.info;
      case _ToastType.success:
        return CoreIcons.success;
    }
  }

  Color _getBackgroundColor(AppColorsExtension colors) {
    switch (widget._type) {
      case _ToastType.error:
        return colors.alertRed;
      case _ToastType.warning:
        return colors.alertOrange;
      case _ToastType.info:
        return colors.alertBlue;
      case _ToastType.success:
        return colors.alertGreen;
    }
  }

  Color _getIconColor(AppColorsExtension colors) {
    switch (widget._type) {
      case _ToastType.error:
        return colors.iconRed;
      case _ToastType.warning:
        return colors.iconOrange;
      case _ToastType.info:
        return colors.iconBlue;
      case _ToastType.success:
        return colors.iconGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;
    final colors = Theme.of(context).coreColors;

    return Semantics(
      container: true,
      button: widget.onClose != null,
      label: widget.title ?? widget.description,
      hint: widget.title != null ? widget.description : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: CoreSpacing.space4,
          vertical: CoreSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: _getBackgroundColor(colors),
          borderRadius: BorderRadius.circular(Toast._radius),
          boxShadow: CoreShadows.medium,
        ),
        child: _buildRow(
          colors,
          text: _buildStackedText(typography, colors),
          trailing: _buildCloseButton(typography, colors),
        ),
      ),
    );
  }

  Widget _buildRow(
    AppColorsExtension colors, {
    required Widget text,
    required Widget trailing,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CoreIconWidget(
          icon: _icon,
          size: CoreIconSize.size24,
          color: _getIconColor(colors),
        ),
        const SizedBox(width: CoreSpacing.space3),
        Expanded(child: text),
        const SizedBox(width: CoreSpacing.space3),
        trailing,
      ],
    );
  }

  Widget _buildStackedText(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title ?? widget.description,
          style: typography.bodyLargeMedium.copyWith(
            color: colors.textDark,
          ),
        ),
        if (widget.title != null)
          Padding(
            padding: const EdgeInsets.only(top: CoreSpacing.space1),
            child: Text(
              widget.description,
              style: typography.bodySmallRegular.copyWith(
                color: colors.textBody,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCloseButton(
    AppTypographyExtension typography,
    AppColorsExtension colors,
  ) {
    return GestureDetector(
      key: const Key('toast_close_button'),
      onTap: widget.onClose ?? () => Navigator.of(context).pop(),
      child: Semantics(
        button: true,
        label: widget.closeLabel,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: CoreSpacing.space12,
            minHeight: CoreSpacing.space12,
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.closeLabel,
                  style: typography.bodyMediumSemiBold.copyWith(
                    color: colors.textLink,
                  ),
                ),
                const SizedBox(width: CoreSpacing.space2),
                CoreIconWidget(
                  icon: CoreIcons.close,
                  size: CoreIconSize.size24,
                  color: colors.iconDark,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
