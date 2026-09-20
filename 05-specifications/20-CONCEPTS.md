# 21 Systems: The Synthesis

**What this is.** Every prior document analyses something. This one decides.
Twenty-one systems for a single game with simulation, action, and RPG pillars,
each traced to the research that produced it.

**Read Part 4 first if you read nothing else.** These are not twenty-one
independent features — four chains do most of the work, and a system pulled out
of its chain does not function.

---

# PART 1 — SIMULATION

The depth layer. This is your differentiator: nothing on mobile handles aero,
differential, and suspension properly (`07` §3.1–3.3).

## 1. The ragged-edge instability meter

Driving at the limit accumulates instability. Backing off sheds it. Crossing the
threshold loses the car.

**The critical detail:** handling rating determines **how fast you shed it**, not
just how well the car corners. A twitchy car doesn't merely corner worse — it
gives you fewer tools to recover from the trouble it creates.

> On a phone there is no force feedback and no seat-of-the-pants feel. This is
> the only mechanism found in the entire corpus that makes limit-driving
> **visible**. Nothing anywhere implements it.

*Source: Gaslands hazard tokens, `06` §1.2*

> ## It is not an authored abstraction — it is a real quantity
>
> **Beckman's circle of traction (`34` Part 1b) gives this mechanic a physical
> basis.** The meter is **how close you are to the boundary of the traction
> circle.** Spending your budget near the edge fills it; spending it well inside
> empties it; a wipeout is asking for more than μg.
>
> **Implementation:** per-wheel `sqrt(a_x² + a_y²) / (μg)` normalised 0–1,
> integrated with a decay term. The decay rate is the "handling determines how
> fast you shed it" parameter.
>
> This matters because the design rests on consequences being *simulated, not
> authored* (§2). The instability meter was the one signature mechanic that
> looked authored. **It isn't.**
>
> ## A third, independent, and precisely computable threshold
>
> `35-EXTENDED-SOURCES.md` Part 3.1 adds a formal detection criterion from a
> 2025 academic paper on the Milliken Moment Method, converging on the same
> physical moment from a different direction:
>
> **`|a_y − v·ψ̇| > ε_threshold`** — compare actual lateral acceleration
> against what steady-state cornering at the current yaw rate would predict.
> Once the gap exceeds a small threshold, **the car has begun rotating faster
> than its lateral acceleration would suggest**, which is precisely the
> moment oversteer becomes unrecoverable.
>
> **This is cheap** — a multiply, a subtract, an absolute value — and every
> quantity it needs (lateral acceleration, velocity, yaw rate) is already
> produced by the physics engine every tick. Use the traction-circle fill
> level (above) for *how hard the player is pushing*; use this criterion for
> *whether the car has actually let go*.
>
> **This same fill level should also drive a Core Haptics pattern**
> (`36` Part 1) — continuous, intensity and sharpness tied to the
> normalised value, on the same debounce discipline already used for the
> trigger above. On a phone with no force feedback, a rising buzz under
> the thumb may register the approaching limit before the visual meter
> does.
>
> ## And the threshold is precise, not chosen
>
> Beckman Part 25 (`34` Part 1d) gives the exact boundary. Plotting combined
> slip against grip produces a central **"cup" region**:
>
> | Region | Behaviour | Player experience |
> |---|---|---|
> | **Inside the cup** | More slip → **more** grip | At the limit. Recoverable. |
> | **Outside** | More slip → **less** grip | Over it. Correcting makes it worse. |
>
> **That is why losing a car feels like falling rather than sliding.** The
> threshold is the edge of the cup, and it moves with load, surface and compound
> on its own.
>
> ## The meter must also read input jerk, not just magnitude
>
> Beckman Part 14: suspension and tyres behave as **damped harmonic oscillators**,
> and *"sinusoidal inputs are better because they match the natural response of
> the car."*
>
> **Frequency, per Beckman's own erratum in Part 26: ~0.64 Hz, not the 4 Hz
> originally published** — he had radians per second confused with cycles per
> second. About one oscillation every 1.6 seconds, which is a much slower
> response and sets the time constant on the jerk term.
>
> **A step input excites the oscillator; a smooth one does not** — so a jerky
> driver loses grip at the *same cornering load* as a smooth one who doesn't.
> Add a term proportional to the derivative of the input vector.
>
> **This is the physical basis for "smooth is fast,"** and it makes the meter
> teach something real rather than merely measuring speed.

## 2. Upgrade dependencies your physics generates for free

Top Gear 2 (1993) made gearbox upgrades useless without a matching engine — a
genuine prerequisite tree, but **an arbitrary rule they had to invent.**

Yours are real:

