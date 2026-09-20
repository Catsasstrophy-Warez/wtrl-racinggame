# Wrench to Race Legends — Deep Content Catalog

Generated from the complete project tree on 2026-09-19. This catalog separates authored design intent, executable Swift production logic, Unity prototype logic, serialized content, and research-only references.

## Repository scope

- 2,443 project files excluding the generated ZIP and Git metadata.
- Approximately 8.52 MB of text/source/data content.
- 294 Markdown documents, 136 Swift files, 24 C# files, 16 JSON files, 12 CSV files, 11 Python files, 760 Unity `.meta` files, 364 FBX files, 356 Blender files, 177 prefabs, 28 PDFs, and supporting assets.
- Major layers: numbered research/specification folders, Unity prototype (`code`/`Art`), Swift production corpus (`ImportedVehicleCorpus`), Blender source (`ArtSource`), and documentation/reconciliation material.

## Authority model

1. `ImportedVehicleCorpus/Documentation/PRODUCT-TRUTH.md` is the newest production-truth authority.
2. `ImportedVehicleCorpus/Sources/WTRLVehicle` contains the vehicle, physics, lineage, damage, telemetry, and engineering models.
3. `ImportedVehicleCorpus/Sources/WTRLGarage` contains workshop, service, fabrication, diagnosis, physical interaction, and persistence models.
4. `ImportedVehicleCorpus/Sources/WTRLWorld` contains counties, districts, surfaces, traffic, climate, streaming, enforcement, and pursuit.
5. `FEATURE-LIST.md` is the Unity implementation/status audit, not the full Swift feature set.
6. Numbered Markdown documents are research/design intent and may describe systems that are not executable.

## Production architecture and systems

### Vehicle simulation

The Swift layer contains fixed-step dynamics, planar and four-corner behavior, tire forces, suspension/tire coupling, elastokinematics, aero, thermal-fluid behavior, combustion, driveline elasticity, driveshaft resonance, tire thermal layers, persistent mechanical damage, structural fatigue, impact consequences, and vehicle-state continuity.

Important primitives include:

- Fixed-step clock and RK4-style dynamics integration.
- Tire force lookup and combined longitudinal/lateral demand.
- Four-corner load, cross-weight, and front-bias calculations.
- Suspension geometry, damping, bump travel, compliance, and thermal fade.
- Aero balance, drag, downforce, ride-height sensitivity, and aero-mechanical closure.
- Engine torque/combustion cycle, fuel and cooling limits, boost/charge temperature, and powertrain continuity.
- Driveline elasticity, torsional resonance, backlash, shaft order analysis, and differential/service state.
- Tire temperature, wear, thermal windows, and surface-dependent grip.
- Mechanical consequence propagation from faults, impacts, heat, and fatigue.

Swift references: `Sources/WTRLVehicle/FixedStepDynamics.swift`, `FourCornerDynamics.swift`, `PlanarVehicleDynamics.swift`, `TireModel.swift`, `MultiLayerTireThermal.swift`, `SuspensionDynamics.swift`, `SuspensionTireCoupling.swift`, `Elastokinematics.swift`, `AerodynamicDynamics.swift`, `FluidThermodynamics.swift`, `CombustionCycle.swift`, `DrivelineElasticity.swift`, `DriveshaftResonance.swift`, `PersistentMechanicalDamage.swift`, `StructuralFatigueThermal.swift`, and `DynamicConsequences.swift`.

### Durable physical vehicle identity

The production model distinguishes:

- Vehicle identity
- Heritage lineage and generation
- Assembly nodes
- Component instance IDs
- Service connections
- Installation history
- Believed versus true condition
- Calibration and diagnostic state
- Persistent scars, fatigue, deformation, and repair evidence

The same physical component remains addressable through installation, removal, repair, inspection, and replacement. Relevant files include `DurableComponentIdentityRev32.swift`, `HeritageAssemblyGraphRev30.swift`, `VehicleContinuity.swift`, `PhysicalDiagnosisTruthRev26.swift`, `ProductionServiceInterfacesRev33.swift`, and `ServiceConnectionAuthorityRev32.swift`.

