import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreFilterChip – accessibility', () {
    testWidgets('exposes semantic label and button role when enabled', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(label: 'Tags', onTap: () {}),
          theme: CoreTheme.light(),
        ),
      );

      final node = tester.getSemantics(
        find
            .descendant(
              of: find.byType(CoreFilterChip),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(node.label, contains('Tags'));
      expect(node.hasFlag(SemanticsFlag.isButton), isTrue);
    });

    testWidgets('does not expose button role when disabled', (tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreFilterChip(label: 'Tags'),
          theme: CoreTheme.light(),
        ),
      );

      final node = tester.getSemantics(
        find
            .descendant(
              of: find.byType(CoreFilterChip),
              matching: find.byType(Semantics),
            )
            .first,
      );
      expect(node.label, contains('Tags'));
      expect(node.hasFlag(SemanticsFlag.isButton), isFalse);
    });

    testWidgets('meets tap target and contrast guidelines in both themes', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreFilterChip(label: 'Tags', onTap: () {}),
        find.byType(CoreFilterChip),
      );
    });
  });
}
