import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreInitialAvatar – accessibility', () {
    testWidgets('exposes default semantic label derived from name',
        (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreInitialAvatar(name: 'John Doe'),
          theme: CoreTheme.light(),
        ),
      );

      // The avatar's label merges with the initial glyph ("J") in the
      // semantics tree, so assert the avatar's contribution is present.
      final semantics = tester.getSemantics(find.byType(CoreInitialAvatar));
      expect(semantics.label, contains('Avatar for John Doe'));
    });

    testWidgets('honours a custom semantic label', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreInitialAvatar(
            name: 'John Doe',
            semanticLabel: 'Owner John Doe',
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreInitialAvatar));
      expect(semantics.label, contains('Owner John Doe'));
    });

    testWidgets('meets label/contrast guidelines in both themes',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreInitialAvatar(name: 'John Doe'),
        find.byType(CoreInitialAvatar),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
      );
    });
  });
}
