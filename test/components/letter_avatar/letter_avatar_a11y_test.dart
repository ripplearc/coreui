import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreLetterAvatar – accessibility', () {
    testWidgets('exposes semantic label based on name', (tester) async {
      await setupA11yTest(tester);

      const name = 'Alice';

      await tester.pumpWidget(
        buildTestApp(
          const CoreLetterAvatar(name: name),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreLetterAvatar));
      expect(semantics.label, 'Letter avatar for $name');
    });
  });
}

