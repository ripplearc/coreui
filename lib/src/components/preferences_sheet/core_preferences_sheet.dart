import 'dart:async';

import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'preference_anchors.dart';
import 'preference_section_view.dart';
import 'preference_sheet_title.dart';

/// A modal bottom sheet body listing settings grouped into sections, each row
/// showing what it currently reads and opening a single-choice sub-sheet.
///
/// The sheet owns no persistent state. It reports a choice through
/// [onChanged] and leaves the caller to supply [sections] again with the new
/// value, so the stored preference stays the single source of truth.
///
/// Passing [initialKey] deep-links to one row: the sheet scrolls it into view
/// before the user sees the list and marks it briefly, for the calculator's
/// path from a rendered value to the preference that formats it — tapping the
/// fraction in `3-5/16in` lands on Fractional resolution.
///
/// Present it with `CoreQuickSheet.show(context: context, child: ...)`.
class CorePreferencesSheet extends StatefulWidget {
  /// Title shown at the top of the sheet.
  final String title;

  /// The settings, in display order.
  final List<CorePreferenceSection> sections;

  /// Called with the row's key and the chosen option id once the user commits
  /// a choice in the sub-sheet.
  final void Function(String key, String optionId) onChanged;

  /// Key of the row to deep-link to, matched against [CorePreferenceRow.key].
  /// An unknown key simply opens the list at the top.
  final String? initialKey;

  /// Label of the sub-sheet's commit button.
  final String optionUpdateLabel;

  /// Accessibility label for the sub-sheet's back button.
  final String optionBackSemanticsLabel;

  /// Builds the key for the row with the given preference key.
  final Key Function(String key)? rowKeyOf;

  /// Builds the key for the sub-sheet's row for the option with the given id.
  final Key Function(String id)? optionKeyOf;

  /// Key applied to the sub-sheet's Update button.
  ///
  /// Forwarded so a consumer can drive a whole change end-to-end — open a row,
  /// pick an option, commit — without reaching for the option labels by text.
  final Key? optionUpdateButtonKey;

  /// How long a deep-linked row stays marked before fading back.
  static const Duration emphasisDuration = Duration(milliseconds: 1600);

  /// Creates a preferences sheet body.
  const CorePreferencesSheet({
    super.key,
    required this.title,
    required this.sections,
    required this.onChanged,
    required this.optionUpdateLabel,
    required this.optionBackSemanticsLabel,
    this.initialKey,
    this.rowKeyOf,
    this.optionKeyOf,
    this.optionUpdateButtonKey,
  });

  @override
  State<CorePreferencesSheet> createState() => _CorePreferencesSheetState();
}

class _CorePreferencesSheetState extends State<CorePreferencesSheet> {
  final PreferenceAnchors _rowAnchors = PreferenceAnchors();
  String? _emphasisKey;
  Timer? _emphasisTimer;

  @override
  void initState() {
    super.initState();
    final initialKey = widget.initialKey;
    if (initialKey != null) {
      _emphasisKey = initialKey;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _revealDeepLink(initialKey);
      });
    }
  }

  @override
  void dispose() {
    _emphasisTimer?.cancel();
    super.dispose();
  }

  // Brings the deep-linked row into view and lets its mark fade once the
  // user has had a moment to see where they landed.
  Future<void> _revealDeepLink(String key) async {
    final anchor = _rowAnchors.contextOf(key);
    if (anchor != null) {
      await Scrollable.ensureVisible(
        anchor,
        alignment: 0.5,
        duration: CorePreferencesSheet.emphasisDuration ~/ 8,
      );
    }
    // ensureVisible is awaited, so the sheet may already be gone by now —
    // arming a timer on a disposed state leaks it past the end of a test.
    if (!mounted) return;
    _emphasisTimer = Timer(CorePreferencesSheet.emphasisDuration, () {
      if (mounted) {
        setState(() => _emphasisKey = null);
      }
    });
  }

  Set<String> get _rowKeys => {
        for (final section in widget.sections)
          for (final row in section.rows) row.key,
      };

  // Each row owns a GlobalKey so the deep link can scroll to it, and a
  // GlobalKey cannot be shared. A duplicate key otherwise fails deep in the
  // framework rather than where the mistake was made.
  bool _debugKeysAreUnique() {
    final rows = widget.sections.fold(0, (n, s) => n + s.rows.length);
    return rows == _rowKeys.length;
  }

  Future<void> _openOptions(CorePreferenceRow row) async {
    await CoreQuickSheet.show<void>(
      context: context,
      child: CorePreferenceOptionSheet(
        title: row.label,
        options: row.options,
        selectedOptionId: row.selectedOptionId,
        updateLabel: widget.optionUpdateLabel,
        backSemanticsLabel: widget.optionBackSemanticsLabel,
        info: row.info,
        optionKeyOf: widget.optionKeyOf,
        updateButtonKey: widget.optionUpdateButtonKey,
        onUpdate: (optionId) => widget.onChanged(row.key, optionId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    assert(_debugKeysAreUnique(), 'preference keys must be unique');
    _rowAnchors.prune(_rowKeys);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PreferenceSheetTitle(title: widget.title),
        Flexible(
          child: Material(
            // See CoreMultiSelectSheet: inside CoreQuickSheet's decorated
            // container the nearest Material is behind the sheet background,
            // so row splashes need a transparent Material of their own.
            type: MaterialType.transparency,
            // Every section is built, rather than only the ones on screen.
            // A deep link scrolls to a row's anchor, and an anchor exists
            // only once its row has been built — a lazy list would silently
            // do nothing for a target below the viewport. A preferences list
            // is short enough that building it whole costs nothing.
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                CoreSpacing.space4,
                0,
                CoreSpacing.space4,
                CoreSpacing.space4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final section in widget.sections)
                    PreferenceSectionView(
                      section: section,
                      emphasisKey: _emphasisKey,
                      emphasisDuration:
                          CorePreferencesSheet.emphasisDuration ~/ 4,
                      rowKeyOf: widget.rowKeyOf,
                      anchorOf: (key) => _rowAnchors[key],
                      onRowTap: _openOptions,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
