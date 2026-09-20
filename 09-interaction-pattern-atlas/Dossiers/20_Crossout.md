# 20 --- Crossout

## Why this game is in the top 25

Primary domain: **construction**. Highest-value extraction: **Packaging,
attachment points, placement consequence**.

## Canonical interaction sequence

  Stage                    Observed/target pattern
  ------------------------ ---------------------------------------
  Player intent            Build a functional vehicle physically
  Screen state             garage builder
  Input                    place/move parts on attachment grid
  Selection feedback       snap/validity/mass/power feedback
  Mechanical operation     assemble modules
  Simulation consequence   mass/shape/function change
  Testing                  test/combat
  Persistence              blueprint/build persists

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

Record exact path from modification to proof: test/combat. Count
transitions/taps/clicks and identify avoidable friction.

### S6 --- Persistence

Record what survives leaving the screen, returning to garage, restarting
an event, save/reload and application relaunch: blueprint/build
persists.

## WTRL implementation translation

**Canonical truth owner:** WTRLCore subsystem appropriate to
`construction`.

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
`Build a functional vehicle physically` and reach `test/combat` without
encountering an inert control or losing the changed state.

## WTRL prototype to derive

Packaging, attachment points, placement consequence.

### Video evidence

**Selected video:** Official Crossout Tutorials: Car Building Tips
**URL:** https://www.youtube.com/watch?v=vf598wMBYzA **Timestamp
status:** Official tutorial search result verified

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
