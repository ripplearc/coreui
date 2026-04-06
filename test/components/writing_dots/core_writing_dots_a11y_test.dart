import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreWritingDots – accessibility', () {
    testWidgets('exposes a writing semantic label', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreWritingDots(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreWritingDots));
      expect(semantics.label, 'Writing');
    });
  });
}
