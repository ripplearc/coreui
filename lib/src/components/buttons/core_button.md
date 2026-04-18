# CoreButton

A customizable button widget that supports flexible content through labels or custom widgets, different sizes, variants, icons, and shadows.

## Usage

```dart
CoreButton(
  label: 'Register',
  onPressed: () => print('Button Pressed'),
  variant: CoreButtonVariant.primary,
  size: CoreButtonSize.large,
)
```

## Properties

| Property | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `label` | `String?` | No\* | `null` | The text displayed on the button. Required if `child` is null. |
| `child` | `Widget?` | No\* | `null` | A custom widget to display instead of the label. Required if `label` is null. |
| `onPressed` | `VoidCallback?` | No | `null` | The callback function when the button is pressed. If null, the button is disabled. |
| `size` | `CoreButtonSize` | No | `CoreButtonSize.large` | Size variant: `small`, `medium`, `large`. |
| `variant` | `CoreButtonVariant` | No | `CoreButtonVariant.primary` | Style variant: `primary`, `secondary`, `social`. |
| `icon` | `CoreIconWidget?` | No | `null` | Optional icon displayed on the button. |
| `isDisabled` | `bool` | No | `false` | Whether the button is visually and functionally disabled. |
| `fullWidth` | `bool` | No | `true` | If true, the button takes the full width of its parent. |
| `borderRadius` | `double` | No | `CoreSpacing.space10` | The border radius of the button. |
| `centerAlign` | `bool` | No | `true` | Whether to center align the content. |
| `spaceOut` | `bool` | No | `false` | If true and an icon is present, adds space between icon and label. |
| `trailing` | `bool` | No | `false` | If true, places the icon after the label. |
| `shadows` | `List<BoxShadow>?` | No | `null` | Optional list of shadows to apply to the button. |
| `focusNode` | `FocusNode?` | No | `null` | Optional focus node to control button focus state. |
| `autofocus` | `bool` | No | `false` | Whether the button should be auto-focused. |

\* Either `label` or `child` must be provided.

## Variants

- **Primary**: Solid background using `colors.buttonSurface`.
- **Secondary**: Outlined button with transparent background.
- **Social**: Specifically designed for social login buttons (e.g., Google, Microsoft). Requires `CoreButtonSize.large`.

## Examples

### Primary Button
```dart
CoreButton(
  label: 'Primary',
  onPressed: () {},
)
```

### Secondary Button with Icon
```dart
CoreButton(
  label: 'Secondary',
  variant: CoreButtonVariant.secondary,
  icon: CoreIconWidget(icon: CoreIcons.add),
  onPressed: () {},
)
```

### Custom Child with Shadows
```dart
CoreButton(
  variant: CoreButtonVariant.secondary,
  shadows: CoreShadows.small,
  onPressed: () {},
  trailing: true,
  icon: const CoreIconWidget(icon: CoreIcons.edit),
  child: Text.rich(
    TextSpan(
      children: [
        TextSpan(
          text: 'O.C: ',
          style: Theme.of(context).coreTypography.bodyLargeRegular.copyWith(
                color: Theme.of(context).coreColors.textBody,
              ),
        ),
        TextSpan(
          text: '6ft',
          style: Theme.of(context).coreTypography.bodyLargeSemiBold.copyWith(
                color: Theme.of(context).coreColors.textHeadline,
              ),
        ),
      ],
    ),
  ),
)
```
