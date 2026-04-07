# CoreWritingDots

A typing indicator widget that displays an animated "writing dots" pattern using a Lottie animation. It is designed to
signal that another participant (e.g. a remote user or an AI assistant) is currently composing a message.

## Usage

```dart
CoreWritingDots

()
CoreWritingDots
(
size
:
CoreSpacing
.
space12
)
```

## Properties

| Property | Type     | Required | Default                     | Description                                         |
|----------|----------|----------|-----------------------------|-----------------------------------------------------|
| `size`   | `double` | No       | `CoreSpacing.space3` (12.0) | The width and height of the writing dots indicator. |

## Examples

### Default

Renders the writing dots animation at the default `CoreSpacing.space3` (12×12) size.

```dart
const CoreWritingDots();
```

### Custom Size

```dart
const CoreWritingDots(size: CoreSpacing.space5);  // chat bubble size (20px)
const CoreWritingDots(size: CoreSpacing.space10); // large – placeholder size (40px)
```

### Chat Bubble Context

The writing dots are often used inside a chat bubble to indicate the other person is typing.

```dart
Container(
  padding: const EdgeInsets.all(CoreSpacing.space3),
  decoration: BoxDecoration(
    color: AppColors.surfaceLight,
    borderRadius: BorderRadius.circular(CoreSpacing.space4),
  ),
  child: const CoreWritingDots(size: CoreSpacing.space5),
)
```

### Activity Feed Item

A compact usage showing the writing dots in a list-like activity indicator.

```dart
Row(
  children: [
    const CoreAvatar(src: 'user_avatar.png'),
    const SizedBox(width: CoreSpacing.space3),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('John Doe', style: AppTypography.titleSmall),
        Row(
          children: [
            const Text('is typing', style: AppTypography.labelSmall),
            const SizedBox(width: CoreSpacing.space1),
            const CoreWritingDots(),
          ],
        ),
      ],
    ),
  ],
)
```

## Accessibility

The widget is wrapped with a `Semantics` node carrying the label **"Writing"**, which allows screen readers to
announce the composing state to visually impaired users.

## Styling

- **Animation asset**: `assets/animations/writing_dots.json` (bundled with `ripplearc_coreui`).
- **Centering**: The animation is always centered within its parent via its internal box model.
- **Sizing**: Both width and height are driven by the single `size` property; the animation is square.
