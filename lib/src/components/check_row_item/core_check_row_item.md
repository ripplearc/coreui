# CoreCheckRowItem Component

`CoreCheckRowItem` is a selectable list row with a leading widget, a title (and optional subtitle), and a trailing checkbox. Tapping anywhere on the row toggles selection. It's designed for multi-select sheets such as an owner / assignee filter, where the leading area defaults to a 40×40 [`CoreAvatar`](../avatar/avatar.md) showing the first initial of the row's title.

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
| `enabled`                | `bool`                   | No       | Defaults to `true`. When `false` the row ignores taps, reads as disabled, and its text uses `textDisable`. |
| `showDivider`            | `bool`                   | No       | Defaults to `true`. Draws the 1 dp divider on the bottom edge; pass `false` on the last row.          |
| `leading`                | `Widget?`                | No       | Leading widget. Defaults to a 40×40 circle showing the first initial of `title`.                       |
| `avatarBackgroundColor`  | `Color?`                 | No       | Background color for the default leading avatar. Ignored when `leading` is supplied.                  |
| `avatarTextColor`        | `Color?`                 | No       | Initial-text color for the default leading avatar. Ignored when `leading` is supplied.                |
| `avatarTextStyle`        | `TextStyle?`             | No       | Full override of the default leading avatar's initial text style. Ignored when `leading` is supplied. `avatarTextColor` is applied on top. |
| `semanticLabel`          | `String?`                | No       | Accessibility label for the row. Defaults to `title`.                                                  |

## Initial derivation

The default leading avatar's initial is the **first character of the first whitespace-delimited token** of `title`, uppercased:

| Title           | Initial |
|-----------------|---------|
| `"John Doe"`    | `"J"`   |
| `"floyd miles"` | `"F"`   |
| `"madonna"`     | `"M"`   |
| `"  "` (blank)  | `""` (empty circle, no crash) |

## Design

Matches the Check row of the Figma List item set.

| Part | Spec |
|------|------|
| Padding | 12 top and bottom, 20 left and right; 12 between avatar, text and box |
| Avatar | 40×40, `backgroundBlueLight`, initials `bodyLargeSemiBold` in `textLink` |
| Name | `bodyLargeMedium`, `textHeadline` |
| Second line | `bodyMediumRegular`, `textBody` |
| Box | 24 dp, `iconDark` when ticked, `iconGrayMid` when not |
| Divider | 1 dp `lineLight`, inset 20 from each edge, on the bottom edge of the row |
| Pressed | row filled with `backgroundGrayLight` |
| Disabled (`enabled: false`) | name, second line and default initials in `textDisable`; a custom `leading` or `avatarTextColor` is not dimmed; the box keeps its look; taps ignored |

The row is at least 48 dp high. The API for the Disabled state is the `enabled` flag.

## Behavior

- The entire row (not just the checkbox) is tappable; tapping calls `onChanged(!selected)`.
- The trailing checkbox icon mirrors `selected`: a filled checked square when `true`, an empty outline square when `false`.
- `leading` takes full precedence over `avatarBackgroundColor`/`avatarTextColor`/`avatarTextStyle` — when supplied, those params have no effect.
- `avatarTextColor` is the single source of truth for the initial's glyph color: it is applied **last**, on top of `avatarTextStyle`. So passing an `avatarTextStyle` that itself sets a color will not change the initial's color — set `avatarTextColor` for that.

## Accessibility

The row exposes a `Semantics(button: true, enabled: enabled, checked: selected)` node with a label (defaulting to `title`); the trailing checkbox icon is excluded from the semantics tree to avoid a duplicate, separately-focusable element, since toggling is exposed at the row level.
