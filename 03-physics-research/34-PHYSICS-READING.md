# Vehicle Physics: Reading List and Gotchas

**A genuine gap in this package.** Thirty-three documents on what to build and
nothing on where to learn the underlying physics — despite tuning depth being the
stated differentiator.

Everything in Part 1 is **free**. Part 3 contains three practical failures you
would otherwise ship.

---

# PART 1 — The canonical free resources

## 1.1 Brian Beckman — *The Physics of Racing* (PhoRS)

**The single best free resource on this subject.**

25+ articles by a physicist, in HTML and PDF. Licensing is explicit:

> The "Physics of Racing" is a set of free articles. You are granted a
> **perpetual, transferable, royalty-free licence** to copy, print, distribute,
> reformat, host and post the articles in any form — provided you do not change
> the content or attribution, do not charge money, and do not restrict others'
> rights to copy freely.

**Coverage:** weight transfer, tyre behaviour, slip angles, combined slip, and
**Part 21 — the Magic Formula, longitudinal version**, which Wikipedia's own
Pacejka article cites as a reference.

Beckman also recorded a talk, *The Physics in Games — Real-Time Simulation
Explained* (Channel 9, 2007; archived). Worth the hour.

Mirrors include `autoxer.skiblack.com/phys_racing/contents.htm`.

> **Read this before touching the RVP code.** It tells you what RVP's friction
> curves are actually approximating, which changes how you read every parameter.

**On combined slip, Beckman is refreshingly honest:**

> *"There are a lot of ways we could stitch them together. This is not the kind
> of situation where there is one right answer. In the absence of hard theory or
> experimental data, we have the freedom to be creative, with the inevitable risk
> of being wrong."*

Useful to know when your own combined-slip handling feels arbitrary. It is.

## 1.2 Marco Monster — *Car Physics for Games* (2000–03)

The classic introduction, mirrored at `rsms.me/etc/car-physics/`,
`asawicki.info`, and elsewhere.

**Its central teaching structures everything else:** handle longitudinal and
lateral forces separately. Longitudinal forces (wheel force, braking, rolling
resistance, drag) control speed. Lateral forces, from sideways tyre friction,
allow the car to turn.

### Know its limitation before relying on it

From a GameDev.net thread on exactly this:

> *"Marco Monster's car physics is one of my favorites, but it deals with a sort
> of 2D car (bicycle). **It can mislead you when making real 3D physics.**"*

**Read it for the framing. Do not implement from it.**

## 1.3 The VPP documentation

`vehiclephysics.com` and `github.com/EdyJ/vehicle-physics-docs`.

**Tempered assessment:** the index page is mostly marketing. **The technical
depth is in the sub-pages** — `about/features` and the component/block
documentation — not the landing page.

Two things the docs confirm that matter here:

- **Full VPP is explicitly "efficient, mobile-capable"** — the Professional
  licence genuinely ships to iOS, unlike the Community Edition (`02`)
- **Customers listed:** Take-Two, Toyota, BMW, Volkswagen, Scania, UPS, Unity.
  This is a package used for actual vehicle engineering.

**Also follow Edy's dev blog at `edy.es/dev`.** He posts about implementing
specific components — there is one on anti-roll bars with a chart of suspension
distance over time showing the effect directly. Exactly the kind of thing you
want when tuning your own.

---

# PART 1b — What the key articles actually say

Read directly, not summarised from elsewhere. **Two of these change other
documents in this package.**

## The full contents (29 parts)

Most relevant to this project, in rough priority order:

| Part | Title | Why |
|---|---|---|
| **7** | **The Traction Budget** | The circle of traction. **This is your ragged-edge meter, physically grounded** |
| **28** | **Hazards of Integration** | Euler diverges. RK4 is the fix. **Affects your thermal budget** |
| **27** | Four-Wheel Weight Transfer | The real version, beyond Part 1 |
| **20** | Four-Point Statics | Per-corner load |
| **24 / 25** | Combination Slip / Combination Grip | Combined slip, honestly caveated |
| **21 / 22** | The Magic Formula, longitudinal / lateral | Pacejka, both axes |
| **13** | Transients | Dynamic behaviour |
| **14** | Why Smoothness? | Directly relevant to the instability meter |
| **10** | Grip Angle | |
| **11 / 23** | Braking / Trail Braking | |
| **8 / 16** | Simulating Car Dynamics / RARS | Implementation, and a simple open racing simulator |

---

## Part 7 — The Traction Budget

### The core result

> **The maximum acceleration a tyre can take is μg, a constant, independent of
> the mass of the car.**

While the maximum *force* depends heavily on the current vertical load, **the
acceleration does not.** A tyre that gives one g gives it on a light car and a
heavy one, loaded or unloaded.

*(Approximately true — μ changes slightly with load, which is a second-order
effect.)*

### Weight transfer is a fraction, not a weight

> *"In a one-g braking manoeuvre, the same **fraction** of each car's total
> weight will be transferred to the front... This will be the same 20% in a 3500
> pound stock Corvette as in a 2200 pound tube-frame Trans-Am Corvette, so long
> as the geometry is the same."*

**Separate the kinematics from the mass.** `W = f(a)mg`, where `f(a)` is the
fraction the tyre must support and accounts for weight transfer.

### Forces combine by Pythagoras, not addition

Front-back acceleration `a_y` and left-right `a_x` combine as
`sqrt(a_x² + a_y²)` — **not** by adding.

### The circle of traction

The boundary is the traction limit. Every point inside is a choice about how you
spend the budget: top is pure acceleration, bottom pure braking, sides pure
cornering, everything else a Pythagorean combination.

> *"In racing we try to spend our budget so as to stay as close to the limit as
> possible. In street driving, we try to stay well inside the limit."*

**The beauty of the representation:** weight-transfer effects are factored out,
so the circle stays approximately the same whatever the load.

### The whole-car budget is not a circle

For a car with sticky fronts and slippery rears, the combined budget looks like
**an egg — flattened at the top, wide in the middle.** Under braking the sticky
fronts dominate; under acceleration the slippery rears do.

> **That single diagram explains understeer and oversteer as one shape.** It is
> the clearest available way to visualise what your tuning changes actually do,
> and it is a strong candidate for the dyno readout (`31` §6.2).

### And a note for the corpus

Beckman, in 1991:

> *"It is probably close enough to make a computer driving simulation that feels
> right (I'm pretty sure that **Hard Drivin'** and other such games use it)."*

Hard Drivin' (1989) is in `17` §1 as the first genuine physics simulation in the
genre. The lineage closes.

---

## ⚠️ Finding 1 — the traction circle IS the ragged-edge meter

`20` §1 and `30` specify an instability meter adapted from Gaslands' hazard
tokens (`06` §1.2) — driving at the limit accumulates instability, backing off
sheds it, crossing the threshold loses the car.

> **Part 7 gives that mechanic a physical basis.**
>
> **The meter is how close you are to the boundary of the traction circle.**
>
> Spending your budget near the edge fills it. Spending it well inside empties
> it. A wipeout is the moment you ask for more than μg.

This matters because the whole design rests on **consequences being simulated
rather than authored** (`20` §2). The instability meter was the one signature
mechanic that looked like an authored abstraction. **It isn't.** It is a readout
of a real quantity your physics engine already computes.

**Implementation:** per-wheel, `sqrt(a_x² + a_y²) / (μg)` as a normalised
0–1 value, integrated over time with a decay term. The decay rate is the
"handling determines how fast you shed it" parameter.

---

## Part 28 — Hazards of Integration

### The demonstration

Beckman integrates an **undamped harmonic oscillator** — about the simplest
differential equation there is — using Euler's method.

> **DISASTER. The numerical version is 60% larger than it should be at 100
> seconds, and looks as though it will continue to grow without bound.**

### Why it fails

A small velocity error propagates: **the position error gets worse even when no
further velocity errors creep in**, and the velocity errors eventually overwhelm
as time grows.

The root cause is structural: **Euler is a linear approximation, and the solution
curves.** A straight line overshoots a curve, every step, forever.

### The fix

**4th-order Runge-Kutta**, which Beckman calls *"the virtual industry
standard."* It samples four points inside each step and combines them in a
weighted average.

