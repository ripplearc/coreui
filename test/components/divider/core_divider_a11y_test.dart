import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  testWidgets(
      'CoreDivider is purely decorative: nothing is announced to screen '
      'readers in either theme', (tester) async {
    final semanticsHandle = tester.ensureSemantics();
    try {
      for (final theme in kA11yTestThemes) {
        await tester.pumpWidget(
          buildTestApp(
            const CoreDivider(),
            theme: theme,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(CoreDivider), findsOneWidget);
        expect(
          find.semantics.byPredicate(
            (node) {
              final data = node.getSemanticsData();
              return data.label.isNotEmpty ||
                  data.value.isNotEmpty ||
                  data.hint.isNotEmpty ||
                  data.actions != 0;
            },
            describeMatch: (plurality) => 'announceable semantics nodes',
          ),
          findsNothing,
        );
      }
    } finally {
      semanticsHandle.dispose();
    }
  });
}
