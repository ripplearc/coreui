import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
  final underline = find.byKey(CoreUnderlineTextField.underlineKey);

  Future<void> pumpField(
    WidgetTester tester,
    CoreUnderlineTextField field, {
    ThemeData? theme,
  }) async {
    await tester.pumpWidget(
      buildTestApp(
        SizedBox(width: 372, child: field),
        theme: theme ?? CoreTheme.light(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Color? underlineColor(WidgetTester tester) =>
      tester.widget<Container>(underline).color;

  double underlineWeight(WidgetTester tester) =>
      tester.getSize(underline).height;

  TextField inner(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField));

  group('CoreUnderlineTextField – text size', () {
    for (final size in CoreUnderlineTextFieldSize.values) {
      testWidgets('$size rows grow so the label is not drawn over the value',
          (tester) async {
        Future<void> pumpAt(double scale) => tester.pumpWidget(
              buildTestApp(
                MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: SizedBox(
                    width: 372,
                    child: CoreUnderlineTextField(
                      label: 'Equipment',
                      initialValue: 'Mini excavator',
                      size: size,
                    ),
                  ),
                ),
                theme: CoreTheme.light(),
              ),
            );

        await pumpAt(1);
        final normalHeight =
            tester.getSize(find.byType(CoreUnderlineTextField)).height;

        await pumpAt(1.6);
        final scaledHeight =
            tester.getSize(find.byType(CoreUnderlineTextField)).height;
        final label = tester.getRect(find.text('Equipment'));
        final value = tester.getRect(find.byType(EditableText));

        expect(scaledHeight, greaterThan(normalHeight));
        expect(label.bottom, lessThanOrEqualTo(value.top));
      });
    }
  });

  group('CoreUnderlineTextField – text size with slots', () {
    testWidgets('a rate row with a wide trailing widget builds at 1.6 times',
        (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child: const SizedBox(
              width: 372,
              child: CoreUnderlineTextField(
                label: 'Rate applied',
                prefixText: r'$',
                initialValue: '145.00',
                unitText: '/day',
                trailing: SizedBox(width: 120, height: 36),
              ),
            ),
          ),
          theme: CoreTheme.light(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(EditableText)).width, greaterThan(0));
    });
  });

  group('CoreUnderlineTextField – content', () {
    testWidgets('shows the label above the value', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Equipment'),
      );

      final label = tester.getTopLeft(find.text('Equipment'));
      final value = tester.getTopLeft(find.byType(TextField));
      expect(label.dy, lessThan(value.dy));
    });

    testWidgets('draws no label when none is given', (tester) async {
      await pumpField(tester, const CoreUnderlineTextField());

      expect(find.byType(Text), findsNothing);
    });

    testWidgets('shows the hint while empty and hides it once typed',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Equipment',
          hintText: 'Name the equipment',
        ),
      );

      double hintOpacity() => tester
          .widget<AnimatedOpacity>(
            find.ancestor(
              of: find.text('Name the equipment'),
              matching: find.byType(AnimatedOpacity),
            ),
          )
          .opacity;

      expect(hintOpacity(), 1);

      await tester.enterText(find.byType(TextField), 'Mini excavator');
      await tester.pumpAndSettle();

      expect(hintOpacity(), 0);
    });

    testWidgets('starts with initialValue', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate', initialValue: '145.00'),
      );

      expect(find.text('145.00'), findsOneWidget);
    });

    testWidgets('a given controller wins over initialValue', (tester) async {
      final controller = TextEditingController(text: 'from controller');
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          initialValue: 'ignored',
          controller: controller,
        ),
      );

      expect(find.text('from controller'), findsOneWidget);
      expect(find.text('ignored'), findsNothing);
    });

    testWidgets('reports every change to onChanged', (tester) async {
      final changes = <String>[];

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', onChanged: changes.add),
      );
      await tester.enterText(find.byType(TextField), '4');
      await tester.enterText(find.byType(TextField), '45');

      expect(changes, ['4', '45']);
    });

    testWidgets('reports the action key to onSubmitted', (tester) async {
      String? submitted;

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          onSubmitted: (value) => submitted = value,
        ),
      );
      await tester.enterText(find.byType(TextField), '45');
      await tester.testTextInput.receiveAction(TextInputAction.done);

      expect(submitted, '45');
    });

    testWidgets('passes the keyboard type and action to the text field',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
        ),
      );

      expect(inner(tester).keyboardType, TextInputType.number);
      expect(inner(tester).textInputAction, TextInputAction.next);
    });

    testWidgets('applies the caller inputFormatters', (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      );
      await tester.enterText(find.byType(TextField), '4a5b');

      expect(find.text('45'), findsOneWidget);
    });

    testWidgets('keeps the text and the caret when a formatter refuses a key',
        (tester) async {
      final controller = TextEditingController(text: '12');
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          controller: controller,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      );
      await tester.showKeyboard(find.byType(TextField));
      controller.selection = const TextSelection.collapsed(offset: 1);
      await tester.pump();

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: '1a2',
          selection: TextSelection.collapsed(offset: 2),
        ),
      );
      await tester.pump();

      expect(controller.text, '12');
      expect(controller.selection, const TextSelection.collapsed(offset: 1));
    });

    testWidgets('keeps the text and the caret when a key is typed at maxLength',
        (tester) async {
      final controller = TextEditingController(text: '123');
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          controller: controller,
          maxLength: 3,
        ),
      );
      await tester.showKeyboard(find.byType(TextField));
      controller.selection = const TextSelection.collapsed(offset: 1);
      await tester.pump();

      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: '1423',
          selection: TextSelection.collapsed(offset: 2),
        ),
      );
      await tester.pump();

      expect(controller.text, '123');
      expect(controller.selection, const TextSelection.collapsed(offset: 1));
    });

    testWidgets('stops accepting characters at maxLength with no counter',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Material', maxLength: 5),
      );
      await tester.enterText(find.byType(TextField), '1234567');

      expect(find.text('12345'), findsOneWidget);
      expect(find.text('5/5'), findsNothing);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('combines the caller inputFormatters with maxLength',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          maxLength: 3,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      );
      await tester.enterText(find.byType(TextField), '1a2b3c4d5');

      expect(find.text('123'), findsOneWidget);
    });

    testWidgets('takes focus on build when autofocus is set', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          focusNode: focusNode,
          autofocus: true,
        ),
      );

      expect(focusNode.hasFocus, isTrue);
    });
  });

  group('CoreUnderlineTextField – underline', () {
    for (final theme in kA11yTestThemes) {
      final name = theme.brightness.name;

      testWidgets('regular rests on lineDarkOutline, 1px ($name)',
          (tester) async {
        await pumpField(
          tester,
          const CoreUnderlineTextField(label: 'Rate'),
          theme: theme,
        );

        expect(underlineColor(tester), theme.coreColors.lineDarkOutline);
        expect(underlineWeight(tester), 1);
      });

      testWidgets('large rests on lineMid, 2px ($name)', (tester) async {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
            label: 'Amount',
            size: CoreUnderlineTextFieldSize.large,
          ),
          theme: theme,
        );

        expect(underlineColor(tester), theme.coreColors.lineMid);
        expect(underlineWeight(tester), 2);
      });

      testWidgets('regular turns outlineHover on focus, still 1px ($name)',
          (tester) async {
        await pumpField(
          tester,
          const CoreUnderlineTextField(label: 'Rate'),
          theme: theme,
        );
        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        expect(underlineColor(tester), theme.coreColors.outlineHover);
        expect(underlineWeight(tester), 1);
      });

      testWidgets('large turns outlineHover on focus, still 2px ($name)',
          (tester) async {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
            label: 'Amount',
            size: CoreUnderlineTextFieldSize.large,
          ),
          theme: theme,
        );
        await tester.tap(find.byType(TextField));
        await tester.pumpAndSettle();

        expect(underlineColor(tester), theme.coreColors.outlineHover);
        expect(underlineWeight(tester), 2);
      });
    }

    testWidgets('returns to the rest color when focus leaves', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: focusNode),
      );
      final colors = CoreTheme.light().coreColors;

      focusNode.requestFocus();
      await tester.pumpAndSettle();
      expect(underlineColor(tester), colors.outlineHover);

      focusNode.unfocus();
      await tester.pumpAndSettle();
      expect(underlineColor(tester), colors.lineDarkOutline);
    });

    testWidgets('tapping the label or the underline focuses the field',
        (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: focusNode),
      );

      await tester.tap(find.text('Rate'));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);

      focusNode.unfocus();
      await tester.pump();

      await tester.tap(underline);
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
    });

    for (final size in CoreUnderlineTextFieldSize.values) {
      for (final maxLines in [1, 3]) {
        testWidgets('with no label, a ${size.name} field with maxLines '
            '$maxLines takes taps over 48 px and no further', (tester) async {
          final focusNode = FocusNode();
          addTearDown(focusNode.dispose);
          // A form row: content above and below, so the parents have room
          // for the touch area to reach into.
          await tester.pumpWidget(
            buildTestApp(
              SizedBox(
                width: 372,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: kMinInteractiveDimension),
                    CoreUnderlineTextField(
                      size: size,
                      maxLines: maxLines,
                      focusNode: focusNode,
                    ),
                    const SizedBox(height: kMinInteractiveDimension),
                  ],
                ),
              ),
              theme: CoreTheme.light(),
            ),
          );
          final field = tester.getRect(find.byType(CoreUnderlineTextField));
          expect(field.height, lessThan(kMinInteractiveDimension));

          Future<bool> tapFocuses(double dy) async {
            focusNode.unfocus();
            await tester.pump();
            await tester.tapAt(Offset(field.center.dx, dy));
            await tester.pump();
            return focusNode.hasFocus;
          }

          const reach = kMinInteractiveDimension / 2;
          expect(await tapFocuses(field.center.dy - reach + 0.5), isTrue);
          expect(await tapFocuses(field.center.dy + reach - 0.5), isTrue);
          expect(await tapFocuses(field.center.dy - reach - 2), isFalse);
          expect(await tapFocuses(field.center.dy + reach + 2), isFalse);
        });
      }
    }

    for (final gap in [0.0, 4.0, 8.0]) {
      testWidgets('with no label and a ${gap}px gap between two fields, a tap '
          'on either field focuses that field', (tester) async {
        final upper = FocusNode();
        final lower = FocusNode();
        addTearDown(upper.dispose);
        addTearDown(lower.dispose);
        await tester.pumpWidget(
          buildTestApp(
            SizedBox(
              width: 372,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CoreUnderlineTextField(
                    key: const Key('upper'),
                    focusNode: upper,
                  ),
                  SizedBox(height: gap),
                  CoreUnderlineTextField(
                    key: const Key('lower'),
                    focusNode: lower,
                  ),
                ],
              ),
            ),
            theme: CoreTheme.light(),
          ),
        );
        final upperRect = tester.getRect(find.byKey(const Key('upper')));
        final lowerRect = tester.getRect(find.byKey(const Key('lower')));

        await tester.tapAt(Offset(upperRect.center.dx, upperRect.bottom - 1));
        await tester.pump();
        expect(upper.hasFocus, isTrue);

        await tester.tapAt(Offset(lowerRect.center.dx, lowerRect.top + 1));
        await tester.pump();
        expect(lower.hasFocus, isTrue);
      });
    }

    testWidgets('hands over from its own focus node to a given one',
        (tester) async {
      final given = FocusNode();
      addTearDown(given.dispose);
      final colors = CoreTheme.light().coreColors;

      await pumpField(tester, const CoreUnderlineTextField(label: 'Rate'));
      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: given),
      );
      await tester.pump();

      expect(tester.takeException(), isNull);
      given.requestFocus();
      await tester.pumpAndSettle();
      expect(underlineColor(tester), colors.outlineHover);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(given.hasFocus, isTrue);
    });

    testWidgets('follows a replaced focus node', (tester) async {
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      final colors = CoreTheme.light().coreColors;

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: first),
      );
      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: second),
      );

      first.requestFocus();
      await tester.pumpAndSettle();
      expect(underlineColor(tester), colors.lineDarkOutline);

      second.requestFocus();
      await tester.pumpAndSettle();
      expect(underlineColor(tester), colors.outlineHover);
    });
  });

  group('CoreUnderlineTextField – focus node ownership', () {
    FocusNode ownedNode(WidgetTester tester) =>
        tester.widget<TextField>(find.byType(TextField)).focusNode!;

    testWidgets('disposes its own focus node with the field', (tester) async {
      await pumpField(tester, const CoreUnderlineTextField(label: 'Rate'));
      final node = ownedNode(tester);

      await tester.pumpWidget(const SizedBox());

      expect(() => node.addListener(() {}), throwsFlutterError);
    });

    testWidgets('disposes its own focus node once a given one replaces it',
        (tester) async {
      final given = FocusNode();
      addTearDown(given.dispose);
      await pumpField(tester, const CoreUnderlineTextField(label: 'Rate'));
      final owned = ownedNode(tester);

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: given),
      );
      await tester.pump();

      expect(() => owned.addListener(() {}), throwsFlutterError);
    });

    testWidgets('goes back to its own focus node when the given one is removed',
        (tester) async {
      final given = FocusNode();
      addTearDown(given.dispose);
      final colors = CoreTheme.light().coreColors;
      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: given),
      );

      await pumpField(tester, const CoreUnderlineTextField(label: 'Rate'));
      given.requestFocus();
      await tester.pumpAndSettle();
      expect(underlineColor(tester), colors.lineDarkOutline);

      await tester.tap(find.byType(TextField));
      await tester.pumpAndSettle();
      expect(underlineColor(tester), colors.outlineHover);
    });

    testWidgets('leaves the focus node it was given alive after it is removed',
        (tester) async {
      final given = FocusNode();
      addTearDown(given.dispose);
      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', focusNode: given),
      );

      await tester.pumpWidget(const SizedBox());

      expect(() => given.addListener(() {}), returnsNormally);
    });
  });

  group('CoreUnderlineTextField – keyboard', () {
    for (final target in ['label', 'underline']) {
      testWidgets('a tap on the $target brings a hidden keyboard back',
          (tester) async {
        await pumpField(
          tester,
          const CoreUnderlineTextField(label: 'Rate'),
        );
        await tester.tap(find.byType(TextField));
        await tester.pump();
        expect(tester.testTextInput.isVisible, isTrue);

        tester.testTextInput.hide();
        expect(tester.testTextInput.isVisible, isFalse);

        await tester.tap(
          target == 'label' ? find.text('Rate') : underline,
          warnIfMissed: false,
        );
        await tester.pump();

        expect(tester.testTextInput.isVisible, isTrue);
      });
    }
  });

  group('CoreUnderlineTextField – sizes', () {
    testWidgets('regular is 12/16 over 16/24 and 53px tall', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate', initialValue: '4'),
      );

      final label = tester.widget<Text>(find.text('Rate')).style as TextStyle;
      final value = inner(tester).style as TextStyle;

      expect(label.fontSize, 12);
      expect(label.height, 16 / 12);
      expect(value.fontSize, 16);
      expect(value.height, 24 / 16);
      expect(tester.getSize(find.byType(CoreUnderlineTextField)).height, 53);
    });

    testWidgets('large is 14/20 over 24/32 semibold and 66px tall',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Amount',
          initialValue: '4',
          size: CoreUnderlineTextFieldSize.large,
        ),
      );

      final label = tester.widget<Text>(find.text('Amount')).style as TextStyle;
      final value = inner(tester).style as TextStyle;

      expect(label.fontSize, 14);
      expect(label.height, 20 / 14);
      expect(value.fontSize, 24);
      expect(value.height, 32 / 24);
      expect(value.fontWeight, FontWeight.w600);
      expect(tester.getSize(find.byType(CoreUnderlineTextField)).height, 66);
    });

    testWidgets('the label sits flush for regular and large', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate'),
      );
      double labelInset() =>
          tester.getTopLeft(find.text('Rate')).dx -
          tester.getTopLeft(find.byType(CoreUnderlineTextField)).dx;
      expect(labelInset(), 0);

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Rate',
          size: CoreUnderlineTextFieldSize.large,
        ),
      );
      expect(labelInset(), 0);
    });

    testWidgets('label, value and underline stack at the Figma offsets',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate', initialValue: '4'),
      );
      final top = tester.getTopLeft(find.byType(CoreUnderlineTextField)).dy;

      expect(tester.getTopLeft(find.text('Rate')).dy - top, 0);
      expect(tester.getTopLeft(find.byType(EditableText)).dy - top, 20);
      expect(tester.getTopLeft(underline).dy - top, 52);
    });

    testWidgets('the typed text keeps the row height the design draws',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate', initialValue: '4'),
      );
      expect(tester.getSize(find.byType(EditableText)).height, 24);

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Amount',
          initialValue: '4',
          size: CoreUnderlineTextFieldSize.large,
        ),
      );
      expect(tester.getSize(find.byType(EditableText)).height, 32);
    });

    testWidgets('the caret is 2px wide and 16px or 24px tall once focused',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate', autofocus: true),
      );
      expect(inner(tester).cursorWidth, 2);
      expect(inner(tester).cursorHeight, 16);
      expect(
        inner(tester).cursorColor,
        CoreTheme.light().coreColors.outlineFocus,
      );

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Amount',
          autofocus: true,
          size: CoreUnderlineTextFieldSize.large,
        ),
      );
      expect(inner(tester).cursorHeight, 24);
    });
  });

  group('CoreUnderlineTextField – colors', () {
    for (final theme in kA11yTestThemes) {
      final name = theme.brightness.name;

      testWidgets(
          'label is textBody, value textHeadline, hint textDisable ($name)',
          (tester) async {
        final colors = theme.coreColors;

        await pumpField(
          tester,
          const CoreUnderlineTextField(
              label: 'Rate', hintText: 'Set your rate'),
          theme: theme,
        );

        expect(
            (tester.widget<Text>(find.text('Rate')).style as TextStyle).color,
            colors.textBody);
        expect((inner(tester).style as TextStyle).color, colors.textHeadline);
        expect(
            ((inner(tester).decoration as InputDecoration).hintStyle
                    as TextStyle)
                .color,
            colors.textDisable);
      });
    }

    testWidgets('draws no border of its own', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate'),
      );

      expect((inner(tester).decoration as InputDecoration).border,
          InputBorder.none);
      expect(find.byType(DecoratedBox), findsNothing);
    });
  });

  group('CoreUnderlineTextField – no Material above it', () {
    for (final size in CoreUnderlineTextFieldSize.values) {
      for (final maxLines in [1, 4]) {
        testWidgets('${size.name}, maxLines $maxLines builds and takes text',
            (tester) async {
          // MaterialApp gives no Material widget; only a Scaffold would.
          await tester.pumpWidget(
            MaterialApp(
              theme: CoreTheme.light(),
              home: Center(
                child: SizedBox(
                  width: 300,
                  child: CoreUnderlineTextField(
                    label: 'Scope of work',
                    size: size,
                    maxLines: maxLines,
                  ),
                ),
              ),
            ),
          );
          expect(find.byType(Scaffold), findsNothing);

          await tester.enterText(find.byType(TextField), 'Kitchen');
          await tester.pump();

          expect(tester.takeException(), isNull);
          expect(find.text('Kitchen'), findsOneWidget);
        });

        testWidgets('${size.name}, maxLines $maxLines draws its text as '
            'under a Scaffold', (tester) async {
          for (final hasError in [false, true]) {
            final field = CoreUnderlineTextField(
              label: 'Rate',
              size: size,
              maxLines: maxLines,
              prefixText: r'$',
              unitText: '/day',
              helperText: 'Per crew',
              errorText: hasError ? 'Enter a rate' : null,
            );
            final texts = [
              'Rate',
              r'$',
              '/day',
              if (hasError) 'Enter a rate' else 'Per crew',
            ];

            TextStyle? styleOf(String text) => tester
                .widget<RichText>(
                  find.descendant(
                    of: find.byType(CoreUnderlineTextField),
                    matching: find.byWidgetPredicate(
                      (w) => w is RichText && w.text.toPlainText() == text,
                    ),
                  ),
                )
                .text
                .style;

            await tester.pumpWidget(
              MaterialApp(
                theme: CoreTheme.light(),
                home: Scaffold(
                  body: Center(child: SizedBox(width: 300, child: field)),
                ),
              ),
            );
            final underScaffold = {for (final t in texts) t: styleOf(t)};

            // With no Material, Flutter draws text in monospace with a
            // yellow double underline.
            await tester.pumpWidget(
              MaterialApp(
                theme: CoreTheme.light(),
                home: Center(child: SizedBox(width: 300, child: field)),
              ),
            );
            expect(find.byType(Scaffold), findsNothing);

            for (final text in texts) {
              final style = styleOf(text);
              expect(
                style,
                isA<TextStyle>()
                    .having((s) => s.fontFamily, 'fontFamily',
                        isNot('monospace'))
                    .having((s) => s.decorationStyle, 'decorationStyle',
                        isNot(TextDecorationStyle.double)),
                reason: '"$text" with hasError $hasError',
              );
              expect(
                style,
                underScaffold[text],
                reason: '"$text" with hasError $hasError',
              );
            }
          }
        });
      }
    }
  });
}
