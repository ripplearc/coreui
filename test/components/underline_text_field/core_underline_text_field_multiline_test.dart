import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  const shortText = 'Kitchen.';
  const longText = 'Demolition of the existing kitchen, removal of all '
      'cabinets and appliances, new subfloor, new tile flooring, new '
      'cabinets, new countertops, paint and a final clean of the whole room.';

  Future<void> pumpField(
    WidgetTester tester,
    CoreUnderlineTextField field,
  ) async {
    await tester.pumpWidget(
      buildTestApp(SizedBox(width: 372, child: field)),
    );
    await tester.pumpAndSettle();
  }

  final underline = find.byKey(CoreUnderlineTextField.underlineKey);
  final fieldFinder = find.byType(CoreUnderlineTextField);
  final editable = find.byType(EditableText);

  EditableTextState editableState(WidgetTester tester) =>
      tester.state<EditableTextState>(editable);

  group('CoreUnderlineTextField – maxLines', () {
    testWidgets('grows the field by one line for each new line',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          key: ValueKey('one'),
          label: 'Scope of work',
          maxLines: 4,
          initialValue: shortText,
        ),
      );
      final oneLine = tester.getSize(fieldFinder).height;

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          key: ValueKey('two'),
          label: 'Scope of work',
          maxLines: 4,
          initialValue: '$shortText\n$shortText',
        ),
      );

      expect(tester.getSize(fieldFinder).height, oneLine + 24);
    });

    testWidgets('keeps the underline 8px under the last line of text',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Scope of work',
          maxLines: 4,
          initialValue: '$shortText\n$shortText\n$shortText',
        ),
      );

      final textBottom = tester.getBottomLeft(editable).dy;
      expect(tester.getTopLeft(underline).dy, textBottom + 8);
    });

    testWidgets('stops growing at maxLines and scrolls the text',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          key: ValueKey('four'),
          label: 'Scope of work',
          maxLines: 4,
          initialValue: '1\n2\n3\n4',
        ),
      );
      final fourLines = tester.getSize(fieldFinder).height;

      await pumpField(
        tester,
        const CoreUnderlineTextField(
          key: ValueKey('eight'),
          label: 'Scope of work',
          maxLines: 4,
          initialValue: '1\n2\n3\n4\n5\n6\n7\n8',
        ),
      );

      expect(tester.getSize(fieldFinder).height, fourLines);
      expect(
        editableState(tester).renderEditable.maxScrollExtent,
        greaterThan(0),
      );
    });

    testWidgets('wraps text that is wider than the field', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Scope of work',
          maxLines: 4,
          initialValue: longText,
        ),
      );

      expect(tester.getSize(editable).height, 96);
    });

    testWidgets('return adds a new line', (tester) async {
      final changes = <String>[];
      var submitted = false;
      await pumpField(
        tester,
        CoreUnderlineTextField(
          label: 'Scope of work',
          maxLines: 4,
          initialValue: 'First',
          onChanged: changes.add,
          onSubmitted: (_) => submitted = true,
        ),
      );

      await tester.tap(editable);
      await tester.pump();
      tester.testTextInput.updateEditingValue(
        const TextEditingValue(
          text: 'First\n',
          selection: TextSelection.collapsed(offset: 6),
        ),
      );
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.newline);
      await tester.pump();

      expect(changes.last, 'First\n');
      expect(submitted, isFalse);
      expect(
        tester.widget<EditableText>(editable).keyboardType,
        TextInputType.multiline,
      );
    });

    testWidgets('a tap on the label or the underline focuses the field',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Scope of work',
          maxLines: 4,
          initialValue: shortText,
        ),
      );
      bool focused() =>
          tester.widget<EditableText>(editable).focusNode.hasFocus;

      await tester.tap(find.text('Scope of work'));
      await tester.pump();
      expect(focused(), isTrue);

      tester.widget<EditableText>(editable).focusNode.unfocus();
      await tester.pump();
      expect(focused(), isFalse);

      await tester.tap(underline);
      await tester.pump();
      expect(focused(), isTrue);
    });

    testWidgets('keeps a 24px minimum for an empty field', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Scope of work', maxLines: 4),
      );

      expect(tester.getSize(editable).height, 24);
    });

    testWidgets('asserts that maxLines is at least 1', (tester) async {
      expect(
        () => CoreUnderlineTextField(maxLines: 0),
        throwsAssertionError,
      );
    });
  });

  group('CoreUnderlineTextField – message with several lines', () {
    testWidgets('an error replaces the hint and turns the line red',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Scope of work',
          maxLines: 4,
          initialValue: shortText,
          helperText: 'Keep it short.',
          errorText: 'Scope of work is required.',
        ),
      );

      expect(find.text('Keep it short.'), findsNothing);
      expect(find.text('Scope of work is required.'), findsOneWidget);
      expect(
        tester.widget<Container>(underline).color,
        CoreTheme.light().coreColors.statusError,
      );
    });

    testWidgets('a screen reader reads the error', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await pumpField(
          tester,
          const CoreUnderlineTextField(
            label: 'Scope of work',
            maxLines: 4,
            initialValue: shortText,
            errorText: 'Scope of work is required.',
          ),
        );

        final data = tester
            .getSemantics(find.text('Scope of work is required.'))
            .getSemanticsData();
        expect(data.flagsCollection.isLiveRegion, isTrue);
        expect(data.label, 'Scope of work is required.');
      } finally {
        handle.dispose();
      }
    });

    testWidgets('the hint shows when there is no error', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Scope of work',
          maxLines: 4,
          initialValue: shortText,
          helperText: 'Keep it short.',
        ),
      );

      expect(find.text('Keep it short.'), findsOneWidget);
    });
  });

  group('CoreUnderlineTextField – default', () {
    testWidgets('stays one line, 54px tall, with a long value',
        (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(
          label: 'Equipment',
          initialValue: longText,
        ),
      );

      expect(tester.getSize(fieldFinder).height, 54);
      expect(tester.getSize(editable).height, 24);
      expect(
        tester.widget<EditableText>(editable).keyboardType,
        TextInputType.text,
      );
    });

    testWidgets('keeps the 10px gap above the underline', (tester) async {
      await pumpField(
        tester,
        const CoreUnderlineTextField(label: 'Equipment', initialValue: 'Saw'),
      );

      expect(
        tester.getTopLeft(underline).dy,
        tester.getBottomLeft(editable).dy + 10,
      );
    });
  });
}
