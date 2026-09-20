# Extraction Inventory

What to take from each open-source project. Check `01-LICENSING.md` before
copying anything.

---

# 1. Randomation Vehicle Physics (RVP) — MIT code, PD art

github.com/JustInvoke/Randomation-Vehicle-Physics
Richest single source. Originally Unity 5.6, last tested 2019.2.9.

## Drivetrain
- **`DriveForce`** — carries RPM and torque through the drivetrain, with a
  feedback RPM propagating backward from the wheels. Architectural spine.
- **`GasMotor`** — torque curve (x-axis = thousands RPM), inertia, reverse,
  output drives, drive-divide-power exponent for splitting torque.
- **`GearboxTransmission`** — gear array (ratio / minRPM / maxRPM). Negative
  ratio = reverse, zero = neutral. Auto/manual, shift delay in physics steps,
  `CalculateRpmRanges()` derives shift points from the torque curve.
- **`ContinuousTransmission`** — CVT, min/max ratio with target interpolation.
- **Top-speed formula:** max engine RPM / last gear ratio / (Pi * 100) *
  driven wheel circumference. x2.23694 for mph, x3.6 for km/h.

**Missing:** no differential, no clutch. Get both from TORSION.

## Suspension — nearly your whole tuning list
Spring force + compression-keyed force curve, spring exponent, damping, extend
speed. Geometry: camber curve across travel, camber offset, solid-axle camber
with opposite-wheel reference, caster, toe, side angle, pivot offset, steer
range min/max. Per-corner brake and ebrake force, hard-contact force on
bottoming out, damage pivot.

**`Ackermann factor`** — approximation making inside wheels steer sharper
through a turn. Fiddly to derive; free here.

**`SuspensionPart`** — drives visible geometry (control arms, pushrods) by
pointing at a connect object, optional stretch, solid-axle support.

## Tire model
- Separate **forward and sideways friction curves** (x = slip, y = friction),
  each with a stretch multiplier.
- **`Slip dependence` enum** — Dependent / Sideways / Forward / Independent.
  Controls whether losing sideways grip costs forward grip. Sideways is the
  documented default. Thoughtful design you'd otherwise have to invent.
- **Normal friction curve** keyed to ground-normal dot world-up — stops cars
  gripping walls and steep banks.
- **Compression friction factor** — load sensitivity.
- Tire radius, rim radius, tire width, rim width, and **tire pressure as an
  interpolation between rim and tire radius**.
- **RPM bias curve** — how strongly the wheel snaps to target RPM vs its
  velocity-derived RPM, based on applied torque and brake force. Raise on driven
  wheels to stop automatics oscillating between gears.
- Axle friction, friction smoothness (jitter control).

## Aero
**`VehicleAssist`** carries downforce with a **speed-keyed downforce curve**,
plus invert-in-reverse and apply-in-air toggles. Your aero starting point.
Same script: drift spin assist + curve, auto-steer drifting (documented as
useful for accelerometer steering on mobile), drift push, straighten assist,
auto roll-over with raycast detection, angular drag on jump, fall speed limit.

## Damage and parts (on-premise for a mechanic protagonist)
- **`VehicleDamage`** — real-time mesh deformation, optional Perlin noise,
  seamless edge alignment between adjacent parts, normal recalculation, six
  `ApplyDamage()` overloads, `Repair()`. Motors and transmissions lose output as
  they take damage; fully damaged motor stops driving, fully damaged
  transmission stops shifting.
- **`DetachablePart`** — hinge-joint attach with separate loose force and break
  force thresholds.
- **`ShatterPart`** — glass and lights, with a "seam keeper" so broken windows
  leave shards at the edges.

## Surfaces and effects
- **`GroundSurfaceMaster`** / `GroundSurfaceInstance` / `TerrainSurface` — named
  surface types with friction, tire sound, rim sound, always-scrape and spark
  flags. `TerrainSurface` maps types onto painted terrain textures, exposes
  `GetDominantSurfaceTypeAtPoint()`.
- **`TireMarkCreate`** — skid mark mesh generation, per-surface materials,
  debris particles (dirt, tire smoke), rim sparks.
- **`TireScreech`**, and a **tire shader** with deform map + deform normal that
  squashes tire geometry under load.

