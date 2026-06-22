# CoreGeometryArea

A robust, multi-faceted component used to display geometry properties, configurable sizes, and relevant attachments. `CoreGeometryArea` is built for complex calculation screens where a user needs to quickly reference calculated dimensions, manage a list of specific size measurements, and access associated media or documents.

## Overview

`CoreGeometryArea` provides an interactive, stateful interface designed to sit above or alongside a software keyboard. It is split into logical vertical sections: Dimensions, Sizes Table, and Attachments. The component supports an expandable/collapsible state to manage screen real estate effectively.

### Key Features
- **Expandable Dimensions**: The top section displays high-level calculated metrics (e.g., Area, Diameter, Radius) passing through `CoreDimensionData`. An expand/collapse toggle controls visibility of the underlying data table and attachments.
- **Interactive Sizes Table**: Renders an organized list of `CoreSizeCardData` entries. Fully supports user-driven gestures:
  - **Drag-and-Drop Reordering**: Users can long-press and drag cards to reorder them (`onSizesReordered`).
  - **Swipe-to-Delete**: Swipe gestures easily dismiss entries (`onSizeDeleted`).
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
  sizesTitleLabel: 'Concrete volumes for 70ft',
  addSizeLabel: 'Add size',
  editSizeLabel: 'Edit size',
  attachmentsTitleLabel: 'Attachments',
  viewAllAttachmentsLabel: 'View all',
  mediaButtonLabel: 'Media',
  documentButtonLabel: 'Document',
  
  dimensions: const [
    CoreDimensionData(label: 'Area', value: '50.27ft²'),
    CoreDimensionData(label: 'Diameter', value: '8ft'),
  ],
  sizesTableTitles: const [
    'Rails /section',
    'O.C.',
    'No. of posts',
    'No. of rails',
  ],
  sizesTableData: const [
    CoreSizeCardData(id: '1', values: ['2', '6', '14', '26']),
    CoreSizeCardData(id: '2', values: ['3', '6', '14', '39']),
  ],
  

  onSizesReordered: (oldIndex, newIndex) {
    // Dispatch reorder event to BLoC
  },
  onSizeDeleted: (id) {
    // Dispatch delete event to BLoC
  },
  onSizeSaved: (result) {
    // Handle form submission for a new size
  },
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

- **Collapsing**: When `isCollapsed` is true, the GeometryArea hides the sizes table and attachments section, leaving only the primary dimensions summary visible. A visual indicator (arrow icon) animates to reflect the state.
- **Drag Reordering**: Powered by `ReorderableListView`. When a card is dragged, it elevates visually (shadow & border). `onSizesReordered` provides standard `oldIndex` and `newIndex` integers to sync backend state.
- **Swipe Deletion**: Utilizing `Dismissible`, cards can be swiped horizontally. Triggering a full swipe fires `onSizeDeleted` passing the unique string ID.

---

## API Reference

### Layout & Text Properties
| Property | Type | Default         | Description |
| :--- | :--- |:----------------| :--- |
| `isCollapsed` | `bool` | `false`         | When true, hides the sizes table and attachments section. |
| `dimensionsLabel` | `String` | `'Dimensions'`  | Title for the top dimensions summary section. |
| `expandLabel` | `String` | `'Expand'`      | Semantic label applied to the expand/collapse toggle icon. |
| `sizesTitleLabel` | `String` | `'Sizes'`       | The header title for the table section. |
| `addSizeLabel` | `String` | `'Add size'`    | Text applied to the floating Add button semantics and tooltips. |
| `editSizeLabel` | `String` | `'Edit size'`   | Text used contextually during size editing. |
| `attachmentsTitleLabel` | `String` | `'Attachments'` | Header text for the attachments block. |
| `viewAllAttachmentsLabel` | `String` | `'View all'`    | Action text to view all attachments. |
| `mediaButtonLabel` | `String` | `'Media'`       | Text inside the Media attachment button. |
| `documentButtonLabel` | `String` | `'Document'`    | Text inside the Document attachment button. |

### Data Properties
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `dimensions` | `List<CoreDimensionData>` | `[]` | Top-level summary pairs (e.g. Area, Radius). |
| `sizesTableTitles` | `List<String>` | `[]` | Headers for the table columns. |
| `sizesTableData` | `List<CoreSizeCardData>` | `[]` | Ordered list of size rows. Identifiers must be unique to support reliable reordering. |

### Callbacks
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `onSizesReordered` | `void Function(int, int)?` | `null` | Invoked on completion of a drag-to-reorder gesture. |
| `onSizeDeleted` | `void Function(String)?` | `null` | Fired when a swipe-to-delete gesture completes. Receives the `id` of the deleted item. |
| `onSizeSaved` | `void Function(SizeEntryResult)?` | `null` | Triggered when saving modifications or new sizes. |
| `onViewAllAttachmentsPressed` | `VoidCallback?` | `null` | If provided, displays the "View all" action. |
| `onMediaButtonPressed` | `VoidCallback?` | `null` | If provided, renders the Media button. Omit to hide it. |
| `onDocumentButtonPressed` | `VoidCallback?` | `null` | If provided, renders the Document button. Omit to hide it. |

---

## Accessibility

`CoreGeometryArea` is built with a11y as a primary consideration:
- **Semantic Grouping**: The widget hierarchy explicitly merges and announces logical groups of data (e.g. Dimensions lists) so screen readers present them cohesively.
- **Interactive Semantics**: The toggle, view all text, and add buttons specify `button: true` semantics, ensuring talkback accurately announces their interaction capability.
- **Action Exclusions**: Purely visual decorative elements like the expand chevron explicitly declare `excludeFromSemantics: true` to minimize auditory clutter.
