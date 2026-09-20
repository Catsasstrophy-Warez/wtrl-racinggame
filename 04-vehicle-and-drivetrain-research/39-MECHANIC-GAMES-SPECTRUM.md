# The Mechanic-Game Spectrum: Beyond Car Mechanic Simulator

**What this is.** `38-CMS-PARTS-TAXONOMY.md` covered one game in depth and
left a real open question (§3.3): should this project's parts granularity
match CMS's dozens of individually named components, stay at the current
category level, or land somewhere between?

**This document exists to answer that properly** — by placing CMS on a
spectrum against four other games that have real, researched mechanic
systems: My Summer Car (far more granular), Jalopy (far less), Automation
(a different axis entirely — design, not disassembly), and BeamNG/Wreckfest
(not discrete parts at all — emergent structural failure). Seeing the full
range makes the open question in `38` answerable rather than arbitrary.

---

# PART 1 — The spectrum, by granularity

| Game | Total components | What "removing a part" means |
|---|---|---|
| **Jalopy** | **Seven**, total | Whole-unit swap or a limited-use repair kit |
| **Car Mechanic Simulator** | Dozens per car, hundreds across the roster | Named sub-assembly, condition-tracked, repairable or replace-only |
| **My Summer Car** | Hundreds of individual fasteners | Every bolt, by size, threaded individually with a matching tool |
| **Automation** | N/A — not a disassembly game | Parametric design: choose an engine *family* architecture, then tune *variants* within it |
| **BeamNG/Wreckfest** | Zero named parts | Emergent: a "part" detaches when the beams holding it to the chassis structurally fail |

**This project (`25`, `38` §3.3) currently sits at category level** — turbo,
cams, intake, exhaust as single purchasable units — which is closer to
Jalopy's end than CMS's, let alone My Summer Car's.

---

# PART 2 — Jalopy: proof the minimal end works

## 2.1 The system

