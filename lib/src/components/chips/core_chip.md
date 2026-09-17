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
| `label` | `String?` | No | `null` | The primary text displayed on the chip. |
| `value` | `String?` | No | `null` | Optional secondary text displayed after the label in bold. |
| `unit` | `String?` | No | `null` | Optional unit displayed after the value in heavy weight. |
| `selected` | `ValueNotifier<bool>` | Yes | — | Owns the selected state. The chip toggles `selected.value` on tap (unless `isSmartChip` is true). |
| `size` | `CoreChipSize` | No | `CoreChipSize.medium` | Size variant: `small`, `medium`, `large`, `mini`. |
| `icon` | `CoreIconData?` | No | `null` | Optional leading icon shown before the label. |
| `onTap` | `VoidCallback?` | No | `null` | Called after a tap. |
| `withCloseIcon` | `bool` | No | `false` | Whether the close (×) icon can be shown. |
| `isSmartChip` | `bool` | No | `false` | If true, the chip acts as a "smart chip" that highlights on tap for 1 second instead of toggling selection. |
| `onRemove` | `VoidCallback?` | No | `null` | Called when the close (×) icon is tapped. You must remove the chip from the widget tree yourself. |
| `outline` | `CoreChipOutline` | No | `CoreChipOutline.solid` | Outline style: `solid`; `dashed` for a tentative offer (a bind suggestion); `highlight` for the rule that fired (a deterministic suggestion). |
| `semanticsLabel` | `String?` | No | `null` | Overrides the announced text; defaults to `label`, `value` and `unit` joined with spaces. |

Notes:

- At least one of `label`, `value`, or `unit` must be provided.

- The close icon is rendered only when `withCloseIcon == true` **and** `onRemove != null`.

## Sizes

`CoreChipSize.small` and `CoreChipSize.medium` share the same overall visual style (grey surface, no shadow). `CoreChipSize.large` uses a page background surface with a drop shadow. `CoreChipSize.mini` is the large chip's secondary form: the same page-background surface and `lineMid` outline at the medium padding, no shadow, and a semibold value in place of the heavy unit — the value-only chips on the conversions row of a two-row `CoreSuggestionArea` (calculator prototype `sc-mini`).

| Size | Padding | Surface | Shadow |
|---|---|---|---|
| `small` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space2, vertical: 2.0)` | `chipGrey` | None |
| `medium` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space3, vertical: CoreSpacing.space2)` | `chipGrey` | None |
| `large` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space3, vertical: CoreSpacing.space3)` | `pageBackground`, `lineMid` outline | `CoreShadows.small` |
| `mini` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space3, vertical: CoreSpacing.space2)` | `pageBackground`, `lineMid` outline | None |

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

### Multi-part chip

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Volume',
  value: '2700',
  unit: 'ft³',
  selected: isSelected,
);
```

### Dashed offer chip

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Height:',
  value: '8ft ?',
  selected: isSelected,
  size: CoreChipSize.large,
  outline: CoreChipOutline.dashed,
  isSmartChip: true,
);
```

### Smart chip

```dart
final isSelected = ValueNotifier<bool>(false);

CoreChip(
  label: 'Smart Chip',
  selected: isSelected,
  isSmartChip: true,
  icon: CoreIcons.lightning,
);
```

## Styling

The component uses theme-aware tokens from `AppColorsExtension` and `AppTypographyExtension`:

- **Text style** (`CoreChipTheme.labelStyle` / `valueStyle` / `unitStyle`): label `typography.bodyMediumMedium` in `colors.textBody`; value `bodyMediumMedium` and unit `bodyMediumSemiBold` at `CoreChipTheme.unitFontWeight` (w800) in `colors.textDark`. A `mini` chip reads its value and unit in plain `bodyMediumSemiBold` instead, so the whole value is one semibold run
- **Corner radius**: `BorderRadius.circular(CoreSpacing.space6)`
- **Animation**: `CoreChipTheme.animationDuration` (`120ms`)
- **Icons**:
  - Leading icon color: `colors.outlineFocus`
  - Close icon color: `colors.iconGrayMid`

### Background resolution

Priority: pressed → focused (small/medium only) → selected → default. `CoreChipTheme.onPageSurface(size)` is true for `large` and `mini`.

- Default background:
  - `large`/`mini`: `colors.pageBackground`
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
  - `large`/`mini`: `colors.lineMid`
  - `small`/`medium`: `colors.chipGrey`

### Border width

- Default: `CoreChipTheme.borderWidth` (`1px`)
- Focused: `CoreChipTheme.borderWidthFor(isFocused: true)` (`2px`)

### Dashed outline

`CoreChipOutline.dashed` keeps every size, state and animation and swaps only the border:

- Background: unchanged — the chip's usual fill for its size (Figma Suggestion Strip Chip `Bind`)
- Solid border: `colors.transparent` at the normal width, so the chip measures the same
- Outline: `CoreDashedBorderDecoration` in `colors.outlineFocus`, `CoreChipTheme.dashLength` / `gapLength` (`4px` / `4px`), stroke following `borderWidthFor` so a focused chip thickens like a solid one

The dashes are the chip's `foregroundDecoration`, so the solid border and its animation are untouched.

### Highlight outline

`CoreChipOutline.highlight` is the Figma Suggestion Strip Chip `Deterministic` look — the rung that fired from the named dimensions on screen:

- Border: `colors.lineHighlight` at `CoreChipTheme.borderWidthFor(outline: highlight)` (`2px`, the focus width); selected and pressed colours still win
- Padding: the extra border width is taken from the padding, so a highlight chip measures the same as a solid one
- Background: unchanged
