import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Used to show a toast message to the user.
/// It provides a static interface to easily display a toast message conveniently.
/// It has the following methods:
/// [showError] shows an error toast.
/// [showSuccess] shows a success toast.
/// [showWarning] shows a warning toast.
/// [showReceipt] shows the receipt toast with its own action.
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

  /// Shows the receipt toast that confirms something was banked and offers
  /// the action that takes it back.
  ///
  /// The toast owns its own dismissal, so [duration] is handed to the widget
  /// rather than to the overlay: a second timer here could only disagree with
  /// it. Answering the toast dismisses it through the same path the timer
  /// takes, so it is removed exactly once either way.
  ///
  /// A `null` [duration] — or an active screen reader, or [disableTimers] —
  /// leaves the receipt up with no timer of its own. The caller holds no
  /// handle to it, so three things remove it after that: the user takes the
  /// action, another toast replaces it, or [cleanup] runs.
  ///
  /// [context] must be mounted and must sit under an [Overlay]; otherwise
  /// this throws a [FlutterError] before anything changes, so a toast that is
  /// already on screen is not disturbed.
  static void showReceipt(
    BuildContext context,
    String message,
    String actionLabel,
    VoidCallback onAction, {
    String? highlight,
    Duration? duration = const Duration(seconds: 5),
  }) {
    final widgetDuration = _disableTimers ? null : duration;
    _showWithDismiss(
      context,
      (dismiss) => Toast.receipt(
        description: message,
        highlight: highlight,
        actionLabel: actionLabel,
        onAction: onAction,
        onClose: dismiss,
        duration: widgetDuration,
      ),
      duration: null,
    );
  }

  /// Shows a custom toast.
  /// Accepts a [context], a [toastBuilder], and an optional [duration] as parameters.
  /// A `null` [duration] leaves the entry on screen: the toast itself owns the
  /// dismissal, as [Toast.receipt] does, and a second timer here could only
  /// disagree with it.
  static void showCustomToast(
    BuildContext context,
    Widget Function(BuildContext context) toastBuilder, {
    Duration? duration = const Duration(seconds: 3),
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
    if (!_disableTimers && duration != null) {
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
    Widget Function(VoidCallback dismiss) build, {
    Duration? duration = const Duration(seconds: 3),
  }) {
    showCustomToast(
      context,
      (overlayContext) {
        final ownEntry = _entry;
        return build(() => _removeEntryOnce(ownEntry));
      },
      duration: duration,
    );
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
