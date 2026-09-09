import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import 'suggestion_area_test_helpers.dart';

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
          home: Scaffold(
            body: testCoreSuggestionArea(),
          ),
        ),
      );

      final suggestionAreaFinder = find.byType(CoreSuggestionArea);
      expect(suggestionAreaFinder, findsOneWidget);

      final animatedContainer = tester.widget<AnimatedContainer>(
        find
            .descendant(
              of: suggestionAreaFinder,
              matching: find.byType(AnimatedContainer),
            )
            .first,
      );
      expect(animatedContainer.margin,
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
          home: Scaffold(
            body: testCoreSuggestionArea(),
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
          home: Scaffold(
            body: testCoreSuggestionArea(
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
          home: Scaffold(
            body: testCoreSuggestionArea(),
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
          home: Scaffold(
            body: testCoreSuggestionArea(),
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
            body: testCoreSuggestionArea(
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

      expect(find.bySemanticsLabel(testToggleSemanticsLabel), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(CoreSuggestionArea),
          matching: find.byType(AnimatedSize),
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
            body: testCoreSuggestionArea(
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

      final toggleFinder = find.bySemanticsLabel(testToggleSemanticsLabel);
      final iconWidgets = tester.widgetList<CoreIconWidget>(
        find.descendant(
          of: toggleFinder,
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
            body: testCoreSuggestionArea(
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
            body: testCoreSuggestionArea(
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

      await tester.tap(find.bySemanticsLabel(testToggleSemanticsLabel));
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
            body: testCoreSuggestionArea(
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

      await tester.tap(find.bySemanticsLabel(testToggleSemanticsLabel));
      await tester.pumpAndSettle();

      expect(find.text('AI'), findsNothing);
      expect(find.text('Conv'), findsOneWidget);
    });

    testWidgets(
        'shows only AI list without toggle when only aiSuggestions provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: testCoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'AI', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel(testToggleSemanticsLabel), findsNothing);
      expect(find.text('AI'), findsOneWidget);
    });

    testWidgets(
        'shows only Conversion list without toggle when only conversionSuggestions provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: testCoreSuggestionArea(
              conversionSuggestions: [
                SuggestionData(label: 'Conv', value: '1', onTap: () {})
              ],
            ),
          ),
        ),
      );

      expect(find.bySemanticsLabel(testToggleSemanticsLabel), findsNothing);
      expect(find.text('Conv'), findsOneWidget);
    });

    testWidgets('tapping a suggestion chip calls onTap and has semantics',
        (WidgetTester tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: testCoreSuggestionArea(
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
      await tester.pump(const Duration(seconds: 1));
      expect(tapped, isTrue);
    });

    testWidgets('renders duplicate suggestions without duplicate key exception',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: testCoreSuggestionArea(
              aiSuggestions: [
                SuggestionData(label: 'Dup', value: '1', onTap: () {}),
                SuggestionData(label: 'Dup', value: '1', onTap: () {}),
              ],
            ),
          ),
        ),
      );

      final chips = tester.widgetList<CoreChip>(find.byType(CoreChip)).toList();
      expect(chips.length, 2);
      expect(chips[0].key, isNot(equals(chips[1].key)));
    });
  });

  group('CoreSuggestionArea overflow toggle', () {
    testWidgets('expand toggle calls onExpandedChanged when collapsed',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      bool expandedChanged = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: testCoreSuggestionArea(
              aiSuggestions: List.generate(
                5,
                (index) => SuggestionData(
                  label: 'Item $index',
                  value: '$index',
                  onTap: () {},
                ),
              ),
              onExpandedChanged: (val) => expandedChanged = val,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump();

      expect(_expandToggleFinder, findsOneWidget);

      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();
      expect(expandedChanged, isTrue);
    });

    testWidgets('collapse toggle calls onExpandedChanged when expanded',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      bool expandedChanged = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: testCoreSuggestionArea(
              aiSuggestions: List.generate(
                5,
                (index) => SuggestionData(
                  label: 'Item $index',
                  value: '$index',
                  onTap: () {},
                ),
              ),
              onExpandedChanged: (val) => expandedChanged = val,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump();

      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();
      expect(expandedChanged, isTrue);

      await tester.tap(
        find.bySemanticsLabel(testCollapseToggleSemantics),
      );
      await tester.pumpAndSettle();
      expect(expandedChanged, isFalse);
    });

    testWidgets(
        'notifies onExpandedChanged when suggestions change while expanded',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const _SuggestionAreaHost(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();

      final host = tester
          .state<_SuggestionAreaHostState>(find.byType(_SuggestionAreaHost));
      expect(host.lastExpanded, isTrue);

      host.updateSuggestions([
        SuggestionData(label: 'New', value: '1', onTap: () {}),
      ]);
      await tester.pumpAndSettle();

      expect(host.lastExpanded, isFalse);
    });
  });

  group('CoreSuggestionArea suggestion kinds', () {
    test('SuggestionData defaults to the predictive kind', () {
      final data = SuggestionData(label: 'Cost:', value: '84', onTap: () {});
      expect(data.kind, SuggestionKind.predictive);
      expect(data.semanticsLabel, isNull);
    });

    testWidgets('bind offer renders the dashed outline and the suffix',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            aiSuggestions: [
              SuggestionData(
                label: 'Height:',
                value: '8ft',
                kind: SuggestionKind.bind,
                onTap: () {},
              ),
            ],
          ));

      expect(find.text('Height:'), findsOneWidget);
      expect(find.text('8ft ?'), findsOneWidget);
      final chip = tester.widget<CoreChip>(find.byType(CoreChip));
      expect(chip.outline, CoreChipOutline.dashed);
    });

    testWidgets('bind suffix follows the unit when one is given',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            aiSuggestions: [
              SuggestionData(
                label: 'Height:',
                value: '8',
                unit: 'ft',
                kind: SuggestionKind.bind,
                onTap: () {},
              ),
            ],
          ));

      expect(find.text('8'), findsOneWidget);
      expect(find.text('ft ?'), findsOneWidget);
    });

    testWidgets('bindSuffix is configurable', (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            bindSuffix: '¿?',
            aiSuggestions: [
              SuggestionData(
                label: 'Height:',
                value: '8ft',
                kind: SuggestionKind.bind,
                onTap: () {},
              ),
            ],
          ));

      expect(find.text('8ft ¿?'), findsOneWidget);
    });

    testWidgets('other kinds keep the solid outline and no suffix',
        (WidgetTester tester) async {
      const solidKinds = [
        SuggestionKind.deterministic,
        SuggestionKind.predictive,
        SuggestionKind.conversion,
      ];
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            aiSuggestions: [
              for (final kind in solidKinds)
                SuggestionData(
                  label: kind.name,
                  value: '1',
                  unit: 'ft',
                  kind: kind,
                  onTap: () {},
                ),
            ],
          ));

      final chips = tester.widgetList<CoreChip>(find.byType(CoreChip));
      expect(chips.length, solidKinds.length);
      for (final chip in chips) {
        expect(chip.outline, CoreChipOutline.solid);
        expect(chip.unit, 'ft');
      }
      expect(find.textContaining('?'), findsNothing);
    });

    testWidgets('bind offer calls onTap like any other suggestion',
        (WidgetTester tester) async {
      bool accepted = false;
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            aiSuggestions: [
              SuggestionData(
                label: 'Height:',
                value: '8ft',
                kind: SuggestionKind.bind,
                onTap: () => accepted = true,
              ),
            ],
          ));

      await tester.tap(find.byType(CoreChip));
      await tester.pump(const Duration(seconds: 1));
      expect(accepted, isTrue);
    });

    testWidgets('semanticsLabel overrides the announced chip text',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            conversionSuggestions: [
              SuggestionData(
                label: 'Conv:',
                value: '12.57',
                unit: 'yd²',
                kind: SuggestionKind.conversion,
                semanticsLabel: 'Convert to 12.57 square yards',
                onTap: () {},
              ),
            ],
          ));

      final semantics = tester.getSemantics(find.byType(CoreChip));
      expect(semantics.label, 'Convert to 12.57 square yards');
    });

    testWidgets('toggle announces the provided semantics label',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            toggleSemanticsLabel: 'Cambiar sugerencias',
            aiSuggestions: [
              SuggestionData(label: 'AI', value: '1', onTap: () {})
            ],
            conversionSuggestions: [
              SuggestionData(label: 'Conv', value: '1', onTap: () {})
            ],
          ));

      expect(find.bySemanticsLabel('Cambiar sugerencias'), findsOneWidget);
      expect(find.bySemanticsLabel(testToggleSemanticsLabel), findsNothing);
    });

    testWidgets('a kind change alone collapses an expanded area',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const _SuggestionAreaHost(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();

      final host = tester
          .state<_SuggestionAreaHostState>(find.byType(_SuggestionAreaHost));
      expect(host.lastExpanded, isTrue);

      host.updateSuggestions([
        for (final data in host.suggestions)
          SuggestionData(
            label: data.label,
            value: data.value,
            kind: SuggestionKind.bind,
            onTap: data.onTap,
          ),
      ]);
      await tester.pumpAndSettle();

      expect(host.lastExpanded, isFalse);
    });
  });

  group('CoreSuggestionArea two-row layout', () {
    List<SuggestionData> ai() => [
          SuggestionData(
            label: 'Area:',
            value: '220',
            unit: 'ft²',
            kind: SuggestionKind.deterministic,
            onTap: () {},
          ),
        ];
    List<SuggestionData> conv() => [
          SuggestionData(
            label: 'Conv:',
            value: '264',
            unit: 'in',
            kind: SuggestionKind.conversion,
            onTap: () {},
          ),
        ];

    test('layout defaults to toggle so existing callers are unchanged', () {
      expect(testCoreSuggestionArea().layout, CoreSuggestionLayout.toggle);
      expect(testCoreSuggestionArea().secondRowHidden, isFalse);
    });

    testWidgets('shows both lists at once with no toggle',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            layout: CoreSuggestionLayout.twoRows,
            aiSuggestions: ai(),
            conversionSuggestions: conv(),
          ));

      expect(find.text('Area:'), findsOneWidget);
      expect(find.text('Conv:'), findsOneWidget);
      expect(find.bySemanticsLabel(testToggleSemanticsLabel), findsNothing);
      expect(
        tester.getTopLeft(find.text('Conv:')).dy,
        greaterThan(tester.getBottomLeft(find.text('Area:')).dy),
        reason: 'conversions sit on their own row below the primary row',
      );
    });

    testWidgets('a single list renders as a single row',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            layout: CoreSuggestionLayout.twoRows,
            conversionSuggestions: conv(),
          ));

      expect(find.text('Conv:'), findsOneWidget);
      expect(find.byType(CoreChip), findsOneWidget);
      expect(
        find.text(CoreSuggestionArea.defaultSuggestionAreaPlaceholder),
        findsNothing,
      );
    });

    testWidgets('secondRowHidden folds the conversions row away and back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const _TwoRowHost(),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Conv:'), findsOneWidget);

      final host = tester.state<_TwoRowHostState>(find.byType(_TwoRowHost));
      host.setSecondRowHidden(true);
      await tester.pumpAndSettle();

      expect(find.text('Area:'), findsOneWidget);
      expect(find.text('Conv:'), findsNothing);

      host.setSecondRowHidden(false);
      await tester.pumpAndSettle();
      expect(find.text('Conv:'), findsOneWidget);
    });

    testWidgets('the conversions row animates over the shared duration',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const _TwoRowHost(),
        ),
      );
      await tester.pumpAndSettle();
      final convHeightBefore =
          tester.getSize(find.byType(CoreChip).last).height;

      final host = tester.state<_TwoRowHostState>(find.byType(_TwoRowHost));
      host.setSecondRowHidden(true);
      await tester.pump();
      await tester.pump(CoreSuggestionArea.animationDuration ~/ 2);

      final areaHeightMidway = tester.getSize(find.byType(CoreSuggestionArea));
      expect(find.text('Conv:'), findsNothing,
          reason: 'the row content is gone as soon as it is hidden');
      expect(areaHeightMidway.height, greaterThan(convHeightBefore),
          reason: 'midway through the fold the area is still taller than one '
              'row, so the second row is shrinking rather than snapping');

      await tester.pumpAndSettle();
      expect(tester.getSize(find.byType(CoreSuggestionArea)).height,
          lessThan(areaHeightMidway.height));
      expect(CoreSuggestionArea.animationDuration,
          const Duration(milliseconds: 300));
    });

    testWidgets('secondRowHidden with only conversions shows the placeholder',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            layout: CoreSuggestionLayout.twoRows,
            secondRowHidden: true,
            conversionSuggestions: conv(),
          ));

      expect(find.byType(CoreChip), findsNothing);
      expect(
        find.text(CoreSuggestionArea.defaultSuggestionAreaPlaceholder),
        findsOneWidget,
      );
    });

    testWidgets('secondRowHidden is ignored in the toggle layout',
        (WidgetTester tester) async {
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            secondRowHidden: true,
            conversionSuggestions: conv(),
          ));

      expect(find.text('Conv:'), findsOneWidget);
    });

    testWidgets('each row overflows independently',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      bool? lastExpanded;
      await pumpSuggestionArea(
          tester,
          testCoreSuggestionArea(
            layout: CoreSuggestionLayout.twoRows,
            onExpandedChanged: (value) => lastExpanded = value,
            aiSuggestions: List.generate(
              5,
              (index) => SuggestionData(
                label: 'Smart $index',
                value: '$index',
                onTap: () {},
              ),
            ),
            conversionSuggestions: List.generate(
              5,
              (index) => SuggestionData(
                label: 'Conv $index',
                value: '$index',
                kind: SuggestionKind.conversion,
                onTap: () {},
              ),
            ),
          ));
      await tester.pumpAndSettle();
      await tester.pump();

      expect(_expandToggleFinder, findsNWidgets(2));

      await tester.tap(_expandToggleFinder.first);
      await tester.pumpAndSettle();

      expect(lastExpanded, isTrue);
      expect(find.bySemanticsLabel(testCollapseToggleSemantics), findsOneWidget,
          reason: 'only the primary row expanded');
      expect(_expandToggleFinder, findsOneWidget,
          reason: 'the conversions row still offers its own expand toggle');
      expect(tester.getTopLeft(find.text('Smart 1')).dy, greaterThan(0));
      expect(tester.getTopLeft(find.text('Conv 1')).dy, lessThan(0),
          reason: 'the conversions row is still collapsed');

      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('Conv 1')).dy, greaterThan(0));
      expect(
          find.bySemanticsLabel(testCollapseToggleSemantics), findsNWidgets(2));

      await tester
          .tap(find.bySemanticsLabel(testCollapseToggleSemantics).first);
      await tester.pumpAndSettle();
      expect(lastExpanded, isTrue,
          reason: 'still expanded while the other row is open');

      await tester.tap(find.bySemanticsLabel(testCollapseToggleSemantics));
      await tester.pumpAndSettle();
      expect(lastExpanded, isFalse);
    });

    testWidgets('a suggestion change collapses both rows',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(200, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const _TwoRowHost(overflow: true),
        ),
      );
      await tester.pumpAndSettle();
      await tester.pump();

      await tester.tap(_expandToggleFinder.first);
      await tester.pumpAndSettle();
      await tester.tap(_expandToggleFinder);
      await tester.pumpAndSettle();

      final host = tester.state<_TwoRowHostState>(find.byType(_TwoRowHost));
      expect(host.lastExpanded, isTrue);
      expect(
          find.bySemanticsLabel(testCollapseToggleSemantics), findsNWidgets(2));

      host.replaceSuggestions();
      await tester.pumpAndSettle();

      expect(host.lastExpanded, isFalse);
      expect(find.bySemanticsLabel(testCollapseToggleSemantics), findsNothing);
    });
  });
}

