part of '../core_date_picker.dart';

class _DatePickerActionButton extends StatelessWidget {
  const _DatePickerActionButton({
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        minimumSize: const Size(0, CoreSpacing.space10),
        padding: const EdgeInsets.symmetric(
          horizontal: CoreSpacing.space3,
          vertical: CoreSpacing.space2,
        ),
        shape: const StadiumBorder(),
      ),
      child: Text(
        label,
        style: typography.bodyMediumMedium.copyWith(color: colors.textLink),
      ),
    );
  }
}
