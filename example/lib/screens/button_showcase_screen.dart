import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

class ButtonShowcaseScreen extends StatefulWidget {
  const ButtonShowcaseScreen({super.key});

  @override
  State<ButtonShowcaseScreen> createState() => _ButtonShowcaseScreenState();
}

class _ButtonShowcaseScreenState extends State<ButtonShowcaseScreen> {
  bool _isDisabled = false;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).coreColors;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Showcase'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(CoreSpacing.space4),
        child: Column(
          children: [
            CoreButton(
              label: 'Primary Button',
              onPressed: () {},
              variant: CoreButtonVariant.primary,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Primary + Icon',
              onPressed: () {},
              variant: CoreButtonVariant.primary,
              isDisabled: _isDisabled,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color: _isDisabled ? colors.textBody : colors.textInverse,
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Primary Focused',
              onPressed: () {},
              variant: CoreButtonVariant.primary,
              isDisabled: _isDisabled,
              autofocus: true,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color: _isDisabled ? colors.textBody : colors.textInverse,
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Secondary Button',
              onPressed: () {},
              variant: CoreButtonVariant.secondary,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Secondary + Icon',
              onPressed: () {},
              variant: CoreButtonVariant.secondary,
              isDisabled: _isDisabled,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color: _isDisabled ? colors.textDisable : colors.buttonSurface,
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Secondary Focused',
              onPressed: () {},
              variant: CoreButtonVariant.secondary,
              isDisabled: _isDisabled,
              autofocus: true,
              icon: CoreIconWidget(
                icon: CoreIcons.checkCircle,
                color: _isDisabled ? colors.textDisable : colors.buttonHover,
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Social Button',
              onPressed: () {},
              icon: const CoreIconWidget(icon: CoreIcons.microsoft),
              variant: CoreButtonVariant.social,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Spacedout',
              onPressed: () {},
              icon: const CoreIconWidget(icon: CoreIcons.google),
              variant: CoreButtonVariant.social,
              spaceOut: true,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              label: 'Social Focused',
              onPressed: () {},
              icon: const CoreIconWidget(icon: CoreIcons.google),
              variant: CoreButtonVariant.social,
              spaceOut: true,
              autofocus: true,
              isDisabled: _isDisabled,
            ),
            const SizedBox(height: CoreSpacing.space4),
            CoreButton(
              onPressed: () {},
              variant: CoreButtonVariant.social,
              shadows: CoreShadows.small,
              fullWidth: false,
              trailing: true,
              icon: CoreIconWidget(
                icon: CoreIcons.edit,
                color: colors.textHeadline,
              ),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'O.C: ',
                      style: Theme.of(context)
                          .coreTypography
                          .bodyLargeSemiBold
                          .copyWith(
                            color: colors.textBody,
                            fontWeight: FontWeight.normal,
                          ),
                    ),
                    TextSpan(
                      text: '6ft',
                      style: Theme.of(context)
                          .coreTypography
                          .bodyLargeSemiBold
                          .copyWith(
                            color: colors.textHeadline,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: CoreSpacing.space4),
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
