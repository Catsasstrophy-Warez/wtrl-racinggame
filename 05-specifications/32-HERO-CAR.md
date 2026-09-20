# Hero Car Specification

**The third specification document.** Research context sits across `13`, `19`,
`25`, `29` and `30`; this records the design.

## The concept

**One car, rebuilt across sixty years.** A 1965 chassis that needs restoring,
which the player then builds, modifies and races through successive eras until
it peaks in 2022 as a legendary vehicle with a documented history.

Visually it evolves through the pony-car lineage without reproducing any
specific production model — the *John Wick* method (`15` Pattern 1), applied
seven times.

## Status note

Everything in Parts 1–4 and 6–7 is specified. **Part 5 (the intimidation
factor) records both the stated design and a recommended alternative, and is
flagged as an open decision.**

---

# PART 1 — What this solves

## 1.1 The ascent-story problem

`29` §4.1 identified the risk: this is an **ascent** story, and the only
precedents are Al Unser Jr. and ProStreet — the latter commercially punished.

Reclamation stories dominate the genre because they **give one specific car
emotional weight before the player has earned any** (`29` §2.1).

> **A car you rebuild across sixty years does that without needing a theft.**
> You get the anchor without borrowing the plot.

## 1.2 The single-nameplate model, made literal

`13` §1 argued for one lineage across generations to solve the art budget.

**This is that, as one continuous object** — which is better, because the shared
topology stops being a production convenience and becomes the fiction.

## 1.3 And it is genuinely unclaimed

**No racing game has a car with a multi-generational history the player
enacts.** Mad Max's Magnum Opus is built once. Porsche Unleashed's Evolution
mode moves you *through* cars. **This one accumulates.**

---

# PART 2 — The generational spine

## 2.1 Visible history

The car should carry evidence of everything that happened to it:

- A repaired panel from a shunt three eras ago
- A period-correct part won in 1993 and never replaced
- Paint changed three times, and the door shuts show it
- Wear that predates the player

`08` §2.3 already establishes wear as narrative. **This makes it generational.**

## 2.2 The work escalates by era, not only by property

`25` Part 7 escalates the installation sequence by **property tier**. This adds a
second axis:

| Era | How the work looks |
|---|---|
| **1965–75** | Hand tools, timing light, carburettor tuned by ear |
| **1976–85** | Emissions-era compromises, vacuum lines everywhere, a multimeter |
| **1986–94** | Fuel injection. First electronics, first sensor faults |
| **1995–2004** | OBD-I/II, a code reader on the bench |
| **2005–14** | A laptop appears. Diagnostics before spanners |
| **2015–22** | Full software diagnostics, and **the mentor does not understand them** |

> **That last row is where the mentor's obsolescence stops being metaphor**
> (`30` §1.4). He knew this car when it was new. By 2022 you are plugging in
> something he cannot read.

## 2.3 The mentor knew this car

**Make them the same story.** He raced it, or against it, or he built it the
first time.

> **He cannot drive any more, and the car he cannot drive is the one you are
> rebuilding.**

This gives `30`'s mentor a reason to be in your garage that is not "tutorial
delivery," and it gives the car a provenance the player inherits rather than
invents.

---

# PART 3 — The parts economy

Three acquisition channels, each doing different work.

| Channel | Function |
|---|---|
| **Bought** | Expensive, reliable. The money sink (`20` §14) |
| **Found** | Barn finds, scrapyards, a part in a shed since 1974. **Exploration content, nearly free to author** (`05` §1.6) |
| **Won from rivals** | Pink slips (`19` §2.3) applied to *parts* rather than whole cars |

## 3.1 Why won-parts is the best of the three

Lower stakes than a whole car, so it can happen often. And **it means a rival's
build is something you can literally take.**

That closes with the rival-inspection verb in `30` §3.2: **you read their car at
a meet, then you race them for the specific piece you want.** Inspection becomes
target selection.

## 3.2 Rarer and more powerful — with a cost

Hero parts being stronger is correct. **Without a countervailing cost the hero
car dominates every class bracket and `06` §2.2 collapses.**

