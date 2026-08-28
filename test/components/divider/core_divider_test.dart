import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreDivider – sizing', () {
    testWidgets('is exactly CoreDivider.thickness tall and fills the width',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreDivider(),
          theme: CoreTheme.light(),
        ),
      );

      final dividerSize = tester.getSize(find.byType(CoreDivider));
      final scaffoldSize = tester.getSize(find.byType(Scaffold));

      expect(dividerSize.height, CoreDivider.thickness);
      expect(dividerSize.width, scaffoldSize.width);
    });

    testWidgets(
        'adds no vertical extent and stays centered as a Row label separator',
        (tester) async {
      const separatorRowKey = Key('separator_row');

      await tester.pumpWidget(
        buildTestApp(
          const Row(
            key: separatorRowKey,
            children: [
              Expanded(child: CoreDivider()),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: CoreSpacing.space2),
                child: Text('or'),
              ),
              Expanded(child: CoreDivider()),
            ],
          ),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byType(CoreDivider), findsNWidgets(2));

      // The row is sized by the text alone: a divider regressing to
      // Material's hidden 16px default height would inflate it.
      final rowHeight = tester.getSize(find.byKey(separatorRowKey)).height;
      final textHeight = tester.getSize(find.text('or')).height;
      expect(rowHeight, textHeight);

      final textCenter = tester.getRect(find.text('or')).center;
      final leftCenter = tester.getRect(find.byType(CoreDivider).first).center;
      final rightCenter = tester.getRect(find.byType(CoreDivider).last).center;

      expect(leftCenter.dy, moreOrLessEquals(textCenter.dy));
      expect(rightCenter.dy, moreOrLessEquals(textCenter.dy));
    });
  });

  group('CoreDivider – color resolution', () {
    testWidgets('defaults to lineLight in both light and dark themes',
        (tester) async {
      for (final theme in kA11yTestThemes) {
        await tester.pumpWidget(
          buildTestApp(
            const CoreDivider(),
            theme: theme,
          ),
        );
        // Let MaterialApp's AnimatedTheme finish, so Theme.of reflects this
        // iteration's theme rather than the transition from the previous one.
        await tester.pumpAndSettle();

        final divider = tester.widget<CoreDivider>(find.byType(CoreDivider));
        final context = tester.element(find.byType(CoreDivider));

        expect(divider.resolvedColor(context), theme.coreColors.lineLight);
      }
    });

    testWidgets('an explicit color overrides the theme default',
        (tester) async {
      final lineMid = CoreTheme.light().coreColors.lineMid;

      await tester.pumpWidget(
        buildTestApp(
          CoreDivider(color: lineMid),
          theme: CoreTheme.light(),
        ),
      );

      final divider = tester.widget<CoreDivider>(find.byType(CoreDivider));
      final context = tester.element(find.byType(CoreDivider));

      expect(divider.resolvedColor(context), lineMid);
    });
  });
}
