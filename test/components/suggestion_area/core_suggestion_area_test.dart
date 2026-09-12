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
