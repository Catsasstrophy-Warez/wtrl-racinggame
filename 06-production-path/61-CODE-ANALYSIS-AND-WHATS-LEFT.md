# Code Analysis and What's Left, Current as of Unity Actually Running

**What this is.** Two things done together because they inform each
other: a full pass through all 15 C# files looking for real bugs, not
just structural consistency (the last audit's scope), and an honest
"what's left" inventory updated for the first time since Unity
actually started compiling and driving this project.

---

# PART 1 — Full code analysis: one real bug, two false alarms, one honest stub

**Method**: checked every division operation across all 15 files for
zero-denominator risk, since that's the class of bug static
consistency-checking (the `58` audit) doesn't catch — it's a runtime
logic error, not a missing or duplicate type definition.

## 1.1 The real bug, found and fixed

**`DiagnosticSkill.cs`'s `MentorPreemptionFactor01`** divided by three
threshold fields — `inspectionDepthThreshold`, `telemetryDepthThreshold`,
`dynoDepthThreshold` — with zero guard against any of them being set to
0 in the Inspector, where all three are public and editable. A zero
threshold would have produced Infinity or NaN feeding into
`Mathf.Clamp01()`, which doesn't reliably clamp NaN back to a valid
range across all Unity versions. **Fixed**: each division now checks
`threshold > 0` first, matching the guard pattern already used
correctly elsewhere in the codebase.

## 1.2 Two false alarms, checked and confirmed safe

**`ReputationTraits.cs`'s `HasReadsACarFastTrait`** divides by
`totalEventsCompleted`, which looked identical to the bug above at
first glance. Checked the actual surrounding code before assuming:
`totalEventsCompleted > 0 &&` already guards it via short-circuit
evaluation. Written safely from the start.

**`BuildRecipe.cs`'s `SatisfiesTarget`** divides by `currentPowerHp`.
Also already guarded — `currentPowerHp > 0f ? ... : float.MaxValue`.

**Worth stating plainly**: two of three identical-looking risks were
already handled correctly. The value of checking all three wasn't
finding three bugs — it was not assuming the pattern held everywhere
just because it failed once.

## 1.3 One honest stub, not a bug — a real "what's left" item instead

**`ActionSystems.cs`'s `StuntSystem.WithinProximityOfHazard()`**
returns `true` unconditionally, with its own comment already stating
plainly that it's a placeholder needing a real proximity raycast
against scene geometry. **Not fixed here, because it can't be** — this
requires an actual Unity scene with real colliders to query, which
doesn't exist in a code-only pass. Moved to Part 2 below as a concrete
near-term task instead of left as an easily-missed code comment.

## 1.4 What wasn't found

No other division risks, no null-reference risks on the public methods
checked, no logic errors in `PursuitEscapeEvent.Tick()`'s timer
handling (the sustained-hold reset for the Pursuit variant works
correctly — checked directly against the stated intent in its own
comment) or `NitrousSystem.Update()`'s drain logic.

---

# PART 2 — What's actually left, current as of this session

## 2.1 The live build status, as of the last confirmed report

| Check | Status |
|---|---|
| Compiles | ✅ Confirmed |
| Drives | ✅ Confirmed |
| Tire deformation reads correctly | ⏳ Not yet specifically checked |
| Differential change: curve + benchmark move | ⏳ Not yet run |
| Differential change: felt through tilt | ⏳ **Still the one open line the whole package has been built around** |

**Two of five.** Unchanged since `code/prototype/RVP-TRIAGE.md`'s
status table was last updated — nothing in this session's code
analysis moves any of these rows, since a code review can't answer a
question only a device can.

## 2.2 Concrete implementation tasks, not design gaps

Everything in this section has a real, fully-specified answer already
written down — these are "open the editor and do it" tasks, not "figure
out what to do" tasks:

- **`StuntSystem`'s proximity check** (§1.3 above) — needs a real
  raycast or trigger-collider check against wall/rival tags, once a
  scene exists to test it against.
- **Now automated**: `code/prototype/Editor/GenerateContentAssets.cs` —
  a Unity Editor script (`Tools > Racing Game > Generate All Remaining
  Content Assets`) that batch-creates every remaining `EngineVariant`,
  `TransmissionSpec`, and `RivalAI` asset from the exact data below,
  re-verified against source before being written into the script
  rather than trusted from memory. Safe to re-run — existing assets are
  skipped, never overwritten.
- **Unity asset creation** for the fully-specified data that's never
  been instantiated as actual ScriptableObjects — the remaining six
  hero-car generations' `EngineVariant`/`TransmissionSpec` pairs
  (`06-production-path/43-FIRST-PLAYABLE-SPECS.md` has 1965 done;
  `04-vehicle-and-drivetrain-research/`... — real numbers for the
  other six are in `05-specifications/47-PARTS-PRICING.md`), the five
  remaining rivals' `RivalAI` ceiling values (`07-content-resolution/
  52-CONTENT-RESOLUTION-PASS-1.md` Part 1 has all six specified;
  Marsh's was walked through as an example two turns ago), and the
  thirty-five `BuildRecipe` assets specified across
  `07-content-resolution/56` and `57`.
- **The Bump variant of the tire shader** — `Tire-URP.shader`'s own
  porting note at the bottom already specifies exactly what's needed
  (occlusion map, normal map, tangent-space basis); the base variant's
  deformation function needs no changes since it's identical between
  the two originals.

## 2.3 What's genuinely still open at the design layer

Checked against every prior audit rather than assumed clean:

- **2022 manual transmission's finalDriveRatio** and the **10-speed
  automatic's reverse/final-drive figures beyond what's already
  sourced** — minor, bounded gaps already flagged honestly in `47`,
  not resolved since.
- **`ReputationTraits.cs`'s running-average recency-weighting** —
  flagged as a real option in `60-FORZA-DEEP-ANALYSIS.md` §3.2,
  deliberately not built, since nothing yet requires it.

## 2.4 What's fully closed, confirmed again rather than assumed

All seven hero-car generations' data (sourced, not yet instantiated —
see §2.2). All six rivals' AI tuning data (same status). All four race
formats with concrete instances. All four road courses. Named drag
strip and oval facilities. The full 35-recipe trim-ladder set. Passive
income, checked against three independent genre sources and holding.
The RPG and action pillar code, now with one real bug fewer than it
had this morning.

---

# Cross-references
- The live status table this doesn't change → `code/prototype/RVP-TRIAGE.md`
- The stub this documents rather than fixes → `code/prototype/ActionSystems.cs`
- The fix applied → `code/prototype/DiagnosticSkill.cs`
- Where the remaining data lives, ready to instantiate → `05-specifications/47-PARTS-PRICING.md`, `07-content-resolution/52` through `57`
- The prior code audit this extends → `06-production-path/58-TEST-EVALUATION-PASS.md`
