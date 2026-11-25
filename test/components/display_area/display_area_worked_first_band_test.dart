import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// The grey band behind the part of a chain that is worked first (CA-1479,
/// UX Design Doc rule 4.6).
void main() {
  const label = 'Worked first, 2 plus 3, equals 5';

  CoreWorkedFirstBand band({
    int start = 0,
    int end = 1,
    String semanticsLabel = label,
  }) =>
      CoreWorkedFirstBand(
        start: start,
        end: end,
        semanticsLabel: semanticsLabel,
      );

  group('CoreWorkedFirstBand', () {
    test('covers the chips from start to end inclusive', () {
      final span = band(start: 1, end: 2);
      expect(span.covers(0), isFalse);
      expect(span.covers(1), isTrue);
      expect(span.covers(2), isTrue);
      expect(span.covers(3), isFalse);
    });

    test('no span covers an index below 0', () {
      expect(band().covers(-1), isFalse);
    });

    test('a span that starts and ends on one chip covers that chip alone', () {
      final span = band(start: 2, end: 2);
      expect(span.covers(1), isFalse);
      expect(span.covers(2), isTrue);
      expect(span.covers(3), isFalse);
    });

    test('two bands built apart with the same span and label are equal', () {
      final first = band();
      final second = band();
      expect(identical(first, second), isFalse,
          reason: 'the two must be different objects, or equality is not '
              'what makes them equal');
      expect(first, second);
      expect(first.hashCode, second.hashCode);
    });

    test('a different start, end or label makes a different band', () {
      expect(band(), isNot(band(start: 1)));
      expect(band(), isNot(band(end: 2)));
      expect(band(), isNot(band(semanticsLabel: 'Worked first')));
    });

    test('a debug build refuses a span that ends before it starts', () {
      expect(() => band(start: 2, end: 1), throwsAssertionError);
    });

    test('a debug build refuses a span that starts below 0', () {
      expect(() => band(start: -1, end: 0), throwsAssertionError);
    });

    test('a debug build refuses an empty label', () {
      expect(() => band(semanticsLabel: ''), throwsAssertionError);
    });
  });
}
