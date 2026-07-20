# CoreDateFilterChip Component

`CoreDateFilterChip` is a filter chip for a date-range filter. With no selection it renders a plain `CoreFilterChip` that opens a `CoreDateRangeSheet` on tap; with a selection it renders an active pill showing the formatted range with a clear ×. The chip is surface-agnostic: each caller supplies its own label, accessibility labels, and widget keys, so the same widget can back any screen with a date filter.

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
| `onClear`           | `VoidCallback`               | Yes      | Called when the user taps the active pill to clear the filter.                 |
| `label`             | `String`                     | Yes      | Label shown on the inactive chip.                                              |
| `semanticLabel`     | `String?`                    | No       | Accessibility label for the inactive chip. Defaults to `label`.                |
| `clearSemanticLabel`| `String`                     | No       | Accessibility label for the active pill. Defaults to `'Clear date filter'`.    |
| `dateLabelBuilder`  | `String Function(DateTime)?` | No       | Formats the pill dates. Defaults to a `"Jan 05, 2026"`-style English format.   |
| `inactiveChipKey`   | `Key?`                       | No       | Key applied to the inactive chip, for widget-test finders.                     |
| `activeChipKey`     | `Key?`                       | No       | Key applied to the active pill, for widget-test finders.                       |

The chip also forwards `CoreDateRangeSheet`'s label parameters (`sheetTitle`, `todayLabel`, `last7DaysLabel`, `last30DaysLabel`, `thisMonthLabel`, `customRangeLabel`, `startDateLabel`, `endDateLabel`, `cancelLabel`, `applyLabel`, `confirmLabel`) so callers can localize the sheet it opens.

## Behavior

- No selection → plain `CoreFilterChip`; tapping it opens `CoreDateRangeSheet.show` seeded with `selectedDateRange`. If the sheet resolves with a range, `onApply` fires; cancelling fires nothing.
- Selection present → active pill with the formatted range (a single date when `start == end`); tapping anywhere on the pill fires `onClear`.
- The caller owns the selection state; the chip never stores a range itself.

## Accessibility

The inactive chip and the active pill each expose a single semantic button node (`semanticLabel` / `clearSemanticLabel`) with their visual contents excluded from the semantics tree, and the pill guarantees a 48dp-tall tap target.
