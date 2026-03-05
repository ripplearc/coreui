# Changelog

## [0.3.7] - CoreQuickSheet component

### ✨ Features

- **UI Components**
  - **CoreQuickSheet**: New standardized bottom sheet component for consistent sheet presentation across the app
    - Automatic content-based height (up to 90% of screen)
    - Custom drag handle with consistent styling
    - Theme-aware background color (defaults to `pageBackground`)
    - Configurable dismiss behavior (`isDismissible`, `enableDrag`)
    - Optional safe area handling (`useSafeArea`)
    - Optional custom background color override
    - Professional 28px top border radius
    - Returns values when dismissed for result handling

### 🔧 Fixes

- **Code Quality**
  - Fixed tooltip component forced unwrapping issue with overlay entry
  - Improved null safety in tooltip overlay insertion

## [0.3.6] - Accessibility improvements

### ✨ Features

- **Accessibility**
  - Added accessibility tests for all interactive components (CoreAvatar, CoreLetterAvatar, CoreKeyboard, CoreButton, CoreBottomNavBar, CoreLoadingIndicator)
  - Tests verify tap target size, semantic labels, and text contrast guidelines

### 🔧 Fixes

- **Design Tokens**
  - Updated text link color from orient600 to orient800 to match UI design specification

- **Accessibility**
  - Fixed CoreButton text overflow with ellipsis and FittedBox scaling for long labels
  - Fixed accessibility-related contrast and layout issues across components

## [0.3.5] - Code quality improvements

### ✨ Features

- **UI Components**
  - **CoreLoadingIndicator**: Added Lottie-based loading indicator component with customizable size and fit options

- **Dependencies**
  - Added **lottie** (^3.2.0) for animation support

- **Assets**
  - Added loading animation asset (`assets/animations/loading.json`)

## [0.3.4] - Code quality improvements

### 🔧 Fixes

- **Code Quality**
  - Fixed `avoid_static_colors` linter violations
  - Integrated shadow colors into theme system for consistent design token usage

## [0.3.3] - Theme extension naming consistency

### ⚠️ Breaking Changes

- **TypographyExtension** has been renamed to **AppTypographyExtension** for consistency with other theme extensions
- Update your code: `Theme.of(context).extension<TypographyExtension>()` → `Theme.of(context).extension<AppTypographyExtension>()`

## [0.3.2] - Code quality improvements

### 🔧 Fixes

- **Code Quality**
  - Fixed `avoid_static_typography` linter violations
  - Fixed `forbid_forced_unwrapping` linter violations
  - Fixed `specific_exceptions_types` linter violations

## [0.3.1] - Add transparent utility color

### ✨ Features

- **Design Tokens**
  - Added **transparent utility color** to the core color palette and **AppColorsExtension** for consistent use across apps.

## [0.1.0] - Initial Release

### ✨ Features

- **UI Components**
  - **CoreBottomNavBar**: A customizable bottom navigation bar component with responsive sizing and smooth animations.
  - **SuccessModal**: A bottom sheet that is displayed to the user when an operation is successful.
  - **Toast**: Provides a static interface to display toast messages, e.g., Toast.showSuccess, Toast.showError, Toast.showWarning.
  - **CoreButton**: Customizable button with support for primary, secondary, and social variants, multiple sizes, icons, and disabled state.
  - **CoreTextField**: Flexible text input with label, helper text, error handling, phone number input, prefix/suffix widgets, and country code selector.
  - **SingleItemSelector**: Single-select dropdown with bottom sheet support.
  - **CoreIconWidget**: Unified icon widget supporting both Material and SVG icons.

- **Design Tokens**
  - Color tokens (brand, gray, blue, red, etc.)
  - Typography tokens (font sizes, weights, styles)
  - Spacing tokens (consistent spacing system)
  - Shadow tokens (multiple shadow levels)
  - Icon tokens (Material and custom SVG icons)

- **Theming**
  - Light and dark theme support
  - Easily extendable theme data for custom branding

- **Assets**
  - Extensive icon set (SVG and Material icons)
  - IBM Plex Sans Hebrew font family included
