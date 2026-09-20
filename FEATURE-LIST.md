# Wrench to Race Legends — Full Feature List

Complete inventory of what exists in the codebase, derived from the source rather
than from the design docs. Covers Rev14.2 (Rev14.1 plus the two fix passes).

**Scope:** 77 compiled C# files across 12 assemblies, ~12,000 lines, plus 24
files in `Prototype~/` that Unity does not compile.

## Status legend

| | Meaning |
|---|---|
| **●** | **Live** — implemented, and a builder places it in a scene. Runs when you press play. |
| **◐** | **Implemented, unreachable** — the code is complete and correct, but nothing calls it and/or no authored asset exists to feed it. |
| **○** | **Data only** — the serialized structure exists and is written to every save, but no code reads or writes it. |
| **◌** | **Prototype only** — lives in `Prototype~/`, which Unity excludes from compilation. Not in the game. |

Counts at the end.

---

# 1. Vehicle physics

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Raycast suspension | Per-wheel spring/damper with compression tracking; 4 wheels | `VehicleController` |
| ● | Combined-slip tyre forces | Longitudinal + lateral demand clamped to a friction circle (`Vector2.ClampMagnitude`) | `VehicleController:196` |
| ● | Load-sensitive grip | `maxTireForce = normalLoad × tireGrip × gripMultiplier × componentGripMultiplier` | `VehicleController:186` |
| ● | Slip telemetry | Slip ratio and slip angle per wheel, computed and exposed | `WheelDebugState` |
| ● | Wheel angular state | Torque/brake integration with a coupling term — **deliberately decoupled from the force solver** (documented at `VehicleController:202`) | `VehicleController` |
| ● | Gearbox | Gear ratios array, final drive, shift duration with torque cut during shifts | `VehicleSpec` / `VehicleController` |
| ● | Engine torque curve | Peak torque, idle and redline RPM, throttle mapping | `VehicleController.EngineTorque()` |
| ● | Drive layouts | RWD and AWD via `DriveShare(i)` | `VehicleController` |
| ● | Aerodynamics | Drag from `aeroCdA`, downforce from `downforceCoefficient`, rolling resistance | `VehicleController.ApplyAero()` |
| ● | Braking | Per-wheel brake torque plus a rear-only handbrake | `VehicleController` |
| ● | Runaway-state clamping | Velocity and angular velocity bounded rather than allowed to propagate NaN | `VehicleController` |
| ● | Upright recovery | `ResetUpright()` restores pose and zeroes velocity | `VehicleController` |
| ◌ | Pacejka/Beckman tyre model | The slip-curve model the research thesis rests on | `Prototype~/Physics/TireForceModel.cs` |
| ◌ | Ragged-edge instability meter | Traction-circle fill + Milliken loss-of-control criterion | `Prototype~/Physics/RaggedEdgeMeter.cs` |
| ◌ | Surface-dependent grip | Per-surface friction lookup | `Prototype~/Physics/SurfaceGripTable.cs` |
| ◌ | Static weight transfer | | `Prototype~/Physics/StaticWeightTransfer.cs` |
| — | Differential model | **Does not exist in any form.** `Differential` is a component *category* with a torque-capacity limit; there is no preload, lock, or torque-split behaviour in the solver. |

**Note:** `forceUtilization` (traction-circle fill, per wheel) is already computed
every physics tick at `VehicleController:200` and consumed by wear, the developer
HUD and driver fingerprinting. It is the input the instability meter needs.

---

# 2. Race loop

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Race state machine | Inactive → Loading → Staging → Countdown → Racing → Finishing → Results → Complete | `RaceDirector` |
| ● | Pre-flight validation | `CanBeginRace` rejects missing track, missing competitors, invalid spec, unraceable track | `RaceDirector:70` |
| ● | Grid staging | Positions competitors, disables control until the countdown ends | `RaceDirector.StageGrid()` |
| ● | Lap counting | Ordered checkpoint sequence; out-of-order crossings ignored | `RaceCompetitor` |
| ● | Live position ranking | Allocation-free: reusable buffer, deterministic comparer, no LINQ | `RaceDirector.RankCompetitors()` |
| ● | Sector timing | Two sector splits plus best-sector tracking | `RaceCompetitor.BestSectorTimes` |
| ● | Best-lap window capture | Records the unity-time window of the best lap for telemetry extraction | `RaceCompetitor` |
| ● | Finish detection | Per-competitor finish status with race time | `MarkFinished` |
| ● | DNF / DNS | Post-finish grace period, then remaining runners marked DNF; hard timeout | `RaceDirector` |
| ● | Out-of-bounds recovery | Boundary trigger teleports to the nearest recovery point | `TrackBoundary` / `RaceCompetitor` |
| ● | Reproducible race seed | `BeginRace(raceId)` — the AI mistake sequence derives from it *(Rev14.2)* | `RaceDirector:55` |
| ● | Results delay | Configurable pause before the results state fires | `RaceDirector` |
| — | Race formats | Only "N laps around a circuit" exists. Outrun, touge, knockout and pursuit/escape are specified in the research and **absent from the live tree**. |

