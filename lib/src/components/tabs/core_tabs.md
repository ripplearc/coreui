# CoreTabs Component

A horizontal tab bar component following the Core design system. Displays a list of selectable tabs with an indicator
highlighting the currently selected tab.

## Usage

CoreTabs is intended to be used together with TabBarView and requires a DefaultTabController in the widget tree.

```dart
class TabsExample extends StatefulWidget {
  const TabsExample({super.key});

  @override
  State<TabsExample> createState() => _TabsExampleState();
}

class _TabsExampleState extends State<TabsExample> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CoreTabs(
          tabs: ['Tab 1', 'Tab 2', 'Tab 3'],
          selectedIndex: selectedIndex,
          onChanged: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
        const SizedBox(height: 16),
        Expanded(
          child: IndexedStack(
            index: selectedIndex,
            children: const [
              Center(child: Text('Tab 1 Content')),
              Center(child: Text('Tab 2 Content')),
              Center(child: Text('Tab 3 Content')),
            ],
          ),
        ),
      ],
    );
  }
}
```

## Properties

| Property       | Type                 | Required | Default | Description                                    |
|----------------|----------------------|----------|---------|------------------------------------------------|
| `tabs`         | `List<String>`       | Yes      | -       | The list of tab labels to display              |
| `initialIndex` | `int`                | No       | `0`     | The index of the initially selected tab        |
| `onChanged`    | `ValueChanged<int>?` | No       | `null`  | Callback when the user selects a different tab |

## Features

### Horizontal Scrolling

The tabs are horizontally scrollable when they exceed the available width, making it suitable for any number of tabs.

### Tab Indicator

The currently selected tab is highlighted with an indicator line using the `tabsHighlight` color from the theme.

### Typography

- Selected tab: `bodyMediumSemiBold` with `textHeadline` color
- Unselected tab: `bodyMediumRegular` with `textBody` color

### Dynamic Updates

The component handles dynamic tab list changes gracefully, recreating the internal `TabController` when the number of
tabs changes.

## Examples

### Two Tabs

```dart
CoreTabs
(
tabs: ['Overview', 'Details'],
)
```

### With Initial Selection

```dart
CoreTabs
(
tabs: ['Home', 'Profile', 'Settings'],
initialIndex: 1,
)
```

### With Change Handler

```dart
CoreTabs
(
tabs: ['All', 'Active', 'Completed'],
onChanged: (index) {
setState(() {
selectedIndex = index;
});
},
)
```

### Many Tabs (Scrollable)

```dart
CoreTabs(
  tabs: ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4', 'Tab 5'],
  selectedIndex : 0,
)
```

## Design System Integration

The component uses theme extensions for consistent styling:

```dart

final colors = AppColorsExtension.of(context);
final typography = AppTypographyExtension.of(context);
```

### Colors Used

- `colors.tabsHighlight` - Tab indicator color
- `colors.textHeadline` - Selected tab text color
- `colors.textBody` - Unselected tab text color

### Spacing

- Tab height: `CoreSpacing.space10` (40px)
- Horizontal padding: `CoreSpacing.space3` (12px)
- Indicator weight: `CoreSpacing.space1` (4px)

## Accessibility

The component uses Flutter's built-in `TabBar` which provides:

- Keyboard navigation between tabs
- Screen reader support with tab labels
- Focus indicators for accessibility