| Upgrade | Requires | Because |
|---|---|---|
| Larger turbo | Stronger clutch | Torque exceeds holding capacity |
| Aggressive aero | Stiffer suspension | Downforce load compresses the travel |
| Shorter final drive | Engine rev range | Nothing to use the ratio with |
| Stickier tyres | Bigger brakes | Grip the brakes cannot exploit is wasted |

> **This is your single clearest advantage over every mobile competitor.**
> They have to author the rule. Your physics engine produces it.

*Source: `18` §2.2*

> **Toolchain note.** VPP Community Edition cannot ship on iOS (desktop builds
> only, 1 vehicle per scene) and `com.unity.vehicles` is ECS-only and targets
> medium realism by design. **RVP + TORSION is the default; VPP Professional is
> the paid alternative.** See `02`. What *is* free from VPP: the public docs at
> `vehiclephysics.com` — the best education available on modelling drivetrains
> and tyres properly.

## 3. Surface-dependent grip

Tarmac, concrete, gravel, painted kerbs, wet patches — each with real friction
differences, and transitions that matter mid-corner.

**RVP's `GroundSurfaceMaster` ships this** (`04`). Sega Rally proved in 1995
that it is the cheapest available way to make tracks feel genuinely different
from one another.

**Now implemented** — `code/prototype/SurfaceGripTable.cs`, matching RVP's real interface shape without depending on RVP's own source (never cleared as ship-safe, `01`).

*Source: `17` §3.3*

## 4. The dyno as your tuning interface

Underground 2 put fine-tuning behind a **Dyno Run** rather than a wall of
sliders.

Seven subsystems is intimidating as a menu and natural as a diagnostic tool.
Tune on the dyno → validate on track → read the result → adjust.

> **Prototype this first.** See Part 5.

*Source: `19` §2.5*

## 5. Post-race telemetry that names the fault

Not a lap chart. **A sentence**: *"Understeer on exit, sectors 2 and 4"* — linked
directly to the parameter that causes it.

This is what closes the loop between your physics and your progression, and it is
the entire reason to have deep tuning. A lost race should produce a specific
data point that leads to a specific fix.

*Source: Ford v Ferrari, `07` §1.1*

## 6. A practice session before each event

You currently have more tuning depth than anything on mobile and **no structured
moment where it pays off.**

Practice reveals what the track demands and converts tuning from a menu into a
decision with stakes. It also gives the telemetry system (§5) something to
compare against.

*Source: `16` §3.1*

## 7. Mechanical failure from sustained abuse

Push lap after lap and something breaks.

> This is the **missing connective tissue** between your damage model (`11` §2.4)
> and the instability meter (§1). It also creates comeback opportunities without
> rubber-banding — the honest way to keep races close.

**BeamNG's structural damage model is the aspirational target for what
"functional consequence" should feel like** — a bent suspension arm
genuinely changes steering, a crumpled engine bay can cause overheating
(`39-MECHANIC-GAMES-SPECTRUM.md` Part 5) — worth keeping as the design
goal even though this project's rigid-body approach reaches it by
authored rules rather than emergent simulation.

**Now implemented** — `code/prototype/MechanicalFailure.cs`, reading `RaggedEdgeMeter.fillLevel01` directly, deliberately not rubber-banded (failure risk tracks sustained abuse time, not race position). **Simulated and corrected** — `06-production-path/62-SIMULATION-AND-TESTING-PASS.md` found the first version never actually fired under realistic driving patterns (it required 5 consecutive unbroken seconds above threshold; no real corner does that). Fixed to track cumulative time across the race instead, matching this section's own "push lap after lap" framing.

*Source: F1 Manager 2024, `16` §4.3*

---

# PART 2 — ACTION

The street layer. Where the career begins, and where contact is tolerated.

## 8. Outruns

**Fully specified in `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 1.1.**


Challenge a rival in free roam; win by putting **300 metres** between you.
Opponents identified by a visual signature (bright tail lights in the original).

**No track, no laps, no checkpoints** — pure escape geometry. Extremely cheap to
build and it works on a phone.

*Source: Underground, `19` §2.4*

## 9. Touge duels

**Fully specified in `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 1.2** —
including why this is the Constant's format specifically.


1v1 on a mountain road. **The closer you are to the leader, the more points you
accrue. Overtake and hold it for ten seconds and you win outright.**

Proximity scoring produces continuous tension rather than a binary result, and
one opponent is nothing to render.

*Source: Carbon's Canyon Duel, `19` §2.7*

## 10. An aggression economy at street level

**Fully specified with real numbers in `50-ACTION-PILLAR-EXPANDED.md`
Part 1** — specific triggers, why the reward is deliberately small,
and the exact mechanism that makes the same system stop being
rational once the player's license grade rises.

Reward contact with something concrete — boost, cash, reputation — so risk-taking
is **economically rational** rather than merely permitted.

