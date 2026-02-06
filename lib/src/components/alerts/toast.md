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
```

## Properties

### Common Properties (Available in all factory constructors)

| Property      | Type            | Required | Description                                                           |
|---------------|-----------------|----------|-----------------------------------------------------------------------|
| `description` | `String`        | Yes      | The main message to be displayed in the toast                         |
| `closeLabel`  | `String`        | Yes      | The text label for the close button                                   |
| `title`       | `String?`       | No       | Optional title text displayed above the description                   |
| `onClose`     | `VoidCallback?` | No       | Optional callback function triggered when the close button is pressed |

## Factory Constructors

### Toast.error

Creates a toast with error styling (red background and icon).

### Toast.warning

Creates a toast with warning styling (orange background and icon).

### Toast.info

Creates a toast with information styling (blue background and icon).

### Toast.success

Creates a toast with success styling (green background and icon).

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

## Accessibility

The Toast component includes semantic labels for accessibility:

- The entire toast is marked as a container
- The close button is marked as a button
- The title (if present) is used as the primary label
- The description is used as a hint when a title is present
- The close button has its own semantic label

## Styling

- Padding: Horizontal `CoreSpacing.space4`, Vertical `CoreSpacing.space3`
- Border Radius: 8 pixels
- Shadow: `CoreShadows.medium`
- Icon Size: 24 pixels
- Typography:
    - Title/Description: `CoreTypography.bodyLargeMedium`
    - Description (when title present): `CoreTypography.bodySmallRegular`
    - Close Label: `CoreTypography.bodyMediumSemiBold` 