# Asset Production Specification

**Nothing here is extracted content.** These are production targets and legal
sourcing routes for building or commissioning your own assets. Figures are
2026 industry ranges — validate against your own profiling on target hardware.

---

## 1. The hard reality check, first

**A single game-ready hero car — high-poly, low-poly, UVs, baked maps, PBR
textures, LODs, and engine integration — takes a senior vehicle artist 4–8
weeks.** Stylized or simplified cars ship in 2–3 weeks. Studios running
specialists in parallel finish 2–4 cars per artist per month.

Do the arithmetic before you design your car list. **Thirty cars is not a
content plan for a solo developer; it is several years.**

### Practical consequences
- **Start with 5–8 cars, not 30.** A tight roster with deep tuning beats a
  large roster with shallow tuning, and it matches your sim positioning.
- **Build a shared library of rim styles and tyre profiles** rather than
  modelling wheels per car. This is standard practice when a game features
  multiple trims and it saves enormous time.
- **Kitbash and re-trim.** One well-built chassis can yield several variants
  through body kits, which is also a gameplay feature.
- **Consider commissioning.** At 4–8 weeks each, outsourcing 3–4 hero cars may
  be cheaper than your own time.

---

## 2. Polygon budgets

### Scene-level ceiling (2026 hardware)
- **Mid-range devices:** 300k–500k triangles on-screen at 60fps once shaders and
  lighting are reasonable
- **Flagship (recent iPhone Pro):** past 1M triangles in optimised scenes

**Budget for mid-range and sustained frame rate, not flagship and first lap.**

### Per-asset targets

| Asset | LOD0 triangles | Notes |
|---|---|---|
| **Player / hero car** | 25,000–40,000 | Industry game-ready cars run 15k–50k total across LODs. Sim hero cars hit 80k–200k but that is console/PC. |
| **Opponent car (close)** | 15,000–20,000 | Same asset, LOD1 |
| **Opponent car (mid-field)** | 5,000–8,000 | LOD2 |
| **Traffic / background vehicle** | 5,000–10,000 | Shared atlas textures |
| **Wheel + tyre (shared library)** | 2,000–4,000 | Reused across the roster |
| **Track environment tile / building** | 500–2,000 | |
| **Distant environment tile** | 100–300 | |
| **Prop (barrier, cone, sign, tyre stack)** | 100–500 | |
| **Garage scene hero prop** | 1,000–3,000 | Garage is a controlled scene, spend a little more |
| **UI mesh / 3D icon** | 100–800 | |

### LOD policy
**Ship at least three LOD levels** for anything that leaves the near frustum:
100% / 50% / 20%.

With a full grid of opponents, LOD is not optional — it is the difference
between shipping and not. Build LOD-friendly topology from the start: even edge
loops and clean quads reduce far more cleanly than dense triangulated meshes.

**Avoid n-gons.** Engines triangulate them unpredictably, and you lose control
of the result.

---

## 3. Textures

### Resolution
- **Mobile target: 1K–2K with simplified materials.** PC/console hero cars use
  4K; you do not have that budget.
- Car body: 2K albedo, 2K normal, 1K ORM (occlusion/roughness/metallic packed)
- Wheels/tyres: 1K, shared across roster
- Environment: trim sheets at 2K, shared across many props
- Props: atlas multiple props onto one 1K–2K sheet

### Compression
**ASTC** for iOS. Set per-texture, do not leave defaults. Uncompressed textures
are the most common cause of oversized iOS builds and of memory pressure that
triggers thermal issues.

### Channel packing
Pack occlusion, roughness, and metallic into one RGB texture. **Every texture
sampler costs on a tile-based GPU.** Fewer, denser textures beat more, sparser
ones.

### The key principle
> Polygon count affects silhouette and performance. Surface detail comes from
> baked textures.

A 200-triangle prop with a well-baked normal map beats a 2,000-triangle prop
with flat materials. Spend triangles on silhouette; spend texels on detail.

---

## 4. Asset list — what you actually need

### Vehicles (start here, expand later)
- 5–8 hero cars across the career tiers
- Shared wheel library: 8–12 rim styles, 3–4 tyre profiles
- Body kit variants: splitters, wings, diffusers, bonnets, bumpers per car
- Engine bay geometry (visible if you build any mechanic-facing screen)
- Damage variants or deformation-ready topology (see RVP's `VehicleDamage` in
  `04-EXTRACTION-INVENTORY.md`)

