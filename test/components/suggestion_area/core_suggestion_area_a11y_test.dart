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
  group('CoreSuggestionArea – accessibility', () {
    testWidgets('meets basic accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreSuggestionArea(),
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
        (theme) => const CoreSuggestionArea(),
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
          home: const Scaffold(
            body: CoreSuggestionArea(),
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
    const suggestionAreaWithToggle = CoreSuggestionArea(isEmpty: false);

    final aiToggleFinder = find.descendant(
      of: find.byType(CoreSuggestionArea),
      matching: find.byType(GestureDetector),
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

    testWidgets('placeholder text meets accessibility guidelines',
        (WidgetTester tester) async {
      await setTestViewport(tester);

      await setupA11yTest(tester);
      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => suggestionAreaWithToggle,
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
          home: const Scaffold(
            body: suggestionAreaWithToggle,
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

    testWidgets('AI toggle meets tap target size guidelines',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => suggestionAreaWithToggle,
        aiToggleFinder,
        checkTapTargetSize: true,
        checkLabeledTapTarget: true,
        checkTextContrast: false,
      );
    });
  });
}
