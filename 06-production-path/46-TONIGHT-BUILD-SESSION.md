# Tonight's Build Session: Ordered Checklist

**What this is.** Everything needed for the first Unity session,
consolidated into one sequence. Nothing new — every step below traces
to a document or file that already exists. This just puts them in the
order to actually execute them tonight, so nothing gets found by
searching mid-session.

---

# Before opening Unity

**Unity 6**, installed.

**A clean clone of RVP** — do not run the migration script against a
copy you've already modified; it's tested against a clean checkout
(`RVP-TRIAGE.md`).

**Two test devices in the room**: one 60Hz iPhone, one Pro-tier
ProMotion iPhone. `03-physics-research/36-IPHONE-SPECIFIC.md` §2.3 — the pass/fail result
may genuinely differ between them, so both need to be present tonight,
not just one with a plan to check the other later.

---

# Step 1 — Migrate the API surface

**On Mac or Linux, or Windows with Git Bash / WSL** (Git Bash ships with
Git for Windows and is the recommended path — it runs the exact script
below, already tested, unchanged):

```
cd <your RVP checkout>
bash migrate-to-unity6.sh Assets/Scripts
```

**On Windows without Git Bash or WSL**, use `migrate-to-unity6.ps1`
below instead — a PowerShell port of the same script. **Read the
honesty note in its own header before trusting it equally**: the bash
version was actually run against a disposable RVP checkout and verified
clean (`code/prototype/RVP-TRIAGE.md`); the PowerShell port has not been
executed anywhere in this project, only written and reasoned through
against the same logic. Same status as the C# prototype code generally
— treat it as a strong first draft, not a tested tool, until it's
actually run once.

Either version: dry-run first, prints every change, asks for
confirmation before touching anything. But **let the Unity compiler
have the final word**, not either script's own confidence. Fix whatever
it catches that static analysis in `RVP-TRIAGE.md` couldn't see.

**Expected**: ~27 sites across ~13 files, all mechanical renames
(`velocity`→`linearVelocity`, `drag`→`linearDamping`/`angularDamping`,
three `FindObjectOfType` calls). If the count is meaningfully different
from that, RVP's `master` has moved since the triage — not alarming,
just worth noting before continuing.

## Everything else is cross-platform, no porting needed

Worth stating plainly rather than leaving implicit: the six C# scripts,
`Tire-URP.shader` (ShaderLab/HLSL), and the Unity project itself are
fully cross-platform — nothing about moving from Mac to Windows (or the
reverse) touches any of them. **The migration script is the only
Mac/Linux-authored piece in this whole session that needed a Windows
counterpart.** If the simulation scripts in
`code/prototype/simulation/` are wanted on Windows too, they need
Python installed (`numpy`, `matplotlib`) — unrelated to the Unity build
itself, since that suite is validation-only and never touches the
actual project.

---

# Step 2 — The shader

Paste in `Tire-URP.shader` in place of RVP's original `Tires.shader`.

**Known open item, check it now rather than after the fact**: the
deformation math was ported using world-space transforms where the
original used object-space via `unity_WorldToObject` — flagged in the
shader's own comments as a judgment call, not a literal translation.
**Look at the tyre under load tonight and confirm the deformation reads
correctly** before trusting it further. If it looks wrong, that's the
first place to debug, not the physics.

`Tires-Bump.shader` still needs its own pass — the porting note at the
bottom of `Tire-URP.shader` covers exactly what's needed (occlusion map,
normal map, tangent-space basis; the vertex function itself needs no
changes since it's identical between the two originals).

---

# Step 3 — Wire in the prototype code

Import, in this order (later ones depend on earlier ones):

1. **`TireForceModel.cs`** — create one `TireCompound` asset via the
   `Create → Vehicle → Tire Force Model (Beckman)` menu. Start from the
   shipped defaults; they're already corrected (`latB` fixed from the
   simulation-found bug, `03-physics-research/34-PHYSICS-READING.md`).
