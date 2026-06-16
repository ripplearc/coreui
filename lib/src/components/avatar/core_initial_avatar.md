# CoreInitialAvatar Component

`CoreInitialAvatar` is a circular avatar that displays a single initial derived from a name, on a themed background. It is a thin, purpose-built wrapper over [`CoreAvatar`](avatar.md) for the common "owner row" pattern — a small circle showing the first initial of a name.

Colours default to design-system tokens (so dark mode is handled by the theme), but every colour is overridable so callers can theme the avatar independently.

## Usage

```dart
// Default: 24x24 mid-blue circle with a centered "J"
CoreInitialAvatar(name: 'John Doe')

// Custom colors (e.g. per-owner theming from the app)
CoreInitialAvatar(
  name: 'Floyd Miles',
  backgroundColor: CoreBackgroundColors.backgroundGreenLight,
  textColor: CoreIconColors.green,
)

// Larger avatar with a custom text style
CoreInitialAvatar(
  name: 'Esther Howard',
  radius: 20,
  textStyle: Theme.of(context).coreTypography.bodyLargeSemiBold,
)
```

## Properties

| Property          | Type         | Required | Description                                                                                  |
|-------------------|--------------|----------|----------------------------------------------------------------------------------------------|
| `name`            | `String`     | Yes      | Name the initial is derived from. `"John Doe"` → `"J"`. A blank name renders an empty circle. |
| `radius`          | `double`     | No       | Circle radius; diameter = `radius * 2`. Defaults to `12` (24×24).                            |
| `backgroundColor` | `Color?`     | No       | Circle background. Defaults to the theme's `backgroundBlueMid` token.                        |
| `textColor`       | `Color?`     | No       | Colour of the initial. Defaults to the theme's `iconOrient` token.                           |
| `textStyle`       | `TextStyle?` | No       | Full override of the initial's text style. Defaults to the theme's `bodySmallMedium`.        |
| `semanticLabel`   | `String?`    | No       | Screen-reader label. Defaults to `"Avatar for {name}"`.                                      |

## Initial derivation

The initial is the **first character of the first whitespace-delimited token**, uppercased:

| Name           | Initial |
|----------------|---------|
| `"John Doe"`   | `"J"`   |
| `"floyd miles"`| `"F"`   |
| `"madonna"`    | `"M"`   |
| `"  "` (blank) | `""` (empty circle, no crash) |

This is a single first-name initial — it does **not** combine first and last initials.

## Colour & text-style precedence

- `backgroundColor` → falls back to `backgroundBlueMid`.
- `textColor` → falls back to `iconOrient`.
- `textStyle` → falls back to `bodySmallMedium`.

`textColor` is the single source of truth for the glyph colour: it is applied **last**, on top of `textStyle`. So passing a `textStyle` that itself sets a colour will not change the initial's colour — set `textColor` for that.

## Accessibility

The avatar exposes a semantic label (`"Avatar for {name}"` by default) via the underlying `CoreAvatar`. Override it with `semanticLabel` when the surrounding context already conveys the name.
