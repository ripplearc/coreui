import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

// Violates prefer_fake_over_mock by using Mockito-based mocks.
class _Dependency extends Mock {}

void main() {
  test('uses mockito mock (should trigger prefer_fake_over_mock)', () {
    final dep = _Dependency();
    when(dep.toString()).thenReturn('mocked');
    expect(dep.toString(), 'mocked');
  });
}

