# Where This Project Actually Is

A read of all 64 research documents and the specification set against the
Rev14.1 Unity tree. Written 2026-09-05, following the Rev14.1 code audit.

The short version: **there are two codebases, and the research validated the
one Unity doesn't compile.**

---

## 1. The structural finding

`20-CONCEPTS.md` defines 21 systems in four chains. Every research document
since traces to them. The production path (`42`, `43`, `46`) sequences the
whole project behind one gate, and `61`/`62`/`63` — the most recent status
documents — report on a codebase of 14–15 C# files under `code/prototype/`:
`RaggedEdgeMeter.cs`, `TireForceModel.cs`, `DynoController.cs`,
`MechanicalFailure.cs`, `ObjectiveTracker.cs`, `BuildRecipe.cs`,
`PartsGating.cs`, `DriverProgression.cs`, `VehicleSetup.cs`,
`RaceFlowCoordinator.cs`, `GarageStationManager.cs`.

Those 24 files are all present in the Rev14.1 archive, at
`Assets/WrenchToRaceLegends/Prototype~/`.

**Unity excludes any folder whose name ends in `~`.** None of that code
compiles, loads, or runs. It is not in any assembly definition. It cannot be
referenced by anything in the project.

The Unity project that *does* compile is a separate 75-file, 12-assembly tree
(`WTRL.Core`, `WTRL.Vehicle`, `WTRL.Racing`, `WTRL.Garage`, `WTRL.Lab`,
`WTRL.Career`, …) built over Rev10→Rev14.1. It shares no code with the
prototype. It is a different game: a mechanical-diagnostics and
vehicle-intelligence simulator with a race loop attached.

Checked symbol by symbol — live tree / `Prototype~`:

| Research system | Live | Prototype |
|---|---|---|
| `RaggedEdgeMeter` | 0 files | 11 |
| `TireForceModel` | 0 | 8 |
| `DynoController` | 0 | 6 |
| `MechanicalFailure` | 0 | 2 |
| `ObjectiveTracker` | 0 | 2 |
| `PartsGating` | 0 | 7 |
| `DriverProgression` | 0 | 1 |
| `SurfaceGripTable` | 0 | 2 |
| `StuntSystem` / `NitrousSystem` / `PursuitEscapeEvent` | 0 | 1–2 each |
| `VehicleSetup` / `RaceFlowCoordinator` / `GarageStationManager` | 0 | 1–2 each |

`61-CODE-ANALYSIS-AND-WHATS-LEFT.md` says "Compiles ✅ Confirmed / Drives ✅
Confirmed." That is true of the WTRL tree. It is not true of the code that
sentence is about.

This is not a criticism of the work — the WTRL tree is substantial and, per the
Rev14.1 audit, competently built. But every "what's left" list in the research
is scoped to a codebase that isn't the one being shipped, and that means the
project's own status documents are measuring the wrong thing.

---

## 2. The 21 systems against the shipping tree

Verified by symbol search plus reading the implementing code. "Shell" means the
data structure exists and is serialized into every save, but no code reads or
writes it.

### Part 1 — Simulation

| # | System | Status | Evidence |
|---|---|---|---|
| 1 | Ragged-edge instability meter | **Closer than absent** | `VehicleController.cs:200` computes `forceUtilization = demandMag / maxTireForce` per wheel — that *is* traction-circle fill. No integrator, no decay, no loss-of-control trigger, no player-facing meter. See §4. |
| 2 | Upgrade dependencies from physics | **Live** | `VehicleCapabilityResolver` — `torqueCapacityNm` bottleneck across clutch/trans/diff/axle, `fuelPowerCapacityHp` ceiling, cooling margin. Genuinely the specified mechanic. |
| 3 | Surface-dependent grip | **Absent** | `surfaceGrip01` exists only as track *metadata* for setup advice. No surface lookup in the force solver. |
| 4 | The dyno | **Absent** | Zero occurrences in the live tree. `WTRL.Lab` is an automated DOE/acceptance-test harness, not the player-facing dyno of `31-DYNO-ANALYSIS.md`. |
| 5 | Telemetry that names the fault | **Live, and beyond spec** | `VehicleIntelligenceSystems` / `VehicleIntelligenceAnalysis` — sensors, learned baselines, diagnostic hypotheses, fault reconstruction, maintenance outlook. |
| 6 | Practice session | **Absent** | Zero occurrences. |
| 7 | Mechanical failure from abuse | **Partial** | Component wear, alerts, fault incidents all exist — but driven by legacy condition deltas, not by an abuse/ragged-edge integral. The research's "push lap after lap and something breaks" curve (validated in `62`) is in `Prototype~`. |

