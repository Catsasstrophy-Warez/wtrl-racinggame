# The Three Unspecified Systems: Race Formats, Ghosts, and Objectives

**What this is.** `20-CONCEPTS.md` §8, §9, §13, §19, and §21 named five
systems in one paragraph each and never returned to them — no other
document in this package specifies them further. This closes that gap:
three race event formats, the time-shifted ghost/Autolog layer, and
objective-based scoring. All three wired into rivals (`30`), the career
structure (`33`), and the physics already built, not designed in
isolation.

---

**A fourth format — pursuit and escape — is specified in
`50-ACTION-PILLAR-EXPANDED.md` Part 3**, kept separate from the three
below since it's specifically the action pillar's format, built around
the aggression economy staying fully active rather than restricted the
way outruns, touge, and knockout each are.

# PART 1 — Three race formats

**Why three, not one generic "race" type**: `20` originally proposed these
as distinct because they test different things. Specified properly below,
that distinction holds — each format exercises a different part of the
physics and a different part of the career.

## 1.1 Outruns

**The format**: two cars, a defined route, no fixed finish line. Win by
opening a **300m gap** and holding it, or by remaining ahead when the
route ends.

**What it tests**: raw pace and the aggression economy (`20` §10) —
contact is viable here, since there's no shared finish line to
disqualify a shove. This is the format for the **street tier** (`33`
Part 2) specifically, and the first format the player meets. It should
be the first time the player challenges a persistent rival by name
(`30` Part 3).

**Live feedback**: a persistent gap readout (`+0.6s` style, already
established as the HUD pattern in earlier design work), building or
shrinking in real time — the tension is entirely in that number.

**Scoring**: binary win/loss on the gap, but the *margin* feeds §3's
objective system below (e.g. "win by 5+ seconds" as a bonus objective).

## 1.2 Touge duels

**Now implemented** — `code/prototype/RaceEventLogic.cs`'s `TougeDuelEvent`, previously only a `RaceFormat` enum value with no win-condition logic.


**The format**: two cars, a technical mountain-pass-style route,
**proximity scoring** instead of a gap. Win by staying within a threshold
distance of the car ahead — or ahead yourself — for a cumulative
**10-second lead** across the route, not by distance.

**What it tests**: technical driving under pressure, not raw pace. This
is deliberately **not** the aggression economy's format — the road is
too tight for contact to be a viable strategy, so the format itself
enforces clean driving without needing the Safety Rating to intervene.

> **This is the Constant's format** (`30` §3.2). He's un-counter-buildable
> specifically because touge duels don't reward the car — they reward
> reading the road, and he's the character who's better at that than the
> player's build can compensate for.

**Live feedback**: relative position (ahead/behind) plus a small
proximity meter, not a gap in metres — the format cares about *staying
close*, and a metre readout would misrepresent what's actually being
measured.

## 1.3 Knockout events

**Now implemented** — `code/prototype/RaceEventLogic.cs`'s `KnockoutEvent`, same gap.


**The format**: a field of multiple competitors (rivals plus passers-
through, `30` §3.4), racing a full circuit. **Last place is eliminated
at each defined checkpoint** (typically each lap), field shrinking round
by round until one car remains.

**What it tests**: consistency under a shrinking field, and — uniquely
among the three formats — genuine multi-car racecraft rather than a
single rival matchup. This is the **professional tier** format (`33`
Part 5), introduced once the Safety Rating (`20` §11) is already active,
since a knockout field with contact scoring disabled produces exactly
the clean, high-stakes racing the professional tier is supposed to feel
like.

**Live feedback**: a position ladder showing who's currently in
elimination range, updating each checkpoint — the tension is watching
the bottom of that ladder as much as watching the front.

## 1.4 Mapping formats to the career

| Format | Tier (`33`) | Rival system tie-in |
|---|---|---|
| **Outruns** | Street | First challenge to a named rival |
| **Touge duels** | Club, into Professional | The Constant's format specifically |
| **Knockout** | Professional | Multi-rival fields, elimination pressure |

---

# PART 2 — Time-shifted ghosts and the Autolog layer

**The entire async multiplayer system**, previously a single paragraph.
`07` and `19` both cite this as a real contributor to Real Racing 3's
thirteen-year lifespan — no netcode, no matchmaking infrastructure, no
server cost, and it's the reason this package has repeatedly flagged it
as the right multiplayer model for this project (`20` §21 originally,
now specified in full).

## 2.1 What gets recorded

A **ghost** is a compact time-series recording of one completed run:
position, rotation, and speed sampled at a fixed interval (a physics
tick or a coarser sample rate — cheap either way, since this is playback
data, not simulation input), tagged with the event, the car and tune
used, and the resulting time.

**Recorded automatically on every personal-best run**, no player action
required — the system should never ask "do you want to save this," since
that's exactly the kind of friction async systems die from.

## 2.2 What the ghost actually is, on screen

