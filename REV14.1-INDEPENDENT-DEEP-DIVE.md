# Rev14.1 — Independent Deep Dive

Second-opinion audit of `WrenchToRaceLegends_Unity6_Rev14.1_DeepAuditClean.zip`,
run against the source rather than against the existing `DEEP-AUDIT-REPORT.md`.
Analysed 2026-09-05. 239 files, 11,640 lines of compiled C# across 12
assemblies, plus 3,579 lines of `Prototype~` research code Unity ignores.

Unity 6000.0.58f2 is not installed here either, so this shares the same hard
boundary as the existing audit. What it adds is a static reconstruction of what
Unity *will* do on first open — and on that reading, **the generated first
playable cannot start a race.** Details in P0-1.

---

## Verdict

The engineering discipline here is real. No missing assembly references, no
dependency cycles, no duplicate types, no empty `catch` blocks, no
`DateTime.Parse`, no unguarded divisions, no obsolete Unity 6 APIs, correct use
of `FindObjectsByType`, and 98 tests that actually assert things (avg 3.5
asserts/test, not decoration). All 14 Python prototypes execute clean. The
existing audit's headline claims mostly hold when checked against source.

But the project has never been compiled or run, and the validation that produced
the green board is mostly **token-presence grep**, not behavioural verification
(§6). That combination has let through two defects that stop the first playable
dead, and a set of latching-state bugs in the Rev13 diagnostics layer that make
several systems permanently unusable after one transient event.

Nothing found is architectural. All of it is fixable in a focused day or two.

---

## 1. What I verified and confirms clean

Worth stating precisely, because it's the part the existing audit undersells:

| Check | Method | Result |
|---|---|---|
| Assembly reference graph | Extracted every type decl, mapped cross-assembly usage against each `.asmdef`'s `references` | **0 missing refs, 0 cycles** across 47 real edges |
| Duplicate type names | All declarations across all assemblies | **0 collisions** (`Prototype~` correctly excluded) |
| Unity 6 API breakage | `Rigidbody.velocity`/`.drag`, `FindObjectOfType`, `FindObjectsOfType` | **0 uses** — already on `linearVelocity`-era APIs and `FindObjectsByType` |
| `JsonUtility` round-trip safety | Every type reaching `ToJson`/`FromJson` | **Safe** — no `Dictionary`, interface, or polymorphic field in any serialized payload |
| Test counts | `[Test]`/`[UnityTest]` per file | **EditMode 78, PlayMode 20 = 98** — matches the claim exactly |
| Python prototype suite | Executed all 14 | **14/14 pass**, `make_chart.py` correctly writes outside `Assets/` |
| Code hygiene | Empty catches, `DateTime.Parse`, unguarded `/count` | **Clean** on all three |

The `Prototype~` reasoning in the existing audit is also correct — Unity does
exclude `~` folders, so the type-name overlap there is genuinely not a collision.

---

## 2. P0 — blocks the first playable

### P0-1. The builder saves both cars with a `HideFlags.DontSave` spec, so `spec` is null on reload and the race can never begin

This is the one that matters. Chain, all verified by line:

1. `VehicleSpec.CreateRuntimeCopy()` — `Vehicles/Runtime/VehicleSpec.cs:80-86` —
   `Instantiate`s the spec and stamps `copy.hideFlags = HideFlags.DontSave`.
2. `VehicleController.ApplyRuntimeSpec()` — `Vehicles/Runtime/VehicleController.cs:86-91` —
   assigns that copy to the **serialized** `public VehicleSpec spec` field.
3. `Rev10FirstPlayableBuilder` calls both consumers **in edit mode**:
   - `:430` `mechanicalRuntime.ResolveAndApply()` → player vehicle
     (`Garage/VehicleMechanicalRuntime.cs:35-37`)
   - `:452` `rivalCareer.ApplyProfile()` → rival vehicle
     (`Runtime/RivalCareerRuntime.cs:151-153`)
4. `:480` `EditorSceneManager.SaveScene(scene, ScenePath)`.

