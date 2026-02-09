import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../../utils/a11y_guidelines.dart';

void main() {
  group('CoreTextField', () {
    testWidgets('displays label and helper text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreTextField(
              label: 'Email',
              helperText: 'Enter a valid email',
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter a valid email'), findsOneWidget);
    });

    testWidgets('shows error text with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreTextField(
              label: 'Password',
              errorTextList: ['Invalid password'],
              obscureText: true,
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      expect(find.text('Invalid password'), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      expect(
          find.byWidgetPredicate((widget) =>
              widget is CoreIconWidget && widget.icon == CoreIcons.error),
          findsOneWidget);
    });

    testWidgets('calls onChanged when typing', (WidgetTester tester) async {
      String changedValue = '';
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreTextField(
              label: 'Username',
              onChanged: (val) => changedValue = val,
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField), 'mark');
      expect(changedValue, 'mark');
    });

    testWidgets('shows phone prefix button if isPhoneNumber is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreTextField(
              isPhoneNumber: true,
              phonePrefixes: ['+1', '+20'],
              phonePrefix: '+1',
              onPhonePrefixChanged: (_) {},
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      expect(find.byType(TextButton), findsOneWidget);
      expect(find.text('+1'), findsOneWidget);
    });

    testWidgets('disables text field when enabled is false',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CoreTextField(
              label: 'Disabled',
              enabled: false,
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      final textField =
          tester.widget<TextFormField>(find.byType(TextFormField));
      expect(textField.enabled, false);
    });
  });

  group('CoreTextField – accessibility tests', () {
    testWidgets('CoreTextField meets tap target and label guidelines',
        (tester) async {
      await setupA11yTest(tester);

      await expectMeetsTapTargetAndLabelGuidelinesForEachTheme(
        tester,
        (_) => Padding(
          padding: const EdgeInsets.all(16),
          child: CoreTextField(
            label: 'Email address',
            helperText: 'We will never share your email.',
            controller: TextEditingController(),
          ),
        ),
        find.byType(CoreTextField),
      );
    });
  });
}
