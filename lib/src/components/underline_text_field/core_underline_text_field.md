# CoreUnderlineTextField

A text field drawn as a small label over a value with a single rule beneath it,
for dense stacked forms such as the "New material, labor or equipment cost"
screens. It is a sibling of `CoreTextField`, not a replacement: `CoreTextField`
draws an outlined box, this field draws no border at all.

```dart
CoreUnderlineTextField(
  label: 'Duration',
  hintText: 'Set the days',
  unitText: 'days',
  keyboardType: TextInputType.number,
  onChanged: (value) => bloc.add(DurationChanged(value)),
)
```

## Parts

```
Label  [labelTrailing]
$ 145.00 /day  [inlineAccessory]                [trailing]
─────────────────────────────────────────────────────────  underline
(i) helperText, or (!) errorText
```

| Property          | Type                          | Description                                                                 |
|-------------------|-------------------------------|-----------------------------------------------------------------------------|
| `label`           | `String?`                     | The small caption above the value                                           |
| `hintText`        | `String?`                     | Dimmed text in the value row while the field is empty                       |
| `controller`      | `TextEditingController?`      | Controls the text. The field keeps its own, seeded with `initialValue`      |
| `initialValue`    | `String?`                     | The starting text. Ignored when `controller` is given                       |
| `focusNode`       | `FocusNode?`                  | Owns focus. The field keeps its own when omitted                            |
| `size`            | `CoreUnderlineTextFieldSize`  | `regular` (default), `compact` or `large`                                   |
| `onChanged`       | `ValueChanged<String>?`       | Called on every change                                                      |
| `onSubmitted`     | `ValueChanged<String>?`       | Called with the keyboard's action key                                       |
| `keyboardType`    | `TextInputType?`              | The keyboard. `TextInputType.none` asks for no system keyboard              |
| `textInputAction` | `TextInputAction?`            | The keyboard's action key                                                   |
| `inputFormatters` | `List<TextInputFormatter>?`   | Filters or reshapes what is typed                                           |
| `maxLength`       | `int?`                        | Most characters accepted. No counter is drawn                               |
| `autofocus`       | `bool`                        | Takes focus when first built                                                |
| `labelTrailing`   | `Widget?`                     | A widget beside the label, such as a badge                                  |
| `prefixText`      | `String?`                     | Fixed text before the value, such as `$`                                    |
| `suffixText`      | `String?`                     | Fixed text after the value in the value's size, such as `%`                 |
| `unitText`        | `String?`                     | Fixed text after the value in a smaller size, such as `days` or `/gal`      |
| `inlineAccessory` | `Widget?`                     | A widget right after the value and unit, such as a unit chip                |
| `trailing`        | `Widget?`                     | A widget at the far end of the value row, such as a lookup button           |
| `helperText`      | `String?`                     | A hint line with an info icon under the field                               |
| `errorText`       | `String?`                     | An error line under the field. Turns the label and underline red            |
| `enabled`         | `bool`                        | `false` dims the field and stops it taking focus or taps                    |
| `readOnly`        | `bool`                        | `true` shows the value, with its normal look, and refuses edits             |
| `selectAllOnFocus`| `bool`                        | Selects the whole value on focus so the first digit typed replaces it       |
| `showCursor`      | `bool?`                       | Whether the caret shows on focus. `false` for a value on an own number pad  |
| `onTap`           | `VoidCallback?`               | A tap anywhere on the field, including its helper or error line             |

## Sizes

| Size      | Label | Value           | Prefix and suffix | Unit  | Underline                | Height |
|-----------|-------|-----------------|-------------------|-------|--------------------------|--------|
| `regular` | 12/16 | 16/24           | 16/24             | 12/16 | 1px, `lineDarkOutline`   | 54px   |
| `compact` | 12/16 | 16/24           | 16/24             | 12/16 | 1px, `lineDarkOutline`   | 52px   |
| `large`   | 14/20 | 24/32, semibold | 24/32, semibold   | 16/24 | 2px, `lineMid`           | 66px   |

`compact` is `regular` with the underline 2px closer to the value (8px under
the value row instead of 10px). The design draws it on the fields of an open
editor panel: waste, burden, delivery and note.

