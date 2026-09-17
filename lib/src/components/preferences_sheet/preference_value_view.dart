import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// Renders a preference row's current value: plain text, or the outlined
/// pill with a state dot that the switch-like preferences read as.
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceValueView extends StatelessWidget {
  /// Creates a value view.
  const PreferenceValueView({super.key, required this.value});

  final CorePreferenceValue value;

  static const double _dotSize = CoreSpacing.space2;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    switch (value) {
      case CorePreferenceTextValue(:final label, :final isMuted):
        return Text(
          label,
          style: typography.bodyLargeSemiBold.copyWith(
            color: isMuted ? colors.textDisable : colors.textLink,
          ),
        );
      case CorePreferencePillValue(:final label, :final isOn):
        final accent = isOn ? colors.iconGreen : colors.iconGrayMid;
        return Container(
          decoration: BoxDecoration(
            color: colors.pageBackground,
            borderRadius: BorderRadius.circular(CoreSpacing.space5),
            border: Border.all(color: accent),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: CoreSpacing.space3,
            vertical: CoreSpacing.space1,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: CoreSpacing.space2),
              Text(
                label,
                style: typography.bodyMediumSemiBold.copyWith(
                  color: isOn ? colors.textSuccess : colors.textBody,
                ),
              ),
            ],
          ),
        );
    }
  }
}
