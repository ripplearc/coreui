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

    testWidgets('a closed bracket refuses to be empty',
        (WidgetTester tester) async {
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

    testWidgets('tapSemanticLabel without onTap is refused',
        (WidgetTester tester) async {
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
            value: '410.67ft²',
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
    ]) {
      testWidgets('$type text meets contrast guidelines in both themes',
          (WidgetTester tester) async {
        await setupA11yTest(tester);

        await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
          tester,
          (theme) => CoreCalculatorChip(
            type: type,
            label: 'Area',
            value: '410.67ft²',
            onTap: () {},
          ),
          find.byType(CoreCalculatorChip),
          checkTapTargetSize: false,
          checkLabeledTapTarget: false,
          checkTextContrast: true,
        );
      });
    }

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
