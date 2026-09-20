# Toast Component

The Toast component is a notification widget that displays temporary messages to users. It supports different types of
notifications (error, warning, info, success) with customizable content and styling.

## Usage

```dart
// Error toast
Toast.error(
  description: 'An error occurred',
  closeLabel: 'Close',
  title: 'Error', // Optional
  onClose: () {}, // Optional
);

// Warning toast
Toast.warning(
  description: 'Warning message',
  closeLabel: 'Close',
);

// Info toast
Toast.info(
  description: 'Information message',
  closeLabel: 'Close',
);

// Success toast
Toast.success(
  description: 'Operation successful',
  closeLabel: 'Close',
);

// Receipt toast — confirms a session was banked and offers Undo
Toast.receipt(
  description: 'Saved to history',
  highlight: 'Calc 60ft²',
  actionLabel: 'Undo',
  onAction: controller.undoBanking,
  onClose: removeTheToast,
);
```

## Properties

### Common Properties (Available in all factory constructors)

| Property      | Type            | Required | Description                                                           |
|---------------|-----------------|----------|-----------------------------------------------------------------------|
| `description` | `String`        | Yes      | The main message to be displayed in the toast                         |
| `closeLabel`  | `String`        | Yes      | The text label for the close button                                   |
| `title`       | `String?`       | No       | Optional title text displayed above the description                   |
| `onClose`     | `VoidCallback?` | No       | Optional callback function triggered when the close button is pressed |

### Toast.receipt Properties

`Toast.receipt` takes no `closeLabel`: it dismisses itself, so it carries no close button.

| Property         | Type            | Required | Description                                                                         |
|------------------|-----------------|----------|-------------------------------------------------------------------------------------|
| `description`    | `String`        | Yes      | The lead, set in the heavier weight — "Saved to history"                            |
| `actionLabel`    | `String`        | Yes      | The primary action's label — "Undo"                                                  |
| `onAction`       | `VoidCallback`  | Yes      | Fires at most once. Answering the toast cancels the auto-dismiss and dismisses it through `onClose` |
| `highlight`      | `String?`       | No       | The tail after a middot, naming what was saved — "Calc 60ft²"                        |
| `onClose`        | `VoidCallback`  | Yes      | The single dismissal path: fires once, either when `duration` elapses or when an action answers the toast. Required, because it is the only way a receipt leaves the screen |
| `duration`       | `Duration?`     | No       | Auto-dismiss delay, 5 s by default. `null` keeps the toast until something else removes it, and so does an active screen reader |

## Factory Constructors

### Toast.error

Creates a toast with error styling (red background and icon).

### Toast.warning

Creates a toast with warning styling (orange background and icon).

### Toast.info

Creates a toast with information styling (blue background and icon).

### Toast.success

Creates a toast with success styling (green background and icon).

### Toast.receipt

Creates the self-dismissing confirmation the calculator shows when a session is
banked: "**Saved to history** · Calc 60ft²" with `Undo`.
It differs from the other four variants in shape as well as content — one line
of text rather than a stacked title and description, an outlined surface rather
than a flat tinted one, an action instead of a close button.

## Visual Properties

Each toast type has specific styling:

- **Error Toast**
    - Background Color: `CoreAlertColors.red`
    - Icon Color: `CoreIconColors.red`
    - Icon: `CoreIcons.error`

- **Warning Toast**
    - Background Color: `CoreAlertColors.orange`
    - Icon Color: `CoreIconColors.orange`
    - Icon: `CoreIcons.warning`

- **Info Toast**
    - Background Color: `CoreAlertColors.blue`
    - Icon Color: `CoreIconColors.blue`
    - Icon: `CoreIcons.info`

- **Success Toast**
    - Background Color: `CoreAlertColors.green`
    - Icon Color: `CoreIconColors.green`
    - Icon: `CoreIcons.success`

- **Receipt Toast**
    - Background Color: `CoreBackgroundColors.backgroundBlueLight`
    - Border: 1 px `CoreBorderColors.lineHighlight`
    - Icon Color: `CoreIconColors.dark`
    - Icon: `CoreIcons.success`
    - No shadow, and a `CoreSpacing.space3` corner radius rather than 8
    - `CoreSpacing.space1` of vertical padding rather than `space3`: the row
      inside is already pinned to the 48 dp tap-target height, which also keeps
      a receipt with a highlight and one without at the same height

## Accessibility

The Toast component includes semantic labels for accessibility:

