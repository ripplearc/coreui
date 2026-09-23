import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// Describes whether a size entry operation is adding a new entry or editing
/// an existing one.
enum SizeOperationIntent {
  /// The user is creating a new size entry.
  add,

  /// The user is modifying an existing size entry.
  edit,
}

class SizeEntryResult {
  const SizeEntryResult({
    required this.values,
    required this.intent,
    this.index,
  });

  /// The list of string values entered for each size dimension.
  final List<String> values;

  /// The operation intent indicating whether this is an addition or an edit.
  final SizeOperationIntent intent;

  /// The index of the size entry being edited, if applicable.
  final int? index;
}

/// The result of a single-value edit, handed to
/// [CoreValueEditorSheet.showSingleValue]'s caller when the user commits.
class CoreValueEditorResult {
  const CoreValueEditorResult({
    required this.value,
    this.unit,
  });

  /// The text the user entered.
  final String value;

  /// The unit the user selected, or `null` if they selected none.
  ///
  /// Usually one of the sheet's `unitOptions`. It can also be a label from the
  /// keyboard's own unit column ('Inch', 'CM'), which renders in every sheet
  /// and cannot be suppressed — so this is not guaranteed to appear in
  /// `unitOptions`, and is non-null even for a sheet built without a unit row.
  /// Match on it rather than indexing into `unitOptions`.
  final String? unit;
}

/// Renamed to [CoreValueEditorSheet].
@Deprecated(
  'Renamed to CoreValueEditorSheet; this alias is removed in the next release.',
)
typedef SizeEntryBottomSheet = CoreValueEditorSheet;

/// A bottom sheet that edits one or more numeric values with a [CoreKeyboard].
///
/// The sheet has two modes, and both drive the same fields, the same keyboard
/// and the same commit path — only the number of fields and the header differ.
///
/// * The default constructor edits a whole size row: one [CoreTextField] per
///   entry in [titles], laid out two to a line, committing a [SizeEntryResult].
/// * [CoreValueEditorSheet.singleValue] edits one labelled value — a sheet
///   size, rate, waste or density behind a dependent-key pill — committing a
///   [CoreValueEditorResult] through the future returned by
///   [showSingleValue]. [onSaved] is an additional notification on the way
///   past, for a sheet embedded outside a modal route.
///
/// The equals key never names itself: [resultLabel] is required and reaches
/// [CoreKeyboard.customResultLabel] unchanged, so "Add" and "Update" are the
/// caller's words and can be localized.
///
/// [unitOptions] renders the unit row above the keyboard. Leave it null and no
/// row is built, which is what the rate variant of the design asks for — pass
/// null rather than an empty list, which a debug assert rejects unless
/// [unitGroupLabel] comes with it.
///
/// The keyboard's own unit column cannot be hidden, so single-value mode makes
/// it follow the same rule as the row: it records the unit instead of typing
/// it into the value. It reports its own labels ('Inch', 'CM'), which are not
/// drawn from [unitOptions] — see [CoreValueEditorResult.unit].
///
/// ```dart
/// final result = await CoreValueEditorSheet.showSingleValue(
///   context: context,
///   title: l10n.rateTitle,
///   label: l10n.rateFieldLabel,
///   initialValue: '12.3',
///   resultLabel: l10n.update,
///   validator: (value) =>
///       (double.tryParse(value) ?? 0) > 0 ? null : l10n.rateMustBePositive,
/// );
/// ```
class CoreValueEditorSheet extends StatefulWidget {
  static const String _unitLabelRequired =
      'CoreValueEditorSheet: a sheet with unitOptions must supply '
      'unitGroupLabel — otherwise the unit row names itself in English. '
      'Pass null rather than an empty list for no unit row.';

  /// Creates the multi-column size editor.
  const CoreValueEditorSheet({
    super.key,
    this.initialData,
    this.initialIndex,
    required this.titles,
    required this.addSizeTitle,
    required this.editSizeTitle,
    required this.resultLabel,
    this.unitOptions,
    this.unit,
    this.unitGroupLabel,
    this.validator,
  })  : assert(
          unitOptions == null || unitGroupLabel != null,
          _unitLabelRequired,
        ),
        assert(
          unit == null,
          'CoreValueEditorSheet: unit is single-value only. Multi-column mode '
          'has no unit field to report it through — SizeEntryResult carries '
          'no unit, and a unit key types its label into the value instead — '
          'so a unit passed here would be read by nothing. Use '
          'CoreValueEditorSheet.singleValue to commit a unit of its own.',
        ),
        title = null,
        initialValue = null,
        onSaved = null,
        isSingleValue = false;