Unity does not serialize a `DontSave` object into a scene, and it will not embed
one either — the reference writes out as `{fileID: 0}`. So the saved
`Rev10_FirstPlayable.unity` has `spec = None` on **both** the player and the rival.

There is no recovery path. `VehicleMechanicalRuntime.AuthoredSpec` and
`RivalCareerRuntime.authoredRivalSpec` are non-serialized, so on reload both are
null too; `ResolveAndApply()` returns false at its `if (!AuthoredSpec) return false`
guard and `ApplyGenerationToVehicle()` bails at
`if (!profile || !rival?.vehicle || !rival.vehicle.spec) return`.

The failure is then hard-blocking, not degraded:

```csharp
// Racing/RaceDirector/RaceDirector.cs:79-84
if (!c.vehicle || !c.vehicle.HasValidSpec)
{
    reason = $"RaceDirector competitor '{c.name}' is missing a valid VehicleController/VehicleSpec.";
    return false;
}
```

`CanBeginRace` returns false → `GameFlowController.StartRace()` returns false on
every attempt. And `Rev10FirstPlayableAutoBootstrap` (`[InitializeOnLoad]`) runs
`Build()` automatically the first time the project opens if the scene file is
absent — which it is. So this fires without anyone touching a menu.

**Fix (small):** don't let a `DontSave` object land in a serialized field at
author time. Either keep the authored spec in a serialized `authoredSpec` field
and only swap in the runtime copy during play mode
(`if (!Application.isPlaying) return;` at the top of `ResolveAndApply`/
`ApplyGenerationToVehicle`), or drop `HideFlags.DontSave` and let the copy embed
in the scene. The first is the right shape — the runtime copy is a play-mode
concept and shouldn't exist in edit mode at all.

**Verify in 60 seconds:** open the built scene, select `Player` and
`Rival_Marsh`, look at `VehicleController.spec` in the inspector. If it reads
`None (Vehicle Spec)`, this is confirmed.

### P0-2. Edit-mode `Destroy()` on a ScriptableObject

`Garage/VehicleMechanicalRuntime.cs:34` and `Runtime/RivalCareerRuntime.cs:150`
both call `Destroy(runtimeSpec)`. In edit mode Unity logs *"Destroy may not be
called from edit mode! Use DestroyImmediate instead"* and does not destroy the
object. First call is safe (the field is null), so the builder's single pass
survives — but any second `ResolveAndApply()`/`ApplyProfile()` in the editor
(a re-run of the builder menu item, an EditMode test, a part install) errors and
leaks a `DontSave` ScriptableObject per call.

Guard with `Application.isPlaying ? Destroy(x) : DestroyImmediate(x)` — or, if
P0-1 is fixed by making runtime copies play-mode-only, this disappears with it.

---

## 3. High severity

### H-1. Rival generation mass never reaches the rigidbody

`Runtime/RivalCareerRuntime.cs:153-155`:

```csharp
rival.vehicle.ApplyRuntimeSpec(ownedRuntimeSpec);   // <- this is what syncs rb.mass
var spec = ownedRuntimeSpec;
spec.massKg = Mathf.Max(500f, generation.massKg);   // <- too late
```

`ApplyRuntimeSpec` is the only thing that writes `rb.mass`
(`VehicleController.cs:90`), and it runs *before* the generation's mass is
assigned. So `rb.mass` keeps the authored 1320 kg while `ApplyAero()` computes
rolling resistance from 1390 kg and the dossier displays 1390. Every
generation's mass change is a silent no-op for inertia, acceleration and braking
— physics and displayed data disagree.

`VehicleMechanicalRuntime.cs:36-37` does it in the correct order
(`ApplyResolved` then `ApplyRuntimeSpec`), which confirms the intent. Swap the
two lines.

### H-2. Determinism claim is false — the AI seed is a fresh GUID per race

The audit states *"AI random mistakes remain deterministic per seeded race/rival
context for reproducibility."* The RNG **isolation** is done right — a
per-instance `System.Random`, no `UnityEngine.Random` anywhere in the AI path.
But the seed source is:

```csharp
// Racing/RaceDirector/RaceDirector.cs:55
RaceId = Guid.NewGuid().ToString("N");
```

