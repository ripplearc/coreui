# CoreDetailsRow Component

`CoreDetailsRow` folds a detail of a form away: a rounded grey row with a label, a bold value, an optional link-style action after a dot, and a chevron. A tap on the label, the value or the chevron calls `onToggle`; while `expanded`, `child` shows under the row inside the same grey card. The value stays in the folded row, so it is never hidden; only the panel that edits it is.

The app uses it for the Delivery row of the equipment form ("Delivery — · Add note"). Design: storyboard CUJ 4–6 `.mod` / `.modx` (`cuj456_screen.css`), Figma "Details Row" in node `66337:162350`.

The caller owns `expanded`, so it can also open the row itself, e.g. when "Add note" is tapped.

## Usage

```dart
CoreDetailsRow(
  label: 'Delivery',
  value: fee == null ? '—' : formatMoney(fee),
  expanded: _deliveryOpen,
  onToggle: () => setState(() => _deliveryOpen = !_deliveryOpen),
  actionLabel: 'Add note',
  onAction: openNoteField,
  child: Column(children: [deliveryFeeField, noteField]),
)
```

## Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `label` | `String` | Yes | The name of the detail, e.g. "Delivery". |
| `value` | `String` | Yes | The value, already formatted, e.g. `$150` or `—`. Ends in an ellipsis when long. |
| `expanded` | `bool` | Yes | Whether `child` shows under the row. Turns the chevron up. |
| `onToggle` | `VoidCallback` | Yes | Called when the label, the value or the chevron is tapped. |
| `actionLabel` | `String?` | No | Link-style text after a dot, e.g. "Add note". Given with `onAction` or not at all (asserted). |
| `onAction` | `VoidCallback?` | No | Called when the action is tapped. |
| `child` | `Widget?` | No | The panel shown while `expanded`. |
| `semanticLabel` | `String?` | No | Screen-reader label of the toggle. Defaults to `label` then `value`, e.g. `Delivery $150`. |

## Styling

| Part | Typography | Colour |
|---|---|---|
| Card | radius 12 dp, 1 dp edge | `backgroundGrayLight` fill, `lineLight` edge |
| Label | `bodyMediumRegular` | `textBody` |
| Value | `bodyMediumSemiBold` | `textHeadline` |
| Dot | `bodySmallRegular`, 4 dp each side | `textDisable` |
| Action | `bodyMediumSemiBold` | `textLink` |
| Chevron | 20 dp, centred 24 dp in from the end edge; turns in 150 ms | `iconGrayMid` |

The row is 48 dp tall, the label starts 16 dp in, and each tap zone (toggle, action, chevron) is at least 48 dp wide. The panel is inset 16 dp at the sides and 12 dp above and below.

## Accessibility

The toggle is one button node with the label above and its expanded state. The action is a second button node. The chevron is left out of the tree because the toggle already carries its action. Every text colour holds 4.5:1 on the card, and the chevron 3:1, in both themes.
