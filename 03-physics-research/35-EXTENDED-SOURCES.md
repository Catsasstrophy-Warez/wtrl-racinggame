# Extended Sources: Beyond Beckman

**What this is.** Beckman's *Physics of Racing* (`34`) is complete, but it is
not the only source, and on several points it is not the best one. This
document covers what is genuinely comparable or better, researched directly
rather than taken on faith.

**A licensing note before anything else.** Beckman's series carries an
explicit perpetual, royalty-free redistribution licence — that is why `34`
could quote it at length. **Nothing in this document has that licence.**
OptimumG's articles are © OptimumG / RaceCar Design Magazine. The arXiv paper
is © IEEE. BeamNG's devblog is © BeamNG GmbH. The textbooks are commercial and
unavailable to me in full. Everything below is paraphrase and short
attribution, not reproduction — treat this document as a map to primary
sources, not a substitute for owning them.

---

# PART 1 — OptimumG: the closest living equivalent to PhoRS

`optimumg.com/technical-papers` is free, current (publishing into 2024–2026),
and written by Claude Rouelle, who has run vehicle dynamics seminars since
1997. Two articles read in full below; several more listed for later reading.

## 1.1 "Rolling About" — jacking forces ⚠️ refines Part 27

**The finding that extends the package's static weight-transfer solution.**

Part 27 (`34` Part 1e) gives the closed-form static solution for four-corner
weight transfer — correct, but it assumes the suspended mass rotates cleanly
about a fixed roll axis. Rouelle's article explains why that assumption is
incomplete: **the geometric portion of load transfer depends on the actual
distribution of lateral tyre force between the inside and outside wheels, not
just on suspension kinematics.**

Because the outside tyre carries more load and therefore more lateral force
than the inside tyre, the two geometric load-transfer contributions do not
cancel symmetrically. **The imbalance produces a net vertical "jacking" force**
that physically lifts or lowers the car's ride height during cornering —
Rouelle cites real skid-pad data showing on the order of 1mm of movement with
stiff suspension and up to 10mm with soft suspension.

> ### Why this matters for your build
>
> **Ride height is a tuning parameter that already appears in your aero setup**
> (`25` §5 — ride height rake). Jacking means ride height is not static during
> a corner even if the player sets it and never touches it again — it moves
> *because of cornering itself*, and since downforce is ride-height sensitive
> (`08`, `25`), **this is a second-order aerodynamic effect that emerges from
> combining the tyre model with the suspension model, not something to author
> separately.**
>
> One structural fact worth keeping regardless of implementation depth: **total
> load transfer is fixed by mass, lateral acceleration, track width and CG
> height alone.** What changes is only the *split* between the geometric and
> elastic portions — more of one always means less of the other. That
> conservation law is a good sanity check on any suspension model: if your
> geometric and elastic components don't trade off against a constant total,
> something is wrong.

**Depth call:** full jacking-force simulation (requiring real-time inside/
outside tyre force distribution from an actual tyre model) is more than a
mobile prototype needs. **Knowing it exists, and that ride height is not truly
static under load, is enough to avoid modelling downforce as a function of a
fixed setup value alone.**

## 1.2 "The anti-antis" — anti-dive and anti-squat are coupled, not independent

**The finding:** most treatments consider front anti-dive and rear anti-lift
(under braking), or rear anti-squat and front anti-lift (under acceleration),
as separate front/rear properties. Rouelle argues this is the same mistake as
analysing left and right suspension independently in a corner — **the whole
suspended mass rotates about one pitch axis under longitudinal acceleration,
just as it rotates about one roll axis under lateral acceleration**, and front
and rear suspension geometry jointly determine where that axis sits.

**The story that motivates it:** increasing front anti-dive by ten percentage
points, with every other car parameter fixed, made the *whole car* sit lower
on average under braking — not higher, as naive intuition about "anti-dive"
would suggest — because the change moved the pitch axis and increased overall
pitch angle, and the rear rose more than the front dropped.

> ### Application
>
> **Front and rear suspension setup should not be tunable as if independent.**
> If `25`'s tuning system exposes anti-dive/anti-squat-adjacent parameters
> (spring rates, damper settings, ride height), the underlying physics model
> should compute a single pitch axis from *both* ends together, not apply
> front and rear corrections separately. This is the same principle as Part
> 20's "you can't solve four wheels independently" (`34`), one axis over.

