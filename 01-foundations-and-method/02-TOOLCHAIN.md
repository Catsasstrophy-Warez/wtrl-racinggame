# Toolchain: Mac vs Windows

**Governing rule:** Windows is where you make the game. Mac is where you prove
it works. Nothing lives on the Mac that you'd want to touch daily.

---

## Windows — authoring machine

**Engine.** Unity 6 LTS. As of Aug 2026 that's 6.3 LTS (supported through Dec
2027); 6.7 LTS expected. Verify in Unity Hub before locking in. Do not upgrade
mid-project without a full test pass on a clone.

**Render pipeline: URP, not HDRP.** Most consequential early decision. HDRP does
not target mobile at all. If you have prototyped in HDRP, every material and
light needs rebuilding. Lock URP now.

**IDE.** JetBrains Rider — free for non-commercial use, better Unity integration
than Visual Studio (ScriptableObject navigation, `[SerializeField]` awareness,
perf warnings inside `Update()`). VS Community is the fallback.

**Vehicle physics — buy or adopt, don't build from zero.**
Unity's built-in `WheelCollider` has no real tire model, no differential, no aero.
Options in rough order of preference:
- **RVP + TORSION** (MIT, both bundled/cloneable) — **the default.** Free, ships
  anywhere. Missing a real differential; needs a URP shader port.
- **VPP Professional / Enterprise** — has everything, ships to mobile. Quote-based
  pricing; ask. If tuning depth is genuinely the product, this may be worth more
  than months of your time.
- **NWH Vehicle Physics 2** — paid, mobile-capable, deep

### Two options to rule out, and why

**VPP Community Edition — desktop builds only, 1 vehicle per scene, single
ground material.** Cannot ship on iOS, cannot run an AI field, cannot do
surface-dependent grip. **Excellent as a desktop feel benchmark; not a
foundation.**

**`com.unity.vehicles` — ECS-only, experimental preview, and Unity states it
"targets a medium level of vehicle physics realism."** Medium by design is the
wrong tool when depth is the differentiator — and adopting it means abandoning
TORSION and RVP for a data-oriented rewrite.

### The rigid-body-plus-curve-fit approach itself — closed, not open

Beyond ruling out specific packages above, the deeper architectural choice
this whole section rests on — rigid-body simulation with curve-fit tyres,
rather than BeamNG-style soft-body node-and-beam simulation — is now
**doubly confirmed, not just assumed for cost reasons.**

`35-EXTENDED-SOURCES.md` Part 4 gives the cost-side argument: 2,000Hz
soft-body simulation is not viable on a phone.

`39-MECHANIC-GAMES-SPECTRUM.md` Part 5 adds the independent second leg:
**BeamNG's own players have spent years asking for the ability to cleanly
remove an already-broken part without resetting the vehicle, and
structurally can't get it** — node-beam simulation has no native concept
of a discrete "part" to remove. This project's discrete-named-parts
approach isn't only what a phone can afford; it's what players have
demonstrably wanted even inside the game that can't provide it.

**Decided on both legs. Not revisited without new information on both.**
- **NWH Vehicle Physics 2** or **Edy's Vehicle Physics Pro** (paid, few hundred USD)
- **TORSION** (MIT) + **RVP** (MIT) assembled yourself — see 04-EXTRACTION-INVENTORY

**3D:** Blender (free). Car modelling dominates art time regardless of tool.

**Texturing:** Substance 3D Painter (~$25/mo). Dominant in automotive — car paint,
flake layers, clearcoat. The one paid seat worth arguing hardest for.

**Audio:** FMOD Studio (free under $200k revenue). Engine sound is RPM-crossfaded
layers driven by load and throttle, not a loop — FMOD is built for this.
Reaper ($60) for recording and editing source.

**GPU debugging:** RenderDoc (free). Also captures Android frames.

**Version control:** Unity Version Control (ex-Plastic SCM), free up to 3 users.
Handles multi-GB binaries and file locking; Git+LFS works but you'll fight it.

**Sidecar hardware:** a mid-range Android phone. Build IL2CPP + ARM64 + your
shipping stripping level. Catches most AOT and linker failures on a device you
can iterate against in minutes. **Decided: Android ships eventually, as a
planned second platform** (`03`) — this device is not a disposable iOS testing
proxy, it is the first unit of hardware the future port ships on. Worth
choosing deliberately (a genuinely representative mid-range device, not
whatever's cheapest) and worth keeping the thermal/performance data from
iOS-era testing rather than treating it as throwaway debug output.

---

## Mac — verification and shipping machine

Deliberately short list.

- **Xcode 26 or later.** App Store submission floor since 28 Apr 2026 (iOS 26 SDK
  or later). Drags macOS with it — Xcode 26.6 requires macOS Tahoe 26.2.
- **Unity, byte-identical version to Windows.** Not "same major version" — the
  same build number. A mismatch forces a full Library reimport on every switch.
- **Instruments** — Time Profiler, Allocations, Energy Log, thermal state.
- **Metal Debugger / GPU frame capture** — per-draw-call cost, shader timing,
  bandwidth. Apple's tile-based deferred GPUs differ enough from Adreno/Mali that
  Android RenderDoc numbers do not transfer.
- **TestFlight** for playtester distribution.

---

## Connective tissue (where projects actually break)

1. **Force text serialization + visible meta files** before your first commit.
   Project Settings > Editor. Otherwise scenes and prefabs are binary blobs and
   every conflict is unresolvable.
2. **Ignore** `Library/`, `Temp/`, `Logs/`, `obj/`, `Builds/`. The Library folder
   is a derived cache; syncing it across two OSes causes strange corruption.
3. **Never edit the same scene or prefab on both machines.** The Mac is
   read-mostly: pull, build, profile, note, fix on Windows.

---

## Data layer — matters more than usual for a sim + action + RPG stack

- **Every tunable number in ScriptableObjects.** Car stats, upgrade tiers, part
  costs, garage/house/shop/warehouse tiers, race rewards, AI difficulty curves.
- **Build a CSV or Google Sheets import pipeline into those ScriptableObjects,
  early.** Balancing means changing forty numbers and replaying. Doing that one
  Inspector field at a time is how economies end up unbalanced — not because you
  couldn't tune them, but because tuning was tedious enough that you stopped.
- **In-game telemetry HUD from day one.** Live tire slip angle, downforce,
  per-wheel loads, gear, torque at the wheels. You cannot tune suspension
  geometry or diff preload by feel, and on mobile you can't attach a desktop
  debugger mid-race.

---

## Budget

**Free:** Unity Personal, Blender, VS Community, FMOD, Audacity, RenderDoc,
Unity Version Control, RVP + TORSION (MIT). VPP Community Edition is free but
desktop-only — useful as a feel benchmark, not shippable.

**Worth paying for:** vehicle physics package if not using the free tier
(few hundred, one-time), Substance Painter (~$25/mo), Reaper ($60).

**Hardware:** used Apple Silicon Mac mini + a two-generation-old iPhone. Together
cheaper than a year of cloud Mac rental, and unlike cloud they can do the thermal
and frame-pacing work.
