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
| `subtitle` | `String?` | No | `null` | A second line under the title. Nothing is drawn when null. |
| `onBack` | `VoidCallback` | Yes | — | Called when the arrow is tapped. The header does not pop anything itself. |
| `backSemanticLabel` | `String` | Yes | — | What a screen reader announces for the arrow. |

## Layout

Source: Figma Sheet Header / Headline in Estimate V2 (`66337:158600`; the same header is on `66368:186022`, `66368:186054` and `66337:159434`).

| Part | Value |
|---|---|
| Arrow | `CoreIcons.arrowLeft`, 24 dp, `textLink`, 12 dp from the left and the top |
| Arrow tap area | 48 × 48 dp |
| Text | starts 48 dp from the left, 11 dp from the top, 20 dp from the right, 15 dp above the bottom |
| Title | `titleMediumSemiBold` (18/26), `textHeadline` |
| Subtitle | `bodyMediumRegular` (14/20), `textBody` |
| Height | 72 dp with a subtitle, 52 dp without |

The arrow sits 1 dp lower than the text so it is centred on the 26 dp title line, as Figma draws it.

## Behaviour

- The title and the subtitle are each one line, cut with an ellipsis when they do not fit.
- The header has no drag handle. `CoreQuickSheet` draws that above its content.
- Figma puts 10 dp between the arrow and the text. The header uses 12, so the arrow's tap area is 48 dp wide, the Android minimum. The text starts 2 dp further right than in Figma.

## Accessibility

The arrow is a button announced as `backSemanticLabel`. The title is marked as a heading, so a screen reader can jump to it. Tests check the tap target, the button label and text contrast in the light and dark themes.
