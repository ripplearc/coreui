import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  group('CoreChip Widget Tests', () {
    testWidgets('renders CoreChip with label correctly',
            (WidgetTester tester) async {
          final selected = ValueNotifier<bool>(false);

          await tester.pumpWidget(
            MaterialApp(
              theme: CoreTheme.light(),
              home: Scaffold(
                body: CoreChip(
                  label: 'Test Chip',
                  selected: selected,
                ),
              ),
            ),
          );

          expect(find.text('Test Chip'), findsOneWidget);
          expect(find.byType(CoreChip), findsOneWidget);
        });

    testWidgets('renders CoreChip with icon correctly',
            (WidgetTester tester) async {
          final selected = ValueNotifier<bool>(false);

          await tester.pumpWidget(
            MaterialApp(
              theme: CoreTheme.light(),
              home: Scaffold(
                body: CoreChip(
                  label: 'Chip with Icon',
                  selected: selected,
                  icon: CoreIcons.check,
                ),
              ),
            ),
          );

          expect(find.text('Chip with Icon'), findsOneWidget);
          expect(find.byType(CoreIconWidget), findsWidgets);
        });

    testWidgets('toggles selected state on tap', (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Toggle Chip',
              selected: selected,
            ),
          ),
        ),
      );

      expect(selected.value, isFalse);

      await tester.tap(find.byType(CoreChip));
      await tester.pumpAndSettle();

      expect(selected.value, isTrue);

      await tester.tap(find.byType(CoreChip));
      await tester.pumpAndSettle();

      expect(selected.value, isFalse);
    });

    testWidgets('calls onTap callback when tapped',
            (WidgetTester tester) async {
          final selected = ValueNotifier<bool>(false);
          bool wasPressed = false;

          await tester.pumpWidget(
            MaterialApp(
              theme: CoreTheme.light(),
              home: Scaffold(
                body: CoreChip(
                  label: 'Callback Chip',
                  selected: selected,
                  onTap: () {
                    wasPressed = true;
                  },
                ),
              ),
            ),
          );

          expect(wasPressed, isFalse);

          await tester.tap(find.byType(CoreChip));
          await tester.pumpAndSettle();

          expect(wasPressed, isTrue);
        });

    testWidgets('renders small size correctly', (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Small Chip',
              selected: selected,
              size: CoreChipSize.small,
            ),
          ),
        ),
      );

      expect(find.text('Small Chip'), findsOneWidget);
      expect(find.byType(CoreChip), findsOneWidget);
    });

    testWidgets('renders medium size correctly', (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Medium Chip',
              selected: selected,
              size: CoreChipSize.medium,
            ),
          ),
        ),
      );

      expect(find.text('Medium Chip'), findsOneWidget);
      expect(find.byType(CoreChip), findsOneWidget);
    });

    testWidgets('renders large size correctly', (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Large Chip',
              selected: selected,
              size: CoreChipSize.large,
            ),
          ),
        ),
      );

      expect(find.text('Large Chip'), findsOneWidget);
      expect(find.byType(CoreChip), findsOneWidget);
    });

    testWidgets('displays close icon', (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Chip with Close',
              selected: selected,
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsWidgets);
    });

    testWidgets('maintains selected state across rebuilds',
            (WidgetTester tester) async {
          final selected = ValueNotifier<bool>(false);

          await tester.pumpWidget(
            MaterialApp(
              theme: CoreTheme.light(),
              home: Scaffold(
                body: CoreChip(
                  label: 'Persistent Chip',
                  selected: selected,
                ),
              ),
            ),
          );

          await tester.tap(find.byType(CoreChip));
          await tester.pumpAndSettle();
          expect(selected.value, isTrue);

          await tester.pumpWidget(
            MaterialApp(
              theme: CoreTheme.light(),
              home: Scaffold(
                body: CoreChip(
                  label: 'Persistent Chip',
                  selected: selected,
                ),
              ),
            ),
          );

          expect(selected.value, isTrue);
        });
  });

  group('CoreChip – accessibility', () {
    testWidgets('exposes semantic label and button role',
            (WidgetTester tester) async {
          await setupA11yTest(tester);

          final selected = ValueNotifier<bool>(false);
          const chipLabel = 'Accessible Chip';

          await tester.pumpWidget(
            buildTestApp(
              CoreChip(
                label: chipLabel,
                selected: selected,
                onTap: () {},
              ),
              theme: CoreTheme.light(),
            ),
          );

          // Ensure the CoreChip is found
          final chipFinder = find.byType(CoreChip);
          expect(chipFinder, findsOneWidget);

          // Check semantics
          final semantics = tester.getSemantics(chipFinder);
          expect(semantics.label, chipLabel);
          expect(semantics.hasFlag(SemanticsFlag.isButton), isTrue);

          // Run a11y checks for light and dark themes
          await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
            tester,
                (theme) => CoreChip(
              label: chipLabel,
              selected: selected,
              onTap: () {},
            ),
            chipFinder,
            checkTapTargetSize: true,
            checkLabeledTapTarget: true,
            checkTextContrast: true,
          );
        });
  });
}