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
        find.bySemanticsLabel('Toggle suggestion mode'),
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
}
