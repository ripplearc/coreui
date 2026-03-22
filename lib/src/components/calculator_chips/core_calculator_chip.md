# CoreCalculatorChip

A specialized chip for the calculator that supports three distinct types (`editable`, `disabled`, `active`), an optional
label, a required value, and an optional close (×) icon. Uses semantic structuring for accessibility.

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

| Property        | Type                     | Required | Default | Description                                                                           |
|-----------------|--------------------------|---------:|---------|---------------------------------------------------------------------------------------|
| `type`          | `CoreCalculatorChipType` |      Yes | —       | The variant of the calculator chip (`editable`, `disabled`, `active`).                |
| `value`         | `String`                 |      Yes | —       | The numeric value or content displayed on the chip with heavy text style.             |
| `onTap`         | `VoidCallback`           |       No | `null`  | Called when the chip is tapped. Ignored if type is `disabled`.                        |
| `label`         | `String?`                |       No | `null`  | The optional label displayed before the value. **Required** when type is `disabled`.  |
| `withCloseIcon` | `bool`                   |       No | `false` | Whether to show the close (×) icon on the left side. Not shown if type is `disabled`. |
| `onClose`       | `VoidCallback?`          |       No | `null`  | Called when the close (×) icon is tapped.                                             |

## Types

Calculator chips come in three visual identity variants mapping to their functional states:

- **Editable**: Light layout with page background surface and focus borders.
- **Active**: Vivid background (e.g. green) indicating the property is actively changing or applied.
- **disabled**: Grey, dimmed layout indicating an inactive property.

| Type       | Background           | Border         | Label/Value Color | Close Icon Color | Shadow  |
|------------|----------------------|----------------|-------------------|------------------|---------|
| `editable` | `pageBackground`     | `outlineFocus` | `textLink`        | `iconOrient`     | `small` |
| `disabled` | `backgroundGrayMid`  | `lineMid`      | `textDark`        | `iconGrayMid`    | `null`  |
| `active`   | `backgroundGreenMid` | `lineMid`      | `textDark`        | `iconGrayDark`   | `null`  |

## Examples

### Editable Chip without Close Icon

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.editable,
  label: 'Length',
  value: '22ft',
  onTap: () {},
);
```

### Disabled Chip

Must have `label` and `value`. No tap events will execute.

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

### Editable Chip with Close Icon

```dart
CoreCalculatorChip(
  type: CoreCalculatorChipType.editable,
  value: '4in',
  withCloseIcon: true,
  onTap: () {},
  onClose: () => debugPrint('remove'),
);
```

## Styling

The component uses theme-aware tokens from `AppColorsExtension` and `AppTypographyExtension`, managed within
`CoreCalculatorChipTheme`:

- **Padding**: `CoreSpacing.space2` horizontal, `CoreSpacing.space1` vertical.
- **Corner radius**: `BorderRadius.circular(CoreSpacing.space6)`
- **Label style**: `typography.bodySmallRegular`
- **Value style**: `typography.bodyMediumSemiBold`
- **Icon size**: `CoreSpacing.space5`.
- **Shadow**: `CoreShadows.small` for `editable`, `null` otherwise.
