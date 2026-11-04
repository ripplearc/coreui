# CoreCheckRowItem Component

`CoreCheckRowItem` is a selectable list row with a leading widget, a title (and optional subtitle), and a trailing checkbox. Tapping anywhere on the row toggles selection. The leading area defaults to a [`CoreAvatar`](../avatar/avatar.md) showing the first initial of the row's title. At large text sizes the initial scales down to stay inside the circle.

It draws one of two parts of the Figma library:

| | `CoreCheckRowItem(...)`: Dropdown cell | `CoreCheckRowItem.checkRow(...)`: Check row |
|---|---|---|
| Used in | Multi-select sheets, such as an owner / assignee filter | Lists such as the CUJ 8 "Send to" sheet |
| Figma | Dropdown cell With Image (57516:18872) | List item, Type Check row (62505:74872; states 66801:224013 / 224021 / 224029 / 224037) |
| Padding | 12 dp on every side | 12 dp above and below, 20 dp left and right |
| Gaps | 8 dp avatar to text | 12 dp between avatar, text and box |
| Avatar | 24 dp, `backgroundBlueMid`, one initial (`initialFor`) in `bodySmallMedium` `textHeadline` | 40 dp, `backgroundBlueLight`, two initials (`initialsFor`, "JS" as in the storyboard's Send to list) in `bodyLargeSemiBold` `textLink` |
| Name | `bodyMediumRegular`, `textDark` | `bodyLargeMedium`, `textHeadline` |
| Second line | `bodySmallRegular`, `textBody` | `bodyMediumRegular`, `textBody` |
| Box | `outlineFocus` ticked, `iconGrayMid` empty | `iconDark` ticked, `iconGrayMid` empty |
| Selected | `backgroundBlueLight` fill, 48 dp radius | No fill; only the box changes |
| Pressed | No tint (the library cell has none) | `backgroundGrayMid` fill, Background/Grey Mid as the library draws it |
| Divider | None | 1 dp `lineLight`, inset 20 dp, on the bottom edge (adds no height). `showDivider: false` on the last row |
| Height | 48 dp | 64 dp with the default avatar, 68 dp with a second line; never under 48 dp |

Both looks share the rest:

- **Disabled** (`enabled: false`): the row ignores taps, Tab skips it, a screen reader reads it as disabled, and the name, second line and default initial use `textDisable`. A custom `leading` or `avatarTextColor` is not dimmed. The box keeps its look.
- **Keyboard focus**: Tab reaches the row, Enter or Space toggles it, and a 2 dp `outlineFocus` ring is drawn just inside the row, following its radius. A touch never shows the ring. Neither library part draws a focused state; the ring is the one every coreui part uses.
- `showDivider` exists only on `CoreCheckRowItem.checkRow`, so a Dropdown cell cannot be given a divider.

## Usage

```dart
// Default: leading avatar shows the first initial of the title
CoreCheckRowItem(
  title: 'John Doe',
  selected: isSelected,
  onChanged: (value) => setState(() => isSelected = value),
)

// With a subtitle (e.g. email)
CoreCheckRowItem(
  title: 'Floyd Miles',
  subtitle: 'floyd@acme.com',
  selected: isSelected,
  onChanged: onChanged,
)

// Custom avatar colors (passthrough to the default leading avatar)
CoreCheckRowItem(
  title: 'Esther Howard',
  avatarBackgroundColor: CoreBackgroundColors.backgroundGreenLight,
  avatarTextColor: CoreTextColors.success,
  selected: isSelected,
  onChanged: onChanged,
)

// The library Check row, e.g. the "Send to" sheet; no divider on the last row
CoreCheckRowItem.checkRow(
  title: 'Floyd Miles',
  subtitle: 'floyd@acme.com',
  selected: isSelected,
  showDivider: !isLastRow,
  onChanged: onChanged,
)

// Fully custom leading widget (avatar color params are ignored)
CoreCheckRowItem(
  title: 'Savannah Nguyen',
  leading: CoreAvatar(radius: 12, image: NetworkImage(url)),
  selected: isSelected,
  onChanged: onChanged,
)
```

## Properties

| Property                | Type                     | Required | Description                                                                                          |
|--------------------------|--------------------------|----------|--------------------------------------------------------------------------------------------------------|
| `title`                 | `String`                 | Yes      | Primary text. Also used to derive the default leading avatar's initial and the default semantic label. |
| `subtitle`               | `String?`                | No       | Optional secondary line shown below `title` (e.g. an email address).                                  |
| `selected`               | `bool`                   | Yes      | Whether the row is currently checked.                                                                  |
| `onChanged`              | `ValueChanged<bool>`     | Yes      | Called with the toggled value when the row or checkbox is activated.                                  |
| `enabled`                | `bool`                   | No       | Defaults to `true`. `false` disables the row (see above).                                              |
| `showDivider`            | `bool`                   | No       | `checkRow` only. Defaults to `true`. Pass `false` on the last row of a list.                           |
| `leading`                | `Widget?`                | No       | Leading widget. Defaults to a circle showing the first initial of `title`: 24 dp in the Dropdown cell, 40 dp in the Check row. |
| `avatarBackgroundColor`  | `Color?`                 | No       | Background color for the default leading avatar. Ignored when `leading` is supplied.                  |
| `avatarTextColor`        | `Color?`                 | No       | Initial-text color for the default leading avatar. Ignored when `leading` is supplied.                |
| `avatarTextStyle`        | `TextStyle?`             | No       | Full override of the default leading avatar's initial text style. Ignored when `leading` is supplied. `avatarTextColor` is applied on top. |
| `semanticLabel`          | `String?`                | No       | Accessibility label for the row. Defaults to `title`; in the Check row with a `subtitle`, to "title, subtitle". |

## Initial derivation

The Dropdown cell's default avatar shows **one initial** (`CoreCheckRowItem.initialFor`): the first character of the first whitespace-delimited word of `title`, uppercased. The Check row's shows **two** (`CoreCheckRowItem.initialsFor`): the first character of each of the first two words.

| Title                | Dropdown cell | Check row |
|----------------------|---------------|-----------|
| `"John Doe"`         | `"J"`         | `"JD"`    |
| `"floyd miles"`      | `"F"`         | `"FM"`    |
| `"Anne Marie Smith"` | `"A"`         | `"AM"`    |
| `"madonna"`          | `"M"`         | `"M"`     |
| `"  "` (blank)       | `""` (empty circle, no crash) | `""` |

## Behavior

- The entire row (not just the checkbox) is tappable; tapping calls `onChanged(!selected)`.
- The trailing checkbox icon mirrors `selected`: a filled checked square when `true`, an empty outline square when `false`.
- `leading` takes full precedence over `avatarBackgroundColor`/`avatarTextColor`/`avatarTextStyle` — when supplied, those params have no effect.
- `avatarTextColor` is the single source of truth for the initial's glyph color: it is applied **last**, on top of `avatarTextStyle`. So passing an `avatarTextStyle` that itself sets a color will not change the initial's color — set `avatarTextColor` for that.

## Accessibility

The row exposes a `Semantics(button: true, enabled: enabled, checked: selected)` node with a label (defaulting to `title`, or "title, subtitle" in the Check row when it has a second line, so two people with the same name sound different); the trailing checkbox icon is excluded from the semantics tree to avoid a duplicate, separately-focusable element, since toggling is exposed at the row level.
