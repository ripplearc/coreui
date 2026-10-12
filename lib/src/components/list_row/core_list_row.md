# CoreListRow Component

`CoreListRow` is a tappable list row: a title, an optional subtitle under it, and an optional value at the end (for example `$145.00 /day`). For example, a recently used rate.

The value takes at most half the row and shrinks rather than overflow; the title wraps. The row pads its content by `CoreSpacing.space2` (8 dp) on each side and is at least 48 dp tall. The list around it supplies the page inset.

## Usage

```dart
// Name, how long ago, and the price
CoreListRow(
  title: 'Scissor lift — 19ft',
  subtitle: 'Used last week',
  value: r'$120.00',
  unit: '/day',
  onTap: () => reuse(rate),
)
```

## Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `title` | `String` | Yes | Primary text, e.g. an item name. Wraps when long. |
| `subtitle` | `String?` | No | Secondary line under `title`. |
| `value` | `String?` | No | Value at the end of the row, already formatted, e.g. `$145.00`. |
| `unit` | `String?` | No | Smaller text after `value`, e.g. `/day`. Ignored without `value`. |
| `onTap` | `VoidCallback?` | No | Called when the row is tapped. Null disables the row. |
| `semanticLabel` | `String?` | No | Screen-reader label. Defaults to the visible texts joined by `. `, e.g. `Scissor lift — 19ft. Used last week. $120.00 /day`. |

## Styling

| Part | Typography | Colour |
|---|---|---|
| Title | `bodyLargeSemiBold` | `textHeadline` |
| Subtitle | `bodySmallRegular` | `textBody` |
| Value | `bodyLargeSemiBold` | `textHeadline` |
| Unit | `bodySmallRegular` | `textBody` |
| Ink ripple | radius 12 dp | — |

The 2 dp gap between title and subtitle comes from the storyboard; `CoreSpacing` has no step that small.

## Accessibility

The row is one button node with the label above. Every text colour holds 4.5:1 on the page, in both themes.
