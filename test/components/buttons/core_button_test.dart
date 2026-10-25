import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../load_fonts.dart';

Widget _wrapWithTheme(Widget child) {
  return MaterialApp(
    theme: CoreTheme.light(),
    home: Scaffold(body: child),
  );
}

void main() {
  setUpAll(() async {
    await loadFonts();
  });

  group('CoreButton Widget Tests', () {
    testWidgets('renders label text when label is provided', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(const CoreButton(label: 'Click Me')),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('renders custom child widget when child is provided',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            child: Icon(Icons.add, key: Key('custom_child')),
          ),
        ),
      );

      expect(find.byKey(const Key('custom_child')), findsOneWidget);
      expect(find.text('Click Me'), findsNothing);
    });

    testWidgets('prefers child over label when both are provided',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'fallback',
            child: Icon(Icons.star, key: Key('star_icon')),
          ),
        ),
      );

      expect(find.byKey(const Key('star_icon')), findsOneWidget);
      expect(find.text('fallback'), findsNothing);
    });

    testWidgets('shows a leading icon when icon is provided and trailing=false',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'With Icon',
            icon: CoreIconWidget(icon: CoreIcons.add),
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('shows a trailing icon when trailing=true', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'With Trailing',
            icon: CoreIconWidget(icon: CoreIcons.arrowRight),
            trailing: true,
          ),
        ),
      );

      expect(find.byType(CoreIconWidget), findsOneWidget);
    });

    testWidgets('calls onPressed when tapped and button is enabled',
        (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Tap Me',
            onPressed: () => pressed = true,
          ),
        ),
      );

      await tester.tap(find.byType(CoreButton));
      expect(pressed, isTrue);
    });

    testWidgets('does not call onPressed when isDisabled=true', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Disabled',
            onPressed: () => pressed = true,
            isDisabled: true,
          ),
        ),
      );

      await tester.tap(find.byType(CoreButton));
      expect(pressed, isFalse);
    });

    testWidgets('does not call onPressed when onPressed is null',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(label: 'No Callback', onPressed: null),
        ),
      );

      await tester.tap(find.byType(CoreButton));
    });

    testWidgets('expands to full parent width when fullWidth=true',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const Align(
            alignment: Alignment.topLeft,
            child: CoreButton(label: 'Full', fullWidth: true),
          ),
        ),
      );

      final size = tester.getSize(find.byType(CoreButton));
      expect(size.width, equals(800.0));
    });

    testWidgets('shrinks to content width when fullWidth=false',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          const Align(
            alignment: Alignment.topLeft,
            child: IntrinsicWidth(
              child: CoreButton(label: 'Compact', fullWidth: false),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(CoreButton));
      expect(size.width, lessThan(800.0));
    });

    testWidgets('social variant throws when size is not large', (tester) async {
      final List<FlutterErrorDetails> errors = [];
      final originalOnError = FlutterError.onError;

      FlutterError.onError = (details) => errors.add(details);
      addTearDown(() => FlutterError.onError = originalOnError);

      await tester.pumpWidget(
        _wrapWithTheme(
          const CoreButton(
            label: 'Social Small',
            variant: CoreButtonVariant.social,
            size: CoreButtonSize.small,
          ),
        ),
      );

      expect(
        errors.any((e) => e.exception is ArgumentError),
        isTrue,
        reason: 'Expected an ArgumentError when social variant is not large',
      );
    });
    testWidgets('applies shadows when shadows are provided', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'With Shadow',
            shadows: CoreShadows.small,
          ),
        ),
      );

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(CoreButton),
          matching: find.byType(DecoratedBox),
        ),
      );

      expect(decoratedBoxes, isNotEmpty);

      final outerDecoration = decoratedBoxes.first.decoration as BoxDecoration;
      expect(outerDecoration.boxShadow, isNotNull);
      expect(outerDecoration.boxShadow, isNotEmpty);
    });

    testWidgets('has no shadows by default', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(const CoreButton(label: 'No Shadow')),
      );

      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(CoreButton),
          matching: find.byType(DecoratedBox),
        ),
      );

      expect(decoratedBoxes, isNotEmpty);

      final outerDecoration = decoratedBoxes.first.decoration as BoxDecoration;
      expect(outerDecoration.boxShadow, isNull);
    });
  });

  group('CoreButton border overrides', () {
    BorderSide sideOf(WidgetTester tester) {
      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(CoreButton),
          matching: find.byType(DecoratedBox),
        ),
      );
      final decoration =
          decoratedBoxes.elementAt(1).decoration as BoxDecoration;
      return (decoration.border as Border).top;
    }

    testWidgets('a secondary button keeps its 2px variant border by default',
        (tester) async {
      final colors = AppColorsExtension.create();
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Secondary',
            variant: CoreButtonVariant.secondary,
            onPressed: () {},
          ),
        ),
      );

      final side = sideOf(tester);
      expect(side.color, colors.buttonSurface);
      expect(side.width, 2);
    });

    testWidgets('borderColor and borderWidth override the variant border',
        (tester) async {
      final colors = AppColorsExtension.create();
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Hairline',
            variant: CoreButtonVariant.secondary,
            onPressed: () {},
            shadows: CoreShadows.small,
            borderColor: colors.lineMid,
            borderWidth: CoreButton.hairlineBorderWidth,
          ),
        ),
      );

      final side = sideOf(tester);
      expect(side.color, colors.lineMid);
      expect(side.width, CoreButton.hairlineBorderWidth);
    });
  });

  group('CoreButton design library looks', () {
    final colors = AppColorsExtension.create();
    final typography = AppTypographyExtension.create();

    BoxDecoration fillOf(WidgetTester tester) {
      final decoratedBoxes = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: find.byType(CoreButton),
          matching: find.byType(DecoratedBox),
        ),
      );
      return decoratedBoxes.elementAt(1).decoration as BoxDecoration;
    }

    Finder focusRing() => find.descendant(
          of: find.byType(CoreButton),
          matching: find.byWidgetPredicate((widget) {
            if (widget is! DecoratedBox) return false;
            final decoration = widget.decoration;
            if (decoration is! BoxDecoration) return false;
            final border = decoration.border;
            return border is Border &&
                border.top ==
                    BorderSide(
                      color: colors.outlineFocus,
                      width: CoreButton.focusRingWidth,
                    );
          }),
        );

    Size fillSizeOf(WidgetTester tester) => tester.getSize(
          find
              .descendant(
                of: find.byType(CoreButton),
                matching: find.byType(DecoratedBox),
              )
              .at(1),
        );

    TextStyle labelStyleOf(WidgetTester tester, String label) =>
        tester.widget<Text>(find.text(label)).style!;

    testWidgets('a pressed primary button fills with buttonPress',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(CoreButton(label: 'Primary', onPressed: () {})),
      );

      final gesture =
          await tester.startGesture(tester.getCenter(find.byType(CoreButton)));
      await tester.pump();

      expect(fillOf(tester).color, colors.buttonPress);
      await gesture.up();
    });

    testWidgets(
        'a focused primary button keeps its surface fill and draws the '
        'focus ring 5px outside', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          Center(
            child: CoreButton(
              label: 'Primary',
              onPressed: () {},
              autofocus: true,
              fullWidth: false,
            ),
          ),
        ),
      );
      await tester.pump();

      expect(fillOf(tester).color, colors.buttonSurface);
      expect(focusRing(), findsOneWidget);

      final buttonRect = tester.getRect(find.byType(CoreButton));
      final ringRect = tester.getRect(focusRing());
      expect(
        ringRect,
        buttonRect.inflate(CoreButton.focusRingOffset),
      );
      final ringBorder = (tester.widget<DecoratedBox>(focusRing()).decoration
              as BoxDecoration)
          .border as Border;
      expect(ringBorder.top.width, CoreButton.focusRingWidth);
    });

    testWidgets('fills the height its parent forces on it', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          Center(
            child: SizedBox(
              height: 68,
              child: CoreButton(label: 'Tall', onPressed: () {}),
            ),
          ),
        ),
      );

      expect(
        tester.getCenter(find.text('Tall')).dy,
        moreOrLessEquals(tester.getCenter(find.byType(CoreButton)).dy),
      );
      expect(fillSizeOf(tester).height, 68);
    });

    for (final (size, height) in [
      (CoreButtonSize.small, 36.0),
      (CoreButtonSize.medium, 40.0),
    ]) {
      testWidgets('a ${size.name} button keeps its ${height.toInt()}px look '
          'in a 48px tap area', (tester) async {
        var taps = 0;
        await tester.pumpWidget(
          _wrapWithTheme(
            Center(
              child: CoreButton(
                label: 'Add',
                size: size,
                fullWidth: false,
                onPressed: () => taps++,
              ),
            ),
          ),
        );

        expect(fillSizeOf(tester).height, height);
        final target = tester.getRect(find.byType(CoreButton));
        expect(target.height, 48);
        expect(target.width, greaterThanOrEqualTo(48));

        await tester.tapAt(target.topCenter + const Offset(0, 1));
        await tester.tapAt(target.bottomCenter - const Offset(0, 1));
        expect(taps, 2);
      });
    }

    testWidgets('a small button grows with 200% text so the label is not cut',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CoreTheme.light(),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: Center(
                child: CoreButton(
                  label: 'Add',
                  size: CoreButtonSize.small,
                  fullWidth: false,
                  onPressed: () {},
                ),
              ),
            ),
          ),
        ),
      );

      final label = tester.renderObject<RenderBox>(find.text('Add'));
      expect(
        label.size.height,
        greaterThanOrEqualTo(label.getMinIntrinsicHeight(label.size.width)),
      );
      expect(fillSizeOf(tester).height, greaterThan(36));
    });

    testWidgets('an unfocused primary button draws no focus ring',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(CoreButton(label: 'Primary', onPressed: () {})),
      );

      expect(focusRing(), findsNothing);
    });

    testWidgets('a focused secondary button keeps its look and draws the ring',
        (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Secondary',
            variant: CoreButtonVariant.secondary,
            onPressed: () {},
            autofocus: true,
          ),
        ),
      );
      await tester.pump();

      expect(labelStyleOf(tester, 'Secondary').color, colors.buttonSurface);
      expect(focusRing(), findsOneWidget);
    });

    testWidgets('a large button has 20px side padding', (tester) async {
      const iconKey = Key('icon');
      await tester.pumpWidget(
        _wrapWithTheme(
          Center(
            child: CoreButton(
              label: 'Primary',
              onPressed: () {},
              fullWidth: false,
              icon: const CoreIconWidget(key: iconKey, icon: CoreIcons.add),
            ),
          ),
        ),
      );

      final buttonLeft = tester.getTopLeft(find.byType(CoreButton)).dx;
      final iconLeft = tester.getTopLeft(find.byKey(iconKey)).dx;
      expect(iconLeft - buttonLeft, CoreSpacing.space5);
    });

    testWidgets('a small button uses Body Medium Semibold', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(
          CoreButton(
            label: 'Small',
            size: CoreButtonSize.small,
            onPressed: () {},
          ),
        ),
      );

      final style = labelStyleOf(tester, 'Small');
      expect(style.fontSize, typography.bodyMediumSemiBold.fontSize);
      expect(style.fontWeight, typography.bodyMediumSemiBold.fontWeight);
    });

    testWidgets('a large button keeps Body Large Semibold', (tester) async {
      await tester.pumpWidget(
        _wrapWithTheme(CoreButton(label: 'Large', onPressed: () {})),
      );

      final style = labelStyleOf(tester, 'Large');
      expect(style.fontSize, typography.bodyLargeSemiBold.fontSize);
      expect(style.fontWeight, typography.bodyLargeSemiBold.fontWeight);
    });

    group('social variant', () {
      const iconKey = Key('logo');
      const label = 'Continue with Google';

      Widget social({bool isDisabled = false}) => _wrapWithTheme(
            CoreButton(
              label: label,
              variant: CoreButtonVariant.social,
              onPressed: () {},
              isDisabled: isDisabled,
              icon: const CoreIconWidget(
                key: iconKey,
                icon: CoreIcons.google,
                size: CoreSpacing.space6,
              ),
            ),
          );

      testWidgets('is 48px tall in a column', (tester) async {
        await tester.pumpWidget(
          _wrapWithTheme(
            Column(
              children: [
                CoreButton(
                  label: label,
                  variant: CoreButtonVariant.social,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        );

        expect(tester.getSize(find.byType(CoreButton)).height, 48);
      });

      testWidgets('stays 48px tall when its parent offers more height',
          (tester) async {
        await tester.pumpWidget(
          _wrapWithTheme(
            Center(
              child: SizedBox(
                height: 300,
                child: Center(
                  child: CoreButton(
                    label: label,
                    variant: CoreButtonVariant.social,
                    onPressed: () {},
                  ),
                ),
              ),
            ),
          ),
        );

        expect(tester.getSize(find.byType(CoreButton)).height, 48);
      });

      testWidgets('puts the logo 20px from the left edge', (tester) async {
        await tester.pumpWidget(social());

        final buttonLeft = tester.getTopLeft(find.byType(CoreButton)).dx;
        final iconLeft = tester.getTopLeft(find.byKey(iconKey)).dx;
        expect(iconLeft - buttonLeft, CoreSpacing.space5);
      });

      testWidgets('keeps the logo clear of the text when not full width',
          (tester) async {
        await tester.pumpWidget(
          _wrapWithTheme(
            Center(
              child: CoreButton(
                label: label,
                variant: CoreButtonVariant.social,
                fullWidth: false,
                onPressed: () {},
                icon: const CoreIconWidget(
                  key: iconKey,
                  icon: CoreIcons.google,
                  size: CoreSpacing.space6,
                ),
              ),
            ),
          ),
        );

        final buttonWidth = tester.getSize(find.byType(CoreButton)).width;
        final iconRect = tester.getRect(find.byKey(iconKey));
        final textRect = tester.getRect(find.text(label));
        const logoWithGap = CoreSpacing.space6 + CoreSpacing.space2;
        const sides = 2 * (logoWithGap + CoreSpacing.space5);
        expect(buttonWidth, moreOrLessEquals(textRect.width + sides));
        expect(textRect.left - iconRect.right,
            greaterThanOrEqualTo(CoreSpacing.space2));
      });

      testWidgets('keeps a long label 8px clear of the logo at 200% text',
          (tester) async {
        const longLabel = 'Continue with Microsoft';
        await tester.pumpWidget(
          _wrapWithTheme(
            MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Center(
                child: SizedBox(
                  width: 328,
                  child: CoreButton(
                    label: longLabel,
                    variant: CoreButtonVariant.social,
                    onPressed: () {},
                    icon: const CoreIconWidget(
                      key: iconKey,
                      icon: CoreIcons.microsoft,
                      size: CoreSpacing.space6,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        final logoRight = tester.getRect(find.byKey(iconKey)).right;
        final labelLeft = tester.getRect(find.text(longLabel)).left;
        expect(labelLeft - logoRight, greaterThanOrEqualTo(CoreSpacing.space2));
      });

      testWidgets('centres the text on the button', (tester) async {
        await tester.pumpWidget(social());

        expect(
          tester.getCenter(find.text(label)).dx,
          moreOrLessEquals(tester.getCenter(find.byType(CoreButton)).dx),
        );
      });

      testWidgets('uses Body Large Medium', (tester) async {
        await tester.pumpWidget(social());

        final style = labelStyleOf(tester, label);
        expect(style.fontSize, typography.bodyLargeMedium.fontSize);
        expect(style.fontWeight, typography.bodyLargeMedium.fontWeight);
      });

      testWidgets('draws a 1px Line Mid border', (tester) async {
        await tester.pumpWidget(social());

        final side = (fillOf(tester).border as Border).top;
        expect(side.color, colors.lineMid);
        expect(side.width, 1);
      });

      testWidgets('fills Grey Mid and keeps the Line Mid border when pressed',
          (tester) async {
        await tester.pumpWidget(social());

        final gesture = await tester
            .startGesture(tester.getCenter(find.byType(CoreButton)));
        await tester.pump();

        final decoration = fillOf(tester);
        expect(decoration.color, colors.backgroundGrayMid);
        expect((decoration.border as Border).top.color, colors.lineMid);
        await gesture.up();
      });

      testWidgets('uses Text Color/Disable when disabled', (tester) async {
        await tester.pumpWidget(social(isDisabled: true));

        expect(labelStyleOf(tester, label).color, colors.textDisable);
      });
    });
  });
}
