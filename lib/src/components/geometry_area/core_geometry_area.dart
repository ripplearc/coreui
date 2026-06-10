import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../../ripplearc_coreui.dart';

part 'parts/dimension_card.dart';
part 'parts/dimensions_section.dart';
part 'parts/table_sizes/size_card.dart';
part 'parts/table_sizes/sizes_header.dart';
part 'parts/table_sizes/sizes_table.dart';
part 'parts/table_sizes/sizes_table_header.dart';

/// Data class for a single row in the sizes table in the [CoreGeometryArea].
class CoreSizeCardData {
  const CoreSizeCardData({
    required this.id,
    required this.values,
  });

  /// A unique identifier for this row, required for drag-and-drop reordering.
  final String id;

  /// The list of string values for each column in the row.
  final List<String> values;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CoreSizeCardData && listEquals(other.values, values);
  }

  @override
  int get hashCode => Object.hashAll(values);
}

/// Data class for a single dimension to display in the [CoreGeometryArea].
class CoreDimensionData {
  const CoreDimensionData({
    required this.label,
    required this.value,
  });

  /// The name or title of the dimension (e.g., 'Area').
  final String label;

  /// The formatted value of the dimension (e.g., '50.27ft²').
  final String value;
}

/// A component that displays geometry-related details and inputs.
///
/// [dimensionsLabel] is the label for the dimensions header.
/// [expandLabel] is the label for the expand action button.
/// [collapseLabel] is the label for the collapse action button.
class CoreGeometryArea extends StatelessWidget {
  /// The default label text shown in the dimensions section.
  static const String defaultDimensionsLabel = 'Dimensions';

  /// The default text shown for the expand button.
  static const String defaultExpandLabel = 'Expand';

  /// The default text shown for the collapse button.
  static const String defaultCollapseLabel = 'Collapse';

  /// The default text shown for the sizes table title.
  static const String defaultSizesTitleLabel = 'Concrete volumes';

  /// The default text shown for the add size button.
  static const String defaultAddSizeLabel = 'Add size';

  /// The default text shown for the drag handle semantic label.
  static const String defaultDragHandleLabel = 'Reorder';

  const CoreGeometryArea({
    super.key,
    this.dimensionsLabel = defaultDimensionsLabel,
    this.expandLabel = defaultExpandLabel,
    this.collapseLabel = defaultCollapseLabel,
    this.sizesTitleLabel = defaultSizesTitleLabel,
    this.addSizeLabel = defaultAddSizeLabel,
    this.dimensions = const [],
    this.sizesTableTitles = const [],
    this.sizesTableData = const [],
    this.isCollapsed = true,
    this.dragHandleLabel = defaultDragHandleLabel,
    this.onSizesReordered,
    this.onSizeDeleted,
  });

  /// Optional callback invoked when the user drags and drops a size card to reorder it.
  /// The parent should update its data list to reflect the new order.
  final void Function(int oldIndex, int newIndex)? onSizesReordered;

  /// Optional callback invoked when the user swipes a size card to delete it.
  /// The parent should update its data list to remove the item with the given ID.
  final void Function(String id)? onSizeDeleted;

  /// The text displayed in the dimensions section.
  ///
  /// Defaults to [defaultDimensionsLabel]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// dimensionsLabel: AppLocalizations.of(context).dimensionsLabel,
  /// ```
  final String dimensionsLabel;

  /// The text displayed for the expand action button.
  ///
  /// Defaults to [defaultExpandLabel]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// expandLabel: AppLocalizations.of(context).expandLabel,
  /// ```
  final String expandLabel;

  /// The text displayed for the collapse action button.
  ///
  /// Defaults to [defaultCollapseLabel]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// collapseLabel: AppLocalizations.of(context).collapseLabel,
  /// ```
  final String collapseLabel;

  /// The text displayed for the sizes table title.
  ///
  /// Defaults to [defaultSizesTitleLabel]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// sizesTitleLabel: AppLocalizations.of(context).sizesTitleLabel,
  /// ```
  final String sizesTitleLabel;

  /// The text displayed for the add size button.
  ///
  /// Defaults to [defaultAddSizeLabel]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// addSizeLabel: AppLocalizations.of(context).addSizeLabel,
  /// ```
  final String addSizeLabel;

  /// The column header titles displayed in the sizes table.
  ///
  /// Defaults to an empty list (no header row rendered). Pass localised
  /// strings from the app layer:
  /// ```dart
  /// sizesTableTitles: AppLocalizations.of(context).sizeColumnTitles,
  /// ```
  final List<String> sizesTableTitles;

  /// The text displayed for the drag handle's semantic label.
  ///
  /// Defaults to [defaultDragHandleLabel]. Pass a localised string from
  /// the app layer:
  /// ```dart
  /// dragHandleLabel: AppLocalizations.of(context).dragHandleLabel,
  /// ```
  final String dragHandleLabel;

  /// The data rows displayed within the sizes table.
  ///
  /// Defaults to an empty list (no data rows rendered). Each entry creates
  /// a draggable size card under the table header.
  final List<CoreSizeCardData> sizesTableData;

  /// The list of dimensions to display.
  final List<CoreDimensionData> dimensions;

  /// Whether the dimensions section is collapsed.
  final bool isCollapsed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);

    return Container(
      color: colors.pageBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _DimensionsSection(
            dimensionsLabel: dimensionsLabel,
            expandLabel: expandLabel,
            collapseLabel: collapseLabel,
            dimensions: dimensions,
            isCollapsed: isCollapsed,
          ),
          if (sizesTableTitles.isNotEmpty) ...[
            const SizedBox(height: CoreSpacing.space2),
            _SizesTable(
              sizesTitleLabel: sizesTitleLabel,
              addSizeLabel: addSizeLabel,
              dragHandleLabel: dragHandleLabel,
              titles: sizesTableTitles,
              sizesTableData: sizesTableData,
              onSizesReordered: onSizesReordered,
              onSizeDeleted: onSizeDeleted,
            ),
          ],
        ],
      ),
    );
  }
}
