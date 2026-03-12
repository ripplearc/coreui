# CoreChip

A selectable chip that supports three sizes, an optional leading icon, an optional close (×) action, and visual feedback for default, focused, pressed, and selected states.

## Usage

```dart
final selected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Filter',
  selected: selected,
  size: CoreChipSize.medium,
  icon: CoreIcons.check,
  onTap: () => debugPrint('toggled'),
);
```

## Properties

| Property | Type | Required | Default | Description |
|---|---|---:|---|---|
| `label` | `String` | Yes | — | The text displayed on the chip. |
| `selected` | `ValueNotifier<bool>` | Yes | — | Owns the selected state. The chip toggles `selected.value` on tap. |
| `size` | `CoreChipSize` | No | `CoreChipSize.medium` | Size variant: `small`, `medium`, `large`. |
| `icon` | `CoreIconData?` | No | `null` | Optional leading icon shown before the label. |
| `onTap` | `VoidCallback?` | No | `null` | Called after a tap, after `selected.value` has been toggled. |
| `withCloseIcon` | `bool` | No | `false` | Whether the close (×) icon can be shown. |
| `onRemove` | `VoidCallback?` | No | `null` | Called when the close (×) icon is tapped. You must remove the chip from the widget tree yourself. |

Notes:

- The close icon is rendered only when `withCloseIcon == true` **and** `onRemove != null`.

## Sizes

`CoreChipSize.small` and `CoreChipSize.medium` share the same overall visual style (grey surface, no shadow). `CoreChipSize.large` uses a page background surface with a drop shadow.

| Size | Padding | Shadow |
|---|---|---|
| `small` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space2, vertical: 2.0)` | None |
| `medium` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space3, vertical: CoreSpacing.space2)` | None |
| `large` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space3, vertical: CoreSpacing.space3)` | `CoreShadows.small` |

## States

The chip resolves visuals from `CoreChipTheme` based on:

- **Selected** (`selected.value == true`)
- **Pressed** (pointer down; internal)
- **Focused** (keyboard focus; internal `FocusNode`)

## Examples

### Basic chip

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Category',
  selected: isSelected,
);
```

### Chip with icon

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Favorites',
  selected: isSelected,
  icon: CoreIcons.favorite,
);
```

### Small chip

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Tag',
  selected: isSelected,
  size: CoreChipSize.small,
);
```

### Large chip with shadow

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Premium',
  selected: isSelected,
  size: CoreChipSize.large,
  icon: CoreIcons.checkCircle,
);
```

### Chip with tap + remove

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Removable',
  selected: isSelected,
  withCloseIcon: true,
  onTap: () => debugPrint('selected: ${isSelected.value}'),
  onRemove: () => debugPrint('remove chip'),
);
```

### Multiple chips in a Wrap

```dart
final chip1Selected = ValueNotifier<bool>(false);
final chip2Selected = ValueNotifier<bool>(true);
final chip3Selected = ValueNotifier<bool>(false);

Wrap(
  spacing: 12,
  runSpacing: 12,
  children: [
    CoreChip(label: 'Option 1', selected: chip1Selected),
    CoreChip(label: 'Option 2', selected: chip2Selected),
    CoreChip(label: 'Option 3', selected: chip3Selected),
  ],
);
```

## Styling

The component uses theme-aware tokens from `AppColorsExtension` and `AppTypographyExtension`:

- **Text style**: `typography.bodyMediumRegular`
- **Corner radius**: `BorderRadius.circular(CoreSpacing.space6)`
- **Animation**: `CoreChipTheme.animationDuration` (`120ms`)
- **Icons**:
  - Leading icon color: `colors.outlineFocus`
  - Close icon color: `colors.iconGrayMid`

### Background resolution

Priority: pressed → focused (small/medium only) → selected → default.

- Default background:
  - `large`: `colors.pageBackground`
  - `small`/`medium`: `colors.chipGrey`
- Pressed: `colors.pageBackground`
- Focused (small/medium): `colors.chipGrey`
- Selected: `colors.pageBackground`

### Border color resolution

Priority: selected → pressed → focused → default.

- Selected: `colors.outlineHover`
- Pressed: `colors.lineDarkOutline`
- Focused: `colors.lineHighlight`
- Default:
  - `large`: `colors.lineMid`
  - `small`/`medium`: `colors.chipGrey`

### Border width

- Default: `CoreChipTheme.borderWidth` (`1px`)
- Focused: `CoreChipTheme.borderWidthFor(isFocused: true)` (`2px`)