which feeds `RacingLineAI.cs:62` via `ComputeDeterministicSeed(...RaceId...)`.
A v4 GUID is cryptographically random and never persisted or injectable, so the
AI is reproducible only *within one run of one race*. You cannot replay a race,
and a tester's "the rival spun at turn 3 on lap 2" is unreproducible by
construction. Grid order is also unspecified — `FindObjectsByType(...SortMode.None)`
at `:72`/`:103` feeds spawn assignment at `:145`.

Make `RaceId` injectable (event id + career race counter, or an explicit seed
field) and the claim becomes true.

### H-3. Second critical fault is never recorded (fault recorder latches)

`Garage/VehicleIntelligenceSystems.cs:732,736`. `best` is selected with strict
`>`, so it latches onto the first alert at max severity; `lastTriggerAlertSignature`
is a single field that only changes when an alert clears and re-raises.

Scenario: coolant goes critical at t=100s and stays critical. Oil pressure
collapses at t=200s — appended after the coolant alert, so `best` never moves and
the signature is unchanged. **The engine-destroying oil-pressure event is never
recorded at all**, for the rest of the session. The intended escape hatch is
`alert.acknowledged` (`:731`), but nothing in the codebase ever sets it true —
the only assignment is `= false` at `:101`. The branch is dead.

### H-4. One unavailable sensor permanently kills baseline learning across the whole vehicle

`VehicleIntelligenceSystems.cs:166,175,318`. The envelope loop does
`if (sensor == null || !sensor.available) continue;` **before** it can reach its
`ClearAlert`, unlike `EvaluateHigh`/`EvaluateLow` which correctly clear on
unavailability (`:183`,`:196`).

So: a logger channel raises an envelope warning, the player removes the logger,
the channel goes unavailable, and the warning can never be cleared. Because
`:318` gates all baseline learning on `!warningActive`, **no channel on that
vehicle ever learns a baseline again** — and the state is serialized into the
save, so it's permanent. Self-test reports Warning forever and the diagnostic
service re-asserts a phantom sensor-fault hypothesis every 0.5s.

### H-5. Baselines never decay, so any part swap creates a permanent false anomaly

`Garage/ExtendedMechanicalSystems.cs:48` — `SensorBaselineData` is a lifetime
Welford accumulator with no window, decay, or reset hook.

