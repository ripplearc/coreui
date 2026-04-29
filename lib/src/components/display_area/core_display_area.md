# CoreDisplayArea

A robust, self-contained, and gesture-driven multi-stage display area component designed for complex calculating or data-entry contexts. `CoreDisplayArea` provides a dynamic history panel, intrinsic animated transitions, and flexible UI states (such as typing indicators, error states, and dependent key handling). It is an ideal top-half companion to a custom software keyboard like `CoreKeyboard`.

## Overview

`CoreDisplayArea` is engineered to handle extensive historical data (previous calculator/data sessions) alongside current active inputs. It achieves a highly fluid user experience through vertical swipe gesture expansions, utilizing an intelligent multi-stage routing path determined by the density of the current session's content.

### Key Features
- **Adaptive Multi-Stage Expansion**: Intelligently switches between a 2-stage and 3-stage expansion trajectory based on the amount of current session data (determined by a 5-item `chipsList` threshold).
- **Interactive History Panel**: Supports rendering a scrollable list of current session chips (`CoreCalculatorChip`) and previous session histories (`CoreHistorySessionData`).
- **Rich State Management**: Natively supports `isTyping` indicators, comprehensive error states (`hasError`, `errorMessage`, `errorTitle`), and contextual dependent keys (e.g., displaying "O.C: 16in" adjacent to the main value).
- **Haptic Feedback Integration**: Provides subtle physical cues (`HapticFeedback.lightImpact`/`mediumImpact`) as the user crosses different expansion thresholds.
- **Stage Callback Hooks**: Exposes `onStageChanged` to seamlessly synchronize and drive external spatial animations.

---

## Usage Example

The component is highly customizable and pairs perfectly with a state management solution (e.g., BLoC) and a paired keyboard component.

```dart
import 'package:ripplearc_coreui/ripplearc_coreui.dart';

CoreDisplayArea(
  label: 'Length',
  value: '16ft 14in',
  isTyping: false,
  dependentKeyLabel: 'O.C',
  dependentKeyValue: '16in',
  onPressedDependentKey: () => print('Dependent key tapped!'),
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
| `historyPlaceholder` | `String` | `'Here will show what you type'` | Text displayed in the history panel when `chipsList` is empty. **TODO: [CA-654]** https://ripplearc.youtrack.cloud/issue/CA-654/Display-Area-Parameterize-Hardcoded-i18n-Strings-in-historyPlaceholder-and-closeSemanticLabel. |

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
| `onPressedDependentKey` | `VoidCallback?` | `null` | Action fired when the dependent key button is tapped. |

### Dependent Key Properties
Designed for secondary, context-specific buttons securely attached beneath the main value.
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `dependentKeyLabel` | `String` | `''` | The descriptive prefix label of the dependent key. |
| `dependentKeyValue` | `String` | `''` | The dynamic value of the dependent key (e.g., '16in'). |

### Accessibility
| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `closeSemanticLabel` | `String` | `'Close'` | The semantic label announced by screen readers for the close icon. **TODO: [CA-XXX]** Parameterize this hardcoded default. Ensure you pass a localized string in production. |

---
*Architectural Note: `CoreDisplayArea` heavily utilizes `AnimatedSize` aligned to `Alignment.topCenter` for its fluid layout transitions and relies on a deliberately calibrated swipe velocity threshold (`80px/sec`) to ensure intention-driven gestures without accidental triggers.*
