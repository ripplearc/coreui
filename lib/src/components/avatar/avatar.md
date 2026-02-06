# CoreAvatar Component

The CoreAvatar component is a circular avatar widget that displays an image from an `ImageProvider`. It is designed to replace Flutter's `CircleAvatar` widget and is implemented using a `Container` with a circular `BoxDecoration`.

## Usage

```dart
// Basic usage with NetworkImage
CoreAvatar(
  image: NetworkImage('https://example.com/avatar.jpg'),
  radius: 30,
)

// With AssetImage
CoreAvatar(
  image: AssetImage('assets/avatar.png'),
  radius: 30,
)

// With background color
CoreAvatar(
  image: NetworkImage('https://example.com/avatar.jpg'),
  radius: 30,
  backgroundColor: CoreIconColors.grayLight,
)

// With icon
CoreAvatar(
  radius: 30,
  backgroundColor: CoreIconColors.orient,
  child: Icon(Icons.person, color: CoreIconColors.white),
)
```

## Properties

| Property          | Type                  | Required | Description                                                                                    |
|-------------------|-----------------------|----------|------------------------------------------------------------------------------------------------|
| `image`           | `ImageProvider?`      | No       | The image to display in the avatar. Can be `NetworkImage`, `AssetImage`, `FileImage`, etc.    |
| `radius`          | `double?`             | No*      | The radius of the avatar. The avatar will be a circle with diameter equal to `radius * 2`     |
| `minRadius`       | `double?`             | No*      | The minimum radius of the avatar. Used with `maxRadius` when `radius` is not provided          |
| `maxRadius`       | `double?`             | No*      | The maximum radius of the avatar. Used with `minRadius` when `radius` is not provided          |
| `backgroundColor` | `Color?`              | No       | The background color of the avatar, shown behind the image or child widget                    |
| `child`           | `Widget?`             | No       | A widget to display in the avatar when `image` is not provided. Typically a `Text` or `Icon`   |
| `semanticLabel`   | `String?`             | No       | Optional semantic label for accessibility. Used by screen readers to describe the avatar       |

\* Either `radius` or both `minRadius` and `maxRadius` must be provided.

## Image Support

The component supports any `ImageProvider` type:
- `NetworkImage` - Load images from URLs
- `AssetImage` - Load images from app assets
- `FileImage` - Load images from local files
- `MemoryImage` - Load images from memory
- Any custom `ImageProvider` implementation

## Size Options

You can specify the avatar size in two ways:

1. **Fixed radius**: Use the `radius` parameter for a fixed-size avatar
   ```dart
   CoreAvatar(radius: 30) // 60x60 pixels
   ```

2. **Min/Max radius**: Use `minRadius` and `maxRadius` for a flexible size
   ```dart
   CoreAvatar(minRadius: 20, maxRadius: 30) // Uses average: 50x50 pixels
   ```

## Image Priority

If both `image` and `child` are provided, the `image` takes precedence and the `child` is not displayed.

## Accessibility

The component includes semantic label support for accessibility:

```dart
CoreAvatar(
  image: NetworkImage('https://example.com/avatar.jpg'),
  radius: 30,
  semanticLabel: 'User avatar for John Doe',
)
```

The image is marked with a semantic label that can be customized using the `semanticLabel` parameter. If not provided, you should ensure proper accessibility labeling in your app.

## Implementation Details

- **Shape**: Always circular (uses `BoxShape.circle`)
- **Image Fit**: Images are fitted using `BoxFit.cover` to fill the circular area
- **Container-based**: Implemented using `Container` with `BoxDecoration` as specified
- **Size Calculation**: Avatar size is calculated as `radius * 2` (or average of min/max radius * 2)

## Examples

```dart
// Display avatar for a user
Row(
  children: [
    CoreAvatar(
      image: NetworkImage(user.avatarUrl),
      radius: 30,
      backgroundColor: CoreIconColors.grayLight,
      semanticLabel: 'Avatar for ${user.name}',
    ),
    const SizedBox(width: CoreSpacing.space3),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(user.name),
        Text(user.email),
      ],
    ),
  ],
)

// In a list
ListView.builder(
  itemBuilder: (context, index) {
    final user = users[index];
    return ListTile(
      leading: CoreAvatar(
        image: NetworkImage(user.avatarUrl),
        radius: 20,
      ),
      title: Text(user.name),
      subtitle: Text(user.email),
    );
  },
)

// With custom semantic label
CoreAvatar(
  image: NetworkImage('https://example.com/avatar.jpg'),
  radius: 30,
  semanticLabel: 'Profile picture for John Doe',
)
```
