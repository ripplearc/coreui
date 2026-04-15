part of '../../core_display_area.dart';

/// A responsive widget that displays a list of calculator chips.
///
/// It uses a [Wrap] widget to arrange chips in multiple lines if needed.
class _HistoryChips extends StatelessWidget {
  /// Creates a [_HistoryChips].
  const _HistoryChips(
      {required this.chipsList,
      this.hasError = false,
      this.errorMessage = 'Dimension Error'});

  /// The list of items (chips) to be arranged in the history section.
  final List<CoreCalculatorChip> chipsList;

  /// The vertical padding for the scrollable chips area.
  static const double _verticalSpace = CoreSpacing.space5;

  /// Whether to display an error chip at the end of the history.
  final bool hasError;

  /// The error message to display in the error chip when [hasError] is true.
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    final colors = AppColorsExtension.of(context);
    final typography = AppTypographyExtension.of(context);
    return Expanded(
      child: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: _verticalSpace),
        child: Wrap(
          spacing: CoreSpacing.space2,
          runSpacing: CoreSpacing.space2,
          children: [
            ...chipsList,
            if (hasError)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: CoreSpacing.space2,
                  vertical: CoreSpacing.space1,
                ),
                decoration: BoxDecoration(
                  color: colors.chipRed,
                  borderRadius: BorderRadius.circular(CoreSpacing.space5),
                ),
                child: Text(
                  errorMessage,
                  style: typography.bodyMediumRegular
                      .copyWith(color: colors.textDark),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
