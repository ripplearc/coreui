# CorePreferencesSheet

A bottom sheet body listing settings grouped into sections. Each row shows its
label, what it currently reads, and opens a single-choice sub-sheet
(`CorePreferenceOptionSheet`) when tapped.

The sheet holds **no persistent state**. It reports a choice through
`onChanged(key, optionId)` and leaves the caller to supply `sections` again
with the new value, so the stored preference stays the single source of truth.

```dart
CoreQuickSheet.show<void>(
  context: context,
  child: CorePreferencesSheet(
    title: l10n.preferences,
    sections: sections,
    optionUpdateLabel: l10n.update,
    optionBackSemanticsLabel: l10n.backToPreferences,
    onChanged: (key, optionId) => prefs.set(key, optionId),
  ),
);
```

## Describing a row

`CorePreferenceValue` is sealed, with two variants, because the calculator's
rows do not all read the same way:

| Variant | Renders as | Used for |
| :--- | :--- | :--- |
| `CorePreferenceTextValue(label, isMuted:)` | text in `textLink`, or `textDisable` when muted | most rows — `1/16`, `in`, `2,000 lb (US short ton)` |
| `CorePreferencePillValue(label, isOn:)` | an outlined pill with a state dot, green when on and grey when off | rows that read as a state — `● Imperial`, `● Off` |

Muted text is for preferences the app cannot act on yet, so a stub reads as
quieter rather than as a live value.

A row with fewer than two options is inert: it renders its value but opens no
sub-sheet.

## Deep linking

`initialKey` scrolls the matching row into view before the first frame the
user sees, and marks it for `CorePreferencesSheet.emphasisDuration` so they
can tell where they landed. This is the path from a rendered value to the
preference that formats it — tapping the fraction in `3-5/16in` opens the
sheet on Fractional resolution. An unknown key simply opens the list at the
top.

> The mark is not in the Figma spec, which shows no deep-linked state. It is
> this component's answer to "lands on that row without the user scrolling",
> and is the part most likely to be revised once design catches up.

## Explanations

A row may carry a `CorePreferenceInfo`, which puts an info button in the
sub-sheet's header. It bundles the heading, the body and both accessibility
labels, so the button can never render unlabelled.

## Strings

Every string is a parameter — the component carries no defaults, in line with
the 0.15.0 localization rule. `optionUpdateLabel` and
`optionBackSemanticsLabel` are forwarded to the sub-sheet the rows open; the
explanation's strings ride on the row itself.

## Testing

`rowKeyOf(key)` builds a stable key per row. `optionKeyOf(id)` and
`optionUpdateButtonKey` are forwarded to the sub-sheet, so a consumer can drive
a whole change end-to-end — open a row, pick an option, commit — without
matching any of it by text.
