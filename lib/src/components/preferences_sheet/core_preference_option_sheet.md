# CorePreferenceOptionSheet

A bottom sheet body offering the choices of a single preference. Opened by a
row of `CorePreferencesSheet`, but usable on its own for any one-of-many
choice that should be confirmed rather than applied on tap.

```dart
CoreQuickSheet.show<void>(
  context: context,
  child: CorePreferenceOptionSheet(
    title: l10n.meterLengthDisplay,
    options: const [
      CorePreferenceOption(id: '0.0', label: '0.0'),
      CorePreferenceOption(id: '0.00', label: '0.00'),
    ],
    selectedOptionId: current,
    updateLabel: l10n.update,
    backSemanticsLabel: l10n.backToPreferences,
    onUpdate: (id) => prefs.setMeterDecimals(id),
  ),
);
```

## Pick, then commit

Tapping an option changes **nothing the caller can see**. Selection is local
until the user taps Update, at which point `onUpdate` receives the chosen id
and the sheet pops itself. That is what lets a user open a setting, look
through the choices and back out unchanged — the back button and a swipe-away
both leave the preference alone.

Update stays disabled until the pick matches one of `options`. A sheet opened
with a `selectedOptionId` that matches nothing — a value left over after the
option set changed — shows no ticked row and cannot commit that id.

## The explanation

Pass a `CorePreferenceInfo` to get an info button in the header. Opening it
replaces the Update button with a `Toast.info` carrying the explanation, so the
sheet keeps its height instead of growing under the user's thumb.

The explanation is taller than the button it replaces, so a row that carries one
reserves the taller of the two from the start: the footer of such a sheet is
already explanation-sized while Update is showing. A row with no
`CorePreferenceInfo` reserves nothing and sits as tight as its content.

```dart
info: const CorePreferenceInfo(
  title: 'Meter length display',
  description: 'Changes the number of decimal places shown',
  semanticsLabel: 'About this preference',
  closeLabel: 'Close',
),
```

The four fields travel together as one object rather than as loose optional
parameters, so a caller cannot configure the button and forget its labels — an
interactive control with no semantics label is invisible to a screen reader.

## Why the pick is tracked, not inferred

The sheet records that the user has touched a row rather than comparing the
pick against the value it opened with. A user who taps away and taps back lands
on that same value, and comparing would read their deliberate re-pick as never
having touched anything — letting a change made elsewhere overwrite it.

Update is enabled by the pick being one of `options`, not by it being non-null.
A caller can hand the sheet an id that matches no option, and no row would tick;
committing it would hand that ghost id back as a fresh choice the user never
made.

## Strings

Every string is a parameter, including the accessibility labels for the back
and info buttons.

## Testing

`optionKeyOf(id)`, `updateButtonKey` and `infoButtonKey` give tests stable
finders. The selected row is exposed as `Semantics(selected: true)`.
