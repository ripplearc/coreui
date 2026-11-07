# RULE 4: Design Tokens

## Name
Design Tokens

## Category
UI Components

## Severity Levels
- **Critical:** Raw `Color(0x…)` or Material `Colors.*` in a component (breaks dark mode and the Figma tokens)
- **Major:** Hard-coded spacing, radius, icon size or `TextStyle(...)`; light-only static color classes used where the theme color exists
- **Minor:** A token exists for a value but a nearby literal is used once (e.g. one `4` next to `CoreSpacing.space1`)
- **Suggestion:** A value is used in two components and should become a token

## Description

coreui is the design system. Every color, text style, spacing, radius and icon size in a component comes from a token, so the app looks the same everywhere and dark mode works. Colors and text styles are read from the theme, because only the theme switches between light and dark.

## Applicability

All production code in `lib/src/components/`.

---

## For Coding Agents (Prescriptive)

### Decision Tree

```
What do I need?

├─ Color?        → final colors = AppColorsExtension.of(context);  colors.textHeadline
├─ Text style?   → final typography = AppTypographyExtension.of(context);  typography.bodyMediumRegular
├─ Spacing?      → CoreSpacing.space1 … space64   (multiples of 4: space1 = 4, space16 = 64;
│                   above space10 the steps skip numbers, see lib/src/theme/spacing.dart)
├─ Radius?       → CoreRadius.radius<N>
├─ Icon?         → CoreIconWidget(icon: CoreIcons.<name>, size: CoreIconSize.size<N>)
└─ Shadow?       → CoreShadows.<size>
```

`CoreTextColors`, `CoreBackgroundColors` and the other static color classes in `lib/src/theme/color_tokens.dart` are the **light** values that feed the theme. Components read `AppColorsExtension.of(context)` instead, so dark mode gets the `CoreDark…` values.

### ❌ / ✅

```dart
// ❌
Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xFFF5F7FA),
    borderRadius: BorderRadius.circular(8),
  ),
  child: Text(label, style: const TextStyle(fontSize: 14)),
)

// ✅
final colors = AppColorsExtension.of(context);
final typography = AppTypographyExtension.of(context);
Container(
  padding: const EdgeInsets.all(CoreSpacing.space4),
  decoration: BoxDecoration(
    color: colors.backgroundGrayLight,
    borderRadius: BorderRadius.circular(CoreRadius.radius8),
  ),
  child: Text(label, style: typography.bodyMediumRegular),
)
```

### No token for the value?

Do not invent a literal. Check the storyboard, then Figma, for the token name. If the design really needs a new value, add the token in `lib/src/theme/` in its own commit and say so in the PR text.

---

## For Review Agents (Detective)

### Detection Patterns

| # | Indicator | Regex | Severity | Fix |
|---|---|---|---|---|
| 1 | Raw hex color | `Color\(0x[0-9A-Fa-f]{6,8}\)` | Critical | `AppColorsExtension.of(context).<name>` |
| 2 | Material colors | `\bColors\.[a-zA-Z]+` (`Colors.transparent` is allowed) | Critical | Theme color |
| 3 | Light-only static color in a component | `Core(Text\|Background\|Border\|Icon\|Button\|Chip\|Alert\|Status)Colors\.` | Major | Same color via `AppColorsExtension.of(context)` |
| 4 | Hard-coded spacing | `EdgeInsets\.[a-zA-Z]+\([^)]*\b[0-9]+(\.[0-9]+)?\b` or `SizedBox\((width\|height): [0-9]` | Major | `CoreSpacing.space<N>` |
| 5 | Hard-coded radius | `BorderRadius\.circular\([0-9]` / `Radius\.circular\([0-9]` | Major | `CoreRadius.radius<N>` |
| 6 | Hard-coded text style | `TextStyle\(` (outside `lib/src/theme/`) | Major | `AppTypographyExtension.of(context).<variant>` |
| 7 | Hard-coded icon size / Material icon | `size: [0-9]` on an icon, `Icons\.[a-z_]+` outside `lib/src/theme/icons/` | Major | `CoreIconSize.size<N>`, `CoreIcons.<name>` |

Run each regex on the **added lines** of the diff only (`scripts/generate_diff.sh`); older literals in a file the PR only touches are not this PR's finding.

Allowed literals: `0`, `1` (hairlines), `double.infinity`, and values with a why-comment that names the storyboard or Figma frame.

### Common Violations

| ❌ Violation | ✅ Fix | Severity |
|---|---|---|
| `color: Color(0xFF1A1A1A)` | `color: colors.textHeadline` | Critical |
| `color: CoreTextColors.headline` in a widget | `color: AppColorsExtension.of(context).textHeadline` | Major |
| `EdgeInsets.symmetric(horizontal: 12)` | `EdgeInsets.symmetric(horizontal: CoreSpacing.space3)` | Major |
| `BorderRadius.circular(6)` | `BorderRadius.circular(CoreRadius.radius6)` | Major |
| `CoreIconWidget(icon: CoreIcons.check, size: 16)` | `size: CoreIconSize.size16` | Major |

---

## Summary: Suggested Fixes

Replace every literal color, text style, spacing, radius and icon size with its token. Read colors and text styles from the theme. Add a missing token in `lib/src/theme/` instead of a literal.

## References

- Tokens: `lib/src/theme/` (`spacing.dart`, `radius.dart`, `icon_sizes.dart`, `shadows.dart`, `color_tokens.dart`, `theme_extensions.dart`, `app_typography_extension.dart`)
- Icons: `lib/src/theme/icons/core_icons.dart`
- Takes the place of the app's "CoreUI Components" rule (04), which checks that the app uses coreui; this one checks that coreui uses its own tokens.
