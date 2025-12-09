import 'package:flutter_test/flutter_test.dart';

class _NullableCounter {
  int? value;
}

void main() {
  test('uses optional operator in test (should trigger no_optional_operators_in_tests)', () {
    final counter = _NullableCounter();
    // This optional access inside a test should violate no_optional_operators_in_tests.
    expect(counter.value?.isEven, isNull);
  });
}