> *"The Runge-Kutta solution remains completely stable and visually
> indistinguishable from the exact solution while the Euler method goes
> completely mad."*

### The step-size arithmetic — read this twice

> *"At 30 frames per second, an acceptable minimum, Δt will be about 33.3
> milliseconds. At 100 miles per hour, or 147 feet per second, a car will go
> about 5 feet in that time. This means that with an integration step size of 33
> msec, **we can only predict the car's motion every five feet at typical racing
> speeds.** This back-of-the-envelope calculation should make us a little
> nervous."*

---

## ⚠️ Finding 2 — thermal throttling degrades physics, not just framerate

`03` and `20` §7 treat thermal throttling as a **performance** problem: the phone
heats, the frame rate drops, the game feels worse.

> **Part 28 shows it is also an accuracy problem.**
>
> When the device throttles, Δt grows. **Integration error grows with Δt.** The
> handling model itself degrades — the car genuinely behaves differently at
> minute twelve than at minute one, independently of how it looks.

**This is a compounding failure the package had not accounted for**, and it is
worse for you than for an arcade racer, because a deep physics model has more to
lose.

### Three mitigations

1. **Use a fixed physics timestep**, decoupled from rendering. Unity's
   `FixedUpdate` already does this — **do not put vehicle physics in `Update`.**
2. **Watch `Time.maximumDeltaTime`.** When a throttled device cannot complete its
   physics steps in budget, Unity clamps, and the simulation slows or spirals
   catching up (`03`). Under Euler that also means unbounded error.
3. **Configurable substeps.** VPP ships *"configurable trade-off between
   simulation precision and CPU usage"* (`02`) precisely for this. **Whatever you
   build on needs the same dial**, and it should be tied to thermal state.

### And it sharpens the prototype test

`31` Part 7's pass condition should be measured **after ten minutes of
continuous play on a warm device**, not on a cold one. If the differential
change is perceptible at minute one and not at minute twelve, you have not
passed.

---

# PART 1c — Parts 1–12, read in full

## Part 1 — Weight Transfer: the actual equation

**Effects of weight transfer are proportional to the height of the CG off the
ground.** Inertia acts through the CG; adhesive forces act at ground level
through the contact patches. The mismatch creates a torque.

```
Lf = dG + Bh/w
Lr = (1 - d)G - Bh/w
```

Where `d` = static weight distribution as a fraction at the front, `G` = weight,
`B` = braking force, `h` = CG height, `w` = wheelbase.

**Worked example:** 3200 lb car, 20" CG height, 100" wheelbase, 1g braking →
`Lf = 2240 lb`, `Lr = 960 lb`. **640 lb transfers forward.**

**Two extensions Beckman gives free:**
- **Acceleration is negative braking force.** Same equation.
- **For cornering, track replaces wheelbase and `d` is always 50%** (ignoring
  driver weight).

Combined braking and cornering — trail braking — is *"much more complicated and
requires some mathematical tricks to derive."*

## Part 2 — Adhesion, and the three tyre sounds

Beckman pushes a 50 lb wheel across his driveway with a bathroom scale. **85 lb
to slide on concrete = 1.70g. 60 lb on linoleum = 1.20g.** Add 40 lb of
dumbbells: 150 lb to slide, **still 1.70g.**

> **The fundamental law of adhesion: the force required to slide a tyre is
> proportional to the weight on it.** `F ≤ μW`.

**But under real driving conditions**, deflection, suspension movement,
temperature and inflation pressure drop a good autocross tyre to about **1.10g.**

### Forgiveness is a design parameter

> *"When one speaks of a 'forgiving' tyre, one means a tyre that breaks away
> slowly as it gets more and more force or less and less weight, giving the
> driver time to correct."*

Old and hard is less forgiving than new and soft. Low-profile less than
high-profile. **Slicks less than road tyres.** Some are so unforgiving they
break away without warning.

**That is a tuning axis you can expose directly** — and it is exactly what your
tyre compound choices should change.

### ⚠️ Finding 3 — the audio spec is in here

> *"Generally, tyres **squeak** when they are nearing the limit, **squeal** at
> the limit, and **squall** over the limit. I find tyre sounds very informative
> and always listen to them while driving."*

**Three distinct sounds mapping to three states of the traction budget.** That is
the instability meter (`20` §1) rendered in audio, and it is how a real driver
reads the limit without instruments.

Part 10 adds the mechanism: individual rubber blocks alternately grip and slide
**thousands of times per second**, and beyond the adhesive limit the squeal drops
to a **lower-frequency squall** as the walking process passes its optimum.

> **Implementation:** three layered loops crossfaded on the same normalised
> traction value that drives the meter, with a pitch drop at the threshold.
> `10` §4 lists tyre screech as one sound. **It is three**, and the transitions
> carry information.

## Part 3 — The launch, as a skill mechanic

Beckman's Corvette: 330 ft-lb engine torque × 3.06 first gear × 3.07 final drive
= **3100 ft-lb at the wheel centre.** Over a 1.08 ft wheel radius = **2870 lb of
available force.**

**But only ~1600 lb sits on the rear tyres at rest.** Ask for 2870 and they
simply spin.

> *"In the very first instant of a launch, your goal as a driver is to get the
> engine up to where it is pushing on the tyre contact patch at about 1600
> pounds. **The tyres will squeal or hiss just a little when you get this
> right.**"*

Then ~320 lb transfers rearward immediately, and you can ask for more. **Within a
second or so you can be at full throttle.**

> **This is a complete launch mechanic with an audio tell.** The player is
> listening for the hiss. Front-drive cars invert it — weight transfer works
> *against* acceleration, so you must be gentler with power.

## Part 4 — a = v²/r, and why "a little too fast" isn't

Cornering acceleration rises as the **square** of velocity.

| Radius | 1.00g | 1.25g |
|---|---|---|
| 50 ft | 27.3 mph | 30.5 mph |
| 100 ft | 38.6 mph | 43.2 mph |
| 200 ft | 54.6 mph | 61.1 mph |

> *"If you go just a little bit too fast, you might as well go much too fast —
> **you're not going to make it.**"*

Between 27 and 30 mph there is *"not much subjective difference... but the
objective difference is usually between making a controlled run and spinning
badly."*

**Beckman's diagnostic, which is also a tutorial event:** drive a circle marked
with cones, increase speed until it slides. **Front breaks away first = natural
understeer. Rear first = natural oversteer.**

## Part 5 — The racing line, with numbers

Three lines through a 75 ft radius, 30 ft wide right-hander:

| Line | Time |
|---|---|
| **m** — the classic geometric line | **3.18 s** |
| i — inside | 4.08 s |
| o — outside | 4.24 s |

**The inside line loses 0.9 seconds in a single corner.** Across widths and radii
tested, line m never lost.

> *"Line m beats line i by 0.16 seconds even on a course that is only four feet
> wider than the car. **You really must 'use up the whole course.'**"*

The ideal-line radius: `k = 3.414(Ro − 0.707Ri)`.

And the reason the real racing line differs: it uses a **late apex**, because you
are accelerating out and therefore need a continuously increasing radius in the
second half.

## Part 6 — Drag, with real numbers

`Fd = ½ Cd A ρ v²`. Air density **0.08 lb/ft³** (0.0025 slugs/ft³). Corvette:
Cd 0.30, frontal area 20 ft².

| Speed | Drag | HP to overcome |
|---|---|---|
| 30 mph | 14.5 lb | 1.2 |
| 60 mph | 58 lb | — |
| 90 mph | 130 lb | 31 |
| 120 mph | 232 lb | 74 |
| 150 mph | 362 lb | **145** |
| 200 mph | 644 lb | **344** |

A 240 hp Corvette spends 145 hp on drag at 150 mph. **200 mph cars usually need
650 hp.**

## Part 9 — A complete straight-line integration model

**`F = Fw − Fd − Fr`** — drive force minus drag minus rolling resistance.

- **Drive force:** `Fw = (TE · R · gk) / (d/2)` — engine torque × final drive ×
  gear ratio, over wheel radius
