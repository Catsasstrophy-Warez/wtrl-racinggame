# W2RL1.01 Art Reference Register

The ten supplied images are preserved under `W2RL1.01-ArtReferences/Provided/` as reference-only material. They are not production meshes, texture sources, or proof of asset ownership.

## Usage

- `W2RL1-Reference-01.jpg`: canonical roster board; use for catalog/UI information architecture and lineage grouping.
- `W2RL1-Reference-02.jpg`: living garage concept; use for modular wall displays, parts archive, lighting, and service-bay composition.
- `W2RL1-Reference-03.jpg`: living garage variant; use for vehicle display plinths, lineage archive walls, and parts visualization.
- `W2RL1-Reference-04.jpg`: duplicate composition of Reference 03; retain as source evidence, do not duplicate as a separate design target.
- `W2RL1-Reference-05.jpg`: master lineage data map; use for garage UI data-wall treatment and catalog navigation.
- `W2RL1-Reference-06.jpg`: broad racing-history reference board; use only for mood, era segmentation, and genre taxonomy.
- `W2RL1-Reference-07.jpg`: racing-game genre board; use for track/event category inspiration, not direct asset copying.
- `W2RL1-Reference-08.jpg`: street-racing/open-road reference board; use for pursuit lighting, road atmosphere, and event mood.
- `W2RL1-Reference-09.jpg`: mobile garage comparison board; use for touch-friendly garage layout, card density, and presentation hierarchy.
- `W2RL1-Reference-10.jpg`: mobile racing category board; use for platform UI research and broad genre taxonomy.

## Art direction extracted

The game should use a dark technical workshop presentation with cool cyan interface accents, warm vehicle paint highlights, modular display bays, lineage/era navigation, visible mechanical assemblies, and a clear separation between inspection data and race presentation. The garage should feel like a living archive that changes as generations, parts, damage, and reputation progress.

## Vehicle-art rules

Create original meshes and materials in Blender. Use the images as composition, silhouette, palette, and interface references only. Keep canonical identity in the registry rather than filenames. Each vehicle asset must have body, interior, wheels, damage proxy, camera anchor, and garage anchor; blockouts must remain labeled `blockout` until mesh, materials, physics, audio, and prefab tests pass.

## Immediate implementation targets

1. Build a garage scene using the cyan technical-wall language from References 02–05.
2. Add roster/lineage cards based on Reference 01, with 18 canonical families and separate hero/rival/police roles.
3. Use References 06–10 to define event categories, but do not import their third-party logos, screenshots, or copyrighted branding.
4. Replace the current Hero 1967 and Marsh blockouts progressively with original production geometry.
5. Preserve all ten originals in the reference folder and never mark them as playable assets.

## Reference Set 02

The second supplied set is preserved under `W2RL1.01-ArtReferences/Provided-Set-02/`.

- `Set02-01` and `Set02-02`: mobile racing information architecture; use category bands, high-contrast cards, and compact touch targets.
- `Set02-03` through `Set02-06`: open-world map composition; use as inspiration for a readable regional map with city, coast, hills, industrial, and rural zones.
- `Set02-07` through `Set02-09`: top-down traffic and circuit readability; use for route hierarchy, lane markings, traffic spacing, and compact event maps.
- `Set02-10`: mechanic/garage fantasy reference; use for hands-on inspection, upgrade presentation, and the progression from workshop to street racer.

## Set 02 implementation guidance

- Build a touch-first event/map screen with five categories: Simulation, Street, Drag, Rally/Off-road, and Casual/Traffic.
- Use a layered Blackridge/San Triana map: macro region, district, route, and encounter markers; do not reproduce any source map geometry.
- Keep traffic silhouettes simple and readable at distance, with stronger color contrast for police and rivals.
- Give the garage a practical mechanic layer: lift, parts shelves, inspection camera, dyno bay, tool bench, and visible generation upgrades.
- Treat all recognizable third-party logos, screenshots, names, and map layouts in these references as research-only. Create original W2RL1 presentation and assets.

## Reference Set 03

The third supplied set is preserved under `W2RL1.01-ArtReferences/Provided-Set-03/`.

- `Set03-01` through `Set03-05`: mechanic-game interaction references; use for tool benches, workshop props, component selection, repair feedback, and engine inspection states.
- `Set03-06`: cockpit and road-readability reference; use for instrument hierarchy, night driving contrast, and first-person telemetry placement.
- `Set03-07` through `Set03-10`: workshop presentation references; use for lifts, tire stations, engine stands, parts shelves, lighting zones, and modular repair bays.

## Set 03 implementation guidance

- Make the garage a functional space rather than a static menu: the player should walk or pan between lift, parts rack, dyno, fabrication bench, and inspection bay.
- Every repair action should expose condition, cost, time, required tool, resulting telemetry change, and visual state change.
- Support close-up inspection of engine, suspension, brakes, wheels, interior, and body damage.
- Use three presentation layers: practical workshop lighting, focused inspection lighting, and cinematic race-prep lighting.
- Preserve the tactile language—tools, stands, shelves, jacks, lifts, fluids, and visible assemblies—while creating original W2RL1 props and UI.

## Reference Set 04

The fourth supplied set is preserved under `W2RL1.01-ArtReferences/Provided-Set-04/`.

- `Set04-01` through `Set04-03`: top-down city and traffic references; use for road hierarchy, intersection readability, pursuit routing, and compact map overlays.
- `Set04-04`: lineage archive/garage visualization; use for multi-generation vehicle shelves and technical wall displays.
- `Set04-05` through `Set04-08`: W2RL1 concept boards; use as high-level direction for the vehicle roster, garage progression, mechanical realism, inspection, dyno, open world, police, and story loop.
- `Set04-09`: evidence-driven diagnostic UI reference; use for hypothesis selection, measurements, evidence lineage, confidence, and repair decisions.
- `Set04-10`: complete W2RL1 presentation reference; use to align the core loop, vehicle history, work orders, component identity, and racing presentation.

## Set 04 implementation guidance

- Separate world navigation into macro map, district map, route map, and live race view.
- Make police routes and traffic lanes readable before adding visual complexity.
- Treat the garage as a progression system: starter bay, performance shop, race development, and apex engineering facility.
- Make diagnostics evidence-based: observations, measurements, hypotheses, confidence, decision, repair, and verification.
- Track every installed part as an identity-bearing component with condition, provenance, service history, and compatibility.
- Make vehicle history visible across the entire loop: acquire, inspect, repair, modify, dyno, race, damage, restore, and advance generations.
