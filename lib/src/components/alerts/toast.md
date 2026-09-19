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
  onAction: () {},
  secondaryLabel: 'View', // Optional, travels with onSecondary
  onSecondary: () {},
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
| `secondaryLabel` | `String?`       | No       | The quieter second action — "View". Travels with `onSecondary` |
| `onSecondary`    | `VoidCallback?` | No       | Fires when the second action is tapped. Answers the toast the same way `onAction` does — whichever is tapped first wins, and the other is locked out |
| `onClose`        | `VoidCallback?` | No       | The single dismissal path: fires once, either when `duration` elapses or when an action answers the toast, so the caller can remove it |
| `duration`       | `Duration?`     | No       | Auto-dismiss delay, 5 s by default. `null` keeps the toast until the caller removes it |

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
banked: "**Saved to history** · Calc 60ft²" with `Undo`, and optionally `View`.
It differs from the other four variants in shape as well as content — one line
of text rather than a stacked title and description, an outlined surface rather
than a flat tinted one, actions instead of a close button.

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

## Accessibility

The Toast component includes semantic labels for accessibility:

- The entire toast is marked as a container
- The close button is marked as a button
- The title (if present) is used as the primary label
- The description is used as a hint when a title is present
- The close button has its own semantic label
- A receipt's lead and highlight are read as one label ("Saved to history · Calc 60ft²")
- Both actions stand 48 dp tall, the Android tap-target minimum. The design draws
  the `Undo` pill at ~29 dp; it is rendered at 48 dp instead, because a tap target
  under 48 dp is an accessibility defect. Worth confirming with design.
- `secondaryLabel` and `onSecondary` are asserted to travel together: an
  interactive control with no label is invisible to a screen reader
  `androidTapTargetGuideline` does not fire on `CoreButton`'s semantics node at
  all, so the height is asserted directly rather than assumed covered by it

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
    - Receipt secondary label: `CoreTypography.bodyLargeRegular` in `textLink` at 75 % opacity
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
  secondaryLabel: 'View',
  onSecondary: controller.openHistory,
);
```

The widget owns the timer, so `CoreToast` starts none of its own — a second
timer could only disagree with it. `CoreToast.disableTimers()` still holds a
receipt on screen, and `cleanup()` is safe to call at any point: the entry is
removed exactly once whichever path gets there first.

## Design source

The receipt variant follows `designs/CA-1042/01-receipt-toast.png`
(Construculator Calculator UX Design Doc v1.0, §1.7 Toasts), not the CA-1042
ticket text, which describes a single link-styled action beside a close button.
The design's border (`#9ADCF5`) has no exact token; `lineHighlight` is the
closest the palette offers.
