# CoreInlineErrorRow Component

`CoreInlineErrorRow` is a one-line error that sits under a field, inside a sheet or in place of a list: a 14 dp error icon, the message in the error colour and, optionally, a link-style action such as "Try again". It knows nothing about what failed. The caller passes the localised message and decides what the action does.

## Usage

```dart
CoreInlineErrorRow(
  message: 'Could not load your rates',
  actionLabel: 'Try again',
  onAction: reload,
)
```

## Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `message` | `String` | Yes | The error text, already localised. Wraps onto more lines when long. |
| `actionLabel` | `String?` | No | Link-style text after the message, e.g. "Try again". Given with `onAction` or not at all (asserted). |
| `onAction` | `VoidCallback?` | No | Called when the action is tapped. |
| `actionKey` | `Key?` | No | Key of the action's tap zone, for tests. |

## Styling

| Part | Style | Colour |
|---|---|---|
| Icon | `CoreIcons.error`, `CoreIconSize.size14` (the storyboard draws it at about 14 dp; the ticket said 16), centred on the first line of the message | `textError` |
| Message | `bodySmallRegular`, 8 dp (`space2`) after the icon | `textError` |
| Action | `bodyLargeSemiBold` (the storyboard draws 16 sp) | `textLink` |
| Action pressed | the zone fills, 8 dp wider at each side, radius 8 dp | `backgroundGrayMid` |
| Action focused | 2 dp ring around the zone, 8 dp wider at each side, radius 8 dp | `outlineFocus` |

The action's tap zone is at least 48 dp square, as wide as the label, so a row with an action is 48 dp high and one without is one text line high (about 20 dp). The action is at most half the row wide and its label wraps beyond that, so at large text sizes the message keeps at least half the row. The label itself ends at the row's end edge, as the storyboard draws it; the fill and the focus ring are painted 8 dp wider at each side than the zone, which draws outside it and never moves the layout. The row sets no padding; the caller places it, and the action's fill and focus ring are painted 8 dp wider than the zone at each side, so leave 8 dp of room at the row's ends where a parent clips.

## Keyboard

Tab reaches the action; Enter or Space calls `onAction`. Focus draws a 2 dp `outlineFocus` ring around the zone, 8 dp wider at each side, so nothing moves. A touch tap draws no ring.

## Accessibility

The icon and message are one live region, so a screen reader announces the message when the row appears. The icon has no label, so it adds nothing to the announcement. The action is a separate button node outside the live region, so a retry does not re-announce the message. Both text colours hold 4.5:1 on the page background in both themes.
