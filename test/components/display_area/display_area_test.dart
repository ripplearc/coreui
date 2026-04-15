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
            body: CoreDisplayArea(),
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

    testWidgets('shows default placeholder text when chipsList is empty',
        (WidgetTester tester) async {
      addTearDown(() => tester.view.resetPhysicalSize());
      tester.view.physicalSize = const ui.Size(1100, 1600);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: const Scaffold(
            body: CoreDisplayArea(),
          ),
        ),
      );

      expect(find.byType(CoreCalculatorChip), findsNothing);
      expect(
          find.text(CoreDisplayArea.defaultHistoryPlaceholder), findsOneWidget);
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

      final scrollFinder = find.byType(SingleChildScrollView);
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
            body: CoreDisplayArea(label: 'Total Output'),
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
            body: CoreDisplayArea(label: 'Total Output', isTyping: true),
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
            body: CoreDisplayArea(label: 'Total Output', isTyping: false),
          ),
        ),
      );

      expect(find.byType(CoreWritingDots), findsNothing);
    });
  });
}
