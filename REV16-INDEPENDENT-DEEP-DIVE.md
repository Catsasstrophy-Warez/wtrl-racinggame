# Rev16 — Independent Deep Dive

Second-opinion audit of `WrenchToRaceLegends_Unity6_Rev16_ProductTruthMobilePreflight.zip`,
run against source rather than against `CURRENT-PRODUCT-TRUTH.md` or
`REV16_VALIDATION_REPORT.md`. Analysed 2026-09-07, following the trail from
`REV14.1-INDEPENDENT-DEEP-DIVE.md` → `REV14.2-FIX-NOTES.md` →
`REV14.3-WIRING-NOTES.md` → `PRODUCTION-READINESS-REVIEW.md` → this.

Also covers, per request: a re-read of the 64-document research corpus for
new contradictions, and a reconciliation of every top-level status document
against what the Rev16 tree actually contains.

Unity 6000.0.58f2 is still not installed in this environment. Every claim
below is either a direct read of source (file:line, quoted) or an explicitly
labeled inference — the same discipline the prior three audits used.

---

## Headline finding

**Rev15 and Rev16 were built from a branch that predates the Rev14.2 and
Rev14.3 fix passes.** Every one of the ~47 findings those two passes fixed —
including the P0 bug that stops the first playable from ever starting a
race — is back in the Rev16 tree, verified by direct inspection of the same
files and line numbers the original findings named. `GarageOperationsService`
and `VehicleIntelligenceReset`, the two new files Rev14.3 built specifically
to wire nine dead save collections into real behaviour, do not exist in
Rev16 at all. The 28 tests those two passes added are also gone — Rev16's own
test count (93 EditMode) is 13 short of Rev14.3's 106, not ahead of it.

This is not a claim that Rev15/16's own work is bad — it isn't; see
"What Rev16 actually did well" below. It's that the fix/wiring work
represented in `archive/unity-revisions/Rev14.2-fixes/` and
`Rev14.3-fixes/` currently exists **only as patch files sitting next to the
project**, not in the project. Nothing in `CURRENT-PRODUCT-TRUTH.md`,
`README.md`, `VERSION.md`, or any Rev15/16 report mentions this — they read
as continuous forward progress from Rev14.1, which is only true for the
subsystems Rev15/16 touched directly (fuel, rival service, mobile input,
event preflight, `.meta` stability).

---

## 1. The regression, verified line by line

Method: for each fix described in `REV14.2-FIX-NOTES.md` and
`REV14.3-WIRING-NOTES.md`, the same file and the same code shape was located
in the extracted Rev16 tree
(`WrenchToRaceLegends_Unity6_Rev16_ProductTruthMobilePreflight.zip`) and
compared against what the fix note says it changed. The patch files in
`archive/unity-revisions/Rev14.2-fixes/*.patch` and `Rev14.3-fixes/*.patch`
were also checked to confirm the fixes were actually written (they were) —
ruling out "the fix note describes intent that was never coded."