Use `large` only when a form asks a single question, so one number is enlarged.
A form with several fields of equal weight uses `regular` for every field.

Heights are for a field with a label, no helper or error line and nothing in
the value row taller than the text. A helper or error line adds 24px. A 32px
`inlineAccessory` makes the regular field 62px, and a 36px `trailing` widget
makes it 66px, with the value centered against the widget.

The design spaces stacked fields 12px apart. That spacing belongs to the form
and is not part of the field.

## Underline and focus

The underline is the field's whole focus affordance. At rest it is
`lineDarkOutline` (`lineMid` for `large`). On focus it turns `outlineHover`
(`#003A54` in light mode, which is what the design draws) and the caret is
`outlineFocus`. The weight does not change on focus.

An `errorText` turns the underline `statusError`, in rest and in focus.

## Prefix, suffix and unit

`prefixText`, `suffixText` and `unitText` are drawn by the field around the
typed text, never inside it:

- the controller's text holds only what the user typed;
- an empty field still reads `$` with a caret, and backspace can never delete it;
- the value hugs its text when something follows it, so `4 days` and
  `3 [gal]` read as one unit. With nothing after it the value fills the row.

While the field has focus the caret takes 2px of room, and the suffix, unit or
accessory after the value moves 2px right with it. At rest nothing is reserved,
so `10%` touches and `4 days` sits 5px from the number. With `showCursor: false`
the caret and its room are both gone, as on the `%` waste editors, which the
design draws with no cursor. A read-only field draws no caret by default.

`suffixText` suits a soft `%`. `unitText` suits a unit word. Pass `unitText`
only once there is a value to put it beside.

## Slots

`labelTrailing`, `inlineAccessory` and `trailing` take any widget. The field
owns their position and spacing, not their look.

- `labelTrailing` sits 5px after the label. It makes the label row 20px tall
  and takes the 4px back from the gap above the underline, so the field keeps
  its height.
- `inlineAccessory` sits 12px after the value and unit.
- `trailing` sits at the far end, 2px inside the field's edge.

The widgets you pass are responsible for their own tap targets and semantics.

## Helper and error lines

`helperText` draws a 16px info icon and a 12/16 line, 8px under the underline.
`errorText` takes the same place, replaces the helper, and turns the label,
underline, icon and line to the error colors. A screen reader announces it as
it appears.

The field never decides when a value is wrong. Set `errorText` from the app,
for instance:

- show no error while the user types;
- show it when the user leaves the field, then re-check on every key;
- clear it as soon as the value is valid;
- leave an empty field without an error, as the storyboard asks. The field
  draws whatever `errorText` it is given, so this is the app's rule.

A `null` or empty `errorText` means no error.

## States

- **Disabled** (`enabled: false`): label, value, affixes and placeholder
  `textDisable`; underline `lineMid`; no focus and no taps. The design has no
  disabled variant, so these colors follow `CoreTextField`.
- **Read-only** (`readOnly: true`): normal look, value can be read but not
  edited.

## Own number pad

```dart
CoreUnderlineTextField(
  label: 'Waste',
  suffixText: '%',
  initialValue: '10',
  keyboardType: TextInputType.none,
  showCursor: false,
  selectAllOnFocus: true,
  onTap: openNumberPad,
)
```

`TextInputType.none` stops the system keyboard. `onTap` fires for a tap on the
label, the value or the underline, and `selectAllOnFocus` makes the first digit
typed replace the suggested value.

## Accessibility

- The text field announces the label, so the visible label is not read twice.
- The text field's accessibility node is 48px tall, though the value row is
  drawn 24px or 32px tall.
- Prefix, suffix and unit text are read as separate items in reading order.
- Prefix, value and unit sit on one text baseline, as the design draws them.
- The placeholder uses `textDisable`, as the design draws it. On a white page
  that is about 2.5:1, below the 4.5:1 WCAG asks of text, and it is the same
  token `CoreTextField` uses for its hint.

## Strings

The field owns no user-facing strings. Every label, hint and message is passed
in by the caller, who localizes it.
