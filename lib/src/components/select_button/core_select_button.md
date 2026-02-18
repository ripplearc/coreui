# CoreSelectButton

A customizable tab selection component that displays multiple options in a horizontal layout with smooth animations. The
selected tab is highlighted with a distinct background color and shadow effect.

This is a **controlled** widget — the parent is responsible for tracking the selected index and passing it via
`selectedIndex`. When the user taps a tab, `onChanged` is called with the new index, and the parent should update
`selectedIndex` accordingly.

## Usage

```dart
CoreSelectButton(
  tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
  selectedIndex: 0,
  onChanged: (index) {
    setState(() => selectedIndex = index);
  },
)
```

## Properties

| Property        | Type                 | Required | Description                                                              |
|-----------------|----------------------|----------|--------------------------------------------------------------------------|
| `tabs`          | `List<String>`       | Yes      | List of tab labels to display                                            |
| `selectedIndex` | `int`                | Yes      | The index of the currently selected tab (0-based). Must be updated by the parent in response to `onChanged`. |
| `onChanged`     | `ValueChanged<int>?` | No       | Callback function triggered when a tab is tapped                         |
| `key`           | `Key?`               | No       | Optional widget key for testing and identification                       |

## Features

### Tab Selection

- Displays multiple tabs in a horizontal scrollable layout
- Smooth animation when switching between tabs (200ms duration with easeOut curve)
- Visual feedback with highlight color and shadow on selected tab
- Automatic spacing between tabs

### Styling

The component follows the Core UI design system with:

- **Container**: Inverse background color with rounded corners (12px radius)
- **Selected Tab**:
    - Background color: `AppColorsExtension.tabsHighlight`
    - Shadow: `CoreShadows.medium`
    - Text style: `CoreTypography.bodyMediumSemiBold` with headline color
- **Unselected Tab**:
    - Transparent background
    - Text style: `CoreTypography.bodyMediumRegular` with body color
- **Padding**:
    - Container: 8px all around (`CoreSpacing.space2`)
    - Tab: 20px horizontal, 8px vertical
    - Tab spacing: 8px between tabs

### Scrolling

When there are many tabs that don't fit on the screen, the component automatically provides horizontal scrolling
capability through `SingleChildScrollView`.

## Examples

### Basic Usage

```dart
CoreSelectButton(
  tabs: ['All', 'Active', 'Archived'],
  selectedIndex: 0,
  onChanged: (index) {
    setState(() {
      selectedIndex = index;
    });
  },
)
```

### With Many Tabs

```dart
CoreSelectButton(
  tabs: [
    'Overview',
    'Details',
    'Settings',
    'History',
    'Analytics',
    'Reports',
  ],
  selectedIndex: 0,
  onChanged: (index) {
    // Handle tab change
  },
)
```

### Without Callback

```dart
CoreSelectButton(
  tabs: ['Option 1', 'Option 2'],
  selectedIndex: 1,
  // onChanged is optional
)
```

## Behavior

- **Selected State**: The tab at `selectedIndex` is displayed with highlight styling
- **Tab Tap**: When a tab is tapped, the `onChanged` callback is triggered with the tab's index
- **Animation**: Tab selection changes are animated smoothly over 200ms
- **Horizontal Scroll**: If tabs exceed the available width, the component scrolls horizontally
- **Null Safety**: The `onChanged` callback is optional and safely handled with null-coalescing operator

## Accessibility

The component provides:

- Proper touch targets for each tab
- Clear visual distinction between selected and unselected states
- Semantic structure with `Semantics` widget wrapping each tab
- Screen reader support with `label`, `selected`, and `button` semantic properties
- Text labels for each tab option

## Testing

The component includes comprehensive tests:

- Unit tests for rendering, selection, and callbacks
- Golden tests for visual regression testing
- Tests for edge cases (single tab, many tabs, null callbacks)

Run tests with:

```bash
flutter test test/components/select_button/core_select_button_test.dart
flutter test test/components/select_button/core_select_button_golden_test.dart
```

