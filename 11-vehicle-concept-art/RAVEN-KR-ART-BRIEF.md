# Raven KR — Hero Car Art Path

Two things, both grounded in what's actually in the repo right now: whether a
marketplace kitbash/re-trim fits the existing chassis, and a ready-to-send
brief for a commissioned artist. Written 2026-09-04.

**Headline finding: the target design already exists.** There's a concept
sheet at `Assets/Concepts/RavenKR/RavenKR-Original-Design-Target-v1.png` —
full four-view (front 3/4, rear 3/4, side, top), rendered, finished — that
nobody has been building toward. The in-engine geometry doesn't resemble it
at all. Whoever does this next doesn't need to invent a design; they need to
model *this* one. That changes both paths below from "figure out what the car
should be" to "get this specific, already-approved design built properly."

---

## Part 1 — Kitbash / re-trim feasibility

The hardpoints are locked in code (`Assets/Editor/RavenKrBodyProfile.cs`) and
independently validated by the project's own gate checks
(`Builds/BodyReview/clay-silhouette-acceptance.md`, `clay-stance-check.md`).
Any sourced base mesh has to hit these:

| Hardpoint | Metric | Imperial |
|---|---|---|
| Wheelbase | 2.743 m | 108.0 in |
| Front track | 1.54 m | 60.6 in |
| Rear track | 1.58 m | 62.2 in (40 mm wider than front — deliberate) |
| Overall length | 4.68 m | 184.3 in |
| Overall width | 1.98 m | 78.0 in |
| Roof crown height | 1.30 m | 51.2 in |
| Front overhang | 1.01 m | 39.7 in |
| Rear overhang | 0.93 m | 36.6 in |
| Wheel + tyre radius | 0.355 m | ~14 in (≈28 in diameter) |
| Arch gap (all 4 corners, settled) | 48–52 mm | — |

Read against the concept art, this is a **widebody 1969–70 Mustang-fastback
silhouette** — long hood, short deck, fastback roofline, no vertical
B-pillar — pushed to muscle-car-restomod width (78 in is significantly wider
than a stock car in this class; a stock '69 Mustang is ~71 in). That's a
real, identifiable category: this is the same silhouette family as
Ringbrothers/Detroit Speed-style widebody restomod builds, and the concept
art's bronze wheels and vertical-slat grille read straight out of that world.

**What this means for sourcing:** a generic "muscle car" or "retro coupe"
marketplace asset (Unity Asset Store, TurboSquid, CGTrader) with roughly
correct proportions is workable as a *starting* mesh, but it will need real
surgery, not just a re-skin — this body is 7+ inches wider than most stock
donor proportions, which means the whole flank, wheel arches, and shoulder
line have to be pushed out and re-surfaced, not just retextured. That's most
of the labor a from-scratch model would take anyway. A kitbash only saves
real time if you can find a donor that's *already* a widebody muscle
fastback — those exist but are less common than stock-body assets, and you'd
be paying for whatever license tier allows modification and commercial use.

**The legal constraint carries over regardless of source.** `12-DERIVATION-METHOD.md`'s
three-change rule (line 188) — at least three defining characteristics
altered from any specific real car — applies to a purchased base mesh
exactly as it applies to an original model. A donor asset that's itself an
unlicensed digital recreation of a specific real production car (a common
thing on asset marketplaces) doesn't insulate you from a trademark/trade-dress
claim; it just moves the problem. Whatever base you use still needs to run
through `templates/derivation-worksheet.md` like every other generation in
this lineage.

**Recommendation:** kitbash is worth a scouted pass (I can search asset stores
for widebody fastback donors if you want a shortlist), but budget it as
*reduced* labor, not *skipped* labor — probably 40–60% of a from-scratch
model's time, concentrated in re-surfacing the body rather than UVs/rigging/
materials, which a decent donor mesh gets you for free. If nothing suitable
turns up, commissioning from the concept art (Part 2) is the direct path.

---

## Part 2 — Commissioning brief

Ready to send to a freelance vehicle artist as-is.

### Project
*Wrench2Legend* — a mobile driving-simulation career game. Real vehicle
dynamics (Pacejka tyre model, full drivetrain simulation), wrapped in a
mechanic-to-driver career. The hero car is a single lineage the player
restores and rebuilds across seven eras (1965 → 2022); this brief covers
**the 2022 flagship generation only** — the fully-realised, present-day
version — per the project's own staging guidance in `32-HERO-CAR.md` §7.1
("ship the first three or four generations and add the rest"). Codename:
**Raven KR**.

### Reference
Attached: `RavenKR-Original-Design-Target-v1.png` — the approved design
target, four-view. Model to this. It is not a mood board; it is the spec.

### Hardpoints (non-negotiable — the physics rig, tests, and gate checks
are already built against these exact numbers)
Same table as Part 1 above. Wheelbase 2.743 m, front track 1.54 m, rear track
1.58 m, overall 4.68 m × 1.98 m × 1.30 m, wheel/tyre radius 0.355 m, arch gap
48–52 mm at the settled ride height. Origin/ground convention: chassis
reference sits 0.42 m above the ground plane in the rig's local frame.