  /// Creates the single-value editor: one field, one label, one optional unit.
  CoreValueEditorSheet.singleValue({
    super.key,
    required this.title,
    required String label,
    required this.resultLabel,
    this.initialValue,
    this.unitOptions,
    this.unit,
    this.unitGroupLabel,
    this.validator,
    this.onSaved,
  })  : assert(
          unitOptions == null || unitGroupLabel != null,
          _unitLabelRequired,
        ),
        assert(
          title != null,
          'CoreValueEditorSheet.singleValue: title is the sheet\'s only '
          'header — a null one renders the sheet with no title at all.',
        ),
        titles = <String>[label],
        initialData = null,
        initialIndex = null,
        addSizeTitle = '',
        editSizeTitle = '',
        isSingleValue = true;

  /// The initial size data to populate the form with if editing an existing
  /// row.
  final CoreSizeCardData? initialData;

  /// The index of the size data being edited, if applicable.
  final int? initialIndex;

  /// The titles for each input field column.
  ///
  /// In single-value mode this holds the one field label.
  final List<String> titles;

  /// The title text displayed when adding a new size.
  final String addSizeTitle;

  /// The title text displayed when editing an existing size.
  final String editSizeTitle;

  /// The header shown in single-value mode, where there is no add/edit pair.
  final String? title;

  /// The text the single field starts with.
  final String? initialValue;

  /// Labels for the unit row above the keyboard. Null or empty renders no row.
  final List<String>? unitOptions;

  /// Single-value mode only: seeds the unit reported back when the user
  /// commits without touching the unit row — the unit the edited value already
  /// carried. Ignored unless it appears in [unitOptions].
  ///
  /// The key strip has no selected state, so this is not rendered as a
  /// highlighted key; it only decides what a commit reports. Multi-column mode
  /// spells its unit inside the value instead, and [SizeEntryResult] carries
  /// no unit of its own.
  final String? unit;

  /// Names the unit row in the keyboard's group header.
  ///
  /// Required whenever [unitOptions] is set, asserted in both constructors:
  /// this package ships no user-facing English, so the label is the app's to
  /// supply and translate. The group's identity does not depend on it — only
  /// the text the user reads does.
  final String? unitGroupLabel;

  /// The label of the keyboard's equals key, such as "Add" or "Update".
  final String resultLabel;

  /// Rejects a value when it returns a message, which is shown beneath the
  /// offending field and keeps the sheet open.
  ///
  /// Runs against every field in multi-column mode.
  final String? Function(String value)? validator;

  /// Called with the committed value and unit in single-value mode, just
  /// before the sheet pops.
  ///
  /// The commit itself comes back through the future from [showSingleValue];
  /// this is the way to hear about it when the sheet was built directly rather
  /// than opened by that helper.
  final void Function(String value, String? unit)? onSaved;

