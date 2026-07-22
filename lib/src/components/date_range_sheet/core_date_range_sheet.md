# CoreDateRangeSheet Component

`CoreDateRangeSheet` is a modal bottom sheet for picking an inclusive, whole-calendar-day `DateRange`. It offers predefined ranges (Today, Last 7 days, Last 30 days, This month) plus a Custom range option that opens `CoreDatePicker` twice — once for the start date, once for the end date. The sheet owns no external state: it resolves with the chosen `DateRange`, or `null` if the user cancels or dismisses.

## Usage

```dart
final range = await CoreDateRangeSheet.show(
  context: context,
  initialRange: currentRange, // pre-selects Custom range when non-null
);
if (range != null) {
  setState(() => currentRange = range);
}
```

## Properties

| Property           | Type         | Required | Description                                                              |
|--------------------|--------------|----------|--------------------------------------------------------------------------|
| `initialRange`     | `DateRange?` | No       | The range already applied when the sheet opens. Pre-selects Custom range. |
| `title`            | `String`     | No       | Sheet title. Defaults to `'Date range'`.                                 |
| `todayLabel`       | `String`     | No       | Today option label. Defaults to `'Today'`.                               |
| `last7DaysLabel`   | `String`     | No       | Last 7 days option label. Defaults to `'Last 7 days'`.                   |
| `last30DaysLabel`  | `String`     | No       | Last 30 days option label. Defaults to `'Last 30 days'`.                 |
| `thisMonthLabel`   | `String`     | No       | This month option label. Defaults to `'This month'`.                     |
| `customRangeLabel` | `String`     | No       | Custom range option label. Defaults to `'Custom range'`.                 |
| `startDateLabel`   | `String`     | No       | Label of the start-date `CoreDatePicker`. Defaults to `'Start date'`.    |
| `endDateLabel`     | `String`     | No       | Label of the end-date `CoreDatePicker`. Defaults to `'End date'`.        |
| `cancelLabel`      | `String`     | No       | Cancel button label, also used by the custom-range pickers. Defaults to `'Cancel'`. |
| `applyLabel`       | `String`     | No       | Apply button label. Defaults to `'Apply'`.                               |
| `confirmLabel`     | `String`     | No       | Confirm (OK) label of the custom-range pickers. Defaults to `'OK'`.      |
| `today`            | `DateTime?`  | No       | Overrides "today" for testing. Defaults to `DateTime.now()`.             |

`CoreDateRangeSheet.show` accepts the same parameters and presents the sheet inside a `CoreQuickSheet`, resolving with the chosen `DateRange` or `null`.

## DateRange

`DateRange` is a plain value type with inclusive `start` and `end` days (`DateTime`, truncated to whole calendar days) and value equality.

## Behavior

- With no `initialRange`, Today is pre-selected; with one, Custom range is pre-selected and re-applying without changes resolves with the untouched initial range.
- Selecting Custom range opens the start-date picker, then the end-date picker (bounded to `firstDate: start`, `lastDate: today`; its seed is clamped to the new start so a stale earlier end can never resolve an inverted range). Cancelling either picker reverts to the previous selection — Custom is only committed once both dates are picked, so Apply can never resolve a half-picked custom range.
- Re-tapping an already-complete Custom selection keeps it instead of reopening the pickers.
- Predefined ranges are resolved against `DateTime.now()` at Apply time: Today is `today→today`, Last 7 days spans 6 days back, Last 30 days spans 29 days back, This month starts on the 1st.
- Cancel (or dismissing the sheet) resolves with `null`; nothing is applied.

## Accessibility

Each range option is a `RadioListTile` with a text label, and the Cancel/Apply actions are full-width `CoreButton`s, all meeting tap-target and label guidelines in both light and dark themes. All user-visible strings are overridable constructor parameters for localization.