**Also worth knowing, briefly:** the same article notes that adding rake
(different front/rear static ride heights) to a car designed with zero
anti-dive/anti-squat *introduces* anti-dive and anti-squat as a side effect,
since the geometric reference lines are no longer parallel to the ground once
the chassis is raked. Another case of one tuning parameter (rake, already in
`25`) having a physical consequence on another (longitudinal weight transfer
behaviour) that a naive implementation would miss.

## 1.3 Other OptimumG articles worth reading next

Not fetched in full, but titled and catalogued for when you need them:

| Article | Covers |
|---|---|
| **"Magic Numbers"** | Determining anti-roll bar stiffness using delta values — directly useful for exposing an ARB stiffness parameter with a physically grounded target rather than an arbitrary slider range |
| **"Optimal thinking" Parts 1–2** | Suspension kinematics design theory, including corner-weight variation induced by steering itself |
| **"Entry Requirements"** | How load transfer plays out specifically in the first few metres of corner entry — pairs with Beckman Part 13's transients and the Constant's trail-braking advantage (`30` §3.2) |

## 1.4 OptimumLap — free lap-time simulation software

OptimumG publishes **OptimumLap**, described on their site as always free.
It is a point-mass lap-time simulator with track converter tools and vehicle
databases. **Worth downloading as a reference/validation tool**: build a rough
model of your hero car's specs in it and compare its predicted lap time against
what your own simulation produces, as an external sanity check independent of
your own code. Not a source of new physics — a free instrument for checking
your physics against someone else's implementation.

---

# PART 2 — Kelvin Tse: a working vehicle dynamics engineer's public notebook

`kktse.github.io`. Described by its author as *"vehicle dynamics from
scratch"* — a former professional in the field writing up his own analysis
work, much of it on real club-level race cars with real measured data.

## 2.1 ⚠️ The NHTSA database — real CG height and inertia data, free

**The single most directly useful find in this pass.**

Tse's post *"Estimating vehicle inertia and centre-of-gravity height using the
NHTSA light vehicle inertial parameter database"* points at a genuinely
excellent public resource: the **NHTSA Light Vehicle Inertial Parameters
Database**, freely available from NHTSA, containing measured or estimated CG
height, inertia, static stability factor, and dynamic index data for a large
range of real production vehicles, non-dimensionalised against track width and
weight distribution so the values transfer across vehicle sizes.

> ### Application: real numbers for the hero car's seven generations
>
> `32` §7.1 specifies seven hero-car generations by era, and `32` §7.0 adds
> polar moment of inertia (Beckman Part 13, `34`) as a second physical axis
> distinguishing them. **Both currently rely on estimation.**
>
> The NHTSA database lets you **look up real CG height and inertia figures for
> era-appropriate vehicles** — a big-block muscle car of the early generation
> versus a modern platform of the late one — rather than guessing at PMI
> differences. Manufacturers publish the geometry data (wheelbase, track,
> weight distribution) needed to apply Tse's non-dimensionalised method even
> for vehicles not directly in the database.
>
> **This is free, government-sourced, real-world data**, and it is the
> difference between "the early generation should probably feel heavier to
> turn" and an actual measured PMI ratio to tune against.

## 2.2 Other posts worth knowing about

**On-centre handling metrics**, using the **linear single-track (bicycle)
model** — the same simplified two-wheel abstraction Beckman uses informally in
several PhoRS chapters, but here applied with real understeer-gradient and
cornering-compliance measurements from an actual race car (a Honda Civic Si
raced in Ontario Time Attack). Useful as a worked example of taking a simple
model and validating it against real telemetry — directly analogous to what
your own dyno-vs-track validation loop (`31` Part 7) should do.

**Suspension kinematics analyses of real cars** (Acura RSX anti-dive/anti-lift,
Honda Civic EK wheel-plane control) — practical applications of exactly the
OptimumG theory above, worked through on real measured suspension pickup
points rather than in the abstract. Good reference for what realistic
suspension geometry numbers look like if you want your hero car's generations
to be grounded in plausible real values.

