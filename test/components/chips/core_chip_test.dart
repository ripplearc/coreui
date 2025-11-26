import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

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

      // The close icon should always be present
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

      // Trigger a rebuild
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
}
