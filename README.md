# Racing Game Research Package

Reference material for an iOS racing game (Unity 6, C#) with simulation, action,
and RPG progression layers. Premise: a mechanic who races on weekends and works
up from street racing to professional track driving.

**Reorganized into 8 folders by purpose** — the numbered documents
that used to sit flat in the root are now grouped (foundations, design
research, physics research, vehicle/drivetrain research, specifications,
production path, content resolution, trends). Every file kept its
original number and name; only the physical location changed, verified
in/out counts with none lost or duplicated. **`VERSION.md` is the real
map of the structure — read that first if you're looking for something
specific.**

**Latest**: a follow-up check found the disconnection pattern went
further than the first fix caught — `63-DANGLING-METHODS-FOLLOWUP.md`.
Six more methods checked individually, and the worst one wasn't in the
RPG layer: `EngineVariant.ApplyToEngine()`, the only path any hero-car
generation's sourced data ever reaches real physics, had zero real
callers anywhere. Every one of the seven generations could be
batch-created via `GenerateContentAssets.cs`, be perfectly correct,
and never affect a single frame of actual driving. New file
`Orchestration/VehicleSetup.cs` fixes that and two more; two other
methods got wired into files that already existed. One left honestly
unfixed — it needs a dialogue system this codebase doesn't have yet,
and forcing a call into nothing would have looked like progress
without being any.

**Also this session**: checked null-safety across every `Update()`
loop in the codebase (six total) — clean, all properly guarded. Then
simulated a second system the same way the mechanical-failure bug was
found: `ObjectiveTracker.cs`'s instability objective against a
realistic driving pattern. This one came back genuinely working, not
broken — normal driving clears it, sustained reckless driving fails
it, with one honest tuning note about exactly how "reckless" has to
get. Not every check needs to find a bug, and saying so plainly
matters as much as reporting the ones that do.

Previous: `62-SIMULATION-AND-TESTING-PASS.md`

**Then**: researching popular mobile games broadly (not just racing)
turned up Royal Match — the most rigorously A/B-tested "light meta
layer" in mobile gaming, and a real structural match to this project's
own RPG design. Checked all nine progression systems together against
their actual data rather than assuming nine well-built systems were
automatically fine: seven have zero dedicated UI at all, matching the
exact principle Dream Games tested and confirmed. Found one real gap
doing it — `ReputationTraits` was being applied to rivals every race
and never once updated from a real result — fixed in
`code/prototype/Orchestration/RaceFlowCoordinator.cs`.

**One honest process note**: the new document initially collided with
an existing `61` — numbering is global across the whole project, not
per-folder, and a folder-local check missed that. Caught before it
shipped, renumbered to `64`, verified no other duplicates exist. — the same numerical-
validation discipline already applied to the core physics, extended to
the newest systems. Found a real bug that read correctly on
inspection and was still wrong: `MechanicalFailure.cs` required 5
*consecutive* unbroken seconds above the instability threshold before
any risk accumulated — no real corner sustains that, so simulating an
actual 6-lap driving pattern showed accumulated abuse staying at
exactly 0.000 for the full 120 seconds. Fixed to track cumulative time
across the whole race instead, matching the system's own "push lap
after lap" design intent, and re-validated against three scenarios
before touching the real file. Also confirmed real: all six rivals'
AI values are genuinely numerically distinguishable from each other,
not just different-looking in separate tables.

Previous, and still worth reading**: a full deep dive found that every one of the 22 prototype
files was individually correct and **none of them were connected to
each other**. Every cross-system event — car loses control, a
mechanical failure occurs — had zero subscribers anywhere. Every
race-event class computed its own win condition correctly and nothing
ever read it. That's a different, bigger class of problem than any
bug found before it: not wrong code, disconnected code.

Two of the three dangling events turned out to be worse than "needs
wiring" — they were plain C# `event Action<T>` delegates, not Unity's
`UnityEvent` type, meaning they weren't even wireable from the
Inspector without a programmer writing subscriber code first. Fixed
both. Then built `code/prototype/Orchestration/RaceFlowCoordinator.cs`
— not a full game manager, which needs real scene and UI knowledge
this pass doesn't have, but a real, verified reference implementation
proving the connection pattern actually works end to end for one path:
an outrun event ending, a mechanical failure occurring mid-run and
genuinely zeroing the nitrous system rather than just logging it, both
flowing into the license and reputation systems correctly.

Previous: the code got the same organizational pass the documents
already had.** `code/prototype/` went from 22 C# files sitting flat to
9 folders by purpose — `Physics/`, `RPG/`, `Action/`, `Audio/`,
`Social/`, `Garage/`, `RVPIntegration/`, plus the pre-existing
`Editor/` and `simulation/`. Verified the same way the document move
was: exact file count before, exact count after, nothing lost.
`code/prototype/README.md` has the full breakdown.

Previous: `code/prototype/Editor/GenerateContentAssets.cs` — a real
Unity Editor automation script, not just more documentation. One menu
item batch-creates every remaining `EngineVariant`, `TransmissionSpec`,
and `RivalAI` asset — six engine generations, seven transmissions
including the real TREMEC DCT ratios, five rivals' AI tuning — instead
of hand-typing dozens of fields across dozens of assets. Every value
was re-verified against its source document while writing the script,
not trusted from memory. Safe to re-run: it checks for an existing
asset at each path first and skips it rather than overwriting anything
already there.

Previous: `06-production-path/61-CODE-ANALYSIS-AND-WHATS-LEFT.md` —
a full pass through all 15 C# files (one real division-by-zero bug
found and fixed in `DiagnosticSkill.cs`, two identical-looking risks
checked and confirmed already safe rather than assumed), plus the
first "what's left" inventory update since Unity actually started
compiling and driving this project. Two of five live-status checks
confirmed; the differential test and the tilt question remain exactly
as open as they've been since the package first named them.

Compiled Aug 2026. Eighteen documents, plus MIT-licensed source and a schema.

---

## How to use this

**Start with `20-CONCEPTS.md`.** It is the synthesis — 21 systems for this game,
each traced back to the research that produced it, organised into the four chains
that actually matter. Everything else is the evidence behind it.

**Then:** `01` (licensing), `11` (systems spec), `19` (the deepest reference).

**About to build something?** `02`, `03`, `08`, `09`, `10` are the production
constraints.

**About to derive an asset from a reference?** `12` is the method,
`templates/derivation-worksheet.md` is the form, `15` is the worked cases.

---

## Outward-facing

`PITCH.md` — the funding and promotion version. Needs title, team, budget and
milestone gates filled in.

## Documents

### Constraints and production
| File | Covers |
|---|---|
| `01-LICENSING.md` | **Read first.** Per-repo licence status, verified from actual licence files. One repo is entirely off-limits. |
| `02-TOOLCHAIN.md` | Mac vs Windows split, software stack, version control, data-layer advice. |
| `03-PLATFORM-NOTES.md` | iOS constraints, IL2CPP pitfalls, thermal throttling, frame pacing. |
| `08-ART-DIRECTION.md` | Three-act visual arc, garage-as-shrine, visible upgrades, mobile rendering limits. |
| `09-ASSET-PRODUCTION.md` | Poly budgets, LOD policy, texture and ASTC specs, legal sourcing, licence-tier table. |
| `10-AUDIO-DESIGN.md` | Engine audio architecture, RPM/Load parameters, full SFX inventory, mobile voice limits. |

### Specifications — decisions, not research
| File | Covers |
|---|---|
| `25-GARAGE-DESIGN.md` | Garage as home screen, seven camera stations, the three tuning contexts, and the installation sequence with tier escalation. |
| `35-EXTENDED-SOURCES.md` | **Beyond Beckman.** OptimumG's living technical papers, a free NHTSA database of real vehicle inertia data, an academic paper with a precise oversteer-detection formula, BeamNG as fidelity contrast, and honest notes on the commercial textbooks I can't fully research. |
| `34-PHYSICS-READING.md` | **Where to learn the underlying physics.** Beckman's free Physics of Racing, Monster's Car Physics for Games, three gotchas that save real time, and a reading order. |
| `31-DYNO-ANALYSIS.md` | **Every dyno in the corpus, and the spec for yours.** UG2's curve editor, ProStreet's 25 sliders, CSR2's benchmark framing, the four failure modes, and the prototype pass condition. |
| `33-ACT-STRUCTURE.md` | **The career arc.** The hired-gun decade, standing as a live variable, the 1995 act break, and the three-currency week. |
| `32-HERO-CAR.md` | **One car, rebuilt across sixty years.** The generational spine, the three parts channels, the intimidation system, and seven derivation worksheets. |
| `30-NARRATIVE-DESIGN.md` | The mentor who becomes obsolete, the inverted sabotage, **six persistent rival archetypes across sixty years**, the culture layer — and how to break the inverse law without a single cutscene. |

### What to build
| File | Covers |
|---|---|
| `20-CONCEPTS.md` | **The synthesis.** 21 systems across simulation, action and RPG, the four chains that connect them, and what to prototype first. |
| `04-EXTRACTION-INVENTORY.md` | RVP, TORSION, Unity's ECS sample, CrazyCar — component by component. |
| `11-SYSTEMS-SPEC.md` | **The build document.** Every system, its dependencies, and a five-phase build order. |

