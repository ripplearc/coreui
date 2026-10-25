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
            body: Align(
              alignment: Alignment.topLeft,
              child: CoreChip(
                label: 'Sheets',
                value: '5.81',
                selected: selected,
                size: CoreChipSize.large,
              ),
            ),
          ),
        ),
      );

      final surfaceRect = tester.getRect(find.byKey(CoreChip.surfaceKey));
      final labelRect = tester.getRect(find.text('Sheets'));
      final valueRect = tester.getRect(find.text('5.81'));
      expect(surfaceRect.height, CoreSpacing.space12);
      expect(labelRect.left - surfaceRect.left, CoreSpacing.space4 + 1);
      expect(surfaceRect.right - valueRect.right, CoreSpacing.space4 + 1);
      expect(valueRect.left - labelRect.right, CoreSpacing.space2);
    });

    testWidgets('renders mini size at the medium height',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Row(
              children: [
                CoreChip(
                  value: '264',
                  unit: 'in',
                  selected: selected,
                  size: CoreChipSize.mini,
                ),
                CoreChip(
                  value: '264',
                  unit: 'in',
                  selected: selected,
                  size: CoreChipSize.medium,
                ),
                CoreChip(
                  value: '264',
                  unit: 'in',
                  selected: selected,
                  size: CoreChipSize.large,
                ),
              ],
            ),
          ),
        ),
      );

      final heights = tester
          .widgetList<CoreChip>(find.byType(CoreChip))
          .map((chip) => tester.getSize(find.byWidget(chip)).height)
          .toList();
      expect(heights[0], heights[1]);
      expect(heights[0], lessThan(heights[2]));
      expect(find.text('264'), findsNWidgets(3));
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

    testWidgets('reads a dashed chip label and value in outlineFocus',
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

      final colors =
          AppColorsExtension.of(tester.element(find.byType(CoreChip)));
      final label = tester.widget<Text>(find.text('Height:')).style;
      final value = tester.widget<Text>(find.text('8ft ?')).style;
      expect((label as TextStyle).color, colors.outlineFocus);
      expect((value as TextStyle).color, colors.outlineFocus);
    });

    testWidgets('keeps 16 dp at both ends of a large chip with a close icon',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: Center(
              child: CoreChip(
                label: 'Chips',
                selected: selected,
                size: CoreChipSize.large,
                icon: CoreIcons.check,
                withCloseIcon: true,
                onRemove: () {},
              ),
            ),
          ),
        ),
      );

      final surface = tester.getRect(find.byKey(CoreChip.surfaceKey));
      final close = tester.getRect(find.byKey(const Key('close_icon')));
      final check = tester.getRect(find.byWidgetPredicate(
        (widget) => widget is CoreIconWidget && widget.icon == CoreIcons.check,
      ));
      expect(
        surface.right - close.right,
        moreOrLessEquals(check.left - surface.left),
      );
    });

    testWidgets('renders a highlight chip with its text intact',
        (WidgetTester tester) async {
      final selected = ValueNotifier<bool>(false);
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreChip(
              label: 'Area:',
              value: '220',
              unit: 'ft²',
              selected: selected,
              size: CoreChipSize.large,
              outline: CoreChipOutline.highlight,
            ),
          ),
        ),
      );

      expect(tester.widget<CoreChip>(find.byType(CoreChip)).outline,
          CoreChipOutline.highlight);
      expect(find.text('Area:'), findsOneWidget);
      expect(find.text('220'), findsOneWidget);
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
          '${entry.key}: dashed chips keep their size fill behind a '
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
          colors.pageBackground,
        );
        expect(
          CoreChipTheme.background(
            size: CoreChipSize.medium,
            isSelected: false,
            isPressed: false,
            isFocused: false,
            colors: colors,
            outline: CoreChipOutline.dashed,
          ),
          colors.chipGrey,
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

      test(
          '${entry.key}: highlight chips draw lineHighlight at the focus '
          'width behind their size fill', () {
        expect(
          CoreChipTheme.borderColor(
            size: CoreChipSize.large,
            isSelected: false,
            isPressed: false,
            isFocused: false,
            colors: colors,
            outline: CoreChipOutline.highlight,
          ),
          colors.lineHighlight,
        );
        expect(
          CoreChipTheme.borderWidthFor(
            isFocused: false,
            outline: CoreChipOutline.highlight,
          ),
          CoreChipTheme.borderWidthFor(isFocused: true),
        );
        expect(
          CoreChipTheme.borderWidthFor(
            isFocused: false,
            outline: CoreChipOutline.solid,
          ),
          CoreChipTheme.borderWidth,
        );
        expect(
          CoreChipTheme.background(
            size: CoreChipSize.large,
            isSelected: false,
            isPressed: false,
            isFocused: false,
            colors: colors,
            outline: CoreChipOutline.highlight,
          ),
          colors.pageBackground,
        );
        expect(
          CoreChipTheme.borderColor(
            size: CoreChipSize.large,
            isSelected: false,
            isPressed: true,
            isFocused: false,
            colors: colors,
            outline: CoreChipOutline.highlight,
          ),
          colors.lineDarkOutline,
          reason: 'pressed feedback still wins over the highlight',
        );
        expect(
          CoreChipTheme.borderColor(
            size: CoreChipSize.large,
            isSelected: true,
            isPressed: false,
            isFocused: false,
            colors: colors,
            outline: CoreChipOutline.highlight,
          ),
          colors.outlineHover,
          reason: 'selected still wins over the highlight',
        );
        expect(
          CoreChipTheme.dashedOutline(
            outline: CoreChipOutline.highlight,
            isFocused: false,
            colors: colors,
          ),
          isNull,
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
        expect(resting.strokeWidth, CoreChipTheme.dashedStrokeWidth);
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

  group('CoreChip mini size', () {
    test('shares the medium padding', () {
      expect(
        CoreChipTheme.padding(CoreChipSize.mini),
        CoreChipTheme.padding(CoreChipSize.medium),
      );
      expect(CoreChipTheme.onPageSurface(CoreChipSize.mini), isTrue);
      expect(CoreChipTheme.onPageSurface(CoreChipSize.medium), isFalse);
    });

    for (final entry in {
      'light': AppColorsExtension.create(),
      'dark': AppColorsExtension.createDark(),
    }.entries) {
      final colors = entry.value;
      final typography = AppTypographyExtension.create();

      test('${entry.key}: resting mini chip takes the large surface', () {
        expect(
          CoreChipTheme.background(
            size: CoreChipSize.mini,
            isSelected: false,
            isPressed: false,
            isFocused: false,
            colors: colors,
          ),
          colors.pageBackground,
        );
        expect(
          CoreChipTheme.borderColor(
            size: CoreChipSize.mini,
            isSelected: false,
            isPressed: false,
            isFocused: false,
            colors: colors,
          ),
          colors.lineMid,
        );
      });

      test('${entry.key}: focused mini chip stays on the page surface', () {
        expect(
          CoreChipTheme.background(
            size: CoreChipSize.mini,
            isSelected: false,
            isPressed: false,
            isFocused: true,
            colors: colors,
          ),
          colors.pageBackground,
        );
        expect(
          CoreChipTheme.background(
            size: CoreChipSize.medium,
            isSelected: false,
            isPressed: false,
            isFocused: true,
            colors: colors,
          ),
          colors.chipGrey,
        );
      });

      test(
          '${entry.key}: mini value and unit read semibold, others keep the heavy unit',
          () {
        expect(
          CoreChipTheme.valueStyle(
            size: CoreChipSize.mini,
            typography: typography,
            colors: colors,
          ).fontWeight,
          typography.bodyMediumSemiBold.fontWeight,
        );
        expect(
          CoreChipTheme.unitStyle(
            size: CoreChipSize.mini,
            typography: typography,
            colors: colors,
          ).fontWeight,
          typography.bodyMediumSemiBold.fontWeight,
        );
        expect(
          CoreChipTheme.valueStyle(
            size: CoreChipSize.medium,
            typography: typography,
            colors: colors,
          ).fontWeight,
          typography.bodyMediumMedium.fontWeight,
        );
        expect(
          CoreChipTheme.unitStyle(
            size: CoreChipSize.large,
            typography: typography,
            colors: colors,
          ).fontWeight,
          CoreChipTheme.unitFontWeight,
        );
        expect(
          CoreChipTheme.labelStyle(
            size: CoreChipSize.medium,
            typography: typography,
            colors: colors,
          ).color,
          colors.textBody,
        );
      });

      test('${entry.key}: large chip has a Regular dark label and heavy value',
          () {
        final label = CoreChipTheme.labelStyle(
          size: CoreChipSize.large,
          typography: typography,
          colors: colors,
        );
        final value = CoreChipTheme.valueStyle(
          size: CoreChipSize.large,
          typography: typography,
          colors: colors,
        );
        expect(label.fontWeight, typography.bodyMediumRegular.fontWeight);
        expect(label.color, colors.textDark);
        expect(value.fontWeight, CoreChipTheme.unitFontWeight);
        expect(value.color, colors.textDark);
        expect(CoreChipTheme.labelGap(CoreChipSize.large), CoreSpacing.space2);
        expect(
            CoreChipTheme.labelGap(CoreChipSize.medium), CoreSpacing.space1);
      });
    }
  });
}
