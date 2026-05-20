import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

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
              withCloseIcon: true,
              onRemove: () {},
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

    testWidgets('renders multi-part chip correctly',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Volume:',
              value: '2700',
              unit: 'ft³',
              selected: selected,
            ),
          ),
        ),
      );

      expect(find.text('Volume:'), findsOneWidget);
      expect(find.text('2700'), findsOneWidget);
      expect(find.text('ft³'), findsOneWidget);
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

    testWidgets('smart chip does not toggle selection but calls onTap',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Smart Chip',
              selected: selected,
              isSmartChip: true,
              onTap: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      expect(selected.value, isFalse);
      expect(wasPressed, isFalse);

      await tester.tap(find.byType(CoreChip));
      await tester.pumpAndSettle();
      expect(selected.value, isFalse);
      expect(wasPressed, isTrue);
      await tester.pump(const Duration(seconds: 1));
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
              withCloseIcon: true,
              onRemove: () {},
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('close_icon')), findsOneWidget);
    });

    testWidgets('maintains selected state across rebuilds',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Chip with Close',
              selected: selected,
              withCloseIcon: true,
              onRemove: () {},
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

    testWidgets('close icon triggers onRemove only', (tester) async {
      final selected = ValueNotifier<bool>(false);
      var removed = false;
      var tapped = false;

      await tester.pumpWidget(
        buildTestApp(
          theme: CoreTheme.light(),
          CoreChip(
            label: 'Filter',
            selected: selected,
            withCloseIcon: true,
            onTap: () => tapped = true,
            onRemove: () => removed = true,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('close_icon')).first);
      await tester.pumpAndSettle();

      expect(removed, isTrue);
      expect(tapped, isFalse);
      expect(selected.value, isFalse);
    });

    testWidgets('shows focused border color when focused',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Focus Chip',
              selected: selected,
              focusNode: focusNode,
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(CoreChip),
          matching: find.byType(AnimatedContainer),
        ),
      );
      final border = (container.decoration as BoxDecoration).border as Border;
      final colors =
          AppColorsExtension.of(tester.element(find.byType(CoreChip)));

      expect(border.top.color, colors.lineHighlight);
    });

    testWidgets('focused state overridden by pressed state',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      final focusNode = FocusNode();

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Focus(
              child: CoreChip(
                label: 'Focus Press Chip',
                selected: selected,
                focusNode: focusNode,
              ),
            ),
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();

      await tester.press(find.byType(CoreChip));
      await tester.pump();

      final container = tester.widget<AnimatedContainer>(
        find.descendant(
          of: find.byType(CoreChip),
          matching: find.byType(AnimatedContainer),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;

      final colors = AppColorsExtension.of(
        tester.element(find.byType(CoreChip)),
      );

      expect(border.top.color, colors.lineDarkOutline);
    });
  });
}
