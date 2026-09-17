import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// A modal bottom sheet body offering the choices of one preference.
///
/// The sheet owns no external state: the caller supplies [options] and the
/// option in force, and hears the user's choice through [onUpdate]. Selection
/// is kept local until the user taps Update, at which point [onUpdate]
/// receives the chosen id and the sheet pops itself — tapping an option alone
/// changes nothing the caller can see, which is what lets a user browse the
/// choices and back out unchanged.
///
/// When [infoTitle] and [infoDescription] are both set the header carries an
/// info button; opening it replaces the Update button with the explanation,
/// so the sheet keeps its height (Figma `62481:80137` and `62481:80158`).
///
/// Present it with `CoreQuickSheet.show(context: context, child: ...)`.
class CorePreferenceOptionSheet extends StatefulWidget {
  /// Title shown beside the back button.
  final String title;

  /// The choices offered, in display order.
  final List<CorePreferenceOption> options;

  /// Identifier of the option in force when the sheet opens.
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

  @override
  void initState() {
    super.initState();
    _selectedId = widget.selectedOptionId;
  }

  void _commit() {
    final selectedId = _selectedId;
    if (selectedId != null) {
      widget.onUpdate(selectedId);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(context),
        Flexible(child: _buildOptionList(context)),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final info = widget.info;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space2,
        0,
        CoreSpacing.space4,
        CoreSpacing.space3,
      ),
      child: Row(
        children: [
          CoreIconWidget(
            icon: CoreIcons.arrowLeft,
            size: CoreIconSize.size24,
            color: colors.iconDark,
            semanticLabel: widget.backSemanticsLabel,
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: CoreSpacing.space2),
          Expanded(
            child: Text(
              widget.title,
              style: typography.bodyLargeSemiBold.copyWith(
                color: colors.textHeadline,
              ),
            ),
          ),
          if (info != null)
            CoreIconWidget(
              key: widget.infoButtonKey,
              icon: CoreIcons.info,
              size: CoreIconSize.size24,
              color: colors.iconGrayMid,
              semanticLabel: info.semanticsLabel,
              onTap: () => setState(() => _infoOpen = !_infoOpen),
            ),
        ],
      ),
    );
  }

  Widget _buildOptionList(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

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
          final isSelected = option.id == _selectedId;

          return InkWell(
            key: widget.optionKeyOf?.call(option.id),
            onTap: () => setState(() => _selectedId = option.id),
            borderRadius: BorderRadius.circular(CoreSpacing.space2),
            child: Semantics(
              selected: isSelected,
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? colors.backgroundBlueLight
                      : colors.transparent,
                  borderRadius: BorderRadius.circular(CoreSpacing.space2),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: CoreSpacing.space3,
                  vertical: CoreSpacing.space3,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option.label,
                        style: typography.bodyLargeRegular.copyWith(
                          color: colors.textHeadline,
                        ),
                      ),
                    ),
                    if (isSelected)
                      // Decorative: the selected state is already announced by
                      // the Semantics(selected:) wrapper above, so announcing
                      // the tick too would say it twice.
                      ExcludeSemantics(
                        child: CoreIconWidget(
                          icon: CoreIcons.checkMark,
                          size: CoreIconSize.size24,
                          color: colors.textSuccess,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final info = widget.info;

    return Padding(
      padding: const EdgeInsets.all(CoreSpacing.space4),
      child: _infoOpen && info != null
          ? Toast.info(
              title: info.title,
              description: info.description,
              closeLabel: info.closeLabel,
              onClose: () => setState(() => _infoOpen = false),
            )
          : CoreButton(
              key: widget.updateButtonKey,
              label: widget.updateLabel,
              size: CoreButtonSize.large,
              variant: CoreButtonVariant.primary,
              fullWidth: true,
              onPressed: _selectedId == null ? null : _commit,
            ),
    );
  }
}
