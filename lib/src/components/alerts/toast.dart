import 'package:flutter/material.dart';

import '../../theme/color_tokens.dart';
import '../../theme/icons/core_icons.dart';
import '../../theme/icons/icon_data.dart';
import '../../theme/shadows.dart';
import '../../theme/spacing.dart';
import '../../theme/typography_extension.dart';
import '../core_icon.dart';

class Toast extends StatelessWidget {
  final String? title;
  final String description;
  final CoreIconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onClose;
  final String closeLabel;

  const Toast._({
    required this.description,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.closeLabel,
    this.title,
    this.onClose,
  });

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
      icon: CoreIcons.error,
      backgroundColor: CoreAlertColors.red,
      iconColor: CoreIconColors.red,
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
      icon: CoreIcons.warning,
      backgroundColor: CoreAlertColors.orange,
      iconColor: CoreIconColors.orange,
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
      icon: CoreIcons.info,
      backgroundColor: CoreAlertColors.blue,
      iconColor: CoreIconColors.blue,
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
      icon: CoreIcons.success,
      backgroundColor: CoreAlertColors.green,
      iconColor: CoreIconColors.green,
      onClose: onClose,
    );
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).extension<TypographyExtension>();

    return Semantics(
      container: true,
      button: onClose != null,
      label: title ?? description,
      hint: title != null ? description : null,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space4, vertical: CoreSpacing.space3),
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
              icon: icon,
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
                    style: typography?.bodyLargeMedium.copyWith(
                      color: CoreTextColors.dark,
                    ),
                  ),
                  if (title != null)
                    Padding(
                      padding: const EdgeInsets.only(top: CoreSpacing.space1),
                      child: Text(
                        description,
                        style: typography?.bodySmallRegular.copyWith(
                          color: CoreTextColors.body,
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      closeLabel,
                      style: typography?.bodyMediumSemiBold.copyWith(
                        color: CoreTextColors.link,
                      ),
                    ),
                    const SizedBox(width: CoreSpacing.space2),
                    const CoreIconWidget(
                      icon: CoreIcons.close,
                      size: 24,
                      color: CoreIconColors.dark,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
