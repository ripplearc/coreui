import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

part 'parts/dimensions_section.dart';

/// A component that displays geometry-related details and inputs.
///
/// [dimensionsLabel] is the label for the dimensions header.
/// [expandLabel] is the label for the expand action button.
class CoreGeometryArea extends StatelessWidget {
  /// The default label text shown in the dimensions section.
  static const String defaultDimensionsLabel = 'Dimensions';

  /// The default text shown for the expand button.
  static const String defaultExpandLabel = 'Expand';

  const CoreGeometryArea({
    super.key,
    this.dimensionsLabel = defaultDimensionsLabel,
    this.expandLabel = defaultExpandLabel,
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
          ),
        ],
      ),
    );
  }
}
