# Input Design and Control Schemes

**Why this document exists.** Twenty-one prior documents covered physics,
progression, economy, art, audio, licensing, and cameras. **Input got a few
paragraphs.** For a touchscreen game whose entire differentiator is depth, that
is the most dangerous gap in the package.

---

# PART 0 — The problem, stated sharply

> **Your differentiator is tuning depth. Input resolution is what makes tuning
> depth perceptible.**

If a player cannot feel the difference between two differential settings because
the steering input is too coarse to express it, **the premise collapses — and it
collapses silently**, presenting as *"the parts don't do anything."*

That is precisely the criticism levelled at Porsche Unleashed (`19` §1.4), at
the Mustang game (`13` §1.3), and at Driver: San Francisco's roster (`21` §6.4).
Three games, three decades, same complaint. **Two of them had the depth and lost
it at the input layer.**

Input is not a polish task. It determines whether the rest of this package was
worth anything.

---

# PART 1 — The evidence base

There is real HCI research here, and it is counterintuitive.

## 1.1 Tilt outperforms touch

**"Tilt or Touch? An Evaluation of Steering Control of Racing Game on Tablet or
Smartphone."** 36 subjects, three interfaces — accelerometer, simulated buttons,
finger gestures — each simulated 15 times on the same circuit.

| Finding | Result |
|---|---|
| Fatal collisions | **Tilt produced 30% fewer** than touch |
| Race completion | **Touch players finished 12 seconds slower** on average |
| Preference | **Accelerometer preferred**, and best-performing |

## 1.2 But tilt for *orientation* is bad

MacKenzie's **Tilt-Touch Synergy** work refines this crucially:

- **Tilt-based orientation hinders navigation** — participants struggled with
  environment collisions and motion paths
- **Tilt-based movement works well** — comparable to a marble-maze mapping,
  where the player rolls in the desired direction
- **Tilt + Touch is the best arrangement** for schemes needing additional
  virtual face buttons

## 1.3 Two structural advantages of tilt

1. **It does not occlude the view.** Virtual controls cover the screen; tilt
   does not.
2. **It frees both thumbs** for face buttons, and works in tandem with them.

And the insight worth underlining:

> Tilt, like touch, offers no tactile feedback — but **it may instead leverage
> proprioception**, which helps compensate for the absence of tactile feedback
> that touch control is noted for lacking.

Your body knows where your hands are. A finger on flat glass does not.

## 1.4 The recommended refinement

The research suggests **nonlinear tilt gain — "tilt acceleration"** — modelled
on the pointer-acceleration transfer functions used in desktop OS UIs.

> **You already have this.** RVP's `MobileInput` / `MobileInputGet` ships
> accelerometer steering with separate steer and flip factors **and a delta
> factor for rate-of-change** (`04`). That delta factor is essentially the
> nonlinear mapping the literature recommends. It is sitting unused in an MIT
> package you already have.

---

# PART 2 — The canonical taxonomy

F1 Mobile Racing ships six configurations that map the entire design space:

| Config | Steering | Throttle / brake |
|---|---|---|
| 1 | Tilt | Auto-accelerate |
| 2 | Tilt | Manual — brake left, accelerate right |
| 3 | Left/right buttons | Auto-accelerate, brake centre |
| 4 | Virtual wheel (left) | Auto-accelerate, brake right |
| 5 | Virtual wheel (right) | Mirrored |
| 6 | Virtual wheel (right) | Manual, pedals left |

Assetto Corsa Mobile offers the same three steering families — tilt, on-screen
wheel, left/right buttons — with limited Bluetooth controller support.

**Two observations:**

- **Every scheme has a handedness mirror.** Configs 4 and 5 are identical except
  for which side the wheel sits. This is not optional.
- **Auto-acceleration appears in half of them**, because holding throttle
  occupies a thumb that has better uses on a touchscreen.

