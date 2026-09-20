# 12 --- Pixel Car Racer

## Why this game is in the top 25

Primary domain: **mobile**. Highest-value extraction: **Small-screen
engineering, clutch/manual-shift controls**.

## Canonical interaction sequence

  Stage                    Observed/target pattern
  ------------------------ -------------------------------------
  Player intent            Build/tune/test on phone
  Screen state             compact garage/dyno
  Input                    tap parts/gearing and race controls
  Selection feedback       large touch feedback + graphs
  Mechanical operation     install/tune
  Simulation consequence   powerband/shift behavior changes
  Testing                  burnout/drag pass
  Persistence              build/currency/tune persist

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

Record exact path from modification to proof: burnout/drag pass. Count
transitions/taps/clicks and identify avoidable friction.

### S6 --- Persistence

Record what survives leaving the screen, returning to garage, restarting
an event, save/reload and application relaunch: build/currency/tune
persist.

## WTRL implementation translation

**Canonical truth owner:** WTRLCore subsystem appropriate to `mobile`.

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
`Build/tune/test on phone` and reach `burnout/drag pass` without
encountering an inert control or losing the changed state.

## WTRL prototype to derive

Small-screen engineering, clutch/manual-shift controls.

### Video evidence

A long-form minimally edited source still needs to be selected and
frame-reviewed. This is recorded as `SOURCE_SELECTION_REQUIRED`, not
treated as missing research evidence for the high-level pattern.

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
