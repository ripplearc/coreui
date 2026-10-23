import 'dart:math';

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

    testWidgets('floats the label in bodySmallRegular textDark',
        (WidgetTester tester) async {
      final theme = CoreTheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: CoreTextField(
              label: 'Email',
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      final decoration =
          tester.widget<TextField>(find.byType(TextField)).decoration!;
      final style = decoration.floatingLabelStyle!;
      final bodySmall = theme.coreTypography.bodySmallRegular;
      expect(style.fontSize, bodySmall.fontSize);
      expect(style.fontWeight, bodySmall.fontWeight);
      expect(style.color, theme.coreColors.textDark);
    });

    testWidgets('draws the focus border in outlineHover',
        (WidgetTester tester) async {
      final theme = CoreTheme.light();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: CoreTextField(
              label: 'Email',
              controller: TextEditingController(),
            ),
          ),
        ),
      );

      final decoration =
          tester.widget<TextField>(find.byType(TextField)).decoration!;
      expect(
        (decoration.focusedBorder! as OutlineInputBorder).borderSide.color,
        theme.coreColors.outlineHover,
      );
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

    // The field is one merged semantics node, so Flutter's
    // textContrastGuideline samples the whole field, value text included, and
    // passes whatever the label colour is. The label is checked against the
    // fill instead.
    for (final theme in kA11yTestThemes) {
      testWidgets(
          'the floating label is at least 4.5:1 on the fill '
          '(${theme.brightness.name})', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: CoreTextField(
                label: 'Email address',
                controller: TextEditingController(),
              ),
            ),
          ),
        );

        final decoration =
            tester.widget<TextField>(find.byType(TextField)).decoration!;
        final label = decoration.floatingLabelStyle!.color!.computeLuminance();
        final fill = decoration.fillColor!.computeLuminance();
        final ratio = (max(label, fill) + 0.05) / (min(label, fill) + 0.05);
        expect(ratio, greaterThanOrEqualTo(4.5));
      });
    }
  });
}
