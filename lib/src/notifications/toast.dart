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
    showCustomToast(
      context,
      (overlayContext) {
        final entry = _entry;
        return Toast.error(
          description: message,
          closeLabel: closeLabel,
          title: title,
          onClose: () => _removeEntry(entry),
        );
      },
    );
  }

  /// Shows a success toast.
  static void showSuccess(
    BuildContext context,
    String message,
    String closeLabel, {
    String? title,
  }) {
    showCustomToast(
      context,
      (overlayContext) {
        final entry = _entry;
        return Toast.success(
          description: message,
          closeLabel: closeLabel,
          title: title,
          onClose: () => _removeEntry(entry),
        );
      },
    );
  }

  /// Shows a warning toast.
  static void showWarning(
    BuildContext context,
    String message,
    String closeLabel, {
    String? title,
  }) {
    showCustomToast(
      context,
      (overlayContext) {
        final entry = _entry;
        return Toast.warning(
          description: message,
          closeLabel: closeLabel,
          title: title,
          onClose: () => _removeEntry(entry),
        );
      },
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
  /// A `null` [duration] leaves the receipt up until the caller removes it,
  /// and [disableTimers] holds it up the same way it holds up every other
  /// toast.
  static void showReceipt(
    BuildContext context,
    String message,
    String actionLabel,
    VoidCallback onAction, {
    String? highlight,
    String? secondaryLabel,
    VoidCallback? onSecondary,
    Duration? duration = const Duration(seconds: 5),
  }) {
    showCustomToast(
      context,
      (overlayContext) {
        // This toast's own entry: once superseded, removing it is not its
        // business any more.
        final entry = _entry;
        return Toast.receipt(
          description: message,
          highlight: highlight,
          actionLabel: actionLabel,
          onAction: onAction,
          secondaryLabel: secondaryLabel,
          onSecondary: onSecondary,
          onClose: () => _removeEntry(entry),
          duration: _disableTimers ? null : duration,
        );
      },
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
    // an entry inserted in this same frame has not mounted yet, and skipping
    // it would orphan it in the overlay
    _removeEntry(_entry);
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
    if (!_disableTimers && duration != null) {
      final entry = _entry;
      _timer = Timer(duration, () => _removeEntry(entry));
    }
  }

  /// Cleans up any active toast and timer.
  /// This method should be called when the app is being disposed.
  static void cleanup() {
    _timer?.cancel();
    _removeEntry(_entry);
  }

  // Nulling _entry first makes removal idempotent: an OverlayEntry may only
  // be removed once, and several callers race for the same one.
  static void _removeEntry(OverlayEntry? entry) {
    if (entry == null || !identical(entry, _entry)) return;
    _entry = null;
    entry.remove();
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
