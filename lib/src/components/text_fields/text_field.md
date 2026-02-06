# CoreTextField

A customizable text input field component that follows the Core UI design system. This component provides a rich set of
features including error handling, helper text, phone number input support, and various styling options.

## Usage

```dart
CoreTextField
(
label: 'Email',
helperText: 'Enter your email address',
onChanged: (value) {
// Handle text changes
},
)
```

## Properties

| Property               | Type                         | Description                                                 |
|------------------------|------------------------------|-------------------------------------------------------------|
| `label`                | `String?`                    | The label text displayed above the text field               |
| `helperText`           | `String?`                    | Additional helper text displayed below the text field       |
| `errorText`            | `String?`                    | Error message to display when the field is invalid          |
| `obscureText`          | `bool`                       | Whether to hide the text being edited (e.g., for passwords) |
| `isPhoneNumber`        | `bool`                       | Whether this field is used for phone number input           |
| `controller`           | `TextEditingController?`     | Controller for the text field                               |
| `onChanged`            | `void Function(String)?`     | Callback function when text changes                         |
| `keyboardType`         | `TextInputType?`             | The type of keyboard to show for this text field            |
| `enabled`              | `bool`                       | Whether the text field is enabled for input                 |
| `validator`            | `String? Function(String?)?` | Function to validate the input                              |
| `focusNode`            | `FocusNode?`                 | Focus node for the text field                               |
| `initialValue`         | `String?`                    | Initial value for the text field                            |
| `readOnly`             | `bool`                       | Whether the text field is read-only                         |
| `prefix`               | `Widget?`                    | Widget to display before the text input                     |
| `suffix`               | `Widget?`                    | Widget to display after the text input                      |
| `phonePrefix`          | `String?`                    | Default phone prefix (e.g., '+1')                           |
| `onPhonePrefixChanged` | `void Function(String?)?`    | Callback when phone prefix changes                          |
| `phonePrefixes`        | `List<String>?`              | List of available phone prefixes                            |

## Features

### Phone Number Input

When `isPhoneNumber` is set to `true`, the text field displays a country code selector with the following features:

- Customizable list of country codes
- Bottom sheet for selecting country codes
- Visual separator between country code and phone number

### Error Handling

The component supports error states with:

- Red border color
- Error icon
- Custom error message display

### Helper Text

Helper text can be displayed below the input with:

- Info icon
- Custom helper message
- Proper styling according to the design system

### Styling

The component follows the Core UI design system with:

- Consistent border radius
- State-specific border colors
- Proper spacing and padding
- Typography following the design system

## Example

```dart
CoreTextField
(
label: 'Phone Number',
isPhoneNumber: true,
phonePrefix: '+1',
phonePrefixes: ['+1', '+44', '+91'],
onPhonePrefixChanged: (prefix) {
// Handle prefix change
},
errorText: 'Please enter a valid phone number',
helperText: 'Include country code',
onChanged: (value) {
// Handle phone number changes
},
)
``` 