- The entire toast is marked as a container
- The close button is marked as a button
- The title (if present) is used as the primary label
- The description is used as a hint when a title is present
- The close button has its own semantic label
- A receipt's lead and highlight are read as one label ("Saved to history · Calc 60ft²")
- The action stands 48 dp tall, the Android tap-target minimum. The design draws
  the `Undo` pill at ~29 dp; it is rendered at 48 dp instead, because a tap target
  under 48 dp is an accessibility defect. The 48 dp stays until design updates the
  frame — see **Open with design** below.
  `androidTapTargetGuideline` does not fire on `CoreButton`'s semantics node at
  all, so the height is asserted directly rather than assumed covered by it
- A receipt carries no close button, so its timer is the only way it leaves. When
  `MediaQuery.accessibleNavigationOf` is true the timer does not start at all, the
  way `SnackBar` persists an action for assistive tech: a window a screen-reader
  user cannot reach in time is worse than no window

## Styling

- Padding: Horizontal `CoreSpacing.space4`, Vertical `CoreSpacing.space3`
  (`CoreSpacing.space1` for a receipt, whose actions already stand 48 dp tall)
- Border Radius: 8 pixels
- Shadow: `CoreShadows.medium`
- Icon Size: 24 pixels
- Typography:
    - Title/Description: `CoreTypography.bodyLargeMedium`
    - Description (when title present): `CoreTypography.bodySmallRegular`
    - Close Label: `CoreTypography.bodyMediumSemiBold` 
    - Receipt lead: `CoreTypography.bodyLargeSemiBold` in `textLink`
    - Receipt highlight: `CoreTypography.bodyLargeRegular` in `textLink`
- Receipt action: `CoreButton`, `primary`, `CoreButtonSize.large` (48 dp), not full width

## Showing a receipt through CoreToast

`CoreToast.showReceipt` puts a receipt in the overlay and wires its dismissal:

```dart
CoreToast.showReceipt(
  context,
  'Saved to history',
  'Undo',
  controller.undoBanking,
  highlight: 'Calc 60ft²',
);
```

For a receipt the widget owns the timer, so `CoreToast` starts none of its own —
a second timer could only disagree with it. `showError`, `showSuccess` and
`showWarning` are unchanged: each still gets a 3 s timer from `CoreToast`.
`CoreToast.disableTimers()` still holds a receipt on screen, and `cleanup()` is
safe to call at any point: the entry is removed exactly once whichever path gets
there first.

A new toast of any kind replaces the one on screen — `CoreToast` holds a single
overlay entry — so a receipt can leave before its own window is up.

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `context` | `BuildContext` | Yes | Must be mounted and sit under an `Overlay`. Otherwise this throws a `FlutterError` before anything changes, so a toast already on screen is undisturbed |
| `message` | `String` | Yes | The lead — "Saved to history" |
| `actionLabel` | `String` | Yes | The action's label — "Undo" |
| `onAction` | `VoidCallback` | Yes | Fires at most once, before the toast is removed |
| `highlight` | `String?` | No | The tail after a middot — "Calc 60ft²" |
| `duration` | `Duration?` | No | 5 s by default, handed to the widget rather than the overlay. `null` leaves the receipt with no timer at all; so does an active screen reader, and so does `disableTimers()` |

With no timer, three things remove a receipt: the user takes the action,
another toast replaces it, or `cleanup()` runs. The caller holds no handle of
its own.

## Design source

The receipt variant follows the **Construculator Calculator UX Design Doc v1.0**,
§1.7 Toasts — with §1.18 and walkthrough 13.2 for the behaviour — not the CA-1042
ticket text, which describes a single link-styled action beside a close button.
The frames live in the Figma file `vugaGpii5HfgEQHPbrS3mU`
("Construculator Visual Design"), the same file the theme tokens are drawn from
(`lib/src/theme/spacing.dart`, `color_tokens.dart`, `shadows.dart`).
PNG extracts of those frames sit at the `ripplearc/` workspace root, deliberately
outside every git repo, so they are not a reference a reader of this repo can
follow and are not cited here.

### Open with design

Neither question blocks the component; both are the designer's call, and the code
holds its current answer until they make it.

- **Border colour.** The design draws `#9ADCF5`. No token is that colour.
  `lineHighlight` (`blue200`, `#6DE3FF`) is used here and is the only border token
  in the blue family, but `blue100` (`#B2EEFF`) is the nearer step — so this is the
  nearest *border token*, not the nearest colour. Choosing `blue100` would mean
  adding a border token for it.
- **Action height.** The frame draws the `Undo` pill at ~29 dp against the 48 dp
  built here. The frame needs updating either way.
