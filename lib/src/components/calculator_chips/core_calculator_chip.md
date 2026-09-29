# CoreCalculatorChip

A specialized chip for the calculator tape that supports nine types (`editable`, `disabled`, `active`, `result`,
`dashed`, `error`, `bracketOpen`, `bracketClosed`, `stale`), an optional label, a value, an optional factor icon
(+, -, etc), tap / long-press callbacks and an `inert` state that layers over any type. Uses semantic structuring for
accessibility.

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
| `type`                   | `CoreCalculatorChipType` |      Yes | —       | The variant of the calculator chip (`editable`, `disabled`, `active`, `result`, `dashed`, `error`, `bracketOpen`, `bracketClosed`, `stale`). |
| `value`                  | `String`                 |       No | `null`  | The numeric value or content displayed on the chip with heavy text style. For the bracket variants, the text inside the brackets — the chip draws the brackets. |
| `factor`                 | `CoreIconData?`          |       No | `null`  | An optional factor icon (e.g. `+`, `-`, `x`) displayed before the element.                              |
| `onTap`                  | `VoidCallback`           |       No | `null`  | Called when the chip is tapped. Ignored if type is `disabled` or the chip is `inert`.                   |
| `tapSemanticLabel`       | `String?`                |       No | `null`  | Screen-reader hint for the tap action ("double tap to …"). Requires `onTap` (asserted); a closed bracket's "reopen the bracket". Pass a localised string. |
| `semanticsLabel`         | `String?`                |       No | `null`  | Replaces the screen-reader label built from `label` and the drawn value. The app must pass it for the bracket variants — their state is punctuation a screen reader skips. Pass a localised string. |
| `onLongPress`            | `VoidCallback`           |       No | `null`  | Called when the chip is long-pressed (the calculator opens provenance this way). Ignored if `disabled` or `inert`. |
| `longPressSemanticLabel` | `String?`                |       No | `null`  | Screen-reader hint for the long-press action. Requires `onLongPress` (asserted) and is withheld while `disabled`; pass a localised string. |
| `label`                  | `String?`                |       No | `null`  | The optional label displayed before the value. **Required** when type is `disabled`.                    |
| `inert`                  | `bool`                   |       No | `false` | Dims the chip to `CoreCalculatorChipTheme.inertOpacity`, ignores tap and long-press and reports the chip disabled, while keeping the look of its `type`. The chips before an open bracket, and after a reopened one, wait like this. |

## Types

On the tape an **outlined** chip is something the user typed and a **filled** chip is something the app worked out.

- **Editable**: Light layout with page background surface and focus borders. What the user typed.
- **Active**: Vivid background (e.g. green) indicating the property is actively changing or applied.
- **Disabled**: Grey, dimmed layout indicating an inactive property. Ignores tap and long-press.
- **Result**: Filled grey chip for an answer the app computed. Shares the `disabled` fill by design (prototype `.t-result`) but stays interactive so a long-press can open provenance.
- **Dashed**: Dashed teal outline for a tentative value — a bind offer (`Height: 8ft ?`) or a chip being edited in place.
- **Error**: Red fill with a regular-weight value for the dimension-error chip that backspace repairs. Keeps button semantics on purpose: it stays interactive like every variant but `disabled`, so the app can attach a repair action to tap or long-press.
- **Bracket open**: A bracket the user is still typing inside (UX design doc term 2.22, Section 7). The `active` green under a dashed teal edge, drawn without its closing bracket: `value: '3×4'` reads `(3×4`. The dash means one thing on the tape — this chip is not settled yet.
- **Bracket closed**: The same chip once closed: `(3×4)` on a blue fill under a solid teal edge. A tap reopens it, so `onTap` is the reopen action. Requires a `value` (asserted): an empty closed bracket is removed by the calculator, never drawn.
- **Stale**: An answer that is out of date because a chip before it is being edited (a reopened bracket, or a value changed in place). The `result` fill under a dashed grey edge, showing `CoreCalculatorChip.stalePlaceholder` (`—`) in place of a number so no out-of-date figure can be read; the label stays, so it reads `Calc —`. Takes no `value` (asserted). Stays interactive unless `inert`. The dash is punctuation a screen reader skips, so pass `semanticsLabel` ("Calc, pending").

A screen reader skips brackets and coreui has no localised words of its own, so both bracket variants announce the same "3 times 4" when built without a `semanticsLabel`. The app must pass `semanticsLabel` ("open bracket, 3 times 4" / "bracket, 3 times 4") for every bracket chip and, on the closed chip, `tapSemanticLabel` ("reopen the bracket").

