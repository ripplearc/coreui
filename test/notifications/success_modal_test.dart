import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SuccessModal displays default content and triggers callback', (
    WidgetTester tester,
  ) async {
    bool wasPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    SuccessModal.show(
                      context,
                      message: 'Operation Successful',
                      buttonLabel: 'Continue',
                      onPressed: () {
                        wasPressed = true;
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  child: const Text('Open Modal'),
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Open Modal'));
    await tester.pumpAndSettle();

    expect(find.text('Operation Successful'), findsOneWidget);

    expect(
      find.text('Continue'),
      findsOneWidget,
    );

    await tester.tap(
      find.text('Continue'),
    );
    await tester.pumpAndSettle();

    expect(wasPressed, isTrue);
    expect(find.text('Operation Successful'), findsNothing);
  });

  testWidgets('SuccessModal displays custom message and button label', (
    WidgetTester tester,
  ) async {
    bool callbackCalled = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder:
              (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      SuccessModal.show(
                        context,
                        message: 'Account created successfully!',
                        buttonLabel: 'Great!',
                        onPressed: () {
                          callbackCalled = true;
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    child: const Text('Trigger Modal'),
                  ),
                ),
              ),
        ),
      ),
    );

    await tester.tap(find.text('Trigger Modal'));
    await tester.pumpAndSettle();

    expect(find.text('Account created successfully!'), findsOneWidget);
    expect(find.text('Great!'), findsOneWidget);

    await tester.tap(find.text('Great!'));
    await tester.pumpAndSettle();

    expect(callbackCalled, isTrue);
  });
}