### Design references
| File | Covers |
|---|---|
| `27-COMPETITOR-ANATOMY.md` | **The two games that matter.** GRID Autosport and CPM dissected, with the corrected three-axis positioning map. |
| `29-NARRATIVE-ANALYSIS.md` | Every racing game story in the corpus. Seven shared patterns, the inverse law, and **the finding that no racing game has a maker protagonist.** |
| `28-CPM-CASE-STUDY.md` | Car Parking Multiplayer in full — the social systems, the player economy, and **the go-to-market nobody documents.** |
| `26-MOBILE-LANDSCAPE.md` | **The competitive picture.** 50 iOS titles across nine categories, market data, a deep dive on the open-world sandbox tier, and the positioning map. |
| `07-INFLUENCE-MAP.md` | **The references that match your premise.** Ford v Ferrari, GT, GRID, iRacing, and the mobile competitive landscape. |
| `13-MUSTANG-DOSSIER.md` | The single-nameplate content model, the trim ladder as progression, and the 2025 ruling on when a movie car is protectable. |
| `16-MANAGER-GENRE.md` | Race management games — the reference for your professional tier. |
| `17-GENRE-TAXONOMY.md` | 40 years of racing games as a feature matrix. What stuck, what's decoration. |
| `18-SNES-ERA.md` | Top Gear 1–3, Street Racer, Al Unser Jr. Constraint-driven design, and two direct ancestors of your systems. |
| `21-DRIVER-SERIES.md` | Driver's four-button traction vocabulary, the garage-test control syllabus, the felony system, and San Francisco's documented control failure. |
| `22-INPUT-DESIGN.md` | **The control scheme.** HCI research on tilt vs touch, the six-config taxonomy, the assist stack as a difficulty system, and the recommended scheme. |
| `24-GARAGE-SYSTEMS.md` | Garages compared across the whole corpus — place vs menu, one car vs many, GT Auto's three decay models, and the six-function matrix. |
| `23-CAMERAS-AND-HUD.md` | Cockpit views as an asset-budget problem, GT5's rationing tricks, Shift 2's helmet cam, and where the instability meter lives. |
| `19-NFS-DOSSIER.md` | **The largest reference doc.** Porsche Unleashed in depth — the closest existing game to your premise — plus the full series game by game. 23 extractable ideas, 7 documented failures. |
| `05-DESIGN-REFERENCE.md` | Mad Max and Outlander. Upgrade tradeoffs, economy failure modes, resource tension. |
| `06-GENRE-REFERENCE.md` | Gaslands, Car Wars, the vehicular-combat lineage. Hazard tokens, class brackets, build budgets. |
| `14-WASTELAND-CORPUS.md` | Extended Mad Max lineage. Low extraction rate — read §4 only. |

### Working legally with references
| File | Covers |
|---|---|
| `12-DERIVATION-METHOD.md` | Seven-step process, the Towle test, three worked examples, the worksheet. |
| `15-DERIVATION-CASEBOOK.md` | Documented cases of professional productions doing this. Film substitutions, replica fleets, GTA's 36-brand system. |

### Directories
```
code/pacejka-reference/  **Public domain.** Beckman's longitudinal + lateral magic
                         formula and the traction circle, in Python, using his
                         published constants. Parts 21, 22, 25 in executable form.
code/TORSION-MIT/      MIT drivetrain source. Ship-safe. Art excluded.
code/CrazyCar-MIT/     MIT licence + MySQL progression schema.
templates/             Blank derivation worksheet.
scripts/               Fresh-clone script for the reference repos.
```

---

## Findings that should shape the project

### The numbers
- **4–8 weeks** per game-ready hero car for a senior artist (`09` §1)
- **~52 audio loops** per vehicle at full spec, reducible to ~16–20 (`10` §2.1)
- **300k–500k triangles** on-screen at 60fps, mid-range 2026 hardware (`09` §2)

All three point the same way: **small roster, deep tuning.**

### The precedent that proves it works
Porsche Unleashed (2000) shipped **80 models of a single marque** across three
eras with a four-point physics model, and reviewers said you could feel the
difference between them. The Mustang game shipped 40 with arcade physics and
players said they all felt the same. **Same strategy, opposite physics, opposite
outcome** (`19` §1.1). Every hour on the tyre model is an hour making this
content strategy viable.

### The content model that resolves it
**One nameplate across generations, not eight unrelated cars** (`13` §1).
Ford Mustang: The Legend Lives shipped 40 variants of a single car in 2005.
Shared topology, shared rims, three engine families. That game failed because
arcade physics made all forty handle identically — **yours won't.**

### Ideas worth building around
1. **Time-shifted ghosts** (`07` §3.5) — async rivals from recorded player
   traces. No netcode, no servers, no matchmaking.
2. **Dual rating: pace + safety** (`07` §2.3) — contact costs you regardless of
   result. Makes the professional tier structurally different, not just faster.
3. **Ragged-edge instability** (`06` §1.2) — Gaslands' hazard tokens reframed.
   Makes limit-driving visible where there is no force feedback.
4. **Class brackets** (`06` §2.2) — a maxed car locks out of lower classes.
   Fixes the currency-sink problem authentically.
5. **Physically-justified upgrade dependencies** (`18` §2.2) — Top Gear 2 had to
   invent arbitrary prerequisites. Your physics engine produces them for free.
   Clearest advantage you have over every mobile competitor.
6. **Progression as curriculum** (`18` §5.2) — each career tier teaches what the
   next tier requires. Solves the skill-gate gap without a tutorial system.
7. **Repair costs as economic pressure** (`19` §2.3) — four damage systems, no
   mid-race repair, a bill in the garage. You own every component of this loop
   already via RVP's `VehicleDamage`. It is the most natural currency sink there
   is.
8. **Stars from objectives, not just position** (`19` §2.9) — advance without
   winning. Keeps a mobile player progressing through a session where they never
   placed first.
9. **A "factory driver" employment tier** (`19` §1.3) — paid technical driving:
   shakedown runs, deliveries, evaluation laps. Native to a mechanic protagonist,
   teaches car control without a tutorial, and gives you non-race events.

### The three-layer principle
`15` Pattern 3. **The car you see, the engine you hear, and the machine that
performs are three separate decisions.** Fast & Furious runs LS engines with
Hemi audio dubbed in post. Your mesh, FMOD events, and TORSION drivetrain need
not share a source.

### The constraint that turns out not to be one
Manufacturers do not license vehicles that visibly break — Gran Turismo carried
extensive trademark notices and no damage modelling for years. You are
inheriting RVP's deformation and repair. **Licensed cars were never available,
so fictional vehicles cost you nothing.** `12` is how to build them so they
still feel like what you liked.

### Two cheap wins already in your stack
- **Surface-dependent grip** — RVP's `GroundSurfaceMaster` ships it. Sega Rally,
  1995, and still the cheapest way to make tracks feel different.
- **Rewind / flashback** — record state, restore state. Widens the audience
  without diluting the sim for anyone who ignores it.

---

## The riskiest thing in the project

**Input resolution is what makes tuning depth perceptible** (`22` Part 0).

If a player cannot feel the difference between two differential settings because
the steering input is too coarse to express it, the premise collapses — and it
collapses *silently*, presenting as "the parts don't do anything." That is the
exact criticism levelled at Porsche Unleashed, the Mustang game, and Driver: San
Francisco's roster. Three games, three decades, same complaint.

Four things follow:

- **Tilt beats touch, per actual research.** 30% fewer fatal collisions and 12
  seconds faster per race across 36 subjects. It also frees both thumbs and
  doesn't occlude the screen. **RVP's `MobileInput` delta factor already
  implements the nonlinear gain curve the literature recommends** — and it is
  sitting unused.
- **Never overload the steering axis.** Driver: San Francisco mapped boost to
  pushing up on the steering stick; players triggered it constantly by accident.
  A touchscreen has no detents and no centre, so this is worse there.
- **Build a traction vocabulary, not a drift button.** Driver (1999) gave four
  ways to break traction, each scrubbing a different amount of speed. That is
  where physics depth becomes *felt*.
- **The assist stack is your difficulty system.** Assists on at street tier,
  removed one at a time through club, bare by professional. Your biggest
  constraint becomes your tutorial and your progression at once (`22` Part 4).

## Cockpit views are an asset-budget decision

A GT5 Premium car took **six months** to model; a Standard car without a full
interior took **one**. GT5 shipped 200 of the former and ~800 of the latter, and
**tinted the Standard cars' windows so you couldn't see in** (`23` §1.2).

Build one great interior for the hero car and spend the rest on the tyre model.
Shift 2's own players abandoned the most expensive camera in the genre the moment
they wanted to go fast.

## The four chains

From `20-CONCEPTS.md` Part 4. These are not independent features — a system
pulled out of its chain does not function.

- **Tuning:** practice → dyno → telemetry → dependencies. Without all four, deep
  tuning is a slider wall.
- **Career:** aggression rewarded at street → Safety Rating at club →
  professional tier gated on it. The player unlearns something to progress.
- **Economy:** repair costs drain, class brackets force multiple builds, property
  tiers provide sinks. Three answers to the failure that killed both Mad Max's
  and Porsche Unleashed's economies.
- **The bridge:** shop-driver work carries the player from street to
  professional. ProStreet proved that audience does not follow you to a racetrack
  on its own.

## Prototype code now exists — steps 2 and 3, written

`code/prototype/` — four C# files implementing the dyno and the instability
meter against TORSION's real interfaces, inspected directly from
`code/TORSION-MIT/` rather than guessed:

- **`TireForceModel.cs`** — Beckman's three-parameter tyre formula, with
  proper combined-slip handling and a low-speed divergence guard
- **`RaggedEdgeMeter.cs`** — the instability meter's real fill level plus
  the precise `|a_y − v·ψ̇| > ε` oversteer trigger
- **`DynoController.cs`** — reads the live torque curve (never a parallel
  simulation), exposes chart data, computes a CSR2-style benchmark via
  proper RK4 integration
- **`StaticWeightTransfer.cs`** — Beckman's closed-form weight-transfer
  solution, as a cross-check tool

**Status: written and reviewed against the real class interfaces, not
compiled** — there is no Unity available to test against in this
environment. `code/prototype/README.md` has the full wiring guide, including
one assumption about `Engine.torqueCurve`'s axis convention that needs
verifying, and the single most important integration note: **the dyno, the
meter, and the car's actual driving must all read the same tyre model**, or
you reproduce Underground 2's exact failure — a differential that tests
fastest on the dyno for reasons that don't hold on track.

