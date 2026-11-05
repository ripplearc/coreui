import 'package:flutter/material.dart';
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

import '../showcase_keyboard_semantics.dart';

class NumberKeypadShowcaseScreen extends StatefulWidget {
  const NumberKeypadShowcaseScreen({super.key});

  @override
  State<NumberKeypadShowcaseScreen> createState() =>
      _NumberKeypadShowcaseScreenState();
}

class _NumberKeypadShowcaseScreenState
    extends State<NumberKeypadShowcaseScreen> {
  String _value = '';
  String _added = '';

  void _type(String character) {
    if (character == '.' && _value.contains('.')) return;
    setState(() => _value += character);
  }

  @override
  Widget build(BuildContext context) {
    final typography = Theme.of(context).coreTypography;

    return Scaffold(
      appBar: AppBar(
        title: Text('Number Keypad', style: typography.bodyLargeSemiBold),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(CoreSpacing.space4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _value.isEmpty ? '—' : _value,
                    style: typography.titleLargeSemiBold,
                  ),
                  if (_added.isNotEmpty)
                    Text('Added $_added', style: typography.bodyMediumRegular),
                ],
              ),
            ),
          ),
          CoreNumberKeypad(
            onDigitPressed: (digit) => _type('$digit'),
            onDecimalPressed: () => _type('.'),
            onBackspacePressed: () => setState(
              () => _value = _value.isEmpty
                  ? _value
                  : _value.substring(0, _value.length - 1),
            ),
            onClearPressed: () => setState(() => _value = ''),
            onConfirmPressed: () => setState(() {
              _added = _value;
              _value = '';
            }),
            clearLabel: 'Clear',
            confirmLabel: 'Add to estimate',
            isConfirmEnabled: _value.isNotEmpty,
            semantics: showcaseKeyboardSemantics,
          ),
          const SizedBox(height: CoreSpacing.space4),
        ],
      ),
    );
  }
}
