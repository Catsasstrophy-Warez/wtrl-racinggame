# Garage Design Specification

**This is the first specification document in the package.** Everything numbered
01–24 is research: what other games did and what it implies. **This document
records decisions.** The analysis behind them is in `24-GARAGE-SYSTEMS.md`.

## The four decisions taken

1. **The garage is a place, and the travel is eliminated.** It is the home
   screen.
2. **Six functions:** Store · Modify · Repair · Display · Trade · Generate
3. **Shrine, not spreadsheet.** Mad Max's reverence, Porsche Unleashed's
   openable panels, CSR2's presentation quality.
4. **Three tuning contexts** — garage for parts, dyno for calibration, practice
   for circuit setup. Three levels of commitment.

Plus one novel addition: **show the work.**

---

# PART 1 — What "garage as home screen" commits you to

**There is no menu layer above it.** No main menu, no garage *screen* entered
from somewhere else. The app opens into the space, the car is already there, and
everything else is reached from inside.

Three consequences to accept deliberately:

- **One load, at launch.** The garage scene stays resident. Every other context
  loads *into* it or briefly replaces it.
- **Navigation is diegetic.** The player looks at things rather than traversing
  a menu tree.
- **The car is always present.** Which means it is always doing emotional work,
  and always showing what state it is in.

---

# PART 2 — The space

**Seven camera positions, not a walkable environment.** This is the single
largest technical saving and it costs almost nothing in feel.

| Station | Contents |
|---|---|
| **Hero** | Default. Three-quarter view, car on the floor, lit. |
| **Lift raised** | Underside. Suspension, differential, exhaust. |
| **Engine bay** | Bonnet open. Engine, intake, turbo, cooling. |
| **Interior** | Driver's seat. Cage, seat, wheel, gauges. |
| **Parts wall** | The catalogue. What is affordable and what is not. |
| **Desk** | Trade, contracts, career, event entry. |
| **Bay overview** | The whole space. Other cars, locked bays. |

**Now implemented** — `code/prototype/GarageStationManager.cs`, the seven-way switch itself (camera Transforms are per-generation scene data, not something this class owns).

## The lift is the anchor object

It is where a real workshop puts a car when work happens. It gives underside
access for the half of the tuning system that lives there. And **raising it is a
satisfying physical beat that costs one animation.**

---

# PART 3 — Navigation

**Tap to focus.** The camera racks between stations with a short move. No
walking, no loading, no fade to black.

Two rules that matter on a phone:

- **Every station is one tap from Hero, and Hero is one tap from everywhere.**
  Never more than two taps between any two stations.
- **Nothing interactive in the bottom corners.** Thumbs cover them (`22`).

---

# PART 4 — The six functions, placed

## 4.1 Display — Hero station
The car with a proper lighting rig and reflection probe (`08` §3). **Openable
bonnet, doors and boot.** This is the Porsche Unleashed detail and it is the one
that is purely premise.

## 4.2 Modify — parts wall to browse, station to install
**Buy at the wall; watch it go on at the relevant station.** A coilover is
purchased at the wall and fitted under the lift.

## 4.3 Repair — the lift
RVP's per-area damage (`04`) shown **on the car itself**.

> **A dented panel stays dented until you pay for it.** Damage is not a number
> in a menu; it is visible on the object the player is proud of.

## 4.4 Store — the bays
**Locked bays are visible from day one**, empty and dark. The player can see the
space they cannot yet use — Test Drive Unlimited's constraint made spatial
rather than numerical (`24` Part 4).

## 4.5 Trade — the desk
Classifieds to buy, a phone to sell. And Porsche Unleashed's rule:
**selling a car re-locks it** (`19` §1.2).

## 4.5b The Engine Bay station has a second use

`30` §3.2 specifies **rival inspection**: at a meet, the player walks around
another car, opens the bonnet, and reads the spec — which is how they learn a
rival's strengths and weaknesses.

**That is this station pointed at someone else's car.** Same camera position,
same interaction, no new context. Budget for the Engine Bay station to accept a
non-player vehicle.

## 4.6 Generate — the building itself
Property tiers change the room, and **each names one effect** (`16` §4.1).

---

# PART 5 — The three tuning contexts

**Dyno specification in full: `31-DYNO-ANALYSIS.md`.**

**These are not three menus with the same sliders.** They differ in what they
change, what they cost, and what they return.