- **Rolling resistance:** approximately proportional to velocity, `Fr = rr·v`,
  with `rr ≈ 0.696 lb/(ft/sec)`. Beckman flags this as *"probably the weakest
  approximation in the model."*
- **Gear logic:** shift up when engine rpm passes the torque peak (~4200)
- **Integration step:** 0.05 sec

**And the improvement he names but doesn't implement:**

> *"Another important improvement on the logic would be to **check whether the
> wheels are spinning, i.e. that acceleration is less than about ½g, and to 'lift
> off the gas'** in that case."*

**That is traction control, described as a two-line fix.**

## Part 10 — Grip angle (he refuses to call it slip angle)

> *"Most writers call this quantity 'slip angle.' I think this name is misleading
> because it suggests that a tyre works by slipping and sliding. **The truth is
> more complicated. Near maximum loads, the contact patch is partly gripping and
> partly slipping.**"*

> *"**The maximum net force a tyre can yield occurs at the threshold where the
> tyre is still gripping but is just about to give way to total slipping.**"*

**That sentence is your ragged edge**, stated as tyre mechanics.

### Four deformation modes
Radial, circumferential, axial, and — **most important for cornering** —
**torsional**: the difference in axial deflection front-to-back across the
contact patch.

### The definition
**Grip angle = the angular difference between where the wheel points and where
the tyre actually walks.**

- **Understeer = larger grip angles at the front**
- **Oversteer = larger grip angles at the rear**

More grip angle gives more cornering force **up to a point**, then less. A real
tyre *"grips gradually better as cornering force increases, and then gradually
worse as the limit is exceeded."*

## Part 11 — Braking

> **Braking *distance* varies as the square of speed. Braking *time* only rises
> linearly.**

At 1g: 60 mph = 2.74 s / 120 ft. 120 mph = 5.48 s / 482 ft. **150 mph = 6.85 s /
754 ft.**

**The brakes are better than the tyres**, assuming they are not overheated — the
limit is tyre grip, not brake dissipation. Beckman verified this by checking his
numbers against published road tests.

**Brake fade, precisely:** pads and rotors overheat first; continue and the fluid
boils, so **pedal pressure goes into crushing gas bubbles rather than crushing
pads against discs.**

## Part 12 — ⚠️ Finding 4: assists are intention-inference

> *"The very terms 'understeer' and 'oversteer' carry cybernetic implication,
> **for these are terms of intent.**"*

Beckman frames ABS, traction control and ASR as **DWIM — "Do What I Mean"** —
systems that infer the driver's intention and correct the physical inputs
accordingly. Standing on the brake means *"I want to stop,"* not *"I want to
skid."*

**And the correction he specifies for understeer is the one drivers get wrong:**

> A common driver mistake is to add more steering lock. Near the limit, the
> appropriate physical reaction is **weight transfer to the front — trailing
> throttle or a little braking — and *less* steering lock.**

He also splits oversteer into **trailing-throttle oversteer** (add a little
throttle, counter-steer) and **power oversteer** (gently trail off throttle,
counter-steer) — two conditions needing opposite throttle inputs.

> **This reframes `22` Part 4.** The assist stack is not a difficulty slider —
> **each assist is a specific intent-inference with a specific correction.** That
> makes the mentor's job concrete: he teaches you what the assist was doing, then
> you turn it off.

---

# PART 1d — The later articles

Beckman notes in his own introduction that **the first 13 parts were written in
1991 and "contain some very dated ideas."** The later articles are where he stops
working from first principles and engages Milliken, Gillespie, Genta and Carroll
Smith, plus the free simulators RARS, TORCS and Racer.

**They are more useful, not less.**

## Part 14 — Why Smoothness? ⚠️ Finding 5

Beckman answers a question the whole genre asserts without explaining.

> *"One of the 'physically correct' meanings of 'smooth' is **sinusoidal**...
> **Sinusoidal inputs are better because they match the natural response of the
> car!** The suspension and tyres perform, approximately, as **damped harmonic
> oscillators** (DHOs)."*

A step input — his "upside-down-hat" curve — excites the oscillator. A sinusoid
does not. Depending on damping, the response is **critically damped, overdamped,
or underdamped**; in the underdamped case the exponentials oscillate, otherwise
the car *"takes one bounce and settles down."*

**And the frequency — with Beckman's own correction.** He originally wrote ~4 Hz
and admitted it *"seemed too fast to me."* **In the errata to Part 26 he corrects
it:**

> *"Part 14, yet again, the numbers for frequency are actually in **radians per
> second, not cycles per second.** There are 2π cycles per radian, so the 4 Hz
> natural suspension frequency I calculated and then tried to rationalize was
> really **4 / 6.28 Hz**, which is quite reasonable and not requiring any
> rationalization."*

**The natural suspension frequency is roughly 0.64 Hz, not 4 Hz** — about one
oscillation every 1.6 seconds. That is a much slower response, and it changes
the time constant on any input-jerk term you build.

> ### This changes how the instability meter should read input
>
> `20` §1 fills the meter from **how close to the limit** you are. Part 14 says
> that is only half of it.
>
> **The meter should also respond to input *jerkiness* — the rate of change of
> steering, throttle and brake — not just magnitude.** A player making smooth
> sinusoidal inputs stays inside the traction budget. A player making step inputs
> excites a ~4 Hz oscillator and loses grip *at the same cornering load.*
>
> **That is the physical basis for "smooth is fast,"** and it makes the meter
> teach something real rather than just measuring speed.
>
> Implementation: add a term proportional to the derivative of the input vector,
> weighted toward the suspension's natural frequency — **~0.64 Hz, per Beckman's
> own correction above**, not the 4 Hz originally published.

## Part 24 — Combination Slip

> *"**Slip is the input and grip is the output** to our model. Slip comes from
> control inputs on brakes, throttle and wheel; grip comes from reaction forces
> of the ground on the tyres."*

**The problem:** the magic formulae of Parts 21 and 22 apply only to a tyre
generating longitudinal *or* lateral force **in isolation.** Part 7's circle of
traction was the approximation to combined behaviour.

> *"**A tyre cannot deliver maximal longitudinal grip when it's delivering
> lateral grip at the same time**, and vice versa."*

### The implementation insight

Beckman vectorises slip — `L = V + W` — replacing *"the ad hoc, signed
quantities of the old notation."*

There are **eight cases**: two signs for `V`, two for `Re`, and whether `|V|`
exceeds `|Re|`.

> *"The nice thing here is that **we can treat all eight cases the same way** —
> the nature of vector math takes care of it because **the magnitude of a vector
> is always unsigned.** Using signed, scalar quantities, we had to dissect the
> system and introduce absolute values."*

**Use vector slip velocity, not signed scalars, and eight special cases collapse
into one.** That is a direct saving in code and in bugs.

## Part 25 — Combination Grip ⚠️ Finding 6

### The commensurability problem

> *"In the old magic formulae, we measure longitudinal slip as a **percentage of
> unity** — that is, as a percentage of breakaway sliding — and we measure
> lateral slip as an **angle in degrees.** **These are not commensurable.**"*

You cannot combine a percentage and an angle until you put them in the same
units. Once you do, you stitch the two formulae together: use the **combined
magnitude** as the input, then **multiply the outputs by the ratios** of each
component to that magnitude.

### The stability criterion — the most precise statement in the series

> *"If the current, commensurable slip values, s and a, are **inside the central
> 'cup' region, then increasing either component of slip increases grip.** If
> they're **outside, then increasing slip leads to decreasing grip** and the
> driver is in the 'deep kimchee' region of the plot."*

> ### This is the exact threshold your instability meter needs
>
> Not "close to the limit" as a vague normalised value. **A mathematically
> precise boundary:**
>
> | Region | Behaviour | Player experience |
> |---|---|---|
> | **Inside the cup** | More slip → **more** grip | At the limit. Recoverable. Meter filling. |
> | **Outside** | More slip → **less** grip | **Over it.** Correcting makes it worse. Spiral. |
>
> **That is why losing a car feels like falling rather than sliding** — past the
> boundary, the driver's instinct to add input actively reduces grip.
>
> The meter's threshold is not an authored number. **It is the edge of the cup**,
> and it moves with load, surface and tyre compound automatically.

---

## Part 23 — Trail Braking ⚠️ Finding 7