  /// Opens the sheet as a modal bottom sheet and returns what the user
  /// submitted, or null if they dismissed it.
  ///
  /// This is the entry point callers should use. Constructing the widget
  /// directly is supported — [didUpdateWidget] keeps it safe across rebuilds —
  /// but note that committing always pops the enclosing route, so a sheet
  /// embedded in a page body pops that page. Give it a route of its own.
  ///
  /// Pass [initialData] to edit an existing row — the sheet then titles itself
  /// [editSizeTitle] and pre-fills each field from the row's values. Leave it
  /// null to add, which titles the sheet [addSizeTitle] and starts empty.
  /// [initialIndex] is carried through untouched, so the caller can tell which
  /// row came back.
  static Future<SizeEntryResult?> show({
    required BuildContext context,
    CoreSizeCardData? initialData,
    int? initialIndex,
    required List<String> titles,
    required String addSizeTitle,
    required String editSizeTitle,
    required String resultLabel,
    List<String>? unitOptions,
    String? unitGroupLabel,
    String? Function(String value)? validator,
  }) {
    return showModalBottomSheet<SizeEntryResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CoreValueEditorSheet(
        initialData: initialData,
        initialIndex: initialIndex,
        titles: titles,
        addSizeTitle: addSizeTitle,
        editSizeTitle: editSizeTitle,
        resultLabel: resultLabel,
        unitOptions: unitOptions,
        unitGroupLabel: unitGroupLabel,
        validator: validator,
      ),
    );
  }

  /// Opens the single-value editor and resolves with what the user committed,
  /// or null if they dismissed the sheet.
  static Future<CoreValueEditorResult?> showSingleValue({
    required BuildContext context,
    required String title,
    required String label,
    required String resultLabel,
    String? initialValue,
    List<String>? unitOptions,
    String? unit,
    String? unitGroupLabel,
    String? Function(String value)? validator,
    void Function(String value, String? unit)? onSaved,
  }) {
    return showModalBottomSheet<CoreValueEditorResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => CoreValueEditorSheet.singleValue(
        title: title,
        label: label,
        resultLabel: resultLabel,
        initialValue: initialValue,
        unitOptions: unitOptions,
        unit: unit,
        unitGroupLabel: unitGroupLabel,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  /// Whether this sheet edits a single labelled value rather than a size row.
  ///
  /// Set by the constructor rather than derived from [title]: a caller passing
  /// a null localized title must not silently fall back to the multi-column
  /// mode, whose result type would not match the route's.
  final bool isSingleValue;

  @override
  State<CoreValueEditorSheet> createState() => _CoreValueEditorSheetState();
}

class _CoreValueEditorSheetState extends State<CoreValueEditorSheet> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String?> _errors;
  int _activeIndex = 0;
  late GroupNameType _unitGroupName;
  late List<FunctionGroup> _unitGroups;
  String? _selectedUnit;
  List<String> get _unitOptions => widget.unitOptions ?? const [];

  @override
  void initState() {
    super.initState();
    // Taken as given, not filtered through unitOptions: the keyboard's own
    // unit column commits labels that are never in that list, so gating on it
    // discarded the seed for exactly the sheet the seed exists for — a rate
    // sheet has no unit row at all, so every seed was dropped and the unit
    // vanished on the second save of a round-trip.
    _selectedUnit = widget.unit;
    _errors = List.filled(widget.titles.length, null);
    _controllers = List.generate(
      widget.titles.length,
      (index) => TextEditingController(text: _initialTextAt(index)),
    );
    _focusNodes = List.generate(widget.titles.length, _createFocusNode);
    _rebuildUnitGroups();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // The sheet can be gone before this runs — a route popped in the same
      // frame, or a parent rebuild that drops it. dispose() has disposed the
      // nodes by then, and requesting focus on a disposed one throws.
      if (!mounted) return;
      if (_focusNodes.isNotEmpty) {
        _focusNodes.first.requestFocus();
      }
    });
  }

  // The text a field starts with: the edited row's value for that column, or
  // empty when adding. Shared with the grow path in didUpdateWidget, which
  // would otherwise hand back blanks for columns the row already filled.
  String _initialTextAt(int index) {
    if (widget.isSingleValue) return widget.initialValue ?? '';
    final data = widget.initialData;
    return data != null && index < data.values.length ? data.values[index] : '';
  }

  FocusNode _createFocusNode(int index) {
    final node = FocusNode();
    node.addListener(() {
      if (node.hasFocus) {
        setState(() {
          _activeIndex = index;
        });
      }
    });
    return node;
  }

  // The field lists are sized from titles, so a rebuild that changes their
  // length has to resize them too — indexing them off a stale length throws.
  // Only the tail moves, so the index each focus listener closed over stays
  // correct for the fields that survive.
  @override
  void didUpdateWidget(CoreValueEditorSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    final unitOptionsChanged =
        !listEquals(widget.unitOptions, oldWidget.unitOptions);
    if (unitOptionsChanged ||
        widget.unitGroupLabel != oldWidget.unitGroupLabel) {
      _rebuildUnitGroups();
    }

    if (widget.unit != oldWidget.unit) {
      // A new seed replaces whatever the old one left behind.
      _selectedUnit = widget.unit;
    } else if (unitOptionsChanged) {
      // A unit the row no longer offers must not still be committed — a unit
      // system toggled from ['m','cm'] to ['ft','in'] would otherwise report
      // 'cm'. Only what the old row offered is dropped: a selection made on
      // the keyboard's own unit column was never in this list and is still
      // the user's answer.
      final selected = _selectedUnit;
      if (selected != null &&
          (oldWidget.unitOptions?.contains(selected) ?? false) &&
          !_unitOptions.contains(selected)) {
        _selectedUnit = null;
      }
    }

    final length = widget.titles.length;
    if (length == oldWidget.titles.length) return;

    for (var i = length; i < _controllers.length; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    if (length < _controllers.length) {
      _controllers.removeRange(length, _controllers.length);
      _focusNodes.removeRange(length, _focusNodes.length);
    } else {
      for (var i = _controllers.length; i < length; i++) {
        // Seeded exactly as initState does. Bare controllers here render the
        // new fields blank even when initialData carries their values, and
        // _submit then writes '' over data the row already had.
        _controllers.add(TextEditingController(text: _initialTextAt(i)));
        _focusNodes.add(_createFocusNode(i));
      }
    }
    // List.filled is fixed-length, so it is replaced rather than resized.
    _errors = List.filled(length, null);
    _activeIndex = _activeIndex.clamp(0, length == 0 ? 0 : length - 1);
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  // Drops the message pinned under the field being edited, so a corrected
  // value stops showing the error it no longer earns.
  void _clearActiveError() {
    if (_activeIndex < 0 || _activeIndex >= _errors.length) return;
    if (_errors[_activeIndex] == null) return;
    setState(() {
      _errors[_activeIndex] = null;
    });
  }

  void _insertText(String input) {
    _clearActiveError();
    if (_activeIndex >= 0 && _activeIndex < _controllers.length) {
      final controller = _controllers[_activeIndex];
      final text = controller.text;
      final selection = controller.selection;

      if (selection.isValid) {
        final newText =
            text.replaceRange(selection.start, selection.end, input);
        controller.value = TextEditingValue(
          text: newText,
          selection:
              TextSelection.collapsed(offset: selection.start + input.length),
        );
      } else {
        controller.text = text + input;
        controller.selection =
            TextSelection.collapsed(offset: controller.text.length);
      }
    }
  }

  void _onDigitPressed(DigitType digit) {
    _insertText(digit.label);
  }

  void _onControlAction(ControlAction action) {
    _clearActiveError();
    if (_activeIndex >= 0 && _activeIndex < _controllers.length) {
      final controller = _controllers[_activeIndex];
      final text = controller.text;
      final selection = controller.selection;

      if (action == ControlAction.delete) {
        if (selection.isValid && !selection.isCollapsed) {
          final newText = text.replaceRange(selection.start, selection.end, '');
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: selection.start),
          );
        } else if (text.isNotEmpty &&
            selection.isValid &&
            selection.start > 0) {
          final newText =
              text.replaceRange(selection.start - 1, selection.start, '');
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: selection.start - 1),
          );
        } else if (text.isNotEmpty && !selection.isValid) {
          controller.text = text.substring(0, text.length - 1);
        }
      } else if (action == ControlAction.clearAll) {
        controller.text = '';
      }
    }
  }

  // Runs the validator over every field, publishes the messages, and reports
  // whether the sheet may close.
  bool _validate() {
    final validator = widget.validator;
    if (validator == null) return true;

    final errors = [
      for (final controller in _controllers) validator(controller.text),
    ];
    setState(() {
      _errors = errors;
    });
    return errors.every((error) => error == null);
  }

  void _submit() {
    if (!_validate()) return;

    if (widget.isSingleValue) {
      final value = _controllers.first.text;
      widget.onSaved?.call(value, _selectedUnit);
      Navigator.of(context).pop(
        CoreValueEditorResult(value: value, unit: _selectedUnit),
      );
      return;
    }

    final values = _controllers.map((c) => c.text).toList();
    Navigator.of(context).pop(SizeEntryResult(
      values: values,
      intent: widget.initialData == null
          ? SizeOperationIntent.add
          : SizeOperationIntent.edit,
      index: widget.initialIndex,
    ));
  }

  // The asterisk marks the value as required, matching the design's `Length*`
  // and `Rate*`.
  Widget _buildTextField(int index) {
    final error = _errors[index];
    return CoreTextField(
      label: '${widget.titles[index]}*',
      controller: _controllers[index],
      focusNode: _focusNodes[index],
      keyboardType: TextInputType.none,
      errorTextList: error == null ? null : [error],
    );
  }

  List<Widget> _buildTextFieldRows() {
    if (widget.isSingleValue) {
      return [_buildTextField(0)];
    }

    final rows = <Widget>[];
    for (int i = 0; i < widget.titles.length; i += 2) {
      final hasSecond = i + 1 < widget.titles.length;
      rows.add(
        Padding(
          padding: EdgeInsets.only(
            bottom: i + 2 < widget.titles.length ? CoreSpacing.space4 : 0,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: hasSecond ? CoreSpacing.space2 : 0,
                  ),
                  child: _buildTextField(i),
                ),
              ),
              if (hasSecond)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: CoreSpacing.space2),
                    child: _buildTextField(i + 1),
                  ),
                )
              else
                const Spacer(),
            ],
          ),
        ),
      );
    }
    return rows;
  }

  // The unit row is the keyboard's own function strip: one key per entry in
  // unitOptions, or no strip at all when the caller supplied none.
  // Held rather than rebuilt per frame. CoreKeyboard compares allGroups by
  // identity, so a fresh list on every build reports a change on every
  // keystroke and posts a refresh of its open function sheet for nothing.
  void _rebuildUnitGroups() {
    _unitGroupName = GroupNameType(
      id: 'Unit',
      label: widget.unitGroupLabel ?? '',
    );
    final unitOptions = _unitOptions;
    _unitGroups = unitOptions.isEmpty
        ? const []
        : [
            FunctionGroup(
              name: _unitGroupName,
              keys: [
                for (final unit in unitOptions)
                  KeyType(
                    groupName: _unitGroupName.id,
                    id: unit,
                    label: unit,
                    action: () {},
                  ),
              ],
            ),
          ];
  }

  // Single-value mode reports the unit as its own field, so the label must not
  // also land in the text — otherwise a commit carries the unit twice and a
  // round-trip through initialValue compounds it ('12.3cm' -> '12.3cmcm').
  // Multi-column mode has no unit field on SizeEntryResult and has always
  // spelled the unit inline ('47.24in'), so it keeps inserting.
  void _onUnitKeyTapped(KeyType key) {
    if (widget.isSingleValue) {
      _selectUnit(key.id);
      return;
    }
    _insertText(key.label);
  }

  // CoreKeyboard renders its own unit column (Yards/Feet/Inch, or the metric
  // set) below the function strip, and it cannot be hidden. It has to obey the
  // same rule: typing 'Inch' into the value is exactly the corruption
  // single-value mode exists to avoid — a commit of '12.3Inch' that compounds
  // on the next round-trip through initialValue.
  //
  // The divide symbol is the one key that never becomes a unit: it composes
  // compound units inside the text ('ft/in'), which is a multi-column idea.
  // Single-value mode drops it rather than reporting '/' as the unit.
  void _onUnitSelected(UnitType unit) {
    if (!widget.isSingleValue) {
      _insertText(unit.label);
      return;
    }
    if (unit == UnitType.divideSymbol) return;
    _selectUnit(unit.label);
  }

  void _selectUnit(String unit) {
    setState(() {
      _selectedUnit = unit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final title = widget.title ??
        (widget.initialData != null
            ? widget.editSizeTitle
            : widget.addSizeTitle);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: colors.pageBackground,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(CoreSpacing.space8),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(CoreSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: CoreSpacing.space8,
                      height: CoreSpacing.space1,
                      decoration: BoxDecoration(
                        color: colors.lineDarkOutline,
                        borderRadius: BorderRadius.circular(CoreSpacing.space1),
                      ),
                    ),
                  ),
                  const SizedBox(height: CoreSpacing.space4),
                  Text(
                    title,
                    style: typography.bodyLargeSemiBold
                        .copyWith(color: colors.textHeadline),
                  ),
                  const SizedBox(height: CoreSpacing.space4),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.35,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: _buildTextFieldRows(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CoreKeyboard(
              currentGroup: _unitGroupName,
              allGroups: _unitGroups,
              onDigitPressed: _onDigitPressed,
              onUnitSelected: _onUnitSelected,
              onOperatorPressed: (op) => _insertText(op.symbol),
              onControlAction: _onControlAction,
              onResultTapped: _submit,
              onGroupSelected: (_) {},
              onKeyTapped: _onUnitKeyTapped,
              onUnitSystemChanged: (_) {},
              customResultLabel: widget.resultLabel,
            ),
          ],
        ),
      ),
    );
  }
}
