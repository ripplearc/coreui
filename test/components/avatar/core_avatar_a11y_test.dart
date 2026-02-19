import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreAvatar – accessibility', () {
    testWidgets('exposes semantic label', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreAvatar(
            radius: 24,
            backgroundColor: CoreTheme.light().coreColors.iconBlue,
            semanticLabel: 'Avatar for John Doe',
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreAvatar));
      expect(semantics.label, 'Avatar for John Doe');

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreAvatar(
          radius: 24,
          backgroundColor: theme.coreColors.iconBlue,
          semanticLabel: 'Avatar for John Doe',
        ),
        find.byType(CoreAvatar),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
      );
    });
  });
}