---

# 3. Opponent AI

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Racing-line following | Waypoint line with nearest-point snapping and lookahead steering | `RacingLineAI` |
| ● | Speed control | Corner-radius-aware target speed, throttle/brake decision | `RacingLineAI` |
| ● | Deterministic mistakes | Per-instance `System.Random` seeded from (raceId, competitorId, baseSeed) — no global RNG | `RacingLineAI:62` |
| ● | Defensive positioning | Lateral offset when an opponent is within awareness distance | `RacingLineAI.DefensiveOffset()` |
| ● | Tactical state machine | Attack / Defend / Conserve / Recover | `RivalRaceBrain` |
| ● | Relationship-driven behaviour | Respect and fear scale brake-point bias, pass suppression, defensive error, launch delay | `RivalRaceBrain.ConfigureRelationship()` |
| ● | Per-rival ceilings | Each profile caps how far intimidation can push those four parameters | `RivalProfile` |
| ● | Physical weaknesses | Weakness types applied as real spec changes during the race, not difficulty modifiers | `RivalCareerRuntime.ApplyPhysicalWeakness()` |
| ● | `BrakeCapacity` weakness | Models brake fade under accumulated thermal load *(Rev14.3 — was a no-op default case)* | `RivalCareerRuntime` |

---

# 4. Rivals and career

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Six named rivals | Marsh, Duquesne, Osei, Reyes, Kade, Vogel | `RivalProfile` assets (builder-generated) |
| ● | Multi-era vehicle generations | 28 authored across the six (Marsh 7, Reyes 5, Vogel 5, Kade 4, Osei 4, Duquesne 3) | `RivalVehicleGenerationDefinition` |
| ● | Generation binding | Stats, mass, aero, grip and wear bound per era, rebound when the era moves *(Rev14.2)* | `RivalCareerRuntime` |
| ● | Persistent rival condition | Per-generation wear survives between encounters and feeds the next one | `RivalVehicleStateData` |
| ● | Relationship history | Respect, fear, race records, memorable events per rival | `RivalRelationshipData` |
| ● | Era / chapter / story beat | Career-level narrative position | `CareerData` |
| ● | Hero vehicle lineage | Persistent chain of hero cars across eras | `HeroVehicleLineageData` |
| ● | Reference lap capture | Rival best-lap telemetry, clipped to the real lap window, flagged when truncated *(Rev14.2)* | `RivalReferenceLapData` |
| ● | Rival dossier | `RivalCareerRuntime.BuildDossier()` public, calls `RivalDossierService.Build()`, scaled by real workshop knowledge *(Rev14.3)* | `RivalCareerRuntime.cs` |
| ○ | Rival roles / succession | `currentRole`, `retiredFromDriving`, `successorId` written every save, read nowhere | `RivalRelationshipData` |
| ○ | Reference laps as ghosts | Captured and persisted (80-lap cap); **nothing consumes them** | `CareerData.rivalReferenceLaps` |

---

# 5. Economy

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Cash balance | Cents-based, never negative | `CareerData.cashCents` |
| ● | Entry fees | Charged on race start, transactional across async aborts *(Rev14.2)* | `GameFlowController` / `CareerService` |
| ● | Race payouts | Win vs. finish vs. DNF tiers | `RaceRewardService` |
| ● | Idempotent rewards | `lastRewardedRaceId` guard survives resubscription and save/load | `RaceRewardService` |
| ● | Economy ledger | `totalEntryFeesPaidCents` / `totalRacePayoutsCents`, reversible | `CareerData` |
| ● | Repair costs | Quote derived from vehicle condition; paid before repair | `GarageService.GetRepairQuoteCents()` |
| ● | Reputation | Accrues from race results | `CareerData.reputation` |
| ● | Win/loss/races-completed | | `CareerData` |
| — | Two-axis gating | Reputation is tracked but **gates nothing**. No licence class exists. |
| — | Class brackets | No class points, no brackets, no lockout. |
| — | Property tiers | See §9. |

