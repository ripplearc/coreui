import '../calculator_chips/core_calculator_chip.dart';
import 'core_worked_first_band.dart';

/// Data model representing a prior calculation session in the history view.
class CoreHistorySessionData {
  const CoreHistorySessionData({
    required this.dateLabel,
    required this.chipsList,
    required this.value,
    this.id,
    this.workedFirstBand,
  });

  /// The band behind the chips the chain worked first, worked out again from
  /// the keys when the session is shown, so history shows it the same way
  /// the tape did, with no fade. Defaults to `null`, which draws none. In a
  /// card that can be restored the card is one stop for a screen reader, and
  /// [CoreWorkedFirstBand.semanticsLabel] is read as part of it, before the
  /// chips.
  final CoreWorkedFirstBand? workedFirstBand;

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
