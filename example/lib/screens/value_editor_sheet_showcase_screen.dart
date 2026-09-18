import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Demonstrates both modes of [CoreValueEditorSheet]: the multi-column size
/// editor the geometry area opens, and the single-value editor a dependent-key
/// pill opens on the calculator page.
class ValueEditorSheetShowcaseScreen extends StatefulWidget {
  const ValueEditorSheetShowcaseScreen({super.key});

  @override
  State<ValueEditorSheetShowcaseScreen> createState() =>
      _ValueEditorSheetShowcaseScreenState();
}

class _ValueEditorSheetShowcaseScreenState
    extends State<ValueEditorSheetShowcaseScreen> {
  static const _unitOptions = ['m', 'cm', 'mm'];

  // An app would localize this; the showcase has no l10n of its own.
  static const _unitGroupLabel = 'Unit';

  String _lastResult = 'Nothing committed yet.';

  void _report(String description) {
    setState(() {
      _lastResult = description;
    });
  }

  Future<void> _openSizeSheet() async {
    final result = await CoreValueEditorSheet.show(
      context: context,
      titles: const ['Length', 'Width'],
      addSizeTitle: 'Add size',
      editSizeTitle: 'Edit size',
      resultLabel: 'Update',
      unitOptions: _unitOptions,
      unitGroupLabel: _unitGroupLabel,
      initialData: const CoreSizeCardData(
        id: '1',
        values: ['47.24in', '94.49in'],
      ),
      initialIndex: 0,
    );
    if (result == null) return;
    _report('Size committed: ${result.values.join(' x ')}');
  }

  Future<void> _openRateSheet() async {
    final result = await CoreValueEditorSheet.showSingleValue(
      context: context,
      title: 'Rate (\$ per ft²)',
      label: 'Rate',
      resultLabel: 'Update',
      initialValue: '12.3',
      // A rate carries its own unit in the title, so it needs no unit row.
      validator: (value) => (double.tryParse(value) ?? 0) > 0
          ? null
          : 'Enter a rate greater than zero',
    );
    if (result == null) return;
    _report('Rate committed: ${result.value}');
  }

  Future<void> _openSheetSizeSheet() async {
    final result = await CoreValueEditorSheet.showSingleValue(
      context: context,
      title: 'Sheet size',
      label: 'Size',
      resultLabel: 'Add',
      unitOptions: _unitOptions,
      unitGroupLabel: _unitGroupLabel,
      unit: 'cm',
      validator: (value) =>
          value.trim().isEmpty ? 'Enter a size' : null,
    );
    if (result == null) return;
    _report('Sheet size committed: ${result.value} (unit: ${result.unit})');
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Value Editor Sheet')),
      body: Padding(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CoreButton(
              label: 'Multi-column size sheet',
              onPressed: _openSizeSheet,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Single value — rate, no unit row',
              onPressed: _openRateSheet,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Single value — sheet size, with unit row',
              onPressed: _openSheetSizeSheet,
            ),
            const SizedBox(height: CoreSpacing.space8),
            Text(
              _lastResult,
              style: typography.bodyMediumRegular
                  .copyWith(color: colors.textHeadline),
            ),
          ],
        ),
      ),
    );
  }
}
