import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

Future<void> setTestViewport(WidgetTester tester) async {
  addTearDown(() => tester.view.resetPhysicalSize());
  tester.view.physicalSize = const ui.Size(1100, 1600);
}

void main() {
  group('DisplayArea – accessibility', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('close icon has correct semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              onClose: () {},
            ),
          ),
        ),
      );

      final closeIconFinder = find.byType(CoreIconWidget);
      expect(closeIconFinder, findsOneWidget);

      final semantics = tester.getSemantics(closeIconFinder);
      expect(semantics.label, CoreDisplayArea.defaultCloseSemanticLabel);
      expect(semantics.hasFlag(ui.SemanticsFlag.isButton), isTrue);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreDisplayArea(onClose: () {}),
        closeIconFinder,
        checkTapTargetSize: true,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('history chips expose correct semantic labels',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              chipsList: [
                CoreCalculatorChip(
                  label: 'Length',
                  value: '16ft 14in',
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: 'Width',
                  value: '10ft',
                  type: CoreCalculatorChipType.active,
                ),
              ],
            ),
          ),
        ),
      );

      final chipFinder = find.byType(CoreCalculatorChip);
      expect(chipFinder, findsNWidgets(2));

      final firstChipSemantics = tester.getSemantics(chipFinder.first);
      expect(firstChipSemantics.label, 'Length, 16ft 14in');
      expect(firstChipSemantics.hasFlag(ui.SemanticsFlag.isButton), isTrue);
    });

    testWidgets('history chips meet accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(
          chipsList: [
            CoreCalculatorChip(
              label: 'Length',
              value: '16ft 14in',
              type: CoreCalculatorChipType.editable,
            ),
            CoreCalculatorChip(
              label: 'Length',
              value: '16ft 14in',
              type: CoreCalculatorChipType.active,
            ),
          ],
        ),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('placeholder text is visible when history is empty',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(),
          ),
        ),
      );

      expect(
        find.text(CoreDisplayArea.defaultHistoryPlaceholder),
        findsOneWidget,
      );
    });

    testWidgets('empty state meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('label meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(label: 'Current Total'),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('typing indicator exposes correct semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(isTyping: true),
          ),
        ),
      );
      await tester.pump();

      final writingIndicator = find.byType(CoreWritingDots);
      expect(writingIndicator, findsOneWidget);

      final semantics = tester.getSemantics(writingIndicator);
      expect(semantics.label, 'Writing');
    });

    testWidgets('value meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(value: '1234.56'),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('error state meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(
          hasError: true,
          errorMessage: 'Dimension Error',
          errorTitle: 'Error',
          value: '123.45',
        ),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('error message in history chips exposes correct semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      const errorMessage = 'Dimension Error';
      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              chipsList: [
                CoreCalculatorChip(
                  label: 'Length',
                  value: '16ft',
                  type: CoreCalculatorChipType.editable,
                ),
              ],
              hasError: true,
              errorMessage: errorMessage,
            ),
          ),
        ),
      );

      final errorSemantics = tester.getSemantics(find.text(errorMessage));
      expect(errorSemantics.label, errorMessage);
    });

    testWidgets('error title in value section exposes correct semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      const errorTitle = 'Error';
      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              hasError: true,
              errorTitle: errorTitle,
            ),
          ),
        ),
      );

      final errorTitleSemantics = tester.getSemantics(find.text(errorTitle));
      expect(errorTitleSemantics.label, errorTitle);
    });

    testWidgets('dependent key button meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(
          dependentKeyLabel: 'O.C',
          dependentKeyValue: '16in',
        ),
        find.byType(CoreButton),
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: true,
      );
    });

    testWidgets('dependent key button exposes correct semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              dependentKeyLabel: 'O.C',
              dependentKeyValue: '16in',
              onPressedDependentKey: () {},
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(CoreButton);
      expect(buttonFinder, findsOneWidget);

      final semantics = tester.getSemantics(buttonFinder);
      expect(semantics.label, contains('O.C: 16in'));
      expect(semantics.hasFlag(ui.SemanticsFlag.isButton), isTrue);
    });

    testWidgets('expandedPrevious state meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);
      await setupA11yTest(tester);

      for (final theme in kA11yTestThemes) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: const Scaffold(
              body: CoreDisplayArea(
                previousSessions: [
                  CoreHistorySessionData(
                    dateLabel: 'Previous',
                    chipsList: [],
                    value: '100',
                  ),
                ],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.fling(
            find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
        await tester.pumpAndSettle();

        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byType(CoreDisplayArea),
          checkTapTargetSize: false,
          checkLabeledTapTarget: false,
          checkTextContrast: true,
        );
      }
    });

    testWidgets('fullScreen state meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);
      await setupA11yTest(tester);

      for (final theme in kA11yTestThemes) {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: const Scaffold(
              body: CoreDisplayArea(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        await tester.fling(
            find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
        await tester.pumpAndSettle();
        await tester.fling(
            find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
        await tester.pumpAndSettle();

        await expectMeetsTapTargetAndLabelGuidelines(
          tester,
          find.byType(CoreDisplayArea),
          checkTapTargetSize: false,
          checkLabeledTapTarget: false,
          checkTextContrast: true,
        );
      }
    });

    testWidgets('revealed previous sessions are readable by screen readers',
        (WidgetTester tester) async {
      await setTestViewport(tester);
      await setupA11yTest(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              previousSessions: [
                CoreHistorySessionData(
                  dateLabel: 'Oct 20, 2026',
                  chipsList: [],
                  value: '42.0',
                ),
              ],
            ),
          ),
        ),
      );

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();

      expect(find.text('Oct 20, 2026'), findsOneWidget);
      expect(find.text('42.0'), findsOneWidget);

      final dateSemantics = tester.getSemantics(find.text('Oct 20, 2026'));
      expect(dateSemantics.label, 'Oct 20, 2026');

      final valueSemantics = tester.getSemantics(find.text('42.0'));
      expect(valueSemantics.label, '42.0');
    });
  });
}
