# Letter Avatar Component

The Letter Avatar component is a widget that displays a WEBP avatar image based on the first letter of a name. It automatically maps the first letter of the provided name (A-Z) to the corresponding letter avatar WEBP file.

## Usage

```dart
// Basic usage with name
CoreLetterAvatar(
  name: 'John',
);

// Full name (uses first letter)
CoreLetterAvatar(
  name: 'Alice Smith',
);

// With custom semantic label
CoreLetterAvatar(
  name: 'Bob',
  semanticLabel: 'User avatar for Bob',
);

// Empty or invalid name (defaults to 'R')
CoreLetterAvatar(
  name: '',
);
```

## Properties

| Property        | Type              | Required | Description                                                                        |
|-----------------|-------------------|----------|------------------------------------------------------------------------------------|
| `name`          | `String`          | Yes      | The name used to determine which letter avatar to display (uses first letter)     |
| `semanticLabel` | `String?`         | No       | Optional semantic label for accessibility. Defaults to "Letter avatar for [name]"  |

## Letter Mapping

The component extracts the first letter from the `name` parameter and maps it to the corresponding WEBP file:

- The first letter is extracted and converted to uppercase
- Letters A-Z map to `A.webp` through `Z.webp` in the `assets/letter_avatars/` directory
- If the name is empty or the first character is not a letter (A-Z), it defaults to `R.webp`
- Non-letter characters (numbers, symbols, etc.) also default to `R.webp`

## Accessibility

The Letter Avatar component includes semantic labels for accessibility:

- The image is marked with a semantic label that defaults to `'Letter avatar for [name]'` where `[name]` is the provided name parameter
- You can provide a custom semantic label using the `semanticLabel` parameter
- The component uses `Image.asset` with proper semantic labeling for screen readers

## Implementation Details

- **Asset Format**: WEBP images
- **Asset Location**: `assets/letter_avatars/` directory within the package
- **Package Assets**: Assets are automatically bundled with the package and work when the package is imported as a dependency
- **Image Loading**: Uses `Image.asset` with `package: 'ripplearc_coreui'` for proper asset resolution

## Examples

```dart
// Display avatar for a user
Column(
  children: [
    CoreLetterAvatar(name: 'Alice'),
    Text('Alice'),
  ],
)

// In a list
ListView.builder(
  itemBuilder: (context, index) {
    final user = users[index];
    return ListTile(
      leading: CoreLetterAvatar(name: user.name),
      title: Text(user.name),
    );
  },
)

// With custom semantic label
CoreLetterAvatar(
  name: 'John Doe',
  semanticLabel: 'Profile picture for John Doe',
)
```
