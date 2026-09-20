# Prototype: RVP Triage, Dyno, Instability Meter, and Numerical Validation

**Steps 1, 2, and 3 of the plan in `README.md`'s "next step" section, plus a
numerical validation pass this document previously didn't mention at all —
the same gap `VERSION.md` had, fixed at the same time.**

## Step 1 — RVP triage (done, with real numbers)

`RVP-TRIAGE.md` — the repository was actually cloned and inspected, not
estimated. 27 deprecated API sites across 13 files, all mechanical; a tested
migration script (`migrate-to-unity6.sh`) that applies and verifies them —
plus `migrate-to-unity6.ps1`, a PowerShell port for Windows machines without
Git Bash/WSL. **The PowerShell version has not been run anywhere in this
project**, unlike the tested bash original — prefer Git Bash running the
`.sh` script when either is available (`46-TONIGHT-BUILD-SESSION.md`
Step 1). And
a working URP replacement for the tire shader (`Tire-URP.shader`) once the
custom logic turned out to be one small vertex-deformation trick rather than
a large rewrite. Read `RVP-TRIAGE.md` first — it tells you exactly what's
still unknown (whether the physics feels good after the port) versus what's
now confirmed (the mechanical porting cost).

## Steps 2 and 3 — dyno and instability meter

Four C# files:

| File | Implements |
|---|---|
| `TireForceModel.cs` | Beckman's three-parameter tyre formula (`34` Part 1d, Part 29) with proper combined-slip handling (Parts 24–25) |
| `RaggedEdgeMeter.cs` | The instability meter — traction-circle fill level plus the `\|a_y − v·ψ̇\| > ε` oversteer trigger (`20` §1, `35` §3.1) |
| `DynoController.cs` | The dyno itself (`31` §6) — reads the live torque curve, exposes chart data, computes a CSR2-style RK4 benchmark |
| `StaticWeightTransfer.cs` | Beckman's closed-form four-corner solution (`34` Part 1e, Part 27), as a **cross-check tool**, not the primary load model |

---

## Status: written and reviewed, not compiled

**I do not have Unity available in this environment**, so this code has been
written carefully against TORSION's real interfaces (`Engine`, `Wheel`,
`Differential` — inspected directly from `code/TORSION-MIT/`) and reasoned
through line by line, but **it has not been compiled or run.** Treat it as a
strong first draft to paste in and iterate on, not a finished, tested
deliverable.

**One assumption you should verify before trusting `DynoController`**:
`GetTorqueCurveSample()` assumes `Engine.torqueCurve`'s X-axis is RPM and
Y-axis is torque in Nm — the conventional layout, but not confirmed against
`Engine.UpdatePhysics()`'s actual internals, which weren't fully visible when
this was written. If your build samples the curve differently, that one
method is the only place to change; everything downstream treats its output
as ground truth and doesn't need to know how it was produced.

---

## Step 3b — engine family/variant model, and engine bay mesh merging

Two more files, implementing the three findings from
`39-MECHANIC-GAMES-SPECTRUM.md`:

**`EngineFamily.cs` / `EngineVariant.cs`** — the family/variant data model
confirmed three independent times (real Ford history, CMS, Automation).
`EngineFamily` is the fixed architecture (firing order, valve type, block
material); `EngineVariant` is a specific tune within it, one per hero-car
generation. Five of the seven generations should be variants of one
family; the last two, a second family — matching `37-FORD-V8-AUDIO.md`'s
finding directly. `EngineVariant.ApplyToEngine()` is the actual point
where this meets TORSION's real `Engine` component (`torqueCurve`,
`redlineRPM`, both confirmed fields).

**`EngineBayMeshManager.cs`** — the fix for Automation's own measured
draw-call problem (nearly 3× render events from an unmerged engine).
Individual part meshes only stay separate while an installation sequence
is actively playing (`25` Part 6); `MergeForNormalRendering()` combines
them into one mesh for every other context. Call
`PrepareForInstallationSequence()` before a sequence plays and
`MergeForNormalRendering()` when it ends or is skipped.

## Step 3c — forced induction, crank type, transmissions

Real history, not invented range: `40-FORCED-INDUCTION-DRIVETRAIN.md`.
Superchargers period-correct from generation one (a real 1965-72
dealer-adjacent Paxton-equivalent option); turbocharging as the honest
aftermarket-only gap the real lineage actually has; flat-plane crank as a
rare top-tier variant inside the final engine family, not a new family
(real flat-plane heads run on real cross-plane bottom ends); automatic
transmissions spanning a genuine 3->10 speed progression across the
seven generations, sourced from real Ford transmission history.

