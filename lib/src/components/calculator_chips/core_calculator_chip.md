# CoreCalculatorChip

A specialized chip for the calculator tape that supports six types (`editable`, `disabled`, `active`, `result`,
`dashed`, `error`), an optional label, a value, an optional factor icon (+, -, etc), and tap / long-press callbacks.
Uses semantic structuring for accessibility.

## Usage

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.editable,
  label: 'Length',
  value: '22ft',
  onTap: () => debugPrint('chip tapped'),
);
```

## Properties

| Property                 | Type                     | Required | Default | Description                                                                                             |
|--------------------------|--------------------------|---------:|---------|---------------------------------------------------------------------------------------------------------|
| `type`                   | `CoreCalculatorChipType` |      Yes | —       | The variant of the calculator chip (`editable`, `disabled`, `active`, `result`, `dashed`, `error`).     |
| `value`                  | `String`                 |       No | `null`  | The numeric value or content displayed on the chip with heavy text style.                               |
| `factor`                 | `CoreIconData?`          |       No | `null`  | An optional factor icon (e.g. `+`, `-`, `x`) displayed before the element.                              |
| `onTap`                  | `VoidCallback`           |       No | `null`  | Called when the chip is tapped. Ignored if type is `disabled`.                                          |
| `onLongPress`            | `VoidCallback`           |       No | `null`  | Called when the chip is long-pressed (the calculator opens provenance this way). Ignored if `disabled`. |
| `longPressSemanticLabel` | `String?`                |       No | `null`  | Screen-reader hint for the long-press action. Exposed only while `onLongPress` is set; pass a localised string. |
| `label`                  | `String?`                |       No | `null`  | The optional label displayed before the value. **Required** when type is `disabled`.                    |

## Types

On the tape an **outlined** chip is something the user typed and a **filled** chip is something the app worked out.

- **Editable**: Light layout with page background surface and focus borders. What the user typed.
- **Active**: Vivid background (e.g. green) indicating the property is actively changing or applied.
- **Disabled**: Grey, dimmed layout indicating an inactive property. Ignores tap and long-press.
- **Result**: Filled grey chip for an answer the app computed. Shares the `disabled` fill by design (prototype `.t-result`) but stays interactive so a long-press can open provenance.
- **Dashed**: Dashed teal outline for a tentative value — a bind offer (`Height: 8ft ?`) or a chip being edited in place.
- **Error**: Red fill with a regular-weight value for the dimension-error chip that backspace repairs.

| Type       | Background            | Border                      | Label/Value Color | Factor Color   | Shadow  |
|------------|-----------------------|-----------------------------|-------------------|----------------|---------|
| `editable` | `pageBackground`      | `outlineFocus`              | `textLink`        | `iconOrient`   | `small` |
| `disabled` | `backgroundGrayMid`   | `lineMid`                   | `textDark`        | `iconGrayMid`  | `null`  |
| `active`   | `backgroundGreenMid`  | `lineMid`                   | `textDark`        | `iconGrayDark` | `null`  |
| `result`   | `backgroundGrayMid`   | `lineMid`                   | `textDark`        | `iconGrayDark` | `null`  |
| `dashed`   | `backgroundBlueLight` | dashed `outlineFocus`       | `textLink`        | `iconOrient`   | `null`  |
| `error`    | `alertRed`            | `alertRed`                  | `textDark`        | `iconRed`      | `null`  |

The `error` value drops to `bodyMediumRegular` (the chip carries a sentence, not a number). The `dashed` outline is a
`CoreDashedBorderDecoration` applied as the chip's `foregroundDecoration` — `CoreCalculatorChipTheme.dashedOutline`
resolves it, and the solid border is painted transparent at the same width so every variant measures the same.

Tokens are mapped from the calculator prototype's tape chips (`.t-result`, `.t-stale`/`.s-bind`, `.t-error`); Figma
`61948:65013` (result) and `61948:65858` (editing) are the design sources for cross-checking. The prototype's error
border tint (`red200`) has no token, so `error` uses its fill as the border.

## Examples

### Editable Chip without Factor

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.editable,
  label: 'Length',
  value: '22ft',
  onTap: () {},
);
```

### Disabled Chip

Must have `label` and `value`. No tap or long-press events will execute.

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.disabled,
  label: 'Area',
  value: '410.67ft²',
  onTap: () {},
);
```

### Active Chip

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.active,
  label: 'Area',
  value: '410.67ft²',
  onTap: () {},
);
```

### Editable Chip with Factor

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.editable,
  value: '4in',
  factor: CoreIcons.addOperator,
  onTap: () {},
);
```

### Result Chip with provenance on long-press

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.result,
  label: 'Area',
  value: '410.67ft²',
  onLongPress: () => showProvenance(),
  longPressSemanticLabel: AppLocalizations.of(context).showProvenance,
);
```

### Dashed Chip (bind offer)

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.dashed,
  label: 'Height',
  value: '8ft ?',
  onTap: () => acceptBinding(),
);
```

### Error Chip

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.error,
  value: 'Dimension error',
);
```

## Styling

The component uses theme-aware tokens from `AppColorsExtension` and `AppTypographyExtension`, managed within
`CoreCalculatorChipTheme`:

- **Padding**: `CoreSpacing.space2` horizontal, `CoreSpacing.space1` vertical.
- **Corner radius**: `BorderRadius.circular(CoreSpacing.space6)`
- **Label style**: `typography.bodySmallRegular`
- **Value style**: `typography.bodyMediumSemiBold` (`bodyMediumRegular` for `error`)
- **Icon size**: `CoreSpacing.space5`.
- **Shadow**: `CoreShadows.small` for `editable`, `null` otherwise.
- **Dashed outline**: `CoreSpacing.space1` dash / `CoreSpacing.space1` gap at `borderWidth`.
