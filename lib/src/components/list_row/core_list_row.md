# CoreListRow Component

`CoreListRow` is a tappable list row: a title, an optional subtitle under it, and an optional value at the end (for example `$145.00 /day`). It has three looks that share one geometry, so the titles of mixed rows line up:

| Constructor | Leading slot | Use |
|---|---|---|
| `CoreListRow(...)` | none | A plain row, e.g. a recently used rate. |
| `CoreListRow.selectable(...)` | a check, shown only when `selected`; the slot keeps its width when empty | A pick-one list, e.g. "Look up a rate". A selected row fills light blue and its title turns the link colour. |
| `CoreListRow.action(...)` | `icon`, always shown | An action at the end of a list, e.g. "+ New equipment cost". Icon and title use the link colour. |

The row pads its content by `CoreSpacing.space2` (8 dp) on each side and is at least 48 dp tall. The list around it supplies the page inset.

## Usage

```dart
// Plain: name, how long ago, and the price
CoreListRow(
  title: 'Scissor lift — 19ft',
  subtitle: 'Used last week',
  value: r'$120.00',
  unit: '/day',
  onTap: () => reuse(rate),
)

// Pick-one list
CoreListRow.selectable(
  title: 'Mini excavator — 1.5 ton',
  subtitle: 'Compact, tight-access digging',
  value: r'$145.00',
  unit: '/day',
  selected: picked == rate,
  onTap: () => setState(() => picked = rate),
)

// Action
CoreListRow.action(
  icon: CoreIcons.add,
  title: 'New equipment cost',
  onTap: startNewCost,
)
```

## Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `title` | `String` | Yes | Primary text, e.g. an item name. Wraps when long. |
| `subtitle` | `String?` | No | Secondary line under `title`. Not on `.action`. |
| `value` | `String?` | No | Value at the end of the row, already formatted, e.g. `$145.00`. Not on `.action`. |
| `unit` | `String?` | No | Smaller text after `value`, e.g. `/day`. Ignored without `value`. Not on `.action`. |
| `selected` | `bool` | `.selectable` only | Whether this row is the current pick. |
| `icon` | `CoreIconData` | `.action` only | The leading icon. |
| `onTap` | `VoidCallback?` | `.action` only | Called when the row is tapped. Null disables the row. |
| `semanticLabel` | `String?` | No | Screen-reader label. Defaults to the visible texts joined by `. `, e.g. `Scissor lift — 19ft. Used last week. $120.00 /day`. |

## Styling

| Part | Typography | Colour |
|---|---|---|
| Title | `bodyLargeSemiBold` (`.action`: `bodyMediumSemiBold`) | `textHeadline`; `textLink` when selected or on `.action` |
| Subtitle | `bodySmallRegular` | `textBody` |
| Value | `bodyLargeSemiBold` | `textHeadline` |
| Unit | `bodySmallRegular` | `textBody` |
| Leading icon | 20 dp, then a 12 dp gap | `textLink` |
| Selected fill | radius 12 dp | `backgroundBlueLight` |

The 2 dp gap between title and subtitle comes from the storyboard; `CoreSpacing` has no step that small.

## Accessibility

The row is one button node with the label above. A `.selectable` row also reports its selected state. Every text colour holds 4.5:1 on the page and on the selected fill, in both themes.
