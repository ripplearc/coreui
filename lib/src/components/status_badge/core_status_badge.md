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

| Variant | Size | Height | Radius | Side padding | Fill | Outline | Text (light / dark) | Icon |
|---|---|---:|---:|---:|---|---|---|---|
| `warning` | `regular` | 24 | 8 | 10 | `backgroundOrangeMid` | `lineOrange` | `textWarningStrong` | optional |
| `warning` | `compact` | 20 | 6 | 8 | `backgroundOrangeLight` | `lineOrange` | `textWarningStrong` | no |
| `neutral` | `regular` | 22 | 6 | 11 | `backgroundGrayMid` | none | `textGrayMid` | no |

Sources: Figma Rate Status (component set `65685:147068`), the Text Field label row Badge and the Tag component, all in Estimate V2. The label is the 12/16 semibold body-small style. The width follows the label.

## Behaviour

- A label wider than the space it is given is cut with an ellipsis on one line.
- The badge announces `label` as one text node. Without `onInfoTap` the info icon is decorative and hidden from screen readers. With it, the icon is a button announced as `infoSemanticLabel`.
- The tap area is the icon plus the badge's right padding, as tall as the badge. A 24 dp badge cannot reach a 44 to 48 dp tap target, so place it where a missed tap is harmless.
- The asserts that refuse other pairings are skipped by a release build, which then draws the nearest look.
- "Estimated" (the delivery-fee tag in Figma) is the regular warning look without an icon, so it needs no variant of its own.
- The 10 and 11 dp padding steps are constants until CoreSpacing has them (CA-1238).

## Accessibility

Every look meets 4.5:1 text contrast in the light and dark themes, and the info icon meets 3:1. Tests cover this for each variant and size.
