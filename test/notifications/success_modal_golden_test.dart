import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

void main() {
  setUpAll(() async {
    await loadAppFonts();
  });

  group('SuccessModal Golden Tests', () {
    testGoldens('SuccessModal Component Visual Regression Test', (tester) async {
      final builder = GoldenBuilder.column()
        // Default success modal
        ..addScenario(
          'Default Success Modal',
          _buildSuccessModalContent(
            message: 'Operation Successful',
            buttonLabel: 'Continue',
          ),
        )
        // Custom message and button
        ..addScenario(
          'Custom Message and Button',
          _buildSuccessModalContent(
            message: 'Account created successfully!',
            buttonLabel: 'Great!',
          ),
        );

      await tester.pumpWidgetBuilder(
      Container(
        color: CoreBackgroundColors.pageBackground,
        padding: const EdgeInsets.all(16),
        child: builder.build(),
      ),
      surfaceSize: const Size(400, 700),
    );

      await screenMatchesGolden(tester, 'success_modal_component');
    });
  });
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