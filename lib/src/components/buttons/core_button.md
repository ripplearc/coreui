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
| `borderColor` | `Color?` | No | `null` | Overrides the border colour the variant resolves, in every state. |
| `borderWidth` | `double?` | No | `null` | Overrides the border width the variant resolves (`0` primary, `1` social, `2` secondary). `CoreButton.hairlineBorderWidth` is the 1 px chip-style edge. |
| `semanticsHint` | `String?` | No | `null` | Screen-reader hint announced after the label — what a tap does (`'Edits the rate'`). Pass a localised string. |
| `focusNode` | `FocusNode?` | No | `null` | Optional focus node to control button focus state. |
| `autofocus` | `bool` | No | `false` | Whether the button should be auto-focused. |

\* Either `label` or `child` must be provided.

## Variants

- **Primary**: Solid background using `colors.buttonSurface`, `colors.buttonPress` while pressed. When focused it keeps its fill and draws a 3 px `colors.outlineFocus` ring 5 px outside the button, with a 2 px transparent gap.
- **Secondary**: Outlined button with transparent background. When focused it keeps its colours and draws the same 3 px ring as the primary button.
- **Social**: Specifically designed for social login buttons (e.g., Google, Microsoft). Requires `CoreButtonSize.large`. The logo sits at the left edge, 20 px in, and the label is centred on its own in Body Large Medium. The label keeps the logo's width plus 8 px clear on both sides, so a long label ends in "…" instead of running under the logo. 1 px `colors.lineMid` border; `colors.backgroundGrayMid` fill while pressed. Disabled: no fill, the `lineMid` border and `textDisable` text. With `fullWidth: false` it is as wide as its content.

Large buttons have 20 px side padding, Medium 20 px and Small 16 px. Small labels are Body Medium Semibold; Large and Medium labels are Body Large Semibold.

Large buttons are 48 px tall, Medium 40 px and Small 36 px. Medium and Small draw that height inside a 48 x 48 px tap area, so they take 48 px of layout and a tap just outside the drawn edge still counts. The heights are minimums: with a large text size the button grows instead of cutting the label. A social button is 48 px tall whatever height its parent offers.

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
