# First Playable: Concrete Specs for Checklist Items 3–10

**What this is.** `42-PATH-TO-LIVE-TESTING.md` listed what's needed; this
provides the actual numbers and decisions for items 3 through 10, so the
minimum test loop is buildable rather than still abstract. Item 3 (the
dyno pass condition) can't be executed without Unity and a device — what
follows for it is a precise protocol, not a result.

---

# Item 3 — The dyno pass condition: exact protocol

Run this exactly, on both device tiers, before trusting any result:

1. Load the 1965 hero car (Item 4) on the test circuit (Item 5).
2. On the dyno (`31` §6), record the baseline torque curve and the
   benchmark corner-exit time from `code/prototype/DynoController.cs`.
3. Change **one differential setting only** — preload, from open to a
   locked equivalent (`25` Part 5's differential row).
4. Record the new curve and new benchmark time. Confirm both moved
   (they should — `code/prototype/simulation/differential_test.py`
   predicts a measurable difference at realistic cornering loads).
5. Drive the outrun instance (Item 7) with each setting, back to back,
   same corner, same speed on entry. **Record whether the difference is
   felt through tilt — yes/no, plus a confidence rating (certain/maybe/
   no).**
6. Repeat steps 3–5 on the second device tier.
7. Record both results in `RVP-TRIAGE.md`'s status section, replacing
   "unconfirmed" with the actual outcome — pass, fail, or split by
   device tier.

**Do not average or round the confidence rating.** If it's "maybe" on
either device, that's the honest result to record, not a soft pass.

---

# Item 4 — The 1965 hero car, concrete starting state

**Narrative state**: mid-restoration, per `05-specifications/30-NARRATIVE-DESIGN.md` Part
2 — the car is driveable but degraded, not derelict. The player's first
dyno session (Item 3's protocol) is also the first in-fiction discovery
of the underspec engine (`30` §2.1).

**`EngineVariant` values** (`code/prototype/EngineFamily.cs`):
- `displacementLiters`: ~3.9 (matching the small-block reference range
  in `04-vehicle-and-drivetrain-research/37-FORD-V8-AUDIO.md` Part 2)
- `peakPowerHp`: **164** — deliberately below the ~195hp base-spec
  reference, representing the degraded starting state, not the
  restored target
- `redlineRPM`: **5500**
- `crankType`: CrossPlane (`04-vehicle-and-drivetrain-research/40-FORCED-INDUCTION-DRIVETRAIN.md` Part 2 —
  cross-plane throughout this entire family)
- `forcedInduction`: None at game start. The period supercharger (`40`
  §1.1) is the first meaningful upgrade available, not a starting part.

**`TransmissionSpec`**: 3-speed manual, matching `40` §3.1's base-trim
1965 reference — the 4-speed is an upgrade, not the starting gearbox.

---

# Item 5 — The test circuit

**Rendered above.** 1.4km, eight corners:

| Corner | Type | Radius | Tests |
|---|---|---|---|
| 1 | Hairpin | 25m | Low-speed instability meter response |
| 2–3 | Sweepers | 60m | Mid-speed, sustained lateral load |
| Back straight | — | 220m | Outrun gap-building (Item 7) |
| 4 | Braking zone into tight corner | 30m | Trail-braking, `30` §3.2's Constant format |
| 5–7 | Esses | 15–20m | Touge-style rapid direction change |
| 8 | Final, onto start/finish | 45m | Exit acceleration, differential test visibility |

**Corner 1's 25m radius is deliberately tight** — per the sensitivity
finding in `03-physics-research/34-PHYSICS-READING.md` (Beckman Part 17), small radius
changes near the limit produce large apex-angle swings, which is exactly
where a differential change should be most perceptible.

---

# Item 6 — The Constant, 1965-era: one real catch and its fix

**⚠️ `05-specifications/30-NARRATIVE-DESIGN.md` §3.2 describes the Constant's archetype as
a "front-drive hot hatch" across all eras. That's an anachronism for
1965** — the hot hatch as a category didn't exist until the late 1970s.

**Fix, era-appropriate**: for the 1965–mid-70s generations specifically,
the Constant drives a **lightweight, modest rear-drive compact** —
unassuming, not front-drive, but matching the same underlying
philosophy `30` establishes (nothing exotic, perfectly sorted, beats you
anyway). The front-drive-hatch description becomes accurate starting
from his mid-70s/late-80s appearances, once that category actually
exists.

**His 1965-era car, concrete**: lower peak power than the hero car's
starting 164hp, but **zero instability-meter penalty** for his driving —
he should be coded to a lower target fill-level ceiling in
`RaggedEdgeMeter.cs`'s per-driver tuning than any other AI in the field,
reflecting "nothing rattles him" mechanically, not just narratively.

---

# Item 7 — The first outrun, concrete parameters

`05-specifications/41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 1.1's format, instanced:

- **Route**: the back straight plus corners 4 through 8 (roughly 600m of
  the 1.4km circuit) — long enough to build or lose a real gap, short
  enough for a single test session to run many repetitions
- **Win threshold**: 300m gap, per the original spec — on this route
  length, achievable but not trivial
- **Opponent**: the Constant (Item 6), specifically because his
  consistent, unrattled driving makes the *player's* differential
  setting the actual variable under test, not opponent inconsistency

---

# Item 8 — Minimum garage: exact station list

`05-specifications/25-GARAGE-DESIGN.md` Part 2's three-station minimum, concretely:

1. **Hero** — the 1965 car, static, lit. No interaction beyond viewing
   for this phase.
2. **Lift** — raised state only needs to support the differential swap
   (Item 3's protocol) and the wheels installation sequence (`42` §3.2).
3. **Engine Bay** — bonnet-open state, showing the degraded engine
   (Item 4). Full disassembly granularity (`38`/`39`'s open question)
   is not needed yet — this phase only needs the bay to *look* correct
   and support the dyno hookup.

**Explicitly not needed for this phase**: Interior, Parts Wall, Desk, Bay
Overview. Add these once the minimum loop is validated.

---

# Item 9 — Dyno UI: minimum viable

`03-physics-research/31-DYNO-ANALYSIS.md` §6.2's curve display, reduced to what Item 3's
protocol actually requires:

- Live torque curve (from `DynoController.GetTorqueCurvePoints()`)
- The benchmark number (`DynoController.RunStraightLineBenchmark()`)
- **One visible readout for the differential setting itself** — open/
  locked as a simple toggle, not a full preload slider yet. The
  continuous version can wait; the binary version is enough to run
  Item 3's test.

No chart styling, no mentor commentary integration yet — those are
Item-11-and-later polish, not blocking for this phase.

---

# Item 10 — Instability meter: exact parameter values for this phase

`code/prototype/RaggedEdgeMeter.cs`'s existing fields, set for the first
test rather than left at placeholder defaults:

- `decayRatePerSecond`: **1.2** (existing default — no change needed
  yet, but confirm it against Corner 1's tight radius specifically once
  driving begins)
- `fillRatePerSecond`: **2.5** (existing default)
- `oversteerThreshold`: **3.0 m/s²** as a starting point, **but this is
  the single value most likely to need retuning once real driving data
  exists** — flag it for revision after the first test session, not
  before
- **Audio**: the three-tyre-sound crossfade (`02-design-research/10-AUDIO-DESIGN.md`) can
  ship with placeholder/stock tyre-squeal samples for this phase — the
  crossfade *logic* is what's being tested, not final audio quality
- **Haptics**: `03-physics-research/36-IPHONE-SPECIFIC.md` Part 1.3's continuous pattern,
  intensity mapped 1:1 to `fillLevel01` with no additional curve —
  tune the mapping curve only after Item 3's protocol produces real
  device feedback on whether the raw linear mapping already feels right

---

# Cross-references
- The checklist these items complete → `42-PATH-TO-LIVE-TESTING.md`
- Differential test data these numbers should match → `code/prototype/simulation/differential_test.py`
- The Constant's general archetype → `05-specifications/30-NARRATIVE-DESIGN.md` §3.2
- Hero car engine data model → `code/prototype/EngineFamily.cs`
- Race format source → `05-specifications/41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 1.1
