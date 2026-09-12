import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

import 'display_area_test_helpers.dart';

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
        (theme) => const CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
        ),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
      expect(firstChipSemantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('history chips meet accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
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
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
            ),
          ),
        ),
      );

      expect(
        find.text(testHistoryPlaceholder),
        findsOneWidget,
      );
    });

    testWidgets('empty state meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
        ),
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
        (theme) => const CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          label: 'Current Total',
        ),
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
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              isTyping: true,
            ),
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
        (theme) => const CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          value: '1234.56',
        ),
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
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              hasError: true,
              errorTitle: errorTitle,
            ),
          ),
        ),
      );

      final errorTitleSemantics = tester.getSemantics(find.text(errorTitle));
      expect(errorTitleSemantics.label, errorTitle);
    });

    testWidgets('dependent key pill exposes correct semantics',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              dependentKeys: [
                CoreDependentKeyData(
                  label: 'O.C',
                  value: '16in',
                  kind: CoreDependentKeyKind.editable,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(CoreButton);
      expect(buttonFinder, findsOneWidget);

      final semantics = tester.getSemantics(buttonFinder);
      expect(semantics.label, contains('O.C: 16in'));
      expect(semantics.flagsCollection.isButton, isTrue);
    });

    testWidgets('each dependent key kind is announced with its own label',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              value: '16in/12in',
              dependentKeys: [
                CoreDependentKeyData(
                  label: 'Rate',
                  value: '\$14.5/sheet',
                  kind: CoreDependentKeyKind.editable,
                  onPressed: () {},
                ),
                CoreDependentKeyData(
                  label: 'Shown as',
                  value: 'in/12in',
                  kind: CoreDependentKeyKind.toggle,
                  onPressed: () {},
                ),
                CoreDependentKeyData(
                  label: 'Re-input 38.30° as',
                  value: '38°30′',
                  kind: CoreDependentKeyKind.offer,
                  semanticsLabel:
                      'Re-input 38.30 degrees as 38 degrees 30 minutes',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      );

      final pills = find.byType(CoreButton);
      expect(pills, findsNWidgets(3));
      final labels = [
        for (var i = 0; i < 3; i++) tester.getSemantics(pills.at(i)).label,
      ];
      expect(labels, [
        'Rate: \$14.5/sheet',
        'Shown as: in/12in',
        'Re-input 38.30 degrees as 38 degrees 30 minutes',
      ]);
      for (var i = 0; i < 3; i++) {
        expect(
            tester.getSemantics(pills.at(i)).flagsCollection.isButton, isTrue);
      }
    });

    testWidgets('dependent key pills meet label and contrast guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreDisplayArea(
          closeSemanticLabel: testCloseSemanticLabel,
          historyPlaceholder: testHistoryPlaceholder,
          value: '\$84.25',
          dependentKeys: [
            CoreDependentKeyData(
              label: 'Rate',
              value: '\$14.5/sheet',
              kind: CoreDependentKeyKind.editable,
              onPressed: () {},
            ),
            CoreDependentKeyData(
              label: 'Shown as',
              value: 'in/12in',
              kind: CoreDependentKeyKind.toggle,
              onPressed: () {},
            ),
            CoreDependentKeyData(
              label: 'Re-input 38.30° as',
              value: '38°30′',
              kind: CoreDependentKeyKind.offer,
              onPressed: () {},
            ),
          ],
        ),
        find.byType(CoreDisplayArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: true,
        checkTextContrast: true,
      );
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
                closeSemanticLabel: testCloseSemanticLabel,
                historyPlaceholder: testHistoryPlaceholder,
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
              body: CoreDisplayArea(
                closeSemanticLabel: testCloseSemanticLabel,
                historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
