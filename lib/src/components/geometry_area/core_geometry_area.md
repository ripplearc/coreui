# CoreGeometryArea

A robust, multi-faceted component used to display geometry properties, configurable sizes, and relevant attachments. `CoreGeometryArea` is built for complex calculation screens where a user needs to quickly reference calculated dimensions, manage a list of specific size measurements, and access associated media or documents.

## Overview

`CoreGeometryArea` provides an interactive, stateful interface designed to sit above or alongside a software keyboard. It is split into logical vertical sections: Dimensions, Sizes Table, and Attachments. The component supports an expandable/collapsible state to manage screen real estate effectively.

### Key Features
- **Expandable Dimensions**: The top section displays high-level calculated metrics (e.g., Area, Diameter, Radius) passing through `CoreDimensionData`. An expand/collapse toggle controls visibility of the underlying data table and attachments.
- **Multiple Interactive Tables**: Renders one table per `CoreSizesTableData` entry in `tables`, each with its own title, columns, rows and callbacks. Every callback is optional, and a null callback hides the affordance it drives:
  - **Drag-and-Drop Reordering**: Available only when `onReordered` is provided; otherwise no drag handles render.
  - **Swipe-to-Delete**: Available only when `onDeleted` is provided.
  - **Add**: The add action renders only when `addLabel` is set.

  That lets the same widget express a reorderable, extendable sizes table and a fixed, read-only rates table side by side.
- **Attachments Section**: An integrated section at the bottom to host action buttons for Media, Documents, and a View All callback for external file management.
- **Rich Localization Support**: All user-facing text strings are exposed as configurable parameters rather than being hardcoded, adhering to CoreUI localization standards.

---

## Usage Example

The component pairs seamlessly with state management solutions like `Bloc` to manage the list of sizes and reordering logic.

```dart
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

CoreGeometryArea(
  isCollapsed: false,
  dimensionsLabel: 'Dimensions',
  expandLabel: 'Expand',
  attachmentsTitleLabel: 'Attachments',
  viewAllAttachmentsLabel: 'View all',
  mediaButtonLabel: 'Media',
  documentButtonLabel: 'Document',

  dimensions: const [
    CoreDimensionData(label: 'Area', value: '50.27ft\u00b2'),
    CoreDimensionData(label: 'Diameter', value: '8ft'),
  ],

  tables: [
    // A reorderable, extendable table.
    CoreSizesTableData(
      title: 'Sheet quantities for 180ft\u00b2',
      addLabel: 'Add size',
      editLabel: 'Edit size',
      dragHandleLabel: 'Reorder',
      columns: const [
        CoreSizesColumn(title: 'Size'),
        CoreSizesColumn(title: 'No. of sheet'),
      ],
      rows: const [
        CoreSizeCardData(id: '1', values: ['47.24in x 94.49in', '5.81']),
        CoreSizeCardData(id: '2', values: ['47.24in x 106.3in', '5.16']),
      ],
      onSaved: (result) {
        // Handle add or edit from the entry sheet
      },
      onDeleted: (id) {
        // Dispatch delete event to BLoC
      },
      onReordered: (oldIndex, newIndex) {
        // Dispatch reorder event to BLoC
      },
    ),

    // A fixed table: no callbacks, so no add action, drag handles or
    // swipe-to-delete render.
    const CoreSizesTableData(
      title: 'Rates & waste for 1,750.7yd\u00b3',
      columns: [
        CoreSizesColumn(title: 'Per unit'),
        CoreSizesColumn(title: 'Rate'),
        CoreSizesColumn(title: 'Waste'),
        CoreSizesColumn(title: 'Cost'),
      ],
      rows: [
        CoreSizeCardData(id: 'ft3', values: ['ft\u00b3', r'$6.5', '0%', r'$307,247.85']),
      ],
    ),
  ],

  onViewAllAttachmentsPressed: () {
    // Navigate to full attachments view
  },
  onMediaButtonPressed: () {
    // Open media picker
  },
  onDocumentButtonPressed: () {
    // Open document picker
  },
)
```

---

## Behavior & Interaction Mechanics

