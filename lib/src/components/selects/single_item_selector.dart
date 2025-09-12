import 'package:flutter/material.dart';
import 'package:ripplearc_core_ui/core_ui.dart';

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
  final Color selectedColor;
  final Color selectedBackgroundColor;
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
    this.selectedColor = CoreTextColors.success,
    this.selectedBackgroundColor = CoreBackgroundColors.backgroundBlueLight,
    this.isDisabled = false,
    this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isDisabled ? null : () => _showSelectionBottomSheet(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          enabled: !isDisabled,
          labelStyle: CoreTypography.bodyLargeSemiBold(
            color: isDisabled
                ? CoreTextColors.disable
                : CoreBorderColors.outlineFocus,
          ),
          hintStyle: CoreTypography.bodyLargeSemiBold(
            color: isDisabled
                ? CoreTextColors.disable
                : CoreBorderColors.outlineFocus,
          ),
          floatingLabelStyle: CoreTypography.bodyLargeSemiBold(
            color: isDisabled
                ? CoreTextColors.disable
                : CoreBorderColors.outlineFocus,
          ),
          border: const OutlineInputBorder(),
          suffixIcon: suffixIcon ?? const Icon(Icons.arrow_drop_down),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _getDisplayText(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: (selectedItem == null || isDisabled)
                          ? Theme.of(context).hintColor
                          : null,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (selectedItem == null) return hintText ?? '';
    return itemToString?.call(selectedItem) ?? selectedItem.toString();
  }

  void _showSelectionBottomSheet(BuildContext context) {
    final onOpenCallback = onOpen;
    if (onOpenCallback != null) {
      onOpenCallback();
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      backgroundColor: CoreBackgroundColors.pageBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) {
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
                      style: CoreTypography.headlineMediumSemiBold(),
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
                      decoration: BoxDecoration(
                        color: isSelected ? selectedBackgroundColor : null,
                        borderRadius: BorderRadius.circular(
                          CoreSpacing.space12,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        title: Row(
                          children: [
                            Text(
                              itemToString?.call(item) ?? item.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            const SizedBox(width: CoreSpacing.space2),
                            if (isSelected)
                              CoreIconWidget(
                                icon: CoreIcons.checkMark,
                                color: selectedColor,
                              ),
                          ],
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          onItemSelected(item);
                        },
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
