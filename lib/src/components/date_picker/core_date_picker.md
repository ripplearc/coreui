# CoreDatePicker Component

`CoreDatePicker` is a modal calendar widget for picking a single date. It shows a header with a label and the selected date spelled out, a month selector with previous/next navigation, a day grid, and Cancel/OK actions.

## Usage

```dart
// Inline, as a controlled widget
CoreDatePicker(
  selectedDate: selectedDate,
  onDateChanged: (date) => setState(() => selectedDate = date),
  onCancel: () => Navigator.of(context).pop(),
  onConfirm: () => Navigator.of(context).pop(selectedDate),
)

// As a dialog via the show() helper
final picked = await CoreDatePicker.show(
  context: context,
  initialDate: DateTime.now(),
  firstDate: DateTime(2020, 1, 1),
  lastDate: DateTime(2030, 12, 31),
);
if (picked != null) {
  setState(() => selectedDate = picked);
}
```

## Properties

| Property                      | Type                            | Required | Description                                                                          |
|--------------------------------|----------------------------------|----------|----------------------------------------------------------------------------------------|
| `selectedDate`                 | `DateTime`                       | Yes      | The currently selected date.                                                          |
| `onDateChanged`                 | `ValueChanged<DateTime>`         | Yes      | Called with the newly selected date when the user taps a day cell.                    |
| `onCancel`                      | `VoidCallback`                   | Yes      | Called when the user taps the cancel action.                                          |
| `onConfirm`                     | `VoidCallback`                   | Yes      | Called when the user taps the confirm (OK) action.                                    |
| `firstDate`                     | `DateTime?`                      | No       | Earliest selectable date, inclusive. Days before it are disabled.                     |
| `lastDate`                      | `DateTime?`                      | No       | Latest selectable date, inclusive. Days after it are disabled.                         |
| `label`                         | `String`                         | No       | Label above the selected date. Defaults to `'Select date'`.                           |
| `cancelLabel`                   | `String`                         | No       | Cancel button label. Defaults to `'Cancel'`.                                          |
| `confirmLabel`                  | `String`                         | No       | Confirm button label. Defaults to `'OK'`.                                             |
| `previousMonthSemanticLabel`    | `String`                         | No       | Accessibility label for the previous-month control.                                   |
| `nextMonthSemanticLabel`        | `String`                         | No       | Accessibility label for the next-month control.                                       |
| `dateLabelBuilder`              | `String Function(DateTime)?`     | No       | Formats the large header date. Defaults to `"Mon, Aug 17"`-style.                     |
| `monthLabelBuilder`             | `String Function(DateTime)?`     | No       | Formats the month selector label. Defaults to `"August 2025"`-style.                  |
| `weekdayLabels`                 | `List<String>?`                  | No       | Seven single-letter weekday labels starting from Sunday. Defaults to `S M T W T F S`. |
| `today`                         | `DateTime?`                      | No       | Overrides "today" for testing. Defaults to `DateTime.now()`.                          |

## `CoreDatePicker.show`

A static helper that presents `CoreDatePicker` inside a rounded dialog and manages the in-progress selection internally, resolving with the confirmed `DateTime` or `null` if the user cancels or dismisses the dialog.

## Behavior

- Tapping a day calls `onDateChanged`; the caller is responsible for updating `selectedDate` (the widget does not manage selection state itself, except inside `show()`).
- Days outside `[firstDate, lastDate]` are rendered disabled and are not tappable.
- The month selector's previous/next arrows disable themselves once navigating further would only reveal entirely out-of-range months.
- "Today" (independent of selection) is rendered with a highlighted outline; the selected day is rendered as a filled circle.
- `dateLabelBuilder`, `monthLabelBuilder`, and `weekdayLabels` allow full localization of all date text without subclassing.

## Accessibility

Each day cell exposes a `Semantics(button: true, selected: ...)` node with a full date label (via `MaterialLocalizations.formatFullDate`), and the previous/next month controls expose their own semantic labels via `previousMonthSemanticLabel`/`nextMonthSemanticLabel`.
