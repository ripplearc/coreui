import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_ui/core_ui.dart';

void main() {
  group('CoreButton', () {
    testWidgets('renders label and responds to tap when enabled',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreButton(
              label: 'Press Me',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Press Me'), findsOneWidget);

      await tester.tap(find.byType(CoreButton));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });

    testWidgets('does not respond to tap when disabled',
        (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreButton(
              label: 'Don’t Tap',
              onPressed: () => tapped = true,
              isDisabled: true,
            ),
          ),
        ),
      );

      expect(find.text('Don’t Tap'), findsOneWidget);

      await tester.tap(find.byType(CoreButton));
      await tester.pumpAndSettle();

      expect(tapped, isFalse);
    });

    testWidgets('renders primary variant correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreButton(
              label: 'Primary',
              variant: CoreButtonVariant.primary,
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<CoreButton>(find.byType(CoreButton));
      expect(button.variant, CoreButtonVariant.primary);
    });

    testWidgets('renders secondary variant correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreButton(
              label: 'Secondary',
              variant: CoreButtonVariant.secondary,
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<CoreButton>(find.byType(CoreButton));
      expect(button.variant, CoreButtonVariant.secondary);
    });

    testWidgets('renders social variant correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreButton(
              label: 'Social',
              variant: CoreButtonVariant.social,
              onPressed: () {},
            ),
          ),
        ),
      );

      final button = tester.widget<CoreButton>(find.byType(CoreButton));
      expect(button.variant, CoreButtonVariant.social);
    });
  });
}