---

# 6. Garage and parts

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Unique component instances | Every part is a distinct physical object with its own id and history | `ComponentInstance` |
| ● | 19 component categories | Engine, FuelSystem, Cooling, Clutch, Transmission, Differential, Axle, Brakes, Suspension, Wheel, Tire, Aero, Electrical, Safety, Body, Chassis, Fabrication, Sensor, Unknown | `ComponentCategory` |
| ● | Multi-axis condition | Wear, fatigue, thermal damage, contamination, deformation, corrosion, lubrication health | `ComponentConditionData` |
| ● | Hidden vs. believed condition | True condition is simulation-only; the player sees belief + confidence | `ComponentConditionData` |
| ● | Install quality | Workmanship, torque accuracy, dimensional accuracy, cleanliness, seal quality, service confidence per installation | `ComponentInstallation` |
| ● | Transactional install | Validates ownership, rolls back cleanly on failure, restores the displaced part | `GarageService.InstallComponentInstance()` |
| ● | Ownership integrity | Duplicate/missing/disagreed ownership rejected at mutation *and* on save load | `ValidateOwnership` / `SaveGameService` |
| ● | Component history | Acquired / installed / removed / full-repair events with timestamps | `ComponentHistoryEvent` |
| ● | Wear from driving | Per-category health deltas pushed into installed components each physics tick | `ComponentWearRuntime` |
| ● | Operating hours | Accrues with elapsed running time for every installed part *(Rev14.2)* | `ComponentWearRuntime` |
| ● | Capability resolution | Installed parts resolve into a live spec: torque bottlenecks, fuel ceiling, cooling margin, brake torque, grip, aero, mass | `VehicleCapabilityResolver` |
| ● | Bottleneck reporting | Named limiting component per system with the numeric limit and an explanation | `VehicleCapabilityBottleneck` |
| ● | Full repair | Resets physical damage while preserving part identity and history | `ComponentConditionBridge` |
| ● | Legacy part bridge | Slot-based `InstallPart` retained for older UI, creates real instances underneath | `GarageService.InstallPart()` |
| ● | Component catalog | Definitions with mass delta, torque/rpm capacity, thermal, fuel power, brake torque, grip, cooling, aero, ratios, price | `ComponentDefinition` |
| ● | Platform compatibility | `SupportsPlatform()` enforced in `GarageService.CanFit()` on every install *(Rev14.3)*. Opt-in — no catalog means unchecked. | `ComponentDefinition` / `GarageService` |
| ● | Required-parts dependencies | `requiredSpecificationIds` enforced the same way; `LastInstallRejection` explains a refusal *(Rev14.3)* | `ComponentDefinition` / `GarageService` |
| ● | Component inspection | `InspectionService.Inspect()` called via `GarageOperationsService.InspectComponent()` with real capability figures; teaches the shop *(Rev14.3)* | `GarageOperationsService` |
| ● | Scrutineering | `ScrutineeringService.Evaluate()` called via `GarageOperationsService.Scrutineer()`; builder authors `FirstPlayableHomologation.asset` *(Rev14.3)* | `GarageOperationsService` |
| ● | Event logistics | `EventLogisticsService.Validate()` called via `GarageOperationsService.ValidateLoadout()`; builder seeds a tow rig and a loadout that fits *(Rev14.3)* | `GarageOperationsService` |
| ◐ | Powertrain catalog | `EngineSpec` / `TransmissionSpec` / `BuildRecipe` SOs with `Apply(VehicleSpec)`. **No assets, no callers — superseded by `ComponentDefinition`, recommended for deletion.** | `PowertrainCatalog` |

---

# 7. Vehicle intelligence and diagnostics

