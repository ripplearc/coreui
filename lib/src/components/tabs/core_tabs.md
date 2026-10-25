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
| `selectedIndex` | `int`                | No       | `0`     | The index of the initially selected tab        |
| `onChanged`    | `ValueChanged<int>?` | No       | `null`  | Callback when the user selects a different tab |

## Features

### Horizontal Scrolling

The tabs are horizontally scrollable when they exceed the available width, making it suitable for any number of tabs.

### Tab Indicator

The currently selected tab is highlighted with a 4px indicator line in `tabsHighlight`, with square ends. It sits inside
the bottom of the 40px tab and is as wide as the tab, not the 4px gap after it.

### Bottom Line and Gap

A 1px `lineDarkOutline` line runs under the tabs. A 4px gap follows every tab, including the last, so the line runs
4px past the last tab.

### Press and Focus

A pressed tab fills its 40px face with `backgroundGrayMid`, the library's Press state. The selected tab keeps its
indicator while pressed. When Tab moves keyboard focus to a tab, a 2px `outlineFocus` ring is drawn on the face.
Neither look covers the 8px of tap area above the face or the 4px gap, and a touch tap draws no ring. The tabs carry
their own `Material`, so both looks also show inside a coloured `Container`. `CoreTabs.tabKey(index)` finds a tab's
face in tests.

### Typography

- Selected tab: `bodyMediumSemiBold` with `textHeadline` color
- Unselected tab: `bodyMediumRegular` with `textBody` color

### Dynamic Updates

The component handles dynamic tab list changes gracefully, recreating the internal TabController when the tab list changes (including label-only changes with the same count).

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
selectedIndex: 1,
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
- `colors.lineDarkOutline` - Bottom line color
- `colors.textHeadline` - Selected tab text color
- `colors.textBody` - Unselected tab text color
- `colors.backgroundGrayMid` - Pressed tab fill
- `colors.outlineFocus` - Focus ring

### Spacing

- Tab height: `CoreSpacing.space10` (40px), drawn at the bottom of a `CoreSpacing.space12` (48px) tap area
- Horizontal padding: `CoreSpacing.space3` (12px)
- Gap after each tab: `CoreSpacing.space1` (4px)
- Indicator: `CoreSpacing.space1` (4px) high, inside the tab

## Accessibility

The component uses Flutter's built-in `TabBar` which provides:

- Keyboard navigation between tabs
- Screen reader support with tab labels
- A 2px `outlineFocus` ring on the tab that has keyboard focus