class _TwoRowHost extends StatefulWidget {
  const _TwoRowHost({this.overflow = false});

  final bool overflow;

  @override
  State<_TwoRowHost> createState() => _TwoRowHostState();
}

class _TwoRowHostState extends State<_TwoRowHost> {
  bool secondRowHidden = false;
  bool? lastExpanded;
  int generation = 0;

  void setSecondRowHidden(bool hidden) {
    setState(() => secondRowHidden = hidden);
  }

  void replaceSuggestions() {
    setState(() => generation++);
  }

  List<SuggestionData> _list(String prefix) => List.generate(
        widget.overflow ? 5 : 1,
        (index) => SuggestionData(
          label: '$prefix${widget.overflow ? ' $index' : ''}',
          value: '$generation',
          onTap: () {},
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: testCoreSuggestionArea(
        layout: CoreSuggestionLayout.twoRows,
        secondRowHidden: secondRowHidden,
        aiSuggestions: _list('Area:'),
        conversionSuggestions: _list('Conv:'),
        onExpandedChanged: (expanded) => lastExpanded = expanded,
      ),
    );
  }
}

final _expandToggleFinder = find.bySemanticsLabel(
  RegExp(r'Show \d+ more suggestions'),
);

class _SuggestionAreaHost extends StatefulWidget {
  const _SuggestionAreaHost();

  @override
  State<_SuggestionAreaHost> createState() => _SuggestionAreaHostState();
}

class _SuggestionAreaHostState extends State<_SuggestionAreaHost> {
  List<SuggestionData> suggestions = List.generate(
    5,
    (index) => SuggestionData(
      label: 'Item $index',
      value: '$index',
      onTap: () {},
    ),
  );

  bool? lastExpanded;

  void updateSuggestions(List<SuggestionData> next) {
    setState(() => suggestions = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: testCoreSuggestionArea(
        aiSuggestions: suggestions,
        onExpandedChanged: (expanded) => lastExpanded = expanded,
      ),
    );
  }
}
