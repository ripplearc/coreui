import '../calculator_chips/core_calculator_chip.dart';

/// Data model representing a prior calculation session in the history view.
class CoreHistorySessionData {
  const CoreHistorySessionData({
    required this.dateLabel,
    required this.chipsList,
    required this.value,
    this.id,
  });

  /// Identifies this session to the consumer, so tapping its card can restore
  /// the tape it came from. Optional: a session with no [id] renders as a
  /// plain card that reports nothing when tapped.
  final String? id;

  /// The label describing when this session occurred (e.g., "Today", "May 27, 2025").
  final String dateLabel;

  /// The sequence of tokens/chips that produced this calculation.
  final List<CoreCalculatorChip> chipsList;

  /// The evaluated result string.
  final String value;
}
