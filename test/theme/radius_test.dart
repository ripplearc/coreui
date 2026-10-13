import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreRadius', () {
    test('radius6 is 6 dp', () {
      expect(CoreRadius.radius6, 6.0);
    });

    test('radius8 is 8 dp', () {
      expect(CoreRadius.radius8, 8.0);
    });
  });
}