The deepest system in the project, and the one with no counterpart in the research docs.

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Sensor sampling | ~21 channels at 10 Hz: oil/coolant/gearbox temps and pressures, fuel pressure, boost, vibration, RPM, speed, per-wheel tyre and brake temps, wheel speeds, slip, yaw, g-forces | `VehicleSensorRuntime` |
| ● | Instrumentation tiers | Channel availability gated on the fitted sensor package (factory vs. aftermarket vs. motorsport) | `VehicleSensorRuntime` |
| ● | Sensor health states | Healthy / Degraded / Intermittent / Failed, with per-channel confidence | `SensorHealthState` |
| ● | Learned baselines | Windowed mean/variance per channel, tracks hardware changes *(Rev14.2)* | `SensorBaselineData` |
| ● | Gated learning | Only learns while mechanically healthy, instrumentation trusted, and no warning active | `VehicleSensorRuntime` |
| ● | Threshold alerts | High and low thresholds with warning/critical tiers, load-gated for pressure channels | `VehicleIntelligenceService.EvaluateAlerts()` |
| ● | Envelope anomalies | z-score against the learned baseline, restricted to health channels *(Rev14.2)* | `EvaluateAlerts` |
| ● | Alert recurrence | Occurrence counter on a stable alert identity; a cleared alert can recur | `SensorAlertData` |
| ● | Alert acknowledgement | `AcknowledgeAlert()` stops a known alert re-arming the recorder *(Rev14.2)* | `FaultRecorderRuntime` |
| ● | Diagnostic hypotheses | Ranked causes with probability, confidence, supporting/contradicting evidence, and a recommended next test | `DiagnosticIntelligenceService` |
| ● | Hypothesis retirement | Hypotheses whose supporting alert has gone are retired | `DiagnosticIntelligenceService` |
| ● | Evidence chain | Sensor alerts become evidence records linked to hypotheses; trimmed at 256 | `DiagnosticEvidenceData` |
| ● | Black-box fault recorder | Rolling pre-trigger buffer (~30 s) plus post-trigger capture, auto-armed on critical alerts | `FaultRecorderRuntime` |
| ● | Multi-fault recording | Distinct faults each get their own incident *(Rev14.2)* | `TryAutoTrigger` |
| ● | Fault reconstruction | Timeline of contributing events with warning lead time and a confidence-scored summary | `FaultReconstructionService` |
| ● | Incident history | Bounded store of reconstructed incidents | `FaultIncidentData` |
| ● | Self-test report | Per-system health check with status, detail, confidence and the responsible component | `VehicleSelfTestService` |
| ● | Instrumentation coverage | Unfitted channels reported once as an advisory, not as faults *(Rev14.2)* | `VehicleSelfTestService` |
| ● | Maintenance outlook | Per-component urgency, recommended action, estimated remaining hours from *believed* condition *(Rev14.2)* | `MaintenancePredictionService` |
| ● | Alert attribution | Specificity-scored channel→component matching *(Rev14.2)* | `MaintenancePredictionService` |
| ● | Engineering problem board | Open / Investigating / Solved entries with severity and candidate fixes; auto-retires *(Rev14.2)* | `EngineeringProblemBoardService` |
| ● | Learned-state retirement | Install, uninstall and repair retire the baselines, alerts, hypotheses and board entries for the affected hardware *(Rev14.2)* | `VehicleIntelligenceReset` |
| ○ | Calibration revisions | Structure only | `CalibrationRevisionData` |
| ○ | Operating modes | Structure only | `OperatingModeData` |
| ○ | Serviceability profile | Structure only | `ServiceabilityProfileData` |
| ○ | Chassis geometry nodes | Structure only — the intended damage-deformation model | `ChassisGeometryNodeData` |
| ○ | Visual repair marks | Structure only | `VisualRepairMarkData` |

---

# 8. Engineering lab (setup and tuning)

