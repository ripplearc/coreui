import 'dart:async';

import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class CoreToast {
  static OverlayEntry? _entry;
  static Timer? _timer;
  
  /// Set to true to disable timers (useful for testing)
  static bool _disableTimers = false;

  /// Shows an error toast.
  /// Accepts a context and an optional message as parameters.
  static void showError(BuildContext context, String? message) {
    showCustomToast(
      context,
      (overlayContext) => Toast.error(
        description: message ?? 'An Error Occured',
        closeLabel: 'Close',
        onClose: () {
          _entry?.remove();
        },
      ),
    );
  }

  /// Shows a success toast.
  /// Accepts a context and an optional message as parameters.
  static void showSuccess(BuildContext context, String? message) {
    showCustomToast(
      context,
      (overlayContext) => Toast.success(
        description: message ?? 'Request Successful',
        closeLabel: 'Close',
        onClose: () {
          _entry?.remove();
        },
      ),
    );
  }

  /// Shows a warning toast.
  /// Accepts a context and an optional message as parameters.
  static void showWarning(BuildContext context, String? message) {
    showCustomToast(
      context,
      (overlayContext) => Toast.warning(
        description: message ?? 'Warning',
        closeLabel: 'Close',
        onClose: () {
          _entry?.remove();
        },
      ),
    );
  }

  /// Shows a custom toast.
  /// Accepts a context, a toast builder, and an optional duration as parameters.
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
