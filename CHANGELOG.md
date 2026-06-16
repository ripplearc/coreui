# Changelog

## [0.6.0] - CoreInitialAvatar & CoreCheckRowItem

### ✨ Features

- **UI Components**
  - **CoreInitialAvatar**: New circular avatar showing a single name initial, built as a thin wrapper over `CoreAvatar`.
    - Derives the initial from the first whitespace-delimited token of `name`, uppercased (`"John Doe"` → `"J"`); a single first-name initial, not first+last
    - Defaults to a 24×24 circle (`radius` 12), parameterized for other sizes
    - Theme-driven default colours (`backgroundBlueMid` background, `iconOrient` initial) so dark mode is handled automatically
    - Fully overridable `backgroundColor`, `textColor`, and `textStyle` so callers can theme the avatar independently; `textColor` is applied last and remains the single source of truth for the glyph colour
    - Localizable `semanticLabel` param (defaults to `"Avatar for {name}"`)
    - Blank `name` renders an empty circle (no crash)
  - **CoreCheckRowItem**: New selectable list row — leading widget, title (+ optional subtitle), and a trailing checkbox.
    - Whole row is tappable; tapping toggles `selected` via `onChanged`
    - Defaults the leading widget to a `CoreInitialAvatar` built from `title`; `avatarBackgroundColor`/`avatarTextColor` pass through to it (ignored when a custom `leading` is supplied)
    - Trailing checkbox swaps between `CoreIcons.check` and `CoreIcons.checkBlank` based on `selected`
    - Optional `subtitle` for a second line (e.g. an email address)
    - Localizable `semanticLabel` param (defaults to `title`); exposed as a `Semantics(button: true, checked: selected)` node

## [0.5.0] - Search components

### ✨ Features

- **UI Components**
  - **CoreSearchBox**: New borderless search input field.
    - Built-in leading search icon and auto-appearing clear button (shown only when the field has text)
    - Flat appearance with no visible border — designed for global or in-page search bars
    - Accepts an optional `TextEditingController` and `FocusNode`; manages its own when none are supplied
    - `onChanged`, `onSearch` (keyboard submit), and `onClear` callbacks
    - `enabled` flag renders the field non-interactive with a `backgroundGrayMid` fill
    - `clearSemanticLabel` localizable constructor param (defaults to `'Clear search'`)
    - `hintText` localizable constructor param for placeholder text
  - **CoreSearchRowItem**: New single-row item for search screens.
    - Two named constructors: `CoreSearchRowItem.recentSearch` (history icon) and `CoreSearchRowItem.suggestion` (search icon with bold-prefix query highlighting)
    - Trailing ↗ icon with independent `onTrailingTap` callback (e.g. fill the search field without triggering a search)
    - `showTrailingIcon` flag to hide the trailing icon
    - `semanticLabel` and `trailingSemanticLabel` localizable params for full screen-reader support
    - Custom variant via the default constructor: caller supplies any `leadingIcon` and a pre-built `label` widget

## [0.4.1] - CoreIconSize token

### ✨ Features

- **Design Tokens**
  - **CoreIconSize**: New icon size token with four canonical sizes — `size16` (16dp), `size20` (20dp), `size24` (24dp), `size32` (32dp).
    - Value-based naming reflects how icon sizes are referenced in design tooling and specs
    - Exported from the public barrel alongside other theme tokens
    - Golden test verifying each size using `CoreIconWidget`

## [0.4.0] - CoreFilterChip component

### ✨ Features

- **UI Components**
  - **CoreFilterChip**: New dropdown-style filter chip for filter rows.
    - Filled pill design using `backgroundGrayMid` (`#F2F4F7`) background token
    - Trailing dropdown arrow icon in `iconDark` (`#015B7C`) color
    - `label` (required) and `onTap` (optional) public API — chip is non-interactive when `onTap` is null
    - Full accessibility support: outer `Semantics` node exposes label and button role (only when enabled); `Text` and arrow icon wrapped in `ExcludeSemantics` to prevent double-announcement
    - Widget tests, accessibility tests, and golden tests (enabled, long label, disabled states)

## [0.3.9] - CoreToast title support

### ✨ Features

- **UI Components**
  - **CoreToast**: Added optional `title` parameter to `showSuccess`, `showError`, and `showWarning` methods.

### 🔧 Fixes

- **Code Quality**
  - Improved null safety in `CoreToast` descriptions to avoid displaying "null" strings.
  - Cleaned up redundant documentation and implementation comments.

## [0.3.8] - CoreQuickSheet component

### ✨ Features

- **UI Components**
  - **CoreQuickSheet**: New standardized bottom sheet component for consistent sheet presentation across the app
    - Automatic content-based height (up to 90% of screen)
    - Custom drag handle with consistent styling
    - Theme-aware background color (defaults to `pageBackground`)
    - Configurable dismiss behavior (`isDismissible`, `enableDrag`)
    - Optional safe area handling (`useSafeArea`)
    - Optional custom background color override
    - Rounded top corners (28px) per design spec
    - Returns values when dismissed for result handling

### 🔧 Fixes

- **Code Quality**
  - Fixed tooltip component forced unwrapping issue with overlay entry
  - Improved null safety in tooltip overlay insertion

## [0.3.7] - Add splash screen icons

### ✨ Features

- **Icons**
  - Added splash screen animation icons (splashFirstState, splashSecondState, splashThirdState)
  - New SVG icons available via CoreIcons for splash screen animations

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