**Give them authentic drawbacks:**
- **Heavier** — period parts were
- **More fragile** — feeding the mechanical-failure system (`20` §7)
- **More expensive to maintain** — feeding the repair economy (`20` §14)
- **Temperamental** — a 1970s race cam is genuinely awful below 3,000rpm

> Authenticity and balance point the same direction here. **Period-correct parts
> should be difficult**, and that is both true and useful.

---

# PART 4 — Class brackets still apply

The hero car must remain **subject to the same class-bracket logic as everything
else** (`06` §2.2, `20` §16).

A fully built 2022-spec hero car should be **locked out of lower classes**, which
means:

- The player still needs other builds
- The hero car's era determines which events it can enter
- **Advancing the car forward in time is a choice with consequences**, not a
  pure upgrade

That last point is the interesting one. **Keeping the car in an earlier spec is a
legitimate strategy**, and it means the player's relationship with the car
includes deciding *when to stop.*

---

# PART 5 — The intimidation factor

**Decided: the AI-behaviour alternative (§5.2 below).** The flat-bonus version
originally specified (§5.1) is kept below as a considered-and-rejected record,
because the reasoning is worth having on file the next time a similar stat gets
proposed.

## 5.1 Considered and rejected: a flat stat bonus

The original specification: a half-second advantage from launch, plus a
one-time half-second catch-up boost per race if the player fell behind.

**Rejected as rubber-banding**, which this package's research identifies
repeatedly as the thing that kills upgrade economies — Top Gear 2's honest AI
was praised specifically because *if the field corrects for your improvements,
you did not improve* (`18` §2.3); Underground 2's stock differential tested
fastest *"even though it doesn't make sense,"* and the tuning system lost
meaning (`31` §2.3).

Three specific breakages: it is authored rather than simulated, with no
physical cause (`20` §2); it breaks class brackets, since a bonus costing no
weight and no budget makes the hero car strictly dominant everywhere it
competes (`06` §2.2); and it hollows out the Safety Rating arc, since a car
that simply wins has nothing to unlearn (`20` §11).

## 5.2 The decision: intimidation is an AI behaviour modifier

> **Intimidation does not make your car faster. It makes rivals worse.**
>
> **That is what intimidation actually is.**

| Effect | What the player sees |
|---|---|
| Rivals **brake earlier** when you are alongside | They give up the corner |
| Rivals **do not attempt** the pass they would otherwise make | They sit behind and wait |
| Rivals **defend badly** — early, clumsy blocks | You get through cleanly |
| At the line, rivals **hesitate** | You leave first because *they* left late |

**The half second at launch still happens.** The player gets it because someone
flinched — and can *see* them flinch.

**Why this version is correct, not just preferred:** it does not scale with
player position, so it is not rubber-banding; the car itself is unchanged, so
class brackets and the tuning model stay honest; it is readable — watching a
rival lift is a better feeling than a number; and it is the reputation currency
from `30` §2.5 made mechanical. No racing game researched in this package has
AI that is afraid of the player. This is the one that does.

## 5.3 Implementation: concrete, tunable AI parameters

**The per-rival ceilings specified here were independently checked
against Forza's own documented AI-safety failure case in
`60-FORZA-DEEP-ANALYSIS.md` §2.1** — Turn 10 learned through a real,
public incident that unbounded training on raw player behaviour
produces toxic AI; this system's ceilings (built for an unrelated
reason, personality-driven limits) already prevent the same failure.


**Per-rival baseline values and ceilings for all four parameters below
are now specified in `45-RIVAL-DEVELOPMENT.md` Part 1** — personality
drives which parameter rises fastest and how high, for each of the six
archetypes individually.


Four parameters per rival, each mapping directly to one row of the table above:

| Parameter | What it controls |
|---|---|
| `brakePointBias` | Metres earlier a rival begins braking when the player is alongside |
| `passAttemptSuppression` | Probability a rival abandons a pass attempt it would otherwise make |
| `defensivePositionError` | Lateral jitter added to a rival's blocking line — larger error, easier to pass |
| `launchReactionDelay` | Extra milliseconds before a rival's throttle input at the start |

