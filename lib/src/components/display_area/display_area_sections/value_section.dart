part of '../core_display_area.dart';

/// A trailing-aligned section that renders the primary display value
/// at the end of the display area using headline typography.
class _ValueSection extends StatelessWidget {
  const _ValueSection(
      {required this.value, required this.hasError, required this.errorTitle});

  /// The main text value to be displayed.
  final String value;

  /// Whether the value section should display an error title instead of the [value].
  final bool hasError;

  /// The error title to display when [hasError] is true.
  final String errorTitle;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Text(
        hasError && errorTitle.isNotEmpty ? errorTitle : value,
        style:
            typography.headlineLargeSemiBold.copyWith(color: colors.textDark),
      ),
    );
  }
}