**`EngineFamily.cs` extended**: `EngineVariant` now carries `crankType`
(CrossPlane/FlatPlane, variant-level, matching the real Voodoo case),
`forcedInduction` (None/PeriodSupercharger/ModernSupercharger/
AftermarketTurbo), and intercooler/BOV flags as properties of the
induction choice rather than separate parts.

**`TransmissionSpec.cs`** — new, structurally parallel to `EngineVariant`.
Speed count, per-gear ratio array (populate from real reference data or
use as a plausible starting point), final drive, and a top-trim
exclusivity flag matching the real GT500-equivalent case (supercharged
engine, 7-speed DCT only, no manual offered).

## Step 3d — RPG and action pillar code, closing the design/implementation gap

Seven more files, closing a real gap found during a research-vs-
current-state audit: `48`, `49`, and `50` were fully specified with
zero code behind any of it, unlike the sim pillar's seven files.

**`RivalAI.cs`** — the four intimidation parameters from `32` S5.3,
specified in detail but never implemented until now. Foundational: the
new reputation/traits code below has nothing to modify without it.

**`BuildRecipe.cs`**, **`PartsGating.cs`** (`ClassBracket` + reputation
tiers), **`DriverProgression.cs`** (`SafetyRating` + `DriverLicense`) —
`48` and `49`'s RPG systems. One real bug caught and fixed during
writing: `BuildRecipe.cs` initially referenced `ClassBracket` as an
instance type before `PartsGating.cs` (written right after) defined it
as a static class — caught by cross-checking rather than assuming the
first draft compiled cleanly, same discipline as everywhere else in
this package.

**`DiagnosticSkill.cs`**, **`ReputationTraits.cs`** — the mentor-
commentary connection from `49` S2.3 is real here: `MentorPreemptionFactor01`
is an actual computed value, not a design note.

**`ActionSystems.cs`** — `AggressionEconomy`, `NitrousSystem` (raises
the traction ceiling the same way `DynoController.cs` computes drive
force, not a flat speed multiplier), `StuntSystem` (close calls reuse
`RaggedEdgeMeter.fillLevel01` directly rather than duplicating it), and
`PursuitEscapeEvent`.

**Same status as everything else in this codebase**: written and
cross-checked for internal consistency, not compiled in a real Unity
project.

## Step 4 — numerical validation (done, without Unity)

`simulation/` — the exact formulas from `TireForceModel.cs` and the RK4
integrator from `DynoController.cs`, ported to Python and **actually run**,
not just reviewed. Five scripts:

| File | What it does |
|---|---|
| `tire_model.py` | The tyre model port, sanity-checked against Beckman's own worked numbers (`34` Part 1d) |
| `weight_transfer.py` | Simplified single-axle load transfer, used by the tests below |
| `differential_test.py` | Open vs. locked differential — the actual pass-condition test |
| `rk4_benchmark.py` | The RK4 integrator, extended to accept the differential test's force output |
| `ragged_edge_test.py` | The instability meter, swept across a corner at increasing speed |
| `make_chart.py` | Generates `simulation_results.png` from all of the above |

**Results:** an open vs. locked differential produces a **71% difference in
available corner-exit force at 0.7g lateral load**, converting to a
**2.32-second (43%) difference in time to reach corner-exit speed** — the
same car, same driver input, one differential setting changed. This is a
real, numerical confirmation of the pass condition's first two criteria
(§"The actual acceptance test" below), for this project's own code, not a
generic claim about differentials in general.

**It also found a real bug.** Running the shipped lateral tyre defaults
(`latA=0.5, latB=10.0, latP=1.8`) through an actual scenario revealed an
implied peak friction coefficient of **~8.9** — physically impossible; real
tyres run roughly 1.0–1.7. The C#'s own comments already flagged these as
placeholders needing calibration, but nobody had run the numbers until the
simulation did. **Fixed in `TireForceModel.cs`** (`latB` recalibrated to
`1.35`, giving mu≈1.2), with the finding documented inline in the source so
it doesn't get silently reintroduced.

**Run it yourself:** `cd code/prototype/simulation && python3 make_chart.py`
— needs `numpy` and `matplotlib`, nothing else. Each script also runs
standalone and prints its own results.

## Step 5 — racing-line optimizer attempt (partial, honestly reported)

