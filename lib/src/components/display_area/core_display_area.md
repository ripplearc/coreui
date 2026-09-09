# CoreDisplayArea

A robust, self-contained, and gesture-driven multi-stage display area component designed for complex calculating or data-entry contexts. `CoreDisplayArea` provides a dynamic history panel, intrinsic animated transitions, and flexible UI states (such as typing indicators, error states, and dependent key handling). It is an ideal top-half companion to a custom software keyboard like `CoreKeyboard`.

## Overview

`CoreDisplayArea` is engineered to handle extensive historical data (previous calculator/data sessions) alongside current active inputs. It achieves a highly fluid user experience through vertical swipe gesture expansions, utilizing an intelligent multi-stage routing path determined by the density of the current session's content.

### Key Features
- **Adaptive Multi-Stage Expansion**: Intelligently switches between a 2-stage and 3-stage expansion trajectory based on the amount of current session data (determined by a 5-item `chipsList` threshold).
- **Interactive History Panel**: Supports rendering a scrollable list of current session chips (`CoreCalculatorChip`) and previous session histories (`CoreHistorySessionData`).
- **Rich State Management**: Natively supports `isTyping` indicators, comprehensive error states (`hasError`, `errorMessage`, `errorTitle`), and a row of dependent-key pills under the value (e.g. `Rate: $12.3/ft²` and `Waste: 10%` beneath a cost, or `Shown as: in/12in` beneath a pitch).
- **Haptic Feedback Integration**: Provides subtle physical cues (`HapticFeedback.lightImpact`/`mediumImpact`) as the user crosses different expansion thresholds.
- **Stage Callback Hooks**: Exposes `onStageChanged` to seamlessly synchronize and drive external spatial animations.

---

## Usage Example

The component is highly customizable and pairs perfectly with a state management solution (e.g., BLoC) and a paired keyboard component.

```dart
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

CoreDisplayArea(
  // Both strings are required: localization is the consumer's responsibility.
  closeSemanticLabel: AppLocalizations.of(context).closeButton,
  historyPlaceholder: AppLocalizations.of(context).historyPlaceholder,
  label: 'Cost',
  value: '\$84.25',
  isTyping: false,
  dependentKeys: [
    CoreDependentKeyData(
      label: 'Rate',
      value: '\$14.5/sheet',
      kind: CoreDependentKeyKind.editable,
      onPressed: () => openRateEditor(),
    ),
    CoreDependentKeyData(
      label: 'Waste',
      value: '10%',
      kind: CoreDependentKeyKind.editable,
      onPressed: () => openWasteEditor(),
    ),
  ],
  onStageChanged: (DisplayAreaStage stage) {
    // React to the display area's current stage,
    // e.g., to animate the paired keyboard's height factor.
  },
  onClose: () {
    // Trigger reset or cleanup logic in your BLoC.
  },
  chipsList: const [
    CoreCalculatorChip(
      label: 'Width',
      value: '10ft',
      type: CoreCalculatorChipType.editable,
    ),
    // ... active input chip, completed chips, etc.
  ],
  previousSessions: const [
    CoreHistorySessionData(
      dateLabel: 'Yesterday',
      value: '10.5',
      chipsList: [...], // past chips
    ),
  ],
)
```

---

## Expansion Behavior & Interaction Mechanics

The component monitors `onVerticalDragEnd` velocities to cycle through `DisplayAreaStage` enum values: `collapsed`, `expandedCurrent`, `expandedPrevious`, and `fullScreen`.

The expansion logic uses a smart threshold logic (`chipsList.length > 5`) to determine the path:

**When `chipsList` has 5 or fewer items (2-Stage Path):**
1. **1st Swipe (Down)**: Skips `expandedCurrent` and transitions directly to `DisplayAreaStage.expandedPrevious` to reveal previous sessions immediately, as the current chips already fit.
2. **2nd Swipe (Down)**: Transitions to `DisplayAreaStage.fullScreen` for a complete, page-filling historical view.

**When `chipsList` has more than 5 items (3-Stage Path):**
1. **1st Swipe (Down)**: Transitions to `DisplayAreaStage.expandedCurrent` to reveal the overflow of the current session chips.
2. **2nd Swipe (Down)**: Transitions to `DisplayAreaStage.expandedPrevious`, pushing the view down further to reveal past session data.
3. **3rd Swipe (Down)**: Transitions to `DisplayAreaStage.fullScreen`.

*Note: Swiping up with a negative velocity reverses the progression stage-by-stage back to `collapsed`.*

---

## Integration Guide: Keyboard Sync (Showcase Pattern)

When `CoreDisplayArea` is paired with a keyboard on a screen, the recommended UX pattern is to push the keyboard off-screen progressively as the display area expands.

Use a `TweenAnimationBuilder` wrapping your keyboard widget. Drive the `end` value of the tween using the current `DisplayAreaStage` provided by `onStageChanged`:

