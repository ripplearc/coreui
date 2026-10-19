import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';
import '../../utils/test_harness.dart';

void main() {
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

  final underline = find.byKey(CoreUnderlineTextField.underlineKey);
  final input = find.byType(TextField);

  Color? underlineColor(WidgetTester tester) =>
      tester.widget<Container>(underline).color;

  Color? colorOf(WidgetTester tester, String text) =>
      (tester.widget<Text>(find.text(text)).style as TextStyle).color;

  group('CoreUnderlineTextField – enabled: false', () {
    for (final theme in kA11yTestThemes) {
      final name = theme.brightness.name;

      testWidgets('dims every part and rests the underline on lineMid ($name)',
          (tester) async {
        final colors = theme.coreColors;

        await pumpField(
          tester,
          const CoreUnderlineTextField(
            enabled: false,
            label: 'Rate',
            prefixText: r'$',
            suffixText: '%',
            unitText: '/day',
            initialValue: '145',
            helperText: 'A hint',
          ),
          theme: theme,
        );

        expect(colorOf(tester, 'Rate'), colors.textDisable);
        expect(colorOf(tester, r'$'), colors.textDisable);
        expect(colorOf(tester, '%'), colors.textDisable);
        expect(colorOf(tester, '/day'), colors.textDisable);
        expect(
          (tester.widget<TextField>(input).style as TextStyle).color,
          colors.textDisable,
        );
        expect(underlineColor(tester), colors.lineMid);
      });
    }

    testWidgets('keeps the regular 1px weight', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(enabled: false, label: 'Rate'),
      );

      expect(tester.getSize(underline).height, 1);
    });

    testWidgets('does not take focus from a tap on the value, label or line',
        (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(
          enabled: false,
          label: 'Rate',
          focusNode: focusNode,
          onTap: () => taps++,
        ),
      );
      await tester.tap(input);
      await tester.tap(find.text('Rate'));
      await tester.tap(underline);
      await tester.pump();

      expect(focusNode.hasFocus, isFalse);
      expect(taps, 0);
      expect(
        underlineColor(tester),
        CoreTheme.light().coreColors.lineMid,
      );
    });

    testWidgets('the text field reports itself disabled', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(enabled: false, label: 'Rate'),
      );

      expect(tester.widget<TextField>(input).enabled, isFalse);
    });

    testWidgets('an error still wins over the dimmed colors', (tester) async {
      final colors = CoreTheme.light().coreColors;

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          enabled: false,
          label: 'Rate',
          errorText: 'An error',
        ),
      );

      expect(colorOf(tester, 'Rate'), colors.textError);
      expect(underlineColor(tester), colors.statusError);
    });
  });

  group('CoreUnderlineTextField – readOnly', () {
    testWidgets('keeps its normal look in both themes', (tester) async {
      for (final theme in kA11yTestThemes) {
        final colors = theme.coreColors;

        await pumpField(
          tester,
          const CoreUnderlineTextField(
            readOnly: true,
            label: 'Rate',
            prefixText: r'$',
            initialValue: '150.00',
            unitText: '/day',
          ),
          theme: theme,
        );

        expect(colorOf(tester, 'Rate'), colors.textBody);
        expect(colorOf(tester, '/day'), colors.textBody);
        expect(
          (tester.widget<TextField>(input).style as TextStyle).color,
          colors.textHeadline,
        );
        expect(underlineColor(tester), colors.lineDarkOutline);
      }
    });

    testWidgets('refuses edits', (tester) async {
      final controller = TextEditingController(text: '150.00');
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          readOnly: true,
          label: 'Rate',
          controller: controller,
        ),
      );

      expect(tester.widget<TextField>(input).readOnly, isTrue);
      expect(controller.text, '150.00');
    });

    testWidgets('still reports a tap', (tester) async {
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(
          readOnly: true,
          label: 'Rate',
          initialValue: '150.00',
          onTap: () => taps++,
        ),
      );
      await tester.tap(input);

      expect(taps, 1);
    });
  });

  group('CoreUnderlineTextField – onTap', () {
    testWidgets('fires once for a tap on the value', (tester) async {
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', onTap: () => taps++),
      );
      await tester.tap(input);

      expect(taps, 1);
    });

    testWidgets('fires once for a tap on the label', (tester) async {
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', onTap: () => taps++),
      );
      await tester.tap(find.text('Rate'));

      expect(taps, 1);
    });

    testWidgets('fires once for a tap on the underline', (tester) async {
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Rate', onTap: () => taps++),
      );
      await tester.tap(underline);

      expect(taps, 1);
    });

    testWidgets('fires once for a tap on the helper or error line',
        (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          focusNode: focusNode,
          helperText: 'A hint',
          onTap: () => taps++,
        ),
      );
      await tester.tap(find.text('A hint'));
      await tester.pump();

      expect(taps, 1);
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('a tap on the label also focuses the field', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          focusNode: focusNode,
          onTap: () {},
        ),
      );
      await tester.tap(find.text('Rate'));
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('a screen reader double tap fires it once and focuses',
        (tester) async {
      final handle = tester.ensureSemantics();
      try {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        var taps = 0;

        await pumpField(
          tester,
          CoreUnderlineTextField(
            label: 'Rate',
            focusNode: focusNode,
            keyboardType: TextInputType.none,
            onTap: () => taps++,
          ),
        );
        final node = tester.getSemantics(input);
        tester.binding.pipelineOwner.semanticsOwner!
            .performAction(node.id, SemanticsAction.tap);
        await tester.pump();

        expect(taps, 1);
        expect(focusNode.hasFocus, isTrue);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('fires for the message line, a plain slot and the affixes',
        (tester) async {
      var taps = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          suffixText: '%',
          unitText: '/day',
          helperText: 'A hint',
          labelTrailing: const Icon(Icons.info, key: Key('label-slot')),
          inlineAccessory: const Icon(Icons.info, key: Key('inline-slot')),
          onTap: () => taps++,
        ),
      );
      for (final finder in [
        find.text('A hint'),
        find.text('%'),
        find.text('/day'),
        find.byKey(const Key('label-slot')),
        find.byKey(const Key('inline-slot')),
      ]) {
        await tester.tap(finder);
      }

      expect(taps, 5);
    });

    testWidgets('does not fire for a tappable slot that takes the tap',
        (tester) async {
      var taps = 0;
      var lookups = 0;

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          trailing: IconButton(
            tooltip: 'Look up a rate',
            onPressed: () => lookups++,
            icon: const Icon(Icons.search),
          ),
          onTap: () => taps++,
        ),
      );
      await tester.tap(find.byType(IconButton));

      expect(lookups, 1);
      expect(taps, 0);
    });

    testWidgets('with keyboardType none, no system keyboard is asked for',
        (tester) async {
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Rate',
          keyboardType: TextInputType.none,
          onTap: () {},
        ),
      );

      expect(tester.widget<TextField>(input).keyboardType, TextInputType.none);
    });
  });

  group('CoreUnderlineTextField – selectAllOnFocus', () {
    testWidgets('selects the whole value when the field gains focus',
        (tester) async {
      final controller = TextEditingController(text: '25');
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Waste',
          selectAllOnFocus: true,
          controller: controller,
        ),
      );
      await tester.tap(input);
      await tester.pumpAndSettle();

      expect(controller.selection.baseOffset, 0);
      expect(controller.selection.extentOffset, 2);
    });

    testWidgets('does not select when focus leaves before the next frame',
        (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final controller = TextEditingController(text: '25');
      addTearDown(controller.dispose);
      controller.selection = const TextSelection.collapsed(offset: 1);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Waste',
          selectAllOnFocus: true,
          controller: controller,
          focusNode: focusNode,
        ),
      );
      focusNode.requestFocus();
      await tester.idle();
      focusNode.unfocus();
      await tester.idle();
      await tester.pump();

      expect(focusNode.hasFocus, isFalse);
      expect(controller.selection, const TextSelection.collapsed(offset: 1));
    });

    testWidgets('selects the value of a given controller on autofocus',
        (tester) async {
      final controller = TextEditingController(text: '25');
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Waste',
          selectAllOnFocus: true,
          autofocus: true,
          controller: controller,
        ),
      );

      expect(controller.selection.baseOffset, 0);
      expect(controller.selection.extentOffset, 2);
    });

    testWidgets('selects the initial value of its own controller on autofocus',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Waste',
          selectAllOnFocus: true,
          autofocus: true,
          initialValue: '25',
        ),
      );

      final selection = tester
          .state<EditableTextState>(find.byType(EditableText))
          .textEditingValue
          .selection;
      expect(selection.baseOffset, 0);
      expect(selection.extentOffset, 2);
    });

    testWidgets('the first digit typed then replaces the value',
        (tester) async {
      final controller = TextEditingController(text: '25');
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Waste',
          selectAllOnFocus: true,
          controller: controller,
        ),
      );
      await tester.tap(input);
      await tester.pumpAndSettle();
      await tester.enterText(input, '3');

      expect(controller.text, '3');
    });

    testWidgets('selects when focus arrives from a focus node', (tester) async {
      final controller = TextEditingController(text: '25');
      final focusNode = FocusNode();
      addTearDown(controller.dispose);
      addTearDown(focusNode.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Waste',
          selectAllOnFocus: true,
          controller: controller,
          focusNode: focusNode,
        ),
      );
      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(controller.selection.extentOffset, 2);
    });

    testWidgets('leaves the caret alone when it is off', (tester) async {
      final controller = TextEditingController(text: '25');
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(label: 'Waste', controller: controller),
      );
      await tester.tap(input);
      await tester.pumpAndSettle();

      expect(controller.selection.isCollapsed, isTrue);
    });

    testWidgets('does nothing for an empty value', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Waste',
          selectAllOnFocus: true,
          controller: controller,
        ),
      );
      await tester.tap(input);
      await tester.pumpAndSettle();

      expect(controller.selection.isCollapsed, isTrue);
    });

    testWidgets('is not applied again by a rebuild while focused',
        (tester) async {
      final controller = TextEditingController(text: '25');
      addTearDown(controller.dispose);

      Future<void> pump() => pumpField(
            tester,
            CoreUnderlineTextField(
              label: 'Waste',
              selectAllOnFocus: true,
              controller: controller,
            ),
          );

      await pump();
      await tester.tap(input);
      await tester.pumpAndSettle();
      controller.selection = const TextSelection.collapsed(offset: 1);
      await pump();

      expect(controller.selection.isCollapsed, isTrue);
    });
  });

  group('CoreUnderlineTextField – state accessibility', () {
    testWidgets('a disabled field is announced as disabled', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
            enabled: false,
            label: 'Rate',
            initialValue: '145',
          ),
        );

        final data = tester.getSemantics(input).getSemanticsData();
        expect(data.label, 'Rate');
        expect(data.flagsCollection.isEnabled, ui.Tristate.isFalse);
      } finally {
        handle.dispose();
      }
    });

    testWidgets(
        'tapping a focused read-only field does not ask the system '
        'keyboard to show', (tester) async {
      final calls = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.textInput,
        (call) async {
          calls.add(call.method);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.textInput, null),
      );
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          readOnly: true,
          label: 'Rate',
          initialValue: '145',
        ),
      );

      await tester.tap(find.text('Rate'));
      await tester.pump();
      await tester.tap(find.text('Rate'));
      await tester.pump();

      expect(calls, isNot(contains('TextInput.show')));
    });

    testWidgets(
        'tapping a focused editable field asks the system keyboard '
        'to show', (tester) async {
      final calls = <String>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.textInput,
        (call) async {
          calls.add(call.method);
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.textInput, null),
      );
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Rate', initialValue: '145'),
      );

      await tester.tap(find.text('Rate'));
      await tester.pump();
      calls.clear();
      await tester.tap(find.text('Rate'));
      await tester.pump();

      expect(calls, contains('TextInput.show'));
    });

    testWidgets('a read-only field is announced as read-only', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
            readOnly: true,
            label: 'Rate',
            initialValue: '145',
          ),
        );

        final data = tester.getSemantics(input).getSemanticsData();
        expect(data.flagsCollection.isReadOnly, isTrue);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('a read-only field meets the guidelines in both themes',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (theme) => const CoreUnderlineTextField(
          readOnly: true,
          label: 'Rate',
          initialValue: '145',
        ),
        find.byType(CoreUnderlineTextField),
      );
    });
  });
}