## AI
**`FollowAI`** — waypoint driving or object following, stuck detection, timed
reverse attempts, reverse-attempt count before reset, roll-over reset.
**`VehicleWaypoint`** — next point, radius, per-waypoint percentage of top speed
(effectively a racing-line speed profile).

> **Generating the waypoints themselves, rather than hand-placing them:**
> Beckman Parts 17–18 (`34` Part 1e) work a complete racing-line optimisation by
> hand — corner geometry, a traction-circle-constrained search over throttle
> ramp time and steering-unwind time, converging on an optimum roughly 0.3s
> better than a naive line.
>
> **This was actually attempted — see `code/prototype/RACING-LINE-ATTEMPT.md`
> for the full honest account.** Reproducing Beckman's exact numbers failed
> (no spreadsheet exists for this article, confirmed by search). A
> from-first-principles alternative using this project's own tyre model works
> and is structurally validated for wide corners, with a known, clearly-marked
> limitation for tight ones. Read that document before using either script.
>
> **Characterising a rival's handling balance for `30` §3.2:** `35` §5.1
> covers `TUMFTM/YawMomentDiagrams` (LGPL-3.0), an open implementation of the
> Milliken Moment Method with a documented Stability Diagram output — change
> of yaw moment with respect to body slip angle, positive meaning a stable
> reaction to a disturbance. A working reference for generating the readable,
> distinct handling profiles the six persistent rivals need.

## Scoring (your action layer, mostly built)
**`StuntManager`** / **`StuntDetect`** — drift scoring with a connect delay so
linked drifts count as one, jump distance scoring, stunt array where each stunt
is defined by rotation axis, precision (dot threshold), angle threshold, score
rate, repeat multiplier. Drifts and stunts award nitrous boost. Crashes cancel
combos.

**This code finally has a game design attached** — `50-ACTION-PILLAR-
EXPANDED.md` Part 2 specifies which stunts exist (including a new
close-call type built free from the instability meter's existing fill
level), what nitrous actually does mechanically, and — deliberately —
which of the three race formats this activity is active in and which
it isn't.

## iOS-specific
- **`MobileInput` / `MobileInputGet`** — UI button input plus accelerometer
  steering with separate steer and flip factors, delta factor for rate-of-change,
  screen orientation locking.
- **`VehicleParent.wheelGroups`** — spreads wheel raycasts across multiple
  FixedUpdates instead of all in one. Documented as a large perf win at the cost
  of precision, recommended for AI vehicles. Real budget on mobile with a full grid.

## Camera / HUD / utility
`CameraControl` (obstruction raycasting, flat-camera mode); `VehicleHud`
(speedometer, gear, RPM, boost); `VehicleMenu` (vehicle spawning/selection);
`TimeMaster` (adjusts fixed timestep with time scale, pitches all audio to
match — slow-mo for free); `PropertyToggleSetter` / `SuspensionPropertyToggle`
(vehicle modes); `GizmosExtra.DrawWireCylinder()`;
`MeshUtil.CalculateMeshTangents()`; `VehicleBalance` (motorcycle leaning, author
flags as not fully stable).

## Art and audio
Prefabs: muscle car, RWD car, F1, monster truck, big rig with tow joint,
motorcycle, hover car, "special car" demoing steering modes. Models and textures
public domain. **Audio is mixed-license — see 01-LICENSING.md.** Roboto is Apache.

## Adoption cost
Built-in render pipeline — **the tire shader needs a URP rewrite**. Unusual
conventions: rigidbody mass defaults to 1 (range 0.5–10), discrete collision
detection, vehicle scale must be 1 on all axes. Requires specific tags
(`Pop Tire`, `Underside`), layers (`Ignore Wheel Cast`, `Vehicles`,
`Detachable Part`), and a **mandatory script execution order**.

---

# 2. TORSION Community Edition — MIT (bundled in `code/TORSION-MIT/`)

Ten files, ~700 lines. Small, but exactly what RVP lacks.

- **`Clutch.cs`** — `clutchTorqueCapacity`, `clutchStiffness`, `clutchDamping`,
  `clutchEngagement`, `slip`, `clutchTorque`. A real friction-clutch model.
- **`Engine.cs`** — `torqueCurve`, `idleRPM`, `redlineRPM`, `inertia`,
  `initialFrictionTorque`, `frictionLossCoefficient`, `throttleStability`,
  `throttleCutoffDuration`, `starterTorque`. Proper rotational inertia and
  friction losses; more physical than RVP's `GasMotor`.
