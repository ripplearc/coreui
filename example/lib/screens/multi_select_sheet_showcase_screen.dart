import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class MultiSelectSheetShowcaseScreen extends StatefulWidget {
  const MultiSelectSheetShowcaseScreen({super.key});

  @override
  State<MultiSelectSheetShowcaseScreen> createState() =>
      _MultiSelectSheetShowcaseScreenState();
}

class _MultiSelectSheetShowcaseScreenState
    extends State<MultiSelectSheetShowcaseScreen> {
  static const _allTags = [
    CoreMultiSelectItem(id: 'roofing', label: 'Roofing'),
    CoreMultiSelectItem(id: 'wall', label: 'Wall'),
    CoreMultiSelectItem(id: 'flooring', label: 'Flooring'),
    CoreMultiSelectItem(id: 'plumbing', label: 'Plumbing'),
    CoreMultiSelectItem(id: 'electrical', label: 'Electrical'),
  ];

  Set<String> _selectedIds = {};

  Future<void> _showSheet(BuildContext context) {
    // The sheet reports the query but keeps no list state of its own, so the
    // showcase filters the items and rebuilds the sheet body via a
    // StatefulBuilder — the same pattern an app would drive from its own
    // state management.
    var query = '';
    return CoreQuickSheet.show<void>(
      context: context,
      child: StatefulBuilder(
        builder: (context, setSheetState) {
          final visibleTags = _allTags
              .where(
                (tag) => tag.label.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
          return CoreMultiSelectSheet(
            title: 'Tags',
            searchHint: 'Search by tag name',
            emptyLabel: 'No tags found.',
            initialSelectedIds: _selectedIds,
            listData: CoreMultiSelectListData(
              isLoading: false,
              items: visibleTags,
            ),
            onSearchQueryChanged: (value) => setSheetState(() => query = value),
            onApply: (ids) => setState(() => _selectedIds = ids),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Scaffold(
      backgroundColor: colors.pageBackground,
      appBar: AppBar(
        title: const Text('CoreMultiSelectSheet Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space6),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Searchable multi-select inside a CoreQuickSheet',
              style: typography.titleMediumMedium.copyWith(
                color: colors.textHeadline,
              ),
            ),
            const SizedBox(height: CoreSpacing.space2),
            ElevatedButton(
              onPressed: () => _showSheet(context),
              child: const Text('Open tag filter'),
            ),
            const SizedBox(height: CoreSpacing.space2),
            Text(
              _selectedIds.isEmpty
                  ? 'No tags selected'
                  : 'Selected: ${_selectedIds.join(', ')}',
              style: typography.bodyMediumRegular.copyWith(
                color: colors.textBody,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