### Part 2 — Action

| # | System | Status |
|---|---|---|
| 8 | Outruns | **Absent** — 0 occurrences |
| 9 | Touge duels | **Absent** — the only hit is `VehicleSetupArchetype.Touge`, a tuning-profile enum value |
| 10 | Aggression economy | **Absent** — the only hits are `RacingLineAI.aggression` (an AI difficulty parameter) and driver-fingerprint fields |
| 11 | Dual rating / Safety Rating | **Absent** — 0 occurrences |
| 12 | Named rivals with technical profiles | **Live** — 6 rivals, `RivalWeaknessType`, relationship history, per-era vehicle generations. The strongest spec-to-code match in the project. |
| 13 | Knockout events | **Absent** — 0 occurrences |

### Part 3 — RPG

| # | System | Status |
|---|---|---|
| 14 | Repair costs as economic engine | **Live** — `RepairCostCents`, `RepairActiveVehicle`, entry fees, payouts, ledger |
| 15 | Two-axis gating | **Absent** — reputation is tracked but gates nothing; no licence class exists |
| 16 | Class brackets | **Absent** — 0 occurrences of class points or brackets |
| 17 | Named build recipes | **Shell** — `BuildRecipe` ScriptableObject declared in `PowertrainCatalog.cs`, one reference, no assets, no consumer |
| 18 | Property tiers | **Shell** — `FacilityCapability` / `facilities` declared in `GarageData`, **0 reads or writes** |
| 19 | Stars from objectives | **Absent** — the hits are tuning-lab "objective weights", unrelated |
| 20 | Shop-driver employment tier | **Shell** — `CustomerJobData` / `customerJobs` declared, **0 reads or writes** |
| 21 | Ghosts + Autolog | **Absent as a feature** — though `rivalReferenceLaps` captures the raw traces (and nothing reads them, per M-10 in the code audit) |

**Tally: 4 live, 1 partial, 1 near, 3 shells, 12 absent.**

Nine `GarageData`/`CareerData` collections are serialized into every save and
never touched by any code: `tools`, `facilities`, `mechanics`,
`transportAssets`, `eventLoadouts`, `mechanicalKnowledge`, `builderReputation`,
`customerJobs`, `specialistRelationships`.

---

## 3. The four chains

`20-CONCEPTS.md` Part 4 is explicit: *"These are not twenty-one independent
features. A system pulled out of its chain does not function."*

**Chain A — Tuning** (practice 6 → dyno 4 → telemetry 5 → dependencies 2).
Practice **absent**, dyno **absent**, telemetry **live**, dependencies **live**.
Broken at both ends. The doc's own verdict on this chain: *"Without all four,
deep tuning is a slider wall. This chain is the entire argument for your game
existing."*

**Chain B — Career arc** (aggression 10 → safety rating 11 → pro gate).
All three **absent**. The arc the research calls *"your arc, mechanically
expressed rather than narrated"* has no implementation.

**Chain C — Economy** (repair 14, brackets 16, property 18).
Repair **live**, brackets **absent**, property **shell**. One of three — and
the research is emphatic that three independent sinks are what stopped both
Mad Max's and Porsche Unleashed's economies from breaking in opposite
directions. With only repair costs, that failure mode is unmitigated.

**Chain D — The bridge** (shop-driver 20). **Shell.**

---

## 4. The gate is now further away than when it was written

Everything in `42`/`43`/`46` is sequenced behind one criterion, quoted from
`31-DYNO-ANALYSIS.md` Part 7:

> *"Change one differential setting. The curve moves visibly. The lap time
> moves measurably. The player feels it through tilt."*

`VERSION.md` in the original archive still says the first two are numerically
confirmed and the third *"remains exactly as unconfirmed as it has been since
this line was first written."* That is still true — but the situation has
changed in a way the docs don't record.