A separate scene with its own builder. Not part of the race loop.

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Instrumented test suite | 7 acceptance tests: acceleration, braking, skidpad, slalom, high-speed stability, suspension bump, coastdown | `VehicleLabTestType` |
| ● | Acceptance envelopes | Per-test pass criteria with target and limit values | `VehicleLabAcceptance` |
| ● | Test scoring | Normalised score per result against its envelope | `VehicleLabScoring` |
| ● | Diagnostic verdicts | Plain-language cause per failed test ("high-speed yaw instability: reduce steering sensitivity, improve aero balance, then damping") | `VehicleLabController` |
| ● | Single-parameter tuning | Closed-loop session: baseline, perturb, measure, recommend, preview, apply or roll back | `VehicleTuningEngine` |
| ● | Multi-parameter DOE | Design-of-experiments across parameters with interaction detection and a recommendation set | `VehicleMultiParameterTuningEngine` |
| ● | Setup archetypes | Drag, Circuit, Touge, Wet, Endurance, HighSpeed — each with weighted objectives | `VehicleSetupArchetype` |
| ● | Protected regression | Optimisation refuses to trade away more than a configured amount of any protected metric | `VehicleLabScoring.ProtectedRegression()` |
| ● | Setup memory | Remembers sessions keyed by build + track + archetype; builds priors for new contexts | `VehicleSetupMemoryService` |
| ● | Build fingerprinting | Vehicle identity as a comparable signature | `VehicleBuildFingerprint` |
| ● | Track fingerprinting | 10-axis track character: braking severity, straight length, technicality, bumpiness, surface grip, tyre energy, thermal load, aero sensitivity, traction demand | `TrackEngineeringAnalyzer` |
| ● | Track similarity | Ranked nearest-track search with a plain-language explanation | `TrackEngineeringProfileService.FindSimilar()` |
| ● | Observed-telemetry blending | Real driving data refines a track's authored fingerprint | `BlendObservedTelemetry()` |
| ● | Driver fingerprinting | 11-axis style: braking lateness/aggression, trail braking, throttle aggression and pickup, steering smoothness, correction frequency, oversteer tolerance, tyre abuse, mechanical sympathy, consistency | `DriverEngineeringAnalyzer` |
| ● | Driver-biased setup | Recommendations shift toward the driver's measured style | `DriverSetupAdvisor.ApplyBias()` |
| ● | Persistent databases | Track, driver and setup memories persist to JSON with prune, export, import and merge | three `*MemoryService` classes |
| ● | CSV / JSON export | Session and telemetry export | `VehicleLabTelemetryExporter`, `ExportCsv/ExportJson` |
| ● | Lab HUD | On-screen test control and readout | `VehicleLabHUD` |

**Not the dyno.** This is an automated acceptance-test and optimisation harness.
The research's dyno (`31-DYNO-ANALYSIS.md`) is a player-facing torque-curve
instrument, and it does not exist in the live tree.

---

# 9. Progression systems

Nine collections were serialized into every save and read by nothing. Pass 3
(`GarageOperationsService`) gave seven of them real readers and writers; two
remain genuinely unbuilt features and are marked `RESERVED` in source rather
than fake-wired.

| | Feature | Research system | Where |
|---|---|---|---|
| ● | Tool ownership | part of §15 two-axis gating | `GarageData.tools` → `WorkshopCapability.toolQuality01` |
| ● | Facility capability | §18 property tiers | `GarageData.facilities` → `WorkshopCapability.facilityLevel01` |
| ● | Mechanic staff | §18 property tiers | `GarageData.mechanics` → `WorkshopCapability.mechanicSkill01` |
| ● | Transport assets | logistics | `GarageData.transportAssets` → loadout capacity check |
| ● | Event loadouts | logistics | `GarageData.eventLoadouts` → loadout capacity check |
| ● | Mechanical knowledge | §15 gating | `GarageData.mechanicalKnowledge` — accrues from inspecting/installing |
| ● | Builder reputation | §15 gating | `GarageData.builderReputation` — accrues from installs, repairs, race finishes |
| ○ | Customer jobs | §20 shop-driver tier | `GarageData.customerJobs` — **RESERVED, genuinely unbuilt** |
| ○ | Specialist relationships | — | `GarageData.specialistRelationships` — **RESERVED, genuinely unbuilt** |

Note: none of these seven are "gating" anything yet in the sense §15 and §18
specify — reputation and knowledge now move and feed inspection/install
quality, but there is still no licence class, no property tier that unlocks
anything, and no UI surface for any of it. Wired is not the same as playable;
see the production-readiness review.

---

# 10. Persistence

| | Feature | Detail | Where |
|---|---|---|---|
| ● | JSON save/load | Single envelope containing career + garage | `SaveGameService` |
| ● | Schema versioning | Currently **schema 7** | `SaveEnvelope.CurrentSchema` |
| ● | Migration chain | Contiguous 1→7, each step validated; rejects newer-than-supported saves | `SaveMigrator` |
| ● | Legacy wear migration | Schema-4 step maps old per-category health onto migrated component instances | `LegacyConditionForCategory` |
| ● | Backup and recovery | Primary save with a `.bak` fallback and a reported recovery message | `SaveGameService.Load()` |
| ● | Integrity validation | Negative cash, negative ledger, and component-ownership inconsistency all rejected on load | `Validate()` |
| ● | Auto-save on results | Saves at end of frame after all result handlers have run | `GameFlowController` |
| ⚠ | Non-atomic write | Delete-then-move rather than `File.Replace`; a validation failure silently starts a new career whose next two saves overwrite both copies | `SaveGameService.Save()` |

