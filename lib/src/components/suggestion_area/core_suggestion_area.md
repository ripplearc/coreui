# CoreSuggestionArea

A specialized widget that provides a dedicated area for presenting smart recommendations to the user, including AI-driven insights (e.g. Area calculation) and contextual unit conversions. It elegantly handles overflow and expands into a scrollable list. Two layouts: the original single row with an AI / conversion **toggle**, and the calculator's **two rows** where the primary row and the conversions row are visible together and overflow independently. Each suggestion carries a `SuggestionKind`, mirroring the Figma Suggestion Strip Chip variants: a **deterministic** rung renders with the highlight outline, a **bind** offer with a dashed outline and a trailing `?` because accepting it relabels an existing chip instead of adding a result, and a **memory** recall with a leading history icon.

## Usage

```dart
CoreSuggestionArea(
  aiSuggestions: [
    SuggestionData(
      label: 'Area:', value: '90', unit: 'sq ft',
      kind: SuggestionKind.deterministic, onTap: () {},
    ),
    SuggestionData(
      label: 'Height:', value: '8ft',
      kind: SuggestionKind.bind, onTap: () {},   // renders as "Height: 8ft ?"
    ),
  ],
  conversionSuggestions: [
    SuggestionData(
      label: 'Conv:', value: '1080', unit: 'in',
      kind: SuggestionKind.conversion,
      semanticsLabel: 'Convert to 1080 inches', onTap: () {},
    ),
  ],
  suggestionAreaPlaceholder: 'Here you can see smart suggestions from us',
  hiddenChipsTextBuilder: (count) => '+$count',
  expandToggleSemanticsLabelBuilder: (count) => 'Show $count more suggestions',
  collapseToggleSemanticsLabel: 'Collapse suggestions',
  toggleSemanticsLabel: 'Toggle suggestion mode',
  onExpandedChanged: (expanded) {
    print('Suggestion area expanded: $expanded');
  },
)
```

## Properties

| Property | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `suggestionAreaPlaceholder` | `String` | No | `'Here you can see smart suggestions from us'` | Placeholder text shown when both `aiSuggestions` and `conversionSuggestions` are empty. Must be localised by the app. |
| `aiSuggestions` | `List<SuggestionData>?` | No | `null` | The list of AI recommendations to display (e.g. Area calculations). |
| `conversionSuggestions` | `List<SuggestionData>?` | No | `null` | The list of conversion metrics to display (e.g. feet to inches). Expected to carry `SuggestionKind.conversion` data only: in `twoRows` it is the secondary row, which drops every chip's label by position rather than by kind, so a `bind` or `memory` suggestion routed here would render as a bare value. |
| `onExpandedChanged` | `ValueChanged<bool>?` | No | `null` | Called when the user expands or collapses the suggestion area overflow list. |
| `hiddenChipsTextBuilder` | `String Function(int count)` | Yes | - | Builds the visible text for the overflow chip (e.g. `'+3'`). Must be localised by the app. |
| `expandToggleSemanticsLabelBuilder` | `String Function(int count)` | Yes | - | Semantics label for the expand control when collapsed. Used by screen readers. |
| `collapseToggleSemanticsLabel` | `String` | Yes | - | Semantics label for the collapse control when expanded. Used by screen readers. |
| `toggleSemanticsLabel` | `String` | Yes | - | Semantics label for the AI / conversion toggle shown when both lists are provided. Must be localised by the app. |
| `bindSuffix` | `String` | No | `'?'` | Trailing marker appended to a `SuggestionKind.bind` chip's last text segment (`Height: 8ft ?`). Override per locale. |
| `layout` | `CoreSuggestionLayout` | No | `toggle` | `toggle` — one row with an AI / conversion switch; `twoRows` — `aiSuggestions` on row 1, `conversionSuggestions` on row 2, no switch. |
| `secondRowHidden` | `bool` | No | `false` | In `twoRows`, folds the conversions row away (an `AnimatedSize` over `CoreSuggestionArea.animationDuration`, 300 ms) so the display area's dependent-key band can take the space. Ignored in `toggle`. |
| `conversionsExpandToggleSemanticsLabelBuilder` | `String Function(int count)?` | No | `null` | In `twoRows`, semantics label for the conversions row's expand control, so a screen reader can tell it from the primary row's. Falls back to `expandToggleSemanticsLabelBuilder`. Ignored in `toggle`. |
| `conversionsCollapseToggleSemanticsLabel` | `String?` | No | `null` | In `twoRows`, semantics label for the conversions row's collapse control. Falls back to `collapseToggleSemanticsLabel`. Ignored in `toggle`. |
| `conversionsRowTagLabel` | `String` | No | `'as'` | In `twoRows`, the word of the tag (ruler icon + text) that leads the conversions row, so "conversion" is said once and the chips show only their value. Decorative — excluded from semantics. Override per locale. Ignored in `toggle`. |
| `conversionsRowSemanticsLabel` | `String` | No | `'Convert to other units'` | In `twoRows`, the group label a screen reader announces on entering the conversions row, giving its value-only chips their context. Override per locale. Ignored in `toggle`. |
| `suggestionsSemanticsLabelBuilder` | `String Function(List<SuggestionData>)?` | No | `null` | Builds the live-region text announced when the visible suggestions change (the active list in `toggle`; both rows in `twoRows`, minus the conversions row while `secondRowHidden`). `null` uses `CoreSuggestionArea.defaultSuggestionsSemanticsLabel`, which joins each suggestion's `semanticsLabel` — or label, value and unit — with commas. Override per locale. |

