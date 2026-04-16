import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';
import '../../utils/a11y_guidelines.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreButton Accessibility Tests', () {
    testWidgets('disabled button exposes correct semantics', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreButton(
              label: 'Click Me',
              onPressed: null,
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(CoreButton)),
        matchesSemantics(
          label: 'Click Me',
          isButton: true,
          isEnabled: false,
          hasEnabledState: true,
        ),
      );

      handle.dispose();
    });

    testWidgets('enabled button exposes correct semantics', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreButton(
              label: 'Submit',
              onPressed: () {},
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(CoreButton)),
        matchesSemantics(
          label: 'Submit',
          isButton: true,
          isEnabled: true,
          hasEnabledState: true,
        ),
      );

      handle.dispose();
    });

    testWidgets('semanticsLabel overrides label in the semantics tree',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreButton(
              semanticsLabel: 'Add Item',
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(CoreButton)),
        matchesSemantics(
          label: 'Add Item',
          isButton: true,
          isEnabled: false,
          hasEnabledState: true,
        ),
      );

      handle.dispose();
    });

    testWidgets(
        'custom child button with no semanticsLabel has no label in tree',
        (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreButton(
              child: Icon(Icons.star),
            ),
          ),
        ),
      );

      final node = tester.getSemantics(find.byType(CoreButton));
      expect(node.label, anyOf(isNull, isEmpty));

      handle.dispose();
    });

    testWidgets('large button meets a11y tap-target guidelines',
        (tester) async {
      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (_) => const Padding(
          padding: EdgeInsets.all(16),
          child: CoreButton(
            label: 'Large',
            onPressed: null,
            size: CoreButtonSize.large,
          ),
        ),
        find.byType(CoreButton),
        checkTextContrast: false,
      );
    });

    testWidgets('medium button meets a11y tap-target guidelines',
        (tester) async {
      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (_) => const Padding(
          padding: EdgeInsets.all(16),
          child: CoreButton(
            label: 'Medium',
            onPressed: null,
            size: CoreButtonSize.medium,
          ),
        ),
        find.byType(CoreButton),
        checkTextContrast: false,
      );
    });

    testWidgets('small button meets a11y tap-target guidelines',
        (tester) async {
      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (_) => const Padding(
          padding: EdgeInsets.all(16),
          child: CoreButton(
            label: 'Small',
            onPressed: null,
            size: CoreButtonSize.small,
          ),
        ),
        find.byType(CoreButton),
        checkTextContrast: false,
      );
    });

    testWidgets('primary enabled button meets contrast guidelines',
        (tester) async {
      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: CoreButton(
            label: 'Primary',
            onPressed: () {},
            variant: CoreButtonVariant.primary,
          ),
        ),
        find.byType(CoreButton),
      );
    });
  });
}
