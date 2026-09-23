import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

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
  static void showError(
    BuildContext context,
    String message,
    String closeLabel, {
    String? title,
  }) {
    _showWithDismiss(
      context,
      (dismiss) => Toast.error(
        description: message,
        closeLabel: closeLabel,
        title: title,
        onClose: dismiss,
      ),
    );
  }

  /// Shows a success toast.
  static void showSuccess(
    BuildContext context,
    String message,
    String closeLabel, {
    String? title,
  }) {
    _showWithDismiss(
      context,
      (dismiss) => Toast.success(
        description: message,
        closeLabel: closeLabel,
        title: title,
        onClose: dismiss,
      ),
    );
  }

  /// Shows a warning toast.
  static void showWarning(
    BuildContext context,
    String message,
    String closeLabel, {
    String? title,
  }) {
    _showWithDismiss(
      context,
      (dismiss) => Toast.warning(
        description: message,
        closeLabel: closeLabel,
        title: title,
        onClose: dismiss,
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
    _removeEntryOnce(_entry);
    // cancels previous timer
    if (_timer != null) {
      _timer?.cancel();
    }
    final ownEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 100,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Material(child: toastBuilder(context)),
        ),
      ),
    );
    _entry = ownEntry;
    overlay.insert(ownEntry);

    // Only create timer if timers are not disabled
    if (!_disableTimers) {
      _timer = Timer(duration, () => _removeEntryOnce(ownEntry));
    }
  }

  /// Cleans up any active toast and timer.
  /// This method should be called when the app is being disposed.
  static void cleanup() {
    _timer?.cancel();
    _removeEntryOnce(_entry);
  }

  static void _showWithDismiss(
    BuildContext context,
    Widget Function(VoidCallback dismiss) build,
  ) {
    showCustomToast(context, (overlayContext) {
      final ownEntry = _entry;
      return build(() => _removeEntryOnce(ownEntry));
    });
  }

  static void _removeEntryOnce(OverlayEntry? entry) {
    if (entry == null || !identical(entry, _entry)) return;
    _entry = null;
    entry.remove();
    entry.dispose();
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
