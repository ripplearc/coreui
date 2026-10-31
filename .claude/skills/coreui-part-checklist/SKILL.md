---
name: coreui-part-checklist
description: |
  Check a coreui part before you open its PR: the pressed and focused looks,
  a coloured parent, large text, tap size, the end of each action, and one
  golden per state. These are the states a resting golden never shows, and
  where most review blockers on coreui came from.

  Trigger: "check this part", "coreui checklist", "before I open the PR",
  "does it pass the part checklist", any new or changed widget under
  lib/src/components/.
disable-model-invocation: false
---

# coreui part checklist

A golden shows a part at rest. It does not show the part pressed, focused,
in large text, or inside a coloured box. In the 24 October 2026 review of
#233 to #248, almost every blocker was in one of those states. The parts
matched the library at rest.

Run all 6 checks on every part the PR adds or changes, before you open the
PR. Each check has a test recipe in `references/test-recipes.md`. Add those
tests to the PR. They stay, so a later change cannot break the state without
a test failing.

Source: the reviewers' checklist,
https://ripplearc-design.pages.dev/shared/coreui-part-checklist-2026-10-24.html

## The 6 checks

### 1. Pressed and focused looks

Press the part, and move to it with Tab. The look must change, and it must
match the library's Pressed and Focused states.

- The tint stays inside the visible shape. It must not fill the whole 48 dp
  touch area around a 32 dp pill (#236, #237).
- An `InkWell` paints on the nearest `Material` *behind* its child. An
  opaque fill on the child (a filled text field, an `AnimatedContainer`
  colour) hides the ink completely (#242, #244). Put a transparent
  `Material` and the `InkWell` *inside* the fill, or draw the state look
  yourself.
- A `GestureDetector` has no focus and no press look. Use `InkWell`,
  `FocusableActionDetector` or a button.

### 2. A coloured parent

Put the part inside `Container(color: …)`, and inside a white `Container`.

- `Ink` does not paint itself. It paints on the nearest `Material` above it.
  Inside a coloured `Container` the fill disappears behind the colour; with
  no `Material` above it at all, the app throws "No Material widget found"
  (#236, #237).
- Fix: give the part its own `Material(type: MaterialType.transparency)`
  around the `Ink`.

### 3. Large text

Try text scale 1.5 and 2.0.

- A label must not slide under an icon (#233), and must not be cut.
- Heights are minimums (`BoxConstraints(minHeight: …)`), never fixed, so a
  part grows with its text. A fixed 32 dp pill cut the filter chip label at
  2.0 (#236).

### 4. Tap size

Every tap target is at least 48 × 48 dp. Measure it in a test of your own:
the shared tap-size guideline skips parts inside a scroll view (#234).

- Keep the library look and add the touch area around it: a 32 dp segment
  inside a 48 dp hit box, `HitTestBehavior.opaque`.

### 5. The end of each action

Follow each callback to its end. Check what closes, where focus goes, and
that every flag resets.

- A toast's "View" opened a page, and the default close then popped that
  new page (#235). The default close must close only the toast.
- A "move focus after a clear" flag was never reset, so focus jumped again
  on a later clear from another control (#238).
- Test each callback **twice**. The second run catches a flag that never
  resets.

### 6. A golden for each state

One golden per state the library draws: rest, pressed, focused, disabled,
in light and dark. Look at every golden you regenerate before you commit it.

## Run the probe first

`scripts/checklist_probe.dart.tmpl` measures checks 1 to 4 for a list of
parts in one run. It prints, per part: the tap target sizes, how many pixels
change on press and on Tab and inside which box, whether a coloured parent
changes the part, whether it throws without a `Material`, and at 1.5 and 2.0
text whether a label is cut or overlaps an icon.

```sh
.claude/skills/coreui-part-checklist/scripts/run_probe.sh \
  "CoreFilterChip(label: 'Tags', onTap: () {})" \
  "CoreSwitch(value: true, onChanged: (_) {})"
```

Read the output like this:

| Line | Pass | Fail |
|---|---|---|
| `tap targets` | every entry ≥ 48x48 | any side < 48 |
| `PRESS` / `TAB1` | pixels change, box inside the part | `NO CHANGE`, or a box larger than the visible shape |
| `COLOURED PARENT` | `NO CHANGE` | any change: a fill vanished |
| `NO MATERIAL` | `ok` | an exception |
| `TEXT x1.5` / `x2.0` | no overlaps, nothing cut | `overlaps` > 0, or a `CUT` line |

The probe uses the test block font, so text is black boxes; sizes are still
right. It writes pictures of each state to `$PROBE_OUT` (default `/tmp`);
look at them. The script deletes the probe file afterwards. Never commit it.

The probe finds problems. It does not replace the tests: write the recipe
tests for each check and keep them in the PR.

## Also check before the PR

These came up in the same review rounds:

- **Measure against the library node.** Read sizes and colours from the
  Figma library part (not a screen frame that uses it) and cite its node id
  in the doc comment or the component `.md`. File key:
  `vugaGpii5HfgEQHPbrS3mU`.
- **4 px grid.** Spacing uses `CoreSpacing` steps (multiples of 4). Icon and
  dot sizes use `CoreIconSize`. There are no off-grid px tokens.
- **Borders add height.** A 1 dp border adds 2 dp to a box. A 48 dp row with
  a bottom line inside it needs 12 / 11 padding, not 12 / 12.
- **Version.** Pick a `pubspec.yaml` version no other open PR uses:
  `gh pr list --state open` and read each branch's `pubspec.yaml`.
- **Lock file.** `flutter test` and `flutter analyze` rewrite
  `example/pubspec.lock`. Do not commit that change.
- **CHANGELOG and the component `.md`** describe every state you changed.
