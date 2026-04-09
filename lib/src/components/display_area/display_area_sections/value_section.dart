part of '../core_display_area.dart';

class _ValueSection extends StatelessWidget {
  const _ValueSection({required this.value});

  /// The main text value to be displayed.
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(value,
            style: typography.headlineLargeSemiBold
                .copyWith(color: colors.textDark)),
      ],
    );
  }
}
