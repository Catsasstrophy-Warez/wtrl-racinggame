# Wrench to Race Legends — Unity Mobile Conversion Project Map

> **This document is a production/content-pipeline companion to
> `WTRL-Unity/PIVOT-PLAN.md`, which is the authoritative architecture
> document for the Unity pivot** (project location, module boundaries,
> the hub-world-plus-instanced-events decision, the SwiftRacer content
> porting map, and the Claude/ChatGPT/Gemini work split). This file was
> originally written independently, before its author had read that
> document, and disagreed with it on real points: a different project
> location (`UnityProject/` vs the actual `WTRL-Unity/`, which already
> exists as a git repository), different module names, and no reflection
> of the hub-plus-instanced-events decision. **Reconciled 2026-09-19** —
> every section below now uses `PIVOT-PLAN.md`'s actual project location,
> module names, and decisions. Its genuinely additive content (the
> Blender pipeline, world/track production pipeline, milestones,
> validation strategy, performance budgets, non-goals) is preserved
> unchanged, since none of that conflicted with the architecture doc —
> it simply didn't exist there yet.
>
> If you're a third assistant picking up either document for the first
> time: **read `WTRL-Unity/PIVOT-PLAN.md` first.** This file assumes it.

## Objective

Convert the current WTRL design/research corpus, Unity prototype assets, Blender source, and Swift mechanical simulation into a shippable Unity 6 mobile game using Blender wherever it is the fastest and most controllable authoring tool.

Target platforms: iOS and Android phones/tablets. Target rendering: URP. Target runtime: Unity 6 LTS-compatible project, C# gameplay layer, Burst/Jobs where profiling proves useful, Addressables for content, and platform-native save/analytics adapters behind interfaces.

## Current-state finding (updated 2026-09-19 — see note at top)