## Prototype this first

**The dyno** (`20` §4, spec in `31`). Every conclusion here rests on the
assumption that your tuning depth is the differentiator — and Porsche Unleashed
shipped a deep, authentic parts catalogue that reviewers said did not change the
car enough to matter.

### The pass condition (`31` Part 7)

> **Change one differential setting.**
> **1.** The curve moves visibly. **2.** The lap time moves measurably.
> **3.** The player can feel it through tilt.
>
> **All three, or the premise does not hold.**

**ProStreet had the first. Underground 2 had the second. Neither had the third.**

### And the design to steal (`31` Part 4)

CSR2's dyno reports **what a perfect run would give you** — and real races can be
faster. Beating the dyno is a skill. That converts a tuning screen into a target,
and it separates *"my car is slow"* from *"I am slow"* — the most useful
diagnostic in the genre.

## Decisions now taken

The package has been research to this point. `25-GARAGE-DESIGN.md` is the first
document that records **decisions**:

- **The garage is a place, and the travel is eliminated.** It is the home
  screen. Underground 2's placeness without Underground 2's pacing cost.
- **Shrine, not spreadsheet.** One hero car presented as an object, with
  openable bonnet, doors and boot.
- **Three tuning contexts, three levels of commitment.** Garage buys parts (costs
  money, permanent). Dyno calibrates (free, iterate endlessly). Practice sets up
  for a circuit (costs a session). **A broke player still has something
  meaningful to do.**
- **Show the work.** Every racing game in the corpus hides installation behind a
  spinner. Four short vignettes — engine bay, underside, wheels, body — with the
  part swapped in as a mesh, carried by audio, always skippable.
- **The work escalates with the property.** Jack stands and a torch at the
  house; four-post lift and air tools at the pro shop; a team at the warehouse.
  **Progression becomes visible in how the work is done** — during the single
  most frequent action in the game.

## The narrative position

Two findings from `29`, and the second is the more valuable:

**Your premise is the rare structure.** Racing stories are overwhelmingly
*reclamation* — you had something, it was taken, you get it back. Most Wanted,
Underground 2, Carbon, Mad Max. **Yours is an ascent story**, and the only
precedents are Al Unser Jr. and ProStreet — the latter commercially punished for
exactly the transition you're planning.

> **No racing game has a maker protagonist.** Tanner drives. The Most Wanted
> protagonist drives. Max drives — **Chumbucket builds.** The one character in
> the entire corpus who does what yours does is a sidekick.

And the structural answer to why deep simulation and authored story have never
coexisted (`30` Part 5): **story has always been delivered as an interruption.**
Cutscenes, unskippable dialogue, a gate between the player and the car.

**Deliver it as ambient texture in places the player already dwells and the
conflict disappears.** Every story beat in `30` happens in the garage, on the
dyno, in post-race telemetry, at the parts wall, or at the desk — **screens
already specified in `25`.** Zero cutscenes. No time away from driving.

## The hero car

`32` — a 1965 chassis the player restores and then carries forward through
successive eras to a 2022 legend, visually evolving through the pony-car lineage
without reproducing any production model.

**It solves the ascent-story problem.** Reclamation plots dominate the genre
because they give one car emotional weight before the player has earned any
(`29` §2.1). **A car you rebuild across sixty years does that without borrowing
the theft.**

It also makes the single-nameplate content model *literal* — the shared topology
stops being a production convenience and becomes the fiction — and it gives the
mentor a reason to be there. **He knew this car when it was new. He can't drive
any more, and the car he can't drive is the one you're rebuilding.**

**Production:** seven base models across sixty years — 1965, mid-70s, late 80s,
mid-90s, early 2000s, mid-2010s, 2022 — with era variants and a shared wheel
library. That is substantially the whole roster, and at `09`'s 4–8 weeks per
hero car it is **28–56 weeks of art.** Worth staging: ship the first three or
four generations, since the fiction supports a car that has not reached the
present day yet.

**Open: the intimidation factor** (`32` Part 5). As stated it is a flat launch
advantage plus a catch-up boost — which is rubber-banding, and this package
identifies rubber-banding as what kills upgrade economies (`18` §2.3).
The alternative: **intimidation doesn't make your car faster, it makes rivals
worse.** They brake early, they don't attempt the pass, they hesitate at the
line. Same half second, but you get it because someone flinched — and you can
see them flinch.

## The rivals

`30` Part 3 — **six archetypes that persist across the hero car's sixty years**,
plus six passers-through, one per era.

Each is a person with a **car lineage** that evolves era by era exactly as the
hero car does: European rear-engine GT, Japanese inline-six turbo, German touring
saloon, American big-block, British minimalist — **and the Constant, in a modest
front-drive hatchback, who beats you in 1978 and beats you in 2011.**

**Entry and exit are characterisation.** The locked-diff man is a 60s–70s figure
who doesn't survive proper differentials. The turbo man vanishes when huge boost
does. The lightweight disappears in the 80s and returns in the 2000s. The
Constant is in every column.

**They remember specifics, not a score.** You raced someone dirty in the street
tier — and twenty years later, at the professional tier where contact is
penalised, he's the one who remembers you as someone who does that. **That gives
the Safety Rating arc a face.**

**The ending:** by 2022 the Constant is the one who can't drive any more, and
he's watching you. That closes the loop the mentor opened.

## The act structure

`33` — written to fix the thinnest stretch of the career. **The diagnosis that
mattered: the sag was not a content problem. Act two had no loop of its own.**

| Act | Loop |
|---|---|
| **One** | Build → race → climb |
| **Two** | **Drive other people's cars while your own sits waiting** |
| **Three** | **Everything competes; the ladder is how you win the week back** |

**Act two is nine years as a hired gun** — shakedowns, evaluations, deliveries,
sorting jobs, ringer drives — **with the dyno closed on every job car.** That is
the only way to prove driving skill separate from building skill.

**The sorting job is the one that matters:** someone hands you a car that's fast
and horrible, you read the telemetry, and you tell them what's wrong. **You're
paid for the diagnosis.**

The 1987 choice shapes which jobs appear, what parts cost, which events accept
you, and who races you clean — **with no meter on screen.** The player infers
their standing from how the world behaves.

**The act break is 1995: somebody walks in and asks you to build something.** The
shop opens because the reputation earned it, not because a tier unlocked.

**Act three adds the three-currency week** — job, commission, or your own car —
and the property ladder stops being storage and becomes **the way you buy your
way out of choosing.**

> And the highest-value item per unit of cost in the entire design: **the hero
> car under a dust sheet in the corner of the bay**, visible every time the
> player opens the app. It turns an abstract opportunity cost into guilt.

## Corrections log

Two recommendations in earlier revisions were wrong and are now fixed in `01`,
`02`, `04`, `11` and above:

- **VPP Community Edition** was described as commercially cleared and actionable.
  It is — but it is **desktop-builds-only, one vehicle per scene, single ground
  material.** It cannot ship on iOS, cannot run an AI field, and cannot do
  surface-dependent grip. Benchmark, not foundation.
- **`com.unity.vehicles`** was offered as a fallback. It is **ECS-only,
  experimental, and targets medium realism by design** — and adopting it means
  abandoning TORSION and RVP for a data-oriented rewrite.

**What remains free and genuinely useful from VPP:** the public documentation at
`vehiclephysics.com` and the `EdyJ/vehicle-physics-docs` repo — though the
technical depth is in the sub-pages, not the landing page. **Better free
resources exist**, and they are collected in `34-PHYSICS-READING.md`:

- **Brian Beckman's *Physics of Racing*** — 25+ articles, explicitly royalty-free,
  and the best free education on this subject anywhere
- **Three gotchas that save real time** — weight transfer emerges from suspension
  compression rather than being computed (RVP already does this, so bolting on a
  separate system would double-count it); **Pacejka diverges at low speed**, which
  you will hit in the pit lane; and the Magic Formula constants are trade secrets,
  so you will be hand-authoring tyre curves either way

## Deep-dive audit: propagating the research into the build docs

A full sweep found the master build document (`11-SYSTEMS-SPEC.md`) had
**zero cross-references** to `34`/`35` despite its vehicle-physics section
being exactly where those findings belong — someone building from `11` alone
would never know to check the physics research. Fixed, along with two smaller
gaps:

**`11` §2.1** now names the tyre model to actually implement (Beckman's
three-parameter formula, `34` Part 1d), points at the closed-form weight
transfer solution (`34` Part 1e), and adds PMI as a build consideration.

**`11` §2.3** — the instability meter's own section previously called it "the
highest-value **original** mechanic." **It isn't original; it's Beckman's
traction circle**, and the section now says so, plus adds the precise
`|a_y − v·ψ̇| > ε_threshold` loss-of-control trigger.

