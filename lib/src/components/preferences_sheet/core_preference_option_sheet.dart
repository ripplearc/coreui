import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';
import 'preference_option_sheet_header.dart';
import 'preference_option_tile.dart';

/// A modal bottom sheet body offering the choices of one preference.
///
/// The sheet owns no external state: the caller supplies [options] and the
/// option in force, and hears the user's choice through [onUpdate]. Selection
/// is kept local until the user taps Update, at which point [onUpdate]
/// receives the chosen id and the sheet pops itself — tapping an option alone
/// changes nothing the caller can see, which is what lets a user browse the
/// choices and back out unchanged.
///
/// When [info] is set the header carries an info button; opening it replaces
/// the Update button with the explanation, so the sheet keeps its height
/// (Figma `62481:80137` and `62481:80158`). The explanation is the taller of
/// the two, so setting [info] reserves that height from the start: the footer
/// of such a sheet is already explanation-sized while Update is showing, with
/// Update held against the bottom. A sheet with no [info] reserves nothing.
///
/// Present it with `CoreQuickSheet.show(context: context, child: ...)`.
class CorePreferenceOptionSheet extends StatefulWidget {
  /// Title shown beside the back button.
  final String title;

  /// The choices offered, in display order.
  final List<CorePreferenceOption> options;

  /// Identifier of the option in force when the sheet opens. An id matching
  /// no entry in [options] leaves the sheet with nothing picked: no row ticks
  /// and Update stays disabled until the user chooses for themselves.
  final String? selectedOptionId;

  /// Label of the commit button.
  final String updateLabel;

  /// Accessibility label for the back button.
  final String backSemanticsLabel;

  /// The explanation behind the header's info button. The button is shown
  /// only when this is set, and it carries its own labels so the button can
  /// never render unlabelled.
  final CorePreferenceInfo? info;

  /// Called with the chosen id when the user taps Update; the sheet pops
  /// itself immediately afterwards.
  final ValueChanged<String> onUpdate;

  /// Builds the key for the row of the option with the given id.
  final Key Function(String id)? optionKeyOf;

  /// Key applied to the Update button.
  final Key? updateButtonKey;

  /// Key applied to the info button.
  final Key? infoButtonKey;

  /// Creates a preference option sheet body.
  const CorePreferenceOptionSheet({
    super.key,
    required this.title,
    required this.options,
    required this.updateLabel,
    required this.backSemanticsLabel,
    required this.onUpdate,
    this.selectedOptionId,
    this.info,
    this.optionKeyOf,
    this.updateButtonKey,
    this.infoButtonKey,
  });

  @override
  State<CorePreferenceOptionSheet> createState() =>
      _CorePreferenceOptionSheetState();
}

class _CorePreferenceOptionSheetState extends State<CorePreferenceOptionSheet> {
  String? _selectedId;
  bool _infoOpen = false;

  bool _userPicked = false;

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedOptionId;
  }

  @override
  void didUpdateWidget(CorePreferenceOptionSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // The caller is the source of truth for what is stored. If it hands the
    // sheet a different option while the sheet is open, an untouched pick
    // must follow it rather than keep showing the value it opened with.
    if (!_userPicked &&
        widget.selectedOptionId != oldWidget.selectedOptionId) {
      _selectedId = widget.selectedOptionId;
    }
  }

  bool get _hasValidSelection =>
      widget.options.any((option) => option.id == _selectedId);

  void _commit() {
    final selectedId = _selectedId;
    // Update is the only way in and it is disabled without a valid pick, but
    // the guard belongs with the callback too: a commit path added later must
    // not be able to hand back an id that matches no option.
    if (selectedId != null && _hasValidSelection) {
      widget.onUpdate(selectedId);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PreferenceOptionSheetHeader(
          title: widget.title,
          backSemanticsLabel: widget.backSemanticsLabel,
          onBack: () => Navigator.of(context).pop(),
          info: widget.info,
          onInfoTap: () => setState(() => _infoOpen = !_infoOpen),
          infoButtonKey: widget.infoButtonKey,
        ),
        Flexible(child: _buildOptionList(context)),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildOptionList(BuildContext context) {
    // The nearest Material inside CoreQuickSheet sits behind the sheet's
    // decorated container, so without a transparent Material of our own the
    // row splashes are invisible and Flutter asserts in debug builds — the
    // same trap CoreMultiSelectSheet hit.
    return Material(
      type: MaterialType.transparency,
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
        itemCount: widget.options.length,
        itemBuilder: (_, index) {
          final option = widget.options[index];

          return PreferenceOptionTile(
            key: widget.optionKeyOf?.call(option.id),
            option: option,
            isSelected: option.id == _selectedId,
            onTap: () => setState(() {
              _userPicked = true;
              _selectedId = option.id;
            }),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final info = widget.info;
    final updateButton = CoreButton(
      key: widget.updateButtonKey,
      label: widget.updateLabel,
      size: CoreButtonSize.large,
      variant: CoreButtonVariant.primary,
      fullWidth: true,
      onPressed: _hasValidSelection ? _commit : null,
    );

    return Padding(
      padding: const EdgeInsets.all(CoreSpacing.space4),
      child: info == null
          ? updateButton
          // An IndexedStack lays both states out and takes the height of the
          // taller, so opening the explanation swaps what is shown without
          // moving the sheet under the thumb that opened it. The branch behind
          // is left out of painting, hit testing, semantics and focus
          // traversal, so it cannot be reached by touch, reader or keyboard.
          : IndexedStack(
              alignment: AlignmentDirectional.bottomCenter,
              index: _infoOpen ? 1 : 0,
              children: [
                updateButton,
                Toast.info(
                  title: info.title,
                  description: info.description,
                  closeLabel: info.closeLabel,
                  onClose: () => setState(() => _infoOpen = false),
                ),
              ],
            ),
    );
  }
}