### Environments
- **Street tier:** 2–3 industrial/urban layouts, reusable modular pieces
- **Club tier:** 2–3 small circuits
- **Pro tier:** 2–3 full circuits
- Garage interior (hero scene — spend here)
- Property progression: house, garage, pro shop, warehouse exteriors/interiors

### VFX
Tyre smoke, dust, sparks, brake glow, exhaust heat haze, rain, headlight
cones, skid marks (RVP's `TireMarkCreate` covers the last one).

**Watch overdraw on all of these.** See `08-ART-DIRECTION.md` §3.

### UI
Gauges, telemetry graphs, tuning sliders, garage/shop screens, map, results
screens, career progression views.

---

## 5. Legal sourcing routes

### License tiers — know these cold

| License | Commercial use | Attribution | Notes |
|---|---|---|---|
| **CC0** | Yes | No | Public domain. Safest. Prefer this. |
| **CC-BY** | Yes | **Required** | Credit in a credits screen. Track every asset. |
| **CC-BY-SA** | Yes | Required | Your modified version must also be CC-BY-SA. Risky for game art. |
| **CC-BY-NC** | **NO** | — | Cannot be used in a game you sell. |
| **Editorial only** | **NO** | — | Cannot be used in a game you sell. |
| **Royalty-free marketplace** | Yes | Usually no | But you may not redistribute the raw files. |

### CC0 sources (safest — commercial, no attribution)
- **Kenney** (kenney.nl) — 40,000+ assets, all CC0, no signup. 3D, 2D, UI, fonts, audio.
- **Quaternius** — CC0 models, many animated
- **KayKit** — CC0
- **Poly Haven** — CC0 HDRIs, textures, models. Your HDRI source for the garage scene.
- **ambientCG** (formerly CC0Textures) — 2,000+ PBR materials and HDRIs, up to 8K, all CC0. Full map sets: albedo, normal, roughness, metallic, height, AO.
- **CGBookcase** — CC0 PBR textures, smaller but high quality

### Mixed-license sources (check every asset individually)
- **Fab** (Epic) — permanently free Megascans starter pack of 1,500+ scanned
  assets, surfaces and decals, usable in any engine, plus a rotating free drop
  every two weeks. Note the full ~17,000-asset Megascans catalog went paid on
  31 Dec 2024.
- **Sketchfab** — the paid Store closed and moved to Fab, but free and
  downloadable models remain available in 2026. Filter by license.
- **Poly Pizza** — 10,600+ free models including the archived Poly by Google
  collection (~2,294 models). Mostly CC-BY, some CC0.
- **Icosa Gallery** — non-profit continuation of the Poly mission, with an API
- **OpenGameArt** — CC0/CC-BY/GPL mix, deep but poorly searchable
- **BlenderKit** — free and paid side by side, filter for the free tier

### The gap: cars
**There is no good CC0 source for quality car models.** This is the hardest
sourcing problem in your project, and it is why §1's build-time arithmetic
matters. Realistic routes:

1. **Model them yourself in Blender** (free, slow, and you control everything)
2. **Commission 3–4 hero cars** and build variants from them yourself
3. **Buy Asset Store car packs** — royalty-free, commercial use permitted, but
   you may not redistribute the raw files, and other games will use the same cars
4. **Design original vehicles.** No licensing question at all, and it sidesteps
   the trademark issue below entirely.

### Trademark warning on real cars
Car manufacturers hold trademarks on body shapes, badges, and model names.
Licensed racing games pay for that. **Do not model a recognisable real car and
ship it commercially without a licence.** Design originals, or design cars that
evoke a class ("90s rear-drive coupe") without reproducing a specific model.

---

## 6. Attribution hygiene

**Maintain an `ATTRIBUTIONS.md` in your project from the first asset you
import.** Record for every asset: name, source URL, license, license URL, and
what you modified.

This is not optional paperwork. CC-BY assets require it, and reconstructing it
eighteen months later from memory is impossible. See the RVP audio situation in
`01-LICENSING.md` — a mix of CC0, CC-BY, and CC Sampling Plus in a single folder
is exactly the problem this prevents.

Ship the file as an in-game credits screen.