| Finding | Fix note says | Rev16 tree actually has |
|---|---|---|
| **P0-1** (race can never start) | `AuthoredSpec` becomes a `[SerializeField]` backing field; runtime copy created only `if (Application.isPlaying)` | `Garage/VehicleMechanicalRuntime.cs:13` — `public VehicleSpec AuthoredSpec { get; private set; }`, a plain non-serialized auto-property. No `isPlaying` guard anywhere in the file. **Bug reproduced exactly as originally found.** |
| **P0-2** (edit-mode `Destroy` on a ScriptableObject) | Both files route through a helper that picks `DestroyImmediate` outside play mode | `VehicleMechanicalRuntime.cs:34,45` and `RivalCareerRuntime.cs:50,152` all call bare `Destroy(...)`, no play-mode branch. **Present.** |
| **H-1** (rival mass never reaches the rigidbody) | Mass written to spec *before* `ApplyRuntimeSpec` | `RivalCareerRuntime.cs:155` calls `ApplyRuntimeSpec` first, `:157` sets `massKg` after. **Original order restored — bug present.** |
| **H-2** (AI seed reproducibility) | `BeginRace(string raceId = null)` injectable | `RaceDirector.cs:46` — `public bool BeginRace()`, no parameter. **Reverted to fresh-GUID-per-race.** |
| **H-3** (second critical fault never recorded) | Tracks a bounded set of already-recorded signatures; adds `AcknowledgeAlert()` | `VehicleIntelligenceSystems.cs:663,742-743` — single `lastTriggerAlertSignature` field, `if (signature == lastTriggerAlertSignature) return;`. No `AcknowledgeAlert` method exists anywhere in the tree. **Present.** |
| **H-4** (one dead sensor kills baseline learning vehicle-wide) | Unavailable channels clear their alert before the `continue` | `VehicleIntelligenceSystems.cs:166` — `if (sensor == null || !sensor.available) continue;` still precedes `ClearAlert` at `:175`. **Present.** |
| **H-5** (baselines never decay) | `MaxEffectiveSamples = 3000` cap, `Reset()` hook | `ExtendedMechanicalSystems.cs` `SensorBaselineData` has no `MaxEffectiveSamples`, no `Reset()`. Unbounded Welford accumulator. **Present.** |
| **H-6** (repeated inspection converges on a confidently wrong number) | Bias salted with attempt index | `EngineeringSystems.cs:147` — `StableBias(component.componentInstanceId + "|" + method)`, no attempt-index salt. **Present.** |
| **H-7** (entry fee not refunded on async abort) | `AbortRace()`, `OnRaceState` treats `Inactive` mid-`FlowMode.Race` as an abort | `GameFlowController.cs` has no `AbortRace` method and no `pendingEntryFeeCents` reference. **Present.** |
| **M-9** (best-lap telemetry falls back to the whole buffer) | Flags `telemetryTruncated`, exposes `HasUsableTelemetry` | `RivalCareerRuntime.cs:273` — `if (bestLapFrames.Count == 0) bestLapFrames.AddRange(frames);`, no truncation flag. **Present.** |
| **M-11** (problem-board entries never retire) | `RetireSolvedProblems()` called from the reset hook and on every hypothesis re-rank | `MarkSolved` (`EngineeringSystems.cs:202`) is called from exactly one place in the whole tree: `Rev12MechanicalFoundationTests.cs:219`. **Still never called from game code.** |
| **Rev14.3 wiring** (fitment enforcement, workshop capability, inspection/scrutineering/logistics, dossier, problem board — the entire pass) | New `Garage/GarageOperationsService.cs`, `Garage/VehicleIntelligenceReset.cs` | Neither file exists anywhere in the Rev16 zip. `find . -iname "GarageOperationsService.cs"` and `-iname "VehicleIntelligenceReset.cs"` both return nothing. **The entire pass is absent, not partially reverted.** |

Not reverted — genuinely still present and correct:

- **Rev16's own fix**, the `evt`-out-of-scope compile risk in
  `Rev10FirstPlayableBuilder.BuildScene()` — `Editor/Rev10FirstPlayableBuilder.cs:315`
  now loads the event asset inside `BuildScene()` itself. This is real, new,
  and unrelated to the Rev14.2/14.3 fixes (it's a bug introduced later, by the
  event-preflight work, and fixed in the same revision that introduced it).
- Code hygiene is still clean: 0 `TODO`/`FIXME`/`NotImplementedException`,
  0 empty `catch` blocks, 0 `DateTime.Parse`, no `.velocity`/`FindObjectOfType`
  API breakage — independently re-checked, not just taken from
  `REV16_VALIDATION_REPORT.md`.
- Rev16's own new test count (93 EditMode / 20 PlayMode) matches what's
  actually in the test files, counted directly by grepping `[Test]`/
  `[UnityTest]` attributes rather than trusting the declared number.

### Why this matters more than a missed patch