### Workshop and service

Workshop tiers are Barn, Commercial, Speed Lab, Paddock, and Empire. Capabilities include hand tools, timing bench, lift, alignment rack, tire machine, chassis dyno, flow bench, TIG welding, machining, corner scales, telemetry room, composite fabrication, and multi-bay inventory.

Diagnostic eras are analog, early electronic, and networked. Tools include vacuum gauge, dwell meter, timing light, carburetor jet kit, oscilloscope, diagnostic jumper, scan tool, CAN monitor, and ECU-calibration laptop.

Service domains include carburetor tuning/rebuild, fluids and cleaning, differential rebuild, measurement, mechanical inspection, physical diagnosis/repair, rotisserie restoration, fabrication, physical fastener/connector interaction, service contracts, timing/ledger, and production service plans.

Relevant files: `WTRLGarage/LivingGarageEcosystem.swift`, `CarburetorTuning.swift`, `CarburetorRebuildVignette.swift`, `DifferentialEngineering.swift`, `DifferentialRebuildRuntime.swift`, `MechanicalInspectionRev27.swift`, `PhysicalDiagnosisRepairRev26.swift`, `PhysicalInteractionRuntimeRev34.swift`, `RotisserieRestoration.swift`, `UniversalFabricationEngine.swift`, and `WorkshopRuntime.swift`.

### Intelligence and diagnostics

The engineering-intelligence layer models approximately 21 telemetry channels, sensor packages, health and confidence, learned baselines, threshold and z-score alerts, alert recurrence, diagnostic hypotheses, evidence chains, pre/post-trigger fault recording, fault reconstruction, self-test, maintenance outlook, alert attribution, engineering problem boards, and learned-state retirement after hardware mutation.

This is implemented principally by `VehicleMechanicalCalibrationRev28.swift`, `VehicleEngineeringTruthRev38.swift`, `PhysicalDiagnosisTruthRev26.swift`, `MechanicalTelemetryInference.swift`, `MechanicalConsequence.swift`, and the corresponding service/runtime types.

### World simulation

The world layer includes county-to-county travel, district/zone profiles, surface material, elevation, ambient temperature offset, moisture bias, traffic density, acoustic reflectivity, open-world streaming, traffic actor demotion/promotion, climate dynamics, hydroplaning authority, pursuit authority, pursuit tactics, faction mission authority, high-stakes pursuit, enforcement calibration, and physical-drive bridging.

Files: `WTRLWorld/BlackridgeWorldBlueprint.swift`, `BlackridgeRuntime.swift`, `BlackridgeSceneRuntime.swift`, `BlackridgeSurfaceField.swift`, `SanTrianaCounty.swift`, `SurfaceClimateDynamics.swift`, `HydroplaningAuthority.swift`, `OpenWorldStreaming.swift`, `TacticalOpenWorldGrid.swift`, `PursuitAuthority.swift`, `PursuitTactics.swift`, `HighStakesPursuit.swift`, `FactionMissionAuthority.swift`, and `EnforcementVehicleRosterRev27.swift`.

## Complete named locations

### Blackridge County districts

Freight Docks; Foundry Row; River Bypass; Icehouse Industrial; Briar; Mountain Crest.

Each district has dry-grip scale, wet-grip scale, roughness, standing-water risk, traffic density, and acoustic reflectivity.

### San Triana County zones

Crest; Foundry Row; Maritime Docks; River Interchange; Old Town.

The Crest is high-elevation tar-chip terrain; Foundry Row is lower urban asphalt; Maritime Docks uses marine concrete; River Interchange is dense urban asphalt; Old Town uses painted road surfaces.

### Named race facilities

Redline Raceway; Cutback Tri-Oval; Longbow Speedway; Highbank Superspeedway.

