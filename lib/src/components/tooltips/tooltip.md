# Tooltip Component

The Tooltip component provides contextual information when users hover over or tap on elements. It supports multiple
positioning options with arrows pointing towards the target widget, following the Core UI design system.

## Usage

### Basic Tooltip (Without Arrow)

```dart
// Tooltip without arrow, positioned above the child
CoreTooltip.none(
  message: 'This is a tooltip without arrow',
  child: Icon(Icons.info),
)
```

### Positioned Tooltips with Arrows

Use named constructors for intuitive positioning. The constructor name indicates where the tooltip appears relative to
the child, and the arrow automatically points towards the child.

```dart
// Tooltip positioned ABOVE the child with arrow pointing DOWN
CoreTooltip.top(
  message: 'Tooltip above',
  child: Icon(Icons.help),
)

// Tooltip positioned BELOW the child with arrow pointing UP
CoreTooltip.bottom(
  message: 'Tooltip below',
  child: Icon(Icons.help),
)

// Tooltip positioned LEFT of the child with arrow pointing RIGHT
CoreTooltip.left(
  message: 'Tooltip left',
  child: Icon(Icons.help),
)

// Tooltip positioned RIGHT of the child with arrow pointing LEFT
CoreTooltip.right(
  message: 'Tooltip right',
  child: Icon(Icons.help),
)
```

### Using the Default Constructor

For advanced use cases, you can use the default constructor with the `arrowPosition` parameter:

```dart
CoreTooltip(
  message: 'Custom tooltip',
  arrowPosition: TooltipArrowPosition.bottom,
  child: Icon(Icons.help),
)
```

## Properties

### Required Properties

| Property  | Type     | Description                                |
|-----------|----------|--------------------------------------------|
| `message` | `String` | The text content to display in the tooltip |
| `child`   | `Widget` | The widget that triggers the tooltip       |

### Optional Properties

| Property        | Type                   | Default | Description                                                     |
|-----------------|------------------------|---------|-----------------------------------------------------------------|
| `arrowPosition` | `TooltipArrowPosition` | `none`  | Direction the arrow points (only used with default constructor) |

## Named Constructors

### CoreTooltip.top()

Tooltip positioned **above** the child with arrow pointing **down**.

```dart
CoreTooltip.top(
  message: 'Help text',
  child: Icon(Icons.info),
)
```

### CoreTooltip.bottom()

Tooltip positioned **below** the child with arrow pointing **up**.

```dart
CoreTooltip.bottom(
  message: 'Help text',
  child: Icon(Icons.info),
)
```

### CoreTooltip.left()

Tooltip positioned **left** of the child with arrow pointing **right**.

```dart
CoreTooltip.left(
  message: 'Help text',
  child: Icon(Icons.info),
)
```

### CoreTooltip.right()

Tooltip positioned **right** of the child with arrow pointing **left**.

```dart
CoreTooltip.right(
  message: 'Help text',
  child: Icon(Icons.info),
)
```

### CoreTooltip.none()

Tooltip **without arrow**, positioned **above** the child.

```dart
CoreTooltip.none(
  message: 'Help text',
  child: Icon(Icons.info),
)
```

## Arrow Positions

The `TooltipArrowPosition` enum controls arrow direction (used with default constructor):

- **`top`**: Arrow points UP (tooltip below)
- **`bottom`**: Arrow points DOWN (tooltip above)
- **`left`**: Arrow points LEFT (tooltip right)
- **`right`**: Arrow points RIGHT (tooltip left)
- **`none`**: No arrow, positioned above

## Behavior

- **Tap to Show/Hide**: On mobile and desktop, tap the child widget to show the tooltip
- **Tap Overlay to Hide**: Tap anywhere on the overlay to hide the tooltip
- **Animation**: Smooth fade-in/out animation (150ms duration)
- **Positioning**: Tooltip is positioned relative to the child with proper spacing (10px gap)
- **Arrow Direction**: Arrow automatically points towards the child widget

## Design System Integration

The tooltip component follows the Core UI design system:

- **Colors**: Uses `CoreTextColors.inverse` for text and `CoreBackgroundColors.backgroundDarkGray` for background
- **Typography**: Uses `CoreTypography.bodySmallRegular()` for text
- **Spacing**: Uses `CoreSpacing` values for consistent padding and margins
- **Border Radius**: Uses `CoreSpacing.space1` for rounded corners

## Styling

The tooltip has a fixed dark gray background with white text and rounded corners. The arrow is rendered as a custom
painted triangle that matches the background color.

```dart
// Tooltip styling (fixed)
Container(
  padding: EdgeInsets.symmetric(
    vertical: CoreSpacing.space1,
    horizontal: CoreSpacing.space2,
  ),
  decoration: BoxDecoration(
    color: CoreBackgroundColors.backgroundDarkGray,
    borderRadius: BorderRadius.circular(CoreSpacing.space1),
  ),
  child: Text(
    message,
    style: CoreTypography.bodySmallRegular(
      color: CoreTextColors.inverse,
    ),
  ),
)
```

## Examples

See the tooltip showcase screen in the example app for interactive demonstrations of all positioning options and use
cases.
