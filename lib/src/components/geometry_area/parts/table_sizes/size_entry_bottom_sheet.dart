part of '../../core_geometry_area.dart';

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

class SizeEntryBottomSheet extends StatefulWidget {
  const SizeEntryBottomSheet({
    super.key,
    this.initialData,
    this.initialIndex,
    required this.titles,
    required this.addSizeTitle,
    required this.editSizeTitle,
  });

  /// The initial size data to populate the form with if editing an existing entry.
  final CoreSizeCardData? initialData;

  /// The index of the size data being edited, if applicable.
  final int? initialIndex;

  /// The titles for each input field column.
  final List<String> titles;

  /// The title text displayed when adding a new size.
  final String addSizeTitle;

  /// The title text displayed when editing an existing size.
  final String editSizeTitle;

  static Future<SizeEntryResult?> show({
    required BuildContext context,
    CoreSizeCardData? initialData,
    int? initialIndex,
    required List<String> titles,
    required String addSizeTitle,
    required String editSizeTitle,
  }) {
    return showModalBottomSheet<SizeEntryResult>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SizeEntryBottomSheet(
        initialData: initialData,
        initialIndex: initialIndex,
        titles: titles,
        addSizeTitle: addSizeTitle,
        editSizeTitle: editSizeTitle,
      ),
    );
  }

  @override
  State<SizeEntryBottomSheet> createState() => _SizeEntryBottomSheetState();
}

class _SizeEntryBottomSheetState extends State<SizeEntryBottomSheet> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
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
    _focusNodes = List.generate(
      widget.titles.length,
      (index) {
        final node = FocusNode();
        node.addListener(() {
          if (node.hasFocus) {
            setState(() {
              _activeIndex = index;
            });
          }
        });
        return node;
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_focusNodes.isNotEmpty) {
        _focusNodes.first.requestFocus();
      }
    });
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

  void _insertText(String input) {
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

  void _submit() {
    final values = _controllers.map((c) => c.text).toList();
    Navigator.of(context).pop(SizeEntryResult(
      values: values,
      intent: widget.initialData == null
          ? SizeOperationIntent.add
          : SizeOperationIntent.edit,
      index: widget.initialIndex,
    ));
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
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: hasSecond ? CoreSpacing.space2 : 0,
                  ),
                  child: CoreTextField(
                    label: '${widget.titles[i]}*',
                    controller: _controllers[i],
                    focusNode: _focusNodes[i],
                    keyboardType: TextInputType.none,
                  ),
                ),
              ),
              if (hasSecond)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: CoreSpacing.space2),
                    child: CoreTextField(
                      label: '${widget.titles[i + 1]}*',
                      controller: _controllers[i + 1],
                      focusNode: _focusNodes[i + 1],
                      keyboardType: TextInputType.none,
                    ),
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final isEdit = widget.initialData != null;
    final title = isEdit ? widget.editSizeTitle : widget.addSizeTitle;

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
              currentGroup: const GroupNameType(label: 'Function'),
              allGroups: [
                FunctionGroup(
                  name: const GroupNameType(label: 'Function'),
                  keys: [
                    KeyType(groupName: 'Function', label: 'm', action: () {}),
                    KeyType(groupName: 'Function', label: 'cm', action: () {}),
                    KeyType(groupName: 'Function', label: 'mm', action: () {}),
                  ],
                ),
              ],
              onDigitPressed: _onDigitPressed,
              onUnitSelected: (unit) => _insertText(unit.label),
              onOperatorPressed: (op) => _insertText(op.symbol),
              onControlAction: _onControlAction,
              onResultTapped: _submit,
              onGroupSelected: (_) {},
              onKeyTapped: (key) => _insertText(key.label),
              onUnitSystemChanged: (_) {},
              customResultLabel: isEdit ? 'Update' : 'Add',
            ),
          ],
        ),
      ),
    );
  }
}