`CanBeginRace` (`RaceDirector.cs`) still hard-fails on a null spec, and P0-1
means the generated first playable still has one on reload — the same chain
`REV14.1-INDEPENDENT-DEEP-DIVE.md` traced in full (builder assigns a
`HideFlags.DontSave` copy in edit mode → Unity refuses to serialize it into
the scene → `spec == null` on both `Player` and `Rival_Marsh` → `CanBeginRace`
returns false on every attempt). Every Rev16 feature that assumes a race can
start — the mobile input scheme, the tilt calibration flow, event preflight,
fuel planning in a live race — is currently sitting on top of a first
playable that, per this same reasoning, cannot start. `UNITY-FIRST-OPEN.md`'s
own device-validation steps ("Tap CALIBRATE TILT", "compare two materially
different setups") assume a working race loop to validate against.

This has never been compiled, so "cannot start" is a static claim with the
same confidence level as the original P0-1 finding two revisions ago — not a
measured fact. But it was a correct static claim then, and nothing in the
diff between then and now changes the reasoning.

---

## 2. What Rev16 (and Rev15) actually did well

Worth stating with the same specificity as the regression, because it's real
work and it's not what the headline finding is about:

- **Fuel is a genuine new system, not a stub.** `VehicleFuelRuntime` /
  `FuelStrategyService` derive consumption from actual engine power via BSFC,
  adjust rigidbody mass from fuel load, and feed low-fuel effects back into
  torque and fuel-pressure sensing. This is real physics-adjacent work, not a
  UI number.
- **Rival between-event repair strategy** (five doctrines, six rivals each
  authored distinctly, budget-constrained, idempotent, visible in dossier) is
  a legitimate expansion of the career layer and doesn't depend on anything
  that regressed.
- **Stable `.meta` GUIDs** (175, 0 missing, 0 duplicate — independently
  recounted and confirmed) close a real production gap: Rev14.1 shipped with
  zero committed `.meta` files, which would have re-GUID'd every asset on
  first import.
- **Mobile input abstraction** (tilt/touch/desktop schemes, calibration,
  deadzone, smoothing, a UI-agnostic touch bridge) is a coherent, sensibly
  layered addition, correctly labeled by its own docs as "instrumented
  pre-device check, not a claim about human feel."
- **`CURRENT-PRODUCT-TRUTH.md` is a good idea, executed honestly as far as it
  goes** — it's the first document in the project whose explicit job is to
  say what's real versus historical, and its own tyre-model and
  differential-model sections are accurate (see §4). Its blind spot is that
  it describes the tree it ships as a strict superset of Rev14.1, which by
  §1 above is not what shipped.
- **Assembly structure held steady**: still 12 assemblies, 0 cross-assembly
  cycles by the same check the Rev14.1 audit used, 0 duplicate type names.
  Adding fuel, rival service, mobile input, and event preflight without
  growing assembly count or introducing a cycle is a sign of a codebase
  that's still being extended deliberately rather than accreting.

---

## 3. Research corpus — re-read for new issues

The 64-document count (`README.md`, `VERSION.md`) is still accurate — recounted
directly, 64 files across the eight numbered folders. The corpus has not been
touched since 2026-09-04, so this is a re-verification of what
`WHERE-WE-ARE.md` already found, not new drift, plus two smaller items that
document's system-by-system pass didn't call out explicitly.

**Confirmed still open, unchanged since first flagged:**

- **The Constant vs. Marsh.** `06-production-path/43-FIRST-PLAYABLE-SPECS.md`
  Item 6/7 names **the Constant** as the outrun opponent specifically because
  his "consistent, unrattled driving makes the player's differential setting
  the actual variable under test." `07-content-resolution/51-CONTENT-INVENTORY.md`
  §1.2 confirms only **Marsh** has actually been run through that protocol.
  The Unity builder itself ships Marsh
  (`Rev10FirstPlayableBuilder.cs:322`, `"Rev10 Proving Ground Duel"`) — so this
  isn't two docs disagreeing about a plan, it's a spec whose stated reason for
  choosing an opponent was never implemented, silently, in favor of the one
  rival that happened to be available.
- **`51-CONTENT-INVENTORY.md` contradicts itself in one file.** Its own §1.3
  table says original road courses are "3 of 3 — closed," citing passes `53`
  and `54`. Six lines above that table, an inline "Update:" note — written
  after only `53` landed — says "the other two road-course briefs … remain
  open." The table was updated when the second and third pass closed; the
  prose note above it wasn't. A reader who stops at the note gets the wrong
  answer even though the correct answer is in the same file.

**New observation this pass:** the research corpus's own internal audit trail
(`61`, `62`, `63`, `51`–`57`) is more careful about marking things "closed on
paper vs. built" than the *Unity project's* own docs are about marking things
"fixed vs. reverted." `63-DANGLING-METHODS-FOLLOWUP.md` explicitly warns that
generated content "could be perfectly correct and never affect a single frame
of actual driving physics" — the research side has a name and a habit for
exactly the failure mode §1 of this document describes on the code side, but
that habit never made it into `CURRENT-PRODUCT-TRUTH.md` or the REV15/16
implementation reports, which have no equivalent "verified vs. assumed
carried-forward" distinction.

No other contradictions surfaced on this pass. The corpus remains what
`WHERE-WE-ARE.md` called it: "unusually good — sourced, self-correcting, and
willing to record its own negative results."

---

## 4. Status documents vs. the Rev16 tree

| Document | Still accurate? | Why |
|---|---|---|
| `WHERE-WE-ARE.md` (Rev14.1) | **Partially, for the wrong reason.** Its "two codebases" finding is more true now than when written — `Prototype~` is unchanged at 24 files, still excluded, and the tyre-model/differential gaps it describes are confirmed identical in Rev16 (§ below). But its 21-system table describes the Rev14.1 tree specifically; Rev15/16 added systems (fuel, event preflight) it never scored. |
| `FEATURE-LIST.md` (Rev14.2) | **Stale, and now in the wrong direction.** Its "~140 live" count and its Rev14.2/14.3 tags describe features that §1 shows are no longer in the tree it would be describing today. Re-deriving this table against Rev16 source is the single most useful housekeeping task left — done partially in §1/§5 here, not exhaustively. |
| `PRODUCTION-READINESS-REVIEW.md` (Rev14.3) | **Stale for the same reason, and its own top recommendation was skipped.** Its ranked five-move list led with "compile and run," second was "fix the non-atomic save write," third was "decide WTRL vs. Prototype vs. merge," fourth a diagnostics UI pass, fifth "port the tyre model." Rev15/16 did none of these five — not even the two-line save-write fix — and instead added scope elsewhere. |
| `REV14.1-INDEPENDENT-DEEP-DIVE.md` | **Still accurate as a description of Rev14.1**, and — per §1 — accurate again as a description of Rev16, which is the uncomfortable part: every P0/H/M finding in it currently reproduces against Rev16 source at the same file:line it originally named. |
| `CURRENT-PRODUCT-TRUTH.md` (Rev16) | **Accurate on what it explicitly commits to (tyre model, differential, controls, fuel), silent on what it doesn't mention.** It never asserts "Rev14.2/14.3 fixes are included," so it isn't technically contradicted by their absence — but a reader has no way to learn from this document that the first playable is back to not starting, and the document's framing ("Rev16 adds," never "Rev16 lost") implies pure accretion. |
| `README.md` / `VERSION.md` / `ROADMAP-REV15-FORWARD.md` (Rev16) | **Accurate about Rev16's own scope**, same caveat as above — none mention the fix passes at all, so there's nothing in them to contradict, but also nothing to warn a reader that two prior audits' worth of fixes need to be reapplied. |
| `PROJECT-BASELINE.md` | Archived last session as stale (pointed at a `Baseline/` folder that no longer exists). Nothing in this pass changes that. |

**The specific gap this creates**: there is currently no single document that
is honest about *both* directions at once — that Rev15/16 added real,
well-built features *and* that the tree lost two audit passes' worth of
fixes in the process. `WHERE-WE-ARE.md`/`FEATURE-LIST.md`/
`PRODUCTION-READINESS-REVIEW.md` know about the fixes but not about Rev16.
`CURRENT-PRODUCT-TRUTH.md`/Rev16's own reports know about Rev16 but not
about the fixes having existed and vanished. This document is the first one
that has read both sides.

---

## 5. Updated tyre-model / differential status (direct re-check)

Unchanged from Rev14.1 through Rev16 — re-verified against Rev16 source,
not assumed:

- `Vehicles/Runtime/VehicleController.cs:201` —
  `Vector2 combined = Vector2.ClampMagnitude(new Vector2(longitudinalDemand, lateralDemand), maxTireForce);`
  — the same saturating clamp. `CURRENT-PRODUCT-TRUTH.md` itself now states
  this plainly ("combined longitudinal/lateral tire-force clamp" under "Live
  production architecture," and RVP/TORSION explicitly demoted to
  research-only) — this is the one place a Rev16 doc is fully candid about a
  known gap rather than silent about it.
- No `differentialLock`, `diffPreload`, or equivalent anywhere in the
  compiled tree. Differential remains a torque-capacity category, not solver
  behaviour, exactly as `WHERE-WE-ARE.md` and
  `PRODUCTION-READINESS-REVIEW.md` described.
- `Prototype~/Physics/TireForceModel.cs` and `RaggedEdgeMeter.cs` are
  untouched — still 24 files in `Prototype~`, the same count at every
  revision since Rev14.1, meaning three full revisions (14.2, 14.3, 15) plus
  this one (16) have passed without anyone moving a single file across that
  boundary in either direction.

---

## 6. Recommended order (supersedes prior "next five moves" lists until acted on)

1. **Re-apply the Rev14.2 and Rev14.3 patches to the Rev15/16 branch, or
   re-derive them against current source if a straight `git apply` doesn't
   land cleanly.** The patch files already exist
   (`archive/unity-revisions/Rev14.2-fixes/*.patch`,
   `Rev14.3-fixes/*.patch`) — this is very likely hours, not days, since the
   fixes were already designed once against a closely related tree. This is
   now the single highest-leverage action available, ahead of anything in
   `PRODUCTION-READINESS-REVIEW.md`'s prior ranking, because it recovers
   ~47 already-solved findings for the cost of a merge rather than a
   re-investigation.
2. **Figure out why the branch diverged before Rev15**, before doing (1)
   blind. Two real possibilities: Rev15 was built from a Rev14.1 checkout
   that never had Rev14.2/14.3 applied (a branching/checkout mistake), or
   Rev14.2/14.3 were deliberately treated as exploratory and not merged
   forward (a decision this document can't see evidence of in any doc). The
   fix is the same either way, but the answer determines whether this needs
   a process change (e.g., "fix passes get merged before the next revision
   starts") to stop it happening a third time.
3. **Once (1) is done, everything in `PRODUCTION-READINESS-REVIEW.md`'s
   five-move list is live again** — compile and run, fix the non-atomic save
   write, decide WTRL vs. Prototype vs. merge, a diagnostics UI pass, port
   the tyre model behind a flag. None of that changes based on this audit.
4. **Settle the Constant-vs-Marsh conflict** (§3) — either update `43` to
   name Marsh as the actual outrun opponent, or build the Constant's
   generation and re-run the protocol. Cheap either way; currently a spec
   whose own stated rationale for a design choice was quietly overridden.
5. **Fix `51-CONTENT-INVENTORY.md`'s internal contradiction** — delete or
   date-stamp the stale "remain open" note now that the table above it says
   closed.
6. **Add the missing distinction to `CURRENT-PRODUCT-TRUTH.md`**: a line
   stating explicitly whether Rev14.2/14.3 fixes are included in "current,"
   so the next revision's author (or reviewer) doesn't have to re-derive §1
   of this document from scratch to find out.

---

## Appendix — method

Rev16 zip extracted and inspected directly (438 files). File and line counts
for `.cs`, `.meta`, `.asmdef`, and test attributes were computed by direct
`find`/`grep` against the extracted tree, not taken from
`REV16_VALIDATION_REPORT.md`. Each Rev14.2/14.3 fix was re-derived from its
fix note's description of the *shape* of the change (not just a keyword),
located in the corresponding Rev16 file, and classified present/absent by
reading the actual code around the cited line. The three `Rev14.2-fixes`/
`Rev14.3-fixes` patch files were checked to confirm each fix was actually
authored (ruling out a fix note describing unimplemented intent). The
research corpus was re-scanned for the two specific loose threads
`WHERE-WE-ARE.md` and `51-CONTENT-INVENTORY.md`'s own text pointed at, plus a
general re-read for new contradictions, of which none were found beyond
those two. Not checked, same boundary as every prior audit in this project:
anything requiring Unity to actually compile or run.
