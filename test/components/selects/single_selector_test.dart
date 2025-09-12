import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_core_ui/core_ui.dart';

void main() {
  group('SingleItemSelector', () {
    testWidgets('renders label and hint', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: null,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Role'), findsOneWidget);
      // Find the InputDecorator
      final decoratorFinder = find.byType(InputDecorator);
      expect(decoratorFinder, findsOneWidget);

      // Grab the widget and inspect its decoration
      final decorator = tester.widget<InputDecorator>(decoratorFinder);
      final decoration = decorator.decoration;

      expect(decoration.hintText, equals('Select your role'));
    });

    testWidgets('opens modal and selects item', (tester) async {
      String? selected;
      final items = ['Engineer', 'Designer'];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: items,
              selectedItem: null,
              onItemSelected: (val) => selected = val,
            ),
          ),
        ),
      );

      // Tap to open modal
      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      // Verify modal and list is shown
      expect(find.text('Select Role'), findsOneWidget);
      expect(find.byKey(const Key('professional_role_list')), findsOneWidget);
      expect(find.text('Engineer'), findsOneWidget);
      expect(find.text('Designer'), findsOneWidget);

      // Tap item
      await tester.tap(find.text('Engineer'));
      await tester.pumpAndSettle();

      // Check if selected was updated
      expect(selected, 'Engineer');
    });

    testWidgets('displays selected item when default is passed', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: 'Engineer',
              onItemSelected: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('Engineer'), findsOneWidget);
    });

    testWidgets('onOpen callback is triggered', (tester) async {
      bool opened = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: null,
              onItemSelected: (_) {},
              onOpen: () => opened = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      expect(opened, isTrue);
    });

    testWidgets('does not open when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleItemSelector<String>(
              labelText: 'Role',
              hintText: 'Select your role',
              modalTitle: 'Select Role',
              items: ['Engineer', 'Designer'],
              selectedItem: null,
              isDisabled: true,
              onItemSelected: (_) {},
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SingleItemSelector<String>));
      await tester.pumpAndSettle();

      // Modal should not open
      expect(find.text('Select Role'), findsNothing);
    });
  });
}
