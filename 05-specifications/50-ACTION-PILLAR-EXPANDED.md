# The Action Pillar, Expanded: Aggression, Stunts, and Pursuit

**What this is.** `11` §4 decided sim is the primary pillar, with action
and RPG real but secondary. RPG just got two full documents (`48`,
`49`). This is the same treatment for action: the aggression economy
(`20` §10) was one paragraph with no numbers, drift/stunt scoring
existed only as extracted RVP code (`04`) with zero game-design
attached, and **pursuit and escape** — listed in `17` §2.3's own race
taxonomy — was never built at all, the one race type from that list
`41` didn't cover.

---

# PART 1 — The aggression economy, with real numbers

## 1.1 What triggers a reward, specifically

Not "contact is rewarded" in the abstract — three distinct triggers,
each different enough to need its own name:

| Trigger | What counts |
|---|---|
| **Forced error** | Contact that causes a rival to lose the racing line without them spinning outright — they brake, lift, or run wide |
| **Takedown-adjacent** | Contact that causes a rival to spin or retire — the strongest reward, and the one most likely to cost Safety Rating |
| **Held under pressure** | Maintaining position while a rival attempts contact on the player — rewards defensive driving without requiring the player to initiate |

## 1.2 The reward, and why it's small on purpose

**Nitrous charge** (Part 2 below) is the primary reward — immediate,
mechanical, felt instantly. A small cash bonus exists per event but is
deliberately minor relative to the real economic engine (`20` §14's
repair costs) — this system was never meant to be a second income
source, only enough to make risk *rational*, per its original framing.

## 1.3 The cost side — this is what makes it an economy, not a freebie

Every trigger in §1.1 also feeds the Safety Rating (`48` §3.2) in the
opposite direction, and carries real mechanical-failure risk (`20`
§7) proportional to contact severity. **The player is genuinely
trading two things they'll want later — a clean Safety Rating and an
undamaged car — for something they want now.**

## 1.4 ⚠️ Where this system is economically rational, and where it stops being so

This is the mechanical bridge `30`'s narrative "unlearning" arc has
been promising since the street-tier framing was first established,
made explicit as numbers rather than a character beat:

> **Street tier**: the reward outweighs the cost. Safety Rating
> penalties are real but don't lock anything yet (`48` §3.3), and
> repair costs at this tier are proportionally survivable.
>
> **Once the Driver License Grade (`49` Part 1) reaches Contender**:
> the exact same contact that was profitable now risks the license
> grade itself, since Contender requires sustained clean results.
> **The system doesn't change. The player's situation around it does**
> — which is the honest way to make a play style stop working without
> the game ever telling the player to stop.

---

# PART 2 — Stunt and drift scoring, given a place

## 2.1 The technical foundation already exists

`04-EXTRACTION-INVENTORY.md` already has the real parameters:
`StuntManager`/`StuntDetect`, a connect-delay so linked drifts count
as one combo, jump-distance scoring, a stunt array defined by
rotation axis, precision (dot threshold), angle threshold, score rate,
and repeat multiplier. **This section gives that code an actual game
design to serve**, since none existed before.

## 2.2 What stunts exist, specifically

- **Drift chains** — the existing connect-delay logic, unmodified
- **Jump distance** — the existing air-time/distance scoring, unmodified
- **Close calls** — new: a near-miss with a wall or rival at high
  relative speed. **This one is free to build** — the instability
  meter's fill level (`20` §1) already computes exactly the
  "how close to the edge" signal this stunt needs every physics tick;
  a close call is simply a high fill-level moment that resolves
  without contact, scored rather than just felt.

## 2.3 The resource stunts actually feed

**Nitrous, not just score.** A genuine mechanical resource, not a
number going up: a temporary boost to available engine force,
implemented the same way `DynoController.cs` already computes
traction-limited drive force — nitrous temporarily raises the ceiling
`TireForceModel.PeakLongitudinal()` allows, not a flat speed multiplier
divorced from the physics.

**Crashes cancel the combo and the banked charge with it** — already
specified in `04`, kept unchanged. The tension is real: chase a longer
chain for more nitrous, risk losing what's already banked.

## 2.4 ⚠️ Where this activity lives, and where it deliberately doesn't

