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
    testWidgets('regular is 12/16 over 16/24 and 54px tall', (tester) async {
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
      expect(tester.getSize(find.byType(CoreUnderlineTextField)).height, 54);
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

    testWidgets('the label sits 2px in for regular and flush for large',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate'),
      );
      double labelInset() =>
          tester.getTopLeft(find.text('Rate')).dx -
          tester.getTopLeft(find.byType(CoreUnderlineTextField)).dx;
      expect(labelInset(), 2);

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
      expect(tester.getTopLeft(find.byType(EditableText)).dy - top, 19);
      expect(tester.getTopLeft(underline).dy - top, 53);
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

    testWidgets('the caret is 2px wide and 17px or 24px tall', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate'),
      );
      expect(inner(tester).cursorWidth, 2);
      expect(inner(tester).cursorHeight, 17);
      expect(
          inner(tester).cursorColor, CoreTheme.light().coreColors.outlineFocus);

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Amount',
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
}