Burnout's Takedown logic without weapons, which keeps your physics honest.

*Source: `06` §3, `17` §1*

## 11. Dual rating: pace and safety, scored separately

**The Safety Rating half is fully specified in
`48-RPG-SYSTEMS-SPEC.md` Part 3** — what moves it, the bounded scale,
and why it locks professional-tier event entry rather than just
docking a score.


Contact costs Safety Rating regardless of result. Introduce it at the club tier
and gate the professional tier on it.

> **The player has to unlearn what won them street races.** That is a
> progression arc, not just faster cars.

### The Shift warning — do not skip this

Shift's Precision/Aggression system **failed in practice.** A reviewer who
constantly bumped, cut off and spun opponents still trended toward Precision,
because racing-line points outweighed every dirty move.

**Weight the axes against each other and test with a deliberately filthy
driver.** If clean-driving points accrue faster than aggression penalties
deduct, your Safety Rating is noise.

*Source: iRacing, `07` §2.3; failure mode from `19` §2.9*

## 12. Named rivals with readable technical profiles

Not difficulty sliders. Each rival gets a car with **genuine weaknesses** — poor
brakes, a peaky engine, bad wet pace — so the player learns which circuits they
are vulnerable on.

Climbed in order, Blacklist style. Costs a data table.

*Source: `19` §2.6, `16` §4.2*

## 13. Knockout events

**Fully specified in `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 1.3.**


Last finisher eliminated each round. Cheap, escalating, and it fits a mobile
session length precisely.

*Source: High Stakes, `19` §2.3*

---

# PART 3 — RPG

Progression, economy, property. The layer with the least prior art anywhere.

## 14. Repair costs as the economic engine

Four damage systems tracked separately — engine, steering, body, suspension —
with **no repair mid-race** and a bill waiting in the garage.

**Damage → cost → pressure → drive more carefully.**

> You already own every component: RVP's `VehicleDamage` tracks per-area damage
> and exposes `Repair()`. Attaching a bill is the most natural currency sink in
> the genre, and it solves a problem that killed both Mad Max's and Porsche
> Unleashed's economies from opposite directions.

*Source: High Stakes, `19` §2.3*

## 15. Two-axis gating

**Fully specified in `48-RPG-SYSTEMS-SPEC.md` Part 2** — including why
this is genuinely distinct from property tiers and class brackets,
not a third redundant gate.


**Reputation or licence class unlocks the catalogue. Money buys the part.**

Two independent curves you can tune separately, and it stops a player buying the
endgame build in hour two while still letting money accumulate meaningfully.

*Source: Mad Max, `05` §1.2*

## 16. Class brackets

Build to qualify, not just to maximise.

> **A fully maxed car locks itself out of lower classes**, so you need multiple
> builds. Money stays meaningful indefinitely, for authentic motorsport reasons
> rather than artificial gating.

**Now given actual defined tiers**, closing a real gap found on audit:
the class-points mechanic already existed (`47` Part 1.1 — every part
costs money and class points), but the brackets themselves were never
named or thresholded.

| Bracket | Class points ceiling | Maps to |
|---|---|---|
| **Street** | Low — Stock-replacement and most Performance-tier parts only | Outruns, pursuit/escape (`41` §1.1, `50` Part 3) |
| **Club** | Mid — Performance tier in full, Race tier begins appearing | Touge duels (`41` §1.2) |
| **Semi-Pro** | High — most Race-tier parts | Bridges into the shop-driver era (`33` §2) |
| **Pro** | No ceiling | Knockout events (`41` §1.3), gated further by Driver License Grade and Safety Rating (`49` Part 1, `48` Part 3) |

**The lockout is real, not just a warning**: a build whose total class
points exceed a bracket's ceiling cannot enter that bracket's events at
all, regardless of the player's own Driver License Grade — the car,
not the player, is what's being qualified here, and the two gates stay
genuinely independent (`48` Part 2.2's same discipline: don't let two
systems collapse into one meter wearing different names).

*Source: Car Wars, `06` §2.2*

## 17. Named build recipes

**Fully specified in `48-RPG-SYSTEMS-SPEC.md` Part 1** — free-form vs.
target recipes, and where target briefs actually come from.


Assemble a full spec — a canyon-carver, a drag setup, a wet-weather build — and
earn a title or livery.

Gives your tuning system **targets** instead of shapeless optimisation, and
teaches the system by example. Real trim ladders (base → performance → factory
hot → homologation → tuner halo) already validate the structure.

*Source: Mad Max Archangels `05` §1.3; trim ladders `13` §2*

## 18. Property tiers that each name what they improve

F1 Manager's facility discipline: **every building buffs one named system. No
vague "+10% everything."**

| Tier | Candidate effects |
|---|---|
| House | Session recovery, small passive income — **mechanism fully specified in `59-TRENDS-GTA-PASSIVE-INCOME.md`**, closing a gap that sat unbuilt since this line was first written |
| Garage | Storage capacity, repair cost reduction |
| Pro shop | Fabrication tier unlock, staff quality ceiling, part development speed |
| Warehouse | Storage at scale, sponsor attractiveness, parts inventory |

*Source: `16` §4.1; TDU's storage-as-constraint `07` §2.1*

## 19. Stars from objectives, not just finishing position

**Fully specified in `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 3.**