Placed to differentiate the three race formats `41` already built,
rather than floating as a disconnected minigame available everywhere:

| Format | Stunt scoring active? | Why |
|---|---|---|
| **Outruns** (`41` §1.1) | **Yes** | The aggression-economy-friendly format; stunts and contact both make sense here |
| **Touge duels** (`41` §1.2) | **No** | A clean-driving-skill format by design — stunt scoring would contradict the format's whole point |
| **Knockout events** (`41` §1.3) | **No** | Safety-Rating-gated, professional tier — same reasoning as touge |
| **Free-roam** (between events) | **Yes** | The natural home for stunt-chasing without race stakes attached |

**This is the same discipline `48` and `49` already held**: a system
earns its place by fitting into what exists, not by being available
everywhere for maximum content volume.

---

# PART 3 — Pursuit and escape: the missing fourth format

## 3.1 Why this is a real gap, not a nice-to-have

`17-GENRE-TAXONOMY.md` §2.3 lists **"pursuit and escape"** in its own
race-type taxonomy, alongside circuit, sprint, drag, and elimination.
`41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` built three of those formats in
full. This is the one it didn't.

## 3.2 The two variants

**Pursuit** — the player chases a fleeing rival. Win condition: close
to within a defined proximity threshold and hold it for a sustained
duration (structurally similar to touge's proximity-scoring logic,
`41` §1.2, but the target is *closing* a gap rather than *holding*
one).

**Escape** — the reverse. The player is the one being chased, by a
rival driving aggressively (the aggression economy, Part 1, is fully
active *for the pursuing rival* in this variant specifically — they
will attempt contact). Win condition: survive a defined duration or
distance without being caught.

## 3.3 Why this is the aggression economy's natural home, narratively

Every other format either forbids contact-as-strategy (touge,
knockout) or treats it as one option among several (outrun). **Pursuit
and escape is the one format built entirely around it** — a chase
only works dramatically if the pursuer is genuinely willing to force
contact, which makes this the format where §1's numbers should feel
most alive, and the format most likely to produce the mechanical-
failure risk `20` §7 exists for.

## 3.4 Which rivals this suits, and which it doesn't

Not every archetype fits every format equally (`45` already
establishes per-rival differences in how each behaves under pressure):

- **Duquesne** (`45` §1.4) — the natural pursuer. His AI tuning already
  specifies near-zero `passAttemptSuppression` even late in a career;
  a chase format is where that trait reads as character rather than
  as an exploitable AI quirk.
- **The Constant** (`45` §1.6) — the natural evader in an escape
  scenario. His trail-braking advantage (`34` Part 1c) means outrunning
  him isn't about straight-line speed, which keeps an escape against
  him interesting even in a straight-format chase.
- **Reyes** (`45` §1.1) — a poor fit for either variant. His whole
  character is composed, grip-trusting precision; forcing him into an
  aggressive chase role would contradict everything already
  established about how he drives.

**Not every rival needs to appear in this format.** Matching the
format to the archetypes it actually suits is more consistent with
the character work already done than making all six universally
available everywhere.

## 3.5 Career placement

Fits naturally into the shop-driver bridge (`33` §2.3) as a sixth
job-type texture within the existing five, or as a distinct event
type unlocked alongside outruns at street tier — **not** available at
professional tier, for the same reason stunt scoring isn't (§2.4):
the format's whole identity depends on the aggression economy staying
active, which the Safety Rating gate (`48` §3.3) deliberately shuts
off at that level.

---

# Cross-references
- Original aggression economy concept → `20-CONCEPTS.md` §10
- Extracted stunt/drift code → `04-EXTRACTION-INVENTORY.md`
- Pursuit and escape's origin in the taxonomy → `17-GENRE-TAXONOMY.md` §2.3
- Race formats this extends → `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md`
- Safety Rating and license gating → `48-RPG-SYSTEMS-SPEC.md` Part 3, `49-PLAYER-CHARACTER-RPG.md` Part 1
- Mechanical failure risk → `20-CONCEPTS.md` §7
- The instability meter, reused for close calls → `20-CONCEPTS.md` §1
- Per-rival AI behaviour → `45-RIVAL-DEVELOPMENT.md`
