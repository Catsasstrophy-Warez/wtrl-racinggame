# iPhone-Specific: Haptics and ProMotion

**Why this document exists.** `26-MOBILE-LANDSCAPE.md` covers fifty racing
games on gameplay, monetisation, and positioning terms. **It does not cover
what's specifically true of the iPhone as a piece of hardware** — the two
things below were researched to fill that gap, and both turned out to map
directly onto systems already specified rather than requiring new ones.

---

# PART 1 — Core Haptics

## 1.1 The platform fact that matters most

**Haptics work on iPhone. They do not work on iPad** — Apple's own Core
Haptics documentation notes some devices, iPads specifically, don't support
haptic feedback at all.

> Given this project is iPhone-first with Android planned "eventually"
> (`33` §2, `03`) and iPad is not in scope anywhere in this package, **that
> is not a gap to work around — it's confirmation that the core platform
> gets the full feature for free.** No fallback logic needed for the
> primary target.

## 1.2 Apple's own worked example is a wall collision

Apple's WWDC introduction to Core Haptics demonstrates the API with a ball
bouncing off the edges of a screen, where **haptic intensity and audio
volume scale together with impact force** — the harder the hit, the more
intense the haptic and the louder the sound, synchronised.

**That is not analogous to a barrier or wall contact in this game. It is
one, described by Apple as their own reference case.**

## 1.3 Two event types, mapped onto systems already specified

| Type | Apple's description | Where it already fits in this design |
|---|---|---|
| **Transient** | Brief, tap-like sensations | Wall contact, curb strikes, gear shifts, the torque-wrench click in the installation sequence (`25` Part 6), the launch hiss moment (`34` Part 1c, Part 3) |
| **Continuous** | Sustained vibration, intensity and sharpness controllable in real time | **The instability meter's fill level** (`20` §1) |

### ⚠️ The one that matters most: the instability meter should have a haptic layer

`20` §1 and `11` §2.3 already drive a visual gauge and, per `10` §4, a
three-tyre-sound audio crossfade (squeak → squeal → squall) from the same
normalised fill value every physics tick.

> **That same value should also drive a continuous Core Haptics pattern —
> intensity and sharpness tied to fill level, exactly as Apple's own API is
> designed for.**
>
> **Update**: the audio half of this pairing is now real code
> (`code/prototype/EngineAudio.cs`'s `TyreAudioCrossfade`, reading the same
> `fillLevel01` value). The haptics half is not, and can't be from pure
> Unity C# — `CHHapticEngine` has no Unity equivalent and needs a native
> iOS plugin bridge. Stated directly rather than left implied by the audio
> side being done.
>
> On a phone with no force feedback, **a rising buzz under the thumb as the
> limit approaches may be a stronger signal than anything visual** — the
> player feels the car getting light before the meter's fill is
> consciously registered. This is the single highest-value addition in this
> document, and it costs nothing new to compute: the value already exists.

## 1.4 The debounce warning — already a known pattern in this design

Apple's own guidance, stated plainly in developer material on the framework:
**"a haptic per render is a buzzing brick."** Firing a haptic every physics
tick produces noise, not signal — events must be debounced on genuine state
change.

> **This is not a new principle for this project.** `20` §1's oversteer
> trigger (`|a_y − v·ψ̇| > ε`) already fires once on threshold crossing, not
> continuously, for exactly this reason. **The same discipline needs to
> extend to haptics specifically** when implementing the continuous
> fill-level pattern above — update the pattern's parameters smoothly, but
> don't re-trigger the underlying event every frame.

## 1.5 AHAP files — surface-specific haptics for near-zero extra cost

Core Haptics patterns can be authored declaratively as **AHAP files**,
separate from code — the haptic equivalent of an audio asset.

> **Surface-specific haptic patterns** (tarmac vs. gravel vs. wet, matching
> the surface-specific audio already specified in `10`) could be authored
> alongside the existing audio work rather than requiring a second content
> pipeline. Same asset-authoring motion, different output format.

## 1.6 One architectural note

`CHHapticEngine` is not a singleton — an app may run multiple instances.
**Worth keeping the persistent "engine rumble" / continuous instability
pattern on a separate engine instance from transient impact events**, so a
wall hit doesn't interrupt or restart the ongoing continuous pattern.

---

# PART 2 — ProMotion and the pass condition

## 2.1 Refresh rate and touch sampling rate are not the same thing

Easy to conflate, and worth being precise about:

- **Touch sampling rate**: how often the screen checks for a touch.
  **Every iPhone since the iPhone X (2017) samples at 120Hz**, regardless
  of display refresh rate.
- **Display refresh rate (ProMotion)**: how often the screen redraws.
  **120Hz is Pro-tier only, from the iPhone 13 Pro onward.**

**Real device fragmentation exists here**, and it's finer-grained than the
Android split already documented in `03` — it exists *within* the iPhone
lineup itself, between Pro and non-Pro models.

## 2.2 The number that actually matters

At 120Hz, one frame is **8ms**. At 60Hz, one frame is **16ms** — confirmed
directly from Apple's own developer materials. That's a real, measurable
difference in how quickly an input can be reflected on screen, not a
marketing figure.

## 2.3 ⚠️ The finding that changes what "pass" means

> **The dyno prototype's pass condition** (`31` Part 7, restated in `11`
> §2.1/§2.3): *"the player feels it through tilt."*
>
> **This may not have a single yes/no answer.** A differential change that
> is imperceptible at 16ms of input latency may become perceptible at 8ms
> — same physics, same tuning change, different result, purely from
> device tier.

**This is a genuinely new risk this package did not have on file before
this research.** It connects directly to `03`'s existing device-
fragmentation discussion, which until now was framed entirely around
Android — this shows the same category of risk exists within iOS alone.

### What follows for the test itself

`31` Part 7's pass condition should be run on **both a Pro-tier ProMotion
device and a base-tier 60Hz device**, not just "an iPhone." If the
differential change passes on Pro-tier and fails on base-tier, that is not
a failed test — it's a real finding requiring one of:

- A stronger differential effect (tuning the physics, not the test)
- An input-resolution compensation for 60Hz devices specifically (`22`)
- Accepting a device-tier floor for the "full feel" of the tuning system,
  the same way `03`'s Android section already accepts a quality-tier split

## 2.4 One thing to verify, not assume

Historical developer reports (iPhone 13 Pro era) describe **third-party
apps not automatically receiving full 120Hz animation** — ProMotion
appeared reliably for scrolling and screen transitions, but not
consistently for arbitrary in-app animation, without the developer
explicitly requesting it.

> **Do not assume 120fps is free once `CADisplayLink`'s preferred frame
> rate range is requested.** Verify actual achieved frame timing on a
> real Pro-tier device — this is exactly the kind of assumption `31`
> Part 7 and `34`'s thermal findings already warn against trusting without
> measurement.

---

# Cross-references
- Instability meter and its existing audio/visual outputs → `20` §1, `10` §4
- The debounce principle, already established → `20` §1 (oversteer trigger)
- Installation sequence audio cues → `25` Part 6
- Input design and touch handling → `22`
- Device fragmentation, previously Android-only → `03`
- The dyno pass condition → `31` Part 7, `11` §2.1/§2.3
- Thermal measurement discipline (the same "verify, don't assume" pattern) → `34` Part 1c, Finding 2
