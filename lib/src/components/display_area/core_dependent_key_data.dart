import 'package:flutter/foundation.dart';

/// What a dependent-key pill under the [CoreDisplayArea] value does when
/// tapped. The kind picks the trailing icon and the label punctuation.
enum CoreDependentKeyKind {
  /// Opens an editor for the assumption the result was computed with
  /// (`Sheet size: 48in × 94.49in`, `Rate: $12.3/ft²`, `Waste: 10%`,
  /// `Density (concrete): 4,050lbs/yd³`). Trailing edit icon.
  editable,

  /// Cycles or swaps a reading of the value already on screen without
  /// changing it (`Shown as: in/12in` → degrees → grade). Trailing swap icon.
  toggle,

  /// A one-time offer that rewrites the number (`Re-input 38.30° as 38°30′`).
  /// The app removes it once accepted. No trailing icon, and the label is
  /// joined to the value with a space rather than a colon, so it reads as a
  /// sentence.
  offer,
}

/// One pill in [CoreDisplayArea.dependentKeys] — the assumption, reading or
/// offer that an answer on the display depends on.
///
/// A cost result shows a `Rate` and a `Waste` pill at the same time, which is
/// why the display area takes a list rather than a single label/value pair.
@immutable
class CoreDependentKeyData {
  /// Creates a [CoreDependentKeyData].
  const CoreDependentKeyData({
    required this.label,
    required this.value,
    required this.kind,
    this.onPressed,
    this.semanticsLabel,
  });

  /// The descriptive prefix (`Rate`, `Shown as`, `Re-input 38.30° as`).
  ///
  /// For [CoreDependentKeyKind.editable] and [CoreDependentKeyKind.toggle] a
  /// colon is appended unless the label already ends with one; for
  /// [CoreDependentKeyKind.offer] the label is used as written.
  final String label;

  /// The value shown in bold after the label (`$12.3/ft²`, `in/12in`,
  /// `38°30′`).
  final String value;

  /// Which behaviour the pill stands for; picks the trailing icon.
  final CoreDependentKeyKind kind;

  /// Called when the pill is tapped. A `null` callback renders the pill
  /// disabled.
  final VoidCallback? onPressed;

  /// Overrides the label screen readers announce for the pill.
  ///
  /// Defaults to the visible label and value. Pass a localised string when
  /// the visible text does not read well aloud.
  final String? semanticsLabel;
}
