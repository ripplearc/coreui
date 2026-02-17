# CoreChip

A selectable chip component that supports different sizes, optional icons, and visual state feedback for default,
highlight, pressed, and selected states.

## Usage

```dart
final selectedNotifier = ValueNotifier<bool>(false);

CoreChip(
  label: 'Filter',
  selected: selectedNotifier,
)
```

## Properties

| Property   | Type                  | Required | Default               | Description                                 |
|------------|-----------------------|----------|-----------------------|---------------------------------------------|
| `label`    | `String`              | Yes      | —                     | The text displayed on the chip              |
| `selected` | `ValueNotifier<bool>` | Yes      | —                     | Controls the selected state of the chip     |
| `size`     | `CoreChipSize`        | No       | `CoreChipSize.medium` | The size of the chip (small, medium, large) |
| `icon`     | `CoreIconData?`       | No       | `null`                | Optional icon displayed before the label    |
| `onTap`    | `VoidCallback?`       | No       | `null`                | Callback invoked when the chip is tapped    |

## Sizes

| Size     | Horizontal Padding | Vertical Padding | Shadow |
|----------|--------------------|------------------|--------|
| `small`  | 8px                | 2px              | None   |
| `medium` | 12px               | 6px              | None   |
| `large`  | 12px               | 12px             | Medium |

## States

The chip supports the following visual states:

- **Default**: Normal appearance with size-dependent background and border
- **Highlight**: Border changes to `lineHighlight` color on hover/focus
- **Pressed**: Border changes to `lineDarkOutline` color while pressed
- **Selected**: Border changes to `outlineHover` color when selected

## Examples

### Basic Chip

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Category',
  selected: isSelected,
)
```

### Chip with Icon

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Favorites',
  selected: isSelected,
  icon: CoreIcons.favorite,
)
```

### Small Chip

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Tag',
  selected: isSelected,
  size: CoreChipSize.small,
)
```

### Large Chip with Shadow

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Premium',
  selected: isSelected,
  size: CoreChipSize.large,
  icon: CoreIcons.checkCircle,
)
```

### Chip with Tap Callback

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Action',
  selected: isSelected,
  onTap: () {
    print('Chip tapped, selected: ${isSelected.value}');
  },
)
```

### Multiple Chips in a Wrap

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
)
```

## Styling

The component uses theme-aware colors from `AppColorsExtension`:

- Background: `textInverse` (large) or `chipGrey` (small/medium)
- Border: Varies by state (`lineMid`, `lineHighlight`, `lineDarkOutline`, `outlineHover`)
- Icon color: `outlineFocus` (leading icon), `iconGrayMid` (close icon)
- Typography: `bodyMediumRegular`
- Border radius: Fully rounded (100px)
- Animation duration: 120ms for state transitions