### SuggestionData

| Property | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `label` | `String` | Yes | - | The display label of the chip (e.g. `'Area:'`). |
| `value` | `String` | Yes | - | The value shown after the label. |
| `unit` | `String?` | No | `null` | Optional unit shown after the value in heavy weight. |
| `onTap` | `VoidCallback` | Yes | - | Called when the chip is accepted. |
| `kind` | `SuggestionKind` | No | `predictive` | Which suggestion source produced the chip: `deterministic`, `predictive`, `bind`, `conversion`, `memory`. |
| `semanticsLabel` | `String?` | No | `null` | Overrides the announced text when the visible text does not read well aloud (`'12.57yd²'` → "Convert to 12.57 square yards"). |
| `testKey` | `Key?` | No | `null` | The key the chip carries for Patrol and widget tests. `null` takes the row's default: `CoreSuggestionArea.chipTestKey(index)` (`calc_strip_chip_<index>`) on the primary row and the toggle layout's single row, `CoreSuggestionArea.conversionChipTestKey(index)` (`calc_strip_conversion_<index>`) on the two-row layout's conversions row. |

## Suggestion kinds

| Kind | Meaning | Accepting it | Look |
| :--- | :--- | :--- | :--- |
| `deterministic` | A rule fired from named dimensions (Area from Length × Width). | Adds a result. | `CoreChipOutline.highlight` — 2 px `lineHighlight` outline |
| `predictive` | A context proposal (material count, cost, weight, recent value). | Adds a result. | Solid |
| `bind` | An offer to name an orphan value (`Height: 8ft ?`). | Relabels the existing chip instead of adding one. | `CoreChipOutline.dashed` — dashed `outlineFocus` outline + trailing `bindSuffix` |
| `conversion` | The value on screen re-expressed in another unit. | Replaces the value in place. | Solid; on the `twoRows` conversions row every chip is a value-only `CoreChipSize.mini` behind the row's `as` tag |
| `memory` | A value recalled from the calculator's memory slots (M1–M3). | Adds a result. | Solid, leading `CoreIcons.history` icon; an empty `label` shows the value alone |

