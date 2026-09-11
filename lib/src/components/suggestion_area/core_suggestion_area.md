# CoreSuggestionArea

A specialized widget that provides a dedicated area for presenting smart recommendations to the user, including AI-driven insights (e.g. Area calculation) and contextual unit conversions. It elegantly handles overflow and expands into a scrollable list. Two layouts: the original single row with an AI / conversion **toggle**, and the calculator's **two rows** where the primary row and the conversions row are visible together and overflow independently. Each suggestion carries a `SuggestionKind`; a **bind** offer renders with a dashed outline and a trailing `?` because accepting it relabels an existing chip instead of adding a result.

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
| `conversionSuggestions` | `List<SuggestionData>?` | No | `null` | The list of conversion metrics to display (e.g. feet to inches). |
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

### SuggestionData

| Property | Type | Required | Default | Description |
| :--- | :--- | :--- | :--- | :--- |
| `label` | `String` | Yes | - | The display label of the chip (e.g. `'Area:'`). |
| `value` | `String` | Yes | - | The value shown after the label. |
| `unit` | `String?` | No | `null` | Optional unit shown after the value in heavy weight. |
| `onTap` | `VoidCallback` | Yes | - | Called when the chip is accepted. |
| `kind` | `SuggestionKind` | No | `predictive` | Which suggestion source produced the chip: `deterministic`, `predictive`, `bind`, `conversion`. |
| `semanticsLabel` | `String?` | No | `null` | Overrides the announced text when the visible text does not read well aloud (`'12.57yd²'` → "Convert to 12.57 square yards"). |

## Suggestion kinds

| Kind | Meaning | Accepting it | Look |
| :--- | :--- | :--- | :--- |
| `deterministic` | A rule fired from named dimensions (Area from Length × Width). | Adds a result. | Solid |
| `predictive` | A context proposal (material count, cost, weight, recent value). | Adds a result. | Solid |
| `bind` | An offer to name an orphan value (`Height: 8ft ?`). | Relabels the existing chip instead of adding one. | Dashed `outlineFocus` outline on `backgroundBlueLight` + trailing `bindSuffix` |
| `conversion` | The value on screen re-expressed in another unit. | Replaces the value in place. | Solid |

Only `bind` changes how the chip looks; the other kinds exist so the app can attach the right accept behaviour without re-deriving it from the label text. The dashed look is `CoreChip`'s `CoreChipOutline.dashed`, which reuses `CoreDashedBorderDecoration` from `CoreCalculatorChip`'s dashed variant.

## Layouts

| Layout | Rows | Toggle | Overflow | When |
| :--- | :--- | :--- | :--- | :--- |
| `toggle` (default) | One | Shown when both lists are provided | One `+N` chip for the visible list | The original layout; the calculator keeps it behind its "Strip layout" preference |
| `twoRows` | Row 1 `aiSuggestions` (the rung that fired), row 2 `conversionSuggestions` | Never | Each row has its own `+N` chip and expands on its own | The calculator's default (prototype `strip: 'tworow'`) |

In `twoRows` a single non-empty list renders as a single row (no empty shelf), and `onExpandedChanged` reports `true` while **either** row is expanded and `false` once both are collapsed. `secondRowHidden` animates row 2 out over `CoreSuggestionArea.animationDuration` — the same 300 ms as the display area's stage transitions, so the two surfaces move together — and collapses it if it was expanded; with only conversions present and the row hidden, the placeholder shows. Pass `conversionsExpandToggleSemanticsLabelBuilder` and `conversionsCollapseToggleSemanticsLabel` so a screen-reader user hears which row a `+N` control belongs to; without them the conversions row reuses the primary row's labels.

Row 2 follows the Figma calculator frames (`61933:62752`, `61665:80039`): standard 48 px chips, each prefixed `Conv:`, with no leading row icon. The prototype instead renders row 2 as value-only mini chips behind a single "as" tag; that treatment is not in Figma, so adopting it is a design decision rather than a follow-up of this component.

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