**The technique:** the driver carries braking into the corner, **gradually
trailing off the brakes while winding in the steering.** Because braking
continues in the corner, **its onset can be delayed in the preceding straight.**

### Why it matters more than it looks

> *"When the cars are equalized, as in spec races, showroom stock, or in a lot of
> Solo II classes, **trail braking takes a prominent role.**"*
>
> *"You may be just as fast in the corner, coming out of the corner, down the
> straight. **You may have perfect threshold braking. You may have perfect
> turn-in, apex and track-out points.** But that little extra later braking and
> entry speed will allow the trail-braker to take away several feet every corner.
> **Corner after corner, lap after lap, he will gobble you up.**"*

### The quantification

Beckman attributes a half-second gap over four corners of one course entirely to
trail braking. At 119 fps average, half a second is about 60 feet:

> **One car length per significant corner.**

### This is the Constant

`30` §3.2 specifies a rival who beats you everywhere, in a modest car, with no
counter-build. **Trail braking is his answer** — and it is physically real,
teachable, and invisible until someone names it.

**Three uses:**

1. **The Constant's advantage.** He is not faster in a straight line and his car
   is not better. He brakes later and releases slower, and takes a car length a
   corner. The player can *watch* him do it and not see it.
2. **A late-game lesson from the mentor** (`30` §1.3). One of the last things he
   teaches, and one of the few where he is still ahead of you.
3. **A telemetry callout** (`20` §5): *"You're off the brake before turn-in.
   You're giving away the entry."*

**Implementation note:** this requires combined braking-and-cornering to behave
correctly — which is Part 25's combination grip (`34` Part 1d) and the reason
Part 1 declined to derive the trail-braking equations. **If your tyre model does
combination grip properly, trail braking emerges on its own.** You do not have to
script it; you have to not prevent it.

---

## Part 26 — The Driving Wheel ⚠️ Finding 8: how a dyno actually works

**Directly relevant to the prototype** (`31`). This is the physics of the screen
you are building first.

### The rotational equation of motion

Linear Newton is `F = ma`. Rotational is **`T = Jω̇`** — torque equals moment of
inertia times angular acceleration.

For a solid cylindrical drum, `J = ½mr²`.

### How the dyno computes torque without knowing anything about your car

**The dyno knows `J` for its own drum and measures `ω̇` very accurately.** From
those two it gets the torque applied by the driving wheels.

It knows nothing else — not the wheel radius, not the gear selected, not the
final drive. **It only needs engine RPM**, because wheel RPM is proportional to
drum RPM, and engine RPM relates to wheel RPM through the gearing.

> **`Torque = RPM ratio × J × drum angular acceleration`**
>
> Every term on the right is measured or known by the dyno. **Engine torque is
> recoverable independently of car details.**

### The gotcha — why dyno numbers are always lower

The engine is also spinning up the clutch, transmission, drive shaft,
differential, axles and wheels, whose combined moment of inertia the dyno **does
not know.**

> **This is why chassis dyno numbers are always 15–20% lower than test-stand
> numbers for the same engine** — and why engine sellers quote the test-stand
> figure.

Beckman is blunt about the labelling: **"rear-wheel torque" and "drive-wheel
torque" are well-intentioned misnomers.** What they actually mean is *"engine
torque as if the engine were connected to the drive wheels by a massless
driveline."*

### The worked example
3-foot solid drum, 6,400 lb (200 slugs) → `J ≈ 900 slug-ft²`. Engine run from
1,500 to 6,000 RPM in 15 seconds. Result: **a constant ~335 ft-lb**, implying a
test-stand figure between 394 and 418 at 15–20% driveline loss.

### ⚠️ The artefact worth knowing before you build the screen

> Beckman: *"we have a totally flat torque curve in this little sample, but
> that's only because we have a completely smooth ramp-up of velocity."*

**A perfectly smooth velocity ramp produces a perfectly flat torque curve.** If
your dyno simulation drives the ramp rather than the engine, **you will get a
flat line and think the model works.** Drive it from the torque curve and let the
ramp fall out, not the reverse.

A spreadsheet of his dyno simulation is attached to the article as
`phors26.xls`.

### The other two errata, for completeness
- **Part 24:** *"CP moving slowly forward w.r.t. ground"* should read
  **w.r.t. HUB**
- **Part 21:** an arithmetic slip — `tan⁻¹(SB) − SB` is `0.688 − 0.822 = −0.134`,
  not −0.266

---

## Part 13 — Transients ⚠️ Finding 12: a second physical axis for era differences

**Read in full from the original document, not excerpt.**

### Polar moment of inertia, and why it's the rotational F=ma

Beckman derives it from first principles: summing Newton's second law over every
part of the car as it yaws about the centre of mass gives

> **`T = J·θ̈`** — torque equals polar moment of inertia times angular
> acceleration, the exact rotational analogue of `F = ma`.

Where **`J = Σ mᵢrᵢ²`** — every part's mass times the square of its distance
from the CM, summed. **Squared distance is the operative fact**: moving the
engine a couple of inches toward the CM can measurably cut J, because the effect
scales with the square of the radius, not linearly.

### The design fork this produces

> *"A car with a low PMI is designed so that the heavy parts — primarily the
> engine — are as close to the CM as possible... Choose a car with a low PMI that
> yaws very quickly and give up on some engine power. Or, choose a car with a
> colossal engine and give up on some handling quickness."*

Beckman's own examples: **Lotus Elan, MR2, X1/9** — light, mid-engined, low
PMI, quick to change direction — against **Corvette, Camaro** — heavier, engine
far from centre, high PMI, strong in a straight line but slower to redirect.

> ### Application: your seven hero-car generations already have this axis for free
>
> `32` §7.1 differentiates eras by engine technology and chassis stiffness. **PMI
> gives you a second, independent physical axis**, and it maps naturally onto the
> car's history:
>
> - **Early, big-block generations** (1965, mid-70s) — heavy iron engine well
>   forward of the CM, **high PMI, slow to yaw, dominant on the straight**
> - **Later, lighter-engine generations** (mid-2010s, 2022) — more centralised
>   mass, modern chassis, **lower PMI, faster direction changes**
>
> This isn't decoration — it's the same *"a bigger turbo needs a clutch that can
> hold the torque"* logic from `18` §2.2, one layer up: **engine placement across
> the hero car's sixty years produces a real, felt difference in how the car
> turns**, derivable from mass distribution rather than authored.

---

## Part 15 — Bumps In The Road

### The back-of-envelope method, named and defended

Beckman states the technique explicitly, and it's worth adopting as a house
style for prototyping:

> *"We often make very gross approximations, such as treating the car as a rigid
> body... Even so, the results are often not wildly off the numerical data... If
> the BOE and numerical results are wildly different, then some detective work is
> indicated: one or both of them is probably wrong."*

**A cheap, deliberately-crude estimate is a sanity check on your real simulation
— not a replacement for it, but a way to catch when the real one is wrong.**

### Bump severity, worked

Simple triangular-bump model, shallow case: **vertical acceleration scales as
`v²h/w`** — the square of speed, linear in height, inverse in width. A bump
noticeable at 50 mph is **sixteen times worse at 200 mph.**

Refined model accounting for the actual bump slope:
**`a_v = v²h/(h²+w²)`**. For a *high, narrow* bump (h > w), the formula
inverts and severity *decreases* with height — a result Beckman flags as
counterintuitive and admits the model breaks down there; a proper treatment
needs dynamics (mass, springs, integration), not the BOE approximation.

> **For your street tier** (`08` Part 1), this is the formula that makes kerbs,
> potholes and speed bumps behave correctly at different speeds without a full
> suspension solve — useful as a first-pass approximation before RVP's actual
> raycast suspension takes over.

### ⚠️ Finding 13 — a direct complication of the earlier correction

**This is important, and I'm presenting it honestly rather than silently
picking a number.**

Part 15 was published shortly *after* Part 14 (2000), and closes with Beckman
responding to reader debate over Part 14's 4 Hz suspension-frequency claim —
**the same number the package earlier corrected to 0.64 Hz using Part 26's
later errata** (`34` Part 1c, §1.3).

