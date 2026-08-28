# Changelog

## [0.13.1] - CoreSearchBox exposes test keys on the inner text field and clear button

> Version note: 0.13.1 is a deliberate patch even though the change is a Feature — it is additive-only, and 0.14.0 is already claimed by the open CA-898 (#158) and CA-654 (#157) branches. Whichever of #157/#158/#159 merges last reconciles the version headers.

### ✨ Features

- **CoreSearchBox**: exposes `CoreSearchBox.textFieldKey` (`core_search_box_text_field`) on the inner text field and promotes the existing clear-button key to `CoreSearchBox.clearButtonKey` (`core_search_box_clear_button`, string unchanged), so app widget tests can target both with `find.byKey` instead of fragile `find.byType(TextFormField)` descendant finders. Both keys are shared statics, matching `CoreInputChip.removeButtonKey` — scope with `find.descendant` when a screen renders more than one search box (CA-952)

### 🧪 Tests

- Widget tests pin both key strings, assert the keyed widget is the single rendered text field, and pin the shared-static behavior across two instances; the suite migrated to the shared `buildTestApp` harness with `CoreTheme.light()` and every finder now goes through the key constants

## [0.13.0] - CoreDateFilterChip active pill reuses the CoreInputChip primitive

### ✨ Features

- **CoreInputChip**: adds `removeOnChipTap` (default false) — when true, tapping anywhere on the chip invokes `onRemove` and the whole chip is exposed as a single semantic button labeled with `removeSemanticLabel`; the close (×) icon stays visible as the removal affordance but is no longer a separate tap target (CA-830)

### 🔧 Changes

- **CoreDateFilterChip**: the active pill is now a `CoreInputChip` with whole-chip tap-to-remove instead of a hand-built container, so it adopts the chip family's visual treatment (pill radius, `chipGrey` background, semibold label, size-20 close icon). Consumers with goldens of the active pill will see pixel drift and should regenerate (CA-830)

### 🧪 Tests

- Unit + semantics tests for the whole-chip tap-to-remove mode (tap anywhere removes, single button node, icon stays, no-op without `onRemove`); default-mode chip goldens are byte-identical
- CoreDateFilterChip active-pill goldens regenerated (light + dark)

## [0.12.0] - CoreAppBar

### ✨ Features

- **CoreAppBar**: new top app bar that implements `PreferredSizeWidget`, so it drops straight into `Scaffold.appBar` (CA-823)
  - Separating shadow comes from `CoreShadows.medium` via `BoxDecoration`, with Material elevation held at zero, so the shadow is drawn exactly once instead of doubling
  - `CoreAppBarElevation { none, shadow, material }` covers the un-shadowed bar, the CoreShadows bar, and surfaces that must match a Material-elevated sibling
  - **`padding` is additive to `preferredSize`** (`preferredSize.height == height + padding.vertical`), so padding never shrinks the content box. This is the failure mode behind the 48x40 tap target in CA-822; the constructor also asserts `height >= CoreSpacing.space12` (48) so leading and action tap targets can always meet the 48x48 guideline
  - `height` defaults to `CoreSpacing.space14` (56) — measured from the consuming app, where 56 is the preferred size of 9 of the 12 existing bars (`HeaderRow` uses 64; the two estimation bars use an off-grid `kToolbarHeight + 5`). The class doc carries a caveat that Figma's reusable "Action Bar" component instead measures 64 total with t8/b8/l4/r16 baked-in padding, so CA-823 migration sites should pass `height`/`padding` explicitly rather than treating the code-derived default as spec-confirmed
  - `decorationShadow` (`@visibleForTesting`) exposes the shadow the bar's decoration paints, resolved from `elevation` and consumed by `build` itself, so tests assert elevation behavior without reaching into the widget tree
  - `scrolledUnderElevation` is held at zero in every mode, so the bar does not darken or re-tint when content scrolls under it
  - Accepts an arbitrary `title` widget (custom rows, icon clusters) or a `titleText` convenience styled `titleMediumSemiBold` in `textHeadline`; supplying both asserts
  - Colors resolve from the theme extension (`pageBackground`, `textHeadline`, `iconDark`), so the bar tracks `CoreTheme.light()` and `CoreTheme.dark()`
  - `implyLeading` defaults to **false**, so the bar never sprouts a Material back button just because the route is poppable — the app bar design has no back button. `leading` is rendered independently of the flag, so an explicit close/back icon is never silently dropped
  - Holds no user-visible strings — `leading` and `actions` pass their own `semanticLabel` through, keeping localization in the consuming app

### 🧪 Tests

- Widget tests: preferred-size arithmetic, both asserts, elevation modes, theming fallback and override, action rendering and callbacks, and leading behaviour over a real pushed route (no implied back button by default, opt-in via `implyLeading`, explicit `leading` rendered regardless)
- Golden tests: five bar shapes (flat/no-shadow, custom title row, back button with project title, Material elevation, plain title) in both light and dark, with the viewport scoped to each bar's own `preferredSize` so every golden contains exactly the bar and no empty body space
- A11y tests: tap-target and label guidelines in both themes, including at the minimum permitted height
- Title contrast is asserted from the resolved tokens rather than sampled pixels; the pixel-sampling guideline reads the AppBar title's antialiased glyph edges and reports a blend of text and background rather than the token colors

## [0.11.2] - Keep CoreMultiSelectSheet visible above the keyboard

### 🔧 Fixes

- **CoreMultiSelectSheet**: the sheet now pads itself by the keyboard's view inset and lets the item list shrink, so the search field, list, and action buttons stay visible above the keyboard while the user types (CA-842)

### 🧪 Tests

- Widget test: presents the sheet through `CoreQuickSheet.show` (the real presentation path), simulates the keyboard opening, and asserts the search field, list items, and Apply button all sit above the keyboard
- Golden tests: keyboard-open sheet in both light and dark themes

## [0.11.1] - CoreBottomNavBar action button semantic label

### 🔧 Fixes

- **CoreBottomNavBar**: adds `actionButtonSemanticLabel` parameter — when provided, the trailing circular action button is wrapped in a `Semantics` node so screen readers can announce it; when null (default) behavior is unchanged (backward compatible, no golden change)

### 🧪 Tests

- Semantics test: verifies label and `isButton` flag appear on the trailing button's semantics node
- A11y test: confirms the labeled trailing button meets tap-target and label guidelines in both light and dark themes

## [0.11.0] - Parameterize CoreBottomNavBar for 2–4 tabs

### ✨ Features

- **CoreBottomNavBar**: now accepts 2–4 tabs (previously required exactly 4)
  - Assert updated to `tabs.length >= 2 && tabs.length <= 4`
  - Layout computation derives tab-row and nav-bar base widths dynamically from `tabs.length`, so pill, active-tab, and inactive-tab proportions are correct for any supported tab count
  - 2-tab design verified against Figma spec (CA-874)
  - Inactive tab icons corrected from `iconGrayMid` to `iconWhite` for contrast on dark track
  - Active tab label uses `textLink` token (semantic fix; same hex value in all themes)
  - Existing 4-tab layout unchanged; goldens regenerated for icon color fix

### 🧪 Tests

- Boundary assert tests: rejects < 2 tabs and > 4 tabs
- 2-tab rendering tests: active label only visible, correct icon count
- 2-tab interaction test: tap second tab fires `onTabSelected(1)`
- New golden: `core_bottom_nav_bar_2tab_default.png`

## [0.10.2] - Accessibility

### ✨ Features

- **CoreInputChip**: add optional `removeSemanticLabel` for a localizable remove-button announcement; when null, keeps the default `'Remove <label>'` English label

## [0.10.1] - Dark-mode contrast fixes

### 🔧 Fixes

- **Accessibility / Dark mode**
  - **CoreButton (social variant)**: background changed from `buttonInverse` (gray25 — near-white) to `backgroundSecondaryDark` in dark mode, preventing invisible content when text and icon tokens also resolve to near-white
  - **DimensionCard**: same background-swap fix applied; card surface is now `backgroundSecondaryDark` in dark mode instead of `buttonInverse`
  - **SizeCard**: same background-swap fix applied; card surface is now `backgroundSecondaryDark` in dark mode instead of `buttonInverse`
  - All three fixes mirror the existing `CoreSelectButton` dark-mode guard pattern; contrast ratios now meet WCAG AA (≥ 4.5:1 for text, ≥ 3:1 for UI components)

### 🧪 Tests

- Social button: WCAG contrast a11y test + light & dark golden tests
- DimensionCard / SizeCard: WCAG contrast a11y tests added to `core_geometry_area_a11y_test.dart`
- Dark-mode golden tests added for `CoreGeometryArea` (collapsed and expanded)

## [0.10.0] - Search & Filter Components

### ✨ Features

- **UI Components**
  - **CoreDateFilterChip**: Filter chip for a date-range filter. With no selection it renders a plain `CoreFilterChip` that opens a `CoreDateRangeSheet` on tap; with a selection it renders an active pill showing the formatted range with a clear ×. Surface-agnostic: each caller supplies its own label, accessibility labels, and widget keys.
  - **CoreDateRangeSheet**: Modal bottom sheet for picking an inclusive, whole-calendar-day `DateRange`. Offers predefined ranges (Today, Last 7 days, Last 30 days, This month) plus a Custom range option that opens `CoreDatePicker` twice — once for the start date, once for the end date. Resolves with the chosen `DateRange`, or `null` on cancel/dismiss.
  - **CoreMultiSelectSheet**: Modal bottom sheet body for selecting multiple values from a searchable list of `{id, label}` items. The caller supplies the (already filtered) list and reacts to search and apply callbacks; present it with `CoreQuickSheet.show`.
  - **DateRange**: Value type representing an inclusive calendar-day range, shared by the date filter components.
  - All three components ship with showcase screens, widget tests, accessibility tests, and light + dark golden tests.

## [0.9.1] - Dart 3.8 compatibility patch

### 🔧 Fixes

- **Dependency constraints loosened for Dart 3.8 compatibility**
  - `flutter_svg`: `^2.3.0` → `^2.2.3` — 2.3.0 requires Dart ≥3.9.0; 2.2.3 is the last release compatible with Dart 3.8. No coreui APIs from 2.3.0 are used.
  - `lottie`: `^3.4.0` → `^3.3.1` — same reason; only `Lottie.asset()` with stable params is used.
  - `ripplearc_linter` moved from `dependencies` to `dev_dependencies` — the linter has no runtime role and should never have been a transitive dependency for consumers; this was causing `analyzer ^8.4.0` to cascade to every app using coreui, breaking build tooling on Dart 3.8.

## [0.9.0] - Dark theme

### ✨ Features

- **Dark Color Tokens**
  - 9 dark token classes mirroring each light class (`DarkBackgroundColors`, `DarkTextColors`, `DarkIconColors`, `DarkBorderColors`, `DarkTabColors`, `DarkButtonColors`, `DarkInputColors`, `DarkSelectColors`, `DarkStateColors`) — all colors sourced from the Figma dark-mode palette
  - `CoreTheme.dark()` now returns a fully populated `ThemeData` with `brightness: Brightness.dark` and `scaffoldBackgroundColor` mapped to `gray50`; both `AppColorsExtension` and `AppTypographyExtension` are switched to their dark variants automatically
  - `AppTypographyExtension.createDark()` — all 19 text styles substituted with `CoreDarkTextColors.*` (gray25 for headlines, gray100 for titles, gray300 for body); components using `typography.someStyle` without `.copyWith` now render correctly in dark mode

### 🔧 Fixes

- **Accessibility**
  - `SingleItemSelector` modal title: uses `.copyWith(color: colors.textHeadline)` so text stays visible on the dark scaffold (was gray900 on gray900 — 1:1 contrast)
  - `SingleItemSelector` item text: uses `.copyWith(color: colors.textBody)` to ensure list items remain legible in dark mode
  - `CoreSelectButton` selected tab: text color switches to `textInverse` (gray900) when tab background is `tabsHighlight` (orient300), resolving the 1.6:1 contrast failure in dark mode
- **CoreLetterAvatar**: replaced `Image.asset` with a `BoxDecoration`-based `Container` wrapped in `AspectRatio(aspectRatio: 1.0)`; fixes `Semantics` label propagation that was blocked by `Image.asset` and correctly derives height from the available width constraint without a `RenderBox` infinite-constraint error

### Tests

- `CoreDatePicker Visual Regression - Dark` golden added — verifies header background (`blue900`), selected day fill (`orient200`), and month row text under `CoreTheme.dark()`
- Dark-mode goldens added for color tokens, letter avatar, and check row item; all light goldens refreshed against current Flutter SDK

## [0.8.0] - CoreInputChip

### ✨ Features

- **UI Components**
  - **CoreInputChip**: New non-toggleable input chip for displaying committed tokens (e.g. email addresses or tags) with a remove button.
    - Displays a text label in `bodyMediumSemiBold` with `TextOverflow.ellipsis` — safe inside `Wrap` rows and on narrow screens
    - Trailing close (×) button meets the 48 dp minimum tap-target requirement; tapping calls `onRemove`
    - `onRemove` is optional — omitting it hides the remove button entirely, enabling a read-only/locked-token display mode
    - Full accessibility support: chip container exposes a `Semantics(container: true)` node with the label text; remove button exposes a `Semantics(button: true)` node labelled `"Remove <label>"`; label `Text` is wrapped in `ExcludeSemantics` to prevent double-announcement
    - `CoreInputChip.removeButtonKey` static key for locating the tap target in tests
    - Widget tests, accessibility tests (both themes), and golden tests (light + dark, short label + email label)

## [0.7.2] - CoreCheckRowItem & CoreDatePicker

### Upgraded
- Flutter SDK bumped from `3.32.0` to `3.44.4`; Dart SDK constraint raised to `>=3.12.0 <4.0.0`.
- Gradle wrapper `8.13` → `8.14`.
- Android Gradle Plugin (AGP) `8.7.0` → `8.11.1`.
- Kotlin Gradle Plugin `2.1.0` → `2.2.20`.
- `flutter_lints` `^5.0.0` → `^6.0.0`.
- `flutter_svg` `^2.2.2` → `^2.3.0`, `lottie` `^3.3.1` → `^3.4.0`, `ripplearc_linter` `^0.4.0` → `^0.4.1`.
- Minimum supported iOS deployment target raised from `12.0` to `13.0` (example app).

### Fixed
- Fixed a drag-reorder regression in `CoreFunctionKeyBottomSheet` where migrating to Flutter's new `onReorderItem` callback (which now performs index correction internally) had left the widget's own manual index-correction logic in place, causing dropped items to land one position off from where the user released them.

### Changed
- Migrated `ReorderableListView`/`ReorderableListView.builder` usages (`_SizesTable`, `CoreFunctionKeyBottomSheet`) from the deprecated `onReorder` callback to `onReorderItem`, ahead of Flutter's planned removal of `onReorder`.
- Migrated widget tests off the deprecated `SemanticsNode.hasFlag`/`SemanticsData.flags` API to the new `flagsCollection` API, including the `isSelected`/`isEnabled` flags moving from `bool` to the new `Tristate` enum.
- `SingleItemSelector`'s bottom sheet item now wraps its `ListTile` in a `Material` widget with `Clip.antiAlias`, fixing the tap ripple/ink effect rendering outside the intended bounds.
- `CoreKeyboard`'s reveal/collapse `SizeTransition` migrated from `axisAlignment: -1.0` to `alignment: AlignmentDirectional.topStart`.

### Tests
- Existing `SingleItemSelector` widget tests now pass without framework exceptions
  after the `Material(clipBehavior: Clip.antiAlias)` wrapper fix.

## [0.7.0] - CoreCheckRowItem & CoreDatePicker

### ✨ Features

- **UI Components**
  - **CoreCheckRowItem**: New selectable list row — leading widget, title (+ optional subtitle), and a trailing checkbox.
    - Whole row is tappable; tapping toggles `selected` via `onChanged`
    - Defaults the leading widget to a 24×24 circle showing the first initial of `title` (derived from the first whitespace-delimited token, uppercased, e.g. `"John Doe"` → `"J"`; blank `title` renders an empty circle, no crash); `avatarBackgroundColor`/`avatarTextColor`/`avatarTextStyle` theme it (ignored when a custom `leading` is supplied); `avatarTextColor` is applied last and remains the single source of truth for the glyph colour
    - Trailing checkbox swaps between `CoreIcons.check` and `CoreIcons.checkBlank` based on `selected`
    - Optional `subtitle` for a second line (e.g. an email address)
    - Localizable `semanticLabel` param (defaults to `title`); exposed as a `Semantics(button: true, checked: selected)` node
  - **CoreDatePicker**: New modal calendar widget for picking a single date (CA-220).
    - Header with a localizable label and a large spelled-out selected date (`"Mon, Aug 17"`-style by default, fully overridable via `dateLabelBuilder`)
    - Month selector row with previous/next navigation; arrows disable themselves once an adjacent month would be entirely out of the optional `firstDate`/`lastDate` range
    - Day grid with selected (filled), "today" (outlined), and disabled (out-of-range) states
    - `CoreDatePicker.show` static helper presents the picker in a themed dialog and resolves with the confirmed `DateTime`, or `null` on cancel/dismiss
    - `monthLabelBuilder` and `weekdayLabels` allow full localization of all date text without subclassing
    - Each day cell exposes a `Semantics(button: true, selected: ...)` node with a full date label via `MaterialLocalizations.formatFullDate`

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
