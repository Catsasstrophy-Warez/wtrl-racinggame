# Dyno Analysis and Specification

**The dyno is the designated first prototype** (`20` §4, `25` Part 9). Every
conclusion in this package rests on one assumption — that tuning depth is the
differentiator — and the dyno is where that assumption gets tested.

This document covers every dyno in the corpus, what each got right and wrong,
and what yours should be.

**Part 6 is the specification. Part 7 is the pass condition.**

---

# PART 1 — The taxonomy

**Four distinct things have been called a dyno.**

| Type | What it does | Examples |
|---|---|---|
| **Measurement** | Reports numbers after the fact | Gran Turismo, Forza |
| **Tuning interface** | Where you *make* adjustments | NFS Underground 2, ProStreet |
| **Benchmark** | Gives you a target to beat | **CSR2** |
| **Validation loop** | Build → test → iterate as the core loop | Automation, BeamNG, Car Mechanic Simulator |

> **Your spec currently describes type 2. The most interesting design in the
> corpus is type 3.** Part 6 combines them.

---

# PART 2 — NFS Underground 2 (2004)

**The deepest arcade dyno ever shipped, and it is twenty years old.**

## 2.1 What it does

Accessible from **any Performance Shop, the player's garage, and Customize
mode** — three entry points.

**Measures:** 0–60 mph, 0–100 mph, maximum power, maximum torque, top speed.

**Seven tunable categories:** suspension, aerodynamics, tyres, brakes, ECU,
turbo, nitrous — plus drivetrain.

## 2.2 Three excellent design decisions

### Parts gate tuning

> *"Every setting category requires the player to install performance upgrades
> to the corresponding category."*

You cannot tune aerodynamics without body modifications fitted. **Buying unlocks
adjusting.** That is your garage/dyno split (`25` Part 5), enforced in 2004.

### Five stored setups, one per event type

Circuit, Drag, Drift, Street X, URL. **A setup is not a state — it is a saved
configuration you switch between.**

### The ECU and turbo are bar graphs across RPM bands

Nine bars, each an RPM point. **The player is literally drawing the torque
curve.**

Community wisdom from 2005: ECU high at 5–9, turbo high at 7–9, producing
*"a strong but narrow power band from about 6,000 rpm to the redline."*

> Players in 2004 were shaping powerbands with a bar graph and discussing the
> results in those terms. **That is the interaction your dyno wants.**

### Plus: Test Run mode
Used **different Bayview Speedway configurations per event type**, with the HUD
expanded to show event-relevant data.

## 2.3 Where it broke — three warnings

### Warning 1 — the physics did not back the tuning

From the speedrunning community: **"Stock differential is usually the fastest,
even though it doesn't make sense."**

> **When the tuning model is not grounded in physics, players discover the wrong
> answer is right, and the whole system loses meaning.**
>
> Your physics engine is the fix — **but only if the dyno reads from the same
> model the driving does.**

### Warning 2 — exploitable stacking

Install level 1, tune, install level 2, tune, install level 3, tune — **and the
bonuses compound.** There is a documented glitch involving a rubber band around
the analog stick to hold a bar up indefinitely.

**Fix: recompute from current state. Never accumulate.**

### Warning 3 — a measurement that lied

Dyno speeds read **8% high — on the Corolla specifically.** Players had to
multiply by 0.92 to get real figures.

> **A measurement tool that lies is worse than no measurement tool**, and this
> one lied inconsistently. **Trust is the only thing a dyno sells.**

---

# PART 3 — NFS ProStreet (2007)

**The most granular tuning in the corpus, and the closest existing precedent for
your seven subsystems.**

## 3.1 The full parameter list

All on −10 to +10 scales.

| Group | Parameters |
|---|---|
| **Suspension** | Front/rear shock compression · front/rear shock rebound · front/rear spring · ride height · front/rear roll bar stiffness · front/rear tyre pressure · toe · camber · caster · steering response ratio |
| **Engine** | Cam timing · start boost · end boost · nitrous pressure · nitrous jetting flow rate |
| **Drivetrain** | Six individual gear ratios · final drive |
| **Brakes** | Bias · brake pressure · handbrake pressure |
| **Body** | Aero as **percentage zones** — front wheels zones 1–4, rear wheels zones 1–4, widebody %, spoiler zones 1–5 each with its own % |

## 3.2 What it gets right

**That is essentially your seven subsystems, shipped in 2007.**

Dependency logic is present, though only as advice: *"don't buy a 3rd level
Engine and Drivetrain and leave the Tires and Suspension at level 1 — they simply
can't handle that much power."* Compare `18` §2.2, where yours are enforced by
physics.

