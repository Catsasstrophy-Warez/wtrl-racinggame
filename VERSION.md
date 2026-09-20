# racinggameideas

Consolidated project archive. **This supersedes every previous zip.**

**Contents:** 64 numbered research and specification documents, now
organized into 8 folders by purpose rather than one flat sequential
list, a pitch, a derivation worksheet template, MIT-licensed source,
and working prototype code with numerical validation.

**Reorganized from a flat 60-file list into folders in this pass.**
Every document keeps its original number and filename — nothing was
renumbered, since 1,300+ cross-references throughout this package cite
documents by number (`47`-style), and those citations work
identically regardless of which folder a file lives in. Only the
physical location changed, verified file-by-file: 60 before the move,
60 after, none lost, none duplicated.

---

## `01-foundations-and-method/` — constraints and how derivation works

| Doc | What it is |
|---|---|
| `01` | Licensing — what's ship-safe |
| `02` | Toolchain — Windows authors, Mac proves the build |
| `03` | Platform limits — iOS hard constraints, Android decided as "eventually" |
| `04` | What to extract from open source (RVP, TORSION, CrazyCar) |
| `12` | The derivation method itself — the three-change rule this whole package follows |
| `15` | Worked derivation cases |

## `02-design-research/` — 40 years of reference, genre, and production research

| Doc | What it is |
|---|---|
| `05`-`07` | Design references — Mad Max, Duskers, Prey, Car Wars, Gaslands, the influence map |
| `08`-`11` | Production specs — art direction, asset production, audio design, the systems build spec |
| `13`-`14` | The Mustang dossier, the wasteland corpus |
| `16`-`19` | Genre taxonomy — management games, 40 years of racing games, the SNES era, NFS |
| `21`-`24` | Driver-series research, input design, cameras/HUD, garage systems |
| `26`-`29` | Mobile landscape (50 titles), competitor anatomy, the CPM case study, narrative analysis |

## `03-physics-research/` — the dyno and the full Beckman reading

| Doc | What it is |
|---|---|
| `31` | The dyno as tuning interface |
| `34` | The complete Beckman Physics of Racing reading, all 29 parts |
| `35` | Sources beyond Beckman — OptimumG, academic literature, BeamNG |
| `36` | iPhone-specific — Core Haptics, ProMotion device-tier risk |

## `04-vehicle-and-drivetrain-research/` — real automotive history as reference

| Doc | What it is |
|---|---|
| `37` | Ford V8 audio, all seven generations, the two-family acoustic finding |
| `38`-`39` | Mechanic-game deep dives — Car Mechanic Simulator, then four more on one spectrum |
| `40` | Forced induction, crank type, real transmission history |

## `05-specifications/` — the actual decisions, not research

**Start here if you want the design itself, not how it was reached.**

| Doc | What it is |
|---|---|
| `20` | **The synthesis** — 21 systems, four chains |
| `25` | Garage design |
| `30` | Narrative design |
| `32` | Hero car — seven generations, intimidation as earned AI behavior |
| `33` | Act structure |
| `41` | Race formats, ghosts, objective-based scoring |
| `44` | Track roster |
| `45` | Rival development — six named archetypes |
| `47` | Parts pricing, transmissions, engines, brakes, axles — fully sourced |
| `48` | The RPG layer — recipes, two-axis gating, Safety Rating |
| `49` | Player-character RPG — license grade, diagnostic skill, emergent traits |
| `50` | The action pillar — aggression economy, stunts, pursuit/escape |

## `06-production-path/` — what's left, in order

| Doc | What it is |
|---|---|
| `42` | **Start here if resuming.** The ordered checklist to a testable build |
| `43` | Concrete numbers for that checklist — the 1965 spec, the first circuit |
| `46` | **Start here tonight.** The single-session Unity build checklist |
| `58` | Test and evaluation pass — code audit, one real numerical finding |
| `61` | **Most current.** Full code analysis (one real bug found and fixed) plus the live "what's left" inventory, updated for the first time since Unity actually started running |

## `07-content-resolution/` — closing the gap between specified and built

| Doc | What it is |
|---|---|
| `51` | The honest content-volume audit that started this whole arc |
| `52`-`57` | Six resolution passes — rival AI data, hero-car generations, race format instances, all four road courses, drag/oval facilities, the full recipe set |

## `08-trends-and-cross-genre/` — checking outside racing games

| Doc | What it is |
|---|---|
| `59` | GTA Online's passive-income economy — a real six-document-old gap found and closed |
| `60` | Forza's Drivatar — checked against `RivalAI.cs`'s existing safeguards, held up |

---

## `code/` — not just reference material