**Seven components, no more**: engine block, carburettor, fuel tank,
battery, ignition coil, water tank, and an optional air filter. Each is
either repaired with a **limited-use repair kit** (kits have a small
number of uses before they're consumed) or replaced outright. Tyres are
handled as a separate category with their own acquisition points (found
in the garage or bought at petrol stations, not the main dealership).

## 2.2 What it validates

> **A mechanic game does not need CMS-level granularity to work.** Seven
> components is not "unfinished" — reviewers and players engaged
> seriously with Jalopy's maintenance loop at that scale. **Category-
> level parts, which is where this project currently sits, is a
> legitimate design point on this spectrum, not a placeholder waiting to
> be replaced with more detail.**

## 2.3 The genuinely useful mechanic: repair kits as a scarce resource

Kits are consumable and limited — you cannot fix everything, so which
part gets attention becomes a real decision under time and money
pressure, particularly on the road between towns.

> **A concrete, cheap addition to `25`'s repairable/replace-only flag**
> (added from `38` §1.3): make repair itself consume a limited resource
> at the lower property tiers, not just cost money. A player with no
> repair kits left has to choose between driving on a degraded part or
> paying full replacement price — real triage, not just a cost slider.
> This should ease at higher property tiers (`25` Part 7), consistent
> with the existing pattern of the property ladder removing constraints
> rather than just adding stat bonuses.

## 2.4 The warning

A widely-repeated community complaint: **durability decay was tuned too
aggressively** — parts wearing out within one or two checkpoints,
described by players as the single biggest problem with the game.

> **Directly relevant to `20`'s mechanical failure system and `31`'s dyno
> — wear rates need real playtesting before shipping**, not just a
> plausible-looking curve. This is the same class of error as `31`
> Part 2's Underground 2 differential problem: a tuning number that looks
> reasonable on paper and turns out to break the system's trust in
> practice.

---

# PART 3 — My Summer Car: the far granular extreme, and why not to go there

## 3.1 The system

Every fastener is individually specified — bolt count and size per
connection (e.g. two 10mm bolts for a main bearing, four 9mm for a
steering rack). The player must select the matching wrench size from a
spanner set (5mm through 15mm plus a screwdriver) for each individual
bolt; the wrong size simply doesn't work. Sub-systems include a wiring
harness requiring individual wire-to-connector matching, described by
players as the hardest part of the whole build, and fluids (fuel, brake,
clutch, coolant, oil) as a separate installation step from any bolted
part.

## 3.2 What it validates — as a warning, not a model

> **This is the extreme this project already correctly avoids.** `25`
> Part 6 already specifies the installation sequence as a short,
> skippable vignette — four generic sequences, never blocking, first-time
> spectacle rather than repeated labour. My Summer Car is the fully-
> realised version of *not* doing that: its own community describes it as
> **"a fever dream"** and **"unforgiving realism,"** language used with
> genuine affection by a self-selected niche audience, not the reaction a
> mainstream mobile racing game should be designing toward.

**One detail worth taking, precisely because it's small:** the **tool-
matching mechanic** (wrong wrench size physically doesn't work) is a real,
cheap, diegetic gate that reinforces the world's internal logic without
requiring bolt-level granularity everywhere. `25`'s parts-gate-adjustment
principle (§6.4, existing) could borrow this specific texture — a
socket/tool requirement tied to a part category, not every individual
fastener.

## 3.3 The sourcing pattern

Parts must be **bought from a shop or found scattered across the
world**, not simply available on demand.

> **Already present in this project's design** — `25` Part 3 (bought,
> found, won from rivals) independently reaches the same structure. Worth
> noting as a second confirmation, not a new idea.

---

# PART 4 — Automation: a different axis, and a real transferable bug

## 4.1 The system

Not a disassembly or repair game at all — a **parametric design tool.**
The player designs an engine by choosing a **family** (fixed architecture:
cylinder count and layout, displacement range, block material) and then
creates multiple **variants** within that family (cam profile,
compression, fuel delivery, forced induction) without redesigning the
architecture each time. Completed designs export via a one-click pipeline
into BeamNG.drive, carrying visuals, basic deformation, and engine audio
together.

## 4.2 The family/variant structure — a third independent confirmation

> **This is the exact two-tier structure `37-FORD-V8-AUDIO.md` found in
> real Ford engineering history** (one firing-order "family" spanning
> five real generations, with many mechanical "variants" inside it) **and
> that `38` §1.4 found in CMS's engine-matched parts** (a gearbox
> literally labelled "V8 OHV," fitting that family only). **Three
> unrelated sources — real automotive history, one commercial simulation
> game, and one design-tool game — independently converge on the same
> family/variant shape.** That is a strong signal this project's own
> engine and parts data should be explicitly modelled that way: a fixed
> "family" record per engine architecture, with "variant" records
> beneath it for each generation's specific tune.

## 4.3 ⚠️ The transferable bug: merge meshes before they matter for performance

Automation's own player community identified a real, measured performance
problem: exporting an engine as many separate small meshes (rather than
one joined mesh) produced roughly **2.5× the render draw calls** of a
comparable native car — 13,416 rendering events against 5,392 — and a
correspondingly large frame-rate loss (roughly 52fps against 120fps in
the same test scene), traced specifically to the engine being left
unmerged.

> ## Directly relevant to the garage's rendering budget
>
> `25`'s installation sequence (Part 6) deliberately shows the engine as
> individually-modelled parts going in one at a time — exactly the
> structure that caused Automation's draw-call problem. **The fix is
> already implied by `25`'s own "tight framing" rule (§6.2) but should be
> stated explicitly as a technical requirement, not just an art
> direction note**: once the installation sequence finishes and the
> player returns to normal garage or driving views, the engine's separate
> part meshes should be **merged into a consolidated mesh** (or reduced
> to a much smaller number of material-grouped meshes) for ongoing
> rendering. Keep full mesh separation only for the duration of the
> vignette itself, where the camera is tightly framed and the part count
> on screen is deliberately small.

---