In Part 15, Beckman does not treat it as a units slip. He defends 4 Hz as
physically plausible for an *extreme* race car, citing a real 1980 Group C
Ferrari he'd just been introduced to: **14,000 lb/in spring rate**, cornering at
**2.7g**, braking at **4g**, riding at **about half an inch** of ground
clearance, and *not* bottoming out. His words:

> *"I would be surprised if its chassis resonance frequency was not on the order
> of 4 Hz or even higher."*

**Part 26's errata — written later, in 2002 — instead says the original number
was a units error**, radians per second mistaken for cycles per second, giving
0.64 Hz.

> ### These are Beckman's own two positions, at two different times, and they
> don't fully agree.
>
> The 2002 correction is chronologically later and mathematically motivated —
> it's a real units bug, not a guess. **But the 2000 defence is empirically
> grounded** in a real, extreme, ground-effect race car, and 4 Hz for *that* car
> is not obviously wrong.
>
> **Resolution for your build: don't trust either number as a universal
> constant.** Ordinary road-going suspension is almost certainly in the sub-1 Hz
> range Part 26 implies. A stiff, low-ride-height aero car — which several of
> your later hero-car generations and rival lineages will be — could genuinely
> sit much higher. **Measure your own suspension's natural frequency from your
> own spring rate and sprung mass**, rather than hard-coding either of
> Beckman's figures into the instability-meter jerk term (`20` §1).

---

## Part 16 — RARS, A Simple Racing Simulator ⚠️ Finding 14: validates the whole toolchain strategy

Beckman's stated reasoning for **not** writing a simulator from scratch:

> *"It would be silly for me to invent the infrastructure for a simulation...
> memory management, windowing, graphics, rendering... programming languages...
> simulation technology: time-stepping, eventing, dynamics solvers... All this,
> while interesting, is not physics."*

He adopts **RARS** (Robot Auto Racing Simulator), public domain, and forks it as
**RARSEP** — "RARS, Enhanced Physics" — modifying only the physics
incrementally while keeping the working infrastructure intact.

> ### This is precisely the strategy this package already recommends
>
> `02` and `04` argue for building on RVP + TORSION rather than writing a
> physics engine from scratch. **A working physicist, in 2002, independently
> reached the same conclusion**: don't rebuild the parts that aren't physics.
> Beckman even name-checks the RARS/TORCS split (`26` in this package) as a
> contemporary he considered and rejected — TORCS was unfinished and Linux-only
> at the time, for *his* situation, just as VPP Community Edition and
> `com.unity.vehicles` are wrong for *yours* (`02`) for different concrete reasons.

### The RARS tire model — the whole thing is one formula

> **`μ(L) = FMAX · L / (K + L)`**
>
> where `L` is the magnitude of a single vector: the contact patch's velocity
> relative to the ground (slip velocity). Force is this coefficient times mass,
> directed opposite to `L`. **One vector in, one force out, one table lookup and
> one interpolation.**

Explicitly listed advantages: *"very simple math, easy to code and debug; very
fast conversion from velocity to force; one table lookup and one
interpolation."* Explicitly listed limitations: no suspension geometry, no
detailed tyre physics, 2D only.

**RARS's planned-enhancement list, from 2002, reads like your spec:**
four wheels, discrete transmission and gear changes, springs and dampers,
aerodynamics, elevation changes, camber, banking, bumps. **You are building what
Beckman was reaching toward twenty-four years ago**, with a tyre and suspension
model (TORSION + RVP) that already clears most of his wish list.

---

## Parts 17–18 — "Slow-in, Fast-out!": a complete, worked racing-line optimiser ⚠️ Finding 15

**The most directly implementable material in the entire series.** Two parts,
one worked example, from geometry through to a search algorithm — and it is a
genuine recipe for AI racing-line generation.

### The setup

650 ft entry straight → 180° hairpin (inner radius 100 ft, outer 200 ft) → 650
ft exit chute. Beckman computes, by hand and then in a spreadsheet, the fastest
way through.

### Part 17 — geometry and the "dummy line" baseline

Two governing formulas for any inscribed cornering radius `r`:

- **Turn-in point:** `h = (r − r0)·cos(α)`
- **Apex angle:** `α = arcsin((r1 − r)/(r − r0))`

> **`α` changes very rapidly near the tightest possible line.** Driving a
> radius just one foot wider than the minimum moves the apex point by **more
> than fifteen degrees.**

Computing exact times for a *"dummy line"* — constant speed through the whole
corner, no unwinding — across radii from 150 to 200 ft:

> **The widest line wins overall**, despite covering more distance in the
> corner itself, because it gains time in three other places: a shorter braking
> zone (higher cornering speed needs less braking), a longer flat-out approach
> (`h` is larger), and — largest gain — **a shorter exit chute**, worth almost a
> full second by itself.

### Part 18 — the actual optimum, with throttle and steering modelled together

Full state-space simulation: position, velocity, tangential and radial
acceleration, integrated step by step, **constrained to stay inside the
traction circle** (`34` Part 1c — this is Part 7's traction budget, used
operationally). Throttle ramps in linearly over a time `k`; the steering wheel
unwinds over a separate time `k_unwind`.

**The key relationship Beckman finds by hand-tweaking:**

> **`k_unwind` should be roughly *twice* `k`** — keep some steering lock on well
> after the throttle is buried, because there is still traction budget left to
> spend on cornering even at increasing throttle.

**Best found: `r = 167.5 ft`, `k = 3.25 s`, `k_unwind = 7.22 s`.** Improvement
over the dummy-line baseline: **0.294 seconds** — which he calls *"very
significant"* and notes would compound further on a longer exit straight.

### ⚠️ The driving lesson, stated as a physical result rather than folklore

> *"This does **not** involve changing the entry to the corner other than by
> slowing down! There is no trail braking or lifting-while-turning or other
> risk-taking going on at corner entry... **to go faster, it is not necessary to
> take risks on corner entry. It is, in fact, both safer and faster just to slow
> down on the entry.**"*

And a second, independent lesson from the same result:

