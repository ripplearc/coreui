import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreCheckRowItem – accessibility', () {
    testWidgets('unselected row meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCheckRowItem(
          title: 'John Doe',
          selected: false,
          onChanged: (_) {},
        ),
        find.byType(CoreCheckRowItem),
        // The single Semantics node on the row covers both label and tap
        // target; there is no separately-labeled tap target to check.
        checkLabeledTapTarget: false,
      );
    });

    testWidgets('selected row meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCheckRowItem(
          title: 'John Doe',
          selected: true,
          onChanged: (_) {},
        ),
        find.byType(CoreCheckRowItem),
        // The single Semantics node on the row covers both label and tap
        // target; there is no separately-labeled tap target to check.
        checkLabeledTapTarget: false,
      );
    });

    testWidgets('disabled row is announced as disabled', (tester) async {
      await setupA11yTest(tester);
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: false,
            enabled: false,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCheckRowItem));
      expect(semantics.label, 'John Doe');
      expect(semantics.flagsCollection.isEnabled, Tristate.isFalse);
      handle.dispose();
    });

    testWidgets('enabled row is announced as enabled', (tester) async {
      await setupA11yTest(tester);
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        buildTestApp(
          CoreCheckRowItem(
            title: 'John Doe',
            selected: true,
            onChanged: (_) {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCheckRowItem));
      expect(semantics.flagsCollection.isEnabled, Tristate.isTrue);
      expect(semantics.flagsCollection.isChecked, CheckedState.isTrue);
      handle.dispose();
    });
  });
}
