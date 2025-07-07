import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';

class ButtonShowcaseScreen extends StatelessWidget {
  const ButtonShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CoreButton(
              label: 'Primary Button',
              onPressed: () {},
              variant: CoreButtonVariant.primary,
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Secondary Button',
              onPressed: () {},
              variant: CoreButtonVariant.secondary,
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Social Button',
              onPressed: () {},
              icon: const CoreIconWidget(
                icon: CoreIcons.facebook,
                color: CoreTextColors.headline, 
              ),
              variant: CoreButtonVariant.social,
            ),
          ],
        ),
      ),
    );
  }
}