| Folder | What's in it |
|---|---|
| `code/TORSION-MIT/` | MIT drivetrain source. Ship-safe. |
| `code/CrazyCar-MIT/` | MIT licence + MySQL progression schema |
| `code/pacejka-reference/` | Public-domain Python tyre-formula implementation |
| `code/prototype/` | **Working prototype code — 15 C# files.** See below. |

### `code/prototype/` — now organized into 9 folders

**Reorganized in the same pass that organized the documents** —
`Physics/` (9 files), `RPG/` (7), `Action/` (2), `Audio/` (1), `Social/`
(1), `Garage/` (1), `RVPIntegration/` (the triage, migration scripts,
shader, racing-line writeup — 5), `Editor/` (the batch asset
generator), `Orchestration/` (see below), `simulation/` (the Python
validation suite, 11 files). `code/prototype/README.md` has the full
breakdown and stays at the root as the entry point.

**Editor automation** (`Editor/GenerateContentAssets.cs`) — batch-
creates every remaining `EngineVariant`, `TransmissionSpec`, and
`RivalAI` asset from data already fully sourced in `47` and `52`. Run
once via `Tools > Racing Game > Generate All Remaining Content Assets`.
Safe to re-run; skips assets that already exist.

**The six systems missing on direct question, now closed**
(`SurfaceGripTable.cs`, `MechanicalFailure.cs`, `ObjectiveTracker.cs`,
`RaceEventLogic.cs`, `GarageStationManager.cs`) — surface grip,
sustained-abuse mechanical failure, the five-objective star system,
real Touge/Knockout event classes, class-bracket-and-license entry
enforcement finally wired together, and the seven-station garage
switch. One real bug (Python-syntax method names) caught and fixed
before it shipped.

**A full-codebase deep dive then found something bigger than a bug**:
every one of the 22 files was individually correct and none were
connected. Every cross-system event had zero subscribers; every race-
event class's completion state was computed and never read. Two events
turned out to be plain C# delegates, not Inspector-wireable `UnityEvent`s
at all — fixed both (`RaggedEdgeMeter.OnLostControl`,
`MechanicalFailure.OnMechanicalFailure`). Built
`Orchestration/RaceFlowCoordinator.cs` as a reference implementation
proving the wiring pattern actually works for one full path — an
outrun ending, a mechanical failure genuinely zeroing the nitrous
system rather than just logging it — honestly scoped as a starting
pattern for the other three formats, not a full game manager.

**Simulated afterward** (`06-production-path/62-SIMULATION-AND-TESTING-PASS.md`): found `MechanicalFailure.cs` never actually fired under a realistic driving pattern despite reading correctly on inspection — fixed and re-validated. Also confirmed all six rivals' AI values are genuinely numerically distinguishable, not just different-looking in separate tables.

**A follow-up check found six more dangling methods** — `EngineVariant.ApplyToEngine()` (the only path any hero-car generation's data ever reaches real physics, previously called from nowhere), `CompatibleWith`, `SatisfiesTarget`, `IsRepairable` (all fixed via new `Orchestration/VehicleSetup.cs`), plus `PassiveIncomePerSession` and `ApplyTraitsToRival` (wired into `GarageStationManager.cs` and `RaceFlowCoordinator.cs` respectively). One left honestly unfixed: `MentorPreemptionFactor01` needs a dialogue system that doesn't exist yet.

**A second simulation confirmed a system actually works**: `ObjectiveTracker.cs`'s instability objective, checked against the same realistic pattern that broke `MechanicalFailure`, genuinely differentiates normal from reckless driving — no bug, one honest tuning note about how sustained "pinned at max" needs to be to fail it. Null-safety across all six `Update()` loops also checked and confirmed clean.

**Checked all nine RPG/action progression systems together against Royal Match's own real testing data on meta-layer weight** (`08-trends-and-cross-genre/64-ROYAL-MATCH-NINE-SYSTEMS-ANALYSIS.md`) — seven of nine have zero dedicated UI at all, and completing one race now genuinely advances four systems in a single moment after finding and fixing a real gap: `ReputationTraits` was being applied to rivals at event start but never updated from actual results, since `RecordEventOutcome()` had no caller anywhere.

`docs/derivation/` — all 27 per-generation rival derivation worksheets.

**Start with this file, then `05-specifications/20-CONCEPTS.md`.**

---

## The one thing to build first — status unchanged

`03-physics-research/31-DYNO-ANALYSIS.md` Part 7:

> Change one differential setting. The curve moves visibly. The lap time
> moves measurably. The player feels it through tilt.

**The first two are numerically confirmed** (`code/prototype/simulation/`).
**The third remains exactly as unconfirmed as it has been since this
line was first written** — nothing in this reorganization, or in any
document added since, changes that. `06-production-path/46-TONIGHT-
BUILD-SESSION.md` is the ordered checklist for closing it.
