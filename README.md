# Ripplearc Core UI

A Flutter design system package with design tokens and basic components.

## Package Structure

```
coreui/
│
├── lib/
│   ├── ripplearc_coreui.dart               # Entry point
│   └── src/
│       ├── theme/                 # Theming system and tokens
│       │   ├── color_tokens.dart
│       │   ├── typography.dart
│       │   ├── spacing.dart
│       │   └── theme_data.dart
│       │
│       └── components/            # UI components
│           ├── buttons/
│           │   └── primary_button.dart
│           ├── switches/
│           ├── text_fields/
│           └── alerts/
│
├── test/                          # Tests
│   ├── theme/
│   └── components/
│       ├── buttons/
│       │   ├── primary_button_test.dart
│       │   └── primary_button_golden.dart
│
├── showroom/                      # Demo app
│   ├── main.dart
│   └── screens/
│       └── components_screen.dart
│
├── pubspec.yaml
└── README.md
```

## Features

- Design Tokens (colors, typography, spacing)
- Basic Components:
  - Buttons
  - More components coming soon
- Comprehensive testing (Unit, Widget, and Golden tests)
- Showroom app to showcase components

## Getting started

Add this package to your pubspec.yaml:

```yaml
dependencies:
  ripplearc_coreui:
    git:
      url: https://github.com/ripplearc/coreui.git
      ref: main
```

## Usage

```dart
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

// Use theme
MaterialApp(
  theme: CoreTheme.light(),
  darkTheme: CoreTheme.dark(),
  // ...
);

// Use components
PrimaryButton(
  label: 'Click me',
  onPressed: () {},
);
```

## Development

### Running Tests

```bash
# Run unit and widget tests
flutter test

# Run golden tests
flutter test --update-goldens
```

### Running the Showroom App

```bash
cd showroom
flutter run
```
