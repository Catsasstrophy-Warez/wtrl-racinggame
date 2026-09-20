# Audio Design Specification

**Nothing here is extracted audio.** This is the architecture for building your
own engine sound system, plus the full SFX inventory and legal sourcing.

**Engine sound is the emotional core of a racing game.** It is also the single
most technically involved audio system you will build. Budget for it properly.

---

## 1. The fundamental choice: loops vs. granular

There are two established methods for interactive engine audio.

### Crossfaded loops
Multiple fixed-RPM loops that crossfade as revs change, with pitch-shifting

**Now implemented** — `code/prototype/EngineAudio.cs`. Checked directly beforehand: `EngineVariant.acousticTextureTag` existed as a field nothing read. It reads now.
between them.

- **Pros:** works everywhere, fully predictable CPU cost, no middleware
  dependency beyond FMOD/Wwise
- **Cons:** large amounts of editing work to find loop points and tune
  pitch-shifting for clean transitions; pitch-shifting quality degrades when
  the real-time algorithm is simplified for CPU budget, so you need *more*
  loops to compensate

### Granular synthesis
Spectral analysis of recordings with additive interpolated synthesis of grains.

- **Pros:** computationally efficient at runtime; you only specify a crossfade
  length from idle into the RPM range and the granular engine handles the rest;
  **it blends on-throttle and off-throttle automatically from throttle data**
- **Cons:** requires middleware

### **Your decision — and a critical platform caveat**

**AudioMotors FMOD**, the leading adaptive granular option, lists platforms as
Windows / macOS / PS4 / PS5 / Xbox One / Xbox Series / Switch. **iOS and Android
are not listed.**

**Verify mobile support before designing around any granular solution.** If it
is unavailable, you are on crossfaded loops — plan the recording session
accordingly, because the loop count is much higher.

---

## 2. Crossfaded loop architecture (assume this)

### 2.1 Recording plan

The reference production spec is **13 loops per engine perspective**, across
**4 perspectives**:

| Perspective | Use |
|---|---|
| Intake | Layered for induction character |
| Engine | Core body of the sound |
| Exhaust | Exterior/chase camera emphasis |
| Interior | Cockpit camera |

**13 × 4 = 52 loops per vehicle — and that is full-throttle only.**

**Mobile reality:** you almost certainly cannot ship 52 loops per car across a
roster. Realistic reduction:
- **2 perspectives** (Exhaust + Interior), not 4
- **7–9 RPM loops** per perspective, not 13
- Accept more pitch-shifting between loops
- **Target ~16–20 loops per vehicle**

This is also the strongest argument in this package for a **small car roster**
(see `09-ASSET-PRODUCTION.md` §1). Every car is both weeks of modelling and a
full audio session.

**For the hero car's seven generations specifically**, `37-FORD-V8-AUDIO.md`
finds only one real acoustic family transition across all seven — most
generations can share core engine loops with era-specific texture layered
on top (mechanical lope, EFI smoothness, emissions muffling, tonal EQ
shift) rather than requiring seven full 16–20-loop builds from scratch.
Read that document before budgeting engine audio per generation — it maps
directly onto the era table in `32-HERO-CAR.md` §7.1.

### 2.2 Naming loops correctly

Do not name loops by rounded RPM. Compute the actual RPM:

```
Loop Fundamental Frequency × 60 ÷ number_of_cylinders × 2 = exact RPM
```

Name the file after that result. Your crossfade points depend on accurate RPM
values, and rounded names will misalign them.

### 2.3 The pitch curve rule

**All loops must use the same pitch curve**, or they detune relative to each
other at crossfade points and the engine sounds wrong in a way that is hard to
diagnose.

- **FMOD:** use the **Autopitch** feature
- **Wwise:** use a **Smart Pitch Curve** over a Blend Container

### 2.4 Crossfade density

**No more than two waveforms should cover any given RPM range.** Three
overlapping loops muddies the sound and wastes voices.

---

## 3. FMOD implementation

### 3.1 Event setup
Delete the Timeline sheet. Create **two Parameter sheets**:

1. **RPM** — range matching your engine's idle-to-redline
2. **Load** — the parameter that makes the engine sound like it is *working*

### 3.2 The Load parameter — the thing most indie games miss

Load is what separates a convincing engine from a pitch-shifted drone.

**Compute it as a function of the rate of change of RPM.** That alone is
generally sufficient. Optionally blend in an external load value from the
physics engine, which matters in cases where **RPM stays constant but the engine
is working harder** — climbing a gradient, for instance.

**You have TORSION's drivetrain** (`code/TORSION-MIT/`). `Engine.cs` already
exposes torque output, inertia, and friction losses, and the drivetrain uses
`GetDownstreamTorque()` / `GetUpstreamAngularVelocity()`. **Derive Load from
actual drivetrain torque rather than approximating it.** That is a genuine
advantage of building on a real physics model, and it costs you almost nothing.

### 3.3 Off-throttle

Off-throttle loops are difficult to generate for technical reasons, and most
indie projects skip recording them.