**In the shipping tree, the test cannot be set up at all.** There is no dyno to
read a curve from. There is no differential model in the force solver — the
live tree has `ComponentCategory.Differential` as a torque-capacity bottleneck
and `DriveShare(i)` as a fixed front/rear split, but no preload, no lock, no
differential behaviour to change. And there is no instability meter to feel.

Two things make this less bad than it sounds.

**First, the hard half of system 1 is already built.** `VehicleController`
computes per-wheel `forceUtilization` from the same combined-force solver that
actually moves the car. `RaggedEdgeMeter`'s own integration note is a warning
about exactly this:

> *"for the meter to be honest, the 'current force' it reads and the 'peak
> force' it compares against must come from the SAME tyre model … you
> reproduce exactly the failure flagged in `31-DYNO-ANALYSIS.md` §2.3"*

Against RVP that was a real risk. In the live tree the quantity already comes
from the one solver. What's missing is the integrator with a decay term, the
Milliken loss-of-control criterion (`|a_y − v·ψ̇| > ε`), and the
visual/audio/haptic surface. That is a small job, not a port.

**Second, and harder: the live tyre model cannot produce the behaviour the
meter is meant to reveal.** `VehicleController.cs:196`:

```csharp
Vector2 combined = Vector2.ClampMagnitude(new Vector2(longitudinalDemand, lateralDemand), maxTireForce);
```

That saturates. Past the friction limit the tyre keeps delivering *maximum*
force indefinitely. Beckman's cup — the thing `20-CONCEPTS.md` §1 builds the
signature mechanic on — requires force to *peak and then decline* with slip:

> *"Inside the cup: more slip → more grip. Outside: more slip → less grip …
> That is why losing a car feels like falling rather than sliding."*

A clamp gives you a plateau, not a peak. The car will plow at the limit rather
than let go, and the falloff that makes a spin unrecoverable never happens.
The file says as much itself, at line 202:

> *"Wheel angular state is intentionally decoupled from the force solver in
> Rev11 … A later tire-model revision can close this loop."*

Slip ratio and slip angle are computed as telemetry and never fed back into
force. So the tyre model is a defensible, stable placeholder — and it is not
the model the tuning-depth thesis rests on. `TireForceModel.cs` in `Prototype~`
is that model, and it has never run.

---

## 5. Content: the pipeline is real, the content isn't

`51-CONTENT-INVENTORY.md` was honest about this and `52`–`57` closed the gaps
**on paper**: all 7 hero generations specified, all 6 rivals' AI ceilings
assigned, 4 road courses, named drag/oval facilities, 35 of 35 build recipes.
`61` §2.4 lists these as closed. `63` then adds the caveat that matters:

> *"Every one of the seven generations could be batch-created via
> `Editor/GenerateContentAssets.cs`, be perfectly correct, and never affect a
> single frame of actual driving physics."*

The archive contains **zero `.asset`, `.unity`, or `.prefab` files.** Nothing is
authored. Everything the first playable contains is generated at edit time by
`Rev10FirstPlayableBuilder.cs`, and `GenerateContentAssets.cs` — the tool that
would instantiate the 35 recipes and 7 generations — is in `Prototype~`, so it
doesn't exist in the project either.

So the content position is: specified in markdown for 7 generations, 6 rivals,
4 formats, 8 tracks and 35 recipes; **built as data for one 1965 car, one
rival (Marsh), one 8-checkpoint circuit, one lap-race format.** That is
unchanged from `51`'s original "one vertical slice" verdict, despite six
resolution passes marked closed.

`51` also flags an unresolved conflict worth settling: `43` Item 6/7 specifies
**the Constant** as the first outrun opponent; `51` §1.2 says **Marsh** is the
one actually run. The builder ships Marsh.

---

## 6. What the shipping tree has that the research never asked for

Worth saying plainly, because it's most of the last four revisions' work and
none of it appears in the 21 systems:

- **Vehicle intelligence (Rev13)** — sensor packages, learned baselines,
  diagnostic hypotheses with evidence and confidence, self-test reports,
  black-box fault recording and reconstruction, maintenance outlook.
- **Mechanical instances (Rev12)** — every component is a unique physical
  object with wear, fatigue, thermal damage, corrosion, contamination,
  provenance, install quality, and full service history.
