# Gameplay Systems Specification

Consolidates the mechanics analysis from `05`, `06`, and `07` into a buildable
system list with dependencies and a build order. This is the "what to actually
make" document.

---

## 1. System map

```
                    ┌─────────────────┐
                    │  VEHICLE PHYSICS │  ← TORSION + RVP + VPP CE
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
   ┌─────▼─────┐      ┌──────▼──────┐     ┌──────▼──────┐
   │  TUNING   │      │ RAGGED EDGE │     │   DAMAGE    │
   │  SYSTEM   │      │ (instability)│     │   MODEL     │
   └─────┬─────┘      └──────┬──────┘     └──────┬──────┘
         │                   │                   │
         └───────────────────┼───────────────────┘
                             │
                    ┌────────▼────────┐
                    │   RACE SYSTEM   │  ← checkpoints, laps, position
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
   ┌─────▼─────┐      ┌──────▼──────┐     ┌──────▼──────┐
   │  RATINGS  │      │   ECONOMY   │     │   GHOSTS    │
   │ speed +   │      │  money +    │     │  (async     │
   │  safety   │      │  parts      │     │   rivals)   │
   └─────┬─────┘      └──────┬──────┘     └─────────────┘
         │                   │
         └───────────────────┤
                             │
                    ┌────────▼────────┐
                    │  CAREER / TIERS │
                    │ street→club→pro │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │  PROPERTY LADDER │
                    │ house→garage→   │
                    │ shop→warehouse  │
                    └─────────────────┘
```

---

## 2. Core systems

### 2.1 Vehicle physics
**Source:** TORSION drivetrain (MIT, bundled) + RVP suspension/tyres/surfaces
(MIT). See `04-EXTRACTION-INVENTORY.md`.

**Note on alternatives:** VPP Community Edition is desktop-only and cannot ship
on iOS — use it as a desktop feel benchmark, not a foundation.
`com.unity.vehicles` is ECS-only and targets medium realism by design. If RVP
does not survive the URP port, price **VPP Professional**. See `02`.

**Preserve TORSION's bidirectional architecture** — `GetDownstreamTorque()` /
`GetUpstreamAngularVelocity()`. Do not flatten it into one-way torque. It is
what makes clutch and differential physically correct, and it feeds the audio
Load parameter (`10-AUDIO-DESIGN.md` §3.2).

**Build yourself:** the LSD. TORSION's `Differential.cs` is an 18-line open-diff
stub.

**Tyre model — read `34-PHYSICS-READING.md` and `31-DYNO-ANALYSIS.md` §6.0b
before choosing.** Beckman's own three-parameter alternative to full Pacejka
(`F = B·Fz·α / (1 + |A·α|^P)`, `34` Part 1d Part 29) was written explicitly
for game simulation, differs from full Pacejka by under 10% almost everywhere,
and is very likely the right starting model — cheaper to author, cheaper to
evaluate per wheel per tick. A public-domain Python reference for full Pacejka
exists in `code/pacejka-reference/` if you need it instead.

**Weight transfer has a closed-form four-corner solution now**, not just RVP's
per-wheel spring compression — see `34` Part 1e (Part 27). Useful as a
from-first-principles cross-check on whatever the suspension model produces.

**Polar moment of inertia (`34` Part 1e, Part 13) is a second physical axis**
for differentiating the hero car's seven generations (`32` §7.0) beyond
horsepower — engine placement relative to the CM changes how quickly the car
yaws, independent of straight-line power. Real reference figures are free via
the NHTSA database (`35` §2.1).

### 2.2 Tuning system
Seven subsystems: aero, suspension, engine, tyres, transmission, driver aids,
differentials.

**Design rule from Mad Max (`05` §1.1):** upgrading one element should
negatively affect another. Yours are *simulated* consequences rather than
authored penalties — that is your differentiator over every other mobile racer.

**Constraint model from Car Wars (`06` §2.1):**