**"Photography as data acquisition"** — measuring roll angle and tyre
inclination from a single photograph of a car at the apex of a corner, using
photogrammetry software (SolveSpace). A genuinely clever low-cost technique;
mentioned here mainly as a demonstration of the amateur-engineering spirit
this whole research thread shares with Beckman's original series — real
analysis does not require a lab budget.

---

# PART 3 — Academic optimal control: genuinely supersedes Parts 17–18

Beckman's own racing-line optimisation (`34` Part 1e, Beckman Parts 17–18) is
explicit about being hand-tweaked in a spreadsheet, not a rigorous search. A
real academic literature exists that does this properly, and one paper in it
produced the best single finding of this whole research pass.

## 3.1 Werner, Sagmeister, Piccinini, Betz — g-g-g-v diagrams (2025)

*"A Quasi-Steady-State Black Box Simulation Approach for the Generation of
g-g-g-v Diagrams,"* arXiv:2504.10225, IEEE 2025. **Open-source code released
alongside it**: `github.com/TUM-AVS/GGGVDiagrams`.

### What it actually does

Extends Beckman's Part 7 traction circle (`34` Part 1c) into a full **g-g-g-v
diagram** — the achievable acceleration envelope as a function not just of
longitudinal and lateral acceleration, but of **speed and vertical
acceleration too**, which matters on non-flat tracks where crests and dips
change the effective vertical load, and where aerodynamic forces scale with
speed.

### The method, and why it's better than Beckman's hand search

The paper formalises the **Milliken Moment Method** — originally a physical
cable-rig test described in Milliken & Milliken's textbook, here replicated in
simulation by applying **virtual external forces at the vehicle's centre of
gravity** to emulate a given longitudinal or vertical acceleration while
holding speed constant via a controller. A slow, controlled steering ramp is
then applied, and the point at which the car becomes unstable is detected.

**Critically, the method treats the vehicle model as a black box.** It does
not require a simplified, differentiable version of your physics — it works
directly on whatever full-fidelity car simulation you already have. This is a
direct advance over optimisation-based lap-time methods, which typically need
simplified equations of motion, and over Beckman's own hand search, which
required manually tweaking a spreadsheet.

### ⚠️ The single best finding of this research pass: a precise oversteer criterion

The paper's method for detecting the transition into instability during a
ramp-steer test is genuinely elegant and cheap to compute:

> **Front-axle saturation (understeer)** is detected as a local maximum in
> lateral acceleration — the car simply stops turning harder no matter how
> much more steering is applied.
>
> **Rear-axle saturation (oversteer)** is detected by comparing actual lateral
> acceleration against what steady-state cornering at the current yaw rate
> would predict: **`|a_y − v·ψ̇| > ε_threshold`**. Once this gap exceeds a small
> threshold, the car has begun rotating faster than its lateral acceleration
> would suggest in a stable turn, and the last stable sample before that point
> is the true limit.

> ### This is a formal version of the instability meter's threshold
>
> `20` §1 already establishes the instability meter as a readout of Beckman's
> traction circle (`34` Part 1c–1d), and `20`'s later revision ties the
> threshold to Part 25's "cup" region. **This paper supplies a third,
> independent, and precisely computable criterion for exactly the same
> moment**, using quantities — lateral acceleration, velocity, yaw rate — that
> RVP and TORSION already expose every physics tick.
>
> **`|a_y − v·ψ̇|` is cheap: a multiply, a subtract, an absolute value.** No
> tyre-model lookup needed at evaluation time, only the outputs the physics
> engine already produces. This is very likely a better real-time detection
> signal for "the car has started to rotate faster than the driver intended"
> than trying to infer it from raw slip angle alone, and it is directly
> implementable in RVP or TORSION's per-frame update.
>
> **Recommendation:** implement this criterion as the trigger for the
> instability meter crossing into "lost it" territory, alongside the
> traction-circle-based fill level for how close to the limit the car is
> generally running. The fill level answers "how hard am I pushing"; this
> criterion answers "have I actually lost the back end."

### Two more things worth knowing

