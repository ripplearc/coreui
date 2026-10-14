# CoreOutlinedIconButton Component

`CoreOutlinedIconButton` is a square icon button: a 36 dp box with a 1 dp light edge and a 20 dp grey icon. The app puts it at the end of a form field, e.g. the magnifier beside Rate and Amount that opens the rate look-up (storyboard CUJ 4–6, `cuj456_screen.css` `.iconbtn`).

The box sits centred in a 48 dp square that takes the taps, so the hit area meets the 48 dp minimum while the drawn box stays 36 dp.

## Usage

```dart
CoreOutlinedIconButton(
  icon: CoreIcons.search,
  semanticLabel: 'Look up a rate',
  onTap: openRateLookup,
)
```

## Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `icon` | `CoreIconData` | Yes | The icon drawn in the box. |
| `onTap` | `VoidCallback` | Yes | Called when the button is tapped. |
| `semanticLabel` | `String` | Yes | Screen-reader label. The button has no visible text, so this is its only name. |

## Styling

| Part | Value |
|---|---|
| Box | 36 dp (`boxSize`), no fill, so it takes the colour of the surface under it |
| Edge | 1 dp, `lineMid` |
| Corners | 9 dp (`borderRadius`); `CoreSpacing` has no 9 dp step |
| Icon | 20 dp, `iconGrayMid` |
| Tap area | 48 dp (`tapTargetSize`) |
| Ink ripple | inside the box |

## Accessibility

The button is one button node named by `semanticLabel`. The icon holds 3:1 on the page in both themes (WCAG 1.4.11).
