import 'package:flutter/material.dart';

import '../../theme/app_typography_extension.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/icons/icon_data.dart';
import '../../theme/shadows.dart';
import '../../theme/spacing.dart';
import '../../theme/theme_extensions.dart';
import '../core_icon.dart';

/// Defines the type of toast notification and its visual styling.
/// - [error]: Error toast with red background and icon for critical issues.
/// - [warning]: Warning toast with orange background and icon for cautionary messages.
/// - [info]: Information toast with blue background and icon for general notifications.
/// - [success]: Success toast with green background and icon for positive confirmations.
enum _ToastType { error, warning, info, success }

/// A notification widget that displays temporary messages to users with different visual styles.
///
/// The Toast component supports four distinct types:
/// - Error: Red styling for critical issues
/// - Warning: Orange styling for cautionary messages
/// - Info: Blue styling for general notifications
/// - Success: Green styling for positive confirmations
///
/// ## Basic Usage
///
/// ```dart
/// // Error toast
/// Toast.error(
///   description: 'An error occurred',
///   closeLabel: 'Close',
/// )
/// ```
///
/// ## Toast with Title
///
/// ```dart
/// // Success toast with title
/// Toast.success(
///   title: 'Operation Complete',
///   description: 'Your changes have been saved successfully.',
///   closeLabel: 'Dismiss',
/// )
/// ```
///
/// ## Toast with Close Callback
///
/// ```dart
/// // Warning toast with custom close handler
/// Toast.warning(
///   description: 'Please review your settings',
///   closeLabel: 'Close',
///   onClose: () {
///     // Handle close action
///   },
/// )
/// ```
///
/// [title] is the optional title text displayed above the description.
/// [description] is the main message to be displayed in the toast.
/// [closeLabel] is the text label for the close button.
/// [onClose] is the optional callback function triggered when the close button is pressed.
class Toast extends StatelessWidget {
  final String? title;
  final String description;
  final VoidCallback? onClose;
  final String closeLabel;
  final _ToastType _type;

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

  CoreIconData get _icon {
    switch (_type) {
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
    switch (_type) {
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
    switch (_type) {
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
    final backgroundColor = _getBackgroundColor(colors);
    final iconColor = _getIconColor(colors);

    return Semantics(
      container: true,
      button: onClose != null,
      label: title ?? description,
      hint: title != null ? description : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: CoreSpacing.space4,
          vertical: CoreSpacing.space3,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: CoreShadows.medium,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CoreIconWidget(
              icon: _icon,
              size: 24,
              color: iconColor,
            ),
            const SizedBox(width: CoreSpacing.space3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title ?? description,
                    style: typography.bodyLargeMedium.copyWith(
                      color: colors.textDark,
                    ),
                  ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(top: CoreSpacing.space1),
                      child: Text(
                        description,
                        style: typography.bodySmallRegular.copyWith(
                          color: colors.textBody,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: CoreSpacing.space3),
            GestureDetector(
              key: const Key('toast_close_button'),
              onTap: onClose ?? () => Navigator.of(context).pop(),
              child: Semantics(
                button: true,
                label: closeLabel,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          closeLabel,
                          style: typography.bodyMediumSemiBold.copyWith(
                            color: colors.textLink,
                          ),
                        ),
                        const SizedBox(width: CoreSpacing.space2),
                        CoreIconWidget(
                          icon: CoreIcons.close,
                          size: 24,
                          color: colors.iconDark,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