- **`Gearbox.cs`** — `gearRatios` array, `shiftDuration`, `inGear` flag,
  `ShiftUp`/`ShiftDown` coroutines so shifts take real time.
- **`Wheel.cs`** (260 lines) — raycast suspension (`restLength`,
  `springStiffness`, `damperStiffness`), `wheelInertia`, `wheelAngularVelocity`,
  `fX`/`fY`/`fZ` force decomposition.
- `Steering.cs`, `Visuals.cs`, `EngineAudio.cs`, `CameraController.cs`, `Vehicle.cs`.

**`Differential.cs` is a stub — know this going in.** 18 lines, `finalDriveRatio`
only, both methods commented `// Open Differential; Uncomment once drivetrain is
complete`. Teaching scaffold. You build the LSD / locked / torque-biasing
behaviour on top.

**THE MOST VALUABLE IDEA IN THIS ENTIRE SURVEY:**
Every drivetrain component exposes `GetDownstreamTorque()` and
`GetUpstreamAngularVelocity()`. Torque flows toward the wheels; angular velocity
flows back toward the engine. That bidirectional coupling is how real drivetrains
are modelled, and it's what allows a clutch and differential to work correctly.
RVP's `DriveForce` approximates it; TORSION does it properly. If you take one
thing, take this architecture.

Companion YouTube series builds it from scratch. Active vehicle-physics Discord.

---

# 3. Unity ECS Network Racing Sample — Unity Companion License

Unity 6000.2.11f1, project v3.0.0, actively maintained. Uses
**`com.unity.vehicles`** — Unity's first-party vehicle physics package.
**Note: ECS-only, experimental preview, and Unity states it targets "a medium
level of vehicle physics realism."** Not a path for this project (`02`). The
sample's *race system designs* remain valuable; the vehicle package does not.

File index in `code/ecs-sample-file-index.txt`.

## Race systems (strongest part)
- `CheckPointLocatorAuthoring`, `CheckPointTriggerAuthoring`,
  `PlayerCheckPointSystem`, `RaceTriggerCheckPointSystem` — checkpoint-gated lap
  validation. Cheat-resistant by construction; can't skip geometry.
- `PlayerProgressSystem` + `PlayerProgress` — live position and ranking
- `RaceStateSystems`, `RaceTimerSystem`, `RaceBootstrapSystem` — race lifecycle
- `LevelBoundsAuthoring` + `VehicleBoundsCheck` + `PlayerTeleport` — OOB respawn
- `Leaderboard`, `LeaderboardPanel`, `AddLeaderboardData`

## Vehicle
- `VehicleControlPredictionSystem` — client-side prediction for vehicles, the
  genuinely hard part of racing netcode
- `VehicleChasesDownForce`, `VehicleInputSystem`, `InputClientInitializerSystem`,
  `WheelsReferenceAuthoring`
- **`Components/AnimationCurve.cs`** — Burst-compatible animation curve for ECS.
  Unity's `AnimationCurve` is managed and won't work in jobs. Solves a real problem.

## Garage screen skeleton
`CarSelectionAuthoring`, `CarSelection` component + system, `PlayerSkins`,
`UpdateCarSkin`, `CarSelectionUI`.

## UI
`HUDController`, `RaceCountdownUISystem`, `UpdateFinishTimer`, `UpdateUISystem`,
`Fader`, `Popup`, `InfoPanel`, `LoadingScreen`, and **`UIMobileInput.cs`** —
mobile touch input in an official Unity racing sample.

## Camera
`CameraSwitcher`, `UpdateCameraTargetSystem`, `UpdateEndRaceCameraSystem`,
`TimelineManager`, plus menu and lobby variants.

## Netcode (if ever needed)
`NetcodeBootstrap`, `GoInGameSystem`, `ServerConnectionUtils`,
`AutoConnectAuthoring`, `TimeoutServerAuthoring`, `NetcodeSpawnerAuthoring`,
`ResetTransformAuthoring`, `LobbyController`, full Vivox voice chat.

## Free tooling
`Internal/ExportTerrain.cs`, `Internal/HiResScreenShots.cs` — terrain exporter
and high-res screenshot tool (your App Store marketing shots).

