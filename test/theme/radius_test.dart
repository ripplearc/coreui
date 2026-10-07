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

  group('CoreIconSize.size14', () {
    test('is 14 dp and the smallest icon size', () {
      expect(CoreIconSize.size14, 14.0);
      expect(CoreIconSize.size14, lessThan(CoreIconSize.size16));
    });
  });
}