**All four default to zero.** Intimidation is not ambient; it is earned per
rival, which is the point of the next section.

## 5.4 Intimidation is earned, not innate — tied to the persistent rivals

`30` Part 3 specifies six archetypes who persist across the hero car's sixty
years and remember specific things the player did. Intimidation should draw on
exactly that history rather than existing from the first race:

- **A rival who has never raced the player**: all four parameters at zero.
  Nobody is intimidated by a stranger.
- **A rival beaten repeatedly**: parameters scale up with the number of losses
  *that specific rival* has taken, not a global player rating. The Constant
  (`30` §3.2) should be the hardest to move — his parameters should rise
  slowest of all six archetypes, because part of his character is that nothing
  rattles him.
- **A rival who witnessed the player racing dirty** (`30` §2.5, Branch B):
  their `passAttemptSuppression` should be *lower* than the table would
  otherwise predict — they are wary of the player, but wary in a way that
  makes them defend harder, not fold. Fear and respect are not the same
  input.
- **A rival the player told the truth to** (`30` §2.5, Branch A): a small,
  separate respect bonus to `defensivePositionError` only — they race cleaner
  against a driver they trust, which is a gift, not a flinch.

> This turns intimidation from a stat into a **readable record of the
> career.** A returning player should be able to look at which rivals
> hesitate and reconstruct roughly what happened between them.

## 5.5 The catch-up mechanic: a gamble, not a gift

When behind, the player may choose to run the car past its limit: real pace,
paid for with **instability headroom** (`20` §1) and **a real chance of
mechanical failure** (`20` §7).

> **The player is not given a half second. They bet the car for one.**

Same dramatic beat as the original specification, real cost instead of none,
and the instability meter earns its keep at the exact moment the drama needs
it most.

---

# PART 5b — The rival timeline is this timeline

**`30` Part 3 specifies six persistent rival archetypes plus six
passers-through, mapped onto these same seven eras.**

Two consequences for this document:

**1. Rival car generations draw from the same period parts library.** A rival's
late-80s car and the hero car's late-80s generation share an era, a parts
vocabulary, and a workshop presentation. **One era research pass serves both.**

**2. Advancing the hero car changes the whole field.** When the player jumps
forward a decade, the people who were fast are older, some have stopped driving,
the machinery is different — **and the man in the hatchback is still there**
(`30` §3.3).

**Production note:** six rival lineages each need their own derivation
worksheets per generation, exactly as §6.1 requires of the hero car. **That is
seven parallel derivation tracks in total.** Budget for it in the schedule, not
at the end.

---

# PART 5c — The car sits waiting

**`33-ACT-STRUCTURE.md` §5.3 specifies the pressure valve for act three, and it
is a hero-car mechanic.**

The three-currency week only bites if **the hero car is visibly starving** — a
class bracket it is about to be locked out of, a rival whose build has moved past
it, a part won in 1993 that is now the weak link.

**The cheapest expression: the car under a dust sheet in the corner of the bay**,
visible from the Hero station every time the player opens the app.

Through act two the car is **waiting** — nine years of driving other people's
machinery while yours sits. That is what makes returning to it matter, and it is
one prop.

---

# PART 6 — Legal

## 6.1 The three-change rule applies per generation

`12` Part 2 — **seven eras means seven derivation worksheets.** The 1965 fastback
and a 2015 car share almost no surfaces, so the protected/transferable split must
be performed separately for each.

Use `templates/derivation-worksheet.md` once per generation. File them in
`docs/derivation/`.

## 6.2 The change is a legal asset

`13` §4 — the Ninth Circuit held Eleanor **unprotectable as a character
precisely because its appearance changed significantly across appearances**
(*Carroll Shelby Licensing v. Halicki*, No. 23-4008, 27 May 2025).

> **Your car changing by design cuts the same way.** It makes a
> character-copyright claim against you very hard to sustain — and one *by* you
> equally hard.
>
> That is a fair trade, and worth knowing before anyone proposes making the hero
> car a protectable brand asset.

