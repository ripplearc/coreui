import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ripplearc_core_ui/core_ui.dart';

import '../await_images_extension.dart';
import '../load_fonts.dart';

void main() {
  setUpAll(() async {
    await loadFonts();
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  testWidgets('SuccessModal Golden Test', (WidgetTester tester) async {
    final scenarios = <Widget>[
      _buildScenario(
        'Default Success Modal',
        _buildSuccessModalContent(
          message: 'Operation Successful',
          buttonLabel: 'Continue',
        ),
      ),
      _buildScenario(
        'Custom Message and Button',
        _buildSuccessModalContent(
          message: 'Account created successfully!',
          buttonLabel: 'Great!',
        ),
      ),
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

    await tester.binding.setSurfaceSize(const Size(400, 700));
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();
    await tester.awaitImages();

    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/success_modal_component.png'),
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

Widget _buildSuccessModalContent({
  String? message,
  String? buttonLabel,
}) {
  return Container(
    width: 400,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, -2),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icons/success.png', width: 90, height: 90),
        const SizedBox(height: 16),
        Text(
          message ?? 'Operation Successful',
          textAlign: TextAlign.center,
          style: CoreTypography.titleLargeMedium(),
        ),
        const SizedBox(height: 24),
        CoreButton(
          onPressed: () {},
          label: buttonLabel ?? 'Continue',
          centerAlign: true,
        ),
      ],
    ),
  );
} 