Fit a high-pressure oil pump: `sampleCount ≈ 36,000` from an hour of driving,
learned mean 250 kPa, new true reading 400 kPa → z ≈ 7.5 → permanent Warning →
which (via H-4's `warningActive` gate) blocks the baseline from ever moving
toward 400, and each sample would move the mean by 0.004 kPa anyway. **A
brand-new correctly-working part produces an unclearable fault.** Needs a decay
window and a reset hook on component install/repair. (`m2` is also a `float`
accumulating over 10⁵–10⁶ samples, so σ itself drifts.)

### H-6. Repeated inspection converges high confidence onto a systematically wrong estimate

`Garage/EngineeringSystems.cs:147`:

```csharp
float signedBias = StableBias(component.componentInstanceId + "|" + method) * uncertainty;
```

The bias is a pure function of `(componentId, method)` — deterministic and
identical on every call — while `beliefConfidence01` compounds toward 1.0 each
inspection (`:159-160`). Note `:151` *does* fold `evidence.Count` into the
evidence id for uniqueness; the same salt was simply omitted from the bias seed.

Click "visual inspect" 20 times on an engine at true 0.40: belief stays pinned at
0.568 while confidence climbs to ~0.87. The player is now 87% confident in a
wrong number, obtained for free by repeating one action, and self-test reports
Pass. `component.evidence` also grows unbounded in the save.

### H-7. Entry fee is only refunded on the synchronous rejection

`Runtime/GameFlowController.cs:99-104` refunds when `BeginRace()` returns false.
But `BeginRace` returns true as soon as the coroutine starts
(`RaceDirector.cs:57`); the two async abort paths (`:97`, `:106`) just
`SetState(Inactive); yield break;` and notify nobody. `GameFlowController` only
subscribes to `Results`.

Result: fee gone, `totalEntryFeesPaidCents` inflated against a race that never
produces a payout, `mode` stuck on `Race` with no exit in `VerticalSliceHUD`.
Currently invisible because the shipped event sets `entryFeeCents = 0`
(builder:312) — it goes live the moment any event charges.

### H-8. `NullReferenceException` 10×/second when `spec` is null

`VehicleIntelligenceSystems.cs:283` dereferences `vehicle.spec.enginePeakTorqueNm`
with no guard, 25 lines after `:258` correctly writes
`vehicle.spec ? vehicle.spec.engineRedlineRpm : 6500f`. `spec == null` is an
explicitly supported state everywhere else in the codebase. Given P0-1 makes
`spec` null on scene reload, **these two will fire together**: the log fills with
NREs at the sample rate while the race refuses to start.

---

## 4. Medium severity

- **M-1. Grip multiplier compounds per tire.** `Garage/VehicleCapabilityResolver.cs`,
  `gripCapabilityMultiplier *= ...` inside the per-installation loop. With four
  tire components installed the multiplier is raised to the 4th power — 0.95/tire
  silently becomes 0.81. Latent today (content installs one tire entry) but the
  design explicitly wants per-corner tires. Same shape applies to cooling.
- **M-2. `operatingHours` only accrues while a part is actively degrading.**
  `Garage/ComponentWearRuntime.cs:55` sits inside `ApplyDelta`, which early-returns
  on `healthLoss <= 0f`. Systematically undercounts, and the Rev13 maintenance
  outlook divides by it (`VehicleIntelligenceAnalysis.cs:210-214`), producing
  "estimated remaining hours" in a unit that matches no clock in the game.
- **M-3. Maintenance outlook leaks hidden truth.** Same lines — the numerator is
  the player's *belief*, the denominator is `wear01`, which `MechanicalDomain.cs:63`
  explicitly documents as *"The simulation knows this. The player should normally
  see only observations/evidence."*
- **M-4. Self-test can never Pass without a motorsport logger.**
  `VehicleIntelligenceAnalysis.cs:84-86` treats "not fitted" and "failed"
  identically, so a showroom-fresh car at condition 1.0 emits 15 Warnings and
  `overallStatus = Warning`.
- **M-5. Self-test over null input returns Pass.** `VehicleIntelligenceAnalysis.cs:51,144` —
  `Unknown = 0 < Pass = 1`, so the escalation can't lower Pass. A "cleared to
  race" gate would read missing data as a healthy car.
- **M-6. Brake-temperature alerts get attributed to the radiator.**
  `VehicleIntelligenceAnalysis.cs:224` — `Cooling` matches any channel containing
  `"temperature"`, and `:194` takes the first list match in installation order.
- **M-7. Generation rebinding never happens.** `RivalCareerRuntime.cs:188,277`
  re-resolve the era every tick and at Results, but stats/wear bind only in
  `ApplyGenerationToVehicle` (Start / `DataChanged`). Change `currentEvent` and
  the rival races generation A's car while post-race wear is written into
  generation B's row — A never degrades, B degrades unraced.
- **M-8. `OnEnable`/`OnDisable` asymmetry loses the career subscription
  permanently.** `RivalCareerRuntime.cs:34` vs `:42-46` — `OnDisable` tears down
  both subscriptions, `OnEnable` restores only the director one, and nothing else
  can re-establish it.
- **M-9. Best-lap reference telemetry falls back to unrelated frames.**
  `RivalCareerRuntime.cs:258` — `if (bestLapFrames.Count == 0) bestLapFrames.AddRange(frames);`
  When the best-lap window has been evicted from the 180s ring, this stores the
  entire buffer (several laps, possibly garage idling) labelled as a 62s lap, and
  persists it. This is the same fix the existing audit claims as #10; the
  windowing is correct but the fallback undoes it.
- **M-10. `rivalReferenceLaps` is written and never read.** One producer,
  zero consumers outside tests. At the 80-lap cap that's ~170k floats
  pretty-printed through `JsonUtility.ToJson(env, true)` on every Results,
  garage return and repair — a synchronous main-thread hitch on the results
  screen for data nothing consumes.
- **M-11. Problem-board entries never retire.** `EngineeringProblemBoardService.MarkSolved`
  is called only from `Rev12MechanicalFoundationTests.cs:219`, never from game
  code; `Mitigated`/`Deferred` are never assigned anywhere. One transient
  overheat leaves a severity-0.95 `Investigating` entry for the rest of the save.
- **M-12. A killed `BeginSequence` coroutine locks out racing permanently.**
  `RaceDirector.cs:48` gates on terminal states; disabling the GameObject during
  the 3.5s countdown kills the coroutine and strands `State` at `Countdown` with
  no watchdog.

---

## 5. Low severity (the tail)

`RacingLineAI.cs:63` mistake grace is measured on `Time.time` from `StageGrid`,
so staging+countdown (3.5s) consumes the intended 2.5s settle-in and a steering
mistake can fire on the first physics tick while cars are side-by-side ·
`RacingLineAI.cs:139` `OverlapSphereNonAlloc` with no `LayerMask` into a 24-slot
buffer, so road cubes and triggers can crowd out the actual opponent and defence
silently switches off · `RaceDirector.cs:196` same-frame finishers tie on
`FinishTime` and are separated by `totalProgress`, which keeps drifting after the
flag because `Update` ranks finished cars too — a 43,000¢ payout swing decided by
coasting · `VehicleIntelligenceSystems.cs:594` fuel-pressure reconstruction drops
the `rpm > 1800f` gate its live-alert counterpart at `:592` requires, inflating
reported warning lead time · `VehicleIntelligenceSystems.cs:754` every fault
reconstruction overwrites one insight record (the id is a compile-time constant)
· `VehicleIntelligenceSystems.cs:788` `CloneFrame` does 300–700 `JsonUtility`
round-trips in the single frame a fault triggers · `VehicleIntelligenceSystems.cs:323`
`accumulatedTelemetrySeconds` adds nominal interval not elapsed time (33%
undercount at 20fps) · `RivalWeaknessType.BrakeCapacity` has no case in the
weakness switch and silently falls through to `default` · `VehicleTuningEngine.cs:147`
and `VehicleMultiParameterTuningEngine.cs:192` call `UnityEngine.Random.InitState`,
mutating global RNG state · `SaveGameService.cs:44-47` delete-then-move save is
non-atomic (prefer `File.Replace`), and a validation failure silently starts a new
career whose next two saves overwrite both the primary and the backup.

---

## 6. The validation itself is the deeper problem

The green board in `DEEP-AUDIT-REPORT.md` is less than it looks. From
`Scripts/validate_rev14_structure.sh` lines 90-109:

```bash
grep -q 'fuelTorqueLimit'        Assets/.../VehicleCapabilityResolver.cs
grep -q 'BestLapStartUnityTime'  Assets/.../RaceCompetitor.cs
grep -q 'lastTriggerAlertSignature' Assets/.../VehicleIntelligenceSystems.cs
...
echo "Capability enforcement: PASS"
echo "Best-lap telemetry windowing: PASS"
echo "Recurring diagnostics/fault signature: PASS"
```

Every one of those `PASS` lines is an **unconditional `echo` after a
single-identifier `grep`**. "Capability enforcement: PASS" proves only that the
string `fuelTorqueLimit` appears in a file. `Mechanical runtime wiring: PASS`
(line 85) is a bare `print()` after checking three identifiers exist in the
builder's text. `Brace balance` counts braces inside string literals and comments
— it's honestly labelled "gross", but it is not a syntax check.

This is exactly why P0-1 sailed through: the Rev12 validator greps that
`CreateRuntimeCopy` *exists* (`validate_rev12_structure.sh:37`) and calls that a
pass. Presence of an identifier is being reported with the same word — PASS —
as verified behaviour, and after enough revisions the board reads as evidence
when it's an inventory.

Three of the checks were genuinely load-bearing and worth keeping: the assembly
cycle DFS (lines 36-44), the derivation worksheet count (62-70), and the
distribution hygiene scan (71-77). Those compute something. The rest either had
to become real assertions or stop printing PASS.

### Fixed — `validate_rev14_structure.sh` rewritten

The script has been replaced with 26 checks that each compute something and can
fail. No unconditional `echo "... PASS"` remains; a check that genuinely can't be
decided statically reports `SKIP` with a reason rather than claiming success, a
check that throws is reported as `ERROR` (counted as a failure, not silently
passed), and the script exits non-zero if anything fails.

Every previously-fake check is now a chain assertion. "Capability enforcement"
no longer greps for `fuelTorqueLimit`; it asserts the whole path — the fuel limit
lowers `sustainableTorqueNm`, the resolver clamps `resolvedSpec.enginePeakTorqueNm`
to it, `ApplyResolved` copies that field onto the runtime spec,
`VehicleMechanicalRuntime` applies that spec to the vehicle, and
`VehicleController` actually reads it. Break any link and it fails. "Save schema"
now verifies the migration chain covers 1..N-1 contiguously, terminates at N, has
a newer-than-supported guard, and agrees with `VERSION.md`.

Six new checks were added for the defect classes this audit found, including the
one that catches P0-1: **`dontsave-not-serialized`** locates any factory that
produces a `HideFlags.DontSave` object and fails if a caller stores it in a
serialized field without an `Application.isPlaying` guard.

Current state on this tree: **22 pass, 4 fail, 0 skipped.** The four failures are
P0-1, P0-2, M-9 and the test-asmdef wiring — all real, all in this report.

The checks were verified by mutation: removing the capability clamp, adding a
`Dictionary` to a saved type, breaking the migration chain, reintroducing
`rb.velocity`, duplicating a type name across assemblies, and using a `Career`
type from `Racing` without the reference each flip their check from PASS to FAIL.

Note that `validate_rev14_unity.sh` runs the structural pass first under
`set -e`, so it now correctly refuses to launch Unity while P0-1 is unfixed.

The 98 authored tests are the real asset here — they're specific and
assert-dense. They've just never been executed.

---

## 7. Recommended order

1. **Fix P0-1 and P0-2** (~30 min). Gate runtime-spec creation on
   `Application.isPlaying`, or keep the authored spec in its own serialized field.
   Nothing else can be validated until the scene works.
2. **Open in Unity 6000.0.58f2 and run all 98 tests.** This is still the real
   gate — expect a first round of compile errors that no static pass can predict.
   While there: modernize the two test `.asmdef`s. Both use the legacy
   `optionalUnityReferences: ["TestAssemblies"]` with no `precompiledReferences:
   ["nunit.framework.dll"]` and no `defineConstraints: ["UNITY_INCLUDE_TESTS"]`.
   Unity has honoured the legacy form for backwards compatibility since 2019.3
   and may still; the modern form costs nothing and removes the question —
   and without the define constraint `WTRL.Tests.PlayMode` has no
   `includePlatforms` and would ship into player builds.
3. **Fix H-1 through H-8.** H-1 and H-7 are two-line changes. H-3/H-4/H-5 are
   the same underlying shape — state that latches and never retires — and are
   worth fixing together with a "reset baselines and alerts on component
   install/repair" hook.
4. **Add the three regression tests the P0 implies:** build the scene, reload it,
   assert `spec != null` on both competitors and `CanBeginRace() == true`. That
   single test would have caught P0-1.
5. **Then the medium tier**, prioritising M-7 (rival era rebinding) and M-10
   (unread reference laps bloating every save).

---

## Appendix — method

Assembly graph and type resolution were computed programmatically: every
`class`/`struct`/`enum`/`interface` declaration extracted per file (comments and
string literals stripped), mapped to its owning `.asmdef` by nearest ancestor
directory, then every project type name matched against every file to derive the
real cross-assembly usage graph and diff it against declared `references`. The
Python suite was executed. `validate_rev14_structure.sh` was executed and read
line by line. The four largest Garage files and the seven racing/career files
were read in full by two independent focused passes; findings from those passes
were re-verified against source before inclusion here.

Not checked, and still open: anything requiring compilation or execution —
compiler errors, `[SerializeField]` serialization behaviour, coroutine timing
under real frame pacing, scene GUID integrity, device build.
