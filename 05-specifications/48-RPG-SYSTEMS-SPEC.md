# The RPG Layer, Fully Specified: Recipes, Gating, and the Safety Rating

**What this is.** `20-CONCEPTS.md` Part 3 named seven RPG systems.
Repair costs, property tiers, and the shop-driver tier all got real
mechanical depth elsewhere in this package. Three didn't: **named build
recipes** (§17), **two-axis gating** (§15), and the **Safety Rating**
half of dual rating (§11) — narratively meaningful in `30`, never given
a formula. All three specified here, tied into the pricing, class,
and career systems already built rather than designed in isolation.

**Checked as a whole, not just system by system, once the number of
RPG systems grew to nine total across this document, `49`, `50`, and
`59`** — `08-trends-and-cross-genre/64-ROYAL-MATCH-NINE-SYSTEMS-
ANALYSIS.md`. Seven of the nine have zero dedicated UI at all,
confirmed against Royal Match's own real testing data on light-versus-
heavy meta layers, and one real cross-system gap was found and fixed
in the process.

---

# PART 1 — Named build recipes

## 1.1 What a recipe actually is

A **saved configuration of the seven-subsystem tuning table** (`25`
Part 5), given a player-chosen name, storable and reloadable from the
garage's Desk station (`25` §4.5). Not a vague "loadout" — a specific,
inspectable spec sheet: every subsystem's current parts and calibration,
snapshotted.

## 1.2 The two recipe types

**Free-form recipes**: the player builds whatever they want and names
it. No target, no reward beyond organization — useful the moment a
player owns more than one competitive setup and needs to switch
between them without re-tuning from scratch.

**Target recipes**: a defined build brief the game hands the player —
*"a canyon-carver," "a drag special," "a wet-weather setup"* — with
real, checkable thresholds (weight-to-power ratio inside a range,
minimum downforce, a specific differential type). Completing one earns
a **title and, where appropriate, a livery unlock** — the reward `20`
§17 originally specified, now mechanically grounded.

## 1.3 Where target recipes come from

**The real trim ladder already cited as the model** (`13` §2: base →
performance → factory hot → homologation → tuner halo) gives five
natural target recipes per hero-car generation — thirty-five across
the full seven-generation span, though not all need to be built as
distinct content on day one (`42`'s deferred-list discipline applies
here too: ship the pattern with a handful of real targets, expand
later).

**A second source, free**: `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md`
Part 3's objective system already tracks per-event performance. A
target recipe that happens to also satisfy a specific event's
objective set (clean-driving threshold, instability-average ceiling)
can surface as a *suggested* recipe name rather than a hand-authored
one — "you've built something that would ace the touge format" — free
content generated from systems that already exist.

## 1.4 What a recipe interacts with

- **Class brackets** (`20` §16): a recipe's stat profile determines
  which bracket it qualifies for. Naming a recipe is also, implicitly,
  declaring which bracket it's built for.
- **Repairable/replace-only parts** (`38` §1.3, `47` §1.3): a saved
  recipe should flag which of its parts are due for replacement next
  time it's loaded, so switching to an old recipe doesn't silently
  hand the player a worn build.
- **The mentor's voice** (`30` §1.3): completing a target recipe is a
  natural moment for a specific, earned line — not generic
  congratulation, a comment on *that* build's actual character.

---

# PART 2 — Two-axis gating

## 2.1 The two axes, precisely

**Axis one — money.** Buys any part the catalogue currently shows.
Straightforward, already priced in full (`47` Part 1).

**Axis two — reputation.** Determines *what the catalogue shows at
all*, independent of money. A player with unlimited cash and no
reputation still can't buy Race-tier parts (`47` §1.1's tier
structure) — the shop won't sell them, not because the player can't
afford them.

## 2.2 ⚠️ Why this is a different gate from property tiers and class brackets, not a redundant one

**Enforcement now real** — `code/prototype/RaceEventLogic.cs`'s `EventEntryGate` calls `ClassBracket.QualifiesForBracket()` and `DriverLicense.PermitsEntry()` together, kept as two separate answers rather than one collapsed boolean, matching this section's whole point.

Three systems already gate parts access in this package, and they
need to stay genuinely distinct or the RPG layer collapses into one
disguised meter:

| System | What it gates | The real-world logic |
|---|---|---|
| **Property tier** (`25` Part 7) | Whether Race-tier parts exist *at this location at all*, and labour availability | Facility capability — a driveway has no lift for a differential swap, regardless of who's asking |
| **Class brackets** (`20` §16) | Which *events* a built car can enter | The car's own stats — a maxed build is too fast for a lower bracket |
| **Reputation** (this section) | Which *parts* a shop will sell, regardless of money or property tier | Trust — a dealer won't sell serious hardware to an unknown |