The **aero zone percentages** are a genuine wind-tunnel abstraction and worth
studying if you want visual aero to matter.

## 3.3 What it gets wrong

**Twenty-five-plus numeric values on abstract −10/+10 scales, with no curve, no
visualisation, and no explanation.**

The community response was to circulate copy-paste setup sheets.

> **Depth without feedback produces copying, not learning.**
>
> ProStreet had your depth and none of your telemetry (`20` §5).

---

# PART 4 — CSR2: the best idea in the category

CSR2 has almost no tuning — **nitrous (duration vs power), final drive
(acceleration vs top speed), and tyre pressure.** Each unlocks only with the
relevant upgrade: stage 2 nitrous, stage 4 transmission, stage 3 tyres.

**And it has the smartest dyno design anywhere.**

## 4.1 The dyno is a benchmark, not a ceiling

> The dyno time is **what the car runs with a perfect start and a perfect shift
> in every gear, nothing clever.**
>
> **Real races can be faster.**

Players discover shift patterns that beat the dyno — shifting into second
immediately off the line, firing nitrous a gear later, holding a gear longer on a
high-revving engine.

The community guidance is explicit: change one thing at a time, keep what is
faster, and *"after a handful of runs you'll have a pattern that beats the
dyno — that's your race pattern."*

## 4.2 Why this is brilliant

**The dyno gives you a number to beat, and beating it is a skill.**

Two players with identical maxed cars post times half a second apart. **The
difference is the tune and the shift pattern, not the car.**

> **This converts a tuning screen into a target — and it is free.**

## 4.3 One more good detail

**Tune nitrous last**, because its optimum depends on everything else being
finished. **Order of operations as a taught skill.**

---

# PART 5 — The rest

| Game | Its dyno |
|---|---|
| **Gran Turismo** | Power and torque curves in the tuning menu. GT Auto's oil change gives a small hp bump on new cars (`24` §7.1). **Measurement, not interaction.** |
| **Forza** | Telemetry overlay and a tuning menu with a power graph. Excellent telemetry; not a dyno. |
| **Assetto Corsa / ACC** | Setup screens with a power graph. Everything trackside, nothing in a garage. |
| **Automation** | **The full validation loop.** Design an engine, dyno it, iterate. The dyno *is* the game. |
| **BeamNG** | A dyno app in the UI, driven by real physics. **The purest implementation.** |
| **Car Mechanic Simulator** | A test path where you validate a rebuild. |
| **Car Parking Multiplayer 2** | **Ships a Dyno Run** (`26` §3.2). A parking game with a dyno. |
| **Motorsport Manager** | No dyno. Parts R&D and the practice session do the same job (`16` §3.1). |

---

# PART 6 — Specification

**Combine UG2's interface, CSR2's framing, and your physics.**

## 6.0 How a real dyno computes torque — and the artefact to avoid

`34` Part 1d (Beckman Part 26) gives the actual mechanism:

> **`Torque = RPM ratio × J × drum angular acceleration`**, where `J` is the
> drum's moment of inertia. The dyno knows `J`, measures angular acceleration,
> and needs nothing else about the car but engine RPM.

**It does not know the driveline's moment of inertia** — which is why chassis
dyno figures run **15–20% below test-stand numbers**, and why "rear-wheel
torque" is what Beckman calls a well-intentioned misnomer.

> ### ⚠️ The artefact that will fool you
>
> Beckman: *"we have a totally flat torque curve in this little sample, but
> that's only because we have a completely smooth ramp-up of velocity."*
>
> **A perfectly smooth velocity ramp produces a perfectly flat torque curve.**
> If your dyno simulation drives the ramp and derives torque from it, you will
> get a clean flat line and conclude the model works.
>
> **Drive it from the torque curve and let the ramp fall out** — never the
> reverse.

## 6.0a Even soft-body simulators find this hard

Worth knowing before authoring tyre curves feels like a compromise: BeamNG's
own devblog (`35` Part 4.1), after a decade of dedicated soft-body physics
development, still names **accurate tyre physics as one of the hardest open
problems in the project**, citing the same scarcity of real reference data
flagged throughout `34`. **This is a genuinely hard problem regardless of
simulation approach, not a symptom of using a simplified model.** Budget
authoring time accordingly (§6.2) and don't treat difficulty here as a sign
something is being done wrong.

## 6.0b The tyre formula to actually implement

Added after reading Beckman Part 29 in full (`34` Part 1e). Beckman built a
**three-parameter substitute for the full Magic Formula, explicitly for game
simulation**:

> **`F = B · Fz · α / (1 + |A · α|^P)`**

