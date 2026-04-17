import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreFilterChip', () {
    testWidgets('renders label text', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreFilterChip(label: 'Tags'),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Tags'), findsOneWidget);
    });

    testWidgets('does not expose as button when onTap is null', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreFilterChip(label: 'Tags'),
          theme: CoreTheme.light(),
        ),
      );

      final handle = tester.ensureSemantics();
      // Use .first to target the outermost Semantics owned by this widget.
      // CoreIconWidget adds its own Semantics node internally, so the
      // descendant finder returns more than one match without the guard.
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
      handle.dispose();
    });

    testWidgets('invokes onTap when tapped and exposes semantics as button', (
      tester,
    ) async {
      var tapCount = 0;

      await tester.pumpWidget(
        buildTestApp(
          CoreFilterChip(
            label: 'Tags',
            onTap: () => tapCount++,
          ),
          theme: CoreTheme.light(),
        ),
      );

      final handle = tester.ensureSemantics();
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

      await tester.tap(find.text('Tags'));
      await tester.pump();

      expect(tapCount, 1);
      handle.dispose();
    });
  });
}