The looks follow the Figma **Suggestion Strip Chip** component set (Design System page, node `66225:151222`, variants `Deterministic` / `Predictive` / `Conversion` / `Bind` / `Memory`): every strip chip is the plain 48 px chip, `Deterministic` adds a 2 px highlight outline, `Bind` a dashed teal outline, `Memory` a leading history icon; the spec's 1.5 px / 4-3 dash is rendered here at the chip's 1 px / 4-4 dash. `predictive` and `conversion` exist so the app can attach the right accept behaviour without re-deriving it from the label text. The dashed look reuses `CoreDashedBorderDecoration` from `CoreCalculatorChip`'s dashed variant.

## Layouts

| Layout | Rows | Toggle | Overflow | When |
| :--- | :--- | :--- | :--- | :--- |
| `toggle` (default) | One | Shown when both lists are provided | One `+N` chip for the visible list | The original layout; the calculator keeps it behind its "Strip layout" preference |
| `twoRows` | Row 1 `aiSuggestions` (the rung that fired) at full size, row 2 `conversionSuggestions` as a secondary row: one `as` tag, then value-only `mini` chips | Never | Each row has its own `+N` chip and expands on its own | The calculator's default (prototype `strip: 'tworow'`) |

In `twoRows` a single non-empty list renders as a single row (no empty shelf), and `onExpandedChanged` reports `true` while **either** row is expanded and `false` once both are collapsed. `secondRowHidden` animates row 2 out over `CoreSuggestionArea.animationDuration` — the same 300 ms as the display area's stage transitions, so the two surfaces move together — and collapses it if it was expanded; with only conversions present and the row hidden, the placeholder shows. Pass `conversionsExpandToggleSemanticsLabelBuilder` and `conversionsCollapseToggleSemanticsLabel` so a screen-reader user hears which row a `+N` control belongs to; without them the conversions row reuses the primary row's labels.

Row 2 follows the calculator prototype's two-row strip (design decision, 2026-09-15): a leading tag — `CoreIcons.ruler` at `space4` in `iconGrayMid` plus `conversionsRowTagLabel` in `bodySmallRegular` — says "conversion" once for the row, and every chip on it is a value-only `CoreChipSize.mini` (the large chip's surface and outline at the medium height, semibold value, no shadow), so the row reads as a quieter echo of the full-size row above. The tag is excluded from semantics; the row is a semantics container labelled `conversionsRowSemanticsLabel`, and each chip still announces its value and unit (or its `semanticsLabel`). Figma differs here: its Suggestion Strip Chip `Conversion` variant (`66225:151222`) is a full 48 px chip labelled `as`, and the older calculator frames (`61933:62752`, `61665:80039`) show 48 px `Conv:` chips built from the generic Smart Chip; the prototype's secondary treatment is what the product owner chose. The `toggle` layout keeps full-size labelled conversion chips behind the ruler side of the switch, as the prototype does.

## Accessibility

The area is a **live region**: its semantics node is labelled with the suggestions on screen (`suggestionsSemanticsLabelBuilder`, default `Area: 220 ft², Cost: $84.25`), so a screen reader announces a new rung or a fresh set of conversions without moving focus. Each chip keeps its own node inside the region, the conversions row keeps its `conversionsRowSemanticsLabel` group, and the placeholder is a live region of its own, so an emptied strip is heard too. Expanding or collapsing a row does not change the text, so the `+N` control is silent beyond its own label.

## Test keys

Every chip carries a stable `Key`, so a Patrol journey or a widget test taps it with `find.byKey`: `SuggestionData.testKey`, or by position in its row — `calc_strip_chip_<index>` on the primary row (and the single row of `toggle`, whichever list the switch shows), `calc_strip_conversion_<index>` on the conversions row of `twoRows`, so the two rows never share a key. The chip's element identity is unchanged: the label / value / unit / kind / index key that keeps a chip's tap highlight bound to its data sits on a `KeyedSubtree` around the chip, and the test key on the chip itself. The keyboard's keys (`calc_key_<enum name>` / `calc_key_<id>`) and the display area's pills (`calc_dep_pill_<index>`) follow the same scheme.

