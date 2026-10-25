# CoreSheetHeader

The header at the top of a bottom sheet: a back arrow on the left, a title, and an optional subtitle under it. Every equipment sheet in Estimate V2 starts with it. Use it in place of a hand-built `Row` of an arrow and text.

## Usage

```dart
CoreQuickSheet.show(
  context: context,
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      CoreSheetHeader(
        title: context.l10n.excavator,
        subtitle: context.l10n.meteredRate,
        backSemanticLabel: context.l10n.backLabel,
        onBack: () => Navigator.of(context).pop(),
      ),
      // the sheet's fields
    ],
  ),
);
```

## Properties

| Property | Type | Required | Default | Description |
|---|---|---:|---|---|
| `title` | `String` | Yes | — | The main line. Localised by the app. |
| `subtitle` | `String?` | No | `null` | A second line under the title: the subtitle, or the meta line for `CoreSheetHeaderStyle.metaLine`. Nothing is drawn when null. |
| `onBack` | `VoidCallback?` | No | `null` | Called when the arrow is tapped. The header does not pop anything itself. Without it there is no arrow: the library Back=Off variant, for the first step of a sheet. |
| `backSemanticLabel` | `String?` | With `onBack` | `null` | What a screen reader announces for the arrow. Asserted when `onBack` is set. |
| `style` | `CoreSheetHeaderStyle` | No | `standard` | `standard` for a form sheet, `metaLine` for a sheet that lists records, such as Logs. |
| `showBottomLine` | `bool` | No | `false` | A 1 dp `lineLight` line under the header. Turn it on only when the content under the header scrolls. |

## Layout

Source: the library Sheet Header set (Figma `66335:151191`), variants Back=On (`66335:151178`), Back=Off and Back=Off Meta line.

| Part | Value |
|---|---|
| Arrow (Back=On) | `CoreIcons.arrowLeft`, 24 dp, `textLink`, 12 dp from the left, centred on the title line |
| Arrow tap area | 48 × 48 dp |
| Text, Back=On | starts 48 dp from the left |
| Text, Back=Off | 20 dp from both sides; 16 dp for the meta line |
| Text, top and bottom | 4 dp above the title, 8 dp under the last line |
| Title | `titleMediumSemiBold` (18/26), `textHeadline` |
| Subtitle | `bodyMediumRegular` (14/20) with a back arrow; `bodySmallRegular` (12/16) on the first step and for the meta line; `textBody` |
| Height (Back=On) | 58 dp with a subtitle, 48 dp without (the arrow's tap area) |

The arrow sits 1 dp below the 4 dp text padding, so it is centred on the 26 dp title line. The library draws the arrow box as one 48 dp wide layer, so the title starts at x 48, as the owner approved on 2026-10-14.

## Behaviour

- The title and the subtitle are each one line, cut with an ellipsis when they do not fit.
- The header has no drag handle. `CoreQuickSheet` draws that above its content.
- When a sheet step opens, focus moves to the title, as the library asks.

## Accessibility

The arrow is a button announced as `backSemanticLabel`. The title is marked as a heading, so a screen reader can jump to it, and it takes focus when the step opens. Tests check the tap target, the button label and text contrast in the light and dark themes.