| | Garage | Dyno | Practice |
|---|---|---|---|
| **Changes** | What you own | How it is calibrated | How it is set up today |
| **Nature** | Discrete parts | Continuous values | Continuous values |
| **Costs** | Money, permanent | Nothing — iterate freely | A session |
| **Returns** | A different car | **A power curve** | **Lap times + telemetry** |

**Forced induction, crank type, and transmission gearing are now fully
specified real-history parts, not placeholders** — see
`40-FORCED-INDUCTION-DRIVETRAIN.md`. Superchargers are period-correct from
generation one (a real 1965-72 dealer-adjacent option); turbocharging
reads as an aftermarket/tuner path throughout, matching the real
lineage's honest gap; flat-plane crank is a rare top-tier variant option
within the final engine family only, not a separate family.

**Full pricing, tied to class brackets and property tiers, is in
`47-PARTS-PRICING.md`** — every part costs both money and class points,
so a fully-stocked driveway car still can't buy its way past a bracket
limit. Repairable parts cost ~30% of a fresh Stock-replacement to fix;
replace-only parts have no repair price at all, which is the pricing
table enforcing `38`'s finding directly rather than leaving it as a
label.

**Every part also carries a repairable-or-replace-only flag**
(`38-CMS-PARTS-TAXONOMY.md` §1.3). Most parts can be repaired — condition
restored, cheaper than replacement, rewards maintenance. A small, deliberate
set cannot: a gearbox, a clutch plate, worn out means swapped, no repair
path exists at any price. Real mechanical truth, not an arbitrary
restriction, and it gives the mentor's diagnostic voice (`30` §1.3)
something concrete and correct to say — *"that gearbox is on its way out,
and there's no fixing it, only delaying it."*

## The seven subsystems, split

| Subsystem | Garage (buy) | Dyno (calibrate) | Practice (set up) |
|---|---|---|---|
| **Engine** | Turbo, cams, intake, exhaust | Boost, fuel map, rev limit | — |
| **Transmission** | Gearset, clutch | Final drive, ratios | — |
| **Differential** | LSD unit type | — | Preload, ramp angles |
| **Suspension** | Coilovers, arms, bars | — | Ride height, damping, camber, toe, **cross-weight** |
| **Tyres** | Compound | — | Pressures |
| **Aero** | Splitter, wing, diffuser | — | Wing angle, rake |
| **Driver aids** | ECU | Map selection | ABS / TC levels |

> **Parts cost money. Geometry and calibration are free to fiddle with.**
>
> That distinction is what makes tuning feel like engineering rather than
> shopping — and it means **a broke player still has something meaningful to
> do.**

Dependencies apply throughout, physically justified (`18` §2.2): a larger turbo
needs a clutch that can hold the torque; aggressive aero needs suspension that
can carry the load.

> ## Cross-weight is a real axis, and it is free
>
> Added after reading Beckman Part 20 (`34` Part 1d). **A four-wheeled vehicle is
> statically indeterminate** — three equations, four unknowns, so wheel loads
> cannot be solved from statics alone. **That indeterminacy is precisely why
> weight jacking works**, and why NASCAR crews adjust spring perches in the pits.
>
> A tricycle cannot be jacked; a car can. Beckman's neutral condition is
> **`ad = bc`** — rear force ratio equals front force ratio. **Deviating from it
> *is* the wedge.**
>
> **You get this for nothing** if per-corner load comes from spring compression
> rather than a statics solve, which is what RVP already does. Expose per-corner
> perch height and the axis appears.
>
> **Ride height is not static under load.** OptimumG's "Rolling About"
> (`35` §1.1) explains why the closed-form static solution below is still an
> approximation: unequal inside/outside tyre force means the geometric and
> elastic portions of load transfer don't cancel symmetrically, producing a
> real "jacking" force that moves ride height mid-corner — documented at
> 1–10mm depending on suspension stiffness. Since downforce is ride-height
> sensitive (`08`), this is a second-order aero effect that should emerge from
> combining the tyre and suspension models, not be authored separately.
>
> **Front and rear suspension setup are coupled, not independent axes.**
> OptimumG's "The anti-antis" (`35` §1.2) makes the case directly: the whole
> car pitches about one axis under braking/acceleration, determined jointly by
> front and rear geometry — treating anti-dive and anti-squat as separate
> per-end sliders can produce genuinely counterintuitive results (their
> worked example: raising front anti-dive made the *whole car* sit lower
> under braking, not higher). If ride-height and damping parameters are
> exposed per-end, the underlying pitch-axis calculation should use both ends
> together.
>
> **And the exact static formula now exists** (`34` Part 1e, Beckman Part 27). Solving
> the four-corner statics problem with the symmetry condition above yields a
> closed form for all four corner loads, built from CG height, wheelbase split,
> track widths, and current longitudinal/lateral force. **One term in that
> solution — `R̄_A`, driven by track-width asymmetry and lateral CG position — is
> the cross-weight knob itself**, made explicit rather than implicit in a spring
> simulation. Cheap enough to evaluate as a from-first-principles cross-check on
> whatever the suspension model produces, even every physics tick.