**The g-g-g-v extension itself** — accounting for vertical acceleration —
matters if any of your tracks have real elevation change (crests, dips,
banking). Aerodynamic downforce and lift both vary with speed, and the paper's
extended model shows measurably different longitudinal and combined-manoeuvre
limits once speed-dependent aero is included versus a fixed-aero baseline.
**If your professional tier includes an undulating circuit, this is the
correct way to think about how the acceleration envelope itself changes across
the lap, not just the grip.**

**The open-source repository** (`TUM-AVS/GGGVDiagrams`) is a genuine
implementation reference, separate from Beckman's hand-derived approach —
worth reading directly if you build a similar offline tool for generating AI
racing-line envelopes or difficulty-tier vehicle limits.

## 3.2 The wider literature, for reference

The paper's own citations trace a real research lineage worth knowing exists,
even without reading each one: Massaro & Limebeer's *"Minimum-lap-time
optimisation and simulation"* (2021), Lovato & Massaro's *"three-dimensional
free-trajectory quasi-steady-state optimal-control method"* (2022), and
Kritayakirana & Gerdes' earlier work on *"Autonomous cornering at the limits"*
(2010) using feedforward trail-braking. **Searchable on arXiv and Google
Scholar under "minimum lap time optimal control race car"** if you want to go
deeper than this package covers.

---

# PART 4 — BeamNG: useful as contrast, not as an implementation model

`beamng.com` and their public devblog. Included because it represents the
opposite end of the fidelity spectrum from everything else in this package,
and that contrast is itself informative.

## 4.1 What they actually do

BeamNG simulates vehicles as **node-and-beam soft-body structures** — every
part of the car is a network of point masses (nodes) connected by spring-like
constraints (beams), updated at **2,000 Hz**. This is explicitly **not** a
rigid-body-plus-tyre-curve model of the kind RVP, TORSION, and every other
source in this package uses. Their own materials describe rigid-body
simulation (what you are building on) as computationally cheap and scalable
but unable to deform; their soft-body approach is the reverse trade — genuine
deformation and damage, at enormous computational cost.

