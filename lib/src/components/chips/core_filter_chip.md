# CoreFilterChip Component

`CoreFilterChip` is the library Filter chip: a label and a drop-down arrow in
an outlined pill, used in filter rows. Tapping it opens whatever the caller
shows, usually a sheet of choices. The inactive `CoreDateFilterChip` is a
`CoreFilterChip`.

## Usage

```dart
CoreFilterChip(
  label: 'Owner',
  onTap: () => showOwnerSheet(context),
)
```

## Properties

| Property        | Type            | Required | Description                                                     |
|-----------------|-----------------|----------|-----------------------------------------------------------------|
| `label`         | `String`        | Yes      | The text on the chip.                                           |
| `onTap`         | `VoidCallback?` | No       | Called when the chip is tapped. Null draws a chip that does not respond. |
| `semanticLabel` | `String?`       | No       | Accessibility label. Defaults to `label`.                       |

`CoreFilterChip.pillKey` finds the outlined pill in widget tests.

## Design

| Part | Spec |
|------|------|
| Pill | at least 32 dp high, radius 20, 12 dp at the sides, `pageBackground` fill, 1 dp `lineDarkOutline` border |
| Label | `bodyMediumRegular` in `textDark` |
| Arrow | `CoreIcons.arrowDropDown`, 24 dp, `textDark`, 8 dp after the label |
| Touch area | at least 48 x 48 dp around the pill |

## States

- **Pressed**: the pill fills `backgroundGrayMid`, as the library List control
  chip does. The library draws no Press state for the Filter chip.
- **Focused** (Tab): the pill border is `outlineFocus` at the chip focus width
  (2 dp). The chip keeps its size, and no tint covers the touch area.
- **Large text**: the pill height is a minimum, so at 200% text the pill grows
  and the label is not cut.

The chip brings its own transparent `Material`, so it draws the same on a
coloured parent, or with no `Material` above it.

## Accessibility

The chip is one button node labelled `semanticLabel` (or `label`). Its text and
arrow are excluded from the semantics tree, so the label is read once.
