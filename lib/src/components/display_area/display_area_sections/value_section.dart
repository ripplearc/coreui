part of '../core_display_area.dart';

/// A trailing-aligned section that renders the primary display value
/// at the end of the display area using headline typography.
class _ValueSection extends StatelessWidget {
  const _ValueSection({
    required this.value,
    required this.hasError,
    required this.errorTitle,
    required this.dependentKeyLabel,
    required this.dependentKeyValue,
    this.onPressedDependentKey,
  });

  /// The main text value to be displayed.
  final String value;

  /// Whether the value section should display an error title instead of the [value].
  final bool hasError;

  /// The error title to display when [hasError] is true.
  final String errorTitle;

  /// The descriptive label for the dependent key (e.g., "O.C").
  /// This is automatically formatted with a colon if not already present.
  final String dependentKeyLabel;

  /// The primary value associated with the dependent key (e.g., "16in").
  final String dependentKeyValue;

  /// Callback triggered when the dependent key button is pressed.
  /// If null, the button will be rendered in a disabled state.
  final VoidCallback? onPressedDependentKey;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    final String formattedLabel = dependentKeyLabel.isEmpty
        ? ''
        : dependentKeyLabel.trimRight().endsWith(':')
            ? '${dependentKeyLabel.trimRight()} '
            : '${dependentKeyLabel.trimRight()}: ';

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            hasError && errorTitle.isNotEmpty ? errorTitle : value,
            style: typography.headlineLargeSemiBold
                .copyWith(color: colors.textDark),
          ),
          if (dependentKeyLabel.isNotEmpty || dependentKeyValue.isNotEmpty)
            CoreButton(
              onPressed: onPressedDependentKey,
              semanticsLabel: '$formattedLabel$dependentKeyValue',
              size: CoreButtonSize.medium,
              shadows: CoreShadows.small,
              variant: CoreButtonVariant.secondary,
              trailing: true,
              fullWidth: false,
              icon: CoreIconWidget(
                icon: CoreIcons.edit,
                color: colors.iconDark,
                size: CoreSpacing.space4,
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: formattedLabel,
                      style: typography.bodySmallRegular.copyWith(
                        color: colors.textBody,
                      ),
                    ),
                    TextSpan(
                      text: dependentKeyValue,
                      style: typography.bodySmallSemiBold.copyWith(
                        color: colors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
