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

## Strings

Every string is a parameter, including the accessibility labels for the back
and info buttons.

## Testing

`optionKeyOf(id)`, `updateButtonKey` and `infoButtonKey` give tests stable
finders. The selected row is exposed as `Semantics(selected: true)`.
