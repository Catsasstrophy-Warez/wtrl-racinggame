# Raven KR — Concept Extension: Interior, Engine Bay, Detail Views

Extends `RavenKR-Original-Design-Target-v1.png` (exterior 4-view, approved
target) with the views it doesn't cover. Written 2026-09-04.

**No image-generation tool is available in this session**, so this is
written art direction, not new renders — grounded in (a) what the game's own
code actually requires from each view, and (b) real reference builds from
the same design lineage the concept sheet is already drawing from. Hand this
to whoever renders or models next; it's meant to be specific enough to work
from directly.

## Reference family

The exterior sheet reads as a widebody '67–'70 Mustang-fastback restomod —
long hood, fastback roofline, bronze wheels, vertical-slat grille. That's not
a vague genre, it's a specific real build tradition: Ringbrothers' Mustang
restomod line is the closest visual family, and two of their builds map
almost directly onto this concept's material language:

- **"Copperback"** (1967 fastback) — the bronze/copper accent treatment the
  concept's wheels and trim are already speaking. Engine: 427ci V8, Tremec
  5-speed, Currie 9-inch rear. Interior: black-and-brown leather, Recaro
  buckets, 4-point harnesses — dark, performance-focused, not showy.
- **"Kingpin"** (1969 Mach 1) — the aggressive widebody stance and "final
  boss" attitude that matches this chassis's 78-in width and 40mm rear-track
  bias.

Use these as the material/mood reference, not as something to copy a badge
or panel from — the three-change rule from `12-DERIVATION-METHOD.md` still
governs actual modeling, same as the exterior.

Sources: [Copperback build details](https://www.motorious.com/articles/news/1967-mustang-ringbrothers/) · [Kingpin coverage](https://www.motor1.com/news/777825/ringbrothers-kingpin-mustang-sema/) · [Ringbrothers widebody kit reference](https://www.ringbrothers.com/1965-1966-widebody-mustang-kit-in-carbon-fiber)

---

## 1. Engine bay

This isn't just a visual — it's a functional requirement. `EngineBayMeshManager.cs`
is built around **swappable tagged part meshes**: a `PartMeshEntry` list keyed
by `partTag`, merged for normal rendering and split apart during the
installation sequence (`PrepareForInstallationSequence()`,
`OnPartReplaced(partTag, newMesh)`). That means the engine bay can't be one
sealed sculpt — it has to be **built as distinct, individually-modeled
components** that the system can hide/show/replace independently:

- Engine block + heads (the part that changes per era/tune)
- Intake manifold / turbo or supercharger assembly (swappable — forced
  induction is a real upgrade path per `40-FORCED-INDUCTION-DRIVETRAIN.md`)
- Radiator + shroud
- Firewall / bulkhead (the fixed backdrop everything else mounts to)
- Brackets, hoses, wiring loom (can be lower-detail "hero clutter" — real
  bays read as complex partly from secondary detail, not just the big parts)

**Material direction:** satin black bulkhead and ancillary brackets (matches
the exterior's `Satin Black` material already named in the placeholder
script), brushed/burnished bronze on anything that would visually reward
attention when the bonnet's open — coil covers, strut brace, a fabricated
intake — echoing the wheel/trim bronze from the exterior sheet exactly the
way Copperback uses copper accents against a dark engine.

**Player-facing requirement:** this bay is seen constantly — it's the garage
home-screen feature (bonnet opens, part goes on, damage stays visible). It
needs to read clearly at both a distant "car on the lift" framing and a close
"part being installed" framing, which argues for bold primary shapes
(manifold, turbo, strut brace) over fussy micro-detail that only reads in a
render.

## 2. Interior / cockpit

Lower priority than the engine bay (players see it less — no first-person
cockpit view is specified anywhere in `05-specifications/`), but the garage
and driver-progression systems (`DriverProgression.cs`, license grade) imply
at least a static cockpit view exists somewhere in the UI.

**Direction:** dark, functional, not showy — matching Copperback's black/brown
leather over flash. Bucket seats (Recaro-style, not bench), visible harness
mounting if the fiction supports a track-oriented late-generation car, bronze
accent on shift surround / gauge bezels only — a thin thread of the exterior's
material language, not a repaint of the whole cabin. Keep the dash simple:
this car spans 1965–2022 in the full lineage, so whatever cockpit language
gets established here needs to plausibly re-skin across eras (analog gauges
early, a driver display late) without a full rebuild each time.

## 3. Front detail (grille, lamps)

The exterior sheet already specifies this at 4-view scale but the project's
own gate check flags it as **not yet validated by eye** — the blockout
passed "Gate 5 — Front grammar" vacuously because no detail existed to
check. Zoomed in, the concept shows: full-width vertical-slat grille (blacked
out, no visible mesh texture at this resolution), inset round lamps
recessed into the corners rather than surface-mounted, a thin bronze splitter
lip. Whoever models this needs to decide slat count/spacing and lamp housing
depth at real scale — those are exactly the kind of decisions that look fine
in a 4-view thumbnail and read as flat or cluttered at 1:1 in-engine, which
is the same failure mode the current procedural body already has.

## 4. Rear detail (lamps, diffuser, badge)

Same gate-check gap on the rear ("Gate 6 — vacuous pass"). Concept shows
full-width lamp bar with three vertical light blades per side (not a single
strip), a bronze trim line running the width of the decklid above the lamps,
and diffuser-style lower fascia with vertical fins. No badge/lettering is
visible in the concept at this resolution — worth deciding deliberately
rather than defaulting to a generic script badge, since `32-HERO-CAR.md`
Part 6 flags that badges/marque names are exactly the trademark-sensitive
element in this whole derivation exercise.

---

## What this doesn't solve

This is written direction, not art. It gets you a brief an artist (or a
future image-gen-capable session) can work from without guessing, but the
actual interior/engine-bay/detail renders still need to be made — either as
part of the commissioning brief already sent (`RAVEN-KR-ART-BRIEF.md`), or
as a separate concept pass if you want these visualized before committing to
a full commission.
