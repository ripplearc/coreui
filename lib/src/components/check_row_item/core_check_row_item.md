# CoreCheckRowItem Component

`CoreCheckRowItem` is a selectable list row with a leading widget, a title (and optional subtitle), and a trailing checkbox. Tapping anywhere on the row toggles selection. It's designed for multi-select sheets such as an owner / assignee filter, where the leading area defaults to a [`CoreInitialAvatar`](../avatar/core_initial_avatar.md) built from the row's title.

## Usage

```dart
// Default: leading initial avatar derived from the title
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
  avatarTextColor: CoreIconColors.green,
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
| `title`                 | `String`                 | Yes      | Primary text. Also used to build the default leading avatar and the default semantic label.          |
| `subtitle`               | `String?`                | No       | Optional secondary line shown below `title` (e.g. an email address).                                  |
| `selected`               | `bool`                   | Yes      | Whether the row is currently checked.                                                                  |
| `onChanged`              | `ValueChanged<bool>`     | Yes      | Called with the toggled value when the row or checkbox is activated.                                  |
| `leading`                | `Widget?`                | No       | Leading widget. Defaults to a 24×24 `CoreInitialAvatar` built from `title`.                            |
| `avatarBackgroundColor`  | `Color?`                 | No       | Background color for the default leading avatar. Ignored when `leading` is supplied.                  |
| `avatarTextColor`        | `Color?`                 | No       | Initial-text color for the default leading avatar. Ignored when `leading` is supplied.                |
| `semanticLabel`          | `String?`                | No       | Accessibility label for the row. Defaults to `title`.                                                  |

## Behavior

- The entire row (not just the checkbox) is tappable; tapping calls `onChanged(!selected)`.
- The trailing checkbox icon mirrors `selected`: a filled checked square when `true`, an empty outline square when `false`.
- `leading` takes full precedence over `avatarBackgroundColor`/`avatarTextColor` — when supplied, those color params have no effect.

## Accessibility

The row exposes a `Semantics(button: true, checked: selected)` node with a label (defaulting to `title`); the trailing checkbox icon is excluded from the semantics tree to avoid a duplicate, separately-focusable element, since toggling is exposed at the row level.