| Constraint | Meaning |
|---|---|
| **Packaging** | Does this part physically fit with that one? |
| **Weight** | The real currency — every addition costs elsewhere |
| **Class bracket** | Build to qualify, not just to maximise |

**Handling is derived, not purchased** (`06` §2.2). Show it as an output that
moves when the player changes something they did not directly touch.

### 2.3 Ragged edge (instability)
**The highest-value mechanic in this package — and not actually an authored
abstraction.** Adapted in concept from Gaslands' hazard tokens (`06` §1.2), but
it turns out to be a direct readout of real vehicle dynamics:

- Driving at the limit accumulates instability
- Backing off sheds it
- Crossing the threshold loses the car
- **Handling rating determines how fast you can shed it**, not just how well the
  car corners

**The meter is Beckman's traction circle** (`34` Part 1c, Part 7): fill level
is how close a wheel's combined force is to `μg`, the threshold is Part 25's
"cup" region where more slip stops producing more grip, and the decay rate
should read input *jerk* as well as magnitude (`34` Part 1d, Part 14 —
suspension responds as a damped oscillator, and step inputs excite it while
smooth ones don't).

**The specific loss-of-control trigger has a precise, cheap formula**, not
just a fill-level threshold: `|a_y − v·ψ̇| > ε_threshold` (`20` §1, sourced
from `35` §3.1). Compares actual lateral acceleration against what the
current yaw rate predicts in a stable turn — a multiply, a subtract, an
absolute value, using quantities the physics engine already produces every
tick.

**Why it matters:** on a phone you have no force feedback and no seat-of-the-
pants feel. This makes limit-driving *visible*. It works identically for street
and professional tiers because it is about instability, not violence.

### 2.4 Damage model
RVP's `VehicleDamage` — mesh deformation, `ApplyDamage()`, `Repair()`. Motors
and transmissions lose output as they take damage.

**On-premise for your mechanic protagonist.** Repair cost is also a natural
recurring economy sink (§2.7).

### 2.5 Race system
Design from Unity's ECS sample (`04` §3), reimplemented in MonoBehaviour form:
- Checkpoint-gated lap validation (cheat-resistant by construction)
- Position/ranking from checkpoint progress
- Race lifecycle state machine
- Out-of-bounds detection and respawn

**AI:** RVP's `FollowAI` + `VehicleWaypoint` (per-waypoint speed percentage =
racing line profile). Add Ishaan35's trick (`04` §5) — randomise which path each
AI takes so the field is not robotic.

### 2.6 Dual rating system
**From iRacing (`07` §2.3). The mechanic that makes your career arc real.**

- **Pace rating** — how fast
- **Safety rating** — how clean; contact costs it regardless of result

**Street tier:** contact is tolerated or rewarded.
**Professional tier:** safety rating gates event entry.

The player must *unlearn* aggressive habits to progress. That is a progression
arc, not just bigger numbers.

### 2.7 Economy
**Data model from CrazyCar (`code/CrazyCar-MIT/SCHEMA-NOTES.md`):** catalog
table + ownership table, with the equipped item denormalised onto the player.

**Two-axis gating (`05` §1.2):**
- Reputation/licence class unlocks the *catalog*
- Money buys the *part*

**Late-game sinks — design now, not later (`05` §1.5).** Mad Max players finish
with 15–20k of useless currency. Your sinks:
- Consumables: tyres, fuel, brake pads, engine rebuilds
- Repair costs (feeds off §2.4)
- Staff wages once the pro shop opens
- Entry fees scaling with tier
- **Class brackets (`06` §2.2)** — a maxed car locks out of lower classes, so
  you need multiple builds. The cleanest sink, and authentic.

### 2.8 Asynchronous ghosts
**From Real Racing 3 (`07` §3.5). Act on this early.**

Record player input/position traces per lap; replay them as opponents. Store
using the `time_trial_record` pattern from the CrazyCar schema.

**You get rivalry, leaderboards, and a populated world with no netcode, no
servers, and no matchmaking.** For a solo developer this replaces months of work
with days.

