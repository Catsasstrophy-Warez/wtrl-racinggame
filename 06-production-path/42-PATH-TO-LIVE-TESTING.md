# The Path to Live Testing

**What this is.** The first document that reads the other 41 as a single
ordered checklist rather than as independent research and specification.
Everything below traces to a specific document; nothing here is new
design, only sequencing.

---

**A real, honest content-volume audit is in
`07-content-resolution/51-CONTENT-INVENTORY.md`** — checked after a competitive comparison
raised the question directly. Short version: one full vertical slice
exists (one generation, one rival encounter, one track, one format).
Every other category has a complete system behind it and zero built
instances. Worth reading before assuming this checklist's "minimum
content" items in Part 2 below scale to the rest of the roster for
free — they don't; the pipeline does the heavy lifting, but each
instance still needs to be made.

# PART 1 — Blocking

Nothing past this section matters until all three resolve.

## 1.1 Compile against real RVP/TORSION

Run `code/prototype/migrate-to-unity6.sh` against an actual RVP checkout.
Paste in `code/prototype/Tire-URP.shader`. Wire `TireForceModel.cs`,
`RaggedEdgeMeter.cs`, `DynoController.cs`, `EngineFamily.cs`/
`EngineVariant.cs`, `EngineBayMeshManager.cs`, and `TransmissionSpec.cs`
into the project. **Fix whatever the real compiler catches that static
analysis in `RVP-TRIAGE.md` couldn't** — the triage was thorough but was
never run through an actual compiler.

## 1.2 Confirm the car drives

Not well. Correctly. Wheels turn, the deformation shader behaves
sensibly (the world-space/object-space judgement call flagged in
`Tire-URP.shader`'s own comments needs visual confirmation here), nothing
breaks on contact.

## 1.3 ⚠️ The dyno pass condition — the actual gate

`03-physics-research/31-DYNO-ANALYSIS.md` Part 7, restated in `02-design-research/11-SYSTEMS-SPEC.md` §2.1/§2.3:

> Change one differential setting. The curve moves visibly. The lap time
> moves measurably. The player feels it through tilt.

**Run on both a 60Hz device and a Pro-tier ProMotion one**, per
`03-physics-research/36-IPHONE-SPECIFIC.md` §2.3 — the answer may genuinely differ by device
tier, and that's a finding to record, not an error to explain away.

`code/prototype/simulation/` already confirms the first two criteria
numerically (71% force difference at 0.7g → 2.32s/43% lap-time
difference). **The third criterion is the one nothing but a device has
ever been able to answer**, and it's the reason every other item in this
document is sequenced after it.

**If this fails**: the tuning-depth thesis itself (`20` §2, `11` §4) needs
revisiting before anything below is worth building further.

---

**Items 3–10 below now have concrete numbers and decisions in
`43-FIRST-PLAYABLE-SPECS.md`** — including a real anachronism caught and
fixed there: the Constant's "front-drive hot hatch" description doesn't
work for his 1965 appearances, since that car category didn't exist yet.

# PART 2 — Minimum content for a test loop to exist

## 2.1 One drivable car

The **1965 generation** specifically (`05-specifications/32-HERO-CAR.md` §7.1) — the
tutorial car, the simplest engine family (`04-vehicle-and-drivetrain-research/37-FORD-V8-AUDIO.md` Part 2),
and the generation the restoration narrative already opens on
(`05-specifications/30-NARRATIVE-DESIGN.md` Part 2).

## 2.2 One circuit

No requirement to be a real track — needs corners tight and fast enough
to exercise the instability meter (`20` §1) meaningfully across its full
range, not just at the edges.

## 2.3 One rival: the Constant

`05-specifications/30-NARRATIVE-DESIGN.md` §3.2 — the calibration rival, un-counter-
buildable, present in every era. Using him first means the first test
opponent is the one whose difficulty is guaranteed not to be a build
problem in disguise.

## 2.4 One race format: outruns

`05-specifications/41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 1.1 — the simplest of the
three specified formats. Build this end to end before touge duels or
knockout events; the latter two can follow once the loop is proven.

## 2.5 A partial garage

`05-specifications/25-GARAGE-DESIGN.md` Part 2's seven stations, **three minimum**: Hero,
Lift, Engine Bay. Enough to install one part and watch a sequence play;
Interior, Parts Wall, Desk, and Bay Overview can follow.

## 2.6 A basic dyno UI

`03-physics-research/31-DYNO-ANALYSIS.md` §6.2's curve display and §6.3's benchmark number.
No decoration required yet — the chart and the figure are the test.

---

# PART 3 — Needed for the test to be meaningful, not merely running

## 3.1 The instability meter's full feedback loop

Visual gauge, the three-tyre-sound crossfade (`02-design-research/10-AUDIO-DESIGN.md`,
squeak → squeal → squall), and the Core Haptics pattern
(`03-physics-research/36-IPHONE-SPECIFIC.md` Part 1.3) — **all three together.** The design
question being tested is whether the player reads the limit correctly,
and that requires the actual multi-sense system, not a placeholder bar
standing in for it.

## 3.2 One installation sequence

The **wheels sequence** specifically (`05-specifications/25-GARAGE-DESIGN.md` Part 6) —
shortest of the four, strongest audio payoff. Building this one first
also directly tests the tier-escalation idea (§ Part 7 there): does a
house-tier install genuinely read as lesser than a pro-shop one.

## 3.3 Basic mentor commentary during that sequence

`05-specifications/30-NARRATIVE-DESIGN.md` §1.3's diagnostic voice. **Text is sufficient
for this phase** — the pattern being tested is whether commentary during
installation lands as a lesson rather than noise, which doesn't require
finished voice acting to evaluate.

## 3.4 Session persistence

Enough save state that closing and reopening the app doesn't lose
progress. Without this, every test session is a cold start, and nothing
about return-engagement or the async ghost system (`41` Part 2) can be
evaluated at all.

---

# PART 4 — Explicitly deferred

Not because these are unimportant — because none of them change the
answer to what Part 1 is testing, and building them before Part 1 passes
risks producing polished content on top of an unconfirmed foundation.

- The remaining six hero-car generations (`32` §7.1)
- The other five rival archetypes and all six passers-through (`30` Part 3)
- The 1987 choice and the mentor's full obsolescence arc (`30` Parts 2, 1.4)
- The property ladder beyond the driveway/garage tiers (`25` Part 7)
- The second engine acoustic family and full texture layering (`37` Part 8)
- Time-shifted ghosts and the Autolog layer (`41` Part 2)
- Touge duels and knockout events (`41` Parts 1.2, 1.3)
- The star/objective scoring system (`41` Part 3)
- Android (`03` — planned "eventually," not now)
- Any full art pass on anything

---

# Cross-references
- The dyno pass condition in full → `03-physics-research/31-DYNO-ANALYSIS.md` Part 7
- Numerical pre-validation → `code/prototype/simulation/`
- The RVP triage this depends on → `code/prototype/RVP-TRIAGE.md`
- Device-tier risk to the pass condition → `03-physics-research/36-IPHONE-SPECIFIC.md` §2.3
- Garage stations → `05-specifications/25-GARAGE-DESIGN.md` Part 2
- Race formats → `05-specifications/41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 1
- The Constant → `05-specifications/30-NARRATIVE-DESIGN.md` §3.2
