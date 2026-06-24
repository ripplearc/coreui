part of '../core_date_picker.dart';

class _MonthSelectorRow extends StatelessWidget {
  const _MonthSelectorRow({
    required this.monthLabel,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.isPreviousEnabled,
    required this.isNextEnabled,
    required this.previousMonthSemanticLabel,
    required this.nextMonthSemanticLabel,
  });

  final String monthLabel;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool isPreviousEnabled;
  final bool isNextEnabled;
  final String previousMonthSemanticLabel;
  final String nextMonthSemanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        left: CoreSpacing.space4,
        right: CoreSpacing.space3,
        top: CoreSpacing.space1,
        bottom: CoreSpacing.space1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Semantics(
            header: true,
            child: Text(
              monthLabel,
              style: typography.bodyMediumRegular.copyWith(
                color: colors.textHeadline,
              ),
            ),
          ),
          Row(
            children: [
              Semantics(
                label: previousMonthSemanticLabel,
                button: true,
                enabled: isPreviousEnabled,
                excludeSemantics: true,
                child: CoreIconWidget(
                  icon: CoreIcons.arrowLeft,
                  size: CoreSpacing.space6,
                  color:
                      isPreviousEnabled ? colors.iconDark : colors.iconGrayLight,
                  onTap: isPreviousEnabled ? onPreviousMonth : null,
                ),
              ),
              Semantics(
                label: nextMonthSemanticLabel,
                button: true,
                enabled: isNextEnabled,
                excludeSemantics: true,
                child: CoreIconWidget(
                  icon: CoreIcons.arrowRight,
                  size: CoreSpacing.space6,
                  color: isNextEnabled ? colors.iconDark : colors.iconGrayLight,
                  onTap: isNextEnabled ? onNextMonth : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