One division, one absolute value, one power — no trig, no piecewise branches.
Fitted against the same reference tyre data used in Parts 21–22, it differs
from the full Pajecka model by under 10% almost everywhere, with larger error
only very close to zero force, where it doesn't matter.

> **This is very likely the right starting tyre model for the dyno prototype**
> (Part 7 above). Three tunable numbers per compound rather than eleven-to-
> fifteen solves the dyno's authoring problem directly (§6.2 below), it's cheap
> enough for every wheel on every physics tick on a phone, and Beckman's own
> fitting method — a grid search narrowed in stages — is the same method to use
> for authoring your own compounds against RVP's friction curves.
>
> The public-domain Python reference in `code/pacejka-reference/` implements
> the full Magic Formula. **The three-parameter version is less work to port and
> was explicitly designed to be interchangeable with it.**

## 6.1 Read from the actual physics model

**Non-negotiable.** The dyno must be a *measurement of the simulation*, not a
parallel model.

> **This is the one thing every competitor got wrong and you get for free.**
> UG2's differential problem, ProStreet's copied setup sheets, and CSR2's
> abstraction all trace back to a tuning layer that was not the driving layer.

## 6.2 Draw the curve, do not move sliders

UG2's bar-graph-by-RPM was right in 2004 and **nobody has improved on it.**

Boost, fuel map and cam timing should **visibly reshape a torque curve the
player can see.** The curve is the interface.

## 6.3 Give a benchmark, then let them beat it

**CSR2's insight, adapted:**

- **The dyno reports what the car should do** — a theoretical best lap or sector,
  computed from the current setup
- **The track reports what the player did**
- **The gap between them is driver skill**

> **Naming that gap is the most motivating thing a racing game can tell a
> player.** It also separates "my car is slow" from "I am slow," which is the
> single most useful diagnostic in the genre.

## 6.4 Parts gate adjustment

No coilovers, no damping sliders. **Buying unlocks tuning** (UG2, §2.2).

## 6.5 Store a setup per event type

Five slots. Switching between them is **one tap at the event entry screen**,
alongside Heat's recommended-spec display (`19` §2.12).

## 6.6 Free to iterate

No cost, no time limit, no consumable.

> **This is the screen a broke player lives in** (`25` Part 5). Parts cost money;
> calibration must not.

## 6.7 The mentor reads it with you

`30` §1.3. He is the difference between a chart and a conversation:

> *"That's all top-end. You'll never use it on a circuit that tight."*

---

# PART 7 — The pass condition

`20` §4 designates the dyno as the first prototype. **Here is the specific test.**

> ## Change one differential setting.
>
> **1. The curve moves visibly.**
> **2. The lap time moves measurably.**
> **3. The player can feel it through tilt.**
>
> **All three, or the premise does not hold.**
>
> **And measure it after ten minutes of continuous play on a warm device, not a
> cold one** (`34` Part 1b, Finding 2). Thermal throttling grows Δt, which grows
> integration error, which degrades the handling model itself. **If the
> differential change is perceptible at minute one and not at minute twelve, you
> have not passed.**
>
> **And run it on both a Pro-tier ProMotion device and a base-tier 60Hz
> device** (`36` Part 2). Touch latency drops from 16ms to 8ms at 120Hz —
> a real, measured difference, not a marketing number. The same
> differential change may pass on one device tier and fail on the other,
> with the physics completely unchanged. That is not a failed test; it is
> a finding requiring a decision (`36` §2.3).

**ProStreet had the first. UG2 had the second. Neither had the third.**

The third is the one `22` exists to solve, and it is the one that costs eighteen
months if you discover it late.

---

# PART 8 — The four failure modes, collected

1. **Physics that do not back the tuning** (UG2's differential, §2.3). If the
   dyno and the driving read from different models, players find the exploit and
   the system dies.
2. **Exploitable stacking** (UG2's install-tune-install). Recompute from current
   state, never accumulate.
3. **Measurements that lie** (the 8% Corolla error). Trust is the only thing a
   dyno sells.
4. **Depth without feedback** (ProStreet's 25 sliders). Produces copied setup
   sheets, not understanding.

---

# Cross-references
- The dyno as first prototype → `20` §4, `25` Part 9
- The three tuning contexts → `25` Part 5
- Upgrade dependencies → `18` §2.2, `20` §2
- Post-race telemetry → `07` §1.1, `20` §5
- Pre-event spec display → `19` §2.12
- Input resolution, and why the third test matters → `22`
- The mentor's diagnostic voice → `30` §1.3
- UG2's shops and fine-tuning → `19` §2.5
