import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// A widget that allows the user to select a single item from a list of items
/// This widget uses a bottom sheet to display the list of items for selection.
class SingleItemSelector<T> extends StatefulWidget {
  /// Label of the field, floated above it. Also the screen-reader label.
  final String? labelText;

  /// Text shown in the field while [selectedItem] is null.
  final String? hintText;

  /// Heading at the top of the bottom sheet the field opens.
  final String modalTitle;

  /// The item the field shows and the sheet ticks. Null shows [hintText].
  final T? selectedItem;

  /// Items listed in the sheet, in this order.
  final List<T> items;

  /// Called with the tapped item as the sheet starts to close. The caller
  /// then passes it back as [selectedItem].
  final ValueChanged<T?> onItemSelected;

  /// Text for an item in the field and the sheet. When null the item's
  /// `toString()` is used.
  final String Function(T?)? itemToString;

  /// Widget at the end of the field. Defaults to a down arrow.
  final Widget? suffixIcon;

  /// Colour of the tick on the selected item. Defaults to `textSuccess`.
  final Color? selectedColor;

  /// Fill behind the selected item. Defaults to `backgroundBlueLight`.
  final Color? selectedBackgroundColor;

  /// Draws the disabled look and stops a tap from opening the sheet.
  final bool isDisabled;

  /// Called on a tap, just before the sheet opens.
  final VoidCallback? onOpen;

  /// Creates a field that opens a bottom sheet of [items] to pick from.
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

  /// Key of the transparent layer on top of the field that draws the tap
  /// ripple, for widget-test finders.
  static const Key inkLayerKey = Key('single_item_selector_ink_layer');

  @override
  State<SingleItemSelector<T>> createState() => _SingleItemSelectorState<T>();
}

class _SingleItemSelectorState<T> extends State<SingleItemSelector<T>> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final displayText = widget.selectedItem == null ? null : _getDisplayText();
    return Semantics(
      button: true,
      enabled: !widget.isDisabled,
      label: widget.labelText,
      value: displayText ?? widget.hintText,
      child: Stack(
        children: [
          // The field only shows the selection; the InkWell above it owns the
          // tap and the focus, so the inner text field never opens the
          // keyboard. The field draws its own focused look while the InkWell
          // holds the focus.
          ExcludeSemantics(
            child: IgnorePointer(
              child: CoreTextField(
                // A new key per selection rebuilds the field with the new text.
                key: ValueKey(displayText),
                label: widget.labelText,
                hintText: widget.hintText,
                initialValue: displayText,
                enabled: !widget.isDisabled,
                showsFocus: _isFocused,
                floatsLabel: true,
                suffix: widget.suffixIcon ??
                    CoreIconWidget(
                      icon: CoreIcons.arrowDown,
                      size: CoreIconSize.size24,
                      color: widget.isDisabled
                          ? colors.iconGrayLight
                          : colors.iconGrayMid,
                    ),
              ),
            ),
          ),
          // On top of the opaque field, so the tap ripple can be seen.
          Positioned.fill(
            child: Material(
              key: SingleItemSelector.inkLayerKey,
              type: MaterialType.transparency,
              child: InkWell(
                customBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(CoreSpacing.space1),
                ),
                onTap: widget.isDisabled
                    ? null
                    : () => _showSelectionBottomSheet(context),
                onFocusChange: (isFocused) =>
                    setState(() => _isFocused = isFocused),
                focusColor: colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayText() {
    if (widget.selectedItem == null) return widget.hintText ?? '';
    return widget.itemToString?.call(widget.selectedItem) ??
        widget.selectedItem.toString();
  }

  void _showSelectionBottomSheet(BuildContext context) {
    final colors = Theme.of(context).coreColors;
    final effectiveSelectedColor = widget.selectedColor ?? colors.textSuccess;
    final effectiveSelectedBackgroundColor =
        widget.selectedBackgroundColor ?? colors.backgroundBlueLight;

    final onOpenCallback = widget.onOpen;
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
                      widget.modalTitle,
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
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final isSelected = widget.selectedItem == item;

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
                                widget.itemToString?.call(item) ??
                                    item.toString(),
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
                            widget.onItemSelected(item);
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
