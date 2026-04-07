part of '../../core_display_area.dart';

/// A responsive widget that displays a list of calculator chips.
///
/// It uses a [Wrap] widget to arrange chips in multiple lines if needed.
class _HistoryChips extends StatelessWidget {
  /// Creates a [_HistoryChips].
  const _HistoryChips({required this.chipsList});

  /// The list of items (chips) to be arranged in the history section.
  final List<CoreCalculatorChip> chipsList;

  /// The vertical padding for the scrollable chips area.
  static const double _verticalSpace = 10;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        reverse: true,
        padding: const EdgeInsets.symmetric(vertical: _verticalSpace),
        child: Wrap(
          spacing: CoreSpacing.space2,
          runSpacing: CoreSpacing.space2,
          children: chipsList,
        ),
      ),
    );
  }
}
