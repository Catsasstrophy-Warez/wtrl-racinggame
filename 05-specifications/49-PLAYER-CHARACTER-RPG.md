# The Player Character: Earned, Not Allocated

**What this is.** Every RPG system in this package so far belongs to
the car or the shop — parts, pricing, property tiers, reputation with
dealers. Nothing tracks the *person*. This closes that gap, built from
a line already sitting in `30-NARRATIVE-DESIGN.md` §3.1: **the
protagonist's actual skill is "looking at a car and knowing what it
does."** Everything below is that sentence, turned into systems.

**The governing rule, stated once so it doesn't need repeating in every
section:** nothing here is a menu the player spends points in. Every
system tracks what the player actually did and reflects it back —
consistent with the physics-first, simulated-not-authored principle
this whole package has held since `20` §2.

---

# PART 1 — Driver License Grade

## 1.1 What it is, and what it isn't

A progression track for **the driver, not the car or the shop** —
real-world motorsport licensing bodies grade drivers this way
precisely because a car's specs and a driver's proven ability are
different questions, and this project already has systems answering
every other version of that question:

| System | What it actually measures |
|---|---|
| Class brackets (`20` §16) | Whether *the car* qualifies for an event |
| Two-axis gating (`48` Part 2) | Whether *a shop* trusts this player enough to sell |
| Safety Rating (`48` Part 3) | *Conduct* during results |
| **Driver License Grade** | **Whether this specific person has proven they can drive at this level** |

**A fully-built Race-tier car does not bypass this.** A player can own
the fastest car in the game and still be license-gated from the top
event tier until they've proven it in a slower one.

## 1.2 The grades, and how they're earned

Four tiers, matching real licensing structures used to gate
competition entry in actual motorsport — the game's own fictional
naming, the real underlying logic:

| Grade | Earned by | Gates |
|---|---|---|
| **Provisional** | Starting grade | Street tier only |
| **Club** | A set number of clean results (Safety Rating above threshold during the result, per `48` §3.2) at street tier | Club-tier events, touge duels |
| **Contender** | Clean results across multiple job types in the shop-driver bridge (`33` §2.3) — proof across *different kinds* of driving, not repetition of one | Professional-tier entry, knockout events |
| **Licensed** | Sustained clean results at Contender level | No further event gate — the ceiling is the car and the player now, not the license |

**Grade can regress.** A sustained drop in Safety Rating at a given
grade can demote it — a real license can be suspended, and this
system should be able to take back what it granted, not just
accumulate forever.

## 1.3 Why this is the real mechanism behind Act Two

`33` §2.1 already states the shop-driver bridge's premise directly:
*"nobody hands a street racer a professional drive... they hand him a
test session first."* **This section is what that sentence was always
describing mechanically, just never named as a system.** The five job
types (`33` §2.3) are the Contender-grade proving ground; completing
them is why the professional licence exists to be handed to the
player at the 1996 story beat (`33`'s own timeline) rather than being
purchasable.

---

# PART 2 — Diagnostic skill

## 2.1 The direct extension of `30` §3.1

Three systems already exist that this section makes *progressively
more legible* as the player uses them, rather than gating behind a
skill point:

- **The rival inspection system** (`25` §4.5b, `30` §3.1) — walking a
  rival's car at a meet and reading its spec
- **Post-race telemetry that names the fault** (`20` §5)
- **The dyno** (`31`)

## 2.2 How it grows — reps, not points

**Every use of the three systems above is a rep.** No menu, no
allocation. The game tracks a simple use-count per system, and
crossing thresholds unlocks *more information being shown*, not a new
mechanic:

| Early game | After sustained use |
|---|---|
| Rival inspection shows broad stats only (power band, general setup) | Shows specific tells — a worn part, an unusual tune, the kind of detail that lets `30` §3.1's "read their build, then race them for the piece you want" actually work as intelligence, not just flavour |
| Post-race telemetry names one fault | Telemetry can surface secondary, compounding faults — the same diagnostic depth a real mechanic gains with experience |
| Dyno curve display is the raw graph only | Dyno annotates likely causes directly on the curve — the player is now reading it the way the mentor used to read it *for* them |

## 2.3 ⚠️ The payoff this closes: the mentor's arc, mechanically

`30` §1.4 already specifies the mentor becoming obsolete as the
narrative's emotional core — *"he doesn't have to be wrong for the
player to start needing him less."* Diagnostic skill is the
**mechanical instrument that makes that arc measurable, not just
felt**:

> **The mentor's commentary during installations** (`25` §6.2b)
> **should shorten as diagnostic skill rises** — not because he's
> saying less, but because the game increasingly lets the player spot
> the thing he'd have pointed out, a beat before he says it. Early
> game, his line lands first. Late game, the player's own read of the
> telemetry gets there before he opens his mouth, and the line that
> used to be information becomes a line that's just... company.

This is the single strongest connection in this whole document —
a narrative beat that was already fully written (`30` §1.4) gets a
genuine mechanical trigger instead of firing on a fixed story
timestamp.

---

# PART 3 — Emergent reputation traits

## 3.1 Not chosen — observed

No trait menu. The game reads the same histories `48` Part 2.3 already
tracks for reputation, and `48` Part 3.2 already tracks for Safety
Rating, and surfaces **descriptive traits** back to the player and, more
importantly, **to the AI**:

| Play pattern observed | Trait surfaced | What it changes |
|---|---|---|
| Consistently high Safety Rating across many results | "Clean racer" | Rivals' `passAttemptSuppression` (`32` §5.3) rises faster when intimidated — a rival respects a clean driver's pressure differently than an aggressive one's |
| Frequent contact at street tier, within the aggression economy's allowed cost (`20` §10) | "No stranger to contact" | Rivals' `defensivePositionError` rises — they defend *harder*, not softer, matching the wary-not-scared distinction already established for Vogel specifically (`45` §1.3) |
| High diagnostic-skill use count relative to career length | "Reads a car fast" | Rival inspection (`25` §4.5b) reveals tells one tier earlier than the base progression in Part 2.2 above would give |
| A named build recipe (`48` Part 1) completed for every real trim-ladder tier in a generation | Title unlock, per generation | Cosmetic and narrative only — the mentor has a specific line for a player who's built the full ladder, not just one car |

## 3.2 Why this stays consistent with the rest of the package

Every trait above is a **read of an existing tracked history**, not a
new currency. Nothing is spent, nothing is chosen from a list — the
same discipline `48` already applied to recipes, reputation, and the
Safety Rating. The player builds a character by playing, and the
character the game shows back to them — and to the AI field around
them — is just an honest report of what actually happened.

---

# Cross-references
- The core skill this whole document extends → `30-NARRATIVE-DESIGN.md` §3.1
- The mentor's obsolescence arc, now mechanically triggered → `30-NARRATIVE-DESIGN.md` §1.4
- The shop-driver bridge and its five job types → `33-ACT-STRUCTURE.md` §2
- Two-axis gating, class brackets, Safety Rating → `48-RPG-SYSTEMS-SPEC.md`
- AI intimidation parameters this feeds → `32-HERO-CAR.md` §5.3
- The aggression economy → `20-CONCEPTS.md` §10
- Rival-specific behaviour precedent (Vogel) → `45-RIVAL-DEVELOPMENT.md` §1.3
