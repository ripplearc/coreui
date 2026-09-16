import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';

import '../../../ripplearc_coreui.dart';

part 'parts/attachments_section.dart';
part 'parts/dimension_card.dart';
part 'parts/dimensions_section.dart';
part 'parts/table_sizes/size_card.dart';
part 'parts/table_sizes/size_entry_bottom_sheet.dart';
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

/// Describes a single column of a [CoreSizesTableData].
///
/// A column is a header title plus, in a later release, whether its cells are
/// individually editable. Columns whose values are computed from the row carry
/// no edit affordance.
class CoreSizesColumn {
  const CoreSizesColumn({
    required this.title,
  });

  /// The header text displayed above this column.
  ///
  /// Pass a localised string from the app layer:
  /// ```dart
  /// CoreSizesColumn(title: AppLocalizations.of(context).sizeColumnTitle),
  /// ```
  final String title;
}

/// Describes one titled table rendered inside a [CoreGeometryArea].
///
/// A [CoreGeometryArea] renders one table per entry in its `tables` list, each
/// with its own columns, rows and callbacks. Every callback is optional, and a
/// null callback hides the affordance that drives it: a table with no
/// [onReordered] renders no drag handles, and a table with no [onAdd] renders
/// no add action. That lets the same widget express a reorderable, extendable
/// sizes table and a fixed, read-only rates table.
class CoreSizesTableData {
  const CoreSizesTableData({
    required this.title,
    required this.columns,
    required this.rows,
    this.addLabel,
    this.editLabel,
    this.dragHandleLabel,
    this.onAdd,
    this.onSaved,
    this.onDeleted,
    this.onReordered,
  })  : assert(
          onReordered == null || dragHandleLabel != null,
          'CoreSizesTableData: a reorderable table must supply '
          'dragHandleLabel, otherwise its drag handles reach screen readers '
          'unlabelled and announce the row text instead.',
        ),
        assert(
          onSaved == null || editLabel != null,
          'CoreSizesTableData: a table with onSaved must supply editLabel, '
          'otherwise tapping a row opens the entry sheet with no title.',
        ),
        assert(
          onAdd == null || addLabel != null,
          'CoreSizesTableData: onAdd has no effect without addLabel, which is '
          'what renders the add action.',
        );

  /// The title displayed above the table.
  ///
  /// Titles normally interpolate the result they describe, e.g.
  /// `'Sheet quantities for 180ft²'`, so this is required and has no default.
  /// Pass a localised string from the app layer.
  final String title;

  /// The columns rendered in this table, in display order.
  ///
  /// Each row in [rows] must supply exactly one value per column.
  final List<CoreSizesColumn> columns;

  /// The data rows displayed in this table.
  ///
  /// Identifiers must be unique within the table to support reliable
  /// reordering.
  final List<CoreSizeCardData> rows;

  /// The text displayed for this table's add action.
  ///
  /// Required in practice whenever [onAdd] is provided, since it labels the
  /// button. Pass a localised string from the app layer.
  final String? addLabel;

  /// The title shown by the entry bottom sheet when editing an existing row.
  ///
  /// Pass a localised string from the app layer.
  final String? editLabel;

  /// The semantic label announced for this table's drag handles.
  ///
  /// Only meaningful when [onReordered] is provided. Pass a localised string
  /// from the app layer.
  final String? dragHandleLabel;

  /// Invoked when the user taps this table's add action.
  ///
  /// When null the add action is not rendered.
  final VoidCallback? onAdd;

  /// Invoked when the user saves a row from the entry bottom sheet.
  ///
  /// The parent should update its data by adding a new row or replacing an
  /// existing one.
  final void Function(SizeEntryResult result)? onSaved;

  /// Invoked when the user deletes a row, passing the row's id.
  ///
  /// When null the row cannot be deleted.
  final void Function(String id)? onDeleted;

  /// Invoked when the user drags a row to a new position.
  ///
  /// The parent should update its data to reflect the new order. When null the
  /// table renders no drag handles and rows cannot be reordered.
  final void Function(int oldIndex, int newIndex)? onReordered;
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

  /// The default text shown for the attachments section title.
  static const String defaultAttachmentsTitleLabel = 'Attachments';

  /// The default text shown for the view all attachments button.
  static const String defaultViewAllAttachmentsLabel = 'View all';

  /// The default text shown for the media button.
  static const String defaultMediaButtonLabel = 'Media';

  /// The default text shown for the document button.
  static const String defaultDocumentButtonLabel = 'Document';

  const CoreGeometryArea({
    super.key,
    this.dimensionsLabel = defaultDimensionsLabel,
    this.expandLabel = defaultExpandLabel,
    this.collapseLabel = defaultCollapseLabel,
    this.attachmentsTitleLabel = defaultAttachmentsTitleLabel,
    this.viewAllAttachmentsLabel = defaultViewAllAttachmentsLabel,
    this.mediaButtonLabel = defaultMediaButtonLabel,
    this.documentButtonLabel = defaultDocumentButtonLabel,
    this.dimensions = const [],
    this.tables = const [],
    this.isCollapsed = true,
    this.onViewAllAttachmentsPressed,
    this.onMediaButtonPressed,
    this.onDocumentButtonPressed,
  });

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

  /// The text displayed for the attachments section title.
  ///
  /// Defaults to [defaultAttachmentsTitleLabel]. Pass a localised string from
  /// the app layer.
  final String attachmentsTitleLabel;

  /// The text displayed for the view all attachments button.
  ///
  /// Defaults to [defaultViewAllAttachmentsLabel]. Pass a localised string from
  /// the app layer.
  final String viewAllAttachmentsLabel;

  /// The text displayed for the media button.
  ///
  /// Defaults to [defaultMediaButtonLabel]. Pass a localised string from
  /// the app layer.
  final String mediaButtonLabel;

  /// The text displayed for the document button.
  ///
  /// Defaults to [defaultDocumentButtonLabel]. Pass a localised string from
  /// the app layer.
  final String documentButtonLabel;

  /// Optional callback invoked when the user taps on "View all" attachments.
  final VoidCallback? onViewAllAttachmentsPressed;

  /// Callback invoked when the user taps on the "Media" button.
  final VoidCallback? onMediaButtonPressed;

  /// Callback invoked when the user taps on the "Document" button.
  final VoidCallback? onDocumentButtonPressed;

  /// The tables rendered below the dimensions section, in display order.
  ///
  /// Defaults to an empty list (no tables rendered). Each entry is configured
  /// independently — see [CoreSizesTableData].
  final List<CoreSizesTableData> tables;

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
          for (final table in tables)
            if (table.columns.isNotEmpty) ...[
              const SizedBox(height: CoreSpacing.space2),
              _SizesTable(table: table),
            ],
          const SizedBox(height: CoreSpacing.space2),
          _AttachmentsSection(
            attachmentsTitleLabel: attachmentsTitleLabel,
            viewAllAttachmentsLabel: viewAllAttachmentsLabel,
            mediaButtonLabel: mediaButtonLabel,
            documentButtonLabel: documentButtonLabel,
            onViewAllAttachmentsPressed: onViewAllAttachmentsPressed,
            onMediaButtonPressed: onMediaButtonPressed,
            onDocumentButtonPressed: onDocumentButtonPressed,
          ),
        ],
      ),
    );
  }
}
