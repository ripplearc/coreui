import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/src/components/preferences_sheet/preference_anchors.dart';

void main() {
  test('an anchor is created once and then reused', () {
    final anchors = PreferenceAnchors();

    final first = anchors['fractional_resolution'];

    expect(anchors['fractional_resolution'], same(first));
    expect(anchors.length, 1);
  });

  test('each row gets an anchor of its own', () {
    final anchors = PreferenceAnchors();

    expect(anchors['length_format'], isNot(same(anchors['area_format'])));
    expect(anchors.length, 2);
  });

  test('an unbuilt row has no context to scroll to', () {
    final anchors = PreferenceAnchors();

    expect(anchors.contextOf('fractional_resolution'), isNull);
  });

  test('pruning forgets the rows the caller dropped', () {
    final anchors = PreferenceAnchors();
    expect(anchors['length_format'], isNotNull);
    expect(anchors['area_format'], isNotNull);

    anchors.prune({'length_format'});

    expect(anchors.length, 1,
        reason: 'a dropped row must not keep its GlobalKey alive for as long '
            'as the sheet is open');
  });

  test('pruning leaves a surviving row on the same anchor', () {
    final anchors = PreferenceAnchors();
    final kept = anchors['length_format'];
    expect(anchors['area_format'], isNotNull);

    anchors.prune({'length_format'});

    expect(anchors['length_format'], same(kept));
  });
}