**A player at the warehouse tier, with money, can still be refused a
part by a shop that doesn't know them yet.** That's the axis this
section adds, and it's the one that makes reputation feel like a
real, separate currency rather than a second wallet.

## 2.3 How reputation accrues

Tied directly to systems already built rather than a new meter to
invent from scratch:

- **Named-rival wins** (`30` Part 3) — beating a specific rival is
  worth more reputation than beating a passer-through, and beating the
  same rival repeatedly diminishes in reputation value (there's
  nothing left to prove against someone already beaten)
- **Shop-driver job completion** (`33` §2.3) — the five job types
  during the nine-year bridge era are themselves reputation-earning,
  which is *why* Act Two exists structurally: it's not just narrative
  bridging, it's the mechanical reputation grind that unlocks the
  professional-tier parts catalogue before the professional tier's
  own money starts flowing
- **Touge duel wins specifically** (`41` §1.2) — weighted higher than
  outrun wins, since the format tests skill independent of the build,
  which is exactly what a reputation-granting result should require

## 2.4 What reputation unlocks, concretely

**A second consumer of this same tracked value, added in `59-TRENDS-
GTA-PASSIVE-INCOME.md`**: shop passive income reads the identical
`ReputationTier` this section already gates parts purchases with — the
same trust that convinces a dealer to sell convinces an outside
customer to bring their car in.

Maps directly onto `47` §1.1's three parts tiers:

| Reputation tier | Catalogue access |
|---|---|
| **Unknown** | Stock-replacement only |
| **Known** | Performance tier unlocked |
| **Respected** | Race tier unlocked |
| **Trusted** | Forced induction and crank-swap options unlocked (`40` Parts 1–2) — the rarest, most consequential parts, gated behind the highest trust tier specifically |

---

# PART 3 — The Safety Rating, given a formula

## 3.1 The two ratings, kept genuinely separate

**Pace rating**: derived from event results — wins, margins, times
against ghosts (`41` Part 2). Already implicit throughout the career
structure; not the gap.

**Safety Rating**: tracks *how* those results were achieved,
independent of whether they were wins. This is the half that's had a
narrative role since `30` (*"gives the Safety Rating arc a face"*) but
never a mechanical one.

## 3.2 What moves it

| Event | Effect |
|---|---|
| Contact caused by the player | Decreases, scaled by severity |
| Off-track cut for advantage | Decreases |
| Causing a rival to spin or retire | Decreases sharply |
| Clean overtake, no contact | Small increase |
| Completing an event with zero incidents | Increase |
| Defensive driving that holds position without contact | Small increase |

**Scale**: a bounded rating, not an unbounded score — bounded metrics
communicate "where do I stand" far better than an accumulating number
with no ceiling, the same reasoning real racing-sim safety-rating
systems are built on.

## 3.3 The tier-dependent meaning — the aggression economy's other half

`20` §10 already establishes the street tier's aggression economy:
contact is a viable strategy there, costed but not forbidden. The
Safety Rating is the mechanism that makes the *professional* tier
behave oppositely, without needing a separate rule system:

> **Street tier**: Safety Rating exists and is tracked, but low
> ratings carry a light cost — some reputation gain suppressed, per
> §2.3, but no event lockout.
>
> **Professional tier, from the licence onward** (`33`'s 1996 entry
> point: *"Professional licence, Safety Rating"*): a minimum Safety
> Rating is required to **enter** knockout events (`41` §1.3)
> specifically. Fall below it, and the field simply won't have the
> player — not a punishment screen, a locked-out entry list, the same
> texture as a real racing licence being suspended.

**This is Rule 3's mechanical teeth** (`30` §2.5's earlier framing):
the unlearning the narrative already promises — *"unlearn what won you
street races"* — now has an actual gate behind it, not just a
character beat.

## 3.4 What it doesn't do

**Never punishes the instability meter's own findings.** A car that
crosses the ragged edge and recovers cleanly (`20` §1) is not a Safety
Rating event — losing grip is physics, not conduct. Only *contact* and
*deliberate track-limit abuse* move the rating. Conflating "drove at
the limit" with "drove dangerously" would undermine the entire
physics-first design principle this package has held throughout.

---

# Cross-references
- Original one-paragraph concepts → `20-CONCEPTS.md` §11, §15, §17
- The seven-subsystem tuning table → `25-GARAGE-DESIGN.md` Part 5
- Parts tiers and pricing → `47-PARTS-PRICING.md` Part 1
- Property tiers → `25-GARAGE-DESIGN.md` Part 7
- Class brackets → `20-CONCEPTS.md` §16
- Shop-driver tier and job types → `33-ACT-STRUCTURE.md` §2
- Named rivals → `30-NARRATIVE-DESIGN.md` Part 3
- Race formats → `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md`
- The aggression economy → `20-CONCEPTS.md` §10
- The narrative "unlearning" arc → `30-NARRATIVE-DESIGN.md` §2.5
