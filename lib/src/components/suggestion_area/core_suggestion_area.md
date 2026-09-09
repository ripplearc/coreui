# CoreSuggestionArea

A specialized widget that provides a dedicated area for presenting smart recommendations to the user, including AI-driven insights (e.g. Area calculation) and contextual unit conversions. It elegantly handles overflow, expands into a scrollable list, and toggles between multiple sets of suggestions. Each suggestion carries a `SuggestionKind`; a **bind** offer renders with a dashed outline and a trailing `?` because accepting it relabels an existing chip instead of adding a result.

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

## Features

- **Dynamic Toggling**: If both `aiSuggestions` and `conversionSuggestions` are provided, a leading toggle button (icon slider) automatically appears to allow users to switch between the two lists.
- **Overflow Management**: Chips overflow into a hidden trailing "Toggle" button. Tapping this button expands the area and allows vertical scrolling if there are many suggestions.
- **Auto-collapse**: If the suggestions update from underneath while expanded, the area automatically collapses back to its default horizontal list state.
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