### 2.9 Career and tiers

| Tier | Identity | Mechanics introduced |
|---|---|---|
| **Street** | Skill before money (Initial D, `07` §1.4) | Basic tuning, contact tolerated, wins come from line and braking |
| **Club** | Money and machinery | Full tuning depth, class brackets, safety rating introduced |
| **Professional** | Operation, not just driving (GRID, `07` §2.2) | Endurance, fuel/tyre strategy, team and sponsors, staff |

**Named build recipes (`05` §1.3)** span all tiers — assemble a full spec, earn
a title or livery.

### 2.10 Property ladder
House -> garage -> pro shop -> warehouse. From Test Drive Unlimited (`07` §2.1)
and Mad Max strongholds (`05` §1.4).

Each tier provides: storage capacity, passive income, reduced repair cost, or a
fabrication tier gate (only the pro shop builds custom diffs).

**Storage as a real constraint.** Wanting a car you have nowhere to put is a good
problem to give a player.

### 2.11 Post-race telemetry
**From Ford v Ferrari (`07` §1.1): failure must generate the next fix.**

A lost race should name a specific problem — "understeer on exit, sectors 2 and
4" — that points at a tuning parameter. This is what closes the loop between
your physics sim and your progression, and it is the reason to have deep tuning
at all.

---

## 3. Build order

**Phase 1 — Prove the core (nothing else matters if this fails)**
1. TORSION + RVP integration in Unity 6 URP; assess the upgrade cost
2. One car, one track, driving that feels good
3. **Profile on a real iPhone for 15 minutes.** Thermals and frame pacing
   (`03-PLATFORM-NOTES.md`). If this fails, the design changes.
4. Touch input scheme that works at speed

**Phase 2 — The loop**
5. Race system: checkpoints, laps, position, AI opponents
6. Ragged edge instability meter
7. Basic tuning on 3–4 parameters
8. Money in, parts out

**Phase 3 — The depth**
9. Full seven-subsystem tuning with packaging/weight constraints
10. Damage and repair
11. Post-race telemetry that names problems
12. Asynchronous ghosts

**Phase 4 — The career**
13. Dual rating system and tier gating
14. Class brackets
15. Property ladder
16. Named build recipes
17. Economy sinks

**Phase 5 — Content**
18. Expand car roster (budget 4–8 weeks each — `09` §1)
19. Additional tracks
20. Story beats

---

## 4. Scope, decided

A full-physics sim, an action layer, and an RPG progression economy with an
upgradable property ladder is **three games' worth of systems**. The tuning
depth specified here — seven subsystems, each individually adjustable — is
comparable to what dedicated simulation studios ship with teams.

**Decided: simulation is the reason someone plays.** Action and RPG are real,
built to the depth specified throughout this package, and not afterthoughts —
but when a scope cut has to happen, it comes from those two first, never from
the physics.

**What this actually means in practice:**

- **Build order follows this priority.** Where §3 above doesn't force a
  sequence, simulation systems (the tyre model, the dyno, the instability
  meter) get first claim on schedule and iteration time. Action-layer systems
  (outruns, touge duels, aggression scoring) and RPG systems (the economy, the
  property ladder, narrative beats) are built to spec but are what gets
  trimmed first if the schedule tightens.
- **Asset and audio budget follow the same order.** `09` and `10`'s budgets
  assume this priority — tyre curve authoring and engine audio depth are not
  the line items to cut when the roster needs to shrink.
- **The dyno prototype (`31` Part 7) is not just the first thing to build — it
  is the test of whether this whole decision is correct.** If a differential
  change isn't perceptible on a phone, simulation depth isn't a viable
  differentiator and this section's decision needs revisiting before anything
  else does.

This is not a hedge. CarX Street has the open world. Assoluto has physics with
no career. Nobody has physics depth plus a real mechanic's career — that gap
is the actual bet this project is making, and simulation is the system that
has to be right for the bet to pay off.
