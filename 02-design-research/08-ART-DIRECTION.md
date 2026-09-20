# Art Direction Brief

**What this is.** A visual direction for *your* game, derived from analysis of
the references in `05`–`07`. Nothing here is copied art. The references informed
the principles; the execution is yours to build or commission.

---

## 1. The premise governs everything

Mechanic -> weekend street racer -> professional track driver. That arc has a
**visual arc built into it**, and it is your strongest art-direction asset.
Most racing games look the same from first race to last. Yours should not.

| Act | Setting | Light | Palette | Surfaces |
|---|---|---|---|---|
| **Street** | Industrial edges, underpasses, empty lots, docks | Sodium vapour, headlights, wet asphalt reflection | Amber/orange, deep cyan shadow, high contrast | Wet, grimy, patched tarmac |
| **Club / regional** | Small circuits, paddocks, tyre walls | Overcast daylight, flat | Desaturated greens, weathered concrete, faded sponsor red | Dry, worn, rubbered-in racing line |
| **Professional** | Real circuits, grandstands, pit lane | Hard midday sun or floodlit night | Clean white, deep shadow, saturated liveries | Smooth, precise, high-grip |

**The reward for progression is legibility.** Street racing should feel visually
noisy and hard to read — that *is* part of the difficulty. Professional circuits
should feel clean, wide, and calm. The player earns clarity.

---

## 2. The three principles worth keeping from the references

From `05-DESIGN-REFERENCE.md` Part 3, restated as production rules:

### 2.1 The garage is a shrine, not a menu
The car is the hero object of the screen. Lit deliberately, framed
three-quarter, rotatable, with real reflections. The player will spend more time
here than in any single race.

**Implementation:** a dedicated garage scene with its own lighting rig and a
reflection probe. Do not render the car against a UI panel background. Budget
for this scene properly — it carries the emotional weight of the whole
progression system.

### 2.2 Every upgrade must read visually
If a player spends money and the car looks identical, the money felt wasted.

**Minimum visible changes:** ride height, wheel/tyre, exhaust tip, intercooler
or intake, brake caliper size and colour, aero (splitter, wing, diffuser), roll
cage, seat, bonnet vents.

**Not visible, so compensate in UI:** differential, gearbox internals, ECU,
suspension damping. These need a strong telemetry or spec-sheet readout so the
spend still registers.

**A cheap dynamic detail worth having, if budget allows: ride height is not
static under load.** OptimumG's jacking-force finding (`35` §1.1) means real
cars visibly rise or squat mid-corner from the tyre-force imbalance between
inside and outside wheels, on top of whatever static rake the player set.
Even a crude version — nudging chassis height by a millimetre or two, driven
by current lateral load — reads as "this car is really being pushed into the
road" without needing the full jacking-force simulation. Low cost, real
physical basis, and it makes the static ride-height slider feel like it's
interacting with something alive rather than just repositioning a mesh.

### 2.3 Wear is narrative
Stone chips, brake dust, tyre marbles, a repaired panel in primer. Your
protagonist is a mechanic — a car that shows its history tells that story with
no dialogue.

**Design decision:** make "restore to showroom" a deliberate, costed player
choice. A battle-scarred car should be a badge, not neglect.

---

## 3. Mobile rendering constraints that shape the look

These are not suggestions. They determine what art direction is even possible.

- **URP, forward renderer.** Deferred is not viable on this hardware class.
- **Baked lighting for static geometry.** One real-time directional light for
  the sun plus the car's own lights. Every additional real-time light is a
  per-pixel cost on a tile-based GPU.
- **Reflection probes, not real-time reflections.** Bake per-track cubemaps.
  Car paint reads convincingly from a good cubemap and a decent clearcoat
  shader; screen-space reflections are not affordable.
- **Overdraw is the enemy.** Transparent particles (tyre smoke, dust, sparks),
  transparent UI over the 3D scene, and layered decals all cost fill rate on a
  tile-based deferred GPU. This is the number one cause of thermal throttling
  in a racing game. See `03-PLATFORM-NOTES.md`.
- **Fog is your friend.** Cheap, hides draw distance, and does real atmospheric
  work — especially for the night street tier.
- **Vertex colours over extra texture samplers.** Every sampler costs.

### The thermal reality
> A scene that hits 60fps for thirty seconds and then throttles to 40fps for the
> next four minutes is a scene you have to trim.

That is the governing art-direction constraint on mobile. It means: build for
the *sustained* frame rate after ten minutes of play, not the first lap.

---

## 4. Art direction that is cheap and art direction that is expensive

**Cheap and high-impact — spend here:**
- Strong, limited palette per act
- Good HDRI-driven ambient and a well-tuned clearcoat car shader
- Wet-road reflection (a single well-made shader carries the whole night tier)
- Fog, bloom, and a restrained colour grade per act
- Trim sheets for environment geometry (one material, many props)
- Silhouette-driven track design — landmarks readable at a glance

**Expensive — avoid or defer:**
- Real-time global illumination
- High-density crowds
- Destructible environments
- Per-track bespoke prop sets
- Dynamic weather with wet-surface transitions (looks incredible, costs enormously)
- Interior cockpit views for every car (each is a second full model)

---

## 5. Reference-gathering direction

Do **not** reference other games' art for the look. Reference reality:

- **Street tier:** night automotive photography, sodium-lit industrial areas,
  wet asphalt, Japanese and Southern California car meet photography
- **Club tier:** club racing paddocks, club motorsport photography, weathered
  regional circuits
- **Professional tier:** contemporary GT and endurance racing photography,
  pit-lane and garage documentary work
- **Garage:** real independent workshops — tool walls, fluorescent tubes, oil
  stains, engine hoists. Not showroom detailing bays.

For camera and shot language, `07-INFLUENCE-MAP.md` §1.6 lists films worth
studying — but for *composition and camera*, not for palette.

---

## 6. UI direction

The UI is the tuning system's entire interface, so it carries more weight here
than in an arcade racer.

- **Diegetic where possible.** Gauges, a clipboard, a workshop whiteboard, a
  laptop on a toolbox. Fits the mechanic premise and avoids generic mobile
  game chrome.
- **Data-dense but progressive.** A player at the street tier should not see a
  differential preload slider. Reveal tuning depth as the career opens it.
- **Telemetry must be readable at a glance on a phone.** Prefer curves and bars
  over numeric tables. See `07-INFLUENCE-MAP.md` §1.1 on post-race telemetry
  that names the problem in plain language.
- **Touch targets sized for thumbs at speed.** Anything the player uses mid-race
  needs to work without looking at it.
