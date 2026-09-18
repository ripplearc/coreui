# CoreValueEditorSheet

A bottom sheet that edits a row of numeric values with a `CoreKeyboard`
mounted beneath the fields — the editor `CoreGeometryArea` opens from a table's
add action or a row's pencil.

One `CoreTextField` per entry in `titles`, laid out two to a line. Commits a
`SizeEntryResult` through the future returned by `show`.

## Usage

```dart
final result = await CoreValueEditorSheet.show(
  context: context,
  titles: const ['Length', 'Width'],
  addSizeTitle: l10n.addSize,
  editSizeTitle: l10n.editSize,
  resultLabel: l10n.update,
  unitOptions: const ['m', 'cm', 'mm'],
  initialData: row,
  initialIndex: index,
);
```

## Behaviour

- **The commit key never names itself.** `resultLabel` is required and reaches
  `CoreKeyboard.customResultLabel` unchanged, so "Add" and "Update" are the
  caller's words and localize with the rest of the app. A custom label renders
  verbatim — sentence case survives, unlike the upper-cased default.
- **The unit row is optional.** `unitOptions` becomes the keyboard's function
  strip, one key per entry, and requires a localized `unitGroupLabel` beside it.
  Pass none and no strip renders, which is what the
  design asks for, and needs a localized `unitGroupLabel` beside it. A unit key
  types its label into the active field: `SizeEntryResult` carries no unit, so
  the value spells it inline as `47.24in` does. The keyboard's own unit column
  (Yards/Feet/Inch) is unaffected either way.
- **Validation blocks the commit.** `validator` runs against every field on
  submit. A non-null return is shown beneath the offending field and the sheet
  stays open. Editing that field clears its message.
- **Focus drives input.** Digits, operators and control actions all land in
  whichever field currently has focus; the first field takes focus on open.
- **Rebuilds are safe.** Changing the length of `titles` on an already-mounted
  sheet resizes the fields, disposing the ones that fall away.

## API Reference

### `CoreValueEditorSheet`

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `titles` | `List<String>` | — | One field label per column. Each renders with a trailing `*`. |
| `addSizeTitle` | `String` | — | Header shown by the multi-column mode when adding. |
| `editSizeTitle` | `String` | — | Header shown by the multi-column mode when editing. |
| `initialData` | `CoreSizeCardData?` | `null` | Pre-fills the multi-column fields. Null means "adding". |
| `initialIndex` | `int?` | `null` | Index of the row being edited, echoed back in `SizeEntryResult`. |
| `resultLabel` | `String` | — | **Required.** The commit key's label, e.g. "Add" or "Update". |
| `unitOptions` | `List<String>?` | `null` | Unit row labels. Null or empty renders no unit row. |
| `unitGroupLabel` | `String?` | `null` | Names the unit row in the keyboard's group header. **Required whenever `unitOptions` is set** (debug assert) — this package ships no user-facing English. |
| `validator` | `String? Function(String)?` | `null` | Returns a message to reject a value and keep the sheet open. |

### `SizeEntryResult`

| Property | Type | Description |
| :--- | :--- | :--- |
| `values` | `List<String>` | One entry per column, in `titles` order. |
| `intent` | `SizeOperationIntent` | `add` when `initialData` was null, otherwise `edit`. |
| `index` | `int?` | The `initialIndex` handed in, for the caller to write back against. |

## Migration

`SizeEntryBottomSheet` is now a deprecated alias for `CoreValueEditorSheet` and
is removed in the next release. Rename the type, and add the newly required
`resultLabel` — previously the commit key silently ignored the label it was
given and always rendered `=`. A sheet with `unitOptions` must also supply a
localized `unitGroupLabel`.

`CoreGeometryArea` callers supply the key's labels through
`CoreSizesTableData.addResultLabel` and `editResultLabel`, which are required
alongside `onSaved`. They are deliberately separate from `addLabel` and
`editLabel`: those title the sheet ("Edit size") while the key reads "Update".
