part of '../core_date_picker.dart';

class _DatePickerHeader extends StatelessWidget {
  const _DatePickerHeader({
    required this.label,
    required this.dateLabel,
  });

  final String label;
  final String dateLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: CoreSpacing.space6,
        right: CoreSpacing.space3,
        top: CoreSpacing.space4,
        bottom: CoreSpacing.space3,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundBlueLight,
        border: Border(bottom: BorderSide(color: colors.lineLight)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: typography.bodyMediumSemiBold.copyWith(
              color: colors.textDark,
            ),
          ),
          const SizedBox(height: CoreSpacing.space8),
          Text(
            dateLabel,
            style: typography.headlineLargeRegular.copyWith(
              color: colors.textHeadline,
            ),
          ),
        ],
      ),
    );
  }
}