**`08-ART-DIRECTION.md` §2.2** gains a cheap visual detail: ride height isn't
static under load (OptimumG's jacking forces, `35` §1.1) — even a crude
version of the car rising and squatting mid-corner makes the static
ride-height slider feel like it's touching something alive.

**`17-GENRE-TAXONOMY.md`** — the claim that a "learnable" handling model is
what makes racing games endure now has its physical grounding stated
explicitly: three independent sources converge on the same threshold Beckman
identifies, which means learnability isn't a design trick over arbitrary
physics — it's what correctly modelled physics *is*.

## Forza, analyzed deeply — Drivatar checked against what's already built

`60-FORZA-DEEP-ANALYSIS.md` — Forza had four scattered mentions across
the package and no dedicated deep dive. This one focuses on Drivatar
specifically, because it's the one Forza system with direct bearing on
work already done, and both checks against existing code held up.

**Real, documented failure case, checked against `RivalAI.cs` rather
than assumed safe**: early Drivatar versions trained too faithfully on
raw player behaviour and learned genuinely toxic habits — deliberate
ramming, dirty driving — forcing Turn 10 to build override logic
after the fact. Verified directly: `RivalAI.cs`'s four parameters are
already clamped to per-rival ceilings on every update, built for an
unrelated reason months of design ago. Two unrelated paths landing on
the same safeguard is real confirmation, not luck.

**A third independent confirmation of the passive-income pattern**:
Drivatar's "paid while you're away" mechanic is structurally identical
to what GTA and idle-game design already confirmed twice. Three
unrelated sources, same shape, no new code needed.

**Declined on purpose, not silently skipped**: Forza's own admitted
rubber-banding — cars get performance-adjusted by gap even though
driving behaviour trains honestly — is exactly the failure mode `32`
§5 was built specifically to avoid. And the auction house / UGC tuning
economy stays out of scope, same reasoning as GTA's live-service lever
two documents ago.

## Stress-tested against idle games, caught myself overstating a claim mid-draft

Checked the newly-built passive income system against idle/incremental
game design specifically — the sharpest available test, since that
genre is built entirely around passive mechanics.

**One adoption**: a welcome-back payout notification, near-universal
in idle-game design. **One independent confirmation**: early-tier zero
income already matches idle design's "don't automate too early" rule,
arrived at here for an unrelated reason (no staff exist yet). **One
deliberate decline**: real idle games scale income against elapsed
offline time; this system stays flat per-session on purpose, since
scaling it would push passive income toward a second primary economy,
which was already ruled out.

**The part worth flagging**: the first draft said the welcome-back
notification "costs nothing new" because `41`'s Autolog layer already
existed to carry it. Checked before letting that stand — Autolog was
design-only, no code anywhere, same gap `51` had already found and
flagged for the rest of that document. Corrected the claim, then built
`AutologNotification.cs` — the first real code for that system — so
the corrected version is actually true instead of just less wrong.

## Self-check catches a real typing gap

Immediately after the passive-income code landed, checked it the same
way every addition in this arc has been checked — and found something.
`PartsGating.cs`'s new property-tier field used bare string literals
(`"ProShop"`, `"Warehouse"`) instead of a real enum, the only place in
the entire 14-file codebase where a tiered concept had no compile-time
safety. A typo would have failed silently at runtime. Fixed with a
real `PropertyTier` enum, matching `ClassBracket.Tier` and
`DriverLicense.Grade`'s existing standard — verified clean afterward,
no leftover string comparisons, no second inconsistent representation
hiding in `EngineBayMeshManager.cs`.

## Trends and GTA Online: a real gap found and closed

`59-TRENDS-GTA-PASSIVE-INCOME.md` — checked a genuinely different
genre for structural lessons rather than more racing-game research,
and it found something real: `20` named "small passive income" for
the House property tier six documents before `25` specified that tier
in full, and `25` never built it. The line sat there, unbuilt, the
whole time.

**Closed without importing anything foreign to the premise.** GTA
Online's actual businesses stay exactly where they are. What
transferred is the *structure* — staffed capability, gated by
standing, and GTA's own 2026 guides are explicit that purchase
sequencing matters more than the purchase itself. That became
mechanically true here by connecting two systems that already existed
and had simply never been wired together: shop staff (`25` §6.2b,
currently only working on the player's own car) now take on outside
customers, gated by the exact same reputation tier `48` already built
for a completely different reason.

**Two things deliberately left out, stated plainly rather than
absorbed**: GTA's live-service rebalancing lever (cutting active
rewards to push players toward passive stacks) is real and worth
knowing about, but this project has no live game yet to rebalance. And
none of GTA's actual business content — nightclubs, cargo, contraband
— has any place here. The lesson was structural; the content wasn't
relevant, and saying so directly matters as much as building the part
that was.

## Test and evaluation pass

`58-TEST-EVALUATION-PASS.md` — honest about what "test" can mean
without Unity. A full audit of all 14 C# files (clean), one syntax
question checked rather than assumed (`enum++`/`--`, confirmed valid,
not a bug), and one real numerical test: the nitrous system's traction
boost run against the validated tire model.

**The nitrous finding is genuine**: full charge implies a friction
coefficient of ~1.85 against a baseline of ~1.61. Not physically
absurd, but closer to the edge of plausibility than comfortable —
flagged directly in the code itself as a production-tuning target, not
buried in a document nobody reopens.

**Stated as plainly as everything else in this package has been**:
this is not a substitute for the actual gate. No frame rate, no
device, no compile. The dyno pass condition is exactly as unconfirmed
as it started.

## Resolving the gap, pass 6: the recipe set completed

`57-CONTENT-RESOLUTION-PASS-6.md` — checked first whether rival AI
tuning was actually still open before building anything. It wasn't;
`52` had already closed it, all six rivals, with real justified
values. That correction happened before any new work started, rather
than duplicating something already done.

**Thirty more recipes**, replicating `56`'s proven trim-ladder pattern
across the remaining six generations — every figure pulled from
`47`'s already-sourced research, none invented for the occasion.

**The part worth keeping**: three generations don't fit the five-rung
shape, and the document says so instead of forcing them into it. 2022
has three real trims, not five — building two extra invented rungs
would have been the exact kind of padding this whole six-pass effort
was built to avoid. The flat-plane and supercharged halo recipes are
genuine opposites by design — one manual-only, one automatic-only —
because that's what the real 2022 lineup actually does, not a
coincidence written in for symmetry.

**Thirty-five of thirty-five generation-rung combinations now
specified.** Still not created as actual Unity assets — that step
remains real production work, correctly labeled as such rather than
folded into "closed."

## Resolving the gap, pass 5: all five categories closed

`56-CONTENT-RESOLUTION-PASS-5.md` — the last of `51`'s five gap
categories, closed by actually opening `DriverProgression.cs` and
`PartsGating.cs` and examining every threshold individually rather than
building around them.

**Two values changed with real reasoning.** `sustainedContenderResultsRequired`
went from 8 to 12, paced against `33`'s real nine-year shop-driver
bridge rather than an arbitrary count — Licensed grade should complete
roughly when that story beat does, not on an unrelated timer.

**Five values stayed the same — and that's the actual finding.**
Changing a number just to look like something happened would have been
worse than leaving it. Three of those five now carry an explicit
comment in the code itself saying they're genuine playtesting targets,
not sourced values quietly dressed up as settled — the same honesty
this whole five-pass effort has been built on, applied one layer
deeper than documents, into the code's own comments.

**Five real recipes built** for the 1965 trim ladder — base through
tuner-halo, matching the real historical figures already sourced in
`47`. The pattern is proven. Six more generations' worth of the same
five-recipe structure is the one item left honestly open, correctly
sized as repeatable production work, not a research gap.

**All five of `51`'s original categories are now closed.** Four fully.
This one in full pattern with one generation instanced.

## Resolving the gap, pass 4: drag strips and ovals closed

`55-CONTENT-RESOLUTION-PASS-4.md` — four named facilities, built
directly from `44`'s real technical standards. Redline Raceway serves
both the drag-strip and standing-mile categories from one physical
location, since building two separate facilities for two straight-line
formats would have been redundant. Three ovals cover all three real
classification tiers in two different shapes, matching `44`'s own
point that shape variety matters as much as length.

**The one deliberate exception worth restating**: Highbank
Superspeedway's headline top speed is explicitly *not* the banked-
corner grip formula's number. `44`'s own simulation already proved
that figure would need roughly 2,150hp just to overcome drag — this
document holds the line on that finding rather than quietly reverting
to the bigger, more impressive-looking number now that a real facility
needed a spec sheet.

**One category left of the original five: RPG data assets.** Not
touched in this pass.

## Resolving the gap, pass 3: road courses closed entirely

`54-CONTENT-RESOLUTION-PASS-3.md` — the last two road course briefs
from `44`, built to real geometry. The signature-elevation-drop
circuit specifically preserves all four deviations `44` already
committed to on paper — reversed direction, single-stage drop instead
of two-stage, cliff setting instead of hillside, mid-lap position
instead of two-thirds — confirmed in the actual layout, not just
restated as intent. The technical-and-tight circuit blends three real
patterns rather than tracing one, the same discipline `44` already
called the safest possible construction.

**All three road course design briefs are now built circuits.** Four
tracks exist total: the short learnable one, the long unpredictable
one, and these two.

**Two categories left of `51`'s original five**: named drag strip and
oval facilities, and RPG data assets. Both untouched by this pass,
stated plainly rather than folded in to make the tally look better.

## Resolving the gap, pass 2: race formats fully closed

`53-CONTENT-RESOLUTION-PASS-2.md` — a real second circuit, 4.2km,
sixteen corners, three blind crests, built to the same concrete
standard as the first. Used it to close an entire gap category: outrun
already had an instance from `43`; touge, knockout, and pursuit/escape
now do too, each with a real rival, real tuning values from `52`, and
a real route rather than a placeholder.

**All six rivals have now appeared in at least one concrete event.**
Marsh gets touge specifically, matching his established archetype;
Duquesne gets both pursuit variants, matching his near-zero pass
suppression in both directions; the other four fill out the knockout
field.

**Three of five original gap categories now closed.** Two road-course
briefs and every named drag strip and oval facility remain open, and
so do actual `BuildRecipe` data assets — not touched in this pass,
stated plainly rather than left to look finished by omission.

## Resolving the gap: two of five categories closed

`52-CONTENT-RESOLUTION-PASS-1.md` — direct production against `51`'s
findings, not new research. Every number traces to something already
sourced.

**All six rivals now have real `RivalAI` tuning values**, each one
justified against its specific line in `45` rather than picked to fill
a table — Duquesne's near-zero pass suppression is the single most
extreme value in the set because his source description was the most
extreme claim in the document. Osei needed something the code didn't
have yet — his behaviour is format-conditional, not a flat ceiling —
so `RivalAI.cs` got a real extension, not a workaround.

**All seven hero-car generations are now assembled into concrete,
buildable specs.** This was the single biggest lever in `51`'s
inventory, and it closed in one pass specifically because the research
already existed in `47` — this was assembly work, not new
investigation.

**Left explicitly open, not padded**: tracks, the remaining three race
formats' actual event instances, and any real `BuildRecipe` assets.
`51`'s own rule held here too — three of five categories stay honestly
unresolved rather than stretched thin to look complete.

## The honest content-volume audit

`51-CONTENT-INVENTORY.md` — checked the question directly instead of
asserting an answer. Real numbers, category by category: seven of
seven hero-car generations have real historical research; **one of
seven** has been taken to an actual playable spec. Twenty-seven
derivation worksheets exist for the rivals — genuinely strong, real
content — but `RivalAI.cs`'s tuning fields have zero actual numbers
assigned to any of the six. One track exists. Three road courses have
design briefs, not designs. Fourteen RPG/action C# files exist with
zero data assets behind any of them.

**The distinction that matters**: every one of those gaps has a
complete, working system standing behind it. This isn't a missing
foundation — it's a real pipeline with one vertical slice built
through it so far. That's a materially better position than having
neither, but it's not the same thing as "fifty documents means fifty
units of content," which is an easy mistake to make from the outside
and, at points, from the inside too.

**Deliberately doesn't propose a target number.** How much is enough
depends on target playtime and team size, neither fixed yet — proposing
a figure here would just be a second, better-dressed version of the
same category error.

## RPG and action pillar: code written, closing the gap the last audit found

Fourteen C# files now, up from seven. `RivalAI.cs` closes a
foundational gap on its own — the four intimidation parameters `32`
specified in detail had never been implemented; the new reputation and
traits code has nowhere to write its effects without it.

**One real bug caught mid-write**: `BuildRecipe.cs` referenced
`ClassBracket` as an instance type before the file that actually
defines it, written immediately after, made it a static class instead.
Caught by cross-checking every file against every other before
integrating, not assumed clean because it compiled in isolation.

**The connection worth having as real code, not just a design note**:
`DiagnosticSkill.MentorPreemptionFactor01` is an actual computed value
now — a normalised number the installation-sequence dialogue system
can read to genuinely shorten the mentor's lines over a career, the
mechanical trigger `49` promised for an arc that was previously pure
narrative.

**Same honest status as every other file in this codebase**: written
and cross-checked for internal consistency, not compiled in Unity.

## The action pillar, expanded

`50-ACTION-PILLAR-EXPANDED.md` — the same treatment `48` and `49` gave
the RPG layer, applied to action. The aggression economy was one
paragraph with no numbers; now it has three specific triggers, a
deliberately small reward, and the exact mechanism that makes it stop
being economically rational once the player's license grade rises,
without the game ever telling the player to change how they play.

**RVP's extracted stunt code finally has a game design attached.** A
new close-call stunt type comes free — the instability meter's fill
level already computes exactly the danger-proximity signal it needs,
every physics tick. Nitrous is a real mechanical resource, raising the
traction ceiling the same way `DynoController.cs` already computes
drive force, not a flat speed multiplier bolted on top of the physics.

**The genuine gap: pursuit and escape.** `17`'s own race-type taxonomy
listed it; `41` built the other three formats and never got to this
one. Built now as two variants, matched deliberately to the rivals who
actually suit it — Duquesne as the natural pursuer, the Constant as
the natural evader — and explicitly *not* forced onto rivals whose
established character it would contradict.

## RPG elements for the player character

`49-PLAYER-CHARACTER-RPG.md` — every RPG system built so far belonged
to the car or the shop. This is the first that tracks the person, built
directly from a line already in `30`: the protagonist's real skill is
"looking at a car and knowing what it does."

**Held to the same discipline as everything else in this package**:
nothing here is a menu the player spends points in. A Driver License
Grade, distinct from class brackets, shop reputation, and Safety
Rating, earned through proven results rather than purchase. Diagnostic
skill that deepens with actual use of systems already built — the
rival inspection, post-race telemetry, the dyno — not a skill tree.

**The connection worth calling out**: `30`'s mentor-obsolescence arc
already existed as pure narrative, with no mechanical trigger.
Diagnostic skill gives it one — his installation commentary genuinely
shortens as the player's own read of the telemetry gets there first, a
beat before he speaks. A story beat that was already fully written now
fires on what the player actually did, not a fixed timestamp.

## The RPG layer, fully specified

`48-RPG-SYSTEMS-SPEC.md` closes the three RPG systems that turned out
to be genuine stubs — checked against the rest of the design rather
than assumed, since the shop-driver tier and repair costs both turned
out to already have real depth elsewhere.

**Named build recipes**: free-form saves plus target recipes with real
checkable thresholds, earning a title and livery — the reward `20`
originally promised, now grounded in the actual seven-subsystem tuning
table.

**Two-axis gating**, specified carefully to stay genuinely distinct
from two systems that already gate parts: property tier gates
facility capability, class brackets gate which events a car qualifies
for, and this new reputation axis gates which parts a shop will even
sell — three different real-world logics, not one meter wearing three
names.

**The Safety Rating**, finally given a formula. `30` had already given
it narrative weight — "the arc has a face" — but never said what
actually moves it. Now it does: contact and track-limit abuse lower it,
clean driving raises it, and below a threshold it locks knockout-event
entry outright at the professional tier. One explicit rule worth
noting: the instability meter's own findings — losing grip, recovering
clean — never touch this rating. Physics isn't conduct.

## Brakes and axles researched, five systems now confirming the same generation boundaries

Extended the same treatment to two more systems that had zero real
data anywhere in the package: brakes and axles.

**Brakes**: real specs for all seven generations, plus two genuine
historical transitions — four-wheel disc brakes arrive 1993-94, and
Brembo enters the lineage specifically in 1996, the same model year as
the 4V DOHC top-trim engine. A bonus find from the same search that
closed the mid-90s engine gap: the exact period brake spec for that
car (13in front, 11.65in rear, both vented).

**Axles**: the 8.8-inch axle replaces the 9-inch by 1986 — landing
precisely on the late-80s generation boundary already set by the EFI
transition. A completely redesigned "Super 8.8" arrives in 2015 with a
genuine Torsen LSD option, landing exactly on the Coyote engine and
MT82 transmission transitions already established.

**The finding that matters most isn't any single spec — it's the
pattern.** Five independently-researched systems now — engine firing
order, engine compression, transmission speed count, brake
configuration, axle housing type — all change generation at the same
real-world model years, repeatedly. Nobody designed this project's
seven-era structure to match; five separate research passes keep
independently confirming it already does, because it's tracking what
actually happened to the real reference vehicle.

**All five systems, all seven generations, zero remaining gaps.**

## Fully closed: the dual-clutch transmission, found on the manufacturer's own PDF

Kept searching per request — six rounds total across general specs,
forums, GT500-specific press coverage, gear-ratio-targeted queries, and
forum deep-dives. All six failed the same way: real confirmation of the
transmission's identity (Tremec TR-9070, 900Nm capacity, sub-100ms
shifts), zero individual gear ratios, anywhere.