**Workaround without off-throttle loops:** apply real-time DSP and volume
automation to the on-throttle loops, driven by throttle state. A low-pass filter
plus a volume dip on lift, with overrun pops layered as one-shots, gets you
most of the way.

---

## 4. Full SFX inventory

### Engine and drivetrain
- Starter motor, idle, RPM loop set (§2.1), rev limiter, engine off
- Turbo spool, blow-off valve, wastegate
- Overrun pops and crackles (one-shots on lift)
- Gear shift: mechanical clunk, whine per gear, clutch engage/disengage
  (TORSION models clutch slip — drive shift audio from `Clutch.cs` state)
- Differential whine under load
- Engine damage: misfire, knock, rod knock at high damage

### Tyres and surface
- Tyre roll loop **per surface type** (tarmac, concrete, gravel, dirt, wet, grass)
- **Three limit sounds, not one** (`34` Part 1c, Beckman Part 2):
  **squeak** approaching the limit → **squeal** at the limit → **squall** over
  it, the last at *lower frequency* as the grip/slide cycle passes its optimum.
  Crossfade all three on the same normalised traction value that drives the
  instability meter (`20` §1), with a pitch drop at the threshold.
  **This is how a real driver reads the limit without instruments** — and on a
  phone, where there is no force feedback, it may carry more information than
  the visual meter does.
- **Pair every one of the three with a Core Haptics event, not just audio**
  (`36` Part 1). Apple's own reference case for the framework is impact
  force scaling audio and haptic intensity together — the same normalised
  traction value already drives the audio crossfade above; extend it to a
  continuous haptic pattern on the same debounce discipline as the
  oversteer trigger (`20` §1). Haptics work on iPhone, not iPad — no
  fallback needed for this project's primary platform.
- **A launch hiss.** Beckman: at a correct launch *"the tyres will squeal or hiss
  just a little."* An audio tell for a skill mechanic (`34` Part 1c, Part 3).
- Skid/screech, layered by slip angle magnitude
- Surface transition impacts (kerb strikes, rumble strips)
- Puncture/blowout

RVP's `GroundSurfaceMaster` already carries per-surface tyre and rim sounds —
see `04-EXTRACTION-INVENTORY.md`.

### Impacts and damage
- Collision set by severity (light scrape / medium / heavy), 4–5 variants each
- Panel deformation, part detachment, glass break
- Rim scrape, undercarriage scrape, barrier and cone impacts

### Environment
- Wind by speed, rain on body, tunnel reverb transitions
- Crowd (pro tier), pit-lane ambience, garage room tone
- Track-side pass-by doppler for opponents

### UI and garage
- Menu navigation, purchase confirm, upgrade install, tool sounds (impact
  wrench, ratchet, hoist), car reveal sting, race start lights, checkered flag

### Voice
- Pit radio / engineer callouts (a small set of lines carries enormous
  atmosphere at the pro tier — see `07-INFLUENCE-MAP.md` §1.7 on *Le Mans*)

---

## 5. Mobile audio constraints

- **Voice count.** Every opponent car running a full engine event is expensive.
  **Cull aggressively by distance** — run simplified single-loop events for
  distant opponents and full multi-layer events only for the player and the
  1–2 nearest cars.
- **Memory.** Compressed in memory for loops; streaming for music and long
  ambiences. Engine loops must be decompressed and resident — they cannot
  stream.
- **Format.** Vorbis for most content; ADPCM for short, frequently triggered
  one-shots where decode cost matters more than size.
- **Mixing for phone speakers.** Most players will use the built-in speaker,
  which has effectively no low end. **Mix a phone-speaker check pass** — if the
  engine reads as thin and buzzy there, add midrange body rather than bass.
- **Silence is free.** Ducking non-essential layers during heavy scenes buys
  both CPU and clarity.

---

## 6. Legal sourcing

### Recording your own
**The best route for engine audio**, and more achievable than it sounds. A
friend's car, a decent handheld recorder, a quiet industrial estate, and a
static rev sweep session gets you a usable loop set. Record intake, exhaust, and
interior separately if you can, and always record more RPM steps than you think
you need.

### Free libraries
- **Freesound.org** — 600,000+ samples under mixed Creative Commons licenses.
  **Filter by CC0** for no-strings use. Quality and licensing vary per upload,
  so check each file individually.
- **Kenney** (kenney.nl) — CC0 audio alongside the art
- **OpenGameArt** — CC0/CC-BY/GPL mix

### Commercial libraries
- **BOOM Library** — the reference vehicle sound libraries; royalty-free,
  commercial use permitted, redistribution of raw files forbidden
- **A Sound Effect**, **Soundly** — general SFX

### Tools
- **Reaper** ($60) — recording, editing, loop point work
- **FMOD Studio** — free under $200k revenue
- **Audacity** — free, adequate for cleanup

### Attribution
Log every CC-BY sample in `ATTRIBUTIONS.md` as you import it. See
`09-ASSET-PRODUCTION.md` §6 — RVP's audio folder mixes CC0, CC-BY, and CC
Sampling Plus in one directory, which is exactly the mess this avoids.