# PART 5 — BeamNG/Wreckfest: not parts at all, and a finding that validates the existing platform decision

## 5.1 The system

Cars are built from **nodes** (point masses) connected by **beams**
(spring-damper connections) — a node-and-beam skeleton, not a set of
discrete named parts. A beam can be tuned to break under a defined force
threshold; when it does, whatever it was holding to the rest of the
structure — a bumper, a panel — physically detaches as an **emergent
consequence of the structural simulation**, not because a "part" object
was individually removed. Deformation propagates through connected beams
in real time, and — critically — has genuine mechanical consequences: a
bent suspension arm actually affects steering, a crumpled engine bay can
cause overheating, a twisted chassis throws off wheel alignment.

## 5.2 ⚠️ The finding that validates this project's existing platform decision

`35-EXTENDED-SOURCES.md` Part 4 already concluded that BeamNG's soft-body
approach is the wrong platform trade for mobile, and recommended rigid-
body-plus-curve-fit tyres instead — a conclusion reached from the cost
side (2,000Hz simulation is not viable on a phone).

**New research adds a second, independent reason, from the usability
side**: BeamNG's own player community has repeatedly asked for the
ability to **cleanly remove an already-broken part** without resetting
the whole vehicle, and this remains a known limitation years after being
first requested — the node-beam structure doesn't have a native concept
of "a part" as a discrete, removable object, so there's no clean
operation to remove one.

> ## Players want discrete parts even in the game that doesn't have them
>
> **This means the discrete-named-parts approach this project already
> uses (`25`, `20`'s damage model) is not just the affordable choice for
> mobile — it's the choice players actively want, evidenced by demand for
> it inside a game that structurally can't provide it.** Two independent
> lines of reasoning now support the same platform decision: cost (`35`)
> and player preference (this document). Worth stating both when the
> decision is questioned later, since "we couldn't afford the
> alternative" is a weaker argument on its own than "we couldn't afford
> the alternative, and it wouldn't have been better anyway."

## 5.3 What's still worth taking

**Mechanical consequences from structural damage** — a bent suspension
arm genuinely changing steering — is a real design target worth keeping
even without soft-body simulation underneath it. `20` §7's mechanical
failure system already specifies functional consequences from damage;
this confirms that ambition is correctly aimed, even though the
implementation route differs.

---

# PART 6 — Answering `38` §3.3: where this project should actually sit

With the full spectrum visible, the open question from `38` has a clearer
answer than it did in isolation:

> **Category-level parts (this project's current default) is validated by
> Jalopy as a legitimate, complete design point — not a placeholder.**
> Going further toward CMS or My Summer Car's granularity is optional
> depth, not a gap to close. **If any part of the game earns extra
> granularity, it should be the hero car specifically** (already singled
> out for full-interior treatment in `23` §6, and the one vehicle the
> mentor's diagnostic voice centres on) — everywhere else, category level
> is not just acceptable, it's independently confirmed as sufficient by
> a real, well-received game built entirely around it.

**The repairable/replace-only flag from `38` §1.3, and the repair-kit
scarcity from §2.3 above, remain worth adding regardless of granularity
level** — both operate at category level fine, and neither requires
component-level detail to work.

---

# Cross-references
- The original CMS deep dive and the open granularity question → `38-CMS-PARTS-TAXONOMY.md`
- Installation sequence and tight framing → `25-GARAGE-DESIGN.md` Part 6
- Parts acquisition (bought/found/won) → `25-GARAGE-DESIGN.md` Part 3
- Property ladder easing constraints → `25-GARAGE-DESIGN.md` Part 7
- Mechanical failure and functional damage consequences → `20-CONCEPTS.md` §7
- BeamNG as fidelity contrast, the cost-side argument → `35-EXTENDED-SOURCES.md` Part 4
- Two-family engine structure (a third confirmation here) → `37-FORD-V8-AUDIO.md`
- Underground 2's tuning-trust failure (the same shape as Jalopy's decay-rate warning) → `31-DYNO-ANALYSIS.md` §2.3
