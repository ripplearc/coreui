# CoreDateFilterChip Component

`CoreDateFilterChip` is a filter chip for a date-range filter. With no selection it renders a plain `CoreFilterChip` that opens a `CoreDateRangeSheet` on tap; with a selection it renders an active pill (the library Chips Type=Tags With Remove) showing the formatted range with a clear ×. The chip is surface-agnostic: each caller supplies its own label, accessibility labels, and widget keys, so the same widget can back any screen with a date filter.

## Usage

```dart
CoreDateFilterChip(
  selectedDateRange: selectedRange, // null renders the inactive chip
  label: 'Modified',
  onApply: (range) => setState(() => selectedRange = range),
  onClear: () => setState(() => selectedRange = null),
)
```

## Properties

| Property            | Type                         | Required | Description                                                                    |
|---------------------|------------------------------|----------|--------------------------------------------------------------------------------|
| `selectedDateRange` | `DateRange?`                 | Yes      | The currently selected range, or `null` when no filter is active.              |
| `onApply`           | `ValueChanged<DateRange>`    | Yes      | Called with the newly chosen range when the user applies a selection.          |
| `onClear`           | `VoidCallback`               | Yes      | Called when the user taps the × on the active pill to clear the filter.        |
| `label`             | `String`                     | Yes      | Label shown on the inactive chip.                                              |
| `semanticLabel`     | `String?`                    | No       | Accessibility label for the inactive chip. Defaults to `label`.                |
| `clearSemanticLabel`| `String`                     | No       | Accessibility label for the ×. Defaults to `'Clear date filter'`.              |
| `rangeSemanticHint` | `String`                     | No       | Accessibility hint for the active pill. Defaults to `'Opens the date range sheet'`. |
| `dateLabelBuilder`  | `String Function(DateTime)?` | No       | Formats the pill dates. Defaults to a `"Jan 05, 2026"`-style English format.   |
| `inactiveChipKey`   | `Key?`                       | No       | Key applied to the inactive chip, for widget-test finders.                     |
| `activeChipKey`     | `Key?`                       | No       | Key applied to the active pill, for widget-test finders.                       |

The chip also forwards `CoreDateRangeSheet`'s label parameters (`sheetTitle`, `todayLabel`, `last7DaysLabel`, `last30DaysLabel`, `thisMonthLabel`, `customRangeLabel`, `startDateLabel`, `endDateLabel`, `cancelLabel`, `applyLabel`, `confirmLabel`) so callers can localize the sheet it opens.

## Behavior

- No selection → plain `CoreFilterChip`; tapping it opens `CoreDateRangeSheet.show` seeded with `selectedDateRange`. If the sheet resolves with a range, `onApply` fires; cancelling fires nothing.
- Selection present → active pill with the formatted range (a single date when `start == end`). Tapping the pill reopens the sheet; tapping the × (`CoreDateFilterChip.clearButtonKey`) fires `onClear`.
- The caller owns the selection state; the chip never stores a range itself.
- Press and focus stay inside the pill. Holding the range or the × shows the library Press look: a `pageBackground` fill with a 1 px `lineDarkOutline` border. Tab focus on the range or the × draws the pill border in `outlineFocus` at 2 px.
- The chip brings its own transparent `Material`, so the pill draws the same on any parent, with or without a `Material` above it.

## Accessibility

The inactive chip is one semantic button (`semanticLabel`). The active pill is two: the range text, and the × labelled `clearSemanticLabel`. Both chips draw a 32 dp pill inside 48 dp tap targets.
