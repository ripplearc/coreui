import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

part 'parts/dimension_card.dart';
part 'parts/dimensions_section.dart';
part 'parts/table_sizes/sizes_header.dart';
part 'parts/table_sizes/sizes_table.dart';
part 'parts/table_sizes/sizes_table_header.dart';

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

  const CoreGeometryArea({
    super.key,
    this.dimensionsLabel = defaultDimensionsLabel,
    this.expandLabel = defaultExpandLabel,
    this.collapseLabel = defaultCollapseLabel,
    this.sizesTitleLabel = defaultSizesTitleLabel,
    this.addSizeLabel = defaultAddSizeLabel,
    this.dimensions = const [],
    this.sizesTableTitles = const [],
    this.isCollapsed = true,
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

  /// The titles for the columns in the sizes table.
  final List<String> sizesTableTitles;

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
          const SizedBox(height: CoreSpacing.space2),
          _SizesTable(
            sizesTitleLabel: sizesTitleLabel,
            addSizeLabel: addSizeLabel,
            titles: sizesTableTitles,
          ),
        ],
      ),
    );
  }
}