**Catch:** DOTS/ECS end to end. RVP and TORSION are MonoBehaviour-based. You
cannot paste these systems into a MonoBehaviour project — designs transfer, code
does not. Known issue: long build times because all shader variants compile.

---

# 4. CrazyCar — MIT (schema bundled in `code/CrazyCar-MIT/data.sql`)

Java/SpringBoot + MyBatis Plus server, Vue + Element admin, Unity client.
You won't copy code — you copy the **data model**. No other project in this
ecosystem has progression plumbing.

## The catalog-plus-ownership pattern, repeated three times
- `equip` / `equip_record` — parts and cars catalog vs what a player owns
- `avatar` / `avatar_record` — cosmetics catalog vs owned
- `match_class`, `time_trial_class` + their `_record` tables — event tiers vs
  a player's results in each

Actual columns:
```
equip:         eid, rid, equip_name, star, mass, power, max_power,
               can_wade, is_show
equip_record:  id, eid, uid, update_time
user:          uid, user_name, user_password, login_time, aid, star, is_vip, eid
match_record:  id, uid, cid, complete_time, record_time
```

Note `user.eid` and `user.aid` = currently equipped car and avatar; the `_record`
tables are the ownership ledger. That split is exactly how you model your garage,
upgrade tiers, and property progression.

## Everything else worth taking
- `time_trial_record` + `time_trial_class_record` — per-tier leaderboards
- `match_map` — track registry
- `user_login_record`, `LoginService`, `TokenFilter` — auth plus daily-login
  tracking (substrate for login-streak rewards)
- **`assets_updating` + `version` tables, `AssetsUpdatingController/Service`,
  `VersionController/Service`** — asset hot-update and version gating. How you
  ship new cars without an App Store submission. Directly relevant to iOS.
- `MailService` + `MailScheduledTask` — in-game mail for delivering rewards
- Networking: `MatchWebSocket`, `MatchRoomWebSocket`, `TimeTrialWebSocket`,
  `KCPRttController`, `NetType` — WebSocket plus KCP for low-latency UDP
- Client uses QFramework split into `Command` / `Query` / `Event` / `Model` /
  `System` layers — good reference for a Unity game with heavy persistent state
- Generic `SkillSystem` (`Deployer` / `Selector` / `ImpactEffects`) — adaptable
  to car perks or driver abilities

Full backend class list in `code/CrazyCar-MIT/backend-class-index.txt`.
Docs primarily Chinese; `README_en.md` exists.

---

# 5. Read-only references

**PERRINN Project 424** — no license. Study the telemetry UI, autopilot, and ML
speed estimator (ONNX model trained from telemetry CSV). Copy nothing.

**Ishaan35's Mario Kart** — Nintendo-derived, verify license, copy nothing.
The AI approach is worth stealing conceptually: path node collections placed
around each track with large hitboxes to detect passage, which doubled as the
ranking system, then randomised which path each AI got so the field feels less
robotic. One solution, two problems.

**GolfRomeo** — terrain-brush track editor with alphamap PNG import/export;
TrackRecord lap-time structure (car + driver name).

**Easy-Road-3D-ECS-Traffic** — DOTS traffic sim. Only open-source Unity traffic
implementation found. Relevant if street racing includes traffic to dodge.

---

# Recommended assembly

1. **TORSION's drivetrain** (MIT) as engine / clutch / gearbox / diff foundation.
   Extend the differential stub into a real LSD.
2. **RVP's suspension, tire friction curves, surfaces, tire marks, damage** (MIT)
   around it.
3. **VPP Community Edition as a desktop feel benchmark only** — it is
   desktop-build-only, 1 vehicle per scene, single ground material, so it cannot
   ship. Drive it to learn what a correct tyre model feels like, then judge RVP
   against it. For a shippable alternative, price **VPP Professional**.
4. **CrazyCar's schema** as your progression data model, reimplemented locally
   in ScriptableObjects + save data, or on a backend if you go online.
5. **ECS sample's checkpoint / progress / race-state designs**, rewritten in
   MonoBehaviour form. Read `AnimationCurve.cs` and `UIMobileInput.cs` regardless.
6. **Nothing from PERRINN 424.**

## The gap nobody fills
No open-source racing project implements a garage/property progression economy,
upgrade trees, part-level tuning persistence, or a career structure. That's the
part with no prior art — and the part that differentiates your game. The physics
you can learn from others; the progression you build alone.
