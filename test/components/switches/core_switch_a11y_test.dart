import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreSwitch – accessibility', () {
    testWidgets('enabled switch can be toggled by a screen reader', (
      tester,
    ) async {
      await setupA11yTest(tester);
      final handle = tester.ensureSemantics();
      bool? received;

      await tester.pumpWidget(
        buildTestApp(
          CoreSwitch(
            type: CoreSwitchType.showHide,
            value: false,
            onChanged: (v) => received = v,
          ),
          theme: CoreTheme.light(),
        ),
      );

      final node = tester.getSemantics(find.byType(CoreSwitch));
      expect(
        node,
        isSemantics(
          label: 'Hide',
          hasEnabledState: true,
          isEnabled: true,
          hasToggledState: true,
          isToggled: false,
          hasTapAction: true,
        ),
      );

      tester.semantics.tap(find.semantics.byLabel('Hide'));
      expect(received, isTrue);
      handle.dispose();
    });

    testWidgets('disabled switch exposes no tap action', (tester) async {
      await setupA11yTest(tester);
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestApp(
          const CoreSwitch(
            type: CoreSwitchType.showHide,
            value: true,
            onChanged: null,
          ),
          theme: CoreTheme.light(),
        ),
      );

      final node = tester.getSemantics(find.byType(CoreSwitch));
      expect(
        node,
        isSemantics(
          hasEnabledState: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('meets tap target and contrast guidelines in both themes', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreSwitch(
          type: CoreSwitchType.showHide,
          value: false,
          onChanged: (_) {},
        ),
        find.byType(CoreSwitch),
      );
    });
  });
}