### Silhouette gates already validated on the blockout — hit these on the
final model too
- Hood : deck length ratio ≥ 1.80:1 (blockout hit 2.51:1)
- Roof crown ≤ 1.320 m above ground
- Rear track 20–60 mm wider than front (locked at 40 mm)
- Continuous fastback roofline, no vertical B-pillar
- Front/rear detail (grille, lamps, diffuser, badging) is **not yet
  validated by eye** — the blockout passed those gates vacuously (no detail
  existed to check). This is exactly the area the concept art specifies and
  the current in-engine geometry gets wrong, so give it real attention.

### Technical deliverable spec
- **Topology:** clean quads, even edge loops, LOD-friendly from the base
  mesh — not a dense triangulated sculpt retopo'd once and called done.
- **Poly budget:** LOD0 25,000–40,000 triangles (per this project's own
  `09-ASSET-PRODUCTION.md` budget for a hero car). LOD1/LOD2 for mid-field
  opponent use if the same asset gets reused there.
- **UVs + PBR textures**, baked maps (normal, AO, etc.) — standard game-ready
  set, not a raw high-poly.
- **Engine bay geometry included** — this project has a garage/dyno feature
  where the bonnet opens and the engine bay is visible; the current
  `EngineBayMeshManager.cs` system expects a real bay to populate, not a
  sealed shell.
- **Damage-ready topology** is a plus, not a hard requirement for this pass —
  the project has a `MechanicalDamageModel` system already; panel-level
  deformation readiness would save a later pass but shouldn't block delivery.
- **Export format:** FBX. Existing project convention is
  `Assets/Vehicles/RavenKR/Models/RavenKR_PhotoMatched.fbx` — replace that
  asset in place (or hand it back for us to drop in) so the existing
  materials/tune/prefab wiring (`RavenKR_ActiveTune.asset`,
  `RavenKR_FirstDrive.prefab`) keeps working without rework.
- **Materials:** the concept shows gunmetal body paint, bronze/brushed-bronze
  wheels and brightwork trim, smoked glass, deep-red taillight lenses — match
  this palette; it's already load-bearing (referenced in the current
  placeholder script's material names).

### Timeline
Per this project's own research (`09-ASSET-PRODUCTION.md`): **4–8 weeks** for
a full game-ready hero car at senior-artist quality (high-poly, low-poly,
UVs, baked maps, PBR, LODs, engine integration). A simplified/stylized pass
that still reads correctly could land in 2–3 weeks — worth asking a
candidate artist to quote both.

### What NOT to do
Don't treat the concept art's Mustang-fastback lineage as license to trace a
real Mustang. The project's legal method (`12-DERIVATION-METHOD.md`) requires
at least three defining characteristics changed from any specific real
production car — the concept art was presumably already built with this in
mind, so matching *it* should keep you compliant, but flag anything that
reads as a 1:1 copy of a real badge, grille signature, or taillight design
rather than the concept's own interpretation.

---

## Suggested next step

Want me to (a) search asset marketplaces for widebody-fastback kitbash
candidates against these exact hardpoints, or (b) just get this brief in
front of a freelancer and treat the current procedural geometry purely as a
physics/gameplay placeholder in the meantime? Either is workable; they're not
mutually exclusive.
