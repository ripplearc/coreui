import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

/// A modal that shows a success message and a button to continue.
///
/// [message] is the message to show.
/// [isDismissible] is whether the modal is dismissible.
/// [enableDrag] is whether the modal can be dragged.
/// [onPressed] is the callback to call when the button is pressed.
/// [buttonLabel] is the label of the button.
/// [assetPath] is the path to the asset to show.
///
/// Example:
/// ```dart
/// SuccessModal.show(
///   context,
///   message: 'Operation Successful',
///   onPressed: () {
///     Navigator.pop(context);
///   },
/// );
class SuccessModal {
  static void show(
    BuildContext context, {
    String? message,
    bool isDismissible = false,
    bool enableDrag = false,
    required VoidCallback onPressed,
    String? buttonLabel,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/success.png', width: 90, height: 90),
              const SizedBox(height: 16),
              Text(
                '$message',
                textAlign: TextAlign.center,
                style: CoreTypography.titleLargeMedium(),
              ),
              const SizedBox(height: 24),
              CoreButton(
                onPressed: onPressed,
                label: '$buttonLabel',
                centerAlign: true,
              ),
            ],
          ),
        );
      },
    );
  }
}