Award progress for holding the racing line, clean overtakes, sector times,
consistency — so **a player can advance without winning.**

> On mobile, where sessions get interrupted and bad sessions happen, this is the
> difference between progress and quitting. Shift required 280 stars for its
> finale and let a weak drift result be offset by a strong time trial elsewhere.

*Source: Shift, `19` §2.9*

## 20. A shop-driver employment tier

Paid technical driving between races: **shakedown runs, delivery jobs,
evaluation laps** for a workshop or manufacturer.

> Native to a mechanic protagonist. Teaches car control without a tutorial. Pays
> money. And it is **how a mechanic realistically earns seat time before anyone
> hires him to race.**
>
> It also solves a structural problem: it gives you events that are not races,
> which your street tier needs.

*Source: Porsche Unleashed's Factory Driver, `19` §1.3; solves the skill-gate
gap identified in `17` §5.3 and `18` §5.2*

## 21. Time-shifted ghosts with an Autolog layer

**Fully specified in `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` Part 2** —
including the finding that ghosts are the mechanical delivery system for
rival persistence: a retired rival's best run stays raceable forever,
even after they've left the narrative.


Race recorded traces of real players. A recommendation engine surfaces *"your
rival beat your time here"* at the moment the player would care.

> **The ghosts are the content; the recommendations make them rivals.**
>
> No netcode, no servers, no matchmaking. Months of work replaced with days.
> Store using the `time_trial_record` pattern in `code/CrazyCar-MIT/`.

*Source: Real Racing 3 `07` §3.5 + Autolog `19` §2.10*

---

# PART 4 — The four chains

**These are not twenty-one independent features.** A system pulled out of its
chain does not function.

## Chain A — Tuning

```
Practice session (6)    →  reveals what the track demands
        ↓
Dyno (4)                →  where the player responds
        ↓
Telemetry (5)           →  tells them whether they were right
        ↓
Dependencies (2)        →  makes the choice non-obvious
```

**Without all four, deep tuning is a slider wall.** This chain is the entire
argument for your game existing.

## Chain B — Career arc

```
Aggression rewarded at street (10)
        ↓
Safety Rating introduced at club (11)
        ↓
Professional tier gated on it
```

**The player unlearns something to progress.** That is your arc, mechanically
expressed rather than narrated.

## Chain C — Economy

```
Repair costs (14)     drain money continuously
Class brackets (16)   force multiple builds
Property tiers (18)   provide sinks and income
```

Three independent answers to the problem that killed **both** Mad Max's economy
(15–20k surplus scrap) and Porsche Unleashed's ("money too easy to come by").
Two games, two directions, same failure.

## Chain D — The bridge

**System 20 (shop-driver work) is what carries the player from street racing to
professional.**

ProStreet proved the street-racing audience does **not** automatically follow you
to a racetrack — its reception was poor enough that EA moved the franchise to
another studio. Paid technical work is how a mechanic plausibly gets there, and
it means neither mode has to replace the other (Heat's lesson, `19` §2.12).

---

# PART 5 — What to prototype first

**System 4 — the dyno.**

`11` §4 decides this: **simulation is the reason someone plays, not a
hypothesis to test against action or RPG.** Every conclusion in this research
package rests on that decision being correct — **your tuning depth is the
differentiator** — and this prototype is where that decision either earns its
place or doesn't.

Porsche Unleashed shipped a deep, authentic, era-correct parts catalogue and
reviewers said the parts **did not change the car enough to matter** (`19` §1.4).
That is the same failure, in the same design space, in the game that is otherwise
closest to yours.

A dyno-plus-track prototype — one car, one circuit, the full seven-subsystem
tuning model, and a telemetry readout — tests that assumption in a fortnight
instead of eighteen months.

**Three others are also cheap validations of core systems:**

| Prototype | Validates | Source |
|---|---|---|
| Instability meter alone, no opponents | Whether §1 reads on a touchscreen | §1 |
| Touge duel, one rival | Physics + racing feel on a phone | §9 |
| One car, damage persists, scarce money | Whether the economy loop bites | §14 |

Each is weeks of work. Each answers a question that otherwise costs eighteen
months to discover the hard way.