- **Collapsing**: When `isCollapsed` is true, the GeometryArea hides the tables and attachments section, leaving only the primary dimensions summary visible. A visual indicator (arrow icon) animates to reflect the state.
- **Drag Reordering**: Powered by `ReorderableListView`, and only when a table supplies `onReordered`. When a card is dragged, it elevates visually (shadow & border); `onReordered` provides standard `oldIndex` and `newIndex` integers to sync backend state. A table without `onReordered` renders a plain column with no drag handles.
- **Swipe Deletion**: Utilizing `Dismissible`, cards can be swiped horizontally when a table supplies `onDeleted`. Triggering a full swipe fires `onDeleted` passing the unique string ID.
- **Adding and editing**: The add action renders when `addLabel` is set. Tapping it calls `onAdd` if provided — the app then owns the flow — and otherwise opens the built-in `SizeEntryBottomSheet`, reporting through `onSaved`. Tapping a row opens the same sheet pre-filled.

---

## API Reference

### Layout & Text Properties
| Property | Type | Default         | Description |
| :--- | :--- |:----------------| :--- |
| `isCollapsed` | `bool` | `true`          | When true, hides the tables and attachments section. |
| `dimensionsLabel` | `String` | `'Dimensions'`  | Title for the top dimensions summary section. |
| `expandLabel` | `String` | `'Expand'`      | Semantic label applied to the expand/collapse toggle icon. |
| `collapseLabel` | `String` | `'Collapse'`    | Semantic label applied to the toggle in its expanded state. |
| `attachmentsTitleLabel` | `String` | `'Attachments'` | Header text for the attachments block. |
| `viewAllAttachmentsLabel` | `String` | `'View all'`    | Action text to view all attachments. |
| `mediaButtonLabel` | `String` | `'Media'`       | Text inside the Media attachment button. |
| `documentButtonLabel` | `String` | `'Document'`    | Text inside the Document attachment button. |

### Data Properties
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `dimensions` | `List<CoreDimensionData>` | `[]` | Top-level summary pairs (e.g. Area, Radius). |
| `tables` | `List<CoreSizesTableData>` | `[]` | The tables rendered below the dimensions section, in display order. A table with no columns is skipped. |

### Callbacks
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `onViewAllAttachmentsPressed` | `VoidCallback?` | `null` | If provided, displays the "View all" action. |
| `onMediaButtonPressed` | `VoidCallback?` | `null` | If provided, renders the Media button. Omit to hide it. |
| `onDocumentButtonPressed` | `VoidCallback?` | `null` | If provided, renders the Document button. Omit to hide it. |

### `CoreSizesTableData`
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `title` | `String` | required | The table's header title. Normally interpolates the result it describes, e.g. `'Sheet quantities for 180ft²'`, so it has no default — pass a localised string. |
| `columns` | `List<CoreSizesColumn>` | required | The columns, in display order. Each row must supply one value per column. |
| `rows` | `List<CoreSizeCardData>` | required | Ordered rows. Identifiers must be unique within the table to support reliable reordering. |
| `addLabel` | `String?` | `null` | Text for the add action. The action renders only when this is set. |
| `editLabel` | `String?` | `null` | Title shown by the entry sheet when editing an existing row. |
| `dragHandleLabel` | `String?` | `null` | Semantic label announced for this table's drag handles. |
| `onAdd` | `VoidCallback?` | `null` | If provided, the app owns the add flow and the built-in entry sheet is not opened. |
| `onSaved` | `void Function(SizeEntryResult)?` | `null` | Fired when a row is saved from the built-in entry sheet. |
| `onDeleted` | `void Function(String)?` | `null` | Fired when a row is deleted, passing its `id`. When null the row cannot be swiped away. |
| `onReordered` | `void Function(int, int)?` | `null` | Fired on completion of a drag-to-reorder gesture. When null no drag handles render. |

### `CoreSizesColumn`
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `title` | `String` | required | The header text displayed above this column. |

---

## Accessibility

`CoreGeometryArea` is built with a11y as a primary consideration:
- **Semantic Grouping**: The widget hierarchy explicitly merges and announces logical groups of data (e.g. Dimensions lists) so screen readers present them cohesively.
- **Interactive Semantics**: The toggle, view all text, and add buttons specify `button: true` semantics, ensuring talkback accurately announces their interaction capability.
- **Action Exclusions**: Purely visual decorative elements like the expand chevron explicitly declare `excludeFromSemantics: true` to minimize auditory clutter.
