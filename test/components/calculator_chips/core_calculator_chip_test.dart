import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:ripplearc_coreui/src/components/calculator_chips/core_calculator_chip_theme.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

Future<void> pumpChip(WidgetTester tester, CoreCalculatorChip chip) {
  return tester.pumpWidget(
    MaterialApp(theme: CoreTheme.light(), home: Scaffold(body: chip)),
  );
}

void main() {
  group('CoreCalculatorChip Widget Tests', () {
    testWidgets('renders editable chip with label correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              label: 'Test Label',
              value: '100',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Test Label'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.byType(CoreCalculatorChip), findsOneWidget);
      expect(find.byType(CoreIconWidget), findsNothing);
    });

    testWidgets('renders active chip correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.active,
              value: 'Active Val',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Active Val'), findsOneWidget);
      expect(find.byType(CoreIconWidget), findsNothing);
    });

    testWidgets('throws assertion if disable without label',
        (WidgetTester tester) async {
      expect(
        () => CoreCalculatorChip(
          type: CoreCalculatorChipType.disabled,
          value: '100',
          onTap: () {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('calls onTap callback when tapped',
        (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              value: '100',
              onTap: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsNothing);
      expect(wasPressed, isFalse);
      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(wasPressed, isTrue);
    });

    testWidgets('does not call onTap when disabled',
        (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.disabled,
              label: 'Label',
              value: '100',
              onTap: () {
                wasPressed = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(find.byType(CoreIconWidget), findsNothing);
      expect(wasPressed, isFalse);
    });

    testWidgets('displays factor icon correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              value: '100',
              factor: CoreIcons.addOperator,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('renders factor-only chip (null value) correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              factor: CoreIcons.addOperator,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders label and factor chip (null value) correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              label: 'Label Only',
              factor: CoreIcons.addOperator,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
      expect(find.text('Label Only'), findsOneWidget);
      expect(find.byType(Text), findsNWidgets(1));
    });
  });

  group('CoreCalculatorChip result, dashed and error variants', () {
    const newVariants = [
      CoreCalculatorChipType.result,
      CoreCalculatorChipType.dashed,
      CoreCalculatorChipType.error,
    ];

    for (final type in newVariants) {
      testWidgets('renders $type with label, value and factor',
          (WidgetTester tester) async {
        await pumpChip(
          tester,
          CoreCalculatorChip(
            type: type,
            label: 'Area',
            value: '410.67ft²',
            factor: CoreIcons.addOperator,
          ),
        );

        expect(find.text('Area'), findsOneWidget);
        expect(find.text('410.67ft²'), findsOneWidget);
        expect(find.byType(CoreIconWidget), findsOneWidget);
      });

      testWidgets('calls onTap for $type', (WidgetTester tester) async {
        bool tapped = false;
        await pumpChip(
          tester,
          CoreCalculatorChip(
            type: type,
            label: 'Area',
            value: '410.67ft²',
            onTap: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });
    }

    test('the dashed variants resolve a dashed outline', () {
      final colors = AppColorsExtension.create();
      const dashedTypes = {
        CoreCalculatorChipType.dashed,
        CoreCalculatorChipType.bracketOpen,
        CoreCalculatorChipType.stale,
      };
      for (final type in CoreCalculatorChipType.values) {
        expect(
          CoreCalculatorChipTheme.dashedOutline(type: type, colors: colors),
          dashedTypes.contains(type) ? isNotNull : isNull,
          reason: '$type',
        );
      }
    });
  });

  group('CoreCalculatorChip brackets', () {
    testWidgets('an open bracket draws its value without a closing bracket',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketOpen,
          factor: CoreIcons.addOperator,
          value: '3×4',
        ),
      );

      expect(find.text('(3×4'), findsOneWidget);
      expect(find.textContaining(')'), findsNothing);
      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('a closed bracket draws its value inside both brackets',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketClosed,
          factor: CoreIcons.addOperator,
          value: '3×4',
        ),
      );

      expect(find.text('(3×4)'), findsOneWidget);
    });

    testWidgets('a bracket just opened reads a lone opening bracket',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketOpen,
          factor: CoreIcons.addOperator,
        ),
      );

      expect(find.text('('), findsOneWidget);
    });

    testWidgets('the semantics label reads the bracketed text',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketClosed,
          factor: CoreIcons.addOperator,
          value: '3×4',
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCalculatorChip));
      expect(semantics.label, '(3×4)');
    });

    test('displayedValue is what the chip draws', () {
      const open = CoreCalculatorChip(
        type: CoreCalculatorChipType.bracketOpen,
        value: '3×4',
      );
      const closed = CoreCalculatorChip(
        type: CoreCalculatorChipType.bracketClosed,
        value: '3×4',
      );
      const plain = CoreCalculatorChip(
        type: CoreCalculatorChipType.editable,
        value: '3×4',
      );

      expect(open.displayedValue, '(3×4');
      expect(closed.displayedValue, '(3×4)');
      expect(plain.displayedValue, '3×4');
    });

    for (final type in [
      CoreCalculatorChipType.bracketOpen,
      CoreCalculatorChipType.bracketClosed,
    ]) {
      final closing = type == CoreCalculatorChipType.bracketClosed ? ')' : '';

      testWidgets('renders $type with label, value and factor',
          (WidgetTester tester) async {
        await pumpChip(
          tester,
          CoreCalculatorChip(
            type: type,
            label: 'Area',
            value: '410.67ft²',
            factor: CoreIcons.addOperator,
          ),
        );

        expect(find.text('Area'), findsOneWidget);
        expect(find.text('(410.67ft²$closing'), findsOneWidget);
        expect(find.byType(CoreIconWidget), findsOneWidget);
      });

      testWidgets('calls onTap for $type', (WidgetTester tester) async {
        bool tapped = false;
        await pumpChip(
          tester,
          CoreCalculatorChip(
            type: type,
            value: '3×4',
            onTap: () => tapped = true,
          ),
        );

        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(tapped, isTrue);
      });
    }

    test('a closed bracket refuses to be empty', () {
      expect(
        () => CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketClosed,
          onTap: () {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('semanticsLabel replaces the label built from the text',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketOpen,
          factor: CoreIcons.addOperator,
          value: '3×4',
          semanticsLabel: 'open bracket, 3 times 4',
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCalculatorChip));
      expect(semantics.label, 'open bracket, 3 times 4');
      expect(find.text('(3×4'), findsOneWidget);
    });

    testWidgets('tapSemanticLabel is the tap hint while onTap is set',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketClosed,
          factor: CoreIcons.addOperator,
          value: '3×4',
          onTap: () {},
          tapSemanticLabel: 'reopen the bracket',
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCalculatorChip));
      expect(semantics.hintOverrides!.onTapHint, 'reopen the bracket');
    });

    test('tapSemanticLabel without onTap is refused', () {
      expect(
        () => CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketClosed,
          value: '3×4',
          tapSemanticLabel: 'reopen the bracket',
          onLongPress: () {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('a value-only chip keeps its value centred',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketOpen,
          value: '3×4',
        ),
      );

      final chip = tester.getRect(find.byType(CoreCalculatorChip));
      final text = tester.getRect(find.text('(3×4'));
      expect(text.center.dx, closeTo(chip.center.dx, 0.5));
    });

    testWidgets('a tap on a closed bracket reaches onTap',
        (WidgetTester tester) async {
      var reopened = 0;
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.bracketClosed,
          factor: CoreIcons.addOperator,
          value: '3×4',
          onTap: () => reopened++,
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(reopened, 1);
    });
  });

  group('CoreCalculatorChip inert', () {
    testWidgets('an inert chip keeps its look and ignores taps',
        (WidgetTester tester) async {
      var tapped = 0;
      var longPressed = 0;
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.editable,
          factor: CoreIcons.multiplyOperator,
          value: '5',
          inert: true,
          onTap: () => tapped++,
          onLongPress: () => longPressed++,
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      await tester.longPress(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(tapped, 0);
      expect(longPressed, 0);
      expect(find.text('5'), findsOneWidget);
      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    test('an inert chip is drawn at inertOpacity and a live one is not', () {
      const inert = CoreCalculatorChip(
        type: CoreCalculatorChipType.editable,
        value: '2',
        inert: true,
      );
      const live = CoreCalculatorChip(
        type: CoreCalculatorChipType.editable,
        value: '2',
      );

      expect(inert.effectiveOpacity, CoreCalculatorChipTheme.inertOpacity);
      expect(live.effectiveOpacity, 1);
    });

    for (final inert in [true, false]) {
      testWidgets(
          '${inert ? 'an inert' : 'a live'} chip is built at its '
          'effectiveOpacity', (WidgetTester tester) async {
        final chip = CoreCalculatorChip(
          type: CoreCalculatorChipType.editable,
          value: '2',
          inert: inert,
        );
        await pumpChip(tester, chip);

        final opacity = tester.widget<Opacity>(
          find.descendant(
            of: find.byType(CoreCalculatorChip),
            matching: find.byType(Opacity),
          ),
        );
        expect(
          opacity.opacity,
          inert ? CoreCalculatorChipTheme.inertOpacity : 1,
        );
        expect(opacity.opacity, chip.effectiveOpacity);
      });
    }

    testWidgets('an inert chip draws its factor in the colour of its text',
        (WidgetTester tester) async {
      final colors = AppColorsExtension.create();
      for (final inert in [true, false]) {
        await pumpChip(
          tester,
          CoreCalculatorChip(
            type: CoreCalculatorChipType.editable,
            factor: CoreIcons.multiplyOperator,
            value: '5',
            inert: inert,
          ),
        );

        final icon = tester.widget<CoreIconWidget>(find.byType(CoreIconWidget));
        expect(icon.color, inert ? colors.textLink : colors.iconOrient);
      }
    });

    testWidgets('inert layers over a result and keeps its label',
        (WidgetTester tester) async {
      var longPressed = 0;
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.result,
          label: 'Calc',
          value: '14',
          inert: true,
          onLongPress: () => longPressed++,
        ),
      );

      await tester.longPress(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(longPressed, 0);
      expect(find.text('Calc'), findsOneWidget);
      expect(find.text('14'), findsOneWidget);
    });
  });

  group('CoreCalculatorChip stale', () {
    testWidgets('a stale answer reads its label and the placeholder',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.stale,
          label: 'Calc',
          semanticsLabel: 'Calc, pending',
        ),
      );

      expect(find.text('Calc'), findsOneWidget);
      expect(find.text(CoreCalculatorChip.stalePlaceholder), findsOneWidget);
      expect(find.text('70'), findsNothing);
    });

    test('a stale answer refuses to be left without a semanticsLabel', () {
      expect(
        () => CoreCalculatorChip(
          type: CoreCalculatorChipType.stale,
          label: 'Calc',
          onTap: () {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('semanticsLabel says in words that the answer is pending',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.stale,
          label: 'Calc',
          semanticsLabel: 'Calc, pending',
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCalculatorChip));
      expect(semantics.label, 'Calc, pending');
      expect(find.text(CoreCalculatorChip.stalePlaceholder), findsOneWidget);
    });

    test('a stale answer refuses a value', () {
      expect(
        () => CoreCalculatorChip(
          type: CoreCalculatorChipType.stale,
          label: 'Calc',
          value: '70',
          semanticsLabel: 'Calc, pending',
          onTap: () {},
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('a stale answer stays interactive unless inert',
        (WidgetTester tester) async {
      var tapped = 0;
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.stale,
          label: 'Calc',
          semanticsLabel: 'Calc, pending',
          onTap: () => tapped++,
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();

      expect(tapped, 1);
    });
  });

  group('CoreCalculatorChip long-press', () {
    for (final type in CoreCalculatorChipType.values) {
      final expectsCallback = type != CoreCalculatorChipType.disabled;

      testWidgets('$type ${expectsCallback ? 'fires' : 'ignores'} onLongPress',
          (WidgetTester tester) async {
        bool longPressed = false;
        await pumpChip(
          tester,
          CoreCalculatorChip(
            type: type,
            label: 'Area',
            value: type == CoreCalculatorChipType.stale ? null : '410.67ft²',
            semanticsLabel:
                type == CoreCalculatorChipType.stale ? 'Area, pending' : null,
            onLongPress: () => longPressed = true,
          ),
        );

        await tester.longPress(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(longPressed, expectsCallback);
      });
    }

    testWidgets('long-press does not fire onTap', (WidgetTester tester) async {
      bool tapped = false;
      bool longPressed = false;
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.result,
          label: 'Area',
          value: '410.67ft²',
          onTap: () => tapped = true,
          onLongPress: () => longPressed = true,
        ),
      );

      await tester.longPress(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(longPressed, isTrue);
      expect(tapped, isFalse);
    });
  });

  group('CoreCalculatorChipTheme variant tokens', () {
    final typography = AppTypographyExtension.create();
    final themes = {
      'light': AppColorsExtension.create(),
      'dark': AppColorsExtension.createDark(),
    };

    for (final entry in themes.entries) {
      final colors = entry.value;

      test('${entry.key}: result reuses the muted grey pair and stays filled',
          () {
        const type = CoreCalculatorChipType.result;
        expect(
          CoreCalculatorChipTheme.background(type: type, colors: colors),
          colors.backgroundGrayMid,
        );
        expect(
          CoreCalculatorChipTheme.borderColor(type: type, colors: colors),
          colors.lineMid,
        );
        expect(
          CoreCalculatorChipTheme.valueStyle(
            type: type,
            colors: colors,
            typography: typography,
          ).color,
          colors.textDark,
        );
        expect(
          CoreCalculatorChipTheme.factorColor(type: type, colors: colors),
          colors.iconGrayDark,
        );
        expect(CoreCalculatorChipTheme.shadow(type), isNull);
        expect(
          CoreCalculatorChipTheme.dashedOutline(type: type, colors: colors),
          isNull,
        );
      });

      test('${entry.key}: dashed paints its outline and keeps the teal text',
          () {
        const type = CoreCalculatorChipType.dashed;
        expect(
          CoreCalculatorChipTheme.background(type: type, colors: colors),
          colors.backgroundBlueLight,
        );
        expect(
          CoreCalculatorChipTheme.borderColor(type: type, colors: colors),
          colors.transparent,
        );
        final outline =
            CoreCalculatorChipTheme.dashedOutline(type: type, colors: colors)!;
        expect(outline.color, colors.outlineFocus);
        expect(outline.strokeWidth, CoreCalculatorChipTheme.borderWidth);
        expect(outline.radius, CoreSpacing.space6);
        expect(outline.dashLength, CoreCalculatorChipTheme.dashLength);
        expect(outline.gapLength, CoreCalculatorChipTheme.gapLength);
        expect(CoreCalculatorChipTheme.shadow(type), CoreShadows.small);
        expect(
          CoreCalculatorChipTheme.labelStyle(
            type: type,
            colors: colors,
            typography: typography,
          ).color,
          colors.textLink,
        );
        expect(
          CoreCalculatorChipTheme.factorColor(type: type, colors: colors),
          colors.iconOrient,
        );
      });

      test('${entry.key}: an open bracket wears the live green under a dash',
          () {
        const type = CoreCalculatorChipType.bracketOpen;
        expect(
          CoreCalculatorChipTheme.background(type: type, colors: colors),
          colors.backgroundGreenMid,
        );
        expect(
          CoreCalculatorChipTheme.borderColor(type: type, colors: colors),
          colors.transparent,
        );
        final outline =
            CoreCalculatorChipTheme.dashedOutline(type: type, colors: colors)!;
        expect(outline.color, colors.outlineFocus);
        expect(outline.strokeWidth, CoreCalculatorChipTheme.borderWidth);
        expect(CoreCalculatorChipTheme.shadow(type), isNull);
        expect(
          CoreCalculatorChipTheme.valueStyle(
            type: type,
            colors: colors,
            typography: typography,
          ).color,
          colors.textLink,
        );
        expect(
          CoreCalculatorChipTheme.factorColor(type: type, colors: colors),
          colors.iconOrient,
        );
      });

      test('${entry.key}: a closed bracket is solid teal on the blue fill', () {
        const type = CoreCalculatorChipType.bracketClosed;
        expect(
          CoreCalculatorChipTheme.background(type: type, colors: colors),
          colors.backgroundBlueMid,
        );
        expect(
          CoreCalculatorChipTheme.borderColor(type: type, colors: colors),
          colors.outlineFocus,
        );
        expect(
          CoreCalculatorChipTheme.dashedOutline(type: type, colors: colors),
          isNull,
        );
        expect(CoreCalculatorChipTheme.shadow(type), isNull);
        expect(
          CoreCalculatorChipTheme.labelStyle(
            type: type,
            colors: colors,
            typography: typography,
          ).color,
          colors.textLink,
        );
        expect(
          CoreCalculatorChipTheme.factorColor(type: type, colors: colors),
          colors.iconOrient,
        );
      });

      test('${entry.key}: stale wears the result fill under a grey dash', () {
        const type = CoreCalculatorChipType.stale;
        expect(
          CoreCalculatorChipTheme.background(type: type, colors: colors),
          colors.backgroundGrayMid,
        );
        expect(
          CoreCalculatorChipTheme.borderColor(type: type, colors: colors),
          colors.transparent,
        );
        final outline =
            CoreCalculatorChipTheme.dashedOutline(type: type, colors: colors)!;
        expect(outline.color, colors.lineDarkOutline);
        expect(outline.strokeWidth, CoreCalculatorChipTheme.borderWidth);
        expect(CoreCalculatorChipTheme.shadow(type), isNull);
        expect(
          CoreCalculatorChipTheme.valueStyle(
            type: type,
            colors: colors,
            typography: typography,
          ).color,
          colors.textDark,
        );
        expect(
          CoreCalculatorChipTheme.factorColor(type: type, colors: colors),
          colors.iconGrayDark,
        );
      });

      test('${entry.key}: error uses the alert fill and a regular value', () {
        const type = CoreCalculatorChipType.error;
        expect(
          CoreCalculatorChipTheme.background(type: type, colors: colors),
          colors.alertRed,
        );
        expect(
          CoreCalculatorChipTheme.borderColor(type: type, colors: colors),
          colors.alertRedOutline,
        );
        expect(CoreCalculatorChipTheme.shadow(type), CoreShadows.small);
        final valueStyle = CoreCalculatorChipTheme.valueStyle(
          type: type,
          colors: colors,
          typography: typography,
        );
        expect(valueStyle.color, colors.textDark);
        expect(valueStyle.fontWeight, typography.bodyMediumRegular.fontWeight);
        expect(
          CoreCalculatorChipTheme.factorColor(type: type, colors: colors),
          colors.iconRed,
        );
        expect(
          CoreCalculatorChipTheme.dashedOutline(type: type, colors: colors),
          isNull,
        );
      });
    }
  });

  group('CoreCalculatorChip – accessibility', () {
    testWidgets('exposes semantic label and button role',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      const label = 'Test';
      const value = '100';

      await tester.pumpWidget(
        buildTestApp(
          CoreCalculatorChip(
            type: CoreCalculatorChipType.editable,
            label: label,
            value: value,
            onTap: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final chipFinder = find.byType(CoreCalculatorChip);
      expect(chipFinder, findsOneWidget);
      expect(find.byType(CoreIconWidget), findsNothing);

      final semantics = tester.getSemantics(chipFinder);
      expect(semantics.label, '$label, $value');
      expect(semantics.flagsCollection.isButton, isTrue);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => CoreCalculatorChip(
          type: CoreCalculatorChipType.editable,
          label: label,
          value: value,
          onTap: () {},
        ),
        chipFinder,
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    for (final type in [
      CoreCalculatorChipType.result,
      CoreCalculatorChipType.dashed,
      CoreCalculatorChipType.error,
      CoreCalculatorChipType.bracketOpen,
      CoreCalculatorChipType.bracketClosed,
      CoreCalculatorChipType.stale,
    ]) {
      testWidgets('$type text meets contrast guidelines in both themes',
          (WidgetTester tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => CoreCalculatorChip(
            type: type,
            label: 'Area',
            value: type == CoreCalculatorChipType.stale ? null : '410.67ft²',
            semanticsLabel:
                type == CoreCalculatorChipType.stale ? 'Area, pending' : null,
            onTap: () {},
          ),
          find.byType(CoreCalculatorChip),
          checkTapTargetSize: false,
          checkLabeledTapTarget: false,
          checkTextContrast: true,
        );
      });
    }

    testWidgets('an inert chip reports itself disabled with no tap action',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      await tester.pumpWidget(
        buildTestApp(
          CoreCalculatorChip(
            type: CoreCalculatorChipType.editable,
            factor: CoreIcons.multiplyOperator,
            value: '5',
            inert: true,
            onTap: () {},
            onLongPress: () {},
          ),
          theme: CoreTheme.light(),
        ),
      );

      final data = tester
          .getSemantics(find.byType(CoreCalculatorChip))
          .getSemanticsData();
      expect(data.label, '5');
      expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      expect(data.hasAction(SemanticsAction.longPress), isFalse);
    });

    testWidgets('an inert tape still meets the guidelines in both themes',
        (WidgetTester tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const Wrap(
          spacing: CoreSpacing.space2,
          children: [
            CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              value: '2',
              inert: true,
            ),
            CoreCalculatorChip(
              type: CoreCalculatorChipType.bracketOpen,
              factor: CoreIcons.addOperator,
              value: '3×4',
            ),
            CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              factor: CoreIcons.multiplyOperator,
              value: '5',
              inert: true,
            ),
            CoreCalculatorChip(
              type: CoreCalculatorChipType.stale,
              label: 'Calc',
              semanticsLabel: 'Calc, pending',
              inert: true,
            ),
          ],
        ),
        find.byType(Wrap),
        checkTapTargetSize: false,
        checkLabeledTapTarget: false,
        checkTextContrast: true,
      );
    });

    group('a dimmed chip keeps the 3:1 component floor', () {
      double contrast(Color a, Color b) {
        final la = a.computeLuminance();
        final lb = b.computeLuminance();
        final lighter = la > lb ? la : lb;
        final darker = la > lb ? lb : la;
        return (lighter + 0.05) / (darker + 0.05);
      }

      final typography = AppTypographyExtension.create();
      final themes = {
        'light': AppColorsExtension.create(),
        'dark': AppColorsExtension.createDark(),
      };
      Color dimmed(Color color, AppColorsExtension colors) => Color.lerp(
            colors.pageBackground,
            color,
            CoreCalculatorChipTheme.inertOpacity,
          )!;

      for (final entry in themes.entries) {
        final colors = entry.value;
        for (final type in CoreCalculatorChipType.values) {
          final fill = dimmed(
            CoreCalculatorChipTheme.background(type: type, colors: colors),
            colors,
          );

          test('${entry.key}: inert $type value and label', () {
            final value = CoreCalculatorChipTheme.valueStyle(
              type: type,
              colors: colors,
              typography: typography,
            ).color!;
            final label = CoreCalculatorChipTheme.labelStyle(
              type: type,
              colors: colors,
              typography: typography,
            ).color!;

            expect(
              contrast(dimmed(value, colors), fill),
              greaterThanOrEqualTo(3),
            );
            expect(
              contrast(dimmed(label, colors), fill),
              greaterThanOrEqualTo(3),
            );
          });

          test('${entry.key}: inert $type factor', () {
            final factor = CoreCalculatorChipTheme.factorColor(
              type: type,
              colors: colors,
              inert: true,
            );

            expect(
              contrast(dimmed(factor, colors), fill),
              greaterThanOrEqualTo(3),
            );
          });
        }

        for (final type in [
          CoreCalculatorChipType.editable,
          CoreCalculatorChipType.dashed,
          CoreCalculatorChipType.bracketOpen,
          CoreCalculatorChipType.bracketClosed,
        ]) {
          test('${entry.key}: inert $type teal edge', () {
            final edge = dimmed(
              CoreCalculatorChipTheme.edgeColor(type: type, colors: colors),
              colors,
            );
            final fill = dimmed(
              CoreCalculatorChipTheme.background(type: type, colors: colors),
              colors,
            );

            expect(
              contrast(edge, colors.pageBackground),
              greaterThanOrEqualTo(3),
            );
            expect(contrast(edge, fill), greaterThanOrEqualTo(3));
          });
        }
      }
    });

    testWidgets('factor icon is excluded from semantics tree', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: Scaffold(
            body: CoreCalculatorChip(
              type: CoreCalculatorChipType.editable,
              value: '100',
              factor: CoreIcons.addOperator,
              onTap: () {},
            ),
          ),
        ),
      );

      final chipFinder = find.byType(CoreCalculatorChip);
      final semantics = tester.getSemantics(chipFinder);
      expect(semantics.label, '100');
    });

    testWidgets(
        'exposes the long-press action and hint while onLongPress is set',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.result,
          label: 'Area',
          value: '410.67ft²',
          onLongPress: () {},
          longPressSemanticLabel: 'show provenance',
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCalculatorChip));
      expect(
        semantics.getSemanticsData().hasAction(SemanticsAction.longPress),
        isTrue,
      );
      expect(semantics.hintOverrides!.onLongPressHint, 'show provenance');
    });

    testWidgets('withholds the long-press action and hint without onLongPress',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        const CoreCalculatorChip(
          type: CoreCalculatorChipType.result,
          label: 'Area',
          value: '410.67ft²',
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCalculatorChip));
      expect(
        semantics.getSemanticsData().hasAction(SemanticsAction.longPress),
        isFalse,
      );
      expect(semantics.hintOverrides, isNull);
    });

    testWidgets('throws assertion if longPressSemanticLabel has no onLongPress',
        (WidgetTester tester) async {
      expect(
        () => CoreCalculatorChip(
          type: CoreCalculatorChipType.result,
          label: 'Area',
          value: '410.67ft²',
          longPressSemanticLabel: 'show provenance',
        ),
        throwsAssertionError,
      );
    });

    testWidgets('withholds the long-press action and hint when disabled',
        (WidgetTester tester) async {
      await pumpChip(
        tester,
        CoreCalculatorChip(
          type: CoreCalculatorChipType.disabled,
          label: 'Area',
          value: '410.67ft²',
          onLongPress: () {},
          longPressSemanticLabel: 'show provenance',
        ),
      );

      final semantics = tester.getSemantics(find.byType(CoreCalculatorChip));
      expect(
        semantics.getSemanticsData().hasAction(SemanticsAction.longPress),
        isFalse,
      );
      expect(semantics.hintOverrides, isNull);
    });
  });
}