---

# PART 6 — The installation sequence

**The novel element.** It must be built carefully or it becomes the failure that
hit Outlander, DRIV3R and Underground 2 — a non-driving segment that is worse
than the driving (`21` Part 5).

## 6.1 Four sequences, not forty

**Do not animate the part. Animate the moment.** Four generic vignettes, with
the specific part swapping in as a mesh.

| Sequence | Beats | Length |
|---|---|---|
| **Engine bay** | Bonnet up · socket wrench · old part lifts out · new part seats · torque wrench click | ~8s |
| **Underside** | Lift rises · spring compressor · coilover swap · lift lowers | ~10s |
| **Wheels** | Impact gun · wheel off · new wheel on · five nuts in sequence | ~7s |
| **Body / aero** | Drill · panel offered up · fixings · a hand smoothing the edge | ~6s |

**Hands and tools are the only new animation work. The part is a mesh swap.**

## 6.2 Rules

- **Skippable, and the skip is remembered.** First time is the show; the
  fiftieth is a tap.
- **Audio carries it.** Impact gun, ratchet, torque wrench click. These are
  already on the SFX list (`10` §4), and **on a phone speaker the click is the
  payoff**, not the visuals.
- **Never block.** If a sequence would delay a race, it does not play.
- **Tight framing.** Close on hands and the part. Almost nothing is rendered,
  and it reads as detail rather than as budget.

## 6.2b Who does the work — decided

**The player does the work, or pays to have it done.** Both exist, and the
choice is the mechanism that makes staff (`33` §5.5) worth having, rather than
staff being a passive stat.

**The resource being traded is time, not money — and it's a resource `33`
already tracks.** `33` §5.1 specifies a weekly choice between a job, a
commission, and working on the player's own car. That third option *is* the
installation sequence. So:

| Who does it | Costs | Frees |
|---|---|---|
| **The player** | A week's activity slot (`33` §5.1) — this *is* "work on own car" | Nothing extra |
| **Paid staff** | Money | The week's activity slot — the player can still take a job or commission that same week |

**No new currency, no new system.** This is `33`'s existing three-way squeeze,
with the installation sequence as the concrete thing that happens when the
player spends their slot on their own car, and staff as the thing that lets
money substitute for that slot once it exists.

**Availability follows the property ladder exactly as `33` §5.5 already
specifies:** no staff at the driveway or garage tiers — the player has no one
to delegate to, and every installation is personal. Staff arrive at the pro
shop, and multiply at the warehouse.

### The mentor is in the room only when the player is

`30` §1.3's diagnostic voice — the mentor commenting during installation — only
fires when the **player** does the work. Paying staff skips it, which is not a
missed feature; it's the point. Early in the career, with no staff and no
choice, every installation is a lesson. Once staff exist, **whether the mentor
is present becomes something the player is choosing to opt out of** by paying
— a second, quieter expression of `30` §1.4's arc. His obsolescence isn't only
the moment the player starts overruling his advice; it's also every week the
player is busy enough, or rich enough, not to need him in the room.

### A small reason to still do it yourself once staff exist

Staff-installed work should carry a minor, honest variance — not a failure
state, just slightly less precise than the player's own hands. Nothing that
should push a player toward micromanaging every wheel nut, but enough that a
build the player genuinely cares about — a named recipe (`05` §1.3), the hero
car ahead of a class-defining event — is worth personally supervising at least
once. **Convenience should be real, not strictly dominant.**

## 6.3 Why it is worth building

Gran Turismo shows a spinner. Forza shows a spinner. Every racing game in the
corpus shows a spinner (`24` Part 10).

> **The installation sequence is the moment money becomes real** — and for a
> game whose protagonist is a mechanic, hiding the work behind a progress bar is
> the one thing that cannot be justified.

---

# PART 7 — The escalation

**The work sequence improves as the property does.** Same four vignettes, four
presentations.

