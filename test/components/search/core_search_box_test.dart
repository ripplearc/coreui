import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';


void main() {
  group('CoreSearchBox', () {
    testWidgets('renders hint text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(
              hintText: 'Search for Calculation and cost',
            ),
          ),
        ),
      );

      expect(find.text('Search for Calculation and cost'), findsOneWidget);
    });

    testWidgets('calls onChanged when typing', (WidgetTester tester) async {
      String changedValue = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(
              onChanged: (val) => changedValue = val,
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Roof cost');
      expect(changedValue, 'Roof cost');
    });

    testWidgets('shows clear button when text is entered',
        (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(controller: controller),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('core_search_box_clear_button')), findsNothing);

      await tester.enterText(find.byType(TextFormField), 'Carpentry');
      await tester.pump();

      expect(find.byKey(const ValueKey('core_search_box_clear_button')), findsOneWidget);
    });

    testWidgets('hides clear button when text is empty',
        (WidgetTester tester) async {
      final controller = TextEditingController(text: 'Carpentry');
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(controller: controller),
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(const ValueKey('core_search_box_clear_button')), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), '');
      await tester.pump();

      expect(find.byKey(const ValueKey('core_search_box_clear_button')), findsNothing);
    });

    testWidgets('clears text and calls onClear when clear button tapped',
        (WidgetTester tester) async {
      bool clearCalled = false;
      String lastChanged = '';
      final controller = TextEditingController(text: 'Carpentry');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(
              controller: controller,
              onClear: () => clearCalled = true,
              onChanged: (val) => lastChanged = val,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('core_search_box_clear_button')));
      await tester.pump();

      expect(clearCalled, isTrue);
      expect(controller.text, isEmpty);
      expect(lastChanged, isEmpty);
    });

    testWidgets('calls onSearch on keyboard submit',
        (WidgetTester tester) async {
      bool searchCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(
              controller: TextEditingController(),
              onSearch: () => searchCalled = true,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'Wall cost');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(searchCalled, isTrue);
    });

    testWidgets('disables field when enabled is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(enabled: false),
          ),
        ),
      );

      final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, false);
    });

    testWidgets('does not show clear button when disabled with text',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreSearchBox(
              enabled: false,
              controller: TextEditingController(text: 'Carpentry'),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(const ValueKey('core_search_box_clear_button')), findsNothing);
    });
  });

}
