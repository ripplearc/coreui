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
### Colors & Typography Usage

**Strict Rule:** Do not use static constants (e.g., `CoreAlertColors.red` or `CoreTypography.body`). Static access breaks Dark Mode support.

Always access tokens through the **Theme Extension** so the UI adapts to the active theme.

**Incorrect** — bypasses the theme; won’t update in Dark Mode.
```dart
// This will fail the build
Container(
  color: AppColors.backgroundBlueLight,
  child: Text(
    'Hello',
    style: CoreTypography.bodyMedium,
  ),
);
```

**Correct** — uses `BuildContext` to read the current theme tokens.
```dart
// Adapts to Light/Dark mode automatically
final colors = Theme.of(context).extension<AppColorsExtension>()!;
final typography = Theme.of(context).extension<AppTypographyExtension>()!;

Container(
  color: colors.pageBackground,
  child: Text(
    'Hello',
    style: typography.bodyMedium,
  ),
);
```

## Development

### Running Tests

#### Golden Tests with Docker

**Why Docker?** Golden test screenshots vary between platforms (macOS, Linux, Windows). The Docker container matches the CI environment (Linux) to ensure consistent screenshots.

#### Setup

1. **Start Docker container:**
   ```bash
   docker-compose up -d
   ```

2. **Get container name:**
   ```bash
   docker container ps
   ```
   Look for `coreui-flutter-1` or similar.

3. **Open shell in container:**
   ```bash
   docker exec -it coreui-flutter-1 bash
   ```
   
   **Note:** If your container has a different name, use `docker container ps` to find it, or replace `coreui-flutter-1` with your container name/ID.

4. **Run golden tests inside container:**
   ```bash
   # Verify golden tests (matching CI workflow)
   flutter test test/components/*
   flutter test test/theme/*
   flutter test test/notifications/*

   # Update golden images (Only run when a visual change is intended in a specific directory)
   flutter test test/components/* --update-goldens
   flutter test test/theme/* --update-goldens
   flutter test test/notifications/* --update-goldens
   ```

5. **Exit container:**
   ```bash
   exit
   ```

**Note:** The `test/` and `lib/` directories are volume-mounted, so updated golden files automatically sync to your host machine. No need to copy files manually.

#### Rebuilding Docker Image

Rebuild the Docker image only when switching to a branch that changes underlying dependencies (for example when pubspec.yaml or pubspec.lock — or any other dependency files — differ). If those files did not change, you can skip the rebuild and just restart the containers.

```bash
# Stop container
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

#### Local Development

```bash
# Run unit and widget tests
flutter test

# Run golden tests
flutter test --update-goldens
```

**Note:** For golden tests, use Docker (see [Golden Tests with Docker](#golden-tests-with-docker) above) to ensure consistent screenshots across platforms.

### Running the Showroom App

```bash
cd showroom
flutter run
```
