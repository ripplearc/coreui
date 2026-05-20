import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('CoreSuggestionArea Widget Tests', () {
    testWidgets('renders CoreSuggestionArea with correct dimensions and margin',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
          ),
          home: const Scaffold(
            body: CoreSuggestionArea(),
          ),
        ),
      );

      final suggestionAreaFinder = find.byType(CoreSuggestionArea);
      expect(suggestionAreaFinder, findsOneWidget);

      final container = tester.widget<Container>(
        find
            .descendant(
              of: suggestionAreaFinder,
              matching: find.byType(Container),
            )
            .first,
      );

      expect(container.constraints!.minHeight, CoreSpacing.space16);
      expect(container.constraints!.maxHeight, CoreSpacing.space16);
      expect(container.alignment, AlignmentDirectional.centerStart);
      expect(container.margin,
          const EdgeInsets.symmetric(horizontal: CoreSpacing.space4));

      final size = tester.getSize(suggestionAreaFinder);
      expect(size.height, CoreSpacing.space16);
      expect(size.width,
          tester.view.physicalSize.width / tester.view.devicePixelRatio);
    });

    testWidgets('renders default placeholder text when none is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSuggestionArea(),
          ),
        ),
      );

      expect(
        find.text(CoreSuggestionArea.defaultSuggestionAreaPlaceholder),
        findsOneWidget,
      );
    });

    testWidgets('renders custom placeholder text when provided',
        (WidgetTester tester) async {
      const customPlaceholder = 'Select an option below to proceed';
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSuggestionArea(
              suggestionAreaPlaceholder: customPlaceholder,
            ),
          ),
        ),
      );

      expect(find.text(customPlaceholder), findsOneWidget);
      expect(
        find.text(CoreSuggestionArea.defaultSuggestionAreaPlaceholder),
        findsNothing,
      );
    });

    testWidgets('applies correct text style and color from theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSuggestionArea(),
          ),
        ),
      );

      final textFinder = find.descendant(
        of: find.byType(CoreSuggestionArea),
        matching: find.byType(Text),
      );
      expect(textFinder, findsOneWidget);

      final textWidget = tester.widget<Text>(textFinder);
      final colors = AppColorsExtension.of(
          tester.element(find.byType(CoreSuggestionArea)));
      final typography = AppTypographyExtension.of(
          tester.element(find.byType(CoreSuggestionArea)));

      expect(textWidget.style!.color, colors.textDark);
      expect(textWidget.style!.fontSize, typography.bodyMediumRegular.fontSize);
      expect(textWidget.style!.fontWeight,
          typography.bodyMediumRegular.fontWeight);
    });
  });
}