## Features

- **Dynamic Toggling** (`toggle` layout): If both `aiSuggestions` and `conversionSuggestions` are provided, a leading toggle button (icon slider) automatically appears to allow users to switch between the two lists.
- **Overflow Management**: Chips overflow into a hidden trailing "Toggle" button. Tapping this button expands the area and allows vertical scrolling if there are many suggestions. In `twoRows` each row overflows independently.
- **Auto-collapse**: If the suggestions (or the layout) update from underneath while expanded, the area automatically collapses back to its default horizontal list state.
- **Fallback State**: Displays a clean, themed placeholder text string if there are no smart chips available to show yet.

## Examples

### Empty State (Placeholder)
```dart
CoreSuggestionArea(
  hiddenChipsTextBuilder: (count) => '+$count',
  expandToggleSemanticsLabelBuilder: (count) => 'Show $count more',
  collapseToggleSemanticsLabel: 'Collapse',
  toggleSemanticsLabel: 'Toggle suggestion mode',
)
```

### AI Mode Only (No Toggle)
If only `aiSuggestions` are provided, the toggle button is hidden.
```dart
CoreSuggestionArea(
  aiSuggestions: [
    SuggestionData(label: 'AI:', value: '42', unit: 'ft', onTap: () {}),
  ],
  hiddenChipsTextBuilder: (count) => '+$count',
  expandToggleSemanticsLabelBuilder: (count) => 'Expand',
  collapseToggleSemanticsLabel: 'Collapse',
  toggleSemanticsLabel: 'Toggle suggestion mode',
)
```

### Two rows
```dart
CoreSuggestionArea(
  layout: CoreSuggestionLayout.twoRows,
  secondRowHidden: dependentKeys.isNotEmpty, // hand the band back to the pills
  aiSuggestions: [
    SuggestionData(label: 'Area:', value: '410.67', unit: 'ft²', kind: SuggestionKind.deterministic, onTap: () {}),
    SuggestionData(label: 'Cost:', value: '\$84.25', kind: SuggestionKind.predictive, onTap: () {}),
  ],
  conversionSuggestions: [
    SuggestionData(label: 'Conv:', value: '264', unit: 'in', kind: SuggestionKind.conversion, onTap: () {}),
    SuggestionData(label: 'Conv:', value: '7.33', unit: 'yd', kind: SuggestionKind.conversion, onTap: () {}),
  ],
  hiddenChipsTextBuilder: (count) => '+$count',
  expandToggleSemanticsLabelBuilder: (count) => 'Show $count more',
  collapseToggleSemanticsLabel: 'Collapse',
  conversionsExpandToggleSemanticsLabelBuilder: (count) => 'Show $count more conversions',
  conversionsCollapseToggleSemanticsLabel: 'Collapse conversions',
  conversionsRowTagLabel: 'as',                              // row 2 reads: [ruler] as  264in  7.33yd
  conversionsRowSemanticsLabel: 'Convert to other units',
  toggleSemanticsLabel: 'Toggle suggestion mode',
)
```

### Bind offer
An orphan `8ft` typed next to a named Length is never consumed silently — the strip proposes the binding, and accepting it names the chip.
```dart
CoreSuggestionArea(
  aiSuggestions: [
    SuggestionData(
      label: 'Height:',
      value: '8ft',
      kind: SuggestionKind.bind,
      semanticsLabel: 'Name 8 feet as height',
      onTap: () => bloc.add(BindAccepted('Height')),
    ),
  ],
  hiddenChipsTextBuilder: (count) => '+$count',
  expandToggleSemanticsLabelBuilder: (count) => 'Expand',
  collapseToggleSemanticsLabel: 'Collapse',
  toggleSemanticsLabel: 'Toggle suggestion mode',
)
```