## Complete race-track catalog

### Drag and speed formats

- Eighth mile: 660 ft / 201 m.
- Quarter mile: 1,320 ft / 402 m, with period-correct use for the 1965-era setting.
- 1,000 ft: modern top-fuel-style distance.
- Half-mile standing-mile event.
- Full-mile standing-mile event.
- Shutdown area at least approximately race-distance length.
- Two-lane layout with UEM-style lane-width guidance.

### Ovals

- 3/4-mile short-track class, steep banking envelope.
- 1.5-mile intermediate class.
- 2.5-mile superspeedway class.
- Simple oval, tri-oval, and D-shaped variants.
- Banking is not treated as a free grip multiplier: at superspeedway scale, power-to-drag becomes the limiting factor.

### Original road-course principles

- Long forest elevation circuit: blind crests, dense trees, large elevation change, low sightlines, real-time reading rather than memorization.
- Coastal signature-drop circuit: right-left sequence, steep single drop, cliff environment, mid-lap signature moment.
- Technical tight circuit: fast uphill compression, crossing/figure-eight pattern, tight barrier-close infield.

The project explicitly avoids reproducing real track layouts. The design references principles associated with famous circuits, not their turn-by-turn geometry.

## Complete playable/production vehicle catalog

### Crownfire hero lineage

1967 Crownfire Original; 1968 Crownfire King; 1970 Crownfire Grand; 2008 Crownfire Rebirth; 2011 Crownfire Evolution; 2014 Crownfire Hammer; 2022 Crownfire Apex; Crownfire EXP Laboratory; Legend GT-X Bloodline Zero.

The lineage progresses from carbureted analog front-engine RWD cars through modern electronically monitored, high-aero, DCT, experimental, and endgame vehicles. The hero definitions include mass, wheelbase, track widths, CG height, weight distribution, power, torque, redline, gearing, tire sizes, aero scale, brake thermal capacity, cooling, rigidity, service complexity, diagnostic era, failure mechanisms, service highlights, visual identity, and research gates.

Source: `Sources/WTRLVehicle/ProductionVehicleRosterRev27.swift` and `Content/HeroCars/`.

### Enforcement fleet

- Sentinel County V8: county patrol; marked livery, push structure, roof lights.
- Vector Highway Interceptor: AWD highway interceptor; low-profile emergency package and cutoff behavior.
- Rhino Heavy Containment: armored heavy unit; roadblocks, corridor closure, off-road capability.
- Phantom Special Response: track-grade precision interceptor with concealed emergency equipment.
- Apex State Hunter: prototype statewide pursuit vehicle with active aero and high-speed telemetry.

### Heritage lineages

The 14 core lineages each contain nine era-spanning entries:

1. Mopar High-Torque
2. Viper V10 Homologation
3. Bowtie Big-Block
4. Fiberglass Grand Tourer
5. Wide-Track Performance
6. V-Series Executive Tourer
7. Personal Luxury Speed
8. Fairlady Z
9. Skyline Heritage
10. Grand Tourer Twin-Cam
11. Lightweight High-RPM
12. VTEC Front-Drive
13. Bavarian Motorsport
14. Rear-Engine Apex

The full model names are encoded directly in `HeritageLineageEngineeringRev29.swift`. The file defines the 126 core entries plus the 27-car Triple-Wide Ford Heritage group.

### Triple-Wide Ford Heritage groups

Heavy Iron/Pursuit: 1964 Galaxie 500 Lightweight 427 SOHC; 1969 Torino Talladega 428CJ; 1973 Falcon XB GT Coupe; 1985 LTD LX 5.0 Sedan; 1991 Crown Victoria P72 Interceptor; 1993 Thunderbird Super Coupe; 2003 Marauder / Falcon BA XR8; 2014 Falcon FG X XR8; 2023 Police Interceptor Utility.

