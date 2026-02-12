import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreAvatar – accessibility', () {
    testWidgets('exposes semantic label', (tester) async {
      await setupA11yTest(tester);

      final colors = AppColorsExtension.create();
      final avatar = CoreAvatar(
        radius: 24,
        backgroundColor: colors.iconBlue,
        semanticLabel: 'Avatar for John Doe',
      );

      await tester.pumpWidget(
        buildTestApp(avatar),
      );

      final semantics = tester.getSemantics(find.byType(CoreAvatar));
      expect(semantics.label, 'Avatar for John Doe');

      await expectMeetsTapTargetAndLabelGuidelines(
        tester,
        find.byType(CoreAvatar),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
      );
    });
  });
}

