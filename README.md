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
│       │   ├── shadows.dart
│       │   ├── icons/
│       │   ├── app_typography_extension.dart
│       │   └── theme_data.dart
│       │
│       └── components/            # UI components
│           ├── alerts/
│           ├── avatar/
│           ├── bottom_sheets/
│           ├── buttons/
│           ├── calculator_chips/
│           ├── check_row_item/
│           ├── chips/
│           ├── date_picker/
│           ├── display_area/
│           ├── keyboard/
│           ├── letter_avatar/
│           ├── navigation/
│           ├── search/
│           ├── select_button/
│           ├── selects/
│           ├── switches/
│           ├── tabs/
│           ├── text_fields/
│           └── tooltips/
│
├── test/                          # Tests
│   ├── theme/
│   └── components/
│
├── example/                       # Demo app
│
├── pubspec.yaml
└── README.md
```

## Features

- Design Tokens (colors, typography, spacing, shadows, icons)
- Full light and dark theme support via `CoreTheme.light()` and `CoreTheme.dark()`
- UI Components:
  - Buttons, switches, text fields, alerts
  - Avatar, letter avatar
  - Chips (filter, calculator, input)
  - Date picker
  - Search (search box, search row item)
  - Select button, selects (single item selector)
  - Keyboard, bottom sheets, navigation, tabs, tooltips
  - Display area, geometry area
- Comprehensive testing (unit, widget, golden, and accessibility tests)

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

### Dark Theme

Pass `CoreTheme.dark()` to `darkTheme` and Flutter will switch automatically based on the device setting. All color and typography tokens resolve to their dark-mode values — no component-level changes needed.

```dart
MaterialApp(
  theme: CoreTheme.light(),
  darkTheme: CoreTheme.dark(),
  themeMode: ThemeMode.system, // or .light / .dark
);
```

Components that access tokens via `Theme.of(context).extension<AppColorsExtension>()!` and `Theme.of(context).extension<AppTypographyExtension>()!` adapt automatically. Never read tokens from static constants — they are frozen to light-mode values and will not update.

### Loading Animations

The package includes a Lottie-based loading indicator for showing progress or loading states.


```dart
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

// Default size (80px)
CoreLoadingIndicator()

// Custom size
CoreLoadingIndicator(size: 100)

// Custom BoxFit
CoreLoadingIndicator(
  size: 80,
  fit: BoxFit.cover,
)
```

### Input Chips

`CoreInputChip` displays a committed token (e.g. an email address or tag) with an optional remove button. It is designed to be used inside a `Wrap`.

```dart
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

// With remove button
CoreInputChip(
  label: 'alice@example.com',
  onRemove: () => setState(() => emails.remove('alice@example.com')),
)

// Display-only (no remove button)
CoreInputChip(
  label: 'alice@example.com',
)
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