> *"Just driving a better line gives better time **without changing the
> driver's margin for error**"* — i.e. skill (line choice) produced almost
> 0.3 seconds with zero increase in risk, before any trail-braking or
> deeper-entry technique (`23` — the Constant's advantage) is even applied.

### Implementation: a direct recipe for rival AI racing lines

> `04` §1 covers RVP's `FollowAI` and `VehicleWaypoint`, with per-waypoint speed
> percentage as a racing-line profile. **This gives you the actual optimisation
> to generate those waypoints, rather than hand-placing them:**
>
> 1. Parametrise a corner by inscribed radius `r`
> 2. For each `r`, compute exact entry/braking/apex times from Part 17's
>    geometry
> 3. Search over `(r, k, k_unwind)` — Beckman did this by hand; **a simple
>    hill-climb converges quickly** since the search space is small and smooth
> 4. Constrain every step to the traction circle (Part 7 / `20` §1) and the
>    track edges
>
> **Beckman explicitly notes he found this by "seat-of-the-pants" tweaking, not
> algorithmic search**, and expects hill-climbing, genetic search or simulated
> annealing to do better. That is a cheap, well-scoped AI task: turn his
> spreadsheet method into an offline waypoint generator that runs once per track
> at build time, not per frame at runtime.

**Also worth noting for the mentor's dialogue** (`30` §1.3): *"slow in, fast
out"* now has a rigorous physical justification the mentor can state precisely,
rather than as received folklore — and Part 18's own erratum, where Beckman
corrects himself mid-series (*"apex later" should have read "apex earlier"*),
is a small reminder that even the source material contains real mistakes, which
supports the design choice in `30` §1.4 that **the mentor should sometimes be
wrong.**

---

## Part 19 — Space, Time, and Rubber

Elaborates RARS's tyre model (Part 16) and the underlying vector mechanics.

**Galilean vector addition**, explicit and simple: contact-patch-velocity
relative to ground = contact-patch-velocity relative to car, plus
car-velocity relative to ground. *"You eliminate the middleman — the car — by
so doing."* Explicitly not relativistic — racing speeds are far below light
speed, so plain vector addition holds exactly.

**Revisits Part 10's torsional picture** (`34` Part 1c) with more mechanism:
under combined acceleration and steering, the two sides of the contact patch
move at different speeds relative to the ground — the outer side "crabs" around
the corner faster. The tyre carcass twists the patch one way; ground friction
provides a restoring torque, **slightly smaller** in a steady turn, since the
patch is still slowly twisting overall.

**The closing comparison is the honest one to keep:**

> RARS's one-vector model trades detailed tyre physics and suspension dynamics
> for *"very simple math... very fast... one table lookup and one
> interpolation."* Not because detail doesn't matter, but because **a simpler
> model that runs is more valuable than a detailed one that doesn't.**

That is the same trade-off RVP and TORSION already made for you (`04` §1–2),
made independently, by the same author, twenty years apart from his own first
attempt.

---

## Part 29 — A Magical Trick ⚠️ Finding 17: the tyre formula to actually ship

**Possibly the single most directly usable piece of code in the entire series
for a mobile build**, and Beckman wrote it explicitly for this purpose.

### The problem he's solving

The full Magic Formula (Parts 21, 22) is accurate but has real costs for a
simulation programmer: many parameters, an awkward nested structure of
`sin(arctan(...))` terms, and — per Part 22's own admission — most of that
parameter space goes unused because nobody has data to fill it in.

> *"This 'Magic Trick' formula is much easier to code and debug, requires much
> less computing horsepower, and differs by less than 10% almost everywhere from
> Pajecka: **probably sufficiently accurate for gaming simulation.**"*

That is Beckman's own framing, not an inference — he built this specifically
for games.

### The formula

**Three parameters instead of eleven or fifteen:**

```
F_horizontal = B · Fz · α / (1 + |A · α|^P)
```

Where `α` is slip (ratio or angle, either axis), `Fz` is vertical load, and
`(A, B, P)` are the only tunable numbers. One division, one absolute value, one
power. **No trig, no piecewise branches, no `sin(arctan(...))` chain.**

### Fitted against the same Ferrari data as Parts 21–22

Least-squares fit via a brute-force grid search — Beckman calls the method
**"archaeological"**: grid the parameter space, exhaustively evaluate, narrow
the search window, repeat. A completely reusable pattern for fitting any curve
to your own tyre data.

**The fitted result for the longitudinal case:**

> **`(A, B, P) = (9.625, 31.0, 2.375)`**

Compared against the full Pajecka model, the fit differs by **under 800 N
absolute error almost everywhere (roughly <10% of peak force)**, with larger
relative error — up to about 32% — only very close to the origin, where forces
are small and, as Beckman notes, most published models already fall back to a
linear approximation anyway. **In the region that actually matters for racing —
near the force maxima, around 15% slip — the error is well under 10%.**

### Why this is the one to ship, not just the one to know about

> ## Implementation priority
>
> - **Three tunable numbers per tyre compound**, not eleven-to-fifteen. This is
>   the dyno's authoring problem (`31` §6.2) solved directly — three sliders per
>   compound rather than a spreadsheet of magic constants nobody can source real
>   data for (`31` §Finding — the constants are trade secrets).
> - **Cheap enough for every wheel, every physics tick, on a phone.** No
>   transcendental chain, just one power function.
> - **The same fitting method works for your own curves.** Record or author a
>   target curve (from RVP's authored friction curves, or from real tyre test
>   data if you get any), then grid-search `(A, B, P)` against it. Beckman's own
>   code for this is trivial to port — a triple nested loop and a sum of squared
>   errors.
> - **This is very likely the right starting implementation for the dyno
>   prototype** (`20` §4, `31` Part 7) — simpler than porting full Pajecka,
>   physically grounded, and it is the formula Beckman himself recommends for
>   exactly your situation.

The Python reference implementation already in `code/pacejka-reference/`
implements the *full* Magic Formula. **Porting the three-parameter Magical
Trick instead is less work and was explicitly designed to be interchangeable
with it** — same inputs, same shape, one order of magnitude fewer parameters.

---

## Part 27 — Four-Wheel Weight Transfer ⚠️ Finding 16: the formula Part 20 promised

**The last genuine gap in the load model, and it closes exactly the way §
"Part 20" anticipated.**

Beckman states the scope up front — this derivation is **for level ground**,
which he calls *"very common in simulation."* Banked or cambered surfaces need
the fuller elevation/banking treatment implied by the ROAD frames in Part 22.

### The setup

Standard SAE frame (same as Part 22): X forward, Y to driver's right, Z
downward. Four tyre positions defined symbolically from CG height `h`,
front/rear CG-to-axle distances `a, b`, and front/rear half-track widths
`tf, tr`. Beckman works the whole derivation in Mathematica and verifies it
numerically against a real Lamborghini Diablo's published geometry.

### The move that resolves the indeterminacy — confirmed, not guessed

Solving torque equilibrium about the CG gives two equations (X and Y torque = 0;
Z is free, since that's yaw) for **four** unknown vertical loads. Exactly Part
20's problem. Beckman's own resolution:

> *"Posit that cross ratios of weights are equal: that any weight-jacking in the
> car is symmetric."*

**`f1z · f3z = f2z · f4z`** — the diagonal cross-product of the four corner
loads. This is the four-corner generalisation of Part 20's `ad = bc`, and it is
**the same "no artificial weight jacking" assumption**, not a different one.

> ### This confirms the recommendation already in `25` §5
>
> `25` recommended resolving the four-wheel indeterminacy through **spring
> compression** rather than the matrix-pseudoinverse alternative, on the grounds
> that the pseudoinverse *invents* a symmetry rather than deriving one.
> **Beckman's own official resolution uses the derived symmetry condition, not a
> pseudoinverse.** The judgement call in `25` was the physically correct one.

### The closed-form result — directly implementable

Combining the cross-ratio condition with total-force balance (`ΣFz = mg`) and
solving yields clean auxiliary terms:

```
t_ΔF = (b·mg − Fx·h) / 2        (front torque term)
t_ΔR = (a·mg + Fx·h) / 2        (rear torque term)
l̄    = 1 / (a + b)              (inverse wheelbase)
R̄_A  = h·Fy / [h·Fx·(tr − tf) + mg·(a·tr + b·tf)]
```

And the four corner loads, in closed form:

```
F[LF]z = t_ΔF · (l̄ + R̄_A)      F[RF]z = t_ΔF · (l̄ − R̄_A)
F[LR]z = t_ΔR · (l̄ + R̄_A)      F[RR]z = t_ΔR · (l̄ − R̄_A)
```

**Every symbol here is something your simulation already tracks**: sprung mass,
CG height, wheelbase split, track widths, and the current longitudinal/lateral
force demand. Beckman verifies the result by re-substituting into the torque
equations and confirming they vanish, and plots the front-right load falling
smoothly as longitudinal and lateral force increase — exactly the physically
expected behaviour.

> ### Implementation
>
> This is a genuine, closed-form, four-corner static weight-transfer solution —
> not an approximation, not a numeric solve. It is cheap enough to evaluate
> every physics tick if you want a from-first-principles cross-check on
> whatever your suspension-compression method (`25` §5) produces, or to use
> directly if you are not modelling per-corner spring compression at all.
>
> **The `R̄_A` term is your cross-weight / wedge knob** (`25` §5) made explicit:
> it is a single number, driven by track-width asymmetry and the CG's lateral
> position, that redistributes load diagonally exactly as a NASCAR crew's spring
> perch adjustment does.

---

## Part 20 — Four-Point Statics ⚠️ Finding 9: a tuning axis you don't have

### The stability ladder

| Wheels | Stability |
|---|---|
| **One** | Unstable. Falls over from the slightest disturbance |
| **Two** | Fore-aft stable (CG between the contact patches), **left-right unstable** |
| **Three** | **Optimally stable.** Rights itself even after going partly airborne, so long as the CG stays inside the triangle of contact patches |
| **Four** | **Over-determined — see below** |

### Why a tricycle solves and a car doesn't

> **"ANY three points define a plane."**

Three normal forces are uniquely determined by statics. Write the moment balance,
solve the 3×3, done.

**Four wheels breaks it:**

> *"Going to four wheels will cause our equations to break down because there is
> **TOO much symmetry** in the vehicle and blind application of linear algebra
> cannot derive, unambiguously, how the normal forces are to be apportioned among
> the wheels. **Four points cannot lie on a plane unless they are exquisitely
> balanced there.**"*

**Three equations, four unknowns.** The 4×4 matrix has a symbolically vanishing
determinant — which Beckman notes is *"not good for physics, but it is the
interesting mathematical point."*

### ⚠️ And this is why weight jacking exists

> *"Physically, in a four-wheeled vehicle with a suspension, **it is very easy to
> load wheels preferentially by jacking the springs up or down.** NASCAR crews
> are often furiously spinning wrenches above the rear wheel purchases in the
> pits, effectively jacking weight into or out of wheels to adjust handling.
> **In a three-wheeled vehicle, weight jacking is not possible**, to first
> order... Playing around a little with the spring heights on a tricycle will not
> affect the weight on each wheel."*

**Cross-weight — "wedge" — is a real tuning parameter that exists only because
four wheels is statically indeterminate.** It is not in the seven-subsystem spec
(`25` Part 5), and it should be: a per-corner spring-perch adjustment that
redistributes static load diagonally.

### The constraint that resolves it

Beckman closes the system with a symmetry assumption:

> **`ad = bc`** — the ratio of the two rear forces equals the ratio of the two
> front forces, *"expressing the circumstance that we have NOT jacked any weight
> into the car."*

**Deviating from `ad = bc` *is* the wedge.** That single equation is both the
neutral condition and the tuning axis.

The full treatment also elevates the plane by ε and banks it by β, so it handles
cambered and banked surfaces. The solution ends in a quadratic.

> ### Implementation consequence
>
> **Do not try to solve for four wheel loads from statics — it has no unique
> solution.** Resolve the indeterminacy through **spring compression**, which is
> what RVP's per-wheel raycast suspension already does (`04` §1).
>
> That is the physically correct resolution, and it means **weight jacking
> emerges on its own** once you expose per-corner spring perch height.

### Independently confirmed, and a second method

A 2022 robotics paper on wheeled mobile manipulators reaches the identical
conclusion from scratch:

> *"When having only three equations, the challenge in the forces determination
> process is that **there are fewer equations than unknown variables in the case
> of four or more wheels.** It is not seldom that additional reasonable relations
> for connecting the tyre loads are being introduced to obtain the closed-form
> system of equations... **or the solution is found using a matrix
> pseudoinverse.**"*

**Two resolutions, then:**

| Method | Notes |
|---|---|
| **Spring compression** | Physically correct, free with a raycast suspension, and **weight jacking falls out** |
| **Matrix pseudoinverse** | The least-squares solution to the under-determined system. Deterministic and cheap, but it *invents* a symmetry rather than deriving one — you would lose cross-weight as a tuning axis |

**Use spring compression.** The pseudoinverse is worth knowing about as the
fallback if you ever need per-corner loads without a suspension model.

---

## Part 21 — The Magic Formula, longitudinal ⚠️ Finding 11

**With this, the tyre chapter is complete: 21, 22, 24, 25.**

### What the magic formula actually is

> *"This so-called magic formula is **not a solution to equations of motion** — a
> solution in such a form is not feasible. **It's just a convenient fitting of
> commonplace mathematical functions to data.**"*

And later, bluntly: *"don't try to find any physics in here."*

**Why it exists, and why it suits you:**

> *"It allows one to compute forces at a higher precision than something like
> RARS, **but without integrating equations.** Therefore, forces can be computed
> within a reasonable time, **say in a real-time simulation program.**"*

That is the whole case for using it on a phone: **accuracy without an integrator
in the inner loop.**

### No slip means no grip

Beckman spends a page resisting this and then concedes it:

> *"If there is any friction between the tyre and the surface, there **must** be
> slip... **The only way to eliminate slip completely is to eliminate GRIP
> completely. Any grip, and you will have slip.**"*

### Effective radius — the subtlety that catches people

A pneumatic tyre spins **faster** than a rigid wheel of the same *unloaded*
radius, but **slower** than a rigid wheel of the same *loaded* radius — because
the tyre also compresses **circumferentially**, and tread speed varies around the
circumference.

`Re` is the average tangential velocity around the wheel. In practice:

> *"Under ordinary circumstances, the effective radius will be no more than a few
> percent less than the unloaded radius."*

Handy number: a 13-inch-radius tyre turns **~129 RPM per 10 mph**, so a few
percent over that. At 100 mph, something over 1,300 RPM.

### The slip definition

**`σ = (ω·Re / V) − 1`**

| Condition | σ |
|---|---|
| Free rolling | **0** |
| Locked under braking (ω = 0) | **−1** |
| Accelerating | **positive** |

### The eleven constants and the build-up

From Genta's *Motor Vehicle Dynamics*, p.528 — apparently a Ferrari 308/328:
`b₀ = 1.65`, `b₂ = 1688`, `b₄ = 229`, `b₈ = −10`, the rest zero in this sample.
(Beckman notes the "large-saloon" example on the preceding page **has no zeros**
— don't over-fit to this case.)

| Step | Expression | Note |
|---|---|---|
| **p** | `b₁Fz + b₂` | Peak longitudinal friction coefficient, **linear in weight** |
| **D** | `p·Fz` | Linear in Fz, so **p acts as a friction coefficient** |
| **B** | from `B·b₀·D = (b₃Fz² + b₄Fz)·exp(−b₅Fz)` | **Depends only weakly on Fz.** Solve with one Fz divided out — *"convenient especially for numerical computation, where overflow is an ever-present hazard"* |
| **S** | `100σ + b₉Fz + b₁₀` | **Slip in percent** |
| **E** | `b₆Fz² + b₇Fz + b₈` | |

Sanity check he runs by hand: at **10% slip**, a 3,300 N vertical load produces
**4,720 N** of longitudinal force. Coefficient of friction near **1.7** — *"Not
my data, man."*

### ⚠️ The peak, and the third arrival at the same conclusion

> The generated force **peaks at around σ = 0.08 — 8 percent slip.**
>
> *"The peak would be something one could definitely feel in the driver's seat.
> **Overcooking the throttle or brakes would produce a palpable reduction in
> g-forces as the tyres start letting go.** Worse than that, increasing braking
> or throttle beyond the peak leads to reduced grip. **This is an instability
> area, where increasing slip leads to decreasing grip.**"*

**Three independent arrivals at the same finding now:** Part 21 longitudinally
(peak at 8% slip), Part 22 laterally (peak at 4° slip angle), Part 25 in
combination (the cup region). Past the peak, more input gives less grip.

> ### And here is the commensurability problem, concretely
>
> **Longitudinal peaks at 8 *percent*. Lateral peaks at 4 *degrees*.**
>
> That is exactly what Part 25 means by *"these are not commensurable"* — you
> cannot combine a percentage and an angle until you put them in the same units.
> Now you can see the two numbers that have to be reconciled.

Closing note: *"the function behaves roughly linearly with Fz, showing that it
acts like a Newtonian coefficient of friction, **albeit a different one for each
value of slip.**"*

---

## Part 22 — The Magic Formula, lateral ⚠️ Finding 10: the coordinate frames

### The constants

**Fifteen**, from Genta's "possible-Ferrari" data sheet. Beckman prints the full
table (a₀ = 1.799, a₂ = 1688, a₃ = 4140 N, a₄ = 6.026 KN, a₆ = −0.3589 KN,
a₉ = −6.111/1000, a₁₀ = −3.224/100, and the rest zero in this sample).

Peak lateral friction coefficient: **`yp = a₁Fz + a₂`**, then **`D = yp·Fz`** —
which has *"the form of the Newtonian model: normal force times coefficient of
friction."* With a₁ = 0, `yp` behaves exactly as a Newtonian coefficient.

**Camber enters directly**, and the signs matter:

> *"The usual negative camber, by the 'shop' definition, will generate forces in
> the positive Y-direction on the right-hand side of the car and in the negative
> Y-direction on the left-hand side."*

There is also an **additive correction for ply steer and conicity** — the source
of the small lateral force at zero slip (~16 lb) that Part 25 mentions.

### The five coordinate frames — keep this on hand

Beckman follows SAE convention as published in Milliken's *Race Car Vehicle
Dynamics*, and says explicitly this instalment is *"one to keep on hand for
future reference."*

| Frame | Definition |
|---|---|
| **EARTH** {X,Y,Z} | Fixed to the ground. **Z points *downward***, along gravity |
| **CAR** {x,y,z} | Fixed to the sprung mass. x tail→nose, y to driver's right, z downward roof→seat. Its angle to EARTH is the **heading ψ** |
| **PATH** | X along the velocity vector. Its angle to EARTH is **course angle υ** |
| **ROAD**ᵢ (i=1–4) | One per contact patch — **1=LF, 2=RF, 3=LR, 4=RR**. Elevated by ε, banked by β |
| **WHEEL**ᵢ | At the hub. **Does NOT include camber.** Differs from ROADᵢ only by rotation about ROAD's Z — the steering angle δ |

**Vehicle sideslip angle = path heading − car heading.** Positive when the right
side of the car slips in the direction of travel.

**Slip angle** is PATH's X-axis projected onto WHEEL's XY plane, measured against
WHEEL's X axis.

### Two implementation gifts

**The small-angle approximation is good enough.**

> *"Even at 20 degrees, the errors are only about 6% in the cosine and 2% in the
> sin, resulting in a maximum error of 12% in the lower right of the matrix.
> **This matrix approximation is suitable for the majority of applications.**"*

**Orthogonal matrices invert by transposition** — flip about the main diagonal.
No matrix inversion needed anywhere in the frame conversions.

**Note:** contact-patch load `Fz` must be computed **in the WHEEL frame**, and is
smaller than the corner weight by cosine factors of ε and β.

### The curve, and what it means for your instability meter

> These tyres **peak at about 4 degrees of slip**, and cornering force goes
> ***down*** as slip goes up on either side of the peak.
>
> *"On the high side of the peak, we have **dynamic understeer, where turning the
> wheel more makes the situation worse. This is a form of instability in the
> control system of car and driver.**"*

**Same finding as Part 25's cup region** (§ above), arrived at from the lateral
side alone. Past the peak, the driver's instinct actively hurts.

### ⚠️ The limitation to plan around

> *"I am somewhat dismayed that the magic formula does **not** account for any
> variation of the lateral force with speed... the literature states that the
> magic formula doesn't deal with it. One of the reasons is that, experimentally,
> **effects of speed are extremely difficult to separate from effects of
> temperature. A fast-moving tyre becomes a hot tyre very quickly on a test
> rig.**"*

**Pacejka has no speed term.** Combined with its low-speed divergence (Part 3.2
above), that is the full limitation set: **wrong at very low speed, and
speed-blind everywhere else.** If you want tyre behaviour to change with speed or
temperature, you are layering that on yourself.

---

## The series is complete

**All 29 parts of "The Physics of Racing" are now covered in this document,
read from primary sources.**

Twenty-one parts were retrievable by search and automated fetch across the
first two passes. **Parts 13, 15, 16, 17, 18, 19, 27 and 29 — eight
chapters — resisted every automated method**: mirrors that block bots, sites
that disallow crawling, complete-series PDFs that silently truncate mid-way,
and a sandbox egress allowlist that blocks the hosting domains outright.

**All eight closed the same way: the user supplied the original scanned PDFs
directly**, which were OCR'd and read as primary source, six in one batch and
the final two (27 and 29) in a second.

### The actual lesson

These articles were never blocked from being read. **They were never mirrored
anywhere a search engine or crawler could reach them.** Beckman distributed
several of the later instalments as `.doc`/`.djvu` zip files over a private
mailing list rather than as standalone web pages, and those files no longer
exist at their original URLs. No amount of cleverer searching would have found
them, because there was nothing at any reachable URL to find — the retrieval
problem and the existence problem were different problems, and this one turned
out to be the second kind.

**Part 27 in particular was worth the wait**: it delivers the exact closed-form
weight-transfer solution that Part 20 (§ above) established the need for, using
precisely the symmetry assumption already recommended in `25` §5. Part 29
supplies a three-parameter tyre-force formula explicitly written for game
simulation — likely the right starting implementation for the dyno prototype
itself.

---

# PART 2 — Open source to read alongside

| Source | Why |
|---|---|
| **`github.com/topics/car-physics`** | A cluster of projects implementing Beckman's and Monster's maths specifically — several tagged `pacejka`, `slip-angle`, `slip-ratio`, `brian-beckman`. **Reading working code alongside the theory is faster than either alone.** |
| **Offroad engine** (SourceForge) | Custom car physics using the Pacejka model, full source |
| **TORCS**, **Racer** | Both cited in PhoRS. Older, open, readable |
| **VDrift** | Already covered in `26`. C++, discontinued, but the tyre code is instructive |
| **TLabVehiclePhysics** (`04` §2) | MIT, Unity, Pacejka with LUT authoring tools |

---

# PART 3 — Three gotchas that will save you real time

## 3.1 Do not compute weight transfer directly

From the same GameDev thread, and **this validates RVP's design:**

> *"Weight transfer is one thing that's quite important, but you don't have to
> calculate it directly. It **comes automatically** when you have a proper
> suspension and/or tire simulation. Simply said, **you can get the tire load
> from the compression of the suspension.**"*

> **RVP already does this.** Its `compression friction factor` (`04` §1) is load
> sensitivity derived from suspension travel.
>
> If you had bolted on a separate weight-transfer system — which is the obvious
> thing to do after reading Monster — **you would have double-counted it**, and
> the resulting handling would have felt wrong in a way that is very hard to
> diagnose.

## 3.2 Pacejka diverges at low speed

**A real bug you would otherwise ship.** Per the Pacejka literature:

> *"A problem with Pacejka's model is that when implemented into computer code,
> **it doesn't work for low speeds** (from around pit-entry speed), because a
> velocity term in the denominator makes the formula diverge."*

Solving the Magic curve at high frequency is also problematic, because **slip
velocity — the difference between car velocity and tyre velocity at the contact
point — changes very quickly.**

> **This applies to you directly.** TLabVehiclePhysics (`04` §2) uses Pacejka. If
> you graft its tyre model onto TORSION's drivetrain, **you will hit this in the
> pit lane and in the garage** — precisely where your player spends the most
> time.
>
> Plan a low-speed blend or clamp from the start.

**The alternative worth knowing:** brush tyre models, which can be analytically
derived. They still need empirical curve fitting for good correlation and tend to
be less accurate than Magic Formula models — but they do not diverge.

## 3.3 The magic constants are secret

> *"Tyre manufacturers are very secretive about the values of these constants for
> actual tyres."* — Monster

So Pacejka is an accurate model with no available data. **This is why
TLabVehiclePhysics ships a LUT system with editor tooling for authoring the
curves by hand**, and why RVP uses authored friction curves rather than a
parameterised model.

**Practical consequence:** you will be hand-authoring tyre behaviour either way.
The question is whether your tool for doing it is any good — which is a `31`
(dyno) problem, not a physics problem.

---

# PART 4 — Reading order

Roughly two evenings, and it changes how you read every line of RVP.

| # | What | Why now |
|---|---|---|
| **1** | **Beckman, Parts 1–5** | Weight transfer and the basics. Before anything else. |
| **2** | **Monster**, one sitting | The longitudinal/lateral framing. Note §1.2's caveat. |
| **3** | **Beckman, Part 21** | The Magic Formula, when you reach the tyre model |
| **4** | **RVP's manual** (`04` §1) | Now that you know what its curves approximate |
| **5** | **VPP block docs** | How a professional package structures a drivetrain |

**Do this before the RVP triage afternoon**, not after. The triage asks "does
this still feel good?" — and that question is much easier to answer when you know
what the model is trying to do.

---

# Cross-references
- RVP's tyre and suspension model → `04` §1
- TLabVehiclePhysics and Pacejka LUTs → `04` §2
- TORSION's drivetrain architecture → `04` §2, `code/TORSION-MIT/`
- Vehicle physics options and what to rule out → `02`
- The dyno, and authoring tyre curves → `31`
- Upgrade dependencies falling out of physics → `18` §2.2, `20` §2
