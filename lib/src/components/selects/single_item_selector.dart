import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A widget that allows the user to select a single item from a list of items
/// This widget uses a bottom sheet to display the list of items for selection.
///
/// [labelText] is the label for the selector
/// [hintText] is the hint text displayed when no item is selected
/// [modalTitle] is the title of the modal that appears when the selector is tapped
/// [selectedItem] is the currently selected item
/// [items] is the list of items to select from
/// [onItemSelected] is called when an item is selected
/// [itemToString] is a function that converts an item to a string for display
/// [suffixIcon] is an optional icon displayed at the end of the selector
/// [selectedColor] is the color of the check mark when an item is selected
/// [selectedBackgroundColor] is the background color of the selected item
/// [isDisabled] indicates if the selector is disabled
/// [onOpen] is an optional callback that is called when the selector is opened
class SingleItemSelector<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final String modalTitle;
  final T? selectedItem;
  final List<T> items;
  final ValueChanged<T?> onItemSelected;
  final String Function(T?)? itemToString;
  final Widget? suffixIcon;
  final Color? selectedColor;
  final Color? selectedBackgroundColor;
  final bool isDisabled;
  final VoidCallback? onOpen;

  const SingleItemSelector({
    super.key,
    this.labelText,
    this.hintText,
    required this.modalTitle,
    this.selectedItem,
    required this.items,
    required this.onItemSelected,
    this.itemToString,
    this.suffixIcon,
    this.selectedColor,
    this.selectedBackgroundColor,
    this.isDisabled = false,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final displayText = selectedItem == null ? null : _getDisplayText();
    return Semantics(
      button: true,
      label: labelText,
      value: displayText ?? hintText,
      child: InkWell(
        onTap: isDisabled ? null : () => _showSelectionBottomSheet(context),
        // The field only shows the selection; the InkWell owns the tap, so
        // the inner text field never takes focus or opens the keyboard.
        child: ExcludeSemantics(
          child: IgnorePointer(
            child: CoreTextField(
              // A new key per selection rebuilds the field with the new text.
              key: ValueKey(displayText),
              label: labelText,
              hintText: hintText,
              initialValue: displayText,
              enabled: !isDisabled,
              suffix: suffixIcon ??
                  CoreIconWidget(
                    icon: CoreIcons.arrowDown,
                    size: CoreIconSize.size24,
                    color: colors.iconGrayMid,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (selectedItem == null) return hintText ?? '';
    return itemToString?.call(selectedItem) ?? selectedItem.toString();
  }

  void _showSelectionBottomSheet(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final effectiveSelectedColor = selectedColor ?? colors.textSuccess;
    final effectiveSelectedBackgroundColor =
        selectedBackgroundColor ?? colors.backgroundBlueLight;

    final onOpenCallback = onOpen;
    if (onOpenCallback != null) {
      onOpenCallback();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: colors.pageBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
        final typography = Theme.of(context).coreTypography;
        return FractionallySizedBox(
          heightFactor: 0.4,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      modalTitle,
                      style: typography.titleMediumSemiBold
                          .copyWith(color: colors.textHeadline),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  key: const Key('professional_role_list'),
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isSelected = selectedItem == item;

                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Material(
                        color: isSelected
                            ? effectiveSelectedBackgroundColor
                            : colors.transparent,
                        borderRadius: BorderRadius.circular(
                          CoreSpacing.space12,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                          ),
                          title: Row(
                            children: [
                              Text(
                                itemToString?.call(item) ?? item.toString(),
                                style: typography.bodyMediumRegular
                                    .copyWith(color: colors.textBody),
                              ),
                              const SizedBox(width: CoreSpacing.space2),
                              if (isSelected)
                                CoreIconWidget(
                                  icon: CoreIcons.checkMark,
                                  color: effectiveSelectedColor,
                                ),
                            ],
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            onItemSelected(item);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
