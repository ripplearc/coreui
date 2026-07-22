import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// One selectable row in a [CoreMultiSelectSheet].
class CoreMultiSelectItem {
  /// Stable identifier used to track selection across rebuilds.
  final String id;

  /// User-facing label rendered on the row.
  final String label;

  /// Creates a [CoreMultiSelectItem].
  const CoreMultiSelectItem({required this.id, required this.label});
}

/// The list portion of a [CoreMultiSelectSheet]: whether it is loading and
/// which items are currently available.
class CoreMultiSelectListData {
  /// Whether the available items are still being fetched.
  final bool isLoading;

  /// The items to render, already filtered by the current search query.
  final List<CoreMultiSelectItem> items;

  /// Creates a [CoreMultiSelectListData].
  const CoreMultiSelectListData({
    required this.isLoading,
    required this.items,
  });
}

/// A modal bottom sheet body for selecting multiple values from a
/// searchable list.
///
/// The sheet owns no external state: the caller supplies the (already
/// filtered) [listData] and reacts to [onSearchQueryChanged] and [onApply].
/// Selection is kept local until the user taps Apply, at which point [onApply]
/// receives the selected ids and the sheet pops itself. Tapping Clear all
/// deselects every item without dismissing the sheet. Passing a null
/// [listData] renders the title, search field, and action buttons with an
/// empty list area, for callers whose state cannot provide a list yet.
///
/// Present it with `CoreQuickSheet.show(context: context, child: ...)`.
class CoreMultiSelectSheet extends StatefulWidget {
  /// Title shown at the top of the sheet.
  final String title;

  /// Hint text for the search field.
  final String searchHint;

  /// Label shown when [CoreMultiSelectListData.items] is empty.
  final String emptyLabel;

  /// Label of the Clear all button.
  final String clearAllLabel;

  /// Label of the Apply button.
  final String applyLabel;

  /// Ids of the items already selected when the sheet opens.
  final Set<String> initialSelectedIds;

  /// The loading flag and available items, or null when the caller's state
  /// cannot provide a list yet.
  final CoreMultiSelectListData? listData;

  /// Called with the new query as the user types in the search field.
  final ValueChanged<String> onSearchQueryChanged;

  /// Called with the selected ids when the user taps Apply; the sheet pops
  /// itself immediately afterwards.
  final ValueChanged<Set<String>> onApply;

  /// Key applied to the loading indicator, so caller tests have a stable
  /// finder target.
  final Key? loadingIndicatorKey;

  /// Key applied to the empty-list label.
  final Key? emptyLabelKey;

  /// Builds the key for the row of the item with the given id.
  final Key Function(String id)? itemKeyOf;

  /// Key applied to the Clear all button.
  final Key? clearAllButtonKey;

  /// Key applied to the Apply button.
  final Key? applyButtonKey;

  /// Creates a [CoreMultiSelectSheet].
  const CoreMultiSelectSheet({
    super.key,
    required this.title,
    required this.searchHint,
    required this.emptyLabel,
    required this.initialSelectedIds,
    required this.listData,
    required this.onSearchQueryChanged,
    required this.onApply,
    this.clearAllLabel = 'Clear all',
    this.applyLabel = 'Apply',
    this.loadingIndicatorKey,
    this.emptyLabelKey,
    this.itemKeyOf,
    this.clearAllButtonKey,
    this.applyButtonKey,
  });

  @override
  State<CoreMultiSelectSheet> createState() => _CoreMultiSelectSheetState();
}

class _CoreMultiSelectSheetState extends State<CoreMultiSelectSheet> {
  late Set<String> _localSelected;

  // Caps the item list so the sheet's title, search field, and action
  // buttons stay visible while the list scrolls internally.
  static const double _listMaxHeight = 300;

  @override
  void initState() {
    super.initState();
    _localSelected = Set.of(widget.initialSelectedIds);
  }

  void _onApply(BuildContext context) {
    widget.onApply(Set.unmodifiable(_localSelected));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final typography = AppTypographyExtension.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitle(typography),
        _buildSearchField(),
        _buildItemList(typography),
        _buildActionButtons(context),
      ],
    );
  }

  Widget _buildTitle(AppTypographyExtension typography) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space4,
        vertical: CoreSpacing.space3,
      ),
      child: Text(widget.title, style: typography.bodyLargeSemiBold),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CoreSpacing.space4,
        vertical: CoreSpacing.space2,
      ),
      child: CoreTextField(
        hintText: widget.searchHint,
        onChanged: widget.onSearchQueryChanged,
        prefix: const CoreIconWidget(
          icon: CoreIcons.search,
          size: CoreSpacing.space5,
        ),
      ),
    );
  }

  Widget _buildItemList(AppTypographyExtension typography) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: _listMaxHeight),
      child: _buildListContent(typography),
    );
  }

  Widget _buildListContent(AppTypographyExtension typography) {
    final listData = widget.listData;
    if (listData == null) {
      return const SizedBox.shrink();
    }
    if (listData.isLoading) {
      return Padding(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Center(
          child: CoreLoadingIndicator(key: widget.loadingIndicatorKey),
        ),
      );
    }
    final items = listData.items;
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Center(
          child: Text(
            widget.emptyLabel,
            key: widget.emptyLabelKey,
            style: typography.bodyMediumRegular,
          ),
        ),
      );
    }
    // The transparent Material gives the CheckboxListTiles a surface to paint
    // ink on: inside CoreQuickSheet's color-decorated container the nearest
    // Material is behind the sheet background, so without this the splashes
    // are invisible (and Flutter asserts in debug builds).
    return Material(
      type: MaterialType.transparency,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (_, index) {
          final item = items[index];
          final isSelected = _localSelected.contains(item.id);
          return CheckboxListTile(
            key: widget.itemKeyOf?.call(item.id),
            value: isSelected,
            title: Text(item.label, style: typography.bodyLargeRegular),
            // Ignore the nullable bool parameter; use the pre-captured
            // isSelected to avoid null-unwrapping and keep the toggle readable.
            // _localSelected is privately owned and snapshotted via
            // Set.unmodifiable at apply time, so in-place mutation is safe.
            onChanged: (_) => setState(() {
              if (isSelected) {
                _localSelected.remove(item.id);
              } else {
                _localSelected.add(item.id);
              }
            }),
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CoreSpacing.space4,
        CoreSpacing.space3,
        CoreSpacing.space4,
        CoreSpacing.space4,
      ),
      child: Row(
        children: [
          Expanded(
            child: CoreButton(
              key: widget.clearAllButtonKey,
              label: widget.clearAllLabel,
              variant: CoreButtonVariant.secondary,
              onPressed: () => setState(() => _localSelected = {}),
            ),
          ),
          const SizedBox(width: CoreSpacing.space3),
          Expanded(
            child: CoreButton(
              key: widget.applyButtonKey,
              label: widget.applyLabel,
              onPressed: () => _onApply(context),
            ),
          ),
        ],
      ),
    );
  }
}