**A conventional Unity project already exists** at `D:\Claudeprojx\WTRL-Unity\`
(sibling to this `racinggame/` corpus), git-initialized, with a real
`Assets/`, `Packages/manifest.json`, and `ProjectSettings/ProjectVersion.txt`
(Unity 6000.0.58f2, matching the archived Rev16.1 reference project). It
already has the full 15-assembly module graph (see "Target Unity project
layout" below), a pure-bash structural validator that runs and passes
without needing the Unity Editor, and `WTRL.Vehicle` is already ported
from `SwiftRacer` and compiler/test-verified (see `WTRL-Unity/Assets/
WrenchToRaceLegends/Vehicle/CONTRACT.md`). **The conversion has already
begun; this is not a from-scratch bootstrap.**

Separately, the following exist as *reference and content material*, not
as the working Unity project:

- Unity/C# prototype code in `code/prototype` (this `racinggame/` corpus)
  and the identical content under the archived Rev16.1 project's
  `Assets/WrenchToRaceLegends/Prototype~/` folder. **Both are the same
  never-compiled code.** Unity excludes any folder ending in `~` from
  compilation, so the `Prototype~` copy never ran; `code/prototype`'s copy
  outside a Unity project never compiled either. A prior audit of this
  exact project (`racinggame/WHERE-WE-ARE.md`) found that treating this
  code as if it were working, verified game logic was a real mistake made
  earlier in this project's history. Treat everything here as design
  intent to react to, not code to port as-is.
- Unity art/material/prefab assets in `Art`.
- Blender and FBX source in `ArtSource/Blender`.
- Swift production truth in `ImportedVehicleCorpus/Sources` — itself
  flagged in its own `REFERENCE-BOUNDARY.md` as reference material, at a
  later revision ("Rev38") than anything reconciled into `SwiftRacer/`,
  with module boundaries that don't match either `SwiftRacer` or the new
  `WTRL-Unity` assembly graph.
- JSON catalogs in `ImportedVehicleCorpus/Content`.
- Research and specification documents in the numbered folders and root
  Markdown files.

## Conversion principles

1. **Revised**: for the deterministic simulation core specifically
   (vehicle physics, tire/suspension/powertrain solvers), translate the
   Swift source term-for-term rather than reimplementing from behavioral
   intent — this is what `WTRL.Vehicle`'s port actually did, and it
   caught a real mistranslation in its own ported tests precisely because
   the arithmetic was checkable against the Swift original line by line.
   For higher-level gameplay systems (career, RPG, world/event flow),
   treat Swift as the behavioral reference and design intent, not code to
   transliterate — those systems don't have the same "must match exactly"
   determinism requirement the physics core does.
2. Treat `FEATURE-LIST.md` as the Unity prototype status audit.
3. Keep research-gated historical claims clearly marked in data.
4. Make the mobile vertical slice authoritative before expanding the roster.
5. Generate repeated vehicle variants from shared Blender and Unity data rather than hand-authoring every car.
6. Keep high-fidelity service simulation behind the same interfaces as the mobile-friendly interaction layer.
7. Use deterministic simulation and replay fixtures so Unity and Swift can be compared numerically.

## Target Unity project layout

This is `D:\Claudeprojx\WTRL-Unity\`, which already exists. **The 15
assemblies below are `PIVOT-PLAN.md`'s actual module graph, already
scaffolded with real `.asmdef` files verified acyclic by `Scripts/
validate_structure.sh`** — not a proposal. Where this document's original
draft named a module that doesn't exist in the real graph (`Race`, `AI`,
`Progression`, `Audio`, `Platform`), the mapping is noted inline; no new
assemblies were invented to preserve this document's original names,
since the actual graph was scaffolded, reviewed, and (for `WTRL.Vehicle`)
already has real ported code depending on the names as they exist now.

```text
WTRL-Unity/                              (existing, git-initialized)
  Assets/WrenchToRaceLegends/
    Core/         WTRL.Core       — clocks, IDs, shared value types. Empty so far.
    Vehicle/      WTRL.Vehicle    — fixed-step vehicle simulation. PORTED, tested.
    World/        WTRL.World     — counties/districts, surfaces, streaming cells.
    Events/       WTRL.Events    — instanced-event lifecycle (was this doc's "Race" state/checkpoint/ranking half).
    Racing/       WTRL.Racing    — racing line, rivals, pursuits, traffic (was this doc's "AI").
    Garage/       WTRL.Garage    — parts, condition, service, diagnosis.
    Lab/          WTRL.Lab       — dyno, deeper diagnostics/validation experiments.
    RPG/          WTRL.RPG       — player-character stats/skills/quests (was half of this doc's "Progression").
    Career/       WTRL.Career    — career/license/reputation/economy (the other half of "Progression").
    Persistence/  WTRL.Persistence — save/versioning/migration.
    Runtime/      WTRL.Runtime   — composition root; also where platform (iOS/Android) adapters live behind
                                    interfaces (this doc's "Platform" — not a separate assembly).
    UI/           WTRL.UI        — mobile HUD, garage, telemetry, menus.
    Editor/       WTRL.Editor    — editor tooling, ScriptableObject/JSON importers, content validators.
    Tests/EditMode, Tests/PlayMode
  Packages/manifest.json   — URP, Input System, Cinemachine, Addressables, Timeline.
  ProjectSettings/
  Scripts/validate_structure.sh   — pure-bash structural validator, runs today, no Editor needed.
  PIVOT-PLAN.md            — the architecture document this file defers to.

  Authoring/ (proposed, not yet scaffolded)
    ScriptableObjects/     # vehicle, parts, tracks, rivals, events
    Importers/             # JSON/CSV/catalog conversion — lives in WTRL.Editor
    Validation/            # editor checks and content reports — lives in WTRL.Editor
  Data/ (proposed)
    Vehicles/ Parts/ Tracks/ Rivals/ World/ Progression/
  Scenes/ (proposed)
    Bootstrap/ VerticalSlice/ Garage/ Race/ World/ Lab/
  Art/ (proposed)
    Vehicles/ Tracks/ World/ Characters/ UI/ VFX/
  Audio/ (proposed — content only; no dedicated assembly. Engine/tire/
          drivetrain/ambience audio is data consumed by WTRL.Vehicle's
          presentation layer and WTRL.World, not its own module.)
  Addressables/ Tests/ Shaders/ (proposed)

BlenderPipeline/                          (proposed, sits outside WTRL-Unity/
                                            since it's an authoring tool, not
                                            a Unity asset — decide final
                                            location when this phase starts)
  source/ scripts/ export/ validation/
```

## Runtime architecture

### Simulation layer

Implement the vehicle simulation as a pure C# assembly with no Unity scene dependencies — this is already the actual design of `WTRL.Vehicle` (see `WTRL-Unity/Assets/WrenchToRaceLegends/Vehicle/CONTRACT.md`): its files have zero `UnityEngine` dependency, which is exactly what let that port be verified with a real `dotnet build`/`dotnet test` instead of only by reading. Keep this property for `WTRL.Core`, `WTRL.Garage`, and `WTRL.World`'s simulation-relevant pieces too — no `WTRL.Simulation.*` prefix needed, the existing assembly names (`WTRL.Core`, `WTRL.Vehicle`, `WTRL.Garage`, `WTRL.World`) already carry this contract implicitly by virtue of what they're allowed to depend on.

Unity `MonoBehaviour` and ECS-facing adapters should only translate input, transforms, physics queries, and presentation — this is `WTRL.Runtime`'s and `WTRL.UI`'s job, not the simulation assemblies'. This preserves deterministic tests and allows simulation speed to be throttled for distant traffic.

One real gap `WTRL.Vehicle`'s port surfaced and this document should account for: Swift's `VehicleSimulation.step` resolved tire/suspension definitions from a global content catalog reached into from inside the physics function. The Unity port deliberately removed that — `tire`/`suspension` are now required parameters, pushing content resolution onto whichever layer calls `Step` every frame. **The ScriptableObject data layer below is exactly that missing resolver** — designing it should explicitly close this gap, not reintroduce a global-lookup pattern inside the simulation assemblies.

Recommended tick policy:

- Player and nearby competitors: fixed 100 Hz or an empirically validated lower rate.
- Race gameplay integration: 50–100 Hz.
- Nearby traffic: 20–30 Hz.
- Distant traffic: kinematic or dormant.
- Telemetry sampling: 10 Hz, matching the existing design.

### Data layer

Convert JSON catalogs into versioned ScriptableObjects plus runtime structs. Keep original JSON in `Assets/WTRL/Data/SourceJSON` and generate Unity assets through an editor import command.

Core ScriptableObjects:

- `VehicleDefinitionSO`
- `VehicleGenerationSO`
- `VehiclePhysicsProfileSO`
- `ComponentDefinitionSO`
- `PartCompatibilitySO`
- `TrackDefinitionSO`
- `TrackEngineeringProfileSO`
- `RivalProfileSO`
- `RivalGenerationSO`
- `WorldDistrictSO`
- `SurfaceProfileSO`
- `RaceEventSO`
- `WorkshopCapabilitySO`
- `LicenseGradeSO`
- `EconomyTableSO`

Runtime save data must remain plain serializable DTOs with schema version and migration number. Do not serialize live `ScriptableObject` references into the save file; store stable IDs.

## System migration matrix

| Domain | Source of truth | Unity target (assembly) | Status | First milestone |
|---|---|---|---|---|
| Vehicle dynamics | `SwiftRacer/.../VehicleSimulation.swift` | `WTRL.Vehicle` | **Ported, compiler/test-verified** | Hero 1967 driving loop |
| Tire model | `TireSolver` in `DynamicsSubsystems.swift` | `WTRL.Vehicle` | **Ported** (part of the above) | Skidpad and braking tests |
| Suspension | `SuspensionSolver` in `DynamicsSubsystems.swift` | `WTRL.Vehicle` | **Ported** (part of the above) | Bump and cornering test |
| Powertrain | `PowertrainSolver`/`ShiftController` | `WTRL.Vehicle` | **Ported** (part of the above) | 1967 manual RWD |
| Damage | `DamageState` (in `VehicleSimulation.swift`), `WorldConsequences.swift` | `WTRL.Vehicle` + `WTRL.Career` | Damage state ported; consequence/repair flow not yet | One fault changes performance |
| Workshop | `WTRLGarage` (`ImportedVehicleCorpus`, reference only), `SwiftRacer` garage/dyno logic | `WTRL.Garage`, `WTRL.Lab` | Not started | Remove/install/repair one part |
| Instanced events | Unity prototype race systems, `SwiftRacer`'s `RaceRuntimeState` | `WTRL.Events` + `WTRL.Racing` | Not started | One circuit, one lap, Marsh |
| Rival AI | `RivalIntimidation.swift`, `TrackAI.swift`, prototype `RivalAI.cs` (reference only) | `WTRL.Racing` | Not started — real, sourced parameter values to port, see `PIVOT-PLAN.md` | Marsh race opponent |
| World | Blackridge/San Triana Swift files, Wave24's world-streaming design (reference — RealityKit code doesn't port, the cell-streaming *design* does) | `WTRL.World` | Not started | One Blackridge district |
| Enforcement | Enforcement roster and pursuit authorities | `WTRL.Racing` or `WTRL.World` (undecided) | Not started | County patrol chase |
| Career/RPG | RPG/specification Markdown (`48-RPG-SYSTEMS-SPEC.md`) + Swift career data | `WTRL.Career` + `WTRL.RPG` | **Assigned to Gemini** (see `WTRL-Unity/Assignments/Gemini-RPG-Spec-Brief.md`) | Cash, repair, reputation |
| Telemetry | Swift intelligence files | `WTRL.Vehicle` (data) + `WTRL.UI` (display) | Not started | Post-race diagnosis |
| Art | Blender/FBX/Unity Art folders, `SwiftRacer/Documentation/ArtDirection/` (Wave25 Visual DNA spec — engine-agnostic, use verbatim) | Blender batch pipeline + Unity import profiles | Not started | Hero 1967 production prefab |
| Audio | Audio design docs and vehicle assets | Content/data, no dedicated assembly (see layout note above) | Not started | Engine/tire/transmission audio |

## Mobile vertical slice

Build this before porting the entire catalog:

1. Blackridge district: Foundry Row or River Bypass.
2. One short original circuit derived from the technical/tight track principle.
3. Player vehicle: 1967 Crownfire Original.
4. Rival: Marsh with one generation.
5. Workshop: inspection, one repair, one component install.
6. One drag event and one circuit event.
7. Race results, cash, repair bill, reputation, and save/load.
8. Mobile touch controls, optional tilt steering, pause, low-battery quality mode.
9. Telemetry HUD with speed, RPM, gear, tire slip, temperature, and one diagnostic alert.
10. iOS and Android device builds with frame-time, thermal, memory, and battery capture.

## Blender-first asset pipeline

### Vehicle authoring stages

For every vehicle family:

1. Preserve the existing `.blend` as immutable source.
2. Normalize units, origin, forward axis, wheel centers, suspension anchors, and naming.
3. Split render body, glass, lamps, wheels, tires, interior, engine-bay, damage panels, and serviceable parts.
4. Create high-resolution source mesh.
5. Produce mobile render mesh with controlled topology.
6. Produce LOD0/LOD1/LOD2/LOD3.
7. Generate collision meshes separately.
8. Bake normals, curvature, AO, and material masks.
9. Pack trim/material IDs into a stable naming convention.
10. Export FBX or glTF according to the Unity import test; use FBX first because existing content is already FBX-oriented.
11. Generate a Unity prefab from a vehicle manifest.
12. Validate wheel positions, bounds, scale, material count, pivot orientation, LOD transitions, and collider coverage.

### Blender automation

Create Python scripts under `BlenderPipeline/scripts` for:

- Batch scene cleanup.
- Naming and collection normalization.
- LOD generation.
- Decimation by target triangle budget.
- UV validation.
- Material consolidation.
- Collider proxy generation.
- Wheel/attachment marker export.
- Damage-panel separation.
- FBX batch export.
- Thumbnail/render-sheet generation.
- Manifest JSON generation.

### Recommended mobile vehicle budgets

Initial budgets, to be validated on target devices:

- Hero exterior LOD0: 80k–140k triangles.
- Hero exterior LOD1: 35k–70k.
- Hero exterior LOD2: 12k–30k.
- Traffic LOD2/LOD3: 3k–15k.
- One vehicle material set: preferably 4–8 materials, with atlasing where practical.
- Interior: separate addressable, loaded only in garage/cockpit views.
- Engine-bay/service parts: separate addressable, loaded only for workshop inspection.
- Avoid per-part renderers for distant cars; collapse to baked presentation meshes.

## World and track production pipeline

Use Blender for modular environment kits, not hand-built monolithic scenes.

Required kits:

- Road and shoulder modules
- Curbs, barriers, guardrails, tire walls
- Industrial buildings and Foundry Row props
- Docks, containers, cranes, asphalt/concrete decals
- Forest and mountain modules
- Old Town facades and painted-road details
- Interchange ramps and signage
- Drag-strip timing towers and shutdown areas
- Oval walls, fencing, pit buildings, and grandstands

Each track gets:

- Spline centerline
- Racing line
- Checkpoint sequence
- Sector markers
- Recovery points
- Surface zones
- Traffic lanes
- World-streaming cells
- Track engineering fingerprint
- Mobile collision simplification

## Character and NPC strategy

The current project has named rivals but no complete authored human-character roster. For mobile scope:

- Represent rivals initially through portrait cards, voice/text identity, car presentation, and race behavior.
- Use low-cost garage NPC silhouettes before full 3D characters.
- Build a reusable Blender human base mesh only after the vehicle/race vertical slice is stable.
- Keep protagonist and mentor mostly first-person/over-the-shoulder UI and hands-on interaction until animation scope is justified.

## Performance and technical budgets

Initial budgets are targets, not acceptance criteria until measured:

- 30 FPS minimum on supported low-tier mobile devices.
- 60 FPS target on mid/high-tier devices.
- Main-thread frame budget: approximately 33 ms at 30 FPS, 16.6 ms at 60 FPS.
- Avoid garbage allocation in fixed-step simulation, ranking, AI, and telemetry loops.
- Use object pools for traffic, VFX, tire smoke, sparks, and race markers.
- Use GPU instancing for repeated environment props.
- Use baked lighting where possible; limit real-time shadows to player/nearby competitors.
- Stream district cells and Addressable art banks.
- Keep save/load and content import off the render-critical path.
- Add thermal degradation modes: reduced shadows, traffic, reflection quality, and telemetry frequency.

## Milestones

### M0 — Project bootstrap

**Partially done.** Unity 6 project (`WTRL-Unity/`), package manifest
(URP, Input System, Cinemachine, Addressables, Timeline), and all 15
assembly definitions already exist and are git-committed. **Still open**:
CI build, input abstraction, save schema, device matrix, import
conventions — and the project has never actually been opened in a real
Unity Editor (no Editor has been available in any environment this
project has been authored in so far), so `.meta` file generation and
package-manifest resolution are still outstanding first-Editor-open tasks
(see `PIVOT-PLAN.md`'s meta-GUID caution before doing this with more than
one person's local copy).

Exit gate: blank iOS/Android builds launch, report version/device data, and load a bootstrap scene.

### M1 — Physics parity

**Substantially done at the code level.** `WTRL.Vehicle` has the fixed-step
vehicle core, tire/suspension model, powertrain, and 5 ported/passing
tests (determinism, banking, fuzz-input robustness — see `Vehicle/
CONTRACT.md`). **Still open**: this was verified with a throwaway plain
.NET project, never inside the actual Unity Editor/Test Framework, and
never against real device performance. Re-run the same tests inside
Unity once an Editor opens this project; only then does this milestone's
original exit gate (tolerance-checked against Swift/Python fixtures for
acceleration, braking, skidpad, slalom, coastdown) actually get evaluated.

### M2 — Hero vehicle and Blender pipeline

Normalize hero 1967 Blender source, create LODs/colliders/materials, build prefab, wire physics anchors and damage/service nodes.

Exit gate: vehicle drives, resets upright, changes condition, and survives repeated import/export.

### M3 — Race loop

Implement track spline, checkpoints, sectors, ranking, countdown, finish, DNF, results, race seed, and Marsh AI.

Exit gate: one complete deterministic race can be repeated and replay-compared.

### M4 — Workshop vertical slice

Implement garage scene, inspection, remove/install, repair, cost, component identity, and save/load.

Exit gate: a damaged component can be identified, serviced, and shown to affect driving.

### M5 — Mobile world slice

Build one Blackridge district, streamed cells, traffic tiers, weather/moisture, traffic audio, and county pursuit patrol.

Exit gate: sustained 20-minute device session without unacceptable thermal, memory, or frame-time regression.

### M6 — Career foundation

Add cash, reputation, license grade, event eligibility, rival relationship history, and mentor progression.

Exit gate: a new save can progress through a coherent short career loop.

### M7 — Content expansion

Add the remaining hero generations, rival generations, enforcement tiers, drag/oval/road-course formats, and garage capability tiers.

Exit gate: generated content passes automated ID, reference, compatibility, and performance validation.

### M8 — Production hardening

Add localization, accessibility, analytics opt-in, crash reporting, cloud-save adapter, store compliance, tutorial, settings, and device-specific quality profiles.

Exit gate: release candidate passes platform certification and soak testing.

## Validation strategy

### Automated

- JSON-to-ScriptableObject import validation.
- Duplicate/missing ID detection.
- Vehicle wheel/anchor/bounds checks.
- Track checkpoint ordering and recovery-point checks.
- Part compatibility and required-dependency checks.
- Save migration tests.
- Deterministic replay tests.
- Physics golden-slice tests.
- AI seed reproducibility tests.
- Addressables dependency checks.
- Blender export manifest checks.

### Visual

- Render each vehicle LOD and compare against Blender source.
- Verify materials, glass, lamps, wheels, seams, and damage panels.
- Verify track silhouettes, sightlines, surface transitions, and recovery zones.
- Verify UI at phone aspect ratios, safe areas, notch/cutout layouts, and touch sizes.

### Device

Test low, mid, and high-tier iOS and Android devices for:

- Cold start and scene transitions
- 30/60 FPS stability
- Battery drain and thermal throttling
- Memory pressure and background/resume
- Touch, tilt, controller, and accessibility input
- Save interruption and recovery
- Audio focus and phone-call interruption

## First implementation backlog

1. ~~Create the Unity project shell and assembly definitions.~~ **Done** — `WTRL-Unity/`.
2. Copy/import only the hero 1967 and Marsh art assets.
3. Add JSON source preservation and ScriptableObject importer.
4. ~~Port fixed-step vehicle state and tire/suspension golden tests.~~ **Done** — `WTRL.Vehicle`, see its `CONTRACT.md`.
5. Build the hero prefab from Blender source.
6. Build one short original circuit with spline/checkpoints.
7. Port deterministic Marsh line AI.
8. Add mobile input and camera.
9. Add minimal garage inspect/repair/install loop.
10. Build iOS and Android vertical-slice packages.
11. Profile on real devices.
12. Only then batch-generate the heritage fleet and world content.

## Explicit non-goals for the first slice

- Full 167+ heritage vehicle presentation set.
- Full human-character animation system.
- Seamless two-county open world.
- Full physical fastener/connector simulation on every part.
- All pursuit tiers.
- All race formats.
- Full dyno and multi-parameter lab UI.
- Exact historical/OEM production claims before verification.

## Definition of done for the conversion

The conversion is complete when the Unity mobile build contains the full intended career, garage, vehicle, rival, world, track, pursuit, diagnostic, and progression systems; all content is generated from versioned data; vehicle and environment assets are imported from validated Blender/FBX source; simulation parity tests pass; every authored item has stable IDs and provenance; and iOS/Android device testing demonstrates acceptable performance, thermal behavior, memory use, save reliability, and input quality.

## Changelog

- 2026-09-19: Initial draft, written independently of `WTRL-Unity/
  PIVOT-PLAN.md`.
- 2026-09-19: Reconciled against `PIVOT-PLAN.md` (Claude) — fixed the
  project location (`UnityProject/` → the actual `WTRL-Unity/`), the
  module/assembly names to match the real 15-assembly `.asmdef` graph,
  corrected the stale "no Unity project exists yet" finding, added the
  `Prototype~`/`code/prototype` never-compiled caution, reconciled
  conversion principle #1 with `WTRL.Vehicle`'s actual (and correct)
  term-for-term porting approach, and updated the migration matrix and
  milestones M0/M1 and backlog items 1/4 to reflect what's actually
  already built and verified. This document's Blender pipeline, world/
  track production pipeline, character/NPC strategy, performance
  budgets, milestones M2-M8, validation strategy, and non-goals were
  left unchanged — none of it conflicted with `PIVOT-PLAN.md`, it simply
  didn't exist there and remains a genuine, additive contribution.
