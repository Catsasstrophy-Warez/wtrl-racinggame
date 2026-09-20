# 19 --- Mad Max

## Why this game is in the top 25

Primary domain: **visual-build**. Highest-value extraction: **Visible
evolution, recipe builds, consequence preview**.

## Canonical interaction sequence

  Stage                    Observed/target pattern
  ------------------------ ----------------------------------------
  Player intent            Evolve a named vehicle configuration
  Screen state             garage/Magnum Opus
  Input                    select body/engine/armor/weapons
  Selection feedback       visual/stat/requirement preview
  Mechanical operation     fit upgrade
  Simulation consequence   appearance/capability/tradeoffs change
  Testing                  drive/combat
  Persistence              vehicle progression persists

## Screen-by-screen forensic decomposition

### S0 --- Orientation

Record camera framing, vehicle prominence, persistent HUD, current task,
currency/resources, warnings, navigation exits and whether the player
can understand the next meaningful action without opening a manual.

### S1 --- Target acquisition

Record how the player identifies the car, assembly, component, setup
category or event. Capture hover/selection states, occlusion handling,
zoom, focus transitions and invalid targets.

### S2 --- Action selection

Record contextual menus, radial actions, tool selection, tabs, sliders,
steppers, drag gestures, controller bindings and touch hit-target size.

### S3 --- Operation

Record the complete manipulation, not merely its result: animation, tool
pose, fastener/part movement, numeric adjustment, placement snapping,
confirmation, prerequisites and cancellation.

### S4 --- Consequence feedback

Record what changes immediately in the world, HUD, graph, sound,
animation or handling. Separate **previewed consequence** from
**simulated consequence**.

### S5 --- Test loop

Record exact path from modification to proof: drive/combat. Count
transitions/taps/clicks and identify avoidable friction.

### S6 --- Persistence

Record what survives leaving the screen, returning to garage, restarting
an event, save/reload and application relaunch: vehicle progression
persists.

## WTRL implementation translation

**Canonical truth owner:** WTRLCore subsystem appropriate to
`visual-build`.

**RealityKit responsibility:** represent physical/spatial state only
where useful; never become a second mechanical truth.

**SwiftUI responsibility:** progressive disclosure, expert data,
comparison, navigation and accessibility.

**Required feedback contract:** selection must have a visible state;
invalid operations explain why; completed operations must expose a
measurable state change.

**Deterministic acceptance test:** Given a fixed initial snapshot and
fixed input/action sequence, assert the resulting canonical state and
persistence payload.

**Player-facing acceptance test:** The player can complete
`Evolve a named vehicle configuration` and reach `drive/combat` without
encountering an inert control or losing the changed state.

## WTRL prototype to derive

Visible evolution, recipe builds, consequence preview.

### Video evidence

**Selected video:** Customize Upgrade Magnum Opus Vehicle **URL:**
https://www.youtube.com/watch?v=dVhLn7_kWB8 **Timestamp status:** Search
result verified; non-verbal garage/customization walkthrough

Timestamp rows are intentionally left for frame verification rather than
guessed.

## Screenshot capture set

Capture 8 frames: orientation; target selection; action/tool selection;
operation-in-progress; consequence; engineering/detail view; test state;
post-test/persistence state.

## Forensic timestamp ledger

  Segment                Start   End Status
  -------------------- ------- ----- -----------------------
  Orientation              ---   --- FRAME_REVIEW_REQUIRED
  Selection                ---   --- FRAME_REVIEW_REQUIRED
  Operation                ---   --- FRAME_REVIEW_REQUIRED
  Consequence              ---   --- FRAME_REVIEW_REQUIRED
  Test                     ---   --- FRAME_REVIEW_REQUIRED
  Return/persistence       ---   --- FRAME_REVIEW_REQUIRED

## Anti-copy boundary

Extract interaction principles and causal structure only. Do not
reproduce proprietary art, UI trade dress, logos, text, sounds, branded
vehicle assets or distinctive screen composition.