- **Engineering intelligence** — track fingerprinting, driver fingerprinting,
  setup memory across sessions, multi-parameter DOE tuning.
- **Living rivals (Rev14)** — persistent condition, relationship history,
  per-era vehicle generations, reference telemetry.

This is a deeper *mechanic-sim* than anything in the research corpus specified.
It is also, in `20-CONCEPTS.md`'s framing, mostly system 5 elaborated —
telemetry that names the fault — grown into the primary system. Systems 1, 4
and 6, which the research says are the reason the game exists, went the other
way.

That's a strategy question, not a bug, and it's the one worth answering
deliberately rather than by accretion.

---

## 7. What's next

**Immediate (this week)**

1. **Fix P0-1 and P0-2** from the code audit — the generated first playable
   can't start a race. ~30 minutes. Nothing below can be tested until this
   works.
2. **Open in Unity 6000.0.58f2 and run the 98 tests.** Still the real gate on
   the code that exists.
3. **Decide which tree is the game.** This is the fork everything else hangs
   off, and it's yours to make, not something the docs answer:
   - *WTRL is the game* → the prototype becomes a reference implementation to
     port from, and the research's status docs (`61`, `62`, `63`) should be
     re-scoped or archived so they stop describing dead code as live.
   - *The prototype is the game* → then four revisions of WTRL work need a
     home, and the `Prototype~` folder needs renaming so Unity compiles it.
   - *Merge* → most likely correct, and it means moving specific files, not
     both trees wholesale.

**Then — make the gate answerable (the shortest path to the project's own
decision point)**

Assuming WTRL is the game, three pieces, roughly in this order:

4. **Port `TireForceModel.cs` into `WTRL.Vehicle`** and replace the
   `ClampMagnitude` saturation with a real slip curve. This is the one that
   unblocks everything else — without a peak-and-falloff, neither the meter nor
   the dyno measures anything meaningful. It's also the riskiest change in the
   project, so do it behind a feature flag with the current model as fallback,
   and re-run the PlayMode reliability suite on both.
5. **Add a differential model** — preload/lock affecting torque split in the
   force solver. Currently there is nothing to change, so step 3 of `43` Item 3's
   protocol is not executable.
6. **Port `RaggedEdgeMeter.cs`** and wire `forceUtilization` into it. Cheap,
   because the quantity already exists and already comes from the right solver.
   Then the visual gauge, the three-sound tyre crossfade (`10-AUDIO-DESIGN.md`),
   and the Core Haptics pattern (`36` Part 1.3) — `42` §3.1 is emphatic that all
   three together are what's being tested, not a placeholder bar.
7. **Build the dyno readout** — `31-DYNO-ANALYSIS.md` §6.2's curve and §6.3's
   benchmark figure. No styling.
8. **Run `43` Item 3's seven-step protocol on both device tiers.** Record the
   result honestly, including "maybe." That instruction appears in both `43` and
   `46` and is the most valuable discipline in this package.

**Only after the gate passes**

9. Content, in `42` Part 2's order — and by then `GenerateContentAssets.cs`
   needs to be live so the 35 recipes and 7 generations become real assets
   rather than markdown.
10. Chain C's missing sinks (class brackets, property tiers) before the economy
    is tuned, since the research is specific that repair costs alone don't hold.

**Housekeeping worth doing while you're in there**

- Delete or wire the nine dead save collections. They cost bytes in every save
  and imply features that don't exist.
- Settle the Constant-vs-Marsh conflict between `43` and `51`.
- `51` §1.3's update text contradicts its own table (road courses "remain open"
  vs. marked closed) — one of them is stale.

---

## 8. The honest summary

The research is unusually good — sourced, self-correcting, and willing to
record its own negative results. The Unity project is competently engineered.
The problem is that they stopped pointing at each other several revisions ago,
and nothing in the status documents caught it, because the status documents are
written against `Prototype~`.

Concretely: **4 of 21 systems are live, 3 of 4 chains are broken or absent, and
the gate the entire package is sequenced behind cannot currently be set up in
the tree that compiles.** The single most valuable thing available is not more
systems — it's making that one differential test runnable, because it's the
experiment that tells you whether the thing you've spent 64 documents arguing
for is true.