**Closed on the seventh attempt** by fetching TREMEC's own official
product sheet directly rather than trusting another search snippet.
The actual PDF had a complete ratio table the indexed summaries never
surfaced: **3.14 / 2.05 / 1.43 / 1.10 / 0.86 / 0.68 / 0.56**, reverse
2.76, 900Nm capacity confirmed.

**One honest nuance kept in the document rather than smoothed away**:
the sheet itself notes alternative ratios are available on request, so
this is TREMEC's published baseline spec for the transmission
architecture — very likely the exact GT500 calibration, given every
other figure matches independently, but stated as "very likely" rather
than silently upgraded to "confirmed."

**All seven generations, all seven transmissions, now genuinely fully
sourced.** The real lesson from this one: a thorough search pass that
comes back empty doesn't always mean the source doesn't exist — direct
manufacturer documentation can sit past what a search engine's snippet
extraction surfaces, and it's sometimes worth fetching the primary
document itself rather than trusting the summary of it.

## Caught and closed: the one unsourced transmission

Direct question surfaced a real miss — the 7-speed dual-clutch top
trim had been named three separate times across the package without a
single source check ever run on it. Repetition had been standing in
for research.

**Now properly identified**: the real Tremec TR-9070, OEM-exclusive,
900Nm/664lb-ft torque capacity, sub-100ms shifts, in the actual vehicle
that runs 0-60 in 3.3s.

**What's still honestly unfilled**: the individual gear ratios. Two
dedicated searches found none published anywhere — plausibly because
TREMEC states this unit outright as not sold individually, unlike every
manual transmission in this document, which enthusiast rebuild
communities have reverse-engineered in detail because people actually
service and swap those. **A different kind of gap than the rest of
this document** — not under-searched, likely not public at all — and
left unfilled rather than interpolated, with an explicit fallback path
noted (derive from the real 0-60 performance envelope, labeled as
derived, never presented as sourced) if a working number is needed
sooner than the real ratios surface.

## All gaps closed: every generation, every named trim, fully sourced

Real research closed both remaining transmission gaps and both
remaining engine gaps, plus the named-trim breakdown specifically
requested: the actual TR-3160 ratios (3.25/2.23/1.61/1.24/1.00/0.63,
identical across every real 2022-era trim that uses it), the complete
10-speed automatic set (4.696 down to 0.636 across all ten gears,
corroborated across five independent sources), and three real,
named-trim horsepower figures for the same model year — 450hp base,
470hp mid-tier, 760hp top — rather than one flattened number.

**One genuinely good find**: the mid-70s base V8 was rated at
essentially the *same* net horsepower as the 1965 289 it followed. The
"heavier, softer" era (`37` §3) wasn't a horsepower story at all — it
was entirely about how the power got delivered, now confirmed rather
than assumed.