```dart
TweenAnimationBuilder<double>(
  tween: Tween<double>(
    begin: 1.0,
    end: switch (_currentStage) {
      DisplayAreaStage.collapsed => 1.0,
      DisplayAreaStage.expandedCurrent => 0.95, // Slight dip
      DisplayAreaStage.expandedPrevious => 0.75, // Moderate dip
      DisplayAreaStage.fullScreen => 0.0,       // Fully hidden
    },
  ),
  duration: const Duration(milliseconds: 300), // Matches _kDisplayAreaAnimationDuration
  curve: Curves.easeInOut,
  builder: (context, factor, child) {
    return ClipRect(
      child: Align(
        alignment: Alignment.topCenter,
        heightFactor: factor,
        child: child, // Your CoreKeyboard
      ),
    );
  },
)
```

---

## API Reference

### Layout & Text Properties
| Property | Type | Default | Description                                                                                                                                                                   |
| :--- | :--- | :--- |:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `label` | `String` | `''` | Main label text shown in the label section (e.g., 'Rise', 'Run').                                                                                                             |
| `value` | `String` | `''` | Main value text shown prominently in the value section.                                                                                                                       |
| `historyPlaceholder` | `String` | **required** | Text displayed in the history panel when `chipsList` is empty. Has no default — pass a localized string from your app's localization layer. |

### State Properties
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `isTyping` | `bool` | `false` | When `true`, displays a typing-animation indicator next to the `label`. |
| `hasError` | `bool` | `false` | Toggles the error state layout. |
| `errorTitle` | `String` | `''` | Replaces the standard value display when `hasError` is `true`. |
| `errorMessage` | `String` | `''` | Displayed dynamically as an error chip when `hasError` is `true`. |

### History Data
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `chipsList` | `List<CoreCalculatorChip>` | `[]` | Ordered list of current-session chips displayed in the history panel. Controls the adaptive expansion threshold. |
| `previousSessions` | `List<CoreHistorySessionData>` | `[]` | Past session data revealed natively in `expandedPrevious` and `fullScreen` stages. |

### Callbacks & Actions
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `onStageChanged` | `void Function(DisplayAreaStage)?` | `null` | Triggered precisely when the expansion stage transitions. |
| `onClose` | `VoidCallback?` | `null` | Triggered when the user taps the top-right close icon (which is hidden in `expandedPrevious` and `fullScreen` modes). |
| `onPressedDependentKey` | `VoidCallback?` | `null` | **Deprecated** — action fired when the legacy single dependent-key pill is tapped. Use `CoreDependentKeyData.onPressed`. |

### Dependent Keys
An answer keeps its assumption on screen. `dependentKeys` renders an end-aligned row of pills under the value; when the pills outgrow the width the row scrolls horizontally with the trailing pill anchored in view.

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `dependentKeys` | `List<CoreDependentKeyData>` | `[]` | The pills rendered under the value, in order. |

#### `CoreDependentKeyData`
| Property | Type | Required | Description |
| :--- | :--- | :--- | :--- |
| `label` | `String` | Yes | The descriptive prefix (`Rate`, `Shown as`, `Re-input 38.30° as`). A colon is appended for `editable` / `toggle` unless the label already ends with one; an `offer` label is used as written. |
| `value` | `String` | Yes | The bold value after the label (`$12.3/ft²`, `in/12in`, `38°30′`). |
| `kind` | `CoreDependentKeyKind` | Yes | `editable`, `toggle` or `offer` — see below. |
| `onPressed` | `VoidCallback?` | No | Tap handler. `null` renders the pill disabled. |
| `semanticsLabel` | `String?` | No | Overrides the announced label; defaults to the visible label and value. |

#### Kinds
| Kind | Meaning | Trailing icon | Example |
| :--- | :--- | :--- | :--- |
| `editable` | Opens an editor for the assumption the result was computed with. | ✎ `CoreIcons.edit` | `Sheet size: 48in × 94.49in`, `Rate: $12.3/ft²`, `Waste: 10%`, `Density (concrete): 4,050lbs/yd³` |
| `toggle` | Cycles or swaps a reading of the value already on screen without changing it. | ⇄ `CoreIcons.swapHorizontal` | `Shown as: in/12in` → degrees → grade |
| `offer` | A one-time offer that rewrites the number; the app removes it once accepted. | none | `Re-input 38.30° as 38°30′` |

Every pill is a `CoreButton` (medium, secondary, small shadow) exposing `button: true` with its label, so the three kinds are distinct both visually and to screen readers. All strings come from the consumer — the row holds no defaults.

#### Deprecated single-pill adapter
`dependentKeyLabel`, `dependentKeyValue` and `onPressedDependentKey` still render, as one `editable` pill appended after `dependentKeys`, but are deprecated and will be removed in the next minor release. `resolvedDependentKeys` (`@visibleForTesting`) exposes the merged list `build` renders.

### Accessibility
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `closeSemanticLabel` | `String` | **required** | The semantic label announced by screen readers for the close icon. Has no default — pass a localized string so screen readers announce it in the user's language. |

---
*Architectural Note: `CoreDisplayArea` heavily utilizes `AnimatedSize` aligned to `Alignment.topCenter` for its fluid layout transitions and relies on a deliberately calibrated swipe velocity threshold (`80px/sec`) to ensure intention-driven gestures without accidental triggers.*