`RACING-LINE-ATTEMPT.md` — an attempt to build the AI-waypoint-generation
capability flagged in `04-EXTRACTION-INVENTORY.md`. Two approaches tried,
six real findings, and a clearly-marked boundary between what's trustworthy
and what isn't:

- **Reproducing Beckman's exact Part 18 numbers**: failed. Three real bugs
  found and fixed, but no spreadsheet exists for this article to validate
  against (unlike Part 26's `phors26.xls`) — every number this approach
  produces is a reconstruction, not a transcription, and shouldn't be
  trusted.
- **A from-first-principles alternative** (`velocity_profile.py`): the
  standard forward/backward velocity-profile method, using this project's
  own validated tyre model. **Works correctly and is structurally validated
  for wide corners (r ≳ 167ft in the test geometry). Has a known, explained
  limitation for tight corners** — a path-length simplification that's
  clearly flagged in the script's own output, not hidden.

**Read `RACING-LINE-ATTEMPT.md` before using either script** — it tells you
exactly which numbers to trust and which to ignore.

## Wiring it up

### 1. Create tyre compound assets
Right-click in the Project window → `Create → Vehicle → Tire Force Model
(Beckman)`. Start from Beckman's own longitudinal reference fit
(A=9.625, B=31.0, P=2.375) as a sanity check, then use the
`FindPeakSlipRatio` / `FindPeakSlipAngleDeg` context-menu action once you've
fitted your own A/B/P to RVP's authored curves or real data (`31` §6.2).

### 2. The consistency requirement — read this before wiring anything else
**The dyno, the instability meter, and the car's actual driving must all
read the same tyre model.** If RVP's wheels compute `fX`/`fY` from their own
separate friction curves while `RaggedEdgeMeter` and `DynoController` ask a
different `TireForceModel` for the ceiling, you reproduce the exact failure
`31` §2.3 documents: Underground 2's stock differential reading as fastest
"even though it doesn't make sense," because the tuning layer and the
driving layer disagreed.

**Two ways to satisfy this, pick one:**
- Wire RVP's per-wheel force computation to call `TireForceModel.Combined()`
  directly, replacing its own authored curves.
- Or keep RVP's curves as the source of truth, and set each
  `TireForceModel`'s A/B/P (via the peak-finding tools) to match what RVP
  already produces, so the *ceiling estimate* agrees even though the forces
  themselves come from RVP.

### 3. Add `RaggedEdgeMeter` to the car
- `vehicleBody` → the car's `Rigidbody`
- `wheels` → all four RVP `Wheel` components
- `tireModel` → the same asset from step 2
- Subscribe to `OnLostControl` for whatever should happen at the moment of
  an actual spin — camera shake, the mentor's voice line (`30` §1.3), the
  three-tyre-sound audio crossfade snapping to "squall" (`10` §4)
- `fillLevel01` is the number to drive the visual meter and the continuous
  audio crossfade

### 4. Add `DynoController` to the garage's dyno station
- `engine` → the car's `Engine` component
- `tireModel` → the same asset again
- Fill in the vehicle mass, drag, and drivetrain fields from the car's
  actual spec
- Call `GetTorqueCurvePoints()` for the chart UI (`31` §6.2 — Underground
  2's bar-graph-by-RPM interface is still the reference for presentation)
- Call `RunStraightLineBenchmark()` for the CSR2-style number — display it
  next to the player's actual best time, and let the gap be the story
  (`31` §4.2)

### 5. `StaticWeightTransfer` — use only as a cross-check
Not wired into anything by default. Call `Compute()` with the car's real
geometry to get a static, level-ground four-corner load prediction, and
compare it against what the suspension-compression method produces at rest.
If they disagree significantly at zero speed and zero lateral/longitudinal
force, something in the suspension setup is wrong — that's what this file is
for catching.

---

## The actual acceptance test

Everything above exists to pass one test, stated in `31-DYNO-ANALYSIS.md`
Part 7 and repeated in `11-SYSTEMS-SPEC.md` §2.1/§2.3:

> **Change one differential setting. The curve moves visibly. The lap time
> moves measurably. The player feels it through tilt.**
>
> **All three, or the premise does not hold.**

**And measure it warm** — after ten minutes of continuous play on a real
device, not cold in the editor (`34` Part 1c, Finding 2). Thermal throttling
degrades the physics itself, not just frame rate: if the differential change
is perceptible at minute one and gone by minute twelve, you have not passed.

ProStreet had the first of the three. Underground 2 had the second. Nobody
in this research had the third. That's the one this code can't verify for
you — only a phone in your hand can.