**The pattern worth keeping across the fictional lineage**: two real,
deliberate manufacturer exclusivity choices — a high-revving mid-tier
trim that never offered an automatic, and a supercharged top trim that
never offered a manual, for opposite reasons (driver engagement vs.
outright speed). `TransmissionSpec.cs`'s `isExclusiveToTopTrim` field
already exists to carry that shape forward.

**All seven generations now fully sourced on both transmissions and
engine output.** Two small, named gaps remain — two top-trim
horsepower figures known only as "higher than base," not down to the
single number — flagged rather than filled.

## Transmissions and engines, sourced across all seven generations

`47-PARTS-PRICING.md` extended with real, independently-corroborated
data for the remaining transmissions — the actual T45 (3.37/1.99/1.33/
1.00/0.67), TR-3650 (3.38/2.00/1.32/1.00/0.62, plus the real 2001-only
running change to a taller 0.67 fifth gear before Ford revised it),
and MT82 V8 (3.66/2.43/1.69/1.32/1.00/0.65) ratio sets. **5 of 7
generations now fully sourced.**

**Two gaps left explicitly flagged rather than filled**: the 2022
manual's specific ratios weren't found this pass, and the 10-speed
automatic has its two most defining values sourced (4.70:1 first,
0.63:1 top) but not the eight ratios between them — the document says
plainly not to interpolate and label it as researched fact.

**Engine horsepower and redline figures assembled across all seven
generations** for the first time — the numbers already existed in `37`
but had never been pulled into per-generation `EngineVariant` specs
beyond 1965. Same honesty rule applied: mid-70s and 2022 have no
specific horsepower figure sourced in `37` itself, so both stay
directional rather than getting an invented number.

## Parts system: pricing closed, transmissions half-populated

`47-PARTS-PRICING.md` closes two of the three gaps from the last status
check. **Correction first**: the repairable/replace-only field I
reported missing last turn already existed in `EngineFamily.cs` —
checked before building on the claim, and it was wrong.

**Pricing**: every part now costs both money and class points, so a
fully-stocked driveway car still can't buy past a bracket limit (`20`
§16). Replace-only parts have no repair price at all — the pricing
table enforces `38`'s finding mechanically, not just as a label.

**Transmissions**: three real `TransmissionSpec` assets populated with
genuine period gear ratios (the actual Top Loader 4-speed close-ratio
set, the actual T5 ratios), enough to unblock the 1965 hero car.
**The remaining four generations' ratios are flagged as an honest open
gap** rather than filled with invented numbers — `40` has the
transmission names and speed counts, not yet the specific real ratios.

## Windows portability for tonight's session

Confirmed: the six C# scripts, `Tire-URP.shader`, and the Unity project
itself are already fully cross-platform — nothing there needed porting.
**The one Mac/Linux-authored piece was the migration script.**

Added `migrate-to-unity6.ps1` — a PowerShell port for a Windows machine
without Git Bash or WSL. **Stated plainly rather than left implicit: this
port has not been run anywhere in this project**, unlike the bash
original, which was actually executed against a disposable RVP checkout
and verified clean. Same status as the C# prototype code generally —
written and reasoned through, not tested. `46-TONIGHT-BUILD-SESSION.md`
now recommends Git Bash running the original tested script whenever
either is available, and only falls back to the PowerShell port when
neither is — with an explicit note to review its first real run more
carefully than the tested version.

## Tonight's build session

`46-TONIGHT-BUILD-SESSION.md` — everything already built and researched,
sequenced into one ordered checklist for the first Unity session: clean
RVP clone, run the migration script, paste the shader (with the one
known judgment call flagged to check first), wire up all six prototype
scripts in dependency order, confirm the car drives, then the exact
five-step differential test protocol on both device tiers. Nothing new
— every step traces to a file that already exists. This just puts them
in the order to execute them without hunting mid-session.

## All 27 rival derivation worksheets, complete

`docs/derivation/` — one file per rival, every era worksheet filled
out in full per `12`'s method: feature inventory, protected/
transferable split, upstream trace, substitution plan, distance test,
build brief. Reyes (5 eras), Kade (3), Vogel (5), Duquesne (3), Osei
(4), Marsh (7) — 27 total, matching `30`'s presence table exactly.

**Zero protected features anywhere across all 27.** Every worksheet
was built from class-wide, multi-manufacturer real-world conventions —
"the rear-engine flat-six homologation GT class of the 1970s," not any
one named car — which the template itself flags as the safest possible
construction.

**Honest note**: the first pass missed one worksheet (Reyes's 2010s
generation — his presence table entry runs five eras, the first pass
only wrote four). Caught by counting headers against the presence
table rather than assuming completeness, fixed directly, noted inline
in the file rather than silently patched.

## Rival development: personalities and cars

`45-RIVAL-DEVELOPMENT.md` — the six archetypes get names (Reyes, Kade,
Vogel, Duquesne, Osei, Marsh) and personalities that mechanically drive
the AI intimidation parameters already specified in `32` §5.3, not just
flavour text next to a stat block. Reyes stays cold under pressure
almost everywhere except technical sections, where his whole philosophy
fails him; Duquesne never stops trying optimistic passes even deep into
the player's career, because that's who he is, not a tuning oversight.

**Every car lineage got real derivation work** — a real automotive
architecture researched as reference, a fictional analog built with
enough changed to stand alone, same discipline already used for the
hero car. One deliberate echo: Vogel's lineage mirrors the hero car's
own two-engine-family structure, crossing a naturally-aspirated-to-turbo
transition at roughly the same point in the timeline — free historical
texture neither car needed to share on paper.

## The track roster

`44-TRACK-ROSTER.md` — sanctioned drag strips and high-speed ovals
(real NHRA/UEM/NASCAR-class standards, built directly, since these are
functional specifications, not creative works), plus three original
road courses.

**The road courses got the full derivation treatment** (`12`), the same
one already applied to the hero car. One design decision worth
flagging: a single downhill elevation-drop corner is the most
recognizable element in this entire document, so it's the one
deliberately reworked hardest — reversed direction, different elevation
profile, a cliff setting instead of a hillside, positioned differently
in the lap. Named and treated the same way `13-MUSTANG-DOSSIER.md`
treats the Eleanor hood scoop: identify the single most recognizable
feature, then make sure it's the one thing you don't copy.

**One honest correction inside it**: half-mile and full-mile aren't
real sanctioned drag distances — reframed as standing-mile events, a
real and distinct motorsport category, rather than inventing a fourth
and fifth drag format that doesn't match how the sport actually works.

## First-playable specs: items 3 through 10, made concrete

`43-FIRST-PLAYABLE-SPECS.md` — the numbers behind `42`'s checklist. The
1965 hero car's exact starting stats (164hp, degraded from the ~195hp
base spec, matching the restoration narrative), a real eight-corner test
circuit designed specifically to exercise the instability meter's full
range, the first outrun instance's concrete parameters, and exact
starting values for every tunable field in `RaggedEdgeMeter.cs`.

**One real design catch**: the Constant's "front-drive hot hatch"
description doesn't work for his 1965 appearances — that car category
didn't exist until the late 1970s. Fixed with an era-correct rear-drive
compact for his early appearances, corrected directly in `30`.

## The path to live testing

`42-PATH-TO-LIVE-TESTING.md` — the first document that reads all the
others as one ordered checklist rather than independent research. Three
blocking items (compile against real RVP, confirm the car drives, the
dyno pass condition on both device tiers), a minimum content list to get
a test loop running at all, what's needed for that test to be meaningful
rather than just functional, and an explicit deferred list — not because
those systems don't matter, but because none of them change the answer
to what the blocking section is testing.

## The three unspecified systems, closed

`41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` — `20-CONCEPTS.md` named five
systems in one paragraph each and never returned to them. All five now
fully specified: three race formats (outruns, touge duels, knockout
events, each mapped to a career tier and tied to the physics that
already exists), the time-shifted ghost and Autolog system, and
objective-based star scoring.

**The finding worth keeping**: ghosts are the mechanical delivery system
for rival persistence (`30` Part 3). A rival's recorded best run stays
raceable forever, even after they've left the career narrative — the
player can chase the Constant's 1978 lap in 2022, as a ghost, even though
the narrative Constant of 2022 can't drive any more. Zero additional
content cost beyond the recording system this document already
specifies.

## Forced induction, crank type, real transmission history

`40-FORCED-INDUCTION-DRIVETRAIN.md` — turbos, superchargers,
intercoolers, blow-off valves, cross-plane vs flat-plane cranks, and
manual/automatic transmissions from 3 to 10 speeds, matched to real
Ford/Mustang counterparts across all seven hero-car generations.

**Built, not just documented.** `EngineFamily.cs` extended with crank
type and forced-induction fields; new `TransmissionSpec.cs`. The real
finding worth knowing: flat-plane crank is a **variant**-level choice, not
a family-level one — real flat-plane cylinder heads run on real
cross-plane bottom ends, so the top-tier high-revving option lives inside
the existing final-generation engine family rather than requiring a
third acoustic family. Superchargers are genuinely period-correct from
generation one (a real 1965-72 dealer-adjacent option); turbocharging
stays aftermarket-only throughout, matching the real lineage's honest
gap; automatics alone span a real 3->10 speed progression across the
seven generations.

## All three findings, built

Not just cross-referenced — implemented. `code/prototype/`:

- **`EngineFamily.cs` / `EngineVariant.cs`** — the three-times-confirmed
  family/variant data model, wired directly into TORSION's real `Engine`
  component (`torqueCurve`, `redlineRPM`). Five of the hero car's seven
  generations as variants of one family; the last two as a second family,
  matching `37`'s acoustic finding exactly.
