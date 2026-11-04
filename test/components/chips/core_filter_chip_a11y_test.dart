import 'dart:ui' as ui;

import 'package:flutter/services.dart';
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

      final node = tester.getSemantics(find.byType(CoreFilterChip));
      expect(node.label, contains('Tags'));
      expect(node.flagsCollection.isButton, isTrue);
    });

    testWidgets('is read as disabled, with no button role, with no onTap', (
      tester,
    ) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          const CoreFilterChip(label: 'Tags'),
          theme: CoreTheme.light(),
        ),
      );

      final node = tester.getSemantics(find.byType(CoreFilterChip));
      expect(node.label, contains('Tags'));
      expect(node.flagsCollection.isButton, isFalse);
      expect(node.flagsCollection.isEnabled, ui.Tristate.isFalse);
    });

    testWidgets('opens with Enter after a keyboard user tabs to it', (
      tester,
    ) async {
      await setupA11yTest(tester);
      var tapCount = 0;

      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(label: 'Tags', onTap: () => tapCount++),
          theme: CoreTheme.light(),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();

      expect(tapCount, 1);
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