---

# 11. UI and developer tooling

| | Feature | Detail | Where |
|---|---|---|---|
| ● | Vertical-slice HUD | Garage / race / results modes, repair and race actions, cash and condition readout | `VerticalSliceHUD` |
| ● | Developer HUD | Compact and full modes; per-wheel load, slip, force use, temps; race state, positions, economy | `DeveloperHUDController` |
| ● | HUD auto-wiring | Finds its own data sources in the scene | `DeveloperHUDDataSource.AutoWire()` |
| ● | Chase camera | Follows the player vehicle | `VehicleCameraRig` |
| ● | Touch/keyboard input | Throttle, brake, steer, handbrake | `PlayerVehicleInput` |
| ● | First-playable builder | Generates the whole scene from code: track, cars, services, HUD, content assets | `Rev10FirstPlayableBuilder` |
| ● | Lab builder | Generates the tuning-lab scene | `VehicleLabBuilder` |
| ● | Auto-bootstrap | Builds the first-playable scene on first editor load if absent | `Rev10FirstPlayableAutoBootstrap` |
| ● | Content validators | Rival/career canon, serialized content, vertical slice, lab wiring | 4 validator classes |
| ● | Track profiler | Editor menu to fingerprint tracks and export JSON | `TrackEngineeringProfiler` |
| ● | Structural validator | 26 real checks, exits non-zero on failure *(Rev14.2)* | `Scripts/validate_rev14_structure.sh` |

---

# 12. Content actually authored

**Zero `.asset`, `.unity` or `.prefab` files ship.** Everything below is generated
at edit time by the builders.

| Content | Built | Specified in research |
|---|---|---|
| Hero car generations | **1** (1965) | 7 |
| Rival profiles | 6 | 6 |
| Rival vehicle generations | 28 | 28 |
| Tracks | **1** (8 checkpoints) | 8 (4 road courses, drag strip, standing mile, 3 oval tiers) |
| Race formats | **1** (lap race) | 4 |
| Build recipes | **0** | 35 |
| Component definitions | ~10 baseline parts | full parts catalogue in `47-PARTS-PRICING.md` |
| Events | **1** | act structure across 7 eras |

14 `CreateAssetMenu` content types are defined and authorable; assets exist for
none of them until a builder runs.

---

# 13. Testing

| | Feature | Detail |
|---|---|---|
| ● | EditMode suite | **92 tests** — migration, economy, mechanical foundation, vehicle intelligence, rival career, deep audit, serialization safety, diagnostics retirement, tuning, setup memory, track/driver engineering |
| ● | PlayMode suite | **20 tests** — race lifecycle, physics bounds, runaway clamping, economy transactions, reward idempotency, persistence round-trip, 100-race ledger stability, AI lap completion |
| ● | Structural validation | 26 checks including assembly graph, serialization hazards, save-schema chain, capability enforcement chain |
| ⚠ | Never executed | Unity has not compiled or run any of it. |

---

# Counts

| Status | Count |
|---|---|
| ● Live | **~140** (Rev14.3, up from ~118) |
| ◐ Implemented but unreachable | **4** — `EngineSpec`/`TransmissionSpec`/`BuildRecipe`/`ContentCatalog`, all superseded and recommended for deletion |
| ○ Data only | **5** — `customerJobs`, `specialistRelationships`, `operatingModes`, `serviceability`, `chassisGeometry` — RESERVED, genuinely unbuilt |
| ◌ Prototype only (not compiled) | **4 major systems** |

Rev14.1 → Rev14.3, EditMode tests: 92 → 106 → **106** (unchanged since; see §13).

**Structural health:** 35 live MonoBehaviours, all 35 placed by a builder — no
orphaned runtime components. 12 assemblies, zero dependency cycles, zero missing
references, zero duplicate type names.

**The shape of it:** the mechanic-simulation half is deep and largely complete —
component instances, wear, diagnostics, capability resolution, setup engineering.
The racing-game half is a single working lap race. The progression half is mostly
serialized structures with no behaviour behind them.

For how this maps onto the 21 designed systems and what it implies for
sequencing, see `WHERE-WE-ARE.md`.
