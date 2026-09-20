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

/// Renamed to [CoreValueEditorSheet].
@Deprecated(
  'Renamed to CoreValueEditorSheet; this alias is removed in the next release.',
)
typedef SizeEntryBottomSheet = CoreValueEditorSheet;

/// A bottom sheet that edits a row of numeric values with a [CoreKeyboard]
/// mounted beneath the fields: one [CoreTextField] per entry in [titles], laid
/// out two to a line, committing a [SizeEntryResult].
///
/// The commit key never names itself: [resultLabel] is required and reaches
/// [CoreKeyboard.customResultLabel] unchanged, so "Add" and "Update" are the
/// caller's words and can be localized.
///
/// [unitOptions] renders the unit row above the keyboard, and needs a
/// localized [unitGroupLabel] beside it. Leave it null and no row is built.
/// The keyboard's own unit column is unaffected either way.
///
/// ```dart
/// final result = await CoreValueEditorSheet.show(
///   context: context,
///   titles: [l10n.length, l10n.width],
///   addSizeTitle: l10n.addSize,
///   editSizeTitle: l10n.editSize,
///   resultLabel: l10n.update,
///   unitOptions: const ['m', 'cm', 'mm'],
///   unitGroupLabel: l10n.unit,
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
    this.unitGroupLabel,
    this.validator,
  }) : assert(
          unitOptions == null || unitGroupLabel != null,
          _unitLabelRequired,
        );

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

  /// Labels for the unit row above the keyboard. Null or empty renders no row.
  final List<String>? unitOptions;

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

  /// Opens the sheet as a modal bottom sheet and returns what the user
  /// submitted, or null if they dismissed it.
  ///
  /// This is the entry point callers should use; constructing the widget
  /// directly is only for embedding it somewhere other than a modal route.
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

  @override
  State<CoreValueEditorSheet> createState() => _CoreValueEditorSheetState();
}

class _CoreValueEditorSheetState extends State<CoreValueEditorSheet> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  late List<String?> _errors;
  int _activeIndex = 0;
  List<String> get _unitOptions => widget.unitOptions ?? const [];

  @override
  void initState() {
    super.initState();
    _errors = List.filled(widget.titles.length, null);
    _controllers = List.generate(
      widget.titles.length,
      (index) {
        final data = widget.initialData;
        return TextEditingController(
          text: data != null && index < data.values.length
              ? data.values[index]
              : '',
        );
      },
    );
    _focusNodes = List.generate(widget.titles.length, _createFocusNode);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes.first.requestFocus();
      }
    });
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
        _controllers.add(TextEditingController());
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
  List<FunctionGroup> get _unitGroups {
    final unitOptions = _unitOptions;
    if (unitOptions.isEmpty) return const [];
    return [
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

  GroupNameType get _unitGroupName => GroupNameType(
        id: 'Unit',
        label: widget.unitGroupLabel ?? '',
      );

  // SizeEntryResult carries no unit of its own, so a unit key spells itself
  // into the value the way the design's `47.24in` does.
  void _onUnitKeyTapped(KeyType key) => _insertText(key.label);

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final title = widget.initialData != null
        ? widget.editSizeTitle
        : widget.addSizeTitle;

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
              onUnitSelected: (unit) => _insertText(unit.label),
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
