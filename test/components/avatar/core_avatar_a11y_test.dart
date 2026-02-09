import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreAvatar – accessibility', () {
    testWidgets('exposes semantic label', (tester) async {
      await setupA11yTest(tester);

      const avatar = CoreAvatar(
        radius: 24,
        backgroundColor: Colors.blue,
        semanticLabel: 'Avatar for John Doe',
      );

      await tester.pumpWidget(
        buildTestApp(avatar),
      );

      final semantics = tester.getSemantics(find.byType(CoreAvatar));
      expect(semantics.label, 'Avatar for John Doe');
    });
  });
}

