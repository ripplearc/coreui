import 'package:flutter/widgets.dart';

/// The scroll anchors a preferences sheet holds, one per row.
///
/// A deep link scrolls to a row by its anchor, and only a row that has been
/// built has one, so the sheet builds its list whole rather than lazily. The
/// registry follows the rows the caller supplies: [prune] drops the anchors
/// of rows that are no longer there, which a plain map would keep alive for
/// as long as the sheet is open.
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceAnchors {
  final Map<String, GlobalKey> _anchors = {};

  /// The anchor for [key], created on first ask.
  GlobalKey operator [](String key) =>
      _anchors.putIfAbsent(key, GlobalKey.new);

  /// How many rows are currently tracked.
  int get length => _anchors.length;

  /// The build context of [key]'s row, or null when it has not been built.
  BuildContext? contextOf(String key) => _anchors[key]?.currentContext;

  /// Forgets every anchor whose key is not in [live].
  void prune(Set<String> live) {
    _anchors.removeWhere((key, _) => !live.contains(key));
  }
}
