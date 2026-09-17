import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// Showcase for [CorePreferencesSheet] and [CorePreferenceOptionSheet],
/// seeded with the calculator's fourteen preferences (UX design doc,
/// Appendix C).
///
/// The second button deep-links straight to Fractional resolution, the path a
/// tapped fraction in a result takes.
class PreferencesSheetShowcaseScreen extends StatefulWidget {
  const PreferencesSheetShowcaseScreen({super.key});

  @override
  State<PreferencesSheetShowcaseScreen> createState() =>
      _PreferencesSheetShowcaseScreenState();
}

class _PreferencesSheetShowcaseScreenState
    extends State<PreferencesSheetShowcaseScreen> {
  /// The option in force for every row, keyed by preference key. The sheet
  /// holds no state of its own, so the showcase plays the part of the store.
  final Map<String, String> _selected = {
    'system_of_units': 'imperial',
    'fractional_resolution': '1/16',
    'fractional_mode': 'std',
    'length_format': 'in',
    'area_format': 'std',
    'volume_format': 'std',
    'weight_format': 'std',
    'density_unit': 'lbs_yd3',
    'pounds_per_ton': '2000',
    'thousands_separator': 'off',
    'meter_decimals': '0.00',
    'millimeter_decimals': '0',
    'degree_display': '0.00',
    'strip_layout': 'two_rows',
    'edit_past_entry': 'keep',
  };

  static const Map<String, List<CorePreferenceOption>> _options = {
    'system_of_units': [
      CorePreferenceOption(id: 'imperial', label: 'Imperial'),
      CorePreferenceOption(id: 'metric', label: 'Metric'),
    ],
    'fractional_resolution': [
      CorePreferenceOption(id: '1/2', label: '1/2'),
      CorePreferenceOption(id: '1/4', label: '1/4'),
      CorePreferenceOption(id: '1/8', label: '1/8'),
      CorePreferenceOption(id: '1/16', label: '1/16'),
      CorePreferenceOption(id: '1/32', label: '1/32'),
      CorePreferenceOption(id: '1/64', label: '1/64'),
    ],
    'fractional_mode': [
      CorePreferenceOption(id: 'std', label: 'std: nearest fraction'),
    ],
    'length_format': [
      CorePreferenceOption(id: 'std', label: 'std (ft-in)'),
      CorePreferenceOption(id: 'in', label: 'in'),
      CorePreferenceOption(id: 'ft', label: 'ft'),
      CorePreferenceOption(id: 'yd', label: 'yd'),
      CorePreferenceOption(id: 'm', label: 'm'),
      CorePreferenceOption(id: 'mm', label: 'mm'),
    ],
    'density_unit': [
      CorePreferenceOption(id: 'lbs_yd3', label: 'lbs/yd³'),
      CorePreferenceOption(id: 'lbs_ft3', label: 'lbs/ft³'),
      CorePreferenceOption(id: 'tons_yd3', label: 'tons/yd³'),
      CorePreferenceOption(id: 'kg_m3', label: 'kg/m³'),
    ],
    'pounds_per_ton': [
      CorePreferenceOption(id: '2000', label: '2,000 lb (US short ton)'),
      CorePreferenceOption(id: '2240', label: '2,240 lb (long ton)'),
    ],
    'meter_decimals': [
      CorePreferenceOption(id: '0.0', label: '0.0'),
      CorePreferenceOption(id: '0.00', label: '0.00'),
      CorePreferenceOption(id: '0.000', label: '0.000'),
    ],
    'millimeter_decimals': [
      CorePreferenceOption(id: '0', label: '0'),
      CorePreferenceOption(id: '0.0', label: '0.0'),
      CorePreferenceOption(id: '0.00', label: '0.00'),
      CorePreferenceOption(id: '0.000', label: '0.000'),
    ],
    'strip_layout': [
      CorePreferenceOption(id: 'two_rows', label: 'Two rows (default)'),
      CorePreferenceOption(id: 'toggle', label: 'Toggle switch'),
    ],
    'edit_past_entry': [
      CorePreferenceOption(id: 'keep', label: 'Keep results and recompute'),
      CorePreferenceOption(
        id: 'remove',
        label: 'Remove what follows + Undo',
      ),
    ],
  };

  // Label of the option in force, used as the row's current value.
  String _labelFor(String key) {
    final options = _options[key] ?? const [];
    for (final option in options) {
      if (option.id == _selected[key]) return option.label;
    }
    return _selected[key] ?? '';
  }

  CorePreferenceRow _row(
    String key,
    String label, {
    bool isMuted = false,
    CorePreferenceInfo? info,
  }) {
    return CorePreferenceRow(
      key: key,
      label: label,
      value: CorePreferenceTextValue(_labelFor(key), isMuted: isMuted),
      options: _options[key] ?? const [],
      selectedOptionId: _selected[key],
      info: info,
    );
  }

  CorePreferenceRow _pillRow(String key, String label, {required bool isOn}) {
    return CorePreferenceRow(
      key: key,
      label: label,
      value: CorePreferencePillValue(_labelFor(key), isOn: isOn),
      options: _options[key] ?? const [],
      selectedOptionId: _selected[key],
    );
  }

  List<CorePreferenceSection> get _sections => [
        CorePreferenceSection(
          rows: [_pillRow('system_of_units', 'System of units', isOn: true)],
        ),
        CorePreferenceSection(
          title: 'Display',
          rows: [
            _row('fractional_resolution', 'Fractional resolution'),
            _row('fractional_mode', 'Fractional mode', isMuted: true),
            _row('length_format', 'Length display format'),
            _row('area_format', 'Area display format', isMuted: true),
            _row('volume_format', 'Volume display format', isMuted: true),
            _row('weight_format', 'Weight display format', isMuted: true),
            _row('density_unit', 'Density display unit'),
            _row('pounds_per_ton', 'Pounds per ton'),
            _pillRow('thousands_separator', 'Thousands separator', isOn: false),
            _row(
              'meter_decimals',
              'Meter length display',
              info: const CorePreferenceInfo(
                title: 'Meter length display',
                description: 'Changes the number of decimal places meter '
                    'values are displayed',
                semanticsLabel: 'About meter length display',
                closeLabel: 'Close',
              ),
            ),
            _row('millimeter_decimals', 'Millimeter length display'),
            _row('degree_display', 'Degree display', isMuted: true),
          ],
        ),
        CorePreferenceSection(
          title: 'Suggestions',
          rows: [
            _row('strip_layout', 'Suggestion strip layout'),
            _row('edit_past_entry', 'Edit a past entry'),
          ],
        ),
      ];

  void _openPreferences({String? initialKey}) {
    CoreQuickSheet.show<void>(
      context: context,
      child: StatefulBuilder(
        // The sheet is rebuilt with the new value the moment the store
        // changes, which is what a real consumer's state management does.
        builder: (_, setSheetState) => CorePreferencesSheet(
          title: 'Preferences',
          sections: _sections,
          initialKey: initialKey,
          optionUpdateLabel: 'Update',
          optionBackSemanticsLabel: 'Back to preferences',
          onChanged: (key, optionId) {
            setState(() => _selected[key] = optionId);
            setSheetState(() {});
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences Sheet')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: _openPreferences,
              child: const Text('Open preferences'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            ElevatedButton(
              onPressed: () =>
                  _openPreferences(initialKey: 'fractional_resolution'),
              child: const Text('Deep-link to Fractional resolution'),
            ),
            const SizedBox(height: CoreSpacing.space4),
            ElevatedButton(
              onPressed: () => _openPreferences(initialKey: 'edit_past_entry'),
              child: const Text('Deep-link to the last row'),
            ),
          ],
        ),
      ),
    );
  }
}
