import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Demonstrates [CoreValueEditorSheet] editing a row of sizes, the flow
/// [CoreGeometryArea] opens from a table's add action or a row's pencil.
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

  Future<void> _openSizeSheet({CoreSizeCardData? row}) async {
    final result = await CoreValueEditorSheet.show(
      context: context,
      titles: const ['Length', 'Width'],
      addSizeTitle: 'Add size',
      editSizeTitle: 'Edit size',
      resultLabel: row == null ? 'Add' : 'Update',
      unitOptions: _unitOptions,
      unitGroupLabel: _unitGroupLabel,
      initialData: row,
      initialIndex: row == null ? null : 0,
      validator: (value) =>
          value.trim().isEmpty ? 'Enter a size' : null,
    );
    if (result == null) return;
    _report('Committed: ${result.values.join(' x ')} (${result.intent.name})');
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
              label: 'Add a size',
              onPressed: _openSizeSheet,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Edit an existing size',
              onPressed: () => _openSizeSheet(
                row: const CoreSizeCardData(
                  id: '1',
                  values: ['47.24in', '94.49in'],
                ),
              ),
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