## Practical settings guidance
- Sensitivity default around **50%**, adjustable
- **A small deadzone** to prevent accidental steering drift
- **Recalibration** available and prompted at session start
- **Screen orientation lock**

---

# PART 3 — What the corpus teaches about input

## 3.1 Driver (1999) — the traction vocabulary

**Most games give one drift button. Driver gave four ways to break traction with
different costs.**

| Button | Function |
|---|---|
| X | Accelerate |
| Square | Brake / reverse |
| Triangle | Handbrake — locks the rear |
| Circle | Burnout — breaks traction under power |
| **L1** | **Locks steering to the direction pressed** |

And the tactical distinction from the speedrunning community: **burnout turns
faster than handbrake at low speed, because the handbrake scrubs more speed.**

> **Depth at the input layer, not just the physics layer.** RVP's separate
> forward and sideways friction curves with a `slip dependence` setting already
> support this — handbrake-induced slip and throttle-induced slip should cost
> different amounts of speed.

**The failure from the same game:** handbrake on Triangle sat too far from
accelerate on X for inputs meant to be combined. **Button adjacency matters when
inputs are pressed together.** On glass, thumb reach is the equivalent.

## 3.2 Driver: San Francisco — the axis-overload failure

**Boost was mapped to pushing up on the left analog stick — the stick already
carrying steering.** A reviewer reported triggering it constantly by accident
from ordinary cornering input. Remappable, which is the only reason it survived.

> **On a touchscreen this is worse.** No detents, no return spring, no
> proprioceptive centre. **Any control sharing space with steering will
> misfire.** This is the single most portable warning in the corpus.

**The success from the same game: Rapid Shift** — one button that jumps to an
ally *or* cancels a pending shift and snaps back, context-dependent. **One
input, two functions, chosen by situation.** Under a mobile button budget of
roughly three, this is the pattern to reach for.

## 3.3 Top Gear (1992) — scarcity as input design

**Three nitros per race, non-replenishing.** A binary button made interesting
entirely by scarcity. The cheapest depth available to any control scheme.

## 3.4 Burnout — the input economy

Boost is **earned** through risky driving and **spent** on a trigger. The same
input has an income side and an expenditure side, which makes pressing it a
decision rather than a reflex.

## 3.5 NFS Shift — input as the progression signal

Precision and Aggression were **inferred from how the player drove**, not chosen
in a menu. The control scheme *was* the character sheet.

**And the documented failure:** racing-line points outweighed every dirty move,
so a driver who constantly bumped and spun opponents still trended Precision
(`19` §2.9).

> **If you infer anything from inputs, weight the axes against each other and
> test with a deliberately terrible driver.**

## 3.6 Real Racing 3 — the honest compromise

**Deliberately simplified handling model, designed for touch from the start.**
Assists limited to automatic steering, automatic braking, and traction control.

> **This is the trade you must make consciously.** RR3 simplified the physics to
> fit the input. **You are proposing the opposite** — deep physics through a
> constrained input. That can work, but only if the input scheme is doing real
> work.

## 3.7 F1 Mobile and Gear.Club — the middle ground

Braking, steering, and stability assists. The common mobile settlement.

## 3.8 Motorsport Manager — the zero-input answer

No driving input at all. Depth delivered entirely through strategy, and it
succeeded on mobile. Worth knowing the option exists.

---

## Touch sampling vs. display refresh — worth knowing before tuning sensitivity

Added after ProMotion-specific research (`36` Part 2). **Every iPhone since
the iPhone X (2017) samples touch at 120Hz**, regardless of display refresh
rate — this is separate from ProMotion (120Hz screen *redraw*), which is
Pro-tier only. Sensitivity and deadzone tuning (Part 2 above) should assume
120Hz *input* sampling is available broadly, even on devices that render at
60Hz — the touch data arrives faster than it may be reflected on screen.

