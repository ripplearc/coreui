import 'package:flutter/material.dart';

import '../../../core_ui.dart';

class Toast extends StatelessWidget {
  final String title;
  final String? description;

  final CoreIconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback? onClose;

  const Toast._({
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.onClose,
    this.description,
  });

  factory Toast.error({
    required String title,
    String? description,
    VoidCallback? onClose,
  }) {
    return Toast._(
      title: title,
      icon: CoreIcons.error,
      backgroundColor: CoreAlertColors.red,
      iconColor: CoreIconColors.red,
      onClose: onClose,
      description: description,
    );
  }

  factory Toast.warning({
    required String title,
    String? description,
    VoidCallback? onClose,
  }) {
    return Toast._(
      title: title,
      icon: CoreIcons.warning,
      backgroundColor: CoreAlertColors.orange,
      iconColor: CoreIconColors.orange,
      onClose: onClose,
      description: description,
    );
  }

  factory Toast.info({
    required String title,
    String? description,
    VoidCallback? onClose,
  }) {
    return Toast._(
      title: title,
      icon: CoreIcons.info,
      backgroundColor: CoreAlertColors.blue,
      iconColor: CoreIconColors.blue,
      onClose: onClose,
      description: description,
    );
  }

  factory Toast.success({
    required String title,
    String? description,
    VoidCallback? onClose,
  }) {
    return Toast._(
      title: title,
      icon: CoreIcons.success,
      backgroundColor: CoreAlertColors.green,
      iconColor: CoreIconColors.green,
      onClose: onClose,
      description: description,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: CoreShadows.medium,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CoreIconWidget(
            icon: icon,
            size: 24,
            color: iconColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: CoreTypography.bodyLargeMedium(
                      color: CoreTextColors.dark),
                ),
                if (description != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      description!,
                      style: CoreTypography.bodySmallRegular(
                          color: CoreTextColors.body),
                    ),
                  ),
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 12),
            GestureDetector(
              key: const Key('toast_close_button'),
              onTap: onClose,
              child: const CoreIconWidget(
                icon: CoreIcons.close,
                size: 24,
                color: CoreIconColors.dark,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
