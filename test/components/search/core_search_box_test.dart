import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/test_harness.dart';

void main() {
  group('CoreSearchBox', () {
    testWidgets('inner text field carries the documented stable key',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(const CoreSearchBox(), theme: CoreTheme.light()),
      );

      expect(
        CoreSearchBox.textFieldKey,
        const Key('core_search_box_text_field'),
      );
      expect(find.byType(TextFormField), findsOneWidget);
      expect(
        tester.widget(find.byKey(CoreSearchBox.textFieldKey)),
        same(tester.widget(find.byType(TextFormField))),
      );
    });

    testWidgets('clear button carries the documented stable key',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchBox(controller: TextEditingController(text: 'Roof')),
          theme: CoreTheme.light(),
        ),
      );
      await tester.pump();

      expect(
        CoreSearchBox.clearButtonKey,
        const Key('core_search_box_clear_button'),
      );
      expect(find.byKey(CoreSearchBox.clearButtonKey), findsOneWidget);
    });

    testWidgets('static keys match every instance on the screen',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const Column(children: [CoreSearchBox(), CoreSearchBox()]),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byKey(CoreSearchBox.textFieldKey), findsNWidgets(2));
    });

    testWidgets('renders hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreSearchBox(hintText: 'Search for Calculation and cost'),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.text('Search for Calculation and cost'), findsOneWidget);
    });

    testWidgets('calls onChanged when typing', (WidgetTester tester) async {
      String changedValue = '';
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchBox(
            onChanged: (val) => changedValue = val,
            controller: TextEditingController(),
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.enterText(
        find.byKey(CoreSearchBox.textFieldKey),
        'Roof cost',
      );
      expect(changedValue, 'Roof cost');
    });

    testWidgets('shows clear button when text is entered',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchBox(controller: controller),
          theme: CoreTheme.light(),
        ),
      );

      expect(find.byKey(CoreSearchBox.clearButtonKey), findsNothing);

      await tester.enterText(
        find.byKey(CoreSearchBox.textFieldKey),
        'Carpentry',
      );
      await tester.pump();

      expect(find.byKey(CoreSearchBox.clearButtonKey), findsOneWidget);
    });

    testWidgets('hides clear button when text is empty',
        (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Carpentry');
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchBox(controller: controller),
          theme: CoreTheme.light(),
        ),
      );

      await tester.pump();
      expect(find.byKey(CoreSearchBox.clearButtonKey), findsOneWidget);

      await tester.enterText(find.byKey(CoreSearchBox.textFieldKey), '');
      await tester.pump();

      expect(find.byKey(CoreSearchBox.clearButtonKey), findsNothing);
    });

    testWidgets('clears text and calls onClear when clear button tapped',
        (WidgetTester tester) async {
      bool clearCalled = false;
      String lastChanged = '';
      final controller = TextEditingController(text: 'Carpentry');

      await tester.pumpWidget(
        buildTestApp(
          CoreSearchBox(
            controller: controller,
            onClear: () => clearCalled = true,
            onChanged: (val) => lastChanged = val,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.pump();
      await tester.tap(find.byKey(CoreSearchBox.clearButtonKey));
      await tester.pump();

      expect(clearCalled, isTrue);
      expect(controller.text, isEmpty);
      expect(lastChanged, isEmpty);
    });

    testWidgets('calls onSearch on keyboard submit',
        (WidgetTester tester) async {
      bool searchCalled = false;
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchBox(
            controller: TextEditingController(),
            onSearch: () => searchCalled = true,
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.enterText(
        find.byKey(CoreSearchBox.textFieldKey),
        'Wall cost',
      );
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(searchCalled, isTrue);
    });

    testWidgets('disables field when enabled is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          const CoreSearchBox(enabled: false),
          theme: CoreTheme.light(),
        ),
      );

      final textField = tester.widget<TextFormField>(
        find.byKey(CoreSearchBox.textFieldKey),
      );
      expect(textField.enabled, false);
    });

    testWidgets('does not show clear button when disabled with text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        buildTestApp(
          CoreSearchBox(
            enabled: false,
            controller: TextEditingController(text: 'Carpentry'),
          ),
          theme: CoreTheme.light(),
        ),
      );

      await tester.pump();
      expect(find.byKey(CoreSearchBox.clearButtonKey), findsNothing);
    });
  });
}
