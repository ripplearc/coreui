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

    testWidgets('shows placeholder only when lists are empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreSuggestionArea(),
          ),
        ),
      );

      expect(find.byType(Row), findsNothing);
      expect(find.byType(GestureDetector), findsNothing);
      expect(
        find.text(CoreSuggestionArea.defaultSuggestionAreaPlaceholder),
        findsOneWidget,
      );
    });

    testWidgets('shows AI toggle and lists row when data is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'AI', value: '1', onTap: () {})
              ],
              conversionSuggestions: [
                SuggestionData(label: 'Conv', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Toggle suggestion mode'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CoreSuggestionArea),
          matching: find.byType(AnimatedSwitcher),
        ),
        findsOneWidget,
      );
      expect(
        find.text(CoreSuggestionArea.defaultSuggestionAreaPlaceholder),
        findsNothing,
      );
    });

    testWidgets('AI toggle shows stars and ruler icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'AI', value: '1', onTap: () {})
              ],
              conversionSuggestions: [
                SuggestionData(label: 'Conv', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      final iconWidgets = tester.widgetList<CoreIconWidget>(
        find.descendant(
          of: find.byType(CoreSuggestionArea),
          matching: find.byType(CoreIconWidget),
        ),
      );

      expect(iconWidgets.length, 2);
      expect(
        iconWidgets.map((w) => w.icon).toList(),
        [CoreIcons.stars, CoreIcons.ruler],
      );
    });

    testWidgets('AI toggle starts in AI mode with thumb on the left',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'AI', value: '1', onTap: () {})
              ],
              conversionSuggestions: [
                SuggestionData(label: 'Conv', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      final animatedAlign = tester.widget<AnimatedAlign>(
        find.descendant(
          of: find.byType(CoreSuggestionArea),
          matching: find.byType(AnimatedAlign),
        ),
      );

      expect(animatedAlign.alignment, Alignment.centerLeft);
    });

    testWidgets('tapping AI toggle switches to conversion mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'AI', value: '1', onTap: () {})
              ],
              conversionSuggestions: [
                SuggestionData(label: 'Conv', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Toggle suggestion mode'));
      await tester.pumpAndSettle();

      final animatedAlign = tester.widget<AnimatedAlign>(
        find.descendant(
          of: find.byType(CoreSuggestionArea),
          matching: find.byType(AnimatedAlign),
        ),
      );

      expect(animatedAlign.alignment, Alignment.centerRight);
    });

    testWidgets('renders AI and conversion chips based on toggle',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'AI', value: '1', onTap: () {})
              ],
              conversionSuggestions: [
                SuggestionData(label: 'Conv', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      expect(find.text('AI'), findsOneWidget);
      expect(find.text('Conv'), findsNothing);

      await tester.tap(find.bySemanticsLabel('Toggle suggestion mode'));
      await tester.pumpAndSettle();

      expect(find.text('AI'), findsNothing);
      expect(find.text('Conv'), findsOneWidget);
    });

    testWidgets('shows only AI list without toggle when only aiSuggestions provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'AI', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Toggle suggestion mode'), findsNothing);
      expect(find.text('AI'), findsOneWidget);
    });

    testWidgets('shows only Conversion list without toggle when only conversionSuggestions provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              conversionSuggestions: [
                SuggestionData(label: 'Conv', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel('Toggle suggestion mode'), findsNothing);
      expect(find.text('Conv'), findsOneWidget);
    });

    testWidgets('tapping a suggestion chip calls onTap and has semantics',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(
                  label: 'AI',
                  value: '1',
                  onTap: () {
                    tapped = true;
                  },
                )
              ],
            ),
          ),
        ),
      );

      final chipFinder = find.descendant(
        of: find.byType(CoreSuggestionArea),
        matching: find.byType(Semantics),
      );
      expect(chipFinder, findsWidgets);

      await tester.tap(find.text('AI'));
      await tester.pumpAndSettle();
      await tester
          .pump(const Duration(seconds: 2));

      expect(tapped, isTrue);
    });
  });
}