Manufacturer trademarks on badges, names and specific body designs still apply
throughout (`12` §1.1).

---

# PART 7 — Production

## 7.0 A second physical axis for era differentiation: polar moment of inertia

Added after reading Beckman Part 13 in full (`34` Part 1e). **PMI (`J = Σmr²`)
is the rotational equivalent of mass** — it governs how quickly a car changes
direction, independent of how it handles in a straight line, and it is set by
*where* mass sits, not how much there is.

> Beckman's own examples split cleanly: light, mid-engined, low-PMI cars (Elan,
> MR2, X1/9) yaw quickly and favour transient response; heavy, engine-forward,
> high-PMI cars (Corvette, Camaro) resist yawing but tolerate a bigger engine.

**This gives the seven hero-car generations a second, independent axis beyond
horsepower and chassis stiffness:**

- **Early, big-block generations** — heavy iron engine well forward of the CM,
  **high PMI**: strong on the straight, reluctant to change direction
- **Later, lighter-engine generations** — more centralised mass, **low PMI**:
  quicker through transients, less dominant in a straight line

Same logic as `18` §2.2's physically-justified dependencies, one layer up: **the
car's history of engine placement produces a real, felt difference in how it
turns**, derivable from mass distribution rather than authored per generation.

## 7.1 Seven base models, not four

| Base | Covers |
|---|---|
| **1965** | The starting chassis. Restoration is the tutorial |
| **Mid-70s** | Emissions era, heavier, softer |
| **Late 80s** | Fuel injection arrives, aero begins |
| **Mid-90s** | Modern platform, first real chassis stiffness |
| **Early 2000s** | Power creep, bigger brakes and wheels |
| **Mid-2010s** | Independent rear, contemporary aero |
| **2022** | The legend. Fully realised |

**Full engine-audio grounding for every row above — idle, street, race,
redline, and shifting per era — is in `37-FORD-V8-AUDIO.md`.** The
headline finding there: only one real acoustic family transition exists
across all seven generations, landing on the last two — meaning most of
this table shares one acoustic lineage, with era-specific texture layered
on top rather than seven builds from scratch.

**Forced induction, crank type, and real 3-to-10-speed transmissions per generation** — turbos, superchargers, intercoolers, blow-off valves, cross-plane vs flat-plane cranks, manual and automatic gearboxes matched to real counterparts — are in `40-FORCED-INDUCTION-DRIVETRAIN.md`, implemented in `code/prototype/EngineFamily.cs` (extended) and the new `code/prototype/TransmissionSpec.cs`.

**Era-appropriate variants between them**, shared wheel and tyre library
throughout (`09` §1).

**Seven hero-car art tasks at 4–8 weeks each** (`09` §1) — and this is
substantially the whole roster, which is what makes the small-roster strategy
(`13` §1) work.

> **Budget honestly: seven models is 28–56 weeks of hero-car art.** That is the
> single largest line item in the project and it is worth staging — ship the
> first three or four generations and add the rest, since the fiction supports
> a car that has not reached the present day yet.

## 7.2 The escalation content is cheap

**Six era presentations × four installation vignettes** (`25` Part 6) is
**lighting setups and tool sets, not new animation.** The hands and the part swap
are already built.

## 7.3 And it is the best marketing asset in the design

**The same car, 1965 and 2022, side by side.**

That is the store screenshot, and it is the fifteen-second clip (`28` Part 6).

---

# Cross-references
- Single-nameplate content model → `13` §1
- The ascent-story risk → `29` §4.1, `19` §2.8
- The mentor → `30` Part 1
- Rival inspection → `30` §3.2
- Installation sequence and escalation → `25` Parts 6–7
- Class brackets → `06` §2.2, `20` §16
- Instability meter → `06` §1.2, `20` §1
- Mechanical failure → `16` §4.3, `20` §7
- Honest AI, not rubber-banding → `18` §2.3, `16` §4.2
- Derivation method and worksheet → `12`, `templates/`
- The Towle test and the Eleanor ruling → `13` §4, `12` §1.3