**And the harder fact**: rendered frame latency genuinely differs by device
tier — 8ms at 120Hz vs. 16ms at 60Hz. This is why `31` Part 7's pass
condition now specifies testing on both tiers (`36` §2.3) rather than
trusting a single device's result.

# PART 4 — The assist stack is your difficulty system

> ## Reframed: each assist is an intent-inference, not a difficulty step
>
> Beckman (`34` Part 1c, Part 12): *"The very terms 'understeer' and 'oversteer'
> carry cybernetic implication, **for these are terms of intent.**"* ABS,
> traction control and ASR are **DWIM — "Do What I Mean"** systems. Standing on
> the brake means *"I want to stop,"* not *"I want to skid."*
>
> **Each assist has a specific correction**, and the understeer one is the
> opposite of player instinct: not more steering lock, but **weight transfer to
> the front — trailing throttle or light braking — and *less* lock.** Oversteer
> splits further into trailing-throttle (add throttle, counter-steer) and power
> oversteer (trail off throttle, counter-steer) — **opposite throttle inputs for
> superficially similar situations.**
>
> **This makes the mentor's job concrete** (`30` §1.3): he names what the assist
> was doing for you, then you turn it off. Removing an assist is a lesson, not a
> difficulty increment.
>
> Beckman also notes traction control as a two-line fix in his own straight-line
> model: *"check whether the wheels are spinning, i.e. that acceleration is less
> than about ½g, and lift off the gas."*


On console, assists are an accessibility layer. **On mobile, assists are how you
reconcile deep physics with coarse input** — which makes them a progression axis
rather than a settings menu.

Roughly ordered by how much they hide:

```
auto-brake → auto-steer → stability control → traction control
→ ABS → racing line → rewind
```

## Tie them to your career tiers

| Tier | Assists |
|---|---|
| **Street** | On by default, never mentioned |
| **Club** | Removed one at a time, each removal teaching what that system was doing |
| **Professional** | Bare, and the player has learned why |

> This converts your largest technical constraint into your **difficulty curve,
> your tutorial, and your progression** simultaneously.
>
> It also gives assist toggles diegetic meaning: **these are real driver aids,
> and they are already in your tuning list** (`11` §2.2). Turning off traction
> control is both a difficulty setting and a setup decision.

---

# PART 5 — Recommended scheme

**Steering: tilt, with nonlinear gain.** The research supports it, it does not
occlude the screen, it frees both thumbs, and RVP's delta factor already
implements the curve. **Ship virtual wheel and button variants as options — never
as the only choice, and always with a handedness mirror.**

**Throttle: auto-accelerate by default, manual as an option.** Frees a thumb for
the traction vocabulary.

**Right thumb: brake. Left thumb: handbrake. Nothing else in the steering zone.**

**Build a real traction vocabulary** (§3.1). Handbrake slip and throttle slip
scrub different amounts of speed, so the choice is a decision. **This is where
physics depth becomes felt rather than merely simulated.**

**Context-dependent buttons** (§3.2). One input, multiple functions by
situation. Your budget is roughly three.

**Ship a calibration and sensitivity screen.** Non-negotiable for tilt.

---

# PART 6 — The test that matters

Build the dyno prototype from `20` §4. Then **change one differential setting
and see whether a player can feel it through tilt, at 60fps, on a phone.**

If they can, everything else in this package is worth building.

If they cannot, **the input scheme needs work before any more content does** —
and you will have learned that in a fortnight rather than after eighteen months
of car production.

---

# Cross-references
- The prototype → `20` §4, Part 5
- Driver's control scheme in full → `21` Parts 2–4, §6.2
- RVP's `MobileInput` / `MobileInputGet` → `04`
- Unity's `UIMobileInput.cs` → `04` §3
- Cars must differ on more than one axis → `13` §1.3, `19` §1.4, `21` §6.4
- Instability meter → `06` §1.2, `20` §1
- Dual rating axes must be weighted → `19` §2.9, `20` §11
