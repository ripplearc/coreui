# CoreStatusBadge

A small pill that tags a value with its status, such as the orange "Sample rate" tag on a looked-up rate or the grey "After first send" tag. Replaces the one-off `Container` + `Text` badges each feature used to build for itself.

## Usage

```dart
CoreStatusBadge(
  label: context.l10n.sampleRate,
  showInfoIcon: true,
  onInfoTap: showSampleRateExplanation,
  infoSemanticLabel: context.l10n.aboutSampleRate,
)

CoreStatusBadge(
  label: context.l10n.sampleRate,
  size: CoreStatusBadgeSize.compact,
)

CoreStatusBadge(
  label: context.l10n.afterFirstSend,
  variant: CoreStatusBadgeVariant.neutral,
)
```

## Properties

| Property | Type | Required | Default | Description |
|---|---|---:|---|---|
| `label` | `String` | Yes | — | The text shown in the badge. Localised by the app. |
| `variant` | `CoreStatusBadgeVariant` | No | `warning` | `warning` (orange) or `neutral` (grey). |
| `size` | `CoreStatusBadgeSize` | No | `regular` | `regular` or `compact`. |
| `showInfoIcon` | `bool` | No | `false` | Adds a 14 dp info icon after the label. Regular warning badge only. |
| `onInfoTap` | `VoidCallback?` | No | `null` | Makes the icon a button. Needs `showInfoIcon` and `infoSemanticLabel`. |
| `infoSemanticLabel` | `String?` | No | `null` | What a screen reader announces for the icon button. Required with `onInfoTap`. |

## Looks

These are the only combinations Figma draws. Any other pairing fails an assert.

| Variant | Size | Min height | Radius | Side padding | Fill | Outline | Text | Icon |
|---|---|---:|---:|---:|---|---|---|---|
| `warning` | `regular` | 24 | 8 | 10 | `chipOrange` | 1 dp `lineOrange` | `textWarningStrong` | optional |
| `warning` | `compact` | 20 | 6 | 8 | `backgroundOrangeLight` | 1 dp `lineOrange` | `textWarningStrong` | no |
| `neutral` | `regular` | 22 | 6 | 11 | `backgroundGrayMid` | none | `textGrayMid` | no |

Side padding is measured inside the 1 dp outline. Each colour is a theme token, so the same token name gives the right colour in the light and the dark theme. Heights are minimums: a badge grows taller when the user sets a larger text size.

Sources: Figma Rate Status (component set `65685:147068`), the Text Field label row Badge and the Tag component, all in Estimate V2. The label is the 12/16 semibold body-small style. The width follows the label.

## Behaviour

- A label wider than the space it is given is cut with an ellipsis on one line.
- The badge announces `label` as one text node. Without `onInfoTap` the info icon is decorative and hidden from screen readers. With it, the icon is a button announced as `infoSemanticLabel`.
- The tap area is 28 × 22 dp: a 4 dp gap, the 14 dp icon and the 10 dp right padding, inside the 24 dp badge less its 1 dp outline on each side. A 24 dp badge cannot reach a 44 to 48 dp tap target, so place it where a missed tap is harmless.
- The asserts that refuse other pairings are skipped by a release build. The pairing then falls back to the regular look. An info icon is still drawn if you ask for it.
- Figma also draws "Estimated" and "Your rate", but no screen uses them. Do not add them until the product manager names a screen.

## Accessibility

Every look meets 4.5:1 text contrast in the light and dark themes, and the info icon meets 3:1. Tests cover this for each variant and size.
