import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import 'display_area_test_helpers.dart';

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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              chipsList: [],
              hasError: true,
              errorMessage: 'Dimension Error',
            ),
          ),
        ),
      );

      expect(find.text(testHistoryPlaceholder), findsOneWidget);
      expect(find.text('Dimension Error'), findsNothing);
    });

    testWidgets('shows value if errorTitle is empty even when hasError is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
    testWidgets(
        'deprecated adapter renders one pill when label or value is provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              dependentKeyLabel: 'O.C',
              dependentKeyValue: '16in',
            ),
          ),
        ),
      );

      expect(find.textContaining('O.C: ', findRichText: true), findsOneWidget);
      expect(find.textContaining('16in', findRichText: true), findsOneWidget);
    });

    testWidgets(
        'deprecated adapter formats the label with a colon automatically',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              dependentKeyLabel: 'O.C: ',
            ),
          ),
        ),
      );
      expect(find.textContaining('O.C: ', findRichText: true), findsOneWidget);
    });

    testWidgets('deprecated adapter triggers onPressedDependentKey when tapped',
        (WidgetTester tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              label: 'Length',
              value: '16ft 14in',
              dependentKeys: [
                CoreDependentKeyData(
                  label: 'O.C',
                  value: '16in',
                  kind: CoreDependentKeyKind.editable,
                ),
              ],
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              label: 'Length',
              value: '16ft 14in',
              dependentKeys: [
                CoreDependentKeyData(
                  label: 'O.C',
                  value: '16in',
                  kind: CoreDependentKeyKind.editable,
                ),
              ],
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              label: 'Length',
              value: '16ft 14in',
              dependentKeys: [
                CoreDependentKeyData(
                  label: 'O.C',
                  value: '16in',
                  kind: CoreDependentKeyKind.editable,
                ),
              ],
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              label: 'Length',
              value: '16ft 14in',
              dependentKeys: const [
                CoreDependentKeyData(
                  label: 'O.C',
                  value: '16in',
                  kind: CoreDependentKeyKind.editable,
                ),
              ],
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
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

  group('CoreDisplayArea dependent keys', () {
    const rate = CoreDependentKeyData(
      label: 'Rate',
      value: '\$14.5/sheet',
      kind: CoreDependentKeyKind.editable,
    );
    const waste = CoreDependentKeyData(
      label: 'Waste',
      value: '10%',
      kind: CoreDependentKeyKind.editable,
    );
    const shownAs = CoreDependentKeyData(
      label: 'Shown as',
      value: 'in/12in',
      kind: CoreDependentKeyKind.toggle,
    );
    const offer = CoreDependentKeyData(
      label: 'Re-input 38.30° as',
      value: '38°30′',
      kind: CoreDependentKeyKind.offer,
    );

    Widget host(
      List<CoreDependentKeyData> keys, {
      String? value,
      TextDirection textDirection = TextDirection.ltr,
    }) {
      return MaterialApp(
        theme: CoreTheme.light(),
        home: Directionality(
          textDirection: textDirection,
          child: Scaffold(
            body: CoreDisplayArea(
              closeSemanticLabel: testCloseSemanticLabel,
              historyPlaceholder: testHistoryPlaceholder,
              value: value,
              dependentKeys: keys,
            ),
          ),
        ),
      );
    }

    Finder iconFinder(CoreIconData icon) => find.byWidgetPredicate(
          (widget) => widget is CoreIconWidget && widget.icon == icon,
        );

    testWidgets('renders every pill with its label and value',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(const [rate, waste], value: '\$84.25'));

      expect(find.byType(CoreButton), findsNWidgets(2));
      expect(find.textContaining('Rate: ', findRichText: true), findsOneWidget);
      expect(find.textContaining('\$14.5/sheet', findRichText: true),
          findsOneWidget);
      expect(
          find.textContaining('Waste: ', findRichText: true), findsOneWidget);
      expect(find.textContaining('10%', findRichText: true), findsOneWidget);
    });

    testWidgets('shows the value section for pills alone',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(const [rate]));

      expect(find.byType(CoreButton), findsOneWidget);
    });

    testWidgets('editable and toggle pills carry their trailing icons',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(const [rate, shownAs, offer]));

      expect(iconFinder(CoreIcons.edit), findsOneWidget);
      expect(iconFinder(CoreIcons.swapHorizontal), findsOneWidget);
      expect(find.byType(CoreButton), findsNWidgets(3));
      expect(
        find.descendant(
          of: find.byType(CoreButton).last,
          matching: find.byType(CoreIconWidget),
        ),
        findsNothing,
        reason: 'an offer has no trailing icon',
      );
    });

    testWidgets('offer labels are joined with a space, not a colon',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(const [offer, shownAs]));

      expect(find.textContaining('Re-input 38.30° as ', findRichText: true),
          findsOneWidget);
      expect(find.textContaining('Re-input 38.30° as: ', findRichText: true),
          findsNothing);
      expect(find.textContaining('Shown as: ', findRichText: true),
          findsOneWidget);
    });

    testWidgets('each pill fires its own onPressed',
        (WidgetTester tester) async {
      final pressed = <String>[];
      await tester.pumpWidget(host([
        CoreDependentKeyData(
          label: 'Rate',
          value: '\$14.5/sheet',
          kind: CoreDependentKeyKind.editable,
          onPressed: () => pressed.add('rate'),
        ),
        CoreDependentKeyData(
          label: 'Waste',
          value: '10%',
          kind: CoreDependentKeyKind.editable,
          onPressed: () => pressed.add('waste'),
        ),
      ]));

      await tester.tap(find.byType(CoreButton).last);
      await tester.pumpAndSettle();
      expect(pressed, ['waste']);

      await tester.tap(find.byType(CoreButton).first);
      await tester.pumpAndSettle();
      expect(pressed, ['waste', 'rate']);
    });

    testWidgets('a pill without onPressed is disabled',
        (WidgetTester tester) async {
      await tester.pumpWidget(host(const [rate]));

      final semantics = tester.getSemantics(find.byType(CoreButton));
      expect(semantics.flagsCollection.isEnabled, ui.Tristate.isFalse);
    });

    testWidgets('anchors the trailing pill in view and scrolls the rest in',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(const [rate, waste, shownAs, offer]));
      await tester.pumpAndSettle();

      final width = tester.getSize(find.byType(CoreDisplayArea)).width;
      final lastPill = tester.getRect(find.byType(CoreButton).last);
      final firstPill = tester.getRect(find.byType(CoreButton).first);
      expect(lastPill.right, lessThanOrEqualTo(width));
      expect(firstPill.left, lessThan(0),
          reason: 'the leading pill starts off-screen when the row overflows');

      await tester.drag(find.byType(CoreButton).last,
          const Offset(CoreSpacing.space64 * 5, 0));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(CoreButton).first).left,
          greaterThanOrEqualTo(0));
    });

    testWidgets('anchors the trailing pill at the end edge in RTL',
        (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(host(
        const [rate, waste, shownAs, offer],
        textDirection: TextDirection.rtl,
      ));
      await tester.pumpAndSettle();

      final width = tester.getSize(find.byType(CoreDisplayArea)).width;
      final lastPill = tester.getRect(find.byType(CoreButton).last);
      final firstPill = tester.getRect(find.byType(CoreButton).first);
      expect(lastPill.left, greaterThanOrEqualTo(0),
          reason: 'the trailing pill anchors at the end edge, the left in RTL');
      expect(firstPill.right, greaterThan(width),
          reason: 'the leading pill starts off-screen to the right');

      await tester.drag(find.byType(CoreButton).last,
          const Offset(-CoreSpacing.space64 * 5, 0));
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byType(CoreButton).first).right,
          lessThanOrEqualTo(width));
    });

    test('resolvedDependentKeys appends the deprecated single pill', () {
      const area = CoreDisplayArea(
        closeSemanticLabel: testCloseSemanticLabel,
        historyPlaceholder: testHistoryPlaceholder,
        dependentKeys: [rate],
        dependentKeyLabel: 'O.C',
        dependentKeyValue: '16in',
      );

      final resolved = area.resolvedDependentKeys;
      expect(resolved.length, 2);
      expect(resolved.first, same(rate));
      expect(resolved.last.label, 'O.C');
      expect(resolved.last.value, '16in');
      expect(resolved.last.kind, CoreDependentKeyKind.editable);
    });

    test('resolvedDependentKeys is empty without either source', () {
      const area = CoreDisplayArea(
        closeSemanticLabel: testCloseSemanticLabel,
        historyPlaceholder: testHistoryPlaceholder,
      );
      expect(area.resolvedDependentKeys, isEmpty);
    });
  });
}