- **`EngineBayMeshManager.cs`** — the fix for Automation's measured
  draw-call problem, applied to `25`'s installation sequence: individual
  part meshes only while a sequence is actively playing, merged into one
  mesh everywhere else.
- **The rigid-body platform decision** is now formally closed in `02`,
  not just cross-referenced — stated as settled on two independent legs
  (cost, and player preference evidenced by BeamNG's own community) and
  not to be revisited without new information on both.

## The mechanic-game spectrum: four more games, and a question answered

`39-MECHANIC-GAMES-SPECTRUM.md` — the same treatment as `38`, extended to
My Summer Car, Jalopy, Automation, and BeamNG/Wreckfest, placed together
on one granularity spectrum from Jalopy's seven total components to My
Summer Car's individual-bolt assembly.

**This closes the open question `38` left.** Jalopy independently
validates category-level parts — this project's existing default — as a
complete, legitimate design point, not a placeholder waiting for more
detail. Extra granularity is optional, and if spent anywhere, the hero
car is the reasonable place to spend it.

**Three findings worth carrying forward:**

- **A third confirmation of the family/variant structure** — Automation's
  engine-design tool splits a fixed architecture "family" from tunable
  "variants" within it, independently matching both real Ford history
  (`37`) and CMS's engine-matched parts (`38`). Three unrelated sources,
  one shape — worth modelling the data that way.
- **A real, transferable performance bug**: Automation's own community
  found exporting an engine as many separate meshes nearly tripled
  render draw calls in BeamNG. Directly relevant to `25`'s installation
  sequence — merge the engine's part meshes after the vignette plays,
  keep full separation only during it.
- **A second, independent argument for the existing rigid-body platform
  decision**: BeamNG's players have long wanted to cleanly remove an
  already-broken part and structurally can't, because soft-body
  simulation has no native concept of a discrete part. This project's
  discrete-parts approach is validated by cost (`35`) and now by player
  preference too.

## Car Mechanic Simulator: the removable parts taxonomy

`38-CMS-PARTS-TAXONOMY.md` — what's actually individually removable in a
game built entirely around disassembly, and what it validates or adds to
the garage spec.

**The real finding: CMS's exterior/engine-bay/component disassembly
structure is the same three-tier station model `25` already
specifies** — arrived at independently, which is stronger validation than
either design alone would be.

**Two smaller additions, both recorded as open rather than forced in:**
a repairable-vs-replace-only distinction per part (a gearbox and clutch
plate are replace-only in CMS — no repair path exists, a real mechanical
truth worth the mentor being able to say out loud), and the question of
whether this project should match CMS's genuinely granular component-level
parts (dozens of individually named engine-bay pieces) or stay at the
category level `25` currently uses. Three options laid out, none chosen —
worth resolving before the parts wall is actually built.

## Ford V8 audio: idle to redline, all seven generations

`37-FORD-V8-AUDIO.md` — real Ford V8 engineering history, researched as
reference material for the hero car's fictional engine (`12`'s derivation
method, the same relationship `13-MUSTANG-DOSSIER.md` has to real
Mustangs). Full idle/street/race/redline/shift breakdown per era.

**The headline finding is a budget strategy, not trivia.** Firing order,
not valve architecture, is what makes a V8 "sound like itself" — a 1965
small-block and a 1996 SOHC modular V8 share almost no hardware and still
read as acoustically related, because they share the same firing order.
**Only one genuine acoustic family transition exists across sixty years of
this lineage, and it lands on the hero car's last two generations.** Five
of the seven generations can share core engine loops with era-specific
texture layered on top — carburetor roughness, EFI smoothness, emissions
muffling, tonal EQ shift — rather than requiring seven full builds from
scratch against `10`'s existing 16–20-loop-per-vehicle budget.

## iPhone-specific: haptics and ProMotion

`36-IPHONE-SPECIFIC.md` — not a repeat of `26`'s 50-title survey. Two
platform-level findings that map directly onto systems already specified.

**Core Haptics.** Apple's own reference example for the framework is a
wall/impact collision with audio and haptic intensity scaling together —
not analogous to this game's barrier contact, one. The instability meter's
fill level (`20` §1) should drive a continuous haptic pattern on the same
value already feeding the three-tyre-sound audio crossfade (`10`) — on a
phone with no force feedback, a rising buzz under the thumb may register
the limit before the visual meter does. **Haptics work on iPhone, not
iPad** — for an iPhone-first project with Android "eventually," that's
confirmation the core platform gets the feature free, not a gap.

**ProMotion — a finding that changes what "pass" means.** One frame at
120Hz is 8ms; at 60Hz it's 16ms, confirmed from Apple's own developer
material. **The dyno prototype's pass condition — can the player feel a
differential change through tilt — may pass on Pro-tier ProMotion devices
and fail on base-tier 60Hz ones, with the physics completely unchanged.**
`31` Part 7 now specifies testing both tiers rather than trusting a single
device's result — a real, previously-undocumented risk, not a hypothetical
one.

## Beyond Beckman

`35-EXTENDED-SOURCES.md` — six further sources researched directly, split
honestly between what's free and what isn't.

**The single best finding of this whole extended pass**: a 2025 academic
paper (`35` §3.1) gives a precise, cheap, real-time oversteer criterion —
**`|a_y − v·ψ̇| > ε_threshold`** — that supplies a third, independent
confirmation of the instability meter's threshold, computable from quantities
the physics engine already produces every tick. Now in `20` §1.

**OptimumG's living technical papers** (`35` Part 1) extend two things
already in the package: jacking forces explain why ride height moves *during*
a corner rather than staying at its set value, which matters because
downforce is ride-height sensitive; and anti-dive/anti-squat are shown to be
coupled front-to-rear, not independent sliders — with a worked example where
raising front anti-dive made the whole car sit *lower* under braking. Both
now in `25` §5.

**A free government database** (`35` §2.1) — NHTSA's Light Vehicle Inertial
Parameters — gives real CG height and inertia figures for production
vehicles, which turns the hero car's polar-moment-of-inertia differentiation
(`32` §7.0) from an estimate into something you can look up.

**And BeamNG confirms rather than challenges the existing approach**: even a
studio running a decade of dedicated soft-body physics still names tyre
modelling as one of their hardest open problems, for the same reason flagged
throughout `34` — real tyre data is scarce everywhere. Their 2kHz node-beam
simulation is the far end of the fidelity spectrum, useful as a sense of
headroom, not a target for a mobile platform.

**A second research pass on the six commercial textbooks** (`35` Part 5)
produced an honest, uneven result rather than uniform coverage. **Milliken
improved the most** — two separate open-source, LGPL-licensed implementations
of the Milliken Moment Method exist (`TUMFTM/YawMomentDiagrams`, plus the
g-g-g-v repo already covered), giving working reference code for yaw-moment
and stability characterisation without touching the book's text. **Pacejka
improved too** — the actual Magic Formula equation, independently restated
across several current academic papers, plus a reading list of open PhD
theses extending it. **Gillespie improved narrowly**, after search results
surfaced apparent unauthorised full-text scans that were explicitly
discarded — one legitimate quote survived, from Gillespie's own public expert
testimony. **Genta, both Carroll Smith titles, and Segers did not improve**
beyond what was already in the package, though Segers' scope is now confirmed
via its bibliography and topic index. **If you want the remaining four
covered properly**, the same method that closed the Beckman gap applies:
obtain the book, supply the relevant pages.

## The physics reading list is complete

**All 29 chapters of Beckman's "Physics of Racing" are now covered in `34`,
read from primary sources.** Twenty-one were retrievable by search; the
remaining eight — 13, 15, 16, 17, 18, 19, 27, 29 — were never mirrored
anywhere a search engine could reach them, and closed only when the user
supplied the original scanned PDFs directly.

**Seventeen findings from reading Beckman directly that changed other
documents:**

- **The instability meter is not an authored abstraction.** Beckman's circle of
  traction (Part 7) *is* the ragged edge — the meter is how close you are to the
  boundary, and a wipeout is asking for more than μg. Per-wheel
  `sqrt(a_x² + a_y²) / (μg)`, integrated with decay. **The one signature mechanic
  that looked invented turns out to be a readout of a real quantity.** (`20` §1)
- **Thermal throttling degrades physics accuracy, not just frame rate.** Growing
  Δt grows integration error — Euler diverges 60% over 100 seconds on the
  simplest possible oscillator. **The handling model itself is worse at minute
  twelve than at minute one.** Fixed timestep, and substeps tied to thermal
  state. (`03`, and the dyno pass condition in `31` now says measure it warm)
- **Tyres make three sounds, not one.** *"Squeak when nearing the limit, squeal
  at the limit, squall over the limit"* — the last at lower frequency as the
  grip/slide cycle passes its optimum. **That is the instability meter rendered
  in audio**, and on a phone with no force feedback it may carry more information
  than the visual meter. (`10` §4)
- **Assists are intent-inference, not difficulty steps.** *"Understeer and
  oversteer are terms of intent."* Each assist has a specific correction — and
  the understeer one is the opposite of player instinct: **less** steering lock,
  plus weight transfer to the front. **Removing an assist becomes a lesson the
  mentor teaches**, not a slider. (`22` Part 4)

- **The instability threshold is precise, not chosen.** Part 25 plots combined
  slip against grip and finds a central **"cup" region**: inside it, more slip
  gives *more* grip and you can recover; outside it, more slip gives *less* grip
  and correcting makes it worse. **That is why losing a car feels like falling
  rather than sliding** — and the boundary moves with load, surface and compound
  by itself. (`20` §1)
- **Smooth is fast for a physical reason.** Suspension and tyres are damped
  harmonic oscillators at roughly **4 Hz**, and sinusoidal inputs match that
  response while step inputs excite it. **So the meter must read input *jerk*,
  not just cornering load** — a jerky driver loses grip at the same load a smooth
  one survives. (`20` §1, `22`)

