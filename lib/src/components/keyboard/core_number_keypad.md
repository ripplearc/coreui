# CoreNumberKeypad Component

`CoreNumberKeypad` is the app's own number pad for a plain number field, shown in place of the phone's keyboard. It has the digits, a decimal point and backspace, with an outlined put-back button and a filled confirm button under them. It has no unit keys, operators or function row; for those, use `CoreKeyboard`.

The keypad knows nothing about the field it types into. It reports each key, and the caller edits the value and decides what the buttons do.

## Usage

```dart
CoreNumberKeypad(
  onDigitPressed: (digit) => field.insertAtSelection('$digit'),
  onDecimalPressed: () => field.insertAtSelection('.'),
  onBackspacePressed: field.deleteBeforeSelection,
  onClearPressed: field.putBack,
  onConfirmPressed: addToEstimate,
  clearLabel: 'Back to 10%',
  confirmLabel: 'Add to estimate',
)
```

To hide the phone's keyboard, give the field `keyboardType: TextInputType.none`.
Do not use `readOnly: true`. That removes Paste and the cursor.
Insert each key at the field's selection, so a selected value is replaced.

## Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `onDigitPressed` | `ValueChanged<int>` | Yes | Called with the digit pressed, 0 to 9. |
| `onDecimalPressed` | `VoidCallback` | Yes | Called for the decimal point key. |
| `onBackspacePressed` | `VoidCallback` | Yes | Called for the backspace key. |
| `onClearPressed` | `VoidCallback` | Yes | Called for the outlined button. |
| `onConfirmPressed` | `VoidCallback` | Yes | Called for the filled button. |
| `clearLabel` | `String` | Yes | The outlined button's text: `Clear`, or the value it puts back, e.g. `Back to 10%`. |
| `confirmLabel` | `String` | Yes | The filled button's text, e.g. `Add to estimate`. |
| `isConfirmEnabled` | `bool` | No | Whether the filled button answers taps. Defaults to `true`. |

## Layout

Four rows of three pill keys (`7 8 9`, `4 5 6`, `1 2 3`, `. 0 ⌫`), 68 dp tall with 4 dp gaps and a 16 dp inset on each side. The two buttons sit 16 dp below the keys, are as tall as a key, and split the keys' width between them. On a 412 dp phone each key is 124 dp wide and each button 188 dp. `CoreNumberKeypad.height` is the full height, 368 dp, for a sheet that reserves room for the keypad.

| Part | Built from | Look |
|---|---|---|
| Digit and decimal keys | `CoreDigitInput` | `keyboardNumbers` fill, `titleLargeMedium` in `textHeadline` |
| Backspace | `CoreControlButton(isNeutral: true)` | `keyboardNumbers` fill, `iconGrayDark` icon |
| Put-back button | `CoreButton`, secondary | outlined |
| Confirm button | `CoreButton`, primary | filled |

## Testing

The digit keys carry `DigitType.testKey` (`calc_key_seven`), backspace carries `ControlAction.delete.testKey` (`calc_key_delete`), and the buttons carry `CoreNumberKeypad.clearButtonKey` and `CoreNumberKeypad.confirmButtonKey`.