Homologation/Rally: 1965 Lotus Cortina Mk1; 1970 Escort RS1600 BDA; 1973 Capri RS3100 Cologne; 1986 Sierra RS Cosworth RS500; 1989 Taurus SHO; 1994 Escort RS Cosworth; 2003 Focus RS Mk1; 2016 Focus RS Mk3; 2024 Puma ST.

Endurance/Halo: 1966 GT40 Mk II; 1967 GT40 Mk IV; 1972 De Tomaso Pantera GTS; 1986 RS200 Evolution; 1990 Supervan 3; 1995 GT90 Concept; 2005 Ford GT; 2016 Ford GT GTE; 2023 Ford GT Mk IV.

### Mustang heritage reference group

1965 Shelby GT350; 1968 Shelby GT500 KR; 1969 Boss 302; 1970 Boss 429; 1986 Mustang SVO; 1993 SVT Cobra; 2000 Cobra R; 2003 SVT Cobra; 2019 Bullitt; 2020 Shelby GT350; 2022 Shelby GT500; 2024 Dark Horse; Mustang GTD; Dark Horse SC.

These are research-gated references, not automatically verified production claims.

## Characters and factions

### Player

Unnamed protagonist. Progression is behavior-derived rather than point allocation: license grade, safety rating, diagnostic reps, inspection competence, emergent traits, and shop-driver proof.

### Mentor

Unnamed workshop mentor. Teaches installation, diagnosis, and interpretation; commentary shortens as the player’s demonstrated diagnostic skill rises.

### Rivals

- Reyes: aero-focused European rear-engine GT specialist; low-speed weakness.
- Kade: turbocharged Japanese inline-six specialist; boost-threshold/peaky torque weakness.
- Vogel: German touring-saloon specialist; precise in dry conditions, weak in wet conditions.
- Duquesne: American big-block specialist; under-braked and highly willing to attempt passes.
- Osei: British lightweight specialist; endurance vulnerability.
- Marsh: “the Constant”; consistent, calm, and deliberately lacks a counter-buildable weakness.

### Enforcement factions

County patrol, highway interceptor units, heavy containment, special response, and state hunter response. These are represented through vehicle roles, equipment, behavior policies, and pursuit authorities rather than named human characters.

## Implementation status caveats

- Unity’s `FEATURE-LIST.md` marks live, unreachable, data-only, prototype-only, and absent systems.
- The Unity prototype has a circuit-race loop, six rival profiles, and authored vehicle generations, but many research concepts are not wired to a playable scene.
- Swift has the more complete mechanical truth model, but its product-truth documentation explicitly says Apple-specific Xcode, RealityKit, Metal, AVFoundation, Simulator, signing, and physical-device execution remain unverified.
- Historical vehicle names and exact engineering values remain research-gated until independently verified.
- Some counts differ between documents because the 153-vehicle product-truth count refers to the 15-lineage heritage layer, while the Mustang reference layer is authored separately.

## Key source files

- `FEATURE-LIST.md`
- `README.md`
- `PITCH.md`
- `WHERE-WE-ARE.md`
- `05-specifications/44-TRACK-ROSTER.md`
- `05-specifications/45-RIVAL-DEVELOPMENT.md`
- `05-specifications/49-PLAYER-CHARACTER-RPG.md`
- `ImportedVehicleCorpus/Documentation/PRODUCT-TRUTH.md`
- `ImportedVehicleCorpus/Sources/WTRLVehicle/ProductionVehicleRosterRev27.swift`
- `ImportedVehicleCorpus/Sources/WTRLVehicle/HeritageLineageEngineeringRev29.swift`
- `ImportedVehicleCorpus/Sources/WTRLVehicle/MustangHeritageRev33.swift`
- `ImportedVehicleCorpus/Sources/WTRLWorld/BlackridgeWorldBlueprint.swift`
- `ImportedVehicleCorpus/Sources/WTRLWorld/SanTrianaCounty.swift`
- `ImportedVehicleCorpus/Sources/WTRLWorld/EnforcementVehicleRosterRev27.swift`
