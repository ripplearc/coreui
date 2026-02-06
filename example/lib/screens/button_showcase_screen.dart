import 'package:ripplearc_coreui/ripplearc_coreui.dart';
import 'package:flutter/material.dart';

class ButtonShowcaseScreen extends StatefulWidget {
  const ButtonShowcaseScreen({super.key});

  @override
  State<ButtonShowcaseScreen> createState() => _ButtonShowcaseScreenState();
}

class _ButtonShowcaseScreenState extends State<ButtonShowcaseScreen> {
  bool _isDisabled = false;
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
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Primary + Icon',
              onPressed: () {},
              variant: CoreButtonVariant.primary,
              isDisabled: _isDisabled,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color:
                    _isDisabled ? CoreTextColors.body : CoreTextColors.inverse,
              ),
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Primary Focused',
              onPressed: () {},
              variant: CoreButtonVariant.primary,
              isDisabled: _isDisabled,
              autofocus: true,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color:
                    _isDisabled ? CoreTextColors.body : CoreTextColors.inverse,
              ),
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Secondary Button',
              onPressed: () {},
              variant: CoreButtonVariant.secondary,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Secondary + Icon',
              onPressed: () {},
              variant: CoreButtonVariant.secondary,
              isDisabled: _isDisabled,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color: _isDisabled
                    ? CoreTextColors.disable
                    : CoreButtonColors.surface,
              ),
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Secondary Focused',
              onPressed: () {},
              variant: CoreButtonVariant.secondary,
              isDisabled: _isDisabled,
              autofocus: true,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color: _isDisabled
                    ? CoreTextColors.disable
                    : CoreButtonColors.hover,
              ),
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Social Button',
              onPressed: () {},
              icon: const CoreIconWidget(icon: CoreIcons.microsoft),
              variant: CoreButtonVariant.social,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Spacedout',
              onPressed: () {},
              icon: const CoreIconWidget(icon: CoreIcons.google),
              variant: CoreButtonVariant.social,
              spaceOut: true,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: 16),
            CoreButton(
              label: 'Social Focused',
              onPressed: () {},
              icon: const CoreIconWidget(icon: CoreIcons.google),
              variant: CoreButtonVariant.social,
              spaceOut: true,
              autofocus: true,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: 16),
            Switch(
                value: _isDisabled,
                onChanged: (state) {
                  setState(() {
                    _isDisabled = state;
                  });
                })
          ],
        ),
      ),
    );
  }
}