**Even their own tyre model is unusually literal**: rather than a curve-fit
force model (Pacejka, or Beckman's three-parameter alternative from `34`),
BeamNG devblog posts describe tyres as **flexible node-beam structures that
collide and interact the same way as the rest of the vehicle** — the tyre
*is* simulated soft-body geometry, not a force curve at all. Their own
developers describe accurate tyre physics as one of the hardest ongoing
problems in the project, specifically citing a lack of reference data for
calibration — **the same "the constants are trade secrets" problem** already
identified in `34` Part 3.3, at a much more literal level.

## 4.2 The actual takeaway

> **This validates the existing choice rather than suggesting a change.**
>
> A 2,000 Hz soft-body simulation is not viable on a phone, and RVP's mesh
> deformation for damage (`04` §1) plus a curve-fit tyre model is the correct
> trade for your platform — cheap enough to run, with damage handled as a
> visual/gameplay layer rather than a physics one. BeamNG proves the *far* end
> of what's possible when cost is no object; it is a reference for how much
> headroom exists above your target, not a target itself.
>
> **The one transferable lesson**: even a studio with a decade of dedicated
> soft-body physics development still finds tyre modelling the hardest open
> problem, for the same reason Beckman flagged and this package has now
> confirmed three times over — real tyre data is scarce and jealously
> guarded. **Budget your own tyre-curve authoring time accordingly** (`31`
> §6.2); it is a genuinely hard problem regardless of your simulation
> approach, not a symptom of using a simplified model.
>
> **A second, independent confirmation of the platform decision itself**
> (not just the tyre-modelling difficulty) is in `39-MECHANIC-GAMES-
> SPECTRUM.md` Part 5: BeamNG's own players have long asked for the
> ability to cleanly remove an already-broken part without resetting the
> vehicle, and can't — the node-beam structure has no native concept of a
> discrete "part" to remove. **Players want discrete parts even inside
> the game that structurally can't provide them.** This project's
> discrete-named-parts approach is validated twice over: once by cost
> (here), once by player preference (`39`).

---

# PART 5 — The commercial textbooks: a second research pass, honestly reported

**A second pass was made specifically to find what's legitimately public about
each of these six** — formulas restated in open academic papers, official
publisher descriptions, citation data, and (the best possible outcome)
open-source code built citing the book as its theoretical source. **The
outcome was uneven across the six, and is reported that way below rather than
smoothed over.**

**One thing surfaced during this pass and was explicitly discarded**: search
results for both Gillespie and Segers returned snippets from sites hosting
apparently unauthorised full scans — front matter, tables of contents, and in
Gillespie's case a complete symbol list and dedication page, lifted wholesale.
**None of that content is used anywhere in this document.** The line held: no
pirated copies sought, none used even when a general search surfaced them
unprompted.

## 5.1 Milliken & Milliken, *Race Car Vehicle Dynamics* — the strongest result

**This one worked well, and produced the best material in this whole pass.**

Two separate, properly open-licensed code repositories implement the book's
central contribution — the **Milliken Moment Method (MMM)** — without
reproducing any of its text:

**`TUMFTM/YawMomentDiagrams`** (LGPL-3.0, TU Munich). Generates yaw moment
diagrams — the **Cn–Ay** and **Cn–Cn** variants Milliken defined — from any
vehicle dynamics model with documented I/O: per-wheel torque, steering angle,
and brake pressure in; velocity, lateral acceleration, yaw rate, and slip
angle out. It computes five distinct diagram types (Yaw Moment, Control
Moment, Control Force, Stability, and slip-angle-difference diagrams) and
evaluates handling KPIs at three defined points — **@lim** (maximum lateral
acceleration), **@trim** (maximum *steady-state* lateral acceleration, where
yaw moment is zero), and **@straight**.

**`TUM-AVS/GGGVDiagrams`** (`35` Part 3.1, already covered) — explicitly built
on the same MMM principle, extended to speed and vertical acceleration.

> ### What this is worth to you
>
> **A third, independent, open-source implementation of a Milliken-derived
> handling-characterisation tool**, alongside the g-g-g-v repo and the
> Pacejka reference in `code/pacejka-reference/`. The **Stability Diagram**
> output in particular — change of yaw moment with respect to body slip angle
> — is a formal version of exactly what the oversteer criterion in `20` §1
> detects informally: a positive value means a stable reaction to a
> disturbance, negative means unstable. **If you ever build offline tooling to
> characterise a car's handling balance** (for tuning validation, or for
> generating the readable rival profiles in `30` §3.2), this repository is a
> working reference for how to do it properly, built directly from Milliken's
> method.

**Also legitimately public**: a concise, correct conceptual description of
the Cn–Ay/Cn–Cn diagram distinction — Cn–Ay evaluates behaviour across
different speeds, Cn–Cn evaluates a specific corner radius — sourced from an
independent technical writeup, not the book.

## 5.2 Gillespie, *Fundamentals of Vehicle Dynamics* — a narrower result

**The search for this one surfaced the leaked-scan problem described above.**
What remains, after discarding that content entirely:

**Gillespie's own words, from a public source he doesn't control the
copyright framing of** — a filed regulatory expert-witness statement (ROHVA,
a US off-highway vehicle standards body), where he explains his own
understeer-gradient concept directly:

> the understeer gradient is *"not a single value but varies continuously with
> the vehicle's operating state,"* and is *"directly related to the cornering
> compliance of the front and rear axles, quantified by the sideslip angle per
> unit of lateral acceleration."*

That is a legitimate, author-sourced restatement of one core concept — useful
confirmation that "understeer gradient" is a *state-dependent* quantity, not a
fixed car property, which matters if `31` or `20` ever expose it as a single
number rather than something read live off current conditions.

**Also legitimate**: SAE's own official course listing for the book, and a
lead worth checking independently — **Georg Rill's vehicle dynamics lecture
notes**, publicly posted by Hochschule Regensburg, appear to cover similar
ground to Gillespie's textbook. Not verified as an authorised open resource
in this pass; worth checking directly before relying on it.

## 5.3 Pacejka, *Tire and Vehicle Dynamics* — a genuinely useful partial result

**The Magic Formula's actual lateral equation, restated independently across
several current, unrelated academic papers** — this is legitimate: equations
describing a physical relationship function as standard notation once enough
independent researchers cite and restate them, the same way a physics formula
isn't "the book's text" merely because a textbook was first to publish it.

