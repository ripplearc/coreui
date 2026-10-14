import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

/// The app's own number pad for a plain number field: the digits, a decimal
/// point and backspace, with a put-back button and a confirm button under
/// them. Unlike [CoreKeyboard] it has no unit keys, operators or function
/// row.
///
/// The keypad knows nothing about the field it types into. It reports each
/// key, and the caller edits the value and decides what the buttons do.
///
/// [onDigitPressed] receives the digit pressed, 0 to 9.
/// [onDecimalPressed] is called for the decimal point key.
/// [onBackspacePressed] is called for the backspace key.
/// [onClearPressed] is called for the outlined button on the left.
/// [onConfirmPressed] is called for the filled button on the right.
/// [clearLabel] is the outlined button's text, e.g. `Clear`, or the value it
/// puts back, e.g. `Back to 10%`.
/// [confirmLabel] is the filled button's text, e.g. `Add to estimate`.
/// [isConfirmEnabled] is whether the filled button answers taps; `false`
/// greys it out and reports it disabled to a screen reader.
///
/// Four rows of three pill keys, 68 dp tall with 4 dp gaps and a 16 dp inset
/// on each side, then the two buttons 16 dp lower, splitting the width of the
/// keys between them. On a 412 dp phone each key is 124 dp wide, each button
/// 188 dp, and the keypad [height] tall.
///
/// The digit keys carry [DigitTypeX.testKey] (`calc_key_seven`), backspace
/// carries `calc_key_delete`, and the buttons carry [clearButtonKey] and
/// [confirmButtonKey], for Patrol and widget tests.
class CoreNumberKeypad extends StatelessWidget {
  /// The [Key] the outlined button carries: `number_keypad_clear`.
  static const Key clearButtonKey = ValueKey('number_keypad_clear');

  /// The [Key] the filled button carries: `number_keypad_confirm`.
  static const Key confirmButtonKey = ValueKey('number_keypad_confirm');

  /// The height of every key and of both buttons.
  static const double keyHeight = 68;

  /// The keypad's full height: five rows of [keyHeight], three 4 dp gaps
  /// between the key rows and a 16 dp gap above the buttons.
  static const double height =
      5 * keyHeight + 3 * CoreSpacing.space1 + CoreSpacing.space4;

  static const _digitRows = [
    [DigitType.seven, DigitType.eight, DigitType.nine],
    [DigitType.four, DigitType.five, DigitType.six],
    [DigitType.one, DigitType.two, DigitType.three],
  ];

  final ValueChanged<int> onDigitPressed;
  final VoidCallback onDecimalPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;
  final VoidCallback onConfirmPressed;
  final String clearLabel;
  final String confirmLabel;
  final bool isConfirmEnabled;

  const CoreNumberKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onDecimalPressed,
    required this.onBackspacePressed,
    required this.onClearPressed,
    required this.onConfirmPressed,
    required this.clearLabel,
    required this.confirmLabel,
    this.isConfirmEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: CoreSpacing.space4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyWidth = (constraints.maxWidth - 2 * CoreSpacing.space1) / 3;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final row in _digitRows) ...[
                _row([
                  for (final digit in row) _digitKey(context, digit, keyWidth),
                ]),
                const SizedBox(height: CoreSpacing.space1),
              ],
              _row([
                _digitKey(context, DigitType.decimal, keyWidth),
                _digitKey(context, DigitType.zero, keyWidth),
                CoreControlButton(
                  action: ControlAction.delete,
                  onControlAction: (_) => onBackspacePressed(),
                  isNeutral: true,
                  width: keyWidth,
                  height: keyHeight,
                ),
              ]),
              const SizedBox(height: CoreSpacing.space4),
              _row([
                _button(
                  key: clearButtonKey,
                  label: clearLabel,
                  variant: CoreButtonVariant.secondary,
                  onPressed: onClearPressed,
                ),
                _button(
                  key: confirmButtonKey,
                  label: confirmLabel,
                  variant: CoreButtonVariant.primary,
                  isDisabled: !isConfirmEnabled,
                  onPressed: onConfirmPressed,
                ),
              ]),
            ],
          );
        },
      ),
    );
  }

  Widget _row(List<Widget> children) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: CoreSpacing.space1),
          children[i],
        ],
      ],
    );
  }

  Widget _digitKey(BuildContext context, DigitType digit, double width) {
    return CoreDigitInput(
      digit: digit,
      onDigitPressed: (digit) => digit == DigitType.decimal
          ? onDecimalPressed()
          : onDigitPressed(int.parse(digit.label)),
      width: width,
      height: keyHeight,
      textStyle: Theme.of(context).coreTypography.titleLargeMedium,
    );
  }

  Widget _button({
    required Key key,
    required String label,
    required CoreButtonVariant variant,
    required VoidCallback onPressed,
    bool isDisabled = false,
  }) {
    return Expanded(
      child: SizedBox(
        height: keyHeight,
        child: CoreButton(
          key: key,
          label: label,
          variant: variant,
          isDisabled: isDisabled,
          onPressed: onPressed,
        ),
      ),
    );
  }
}