2. **`EngineFamily.cs`** / `EngineVariant` — create one `EngineFamily`
   asset and one `EngineVariant` asset for the 1965 hero car, using the
   concrete values from `43-FIRST-PLAYABLE-SPECS.md` Item 4 (164hp,
   5500rpm redline, cross-plane, no forced induction).
3. **`TransmissionSpec.cs`** — one asset, 3-speed manual, per `43` Item 4.
4. **`RaggedEdgeMeter.cs`** — attach to the car, wire `vehicleBody` and
   `wheels` to the real RVP components, `tireModel` to the asset from
   step 1. **Read the integration note in the script's own header
   before wiring anything** — the meter, the dyno, and the car's actual
   driving must all read the same tyre model, or you reproduce
   Underground 2's exact failure (`31` §2.3).
5. **`DynoController.cs`** — attach to the garage's dyno station,
   `engine` to the car's real `Engine` component, `tireModel` to the
   same asset again.
6. **`EngineBayMeshManager.cs`** — attach to the engine bay, populate
   `partMeshes` from whatever the hero car's engine bay prefab has.
   Leave this for last; it's cosmetic/performance, not load-bearing for
   tonight's actual test.

---

# Step 4 — Confirm the car drives

Not well. Correctly. Press play, drive it. Nothing needs to be tuned
yet — just confirm wheels turn, the car responds to input, nothing
explodes on contact.

**If this fails**, stop here for tonight. Everything below assumes a
driving car.

---

# Step 5 — The actual test

`43-FIRST-PLAYABLE-SPECS.md` Item 3's exact protocol:

1. On the dyno, record the baseline torque curve and benchmark
   corner-exit time (`DynoController.GetTorqueCurvePoints()`,
   `RunStraightLineBenchmark()`).
2. Change **one differential setting only** — preload, open to locked
   (`05-specifications/25-GARAGE-DESIGN.md` Part 5).
3. Record the new curve and new benchmark time. Confirm both moved.
4. Drive the same corner, same entry speed, each setting back to back.
   **Record yes/no plus a confidence rating (certain/maybe/no)** for
   whether the difference is felt through tilt.
5. **Repeat step 4 on the second device.**
6. Write the result into `RVP-TRIAGE.md`'s status section tonight,
   while it's fresh — replacing "unconfirmed" with the actual outcome.

**Do not round a "maybe" up to a pass.** That's the one rule this whole
project has run on since the Python simulation first caught its own bug
in `TireForceModel.cs` — a soft result recorded honestly is worth more
than a clean one recorded optimistically.

---

# What to bring back afterward

Whatever the result, write it down before doing anything else with it —
new features, more tuning, a second car. Three possible outcomes, and
what each means for what comes next:

- **Clear pass, both devices** — the tuning-depth thesis holds. `42
  -PATH-TO-LIVE-TESTING.md` Part 2 becomes the actual next work: one
  circuit, one rival, one race format.
- **Pass on Pro-tier, fail or maybe on 60Hz** — a real, documented
  finding (`36` §2.3 predicted exactly this possibility). The next
  question is whether that's acceptable as a device-tier floor or
  needs an input-resolution fix.
- **Fail on both** — the physics or the input handling needs
  revisiting before anything else in this package is worth building
  further. Not a failure of the research; a genuinely important thing
  to know before more content gets built on an unconfirmed foundation.

---

# Cross-references
- Full RVP triage → `code/prototype/RVP-TRIAGE.md`
- The complete pre-Unity checklist this session executes → `42-PATH-TO-LIVE-TESTING.md`
- Concrete numbers for every asset created tonight → `43-FIRST-PLAYABLE-SPECS.md`
- Device-tier risk → `03-physics-research/36-IPHONE-SPECIFIC.md` §2.3
- The consistency requirement for step 3.4 → `03-physics-research/31-DYNO-ANALYSIS.md` §2.3
