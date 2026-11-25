import 'package:flutter/foundation.dart';

import 'core_display_area.dart';
import 'core_history_session_data.dart';

/// The chips a grey band is drawn behind on the tape: the part of a chain
/// that is worked first (UX Design Doc rule 4.6, "a light grey band appears
/// behind the chips").
///
/// On the first switch from + or − to × or ÷, the band sits behind every
/// chip before that × or ÷, so `2 + 3 × 4` bands `2` and `+3`. The consumer
/// works the span out from the keys and hands it over as chip indexes into
/// the tape's chip list; [CoreDisplayArea.workedFirstBand] draws it. This
/// class names the span and what a screen reader hears for it; it says
/// nothing about the order itself. The band is never saved: a session shows
/// it the same way through [CoreHistorySessionData.workedFirstBand].
///
/// [semanticsLabel] is what a screen reader hears once for the band —
/// "Worked first, 2 plus 3, equals 5" — before each chip, which stays its
/// own stop. It is the consumer's string: localisation is the caller's
/// responsibility.
///
/// A debug build refuses a span that starts below 0 or ends before it
/// starts, and an empty [semanticsLabel]. The checks are asserts, so a
/// release build takes them: there a span that ends before it starts covers
/// no chip.
@immutable
class CoreWorkedFirstBand {
  /// Creates the span from [start] to [end], both inclusive.
  const CoreWorkedFirstBand({
    required this.start,
    required this.end,
    required this.semanticsLabel,
  })  : assert(start >= 0 && end >= start,
            'A band covers at least one chip, from start to end inclusive.'),
        assert(semanticsLabel != '',
            'A band a screen reader cannot name is not announced at all.');

  /// Index of the first chip under the band, into the chip list.
  final int start;

  /// Index of the last chip under the band, inclusive.
  final int end;

  /// What a screen reader hears for the band, once.
  final String semanticsLabel;

  /// Whether the chip at [index] is under the band.
  bool covers(int index) => index >= start && index <= end;

  @override
  bool operator ==(Object other) =>
      other is CoreWorkedFirstBand &&
      other.start == start &&
      other.end == end &&
      other.semanticsLabel == semanticsLabel;

  @override
  int get hashCode => Object.hash(start, end, semanticsLabel);
}
