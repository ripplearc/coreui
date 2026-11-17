# CoreInlineErrorRow Component

`CoreInlineErrorRow` is a one-line error that sits under a field, inside a sheet or in place of a list: a 16 dp error icon, the message in the error colour and, optionally, a link-style action such as "Try again". It knows nothing about what failed. The caller passes the localised message and decides what the action does.

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
| Icon | `CoreIcons.error`, `CoreIconSize.size16`, centred on the first line of the message, which follows the phone's text size | `iconRed` |
| Message | `bodySmallRegular`, 8 dp (`space2`) after the icon | `textError` |
| Action | `bodyLargeSemiBold` (the storyboard draws 16 sp) | `textLink` |
| Action pressed | the label turns `buttonPress`, with no fill, as the library Text button does | `buttonPress` |
| Action focused | 3 dp stadium ring around the label, 12 dp wider at each side and 5 dp above and below | `outlineFocus` |

The action's tap zone is at least 48 dp square, as wide as the label, and 12 dp (`space3`) after the message, so a row with an action is 48 dp high and one without is one text line high (16 dp). The action is at most half the row wide and its label wraps beyond that, so at large text sizes the message keeps the rest of the row less the 12 dp gap. The label ends at the row's end edge, as the storyboard draws it. The focus ring is painted 12 dp wider than the label at each side, outside the zone, and never moves the layout. The row sets no padding; the caller places it, so leave 12 dp of room at the row's ends where a parent clips.

The row measures its width with a `LayoutBuilder`, so it cannot be placed inside an intrinsic-size parent such as `IntrinsicHeight` or `IntrinsicWidth`: it throws there.

## Keyboard

Tab reaches the action; Enter or Space calls `onAction`. Focus draws a 3 dp `outlineFocus` ring around the label, 12 dp wider at each side, so nothing moves. A touch tap draws no ring.

## Accessibility

The icon and message are one live region, so a screen reader announces the message when the row appears. The icon has no label, so it adds nothing to the announcement. The action is a separate button node outside the live region, so a retry does not re-announce the message. Both text colours hold 4.5:1 on the page background in both themes.
