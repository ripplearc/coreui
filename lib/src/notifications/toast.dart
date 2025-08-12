import 'dart:async';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

/// Used to show a toast message to the user.
/// It provides a static interface to easily display a toast message conveniently.
/// It has the following methods:
/// [showError] shows an error toast.
/// [showSuccess] shows a success toast.
/// [showWarning] shows a warning toast.
/// [showCustomToast] shows a custom toast.
/// example:
/// ```dart
/// CoreToast.showError(context, 'An Error Occured');
/// ```
class CoreToast {
  // The entry for the toast.
  static OverlayEntry? _entry;
  // The timer for the toast.
  static Timer? _timer;
  // Set to true to disable timers (useful for testing)
  static bool _disableTimers = false;

  /// Shows an error toast.
  /// Accepts a [context] and an optional [message] as parameters.
  static void showError(BuildContext context, String? message, String closeLabel) {
    showCustomToast(
      context,
      (overlayContext) => Toast.error(
        description: '$message',
        closeLabel: closeLabel,
        onClose: () {
          _entry?.remove();
        },
      ),
    );
  }

  /// Shows a success toast.
  /// Accepts a [context] and an optional [message] as parameters.
  static void showSuccess(BuildContext context, String? message, String closeLabel) {
    showCustomToast(
      context,
      (overlayContext) => Toast.success(
        description: '$message',
        closeLabel: closeLabel,
        onClose: () {
          _entry?.remove();
        },
      ),
    );
  }

  /// Shows a warning toast.
  /// Accepts a [context] and an optional [message] as parameters.
  static void showWarning(BuildContext context, String? message, String closeLabel) {
    showCustomToast(
      context,
      (overlayContext) => Toast.warning(
        description: '$message',
        closeLabel: closeLabel,
        onClose: () {
          _entry?.remove();
        },
      ),
    );
  }

  /// Shows a custom toast.
  /// Accepts a [context], a [toastBuilder], and an optional [duration] as parameters.
  static void showCustomToast(
    BuildContext context,
    Widget Function(BuildContext context) toastBuilder, {
    Duration duration = const Duration(seconds: 3),
  }) {
    // hides keyboard if visible
    FocusScope.of(context).unfocus();
    final overlay = Overlay.of(context);
    // removes previous entry
    if (_entry?.mounted ?? false) {
      _entry?.remove();
    }
    // cancels previous timer
    if (_timer != null) {
      _timer?.cancel();
    }
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Material(child: toastBuilder(context)),
        ),
      ),
    );
    final entryToAdd = _entry;
    if (entryToAdd != null) {
      overlay.insert(entryToAdd);
    }

    // Only create timer if timers are not disabled
    if (!_disableTimers) {
      _timer = Timer(duration, () {
        if (_entry?.mounted ?? false) {
          _entry?.remove();
        }
      });
    }
  }

  /// Cleans up any active toast and timer.
  /// This method should be called when the app is being disposed.
  static void cleanup() {
    _timer?.cancel();
    final entry = _entry;
    if (entry != null && entry.mounted) {
      entry.remove();
    }
  }

  /// Disables timers for testing purposes.
  /// Call this in test setup to avoid timer issues.
  static void disableTimers() {
    _disableTimers = true;
  }

  /// Enables timers (default behavior).
  /// Call this in test teardown to restore normal behavior.
  static void enableTimers() {
    _disableTimers = false;
  }
}
