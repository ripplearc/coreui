import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

void main() {
  group('DisplayArea Widget Tests', () {
    testWidgets('renders DisplayArea with correct dimensions and decoration',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light().copyWith(
            textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Roboto'),
          ),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
            ),
          ),
        ),
      );

      final displayAreaFinder = find.byType(CoreDisplayArea);
      expect(displayAreaFinder, findsOneWidget);

      final container = tester.widget<Container>(
        find
            .descendant(
              of: displayAreaFinder,
              matching: find.byType(Container),
            )
            .first,
      );

      final decoration = container.decoration as BoxDecoration;
      final colors = AppColorsExtension.of(tester.element(displayAreaFinder));
      final size = tester.getSize(find.byType(CoreDisplayArea));
      expect(size.height, CoreSpacing.space57);
      expect(size.width,
          tester.view.physicalSize.width / tester.view.devicePixelRatio);
      expect(decoration.color, colors.backgroundBlueLight);

      final borderRadius = decoration.borderRadius as BorderRadius;
      expect(
          borderRadius.bottomLeft, const Radius.circular(CoreSpacing.space7));
      expect(
          borderRadius.bottomRight, const Radius.circular(CoreSpacing.space7));
    });

    testWidgets('triggers onClose when close icon is tapped',
        (WidgetTester tester) async {
      bool closed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              onClose: () => closed = true,
            ),
          ),
        ),
      );

      final closeIconFinder = find.byType(CoreIconWidget);
      expect(closeIconFinder, findsOneWidget);

      await tester.tap(closeIconFinder);
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('renders history chips when chipsList is provided',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
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
                CoreCalculatorChip(
                  label: 'Length',
                  value: '16ft 14in',
                  type: CoreCalculatorChipType.disabled,
                ),
              ],
            ),
          ),
        ),
      );

      final chipFinder = find.byType(CoreCalculatorChip);
      expect(chipFinder, findsNWidgets(3));
    });

    testWidgets('announces the provided closeSemanticLabel on the close icon',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Cerrar',
              historyPlaceholder: 'Aqui aparecera lo que escribas',
            ),
          ),
        ),
      );

      // Deliberately non-English: proves the string is threaded through to the
      // icon rather than a hardcoded default being announced.
      expect(find.bySemanticsLabel('Cerrar'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('shows custom historyPlaceholder text when chipsList is empty',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Enter a value to begin',
            ),
          ),
        ),
      );

      expect(find.byType(CoreCalculatorChip), findsNothing);
      expect(find.text('Enter a value to begin'), findsOneWidget);
    });

    testWidgets('renders chips with correct text content',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              chipsList: [
                CoreCalculatorChip(
                  label: 'Width',
                  value: '10ft',
                  type: CoreCalculatorChipType.editable,
                ),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Width'), findsOneWidget);
      expect(find.text('10ft'), findsOneWidget);
    });

    testWidgets('renders SingleChildScrollView for scrollable chips',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              chipsList: [
                CoreCalculatorChip(
                  label: 'Item 1',
                  type: CoreCalculatorChipType.editable,
                ),
                CoreCalculatorChip(
                  label: 'Item 2',
                  type: CoreCalculatorChipType.active,
                ),
                CoreCalculatorChip(
                  label: 'Item 3',
                  type: CoreCalculatorChipType.disabled,
                ),
                CoreCalculatorChip(
                  label: 'Item 4',
                  type: CoreCalculatorChipType.editable,
                ),
              ],
            ),
          ),
        ),
      );

      final scrollFinder = find
          .descendant(
            of: find.byType(CoreDisplayArea),
            matching: find.byType(SingleChildScrollView),
          )
          .last;
      expect(scrollFinder, findsOneWidget);

      final scrollWidget = tester.widget<SingleChildScrollView>(scrollFinder);
      expect(scrollWidget.reverse, isTrue);

      final wrapFinder = find.descendant(
        of: scrollFinder,
        matching: find.byType(Wrap),
      );
      expect(wrapFinder, findsOneWidget);
    });
    testWidgets('renders the provided label text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              label: 'Total Output',
            ),
          ),
        ),
      );

      expect(find.text('Total Output'), findsOneWidget);
    });

    testWidgets('displays typing indicator when isTyping is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              label: 'Total Output',
              isTyping: true,
            ),
          ),
        ),
      );

      expect(find.byType(CoreWritingDots), findsOneWidget);
    });

    testWidgets('hides typing indicator when isTyping is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              label: 'Total Output',
              isTyping: false,
            ),
          ),
        ),
      );

      expect(find.byType(CoreWritingDots), findsNothing);
    });

    testWidgets('renders the provided value text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              value: '123.45',
            ),
          ),
        ),
      );

      expect(find.text('123.45'), findsOneWidget);
    });
    testWidgets('does not render value when value is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
            ),
          ),
        ),
      );

      expect(find.text('null'), findsNothing);
    });

    testWidgets('renders error title when hasError is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              value: '123.45',
              hasError: true,
              errorTitle: 'Custom Error',
            ),
          ),
        ),
      );

      expect(find.text('123.45'), findsNothing);
      expect(find.text('Custom Error'), findsOneWidget);
    });

    testWidgets('renders error message chip when hasError is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              chipsList: [
                CoreCalculatorChip(
                  label: 'Width',
                  value: '10ft',
                  type: CoreCalculatorChipType.editable,
                ),
              ],
              hasError: true,
              errorMessage: 'Dimension Error',
            ),
          ),
        ),
      );

      expect(find.text('Width'), findsOneWidget);
      expect(find.text('Dimension Error'), findsOneWidget);
    });

    testWidgets('error message chip is NOT rendered when chipsList is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              chipsList: [],
              hasError: true,
              errorMessage: 'Dimension Error',
            ),
          ),
        ),
      );

      expect(
          find.text('Here will show what you type'), findsOneWidget);
      expect(find.text('Dimension Error'), findsNothing);
    });

    testWidgets('shows value if errorTitle is empty even when hasError is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              value: '123.45',
              hasError: true,
              errorTitle: '',
            ),
          ),
        ),
      );

      expect(find.text('123.45'), findsOneWidget);
    });

    testWidgets('does not show error chip if errorMessage is empty',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              chipsList: [
                CoreCalculatorChip(
                  label: 'Width',
                  type: CoreCalculatorChipType.editable,
                ),
              ],
              hasError: true,
              errorMessage: '',
            ),
          ),
        ),
      );

      expect(find.text('Width'), findsOneWidget);
    });
    testWidgets('renders dependent key when label or value is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              dependentKeyLabel: 'O.C',
              dependentKeyValue: '16in',
            ),
          ),
        ),
      );

      expect(find.textContaining('O.C: ', findRichText: true), findsOneWidget);
      expect(find.textContaining('16in', findRichText: true), findsOneWidget);
    });

    testWidgets('formats dependent key label with colon automatically',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              dependentKeyLabel: 'O.C',
            ),
          ),
        ),
      );
      expect(find.textContaining('O.C: ', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              dependentKeyLabel: 'O.C:',
            ),
          ),
        ),
      );
      expect(find.textContaining('O.C: ', findRichText: true), findsOneWidget);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              dependentKeyLabel: 'O.C: ',
            ),
          ),
        ),
      );
      expect(find.textContaining('O.C: ', findRichText: true), findsOneWidget);
    });

    testWidgets('triggers onPressedDependentKey when button is tapped',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              dependentKeyLabel: 'O.C',
              onPressedDependentKey: () => pressed = true,
            ),
          ),
        ),
      );

      final buttonFinder = find.byType(CoreButton);
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      expect(pressed, isTrue);
    });

    testWidgets('performs 2-stage expansion when chipsList length <= 5',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              label: 'Length',
              value: '16ft 14in',
              dependentKeyLabel: 'O.C',
              dependentKeyValue: '16in',
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
              previousSessions: [
                CoreHistorySessionData(
                  dateLabel: 'May 27, 2025',
                  value: '2700ft³',
                  chipsList: [
                    CoreCalculatorChip(
                      label: 'Length',
                      value: '16ft 14in',
                      type: CoreCalculatorChipType.editable,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(
          find.byKey(const Key('display_area_previous_section')), findsNothing);

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('display_area_previous_section')),
          findsOneWidget);

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();

      final historyPanel = find.byKey(const Key('display_area_history_panel'));
      expect(historyPanel, findsOneWidget);
    });

    testWidgets('performs 3-stage expansion when chipsList length > 5',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              label: 'Length',
              value: '16ft 14in',
              dependentKeyLabel: 'O.C',
              dependentKeyValue: '16in',
              chipsList: [
                CoreCalculatorChip(
                    label: '1', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '2', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '3', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '4', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '5', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '6', type: CoreCalculatorChipType.active),
              ],
              previousSessions: [
                CoreHistorySessionData(
                  dateLabel: 'May 27, 2025',
                  value: '2700ft³',
                  chipsList: [
                    CoreCalculatorChip(
                      label: 'Length',
                      value: '16ft 14in',
                      type: CoreCalculatorChipType.editable,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      expect(
          find.byKey(const Key('display_area_previous_section')), findsNothing);

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();
      expect(
          find.byKey(const Key('display_area_previous_section')), findsNothing);

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('display_area_previous_section')),
          findsOneWidget);

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();
    });

    testWidgets('collapses when swiping up', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              label: 'Length',
              value: '16ft 14in',
              dependentKeyLabel: 'O.C',
              dependentKeyValue: '16in',
              chipsList: [
                CoreCalculatorChip(
                    label: '1', type: CoreCalculatorChipType.active),
              ],
              previousSessions: [
                CoreHistorySessionData(
                  dateLabel: 'May 27, 2025',
                  value: '2700ft³',
                  chipsList: [
                    CoreCalculatorChip(
                      label: 'Length',
                      value: '16ft 14in',
                      type: CoreCalculatorChipType.editable,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('display_area_previous_section')),
          findsOneWidget);

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, -200), 1000);
      await tester.pumpAndSettle();
      expect(
          find.byKey(const Key('display_area_previous_section')), findsNothing);
    });

    testWidgets('calls onStageChanged with correct stages',
        (WidgetTester tester) async {
      final stages = <DisplayAreaStage>[];
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              label: 'Length',
              value: '16ft 14in',
              dependentKeyLabel: 'O.C',
              dependentKeyValue: '16in',
              chipsList: [
                const CoreCalculatorChip(
                  label: 'Length',
                  value: '16ft 14in',
                  type: CoreCalculatorChipType.editable,
                ),
              ],
              onStageChanged: (stage) => stages.add(stage),
              previousSessions: [
                const CoreHistorySessionData(
                  dateLabel: 'Previous',
                  chipsList: [],
                  value: '100',
                ),
              ],
            ),
          ),
        ),
      );
      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();

      expect(
          stages,
          containsAllInOrder([
            DisplayAreaStage.expandedPrevious,
            DisplayAreaStage.fullScreen,
          ]));
    });

    testWidgets(
        'N8: Full swipe-up reversal path (fullScreen -> expandedPrevious -> collapsed)',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              chipsList: [
                CoreCalculatorChip(
                    label: '1', type: CoreCalculatorChipType.active),
              ],
              previousSessions: [
                CoreHistorySessionData(
                  dateLabel: 'May 27, 2025',
                  value: '2700ft³',
                  chipsList: [],
                ),
              ],
            ),
          ),
        ),
      );

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();
      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();

      expect(
          find.byKey(const Key('display_area_history_panel')), findsOneWidget);
      final size = tester.getSize(find.byType(CoreDisplayArea));
      expect(size.height, greaterThanOrEqualTo(600));

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, -200), 1000);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('display_area_previous_section')),
          findsOneWidget);

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, -200), 1000);
      await tester.pumpAndSettle();
      expect(
          find.byKey(const Key('display_area_previous_section')), findsNothing);
      expect(tester.getSize(find.byType(CoreDisplayArea)).height,
          CoreSpacing.space57);
    });

    testWidgets(
        'N9: previousSessions = [] edge case (close tap fires CollapseEvent)',
        (WidgetTester tester) async {
      bool closed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: 'Close',
              historyPlaceholder: 'Here will show what you type',
              onClose: () => closed = true,
              chipsList: const [
                CoreCalculatorChip(
                    label: '1', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '2', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '3', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '4', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '5', type: CoreCalculatorChipType.active),
                CoreCalculatorChip(
                    label: '6', type: CoreCalculatorChipType.active),
              ],
              previousSessions: const [],
            ),
          ),
        ),
      );

      await tester.fling(
          find.byType(CoreDisplayArea), const Offset(0, 200), 1000);
      await tester.pumpAndSettle();

      final closeIconFinder = find.byType(CoreIconWidget);
      expect(closeIconFinder, findsOneWidget);

      await tester.tap(closeIconFinder);
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });
  });
}