- **A four-wheeled car is statically indeterminate**, and that is *why weight
  jacking works.* Three equations, four unknowns — wheel loads cannot be solved
  from statics. A tricycle can't be jacked; a car can. **Cross-weight is a real
  tuning axis the spec didn't have**, and it comes free if per-corner load derives
  from spring compression rather than a statics solve. (`25` Part 5)
- **The five SAE coordinate frames**, which Beckman calls one to keep on hand:
  EARTH (Z points *down*), CAR, PATH, ROADᵢ, WHEELᵢ — the last excluding camber.
  Plus two gifts: the small-angle approximation holds to ~12% even at 20°, and
  orthogonal matrices invert by transposition. (`34`)
- **A second physical axis for the hero car's seven generations: polar moment of
  inertia.** `J = Σmr²` — the rotational equivalent of mass, set by *where*
  weight sits, not how much. Early big-block generations are high-PMI (strong
  straight-line, reluctant to turn); later centralised-mass generations are
  low-PMI (quicker through transients). A second felt difference across the
  car's history, derived rather than authored. (`32` §7.0)
- **A complete, worked racing-line optimiser, by hand, in a spreadsheet.**
  Corner geometry, a traction-circle-constrained search over throttle ramp and
  steering unwind time, and a found optimum ~0.3s better than a naive line —
  with Beckman's own note that his hand-tweaking should lose to real
  algorithmic search. **A direct recipe for generating AI waypoints offline
  rather than hand-placing them.** (`04`, rival AI)
- **An honest, unresolved tension in Beckman's own writing**, presented as such
  rather than silently resolved: his 2000 defence of a 4 Hz suspension
  resonance (using a real Group C Ferrari as evidence) doesn't fully agree with
  his 2002 errata correcting it to 0.64 Hz as a units slip. **Measure your own
  suspension's natural frequency rather than hard-coding either number.** (`34`)
- **The exact closed-form four-corner weight-transfer solution** (Part 27) —
  the formula Part 20 established the need for, using precisely the symmetry
  assumption already chosen in `25` §5. One term in it, `R̄_A`, **is the
  cross-weight tuning knob made explicit**, built from track-width asymmetry
  and lateral CG position, cheap enough to evaluate every physics tick as a
  cross-check on the suspension model. (`25` §5, `34`)
- **A three-parameter tyre-force formula, written by Beckman explicitly for
  game simulation** (Part 29): `F = B·Fz·α / (1 + |A·α|^P)` — one division, one
  absolute value, one power, differing from full Pajecka by under 10% almost
  everywhere. **Likely the right starting tyre model for the dyno prototype
  itself** — three tunable numbers per compound instead of eleven-to-fifteen,
  and cheap enough for every wheel on a phone. (`31` §6.0b)
- **The tyre chapter is now complete** (Parts 21, 22, 24, 25). The magic formula
  is *"not a solution to equations of motion... just a convenient fitting of
  commonplace mathematical functions to data"* — and that is exactly why it suits
  a phone: **accuracy without an integrator in the inner loop.** Longitudinal
  peaks at **8% slip**, lateral at **4° slip angle** — which is the
  commensurability problem of Part 25 made concrete.
- **Pacejka is speed-blind.** No velocity term at all, because speed effects can't
  be separated from temperature on a test rig. Combined with its low-speed
  divergence: wrong at crawl, speed-blind everywhere else.
- **A real dyno computes torque as `RPM ratio × J × drum angular acceleration`**,
  which is why chassis figures run 15–20% under test-stand numbers — and **a
  smooth velocity ramp produces a fake flat torque curve**, so drive the sim from
  the torque curve and let the ramp fall out. (`31` §6.0)

Also now in `34`: the weight-transfer equation with worked numbers, a complete
straight-line integration model with real constants, the a=v²/r cornering table,
racing-line timings showing the inside line loses **0.9 seconds in one corner**,
and a launch mechanic with an audio tell.

## Open decisions — all five resolved

Every item that was open is now decided, with the reasoning and the ripple
effects written into the relevant documents rather than just recorded here.

1. ~~Single hero car or a garage of many?~~ **Resolved** — `32-HERO-CAR.md`
   specifies a single persistent hero car across seven generations, plus a
   supporting roster of six rival lineages (`30` Part 3).
2. ~~Does the player do the mechanic work, or only pay for it?~~ **Resolved:
   both.** The player does the work personally, or pays staff once the
   property ladder unlocks them — no new currency, just `33` §5.1's existing
   weekly-activity slot changing hands for money instead of time. Full
   mechanism in `25` §6.2b, with a knock-on effect on the mentor's arc in
   `30` §1.4.
3. ~~Is Android a real target?~~ **Resolved: yes, eventually.** iOS ships
   first; Android is a planned second platform, not deferred indefinitely.
   The Android sidecar device recommended throughout this package stops being
   a disposable iOS testing proxy and becomes the first unit of the platform
   it will actually ship on. Full consequences — device fragmentation, likely
   quality tiers, separate store submission — in `03`'s new Android section
   and `02`'s toolchain note.
4. ~~Which of sim, action, or RPG is the reason someone plays?~~ **Resolved:
   simulation.** Action and RPG are built to full spec, not afterthoughts —
   but when a scope cut is needed, it comes from those two first, never from
   the physics. Build order, asset budget, and audio budget all follow this
   priority now (`11` §4). The dyno prototype is simultaneously the first
   thing to build and the test of whether this decision holds.
5. ~~The intimidation factor's mechanism?~~ **Resolved: the AI-behaviour
   alternative.** Rivals brake early, abandon passes, defend badly, and
   hesitate at the line — never a flat stat bonus. Four concrete tunable
   parameters, and the strength of the effect is now tied to each persistent
   rival's actual history with the player (`30` Part 3), so intimidation is
   earned per rival rather than innate to the car. Full spec in `32` §5,
   including the original flat-bonus version kept as a considered-and-rejected
   record.

---

## Immediate next actions

**Renumbered — this list had accumulated duplicate entries (two "4"s, two
"5"s) from incremental edits across sessions. Fixed below, and the two
newest items (the numerical simulation and the fix it produced) are now
actually in this list rather than only in the conversation that made them.**

1. Read `01-LICENSING.md` before opening any code.
2. **Do not** reach for Vehicle Physics Pro Community Edition as your foundation
   — it is **desktop-builds-only, 1 vehicle per scene, single ground material**,
   so it cannot ship on iOS or run an AI field. It is an excellent *desktop feel
   benchmark*: drive it to learn what a correct tyre model feels like, then judge
   RVP against it (`02`).
3. **Skip `com.unity.vehicles`** — ECS-only, experimental, and Unity states it
   targets "a medium level of vehicle physics realism." Medium by design is the
   wrong tool when depth is the differentiator. Read the ECS sample's *race
   system designs* (`04` §3); ignore the vehicle package.
4. **If RVP does not survive the port**, price **VPP Professional** — modular
   drivetrain, five differential types including Salisbury and Torsen, Pacejka
   tyre models, and it ships to mobile. Quote-based, so you have to ask.
5. **Read `34-PHYSICS-READING.md` Part 4 first** — Beckman's Physics of Racing
   parts 1–5, then Monster. Two evenings, free, and it changes how you read every
   line of RVP.
6. **The RVP triage is done — see `code/prototype/RVP-TRIAGE.md`.** Cloned and
   inspected directly, not estimated: **27 deprecated API call sites across 13
   files**, all mechanical renames (`velocity`→`linearVelocity`, `drag`→
   `linearDamping`/`angularDamping`, three `FindObjectOfType` calls), with a
   **tested migration script** (`migrate-to-unity6.sh`) that applies and
   verifies them. The tire shaders looked scarier than they are: both are
   legacy Surface Shaders URP's converter can't touch, but the actual custom
   logic is one ~15-line vertex-deformation trick, **identical in both shader
   files**, already ported to a working URP replacement (`Tire-URP.shader`).
   Only two tags are actually required (`Underside`, `Pop Tire`), not a long
   list.
7. **The dyno and instability-meter prototype code has been numerically
   validated — see `code/prototype/simulation/`.** The exact formulas from
   `TireForceModel.cs` were ported to Python and run for real: an open vs.
   locked differential produces a **71% force difference at 0.7g lateral
   load**, which converts to a **2.32-second (43%) difference in corner-exit
   time** through the same RK4 integrator `DynoController.cs` uses — the
   first two of the dyno's three pass-condition criteria (`31` Part 7),
   confirmed numerically. **The simulation also found and fixed a real bug**:
   the shipped lateral tyre defaults produced an implied friction coefficient
   of ~8.9 (physically impossible; real tyres run 1.0–1.7), caught only by
   actually running numbers through them, not by code review. Fixed in
   `TireForceModel.cs` and documented inline. **What's still unknown, and can
   only be answered in the editor on a phone: whether the physics feels good,
   and whether that same 43% difference is perceptible through tilt** — that
   is the one number no amount of static analysis or numerical simulation can
   give you in advance.
8. **Profile on a real iPhone for 15 minutes** (`03`). Thermals and frame pacing
   decide whether this design ships.
9. Play **CarX Street** and **Assoluto Racing** (`07` §3.1–3.2). CarX Street is
   close enough to this concept that you need an answer to "how is mine
   different." Everything else here is about *how* to build; those two tell you
   what you are building against.

---

## Deliberately not in this package

- **PERRINN Project 424** — no licence grant; both dependencies non-commercial.
- **Art or audio from any repo.** All bundle third-party assets the authors
  cannot sublicense.
- **The Unity ECS sample source** — Unity Companion Licence, requires Git LFS,
  actively maintained. Clone fresh; file index included.
- **Anything from Mad Max, Outlander, the Mustang games, Top Gear, Street Racer,
  or any other commercial title.** All proprietary. Documents 05, 06, 13–18
  analyse mechanics, which are not copyrightable. No assets, no game data.