| Type       | Background            | Border                      | Label/Value Color | Factor Color   | Shadow  |
|------------|-----------------------|-----------------------------|-------------------|----------------|---------|
| `editable` | `pageBackground`      | `outlineFocus`              | `textLink`        | `iconOrient`   | `small` |
| `disabled` | `backgroundGrayMid`   | `lineMid`                   | `textDark`        | `iconGrayMid`  | `null`  |
| `active`   | `backgroundGreenMid`  | `lineMid`                   | `textDark`        | `iconGrayDark` | `null`  |
| `result`   | `backgroundGrayMid`   | `lineMid`                   | `textDark`        | `iconGrayDark` | `null`  |
| `dashed`   | `backgroundBlueLight` | dashed `outlineFocus`       | `textLink`        | `iconOrient`   | `small` |
| `error`    | `alertRed`            | `alertRedOutline`           | `textDark`        | `iconRed`      | `small` |
| `bracketOpen` | `backgroundGreenMid` | dashed `outlineFocus`     | `textLink`        | `iconOrient`   | `null`  |
| `bracketClosed` | `backgroundBlueMid` | `outlineFocus`           | `textLink`        | `iconOrient`   | `null`  |
| `stale`    | `backgroundGrayMid`   | dashed `lineDarkOutline`    | `textDark`        | `iconGrayDark` | `null`  |

The `error` value drops to `bodyMediumRegular` (the chip carries a sentence, not a number). The `dashed` outline is a
`CoreDashedBorderDecoration` applied as the chip's `foregroundDecoration` — `CoreCalculatorChipTheme.dashedOutline`
resolves it, and the solid border is painted transparent at the same width so every variant measures the same.

The tokens follow the Figma **Calculator Chip** component set (Design System page, node `58781:24269`, variants
`Editable` / `Disabled` / `Active` / `Result` / `Dashed` / `Error`, each with a `Factor` axis): `Result` is defined with
the `Disabled` fill and border, `Dashed` is `#EEFAFF` under a `#015B7C` dashed stroke with the value `8ft ?`, `Error` is
`#FEE4E2` inside a `#FECDCA` (`red200`) stroke with a 14 px regular value, and the outlined `Editable` / `Dashed` /
`Error` variants carry the small drop shadow while the filled ones sit flat. `alertRedOutline` was added for the error
stroke. The populated calculator screens (`61948:65013` result, `61948:65858` editing) use the same instances. Two
spec values stay off-grid and are not reproduced: the dashed stroke is 1.5 px with a 4 / 3 dash in Figma, here 1 px
with a 4 / 4 dash (`CoreSpacing.space1`) so every variant keeps the same border width.

The bracket chips follow the prototype (`.t-group` / `.t-group-open` in `construculator-prototype.html`) and the UX
design doc walkthroughs 12.6 and 12.8; there is no Figma variant for them. The open bracket wears the live green
every chip being typed into wears (`#cffce4`, `backgroundGreenMid`) and the closed one the prototype's blue
(`#d6eeff`, nearest token `backgroundBlueMid`), both under the teal the typed chips use. They sit flat like the other
filled chips; the prototype draws no shadows at all.

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

### A tape around a reopened bracket

Walkthrough 12.8: `2 + (3×4) × 5 = 70`, then the bracket chip is tapped. The chips after it wait, dimmed, and the
answer keeps its chip but reads `Calc —`.

```dart
Wrap(children: [
  CoreCalculatorChip(type: CoreCalculatorChipType.editable, value: '2', inert: true),
  CoreCalculatorChip(type: CoreCalculatorChipType.bracketOpen, factor: CoreIcons.addOperator, value: '3×4'),
  CoreCalculatorChip(type: CoreCalculatorChipType.editable, factor: CoreIcons.multiplyOperator, value: '5', inert: true),
  CoreCalculatorChip(type: CoreCalculatorChipType.stale, label: 'Calc', semanticsLabel: l10n.calcPending, inert: true),
]);
```

**Inert opacity.** The prototype dims a waiting chip to 55 % (`.t-frozen`), which drops the typed teal to 2.7:1 on the
page. `CoreCalculatorChipTheme.inertOpacity` is 70 %, the strongest dim that keeps every variant's text at or above
the 3:1 floor WCAG 1.4.11 sets for user-interface components in both themes — a test composites every type's text
over its fill at that opacity and asserts the ratio. WCAG 1.4.3 exempts an inactive control from the 4.5:1 text floor,
and an inert chip reports itself disabled so the automated contrast guideline treats it as one. Open with design.

### Bracket Chips

The operator before the bracket is the `factor`; `value` is what sits inside the brackets.

```dart
// Reads "+ (3×4" while the user types inside the bracket…
CoreCalculatorChip(
  type: CoreCalculatorChipType.bracketOpen,
  factor: CoreIcons.addOperator,
  value: '3×4',
  semanticsLabel: l10n.openBracketChip('3×4'),
);

// …and "+ (3×4)" once it closes; a tap reopens it.
CoreCalculatorChip(
  type: CoreCalculatorChipType.bracketClosed,
  factor: CoreIcons.addOperator,
  value: '3×4',
  semanticsLabel: l10n.bracketChip('3×4'),
  onTap: () => reopenBracket(),
  tapSemanticLabel: l10n.reopenBracket,
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
- **Dashed outline**: `CoreSpacing.space1` dash / `CoreSpacing.space1` gap at `borderWidth`. `CoreCalculatorChipTheme.isDashed` decides which variants dash; `edgeColor` is the edge's colour whether solid or dashed, `borderColor` the solid side (transparent when dashed) and `dashedOutline` the decoration.
- **Value spacing**: the `space1` gap before the value is drawn only when a factor or a label precedes it, so a value-only chip sits centred.
