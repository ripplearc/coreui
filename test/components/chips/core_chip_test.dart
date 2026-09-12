import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/chips/core_chip_theme.dart';

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
      await tester.pump(const Duration(seconds: 1));
      expect(selected.value, isFalse);
      expect(wasPressed, isTrue);
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

  group('CoreChip outline', () {
    testWidgets('defaults to a solid outline', (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(label: 'Solid', selected: selected),
          ),
        ),
      );

      expect(tester.widget<CoreChip>(find.byType(CoreChip)).outline,
          CoreChipOutline.solid);
    });

    testWidgets('renders a dashed chip with its text intact',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Height:',
              value: '8ft ?',
              selected: selected,
              size: CoreChipSize.large,
              outline: CoreChipOutline.dashed,
            ),
          ),
        ),
      );

      expect(tester.widget<CoreChip>(find.byType(CoreChip)).outline,
          CoreChipOutline.dashed);
      expect(find.text('Height:'), findsOneWidget);
      expect(find.text('8ft ?'), findsOneWidget);
    });

    testWidgets('semanticsLabel overrides the combined label',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Conv:',
              value: '12.57',
              unit: 'yd²',
              selected: selected,
              semanticsLabel: 'Convert to 12.57 square yards',
            ),
          ),
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreChip));
      expect(semantics.label, 'Convert to 12.57 square yards');
    });

    for (final entry in {
      'light': AppColorsExtension.create(),
      'dark': AppColorsExtension.createDark(),
    }.entries) {
      final colors = entry.value;

      test(
          '${entry.key}: dashed chips sit on backgroundBlueLight with a '
          'transparent solid border', () {
        expect(
          CoreChipTheme.background(
            size: CoreChipSize.large,
            isSelected: false,
            isPressed: false,
            isFocused: false,
            colors: colors,
            outline: CoreChipOutline.dashed,
          ),
          colors.backgroundBlueLight,
        );
        expect(
          CoreChipTheme.borderColor(
            size: CoreChipSize.large,
            isSelected: true,
            isPressed: true,
            isFocused: true,
            colors: colors,
            outline: CoreChipOutline.dashed,
          ),
          colors.transparent,
        );
        expect(
          CoreChipTheme.background(
            size: CoreChipSize.large,
            isSelected: false,
            isPressed: true,
            isFocused: false,
            colors: colors,
            outline: CoreChipOutline.dashed,
          ),
          colors.pageBackground,
          reason: 'pressed feedback still wins over the offer fill',
        );
      });

      test('${entry.key}: dashed outline follows the focus border width', () {
        final resting = CoreChipTheme.dashedOutline(
          outline: CoreChipOutline.dashed,
          isFocused: false,
          colors: colors,
        )!;
        final focused = CoreChipTheme.dashedOutline(
          outline: CoreChipOutline.dashed,
          isFocused: true,
          colors: colors,
        )!;
        expect(resting.color, colors.outlineFocus);
        expect(resting.strokeWidth, CoreChipTheme.borderWidth);
        expect(
            focused.strokeWidth, CoreChipTheme.borderWidthFor(isFocused: true));
        expect(resting.radius, CoreSpacing.space6);
        expect(resting.dashLength, CoreChipTheme.dashLength);
        expect(resting.gapLength, CoreChipTheme.gapLength);
        expect(
          CoreChipTheme.dashedOutline(
            outline: CoreChipOutline.solid,
            isFocused: false,
            colors: colors,
          ),
          isNull,
        );
      });
    }
  });
}