```
F_y = D·sin(C·arctan(B·Φ))
Φ = (1 − E)·α + (E/B)·arctan(B·α)
```

Consistent with Beckman's own Parts 21–22 (`34` Part 1d), confirming
independently that his simplification tracks the source correctly.

**Also found**: Wikipedia's clean biographical and conceptual summary of
Pacejka and the Magic Formula's origin, and a reading list of **open PhD
theses** that extend his work and are freely available from their host
universities — Higuchi (1997, Delft, transient tyre response at large slip
and camber), Svendenius (2007, Lund, tyre modelling and friction estimation),
Van Ginkel (2014, Delft, tyre-road friction from force measurements). **These
are legitimate open academic documents**, unlike the leaked commercial scans
above, and worth reading directly if the low-speed divergence problem
(`34` Part 3.2) or the speed-blindness limitation (`34` Part 1d) need a more
rigorous treatment than this package provides.

## 5.4 Genta, *Motor Vehicle Dynamics: Modeling and Simulation* — no new material

**Honestly: this pass did not surface anything beyond what `34` already has**
via Beckman's own explicit citations (the "Genta's possible-Ferrari data
sheet" constants used throughout Parts 21, 22, 25, 29). No open
implementation, no independently-restated formula set, no legitimate
secondary source of comparable depth was found.

## 5.5 Carroll Smith, *Tune to Win* / *Engineer to Win* — no new material

**Also no significant new find in this pass.** The roll-stiffness-versus-
anti-roll-bar distinction already in `33`/`35` §1.2 (drawn from a widely-
quoted passage) remains the extent of what's legitimately represented from
these two books. They are the most practical and least mathematical of the
six — written by a race engineer for other race engineers — which may be
exactly why they circulate less as cited formulas in academic papers, the
channel that worked well for Milliken and Pacejka.

## 5.6 Segers, *Analysis Techniques for Racecar Data Acquisition* — scope confirmed, not depth

**Two legitimate things surfaced**, neither the book's actual content:

**A topic index** (Google Books' auto-generated keyword list — a standard
bibliographic feature, closer to a book's own back-of-index page than to
reproduced prose) confirms the book's scope aligns closely with material
already in this package — traction circle, weight transfer, roll gradient,
motion ratio, slip angle, slip ratio, oversteer — and surfaces **"roll
gradient"** and **"motion ratio"** as named concepts not yet explicitly
covered anywhere in this package. Worth knowing they exist as search terms if
you go looking for them elsewhere.

**Its own bibliography** (citation lists are factual data, not copyrighted
prose) shows Segers draws on Milliken & Milliken, Fey's *Data Power — Using
Racecar Data Acquisition*, Van Valkenburg's *Race Car Engineering and
Mechanics*, and Rouelle's OptimumG seminar material (already covered in Part
1 above) — confirming the vehicle-dynamics literature is a small, densely
cross-citing world, and that this package's coverage of Beckman, OptimumG,
and Milliken already touches most of what Segers itself is built on.

## 5.7 The honest summary

**Two of six (Milliken, Pacejka) improved meaningfully** through legitimate
secondary sources — open-source code in Milliken's case, independently
restated formulas and open theses in Pacejka's. **One (Gillespie) improved
narrowly**, salvaging one author-sourced quote after discarding leaked
content. **Three (Genta, both Carroll Smith titles, Segers) did not improve**
beyond what was already documented, though Segers' scope is now confirmed
rather than assumed.

**If you want the other four covered the way PhoRS, Milliken, and Pacejka now
are**, the path remains the one that worked for the missing Beckman
chapters: **obtain the book legitimately, supply the relevant pages, and they
get read as primary source** rather than reconstructed from whatever a search
happens to surface.

---

# Cross-references
- Instability meter and the new oversteer criterion → `20` §1
- Static weight transfer, extended by jacking forces → `25` §5, `34` Part 1e
- Hero car PMI, extendable with real NHTSA data → `32` §7.0
- Tyre curve authoring and its inherent difficulty → `31` §6.2, `34` Part 1c §3.3
- Rigid-body-plus-curve-fit as the correct platform trade → `04` §1, `02`
- Trail braking and corner-entry load transfer → `30` §3.2, `34` Part 1c (Part 23)
