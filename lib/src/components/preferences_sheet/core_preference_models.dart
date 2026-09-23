import 'package:flutter/foundation.dart';

/// How a [CorePreferenceRow] renders the value it currently holds.
///
/// The calculator's preference rows do not all read the same way: most show
/// their value as text, but a couple read as a state the user has switched on
/// or off and are drawn as a dotted pill (Figma `62509:94419`). Keeping the
/// two as variants of one sealed type lets a caller describe either without
/// the sheet growing a flag per row.
sealed class CorePreferenceValue {
  /// Creates a preference value.
  const CorePreferenceValue();
}

/// A value rendered as plain text at the end of the row, such as `1/16`.
class CorePreferenceTextValue extends CorePreferenceValue {
  /// The text to render.
  final String label;

  /// Whether the value is one the app cannot act on yet.
  ///
  /// Muted values read as a quieter grey; the calculator uses this for the
  /// preferences that are still stubs (Appendix C).
  final bool isMuted;

  /// Creates a text value.
  const CorePreferenceTextValue(this.label, {this.isMuted = false});

  @override
  bool operator ==(Object other) =>
      other is CorePreferenceTextValue &&
      other.label == label &&
      other.isMuted == isMuted;

  @override
  int get hashCode => Object.hash(label, isMuted);
}

/// A value rendered as an outlined pill with a leading state dot, such as
/// `● Imperial` or `● Off`.
class CorePreferencePillValue extends CorePreferenceValue {
  /// The text inside the pill.
  final String label;

  /// Whether the pill reads as on — a green dot and outline — or off, which
  /// is grey.
  final bool isOn;

  /// Creates a pill value.
  const CorePreferencePillValue(this.label, {required this.isOn});

  @override
  bool operator ==(Object other) =>
      other is CorePreferencePillValue &&
      other.label == label &&
      other.isOn == isOn;

  @override
  int get hashCode => Object.hash(label, isOn);
}

/// The explanation behind a preference's info button.
///
/// Bundled rather than passed as four loose parameters so a caller cannot
/// configure the button and forget its labels: the info button is
/// interactive, and an interactive element without a semantics label is
/// invisible to a screen reader.
class CorePreferenceInfo {
  /// Heading of the explanation.
  final String title;

  /// Body of the explanation.
  final String description;

  /// Accessibility label for the info button that opens the explanation.
  final String semanticsLabel;

  /// Accessibility label for the explanation's close button.
  final String closeLabel;

  /// Creates a preference explanation.
  const CorePreferenceInfo({
    required this.title,
    required this.description,
    required this.semanticsLabel,
    required this.closeLabel,
  });

  @override
  bool operator ==(Object other) =>
      other is CorePreferenceInfo &&
      other.title == title &&
      other.description == description &&
      other.semanticsLabel == semanticsLabel &&
      other.closeLabel == closeLabel;

  @override
  int get hashCode =>
      Object.hash(title, description, semanticsLabel, closeLabel);
}

/// One choice offered by a [CorePreferenceRow].
class CorePreferenceOption {
  /// Stable identifier reported through the sheet's change callback.
  final String id;

  /// User-facing label rendered on the option row.
  final String label;

  /// Creates a preference option.
  const CorePreferenceOption({required this.id, required this.label});

  @override
  bool operator ==(Object other) =>
      other is CorePreferenceOption && other.id == id && other.label == label;

  @override
  int get hashCode => Object.hash(id, label);
}

/// One settings row: what it is called, what it currently reads, and the
/// choices its sub-sheet offers.
class CorePreferenceRow {
  /// Stable identifier, used both as the target a deep link asks for and as
  /// the key reported on change.
  final String key;

  /// User-facing label at the start of the row.
  final String label;

  /// The value rendered at the end of the row.
  final CorePreferenceValue value;

  /// The choices the option sub-sheet offers. A row with fewer than two
  /// options does not open a sub-sheet.
  final List<CorePreferenceOption> options;

  /// Identifier of the option currently in force, matched against
  /// [CorePreferenceOption.id].
  final String? selectedOptionId;

  /// The explanation behind the sub-sheet's info button, or null for a
  /// preference that needs none.
  final CorePreferenceInfo? info;

  /// Creates a preference row.
  const CorePreferenceRow({
    required this.key,
    required this.label,
    required this.value,
    this.options = const [],
    this.selectedOptionId,
    this.info,
  });

  /// Whether tapping this row opens an option sub-sheet.
  bool get isSelectable => options.length > 1;

  @override
  bool operator ==(Object other) =>
      other is CorePreferenceRow &&
      other.key == key &&
      other.label == label &&
      other.value == value &&
      listEquals(other.options, options) &&
      other.selectedOptionId == selectedOptionId &&
      other.info == info;

  @override
  int get hashCode => Object.hash(
        key,
        label,
        value,
        Object.hashAll(options),
        selectedOptionId,
        info,
      );
}

/// A titled group of rows. A section with a null [title] renders its rows
/// without a heading, as the lone `System of units` row does.
class CorePreferenceSection {
  /// Heading above the group, or null for an untitled group.
  final String? title;

  /// The rows in this group.
  final List<CorePreferenceRow> rows;

  /// Creates a preference section.
  const CorePreferenceSection({required this.rows, this.title});

  @override
  bool operator ==(Object other) =>
      other is CorePreferenceSection &&
      other.title == title &&
      listEquals(other.rows, rows);

  @override
  int get hashCode => Object.hash(title, Object.hashAll(rows));
}
