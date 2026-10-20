import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  Widget header() => SizedBox(
        width: 375,
        child: CoreSheetHeader(
          title: 'Excavator',
          subtitle: 'Metered rate',
          backSemanticLabel: 'Back',
          onBack: () {},
        ),
      );

  for (final theme in kA11yTestThemes) {
    testWidgets(
        'meets the tap target, label and contrast guidelines '
        '(${theme.brightness.name})', (tester) async {
      await setupA11yTest(tester);
      await tester.pumpWidget(buildTestApp(header(), theme: theme));

      await expectMeetsTapTargetAndLabelGuidelines(
        tester,
        find.byType(CoreSheetHeader),
      );
    });
  }

  testWidgets('announces the arrow as a button labelled Back', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(buildTestApp(header(), theme: CoreTheme.light()));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Back')),
        matchesSemantics(
          label: 'Back',
          isButton: true,
          hasTapAction: true,
          isEnabled: true,
          hasEnabledState: true,
          isFocusable: true,
          hasFocusAction: true,
        ),
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets('marks the title as a heading', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(buildTestApp(header(), theme: CoreTheme.light()));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Excavator')),
        isSemantics(label: 'Excavator', isHeader: true),
      );
    } finally {
      handle.dispose();
    }
  });
}