| Tier | How the work looks |
|---|---|
| **House / driveway** | Jack stands, hand tools, poor light, working alone |
| **Garage** | Two-post lift, proper sockets, a work lamp |
| **Pro shop** | Four-post lift, air tools, a second pair of hands in frame |
| **Warehouse** | Multiple bays, a team, someone else doing the wheels |

> **Progression becomes visible in how the work is done**, not in a stat
> readout. The player sees they have moved up **every single time they fit a
> part** — which is the most frequent action in the game.

Four lighting setups and a few extra hands. **Enormous emotional return for very
little content.**

**One thing this section never covered, closed in `59-TRENDS-GTA-PASSIVE-INCOME.md`**: actual passive income from this same staff, once they're trusted enough by outside customers to work on cars that aren't the player's. The presentation escalation above is real and stays exactly as specified; the income mechanic was simply never built to go with it.

---

# PART 7b — The social finding (added after `26`)

**Car Parking Multiplayer — a game named for parking — has one of the largest
player bases in mobile racing, and it is built entirely around showing your car
to other people** (`26` §3.2).

Two of its mechanics bear directly on this specification:

**The engine-bay show.** CPM's vehicle control menu opens doors, trunk and
bonnet, with a dedicated animation for **displaying a tuned engine or performing
virtual repairs in front of other players.**

> This spec already calls for openable panels (§4.1) and an installation
> sequence (Part 6). **CPM demonstrates that the reason players want them is to
> be seen.** Even without multiplayer, that argues for a photo/share output from
> the garage — a framed shot of the car with the bonnet up, generated from the
> Hero or Engine Bay station.

**The flipping economy.** Players buy cheap cars, upgrade them, and **resell to
other players at a profit.** A well-built car has real market value.

> Buying a wreck, restoring it and selling it for more than you paid **is the
> protagonist's actual job.** The Desk (§4.5) should support it: classifieds
> where cars appear cheap and rough, and a sale price that reflects what was
> done to them.

Neither requires multiplayer to be worth building. Both become far more valuable
if multiplayer is ever added.

---

# PART 8 — Technical budget

- **One scene, persistent, loaded at launch.** Baked lighting, one reflection
  probe (`08` §3).
- **Camera positions, not a walkable space.** No navmesh, no character
  controller, no collision geometry.
- **The car is the only high-poly asset.** LOD0 at 25–40k tris (`09` §2) — the
  player is looking at it closely.
- **Everything else is trim-sheet environment** — one material family across the
  whole room (`08` §4).
- **The full interior exists only for the hero car** (`23` §6). Every other car
  parks in a bay and never gets the Interior station.
- Tool wall, lift, bench: **1,000–3,000 tris each.** It is a controlled scene,
  so spending here is affordable.
- **Overdraw discipline** still applies — no layered transparent effects in the
  garage (`08` §3).

---

# PART 9 — What to prototype

**1. The dyno station, first.** This is the `20` §4 test and it remains the
thing that decides whether the whole design holds up: **change one differential
setting and see whether a player can feel it.**

**2. Then one installation sequence.** Build the **wheels** one — shortest, and
the audio is the most satisfying.

> **The confirmation test:** if a coilover swap at the *house* tier feels good,
> and the same swap at the *pro shop* tier feels **better**, the escalation idea
> is confirmed and the other three sequences are just production.

---

## Open: component-level granularity

**Answered — `39-MECHANIC-GAMES-SPECTRUM.md` Part 6.** Category-level parts
(this spec's existing default) is independently validated by Jalopy as a
complete, legitimate design point, not a placeholder waiting for more
detail. The hero car is the one reasonable place to spend extra
granularity, if any is spent at all — everywhere else, stay at category
level.

**One addition worth taking regardless of granularity** (`39` §2.3):
repair itself could consume a limited resource at lower property tiers
(Jalopy's repair-kit scarcity), not just cost money — easing at higher
tiers, consistent with the property ladder's existing pattern of removing
constraints rather than only adding stat bonuses.

# Cross-references
- The comparative analysis behind these decisions → `24-GARAGE-SYSTEMS.md`
- Art direction and garage lighting → `08` §2.1, §3
- Poly and texture budgets → `09` §2–3
- Tool and workshop audio → `10` §4
- Camera and interior policy → `23` §6
- Input and thumb zones → `22`
- Upgrade dependencies → `18` §2.2, `20` §2
- Property tier effects → `16` §4.1, `20` §18
- The dyno prototype → `20` §4, Part 5
