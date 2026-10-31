import 'package:flutter/material.dart';

import '../../../ripplearc_coreui.dart';

/// Renders a preference row's current value: plain text, or the outlined
/// pill with a state dot that the switch-like preferences read as. The pill
/// follows the library Setting List Switch row (Figma 66778:196399).
///
/// Internal to the preferences sheet — not exported from the package barrel.
class PreferenceValueView extends StatelessWidget {
  /// The value to render.
  final CorePreferenceValue value;

  /// Draws the value in `textDisable`, for a disabled row.
  final bool isDisabled;

  /// Creates a value view.
  const PreferenceValueView({
    super.key,
    required this.value,
    this.isDisabled = false,
  });

  /// Key of the pill's outline, for widget-test finders.
  static const Key pillKey = Key('preference_value_pill');

  /// Key of the pill's state dot, for widget-test finders.
  static const Key dotKey = Key('preference_value_dot');

  static const double _dotSize = CoreIconSize.size14;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    switch (value) {
      case CorePreferenceTextValue(:final label, :final isMuted):
        return Text(
          label,
          style: typography.bodyMediumSemiBold.copyWith(
            color: isDisabled
                ? colors.textDisable
                : isMuted
                    ? colors.textBody
                    : colors.textLink,
          ),
        );
      case CorePreferencePillValue(:final label, :final isOn):
        final accent = isOn ? colors.iconGreen : colors.iconGrayMid;
        return Container(
          key: pillKey,
          decoration: BoxDecoration(
            color: colors.pageBackground,
            borderRadius: BorderRadius.circular(CoreSpacing.space5),
            border: Border.all(color: accent),
          ),
          // A minimum, not a fixed height, so large text grows the pill.
          constraints: const BoxConstraints(minHeight: CoreSpacing.space6),
          padding: const EdgeInsets.only(
            left: CoreSpacing.space1,
            right: CoreSpacing.space3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                key: dotKey,
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: CoreSpacing.space1),
              Text(
                label,
                style: typography.bodySmallRegular.copyWith(
                  color: isDisabled
                      ? colors.textDisable
                      : isOn
                          ? colors.textSuccess
                          : colors.textBody,
                ),
              ),
            ],
          ),
        );
    }
  }
}
