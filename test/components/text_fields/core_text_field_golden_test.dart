import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_core_ui/core_ui.dart';

import '../../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });
  testWidgets('CoreTextField Golden Test', (WidgetTester tester) async {
    final scenarios = <Widget>[
      _buildScenario(
          'Default',
          CoreTextField(
            controller: TextEditingController(),
            helperText: 'Helper Text',
            label: 'Label',
          )),
      _buildScenario(
          'Focus',
          CoreTextField(
            controller: TextEditingController(text: 'Hello, Suyang!'),
            label: 'Label',
            helperText: 'Helper Text',
          )),
      _buildScenario(
          'Active',
          CoreTextField(
            controller: TextEditingController(text: 'Input'),
            label: 'Label',
            helperText: 'Helper Text',
          )),
      _buildScenario(
          'Error',
          CoreTextField(
            controller: TextEditingController(text: 'Input'),
            label: 'Label',
            errorTextList: ['Error Message'],
            helperText: 'Helper Text',
          )),
      _buildScenario(
          'DefaultError',
          CoreTextField(
            controller: TextEditingController(),
            errorTextList: ['Error Message'],
            label: 'Label',
          )),
      _buildScenario(
          'Default Disable',
          CoreTextField(
            controller: TextEditingController(),
            enabled: false,
            helperText: 'Helper Text',
            label: 'Label',
          )),
      _buildScenario(
          'Active Disable',
          CoreTextField(
            controller: TextEditingController(text: 'Input'),
            label: 'Label',
            helperText: 'Helper Text',
            enabled: false,
          )),
      _buildScenario(
          'Mobile Number Default',
          CoreTextField(
            isPhoneNumber: true,
            phonePrefixes: const ['+1'],
            phonePrefix: '+1',
            onPhonePrefixChanged: (_) {},
            controller: TextEditingController(),
            helperText: 'Helper Text',
            label: 'Label',
          )),
      _buildScenario(
          'Mobile Number Active',
          CoreTextField(
            isPhoneNumber: true,
            phonePrefixes: const ['+1'],
            phonePrefix: '+1',
            onPhonePrefixChanged: (_) {},
            controller: TextEditingController(text: '1234567890'),
            label: 'Label',
            helperText: 'Helper Text',
          )),
      _buildScenario(
          'Password',
          CoreTextField(
            obscureText: true,
            controller: TextEditingController(text: '1234567890'),
            label: 'Password',
          )),
      _buildScenario(
          'Mobile Number Error',
          CoreTextField(
            isPhoneNumber: true,
            phonePrefixes: const ['+1'],
            phonePrefix: '+1',
            onPhonePrefixChanged: (_) {},
            controller: TextEditingController(text: '1234567890'),
            label: 'Label',
            errorTextList: ['Error Message'],
          )),
    ];

    final widget = MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: scenarios,
        ),
      ),
    );

    await tester.binding.setSurfaceSize(const Size(400, 1600));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/core_text_field.png'),
    );
  });
}

Widget _buildScenario(String title, Widget child) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        child,
      ],
    ),
  );
}
