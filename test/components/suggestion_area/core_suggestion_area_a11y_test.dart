import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';
import 'suggestion_area_test_helpers.dart';

Future<void> setTestViewport(WidgetTester tester) async {
  addTearDown(() => tester.view.resetPhysicalSize());

  tester.view.physicalSize = const ui.Size(1100, 1600);
}

final _expandToggleFinder = find.bySemanticsLabel(
  RegExp(r'Show \d+ more suggestions'),
);

final _conversionsExpandToggleFinder = find.bySemanticsLabel(
  RegExp(r'Show \d+ more conversions'),
);

void main() {
  group('CoreSuggestionArea – accessibility', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => testCoreSuggestionArea(),
        find.byType(CoreSuggestionArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('placeholder text meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => testCoreSuggestionArea(),
        find.byType(CoreSuggestionArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    testWidgets('placeholder text is readable by screen readers',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: testCoreSuggestionArea(),
          ),
        ),
      );

      final textFinder =
          find.text(CoreSuggestionArea.defaultSuggestionAreaPlaceholder);

      expect(textFinder, findsOneWidget);

      final semantics = tester.getSemantics(textFinder);

      expect(
          semantics.label, CoreSuggestionArea.defaultSuggestionAreaPlaceholder);
    });
  });

  group('CoreSuggestionArea with AI toggle – accessibility', () {
    final suggestionAreaWithToggle = testCoreSuggestionArea(
      aiSuggestions: [SuggestionData(label: 'AI', value: '1', onTap: () {})],
      conversionSuggestions: [
        SuggestionData(label: 'Conv', value: '1', onTap: () {})
      ],
    );

    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => suggestionAreaWithToggle,
        find.byType(CoreSuggestionArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('AI toggle meets tap target size guidelines',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => suggestionAreaWithToggle,
        find.bySemanticsLabel(testToggleSemanticsLabel),
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: false,
      );
    });
  });

  group('CoreSuggestionArea with single list – accessibility', () {
    final suggestionAreaWithAiOnly = testCoreSuggestionArea(
      aiSuggestions: [SuggestionData(label: 'AI', value: '1', onTap: () {})],
    );

    final suggestionAreaWithConvOnly = testCoreSuggestionArea(
      conversionSuggestions: [
        SuggestionData(label: 'Conv', value: '1', onTap: () {})
      ],
    );

    testWidgets('AI list only meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => suggestionAreaWithAiOnly,
        find.byType(CoreSuggestionArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });

    testWidgets('Conversion list only meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => suggestionAreaWithConvOnly,
        find.byType(CoreSuggestionArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });
  });

  group('CoreSuggestionArea with duplicate chips – accessibility', () {
    final suggestionAreaWithDuplicates = testCoreSuggestionArea(
      aiSuggestions: [
        SuggestionData(label: 'AI', value: '1', onTap: () {}),
        SuggestionData(label: 'AI', value: '1', onTap: () {}),
      ],
    );

    testWidgets('duplicate list meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => suggestionAreaWithDuplicates,
        find.byType(CoreSuggestionArea),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: false,
      );
    });
  });

  group('CoreSuggestionArea overflow toggle – accessibility', () {
    List<SuggestionData> overflowSuggestions() => List.generate(
          8,
          (index) => SuggestionData(
              label: 'Item $index', value: '$index', onTap: () {}),
        );

    testWidgets('collapsed expand toggle meets tap target and label guidelines',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const ui.Size(200, 800));

      addTearDown(() => tester.binding.setSurfaceSize(null));

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => SizedBox(
          width: 200,
          child: testCoreSuggestionArea(aiSuggestions: overflowSuggestions()),
        ),
        _expandToggleFinder,
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: false,
      );
    });

    testWidgets(
        'expanded collapse toggle meets tap target and label guidelines',
        (WidgetTester tester) async {
      await setupA11yTest(
        tester,
        screenSize: const ui.Size(200, 800),
      );
      await tester.pumpWidget(
        buildTestApp(
          testCoreSuggestionArea(
            aiSuggestions: overflowSuggestions(),
          ),
          theme: CoreTheme.light(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump();
      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();

      await expectMeetsTapTargetAndLabelGuidelines(
        tester,
        find.bySemanticsLabel(testCollapseToggleSemantics),
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: false,
      );
    });
  });

  group('CoreSuggestionArea bind offer – accessibility', () {
    CoreSuggestionArea bindArea() => testCoreSuggestionArea(
          aiSuggestions: [
            SuggestionData(
              label: 'Height:',
              value: '8ft',
              kind: SuggestionKind.bind,
              onTap: () {},
            ),
          ],
        );

    testWidgets('bind chip meets tap target, label and contrast guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => bindArea(),
        find.byType(CoreChip),
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: true,
      );
    });

    testWidgets('bind chip announces its label, value and suffix',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await pumpSuggestionArea(tester, bindArea());

      final semantics = tester.getSemantics(find.byType(CoreChip));
      expect(semantics.label, 'Height: 8ft ?');
      expect(semantics.flagsCollection.isButton, isTrue);
    });
  });

  group('CoreSuggestionArea two-row layout – accessibility', () {
    CoreSuggestionArea twoRowArea() => testCoreSuggestionArea(
          layout: CoreSuggestionLayout.twoRows,
          aiSuggestions: [
            SuggestionData(
              label: 'Area:',
              value: '220',
              unit: 'ft²',
              kind: SuggestionKind.deterministic,
              onTap: () {},
            ),
          ],
          conversionSuggestions: [
            SuggestionData(
              label: 'Conv:',
              value: '264',
              unit: 'in',
              kind: SuggestionKind.conversion,
              onTap: () {},
            ),
          ],
        );

    testWidgets('both rows meet tap target, label and contrast guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => twoRowArea(),
        find.byType(CoreSuggestionArea),
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: true,
      );
    });

    testWidgets('no toggle is announced in the two-row layout',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);

      await pumpSuggestionArea(tester, twoRowArea());

      expect(find.bySemanticsLabel(testToggleSemanticsLabel), findsNothing);
      expect(find.byType(CoreChip), findsNWidgets(2));
    });

    testWidgets('each row announces its own overflow controls',
        (WidgetTester tester) async {
      await setupA11yTest(
        tester,
        screenSize: const ui.Size(200, 600),
      );

      List<SuggestionData> overflow(String prefix, SuggestionKind kind) =>
          List.generate(
            5,
            (index) => SuggestionData(
              label: '$prefix $index',
              value: '$index',
              kind: kind,
              onTap: () {},
            ),
          );

      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            layout: CoreSuggestionLayout.twoRows,
            aiSuggestions: overflow('Smart', SuggestionKind.predictive),
            conversionSuggestions: overflow('Conv', SuggestionKind.conversion),
          ));
      await tester.pumpAndSettle();

      expect(_expandToggleFinder, findsOneWidget);
      expect(_conversionsExpandToggleFinder, findsOneWidget);

      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();
      await tester.tap(_conversionsExpandToggleFinder);
      await tester.pumpAndSettle();

      expect(
          find.bySemanticsLabel(testCollapseToggleSemantics), findsOneWidget);
      expect(find.bySemanticsLabel(testConversionsCollapseToggleSemantics),
          findsOneWidget);
    });
  });
}
