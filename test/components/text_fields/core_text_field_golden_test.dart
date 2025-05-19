// test/golden/core_text_field_golden_test.dart
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  testGoldens('CoreTextField Golden Test', (WidgetTester tester) async {
    await loadAppFonts(); // required for consistent text rendering

    final builder = GoldenBuilder.column()
      ..addScenario(
          'Default',
          CoreTextField(
            controller: TextEditingController(),
            helperText: 'Helper Text',
            label: 'Label',
          ))
      ..addScenario(
          'Focus',
          CoreTextField(
            controller: TextEditingController(text: 'Hello, Suyang!'),
            label: 'Label',
            helperText: 'Helper Text',
          ))
      ..addScenario(
          'Active',
          CoreTextField(
            controller: TextEditingController(text: 'Input'),
            label: 'Label',
            helperText: 'Helper Text',
          ))
      ..addScenario(
          'Error',
          CoreTextField(
            controller: TextEditingController(text: 'Input'),
            label: 'Label',
            errorText: 'Error Message',
            helperText: 'Helper Text',
          ))
      ..addScenario(
          'DefaultError',
          CoreTextField(
            controller: TextEditingController(),
            errorText: 'Error Message',
            label: 'Label',
          ))
      ..addScenario(
          'Default Disable',
          CoreTextField(
            controller: TextEditingController(),
            enabled: false,
            helperText: 'Helper Text',
            label: 'Label',
          ))
      ..addScenario(
          'Active Disable',
          CoreTextField(
            controller: TextEditingController(text: 'Input'),
            label: 'Label',
            helperText: 'Helper Text',
            enabled: false,
          ))
      ..addScenario(
          'Mobile Number Default',
          CoreTextField(
            isPhoneNumber: true,
            phonePrefixes: const ['+1'],
            phonePrefix: '+1',
            onPhonePrefixChanged: (_) {},
            controller: TextEditingController(),
            helperText: 'Helper Text',
            label: 'Label',
          ))
      ..addScenario(
          'Mobile Number Active',
          CoreTextField(
            isPhoneNumber: true,
            phonePrefixes: const ['+1'],
            phonePrefix: '+1',
            onPhonePrefixChanged: (_) {},
            controller: TextEditingController(text: '1234567890'),
            label: 'Label',
            helperText: 'Helper Text',
          ))
      ..addScenario(
          'Password',
          CoreTextField(
            obscureText: true,
            controller: TextEditingController(text: '1234567890'),
            label: 'Password',
          ))
      ..addScenario(
          'Mobile Number Error',
          CoreTextField(
            isPhoneNumber: true,
            phonePrefixes: const ['+1'],
            phonePrefix: '+1',
            onPhonePrefixChanged: (_) {},
            controller: TextEditingController(text: '1234567890'),
            label: 'Label',
            errorText: 'Error Message',
          ));

    await tester.pumpWidgetBuilder(
      Container(
        color: Colors.white,
        child: builder.build(),
      ),
      surfaceSize: const Size(400, 1600),
    );

    await screenMatchesGolden(tester, 'core_text_field');
  });
}
