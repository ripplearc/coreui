# CoreSuggestionArea

A specialized widget that provides a dedicated area for presenting smart recommendations to the user, including AI-driven insights (e.g. Area calculation) and contextual unit conversions. It elegantly handles overflow, expands into a scrollable list, and toggles between multiple sets of suggestions.

## Usage

```dart
CoreSuggestionArea(
  aiSuggestions: [
    SuggestionData(label: 'Area:', value: '90', unit: 'sq ft', onTap: () {}),
  ],
  conversionSuggestions: [
    SuggestionData(label: 'Conv:', value: '1080', unit: 'in', onTap: () {}),
  ],
  suggestionAreaPlaceholder: 'Here you can see smart suggestions from us',
  hiddenChipsTextBuilder: (count) => '+$count',
  expandToggleSemanticsLabelBuilder: (count) => 'Show $count more suggestions',
  collapseToggleSemanticsLabel: 'Collapse suggestions',
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
)
```
