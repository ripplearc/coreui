# CoreMultiSelectSheet Component

`CoreMultiSelectSheet` is a modal bottom sheet body for selecting multiple values from a searchable list of `{id, label}` items. The sheet owns no external state: the caller supplies the (already filtered) list and reacts to search and apply callbacks. Present it with `CoreQuickSheet.show(context: context, child: ...)`.

## Usage

```dart
CoreQuickSheet.show<void>(
  context: context,
  child: CoreMultiSelectSheet(
    title: 'Tags',
    searchHint: 'Search by tag name',
    emptyLabel: 'No tags found.',
    initialSelectedIds: selectedIds,
    listData: CoreMultiSelectListData(isLoading: false, items: visibleItems),
    onSearchQueryChanged: (query) => filterItems(query),
    onApply: (ids) => setState(() => selectedIds = ids),
  ),
);
```

## Properties

| Property               | Type                          | Required | Description                                                                 |
|------------------------|-------------------------------|----------|-----------------------------------------------------------------------------|
| `title`                | `String`                      | Yes      | Title shown at the top of the sheet.                                        |
| `searchHint`           | `String`                      | Yes      | Hint text for the search field.                                             |
| `emptyLabel`           | `String`                      | Yes      | Label shown when `listData.items` is empty.                                 |
| `initialSelectedIds`   | `Set<String>`                 | Yes      | Ids of the items already selected when the sheet opens.                     |
| `listData`             | `CoreMultiSelectListData?`    | Yes      | Loading flag + available items; `null` renders no list area at all.         |
| `onSearchQueryChanged` | `ValueChanged<String>`        | Yes      | Called with the new query as the user types.                                |
| `onApply`              | `ValueChanged<Set<String>>`   | Yes      | Called with the selected ids on Apply; the sheet pops itself afterwards.    |
| `clearAllLabel`        | `String`                      | No       | Clear all button label. Defaults to `'Clear all'`.                          |
| `applyLabel`           | `String`                      | No       | Apply button label. Defaults to `'Apply'`.                                  |
| `loadingIndicatorKey`  | `Key?`                        | No       | Key applied to the loading indicator, for widget-test finders.              |
| `emptyLabelKey`        | `Key?`                        | No       | Key applied to the empty-list label.                                        |
| `itemKeyOf`            | `Key Function(String id)?`    | No       | Builds the key for the row of the item with the given id.                   |
| `clearAllButtonKey`    | `Key?`                        | No       | Key applied to the Clear all button.                                        |
| `applyButtonKey`       | `Key?`                        | No       | Key applied to the Apply button.                                            |

## Supporting types

- `CoreMultiSelectItem` — one selectable row: a stable `id` used to track selection and a user-facing `label`.
- `CoreMultiSelectListData` — the list portion of the sheet: `isLoading` and the (already filtered) `items`.

## Behavior

- Selection is kept local until the user taps Apply, at which point `onApply` receives an unmodifiable set of selected ids and the sheet pops itself.
- Clear all deselects every item without dismissing the sheet.
- The caller performs the actual filtering: `onSearchQueryChanged` reports the query and the caller rebuilds the sheet with new `listData`.
- `listData.isLoading` renders a centered `CoreLoadingIndicator`; an empty `items` list renders `emptyLabel`; a `null` `listData` renders the title, search field, and buttons with no list area, for callers whose state cannot provide a list yet.
- The item list is capped in height and scrolls internally so the title, search field, and action buttons stay visible.

## Accessibility

Each row is a `CheckboxListTile` with a text label, and the Clear all/Apply actions are full-width `CoreButton`s, meeting tap-target and label guidelines in both light and dark themes. All user-visible strings are constructor parameters for localization.