A translucent rendering of the recorded car, driving the exact recorded
line, visible during a live run as a **chase target** — the format
CSR2's dyno benchmark already established a taste for in this package
(`31` §6.3, "the gap between the dyno number and what you actually
achieve is driver skill, named explicitly"). The ghost is that same idea,
made visible and literal: **a car-shaped version of the number you're
trying to beat.**

**Two ghost sources, not one**:

- **Your own best** — the default opponent for solo practice, always
  available, no connectivity required
- **A rival's recorded run** — per §2.4 below, letting the player race
  a specific named rival's actual best even when that rival isn't
  "present" in the current career beat

## 2.3 The Autolog layer

**First code for this system in `code/prototype/AutologNotification.cs`** — built when `59-TRENDS-GTA-PASSIVE-INCOME.md` needed the same notification shape for a second message source and a self-check caught that this system had never actually been implemented despite being specified here.

After any event, a short, non-blocking notification: *"[Name] beat your
time on [event] by [margin]."* Sourced from whichever ghosts are
available — rivals, or (if any online layer exists later) other players'
synced times.

**Deliberately not a live leaderboard the player has to check.** The
notification comes to the player; the player doesn't go hunting for it.
This matches the mobile session-length discipline already established
throughout `20` and `33` — the system should create a reason to open the
app again, not a reason to stay in it longer right now.

## 2.4 ⚠️ The finding that ties this system to the rivals

`30` Part 3 already specifies six persistent rivals who remember specific
things the player did across sixty years. **Ghosts are the mechanical
delivery system for that persistence.**

> A rival who "left" the career narrative — retired, handed the car to
> someone younger, became an engineer (`30` §3.5) — doesn't have to
> disappear from the game entirely. **Their best recorded run stays
> available as a ghost, forever**, on whatever event they were once
> fastest at. The player can still race the Constant's best lap from
> 1978 in 2022, as a ghost, even though the narrative Constant of 2022 is
> the one who can't drive any more.
>
> That's not a technical convenience — it's the persistence theme from
> `30` made literal and replayable, at zero additional content cost
> beyond the recording system this section already specifies.

## 2.5 Data cost

A ghost recording is small — position/rotation/speed samples, not a
video or a full replay buffer. Storing one ghost per event per rival
(six rivals, plus the player's own best, per format per era) is a data
volume problem measured in kilobytes per record, not a production
budget line. This is, deliberately, the cheapest system in this
document to actually build.

---

# PART 3 — Objective-based scoring: stars, not just position

**Now implemented** — `code/prototype/ObjectiveTracker.cs`, all five objectives, the three-star cap enforced exactly as specified below. **Simulated and confirmed working** (`62-SIMULATION-AND-TESTING-PASS.md` Part 3) — the instability objective genuinely differentiates normal from reckless driving, with one production-tuning note about exactly how sustained "pinned at max" needs to be to fail it.


**The system that lets a player advance without winning outright** —
`20` §19's original one-line pitch, now specified.

## 3.1 The objective set, per event

Each event carries a small set of **independent, always-visible
objectives**, not a hidden scoring formula:

| Objective | Ties into |
|---|---|
| **Finish in the top N** (or beat the named rival, for the two-car formats) | The event's own win condition |
| **Beat your personal best** | The ghost system, §2 |
| **Complete with no contact** | The Safety Rating (`20` §11) |
| **Keep the instability meter under a threshold average** | The ragged-edge meter (`20` §1) |
| **Win by a defined margin** (outruns) / **hold the lead threshold with room to spare** (touge) | The format's own scoring, §1 |

**Three stars per event, from up to five available objectives** — the
player doesn't need all five, and which two or three they chase is a
real choice, not a checklist.

## 3.2 Why this matters more on mobile than elsewhere

A player who can't currently win a given rival matchup — car not yet
built for it, or genuinely not skilled enough yet — still has something
real to do: chase the clean-driving objective, chase their own ghost,
chase the instability-average objective. **No session has to end in pure
failure.** This is the direct mechanical answer to the mobile
session-length problem `20` and `33` raise repeatedly: even a "loss" can
close with a star earned.

## 3.3 What stars unlock

Not cosmetic. **Stars gate progression the same way money and reputation
already do** (`33` Part 3) — a defined star total per era unlocks the
next career beat, independent of whether every event in that era was
*won*. This means a player can advance the story by being a clean,
consistent driver who doesn't win everything, which is a genuinely
different profile than "the fastest driver," and the game should let
that profile exist.

---

# Cross-references
- Original one-paragraph concepts → `20-CONCEPTS.md` §8, §9, §13, §19, §21
- Persistent rivals and their exits → `30-NARRATIVE-DESIGN.md` Part 3
- Career tiers and formats per phase → `33-ACT-STRUCTURE.md`
- The instability meter → `20-CONCEPTS.md` §1
- Safety Rating → `20-CONCEPTS.md` §11
- The dyno-benchmark framing this borrows for ghosts → `31-DYNO-ANALYSIS.md` §6.3
- Async multiplayer as a cost/lifespan advantage → `07-INFLUENCE-MAP.md`, `19-NFS-DOSSIER.md`
