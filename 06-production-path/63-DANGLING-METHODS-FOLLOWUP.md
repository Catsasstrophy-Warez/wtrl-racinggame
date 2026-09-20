# Following Up: Six More Dangling Methods, Found and Fixed

**What this is.** `RaceFlowCoordinator.cs` fixed three cross-system
events but only wired one path through the game. Checking whether the
same disconnection pattern extended further turned up a bigger problem
than expected — seven more methods, checked individually, six with
zero real callers anywhere in the codebase.

**The most important one wasn't in the RPG layer.**
`EngineVariant.ApplyToEngine()` — the only path by which any hero-car
generation's sourced data ever reaches a real `Engine` component — had
no caller at all. Every one of the seven generations could be
batch-created via `Editor/GenerateContentAssets.cs`, be perfectly
correct, and never affect a single frame of actual driving physics.
That sits on the sim pillar directly, not the RPG layer this project
has spent the most recent sessions checking.

---

# What was checked, and the real count

| Method | Owner | Real callers before | After |
|---|---|---|---|
| `ApplyToEngine` | `EngineFamily.cs` | 0 (one comment reference, verified not real code) | 1 — `VehicleSetup.cs` |
| `CompatibleWith` | `TransmissionSpec.cs` | 0 | 1 — `VehicleSetup.cs` |
| `SatisfiesTarget` | `BuildRecipe.cs` | 0 | 1 — `VehicleSetup.cs` |
| `IsRepairable` | `EngineFamily.cs` | 0 | 1 — `VehicleSetup.cs` |
| `PassiveIncomePerSession` | `PartsGating.cs` | 0 (one comment reference) | 2 — `GarageStationManager.cs` |
| `ApplyTraitsToRival` | `ReputationTraits.cs` | 0 | 1 — `RaceFlowCoordinator.cs` |
| `MentorPreemptionFactor01` | `DiagnosticSkill.cs` | 0 | **0 — left unfixed on purpose** |

**Two comment-only false positives caught before being counted as
real** — `ApplyToEngine` and `PassiveIncomePerSession` both had a
`///` documentation comment mentioning the method that read, at a
glance, like a real call site. Checked each directly rather than
trusting the grep hit, the same discipline that caught the original
`GarageStationManager` false claim from the opposite direction.

---

# The three fixes

## `Orchestration/VehicleSetup.cs` — new file

The actual missing link. `ApplySelectedVariant()` is the moment an
`EngineVariant` asset's data becomes real physics — calling
`ApplyToEngine()` and, before that, checking `CompatibleWith()` so an
incompatible transmission is rejected rather than silently applied.
`CheckRecipeSatisfied()` and `IsPartRepairable()` give
`SatisfiesTarget()` and `IsRepairable()` real, sensible call sites
tied to the same vehicle-setup moment rather than forced into an
unrelated class.

## `Garage/GarageStationManager.cs` — extended

Passive income now genuinely fires: arriving at the Hero station for
the first time in a session calls `PartsGating.PassiveIncomePerSession()`
and passes the real result into
`AutologNotification.QueuePassiveIncome()` — the exact "welcome-back"
moment `59-TRENDS-GTA-PASSIVE-INCOME.md`'s research specified,
finally connected to the notification system built to display it.

## `Orchestration/RaceFlowCoordinator.cs` — extended

`StartEvent()` now takes an optional `RivalAI` parameter and calls
`ApplyTraitsToRival()` — the exact moment its own doc comment already
specified ("call when a race against this rival is about to start")
and nothing had ever actually reached.

---

# What's still honestly open

`MentorPreemptionFactor01` needs an actual dialogue-triggering system
— something that plays the mentor's lines during an installation
sequence and can check this value to decide whether to shorten or skip
one. No dialogue system exists anywhere in this codebase. Forcing a
call into nothing would look like a fix without being one; left
flagged instead, the same honesty already applied to Core Haptics in
`36` and the touge/knockout event flow before this session.

---

# Cross-references
- The check this follows up on → `06-production-path/61-CODE-ANALYSIS-AND-WHATS-LEFT.md`
- The original three-event fix this extends → `code/prototype/Orchestration/RaceFlowCoordinator.cs`
- The passive-income research this finally connects → `08-trends-and-cross-genre/59-TRENDS-GTA-PASSIVE-INCOME.md`
- The dyno pass condition this data now genuinely reaches → `03-physics-research/31-DYNO-ANALYSIS.md` Part 7
