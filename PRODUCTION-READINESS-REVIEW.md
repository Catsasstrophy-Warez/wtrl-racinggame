# Production-Readiness Review — Rev14.3

A simulated pass over every feature area in `FEATURE-LIST.md`, scored against
what "production ready" actually requires: not just "does the code look
correct" but "would this survive a player touching it." Written 2026-09-06,
after three fix/wiring passes (Rev14.1 deep-dive, Rev14.2 fixes, Rev14.3
wiring).

**This cannot be a real simulation.** Unity 6000.0.58f2 is not available in
this environment, so nothing here has compiled, entered play mode, or run a
frame. Every score below is a *reviewed-static-analysis* estimate, not a
measured one. Treat every number as a ceiling, not a guarantee — the actual
number for anything is 0% until it compiles. Item 1 of the punch list at the
end exists to make that stop being true.

---

## How to read the scores

Two axes, because they answer different questions and conflating them is how
"92 tests written" gets mistaken for "the game works":

- **Engineering readiness** — is the code complete, internally consistent,
  and covered by a test that would catch a regression? This is what static
  review and the 106 EditMode / 20 PlayMode tests can actually support.
- **Product readiness** — if this shipped today exactly as it is, would a
  player experience a finished feature, or a stub, a single data point, or
  nothing at all? This is gated by content, UI, and design completeness, not
  code correctness.

A feature can be engineering-ready and product-not-ready at the same time —
most of the garage/diagnostics stack is exactly that: correct, tested code
with no UI and one authored car to point it at.

Tier legend used in the verdict column:

| Tier | Meaning |
|---|---|
| **A** | Would hold up under real play, pending the compile gate |
| **B** | Functionally complete, but thin content/UI or an edge case away from A |
| **C** | Real code, but either unreachable, unexercised by content, or missing the piece that makes it matter |
| **D** | Structurally present but not the thing it needs to be (the tyre model) |
| **F** | Not built |

---

## 1. Vehicle physics — **Tier D**, Engineering 60% / Product 35%

The suspension, gearbox, aero, and braking models are complete and
self-consistent — nothing here is a stub. But the tyre force model is the
one piece this entire game's thesis depends on, and it's wrong in a specific,
consequential way: `Vector2.ClampMagnitude` at `VehicleController:196`
saturates at the friction limit instead of peaking and falling off. That
means the car plows instead of spinning out, which `WHERE-WE-ARE.md` already
identified as blocking the signature mechanic. Slip ratio/angle are computed
as telemetry but never fed back into force (`VehicleController:202`), so
there is no closed loop to tune against yet.

There is no differential model at all — `Differential` is a torque-capacity
bottleneck, not a solver behavior. Every "tune the diff and feel it" claim in
the research is currently untestable because there's nothing to change.

**What would move this to B**: port `Prototype~/Physics/TireForceModel.cs`
behind a feature flag, keep `ClampMagnitude` as fallback, re-run the PlayMode
suite on both. This is the highest-leverage single change available and the
riskiest one — budget a real QA pass around it, not a quick swap.

**Blocking production**: yes, for anything that claims tuning depth as a
selling point. Not blocking for shipping the current lap-race vertical slice
as-is, which doesn't ask the tyre model to do anything subtle.

---

## 2. Race loop — **Tier A**, Engineering 85% / Product 55%

This is the most production-ready system in the project. State machine,
pre-flight validation, grid staging, lap counting, ranking, sector timing,
DNF/DNS, out-of-bounds recovery, and deterministic seeding are all present,
each with a defensible implementation and PlayMode coverage (race lifecycle,
100-race ledger stability). The Rev14.2 fix (injectable `raceId`) closed the
one real correctness gap (AI mistake reproducibility).

Product score is lower only because there is exactly one format (N laps on
one circuit) against four specified (outrun, touge, knockout, pursuit). As an
engineering artifact this is done; as a product it's a tech demo of one race
type.

**Risk**: the non-atomic save write (§10) sits directly downstream of every
race result — a crash between delete and move during the auto-save-on-results
path is the one way this system's correctness doesn't protect the player's
progress.

---

## 3. Opponent AI — **Tier B**, Engineering 75% / Product 60%

Racing line following, deterministic mistakes, defensive positioning, and
the four-state tactical brain (attack/defend/conserve/recover) with
relationship-scaled parameters are a genuinely sophisticated AI for a single
lap-race format. `RivalRaceBrain.ConfigureRelationship()` turning respect/fear
into brake-point bias, pass suppression, defensive error rate, and launch
delay is a real implementation of "rivals feel different," not a difficulty
slider with a rival's name on it.

The one gap that used to be a real correctness bug — `BrakeCapacity`
falling through to `default` and doing nothing — is fixed in Rev14.3. All
five weakness types now have behavior.

**What's missing for A**: this has never raced against more than the single
authored rival generation per era in practice (no compiled run to confirm
pack behavior with 3+ AI cars), and there's no tuning pass on the tactical
thresholds — they're each individually reasonable, untested in combination.

---

## 4. Rivals and career — **Tier B**, Engineering 80% / Product 45%

The data model is the deepest and most complete non-diagnostic system in the
project: six rivals, 28 authored vehicle generations, persistent
per-generation wear, relationship history, hero lineage, and reference-lap
capture that's now honest about truncation (Rev14.2). `BuildDossier()` is
wired in Rev14.3 and actually scales with measured workshop knowledge rather
than a constant — a real payoff for the garage-operations work.

Product score is capped hard by content: 1 of 7 hero generations exists, 1
of 8 tracks, and the "era/chapter/story beat" fields (`CareerData`) have
structure but no authored beats to move through. `currentRole` /
`retiredFromDriving` / `successorId` are still write-only — succession is
modeled in the schema and absent in play. Reference laps are captured
(80-lap cap) and still consumed by nothing, so "ghost of your rival's best
lap" is data sitting in a save file, not a feature.

---

## 5. Economy — **Tier B**, Engineering 80% / Product 40%

Cash, entry fees (now transactionally refunded on abort, Rev14.2), payouts,
idempotent rewards, and a reversible ledger are correctly built and cover the
one loop that exists (enter a race, pay or get paid, repair). This is
engineering-solid.

But `WHERE-WE-ARE.md`'s Chain C finding stands: this is one of three
specified economic sinks with the other two (class brackets, property tiers)
absent or shell. Reputation accrues and gates nothing. Shipping the economy
exactly as-is works for the vertical slice and will not hold as more content
and races are added — there's no license-class wall to stop a player from
grinding into content they shouldn't reach yet, because there's no such wall
at all.

---

## 6. Garage and parts — **Tier A** (core) / **Tier B** (operations layer), Engineering 85% / Product 55%

The component-instance model — unique parts, multi-axis condition, hidden
vs. believed state, transactional install with rollback, ownership
integrity checked at mutation *and* load, capability resolution with named
bottlenecks — is the strongest engineering in the codebase. This has real
edge-case handling (duplicate ownership, displaced-part restoration) that
most systems this deep skip.

Rev14.3 took the biggest single step of the three passes here: fitment
enforcement (`SupportsPlatform`, `requiredSpecificationIds`) went from
authored-and-ignored to actually gating installs, and `LastInstallRejection`
gives a real reason. Inspection, scrutineering, and event logistics all went
from zero-caller services to called services with authored fallback content
(a loose first-event homologation rule set, a tow rig that fits with
margin).

What keeps this at B rather than A for product: there is still no UI for
any of this. `CanFit()`, `Scrutineer()`, `ValidateLoadout()` all return
correct, well-reasoned results that nothing on screen shows the player yet.
`VerticalSliceHUD` predates all of it. This is real backend for a feature
whose front end doesn't exist.

The four superseded types (`EngineSpec`/`TransmissionSpec`/`BuildRecipe`/
`ContentCatalog`) are dead weight, not risk — they cost nothing at runtime
and are flagged for deletion pending your call.

---

## 7. Vehicle intelligence and diagnostics — **Tier A** (engineering) / **Tier C** (product), Engineering 85% / Product 30%

This is the deepest, best-tested subsystem in the project and it has no
counterpart in the design research at all — it grew organically across
Rev12-13 into something the 21-system spec never asked for. Sensor sampling,
gated learning, threshold + envelope-anomaly alerts, hypothesis ranking with
evidence chains, black-box fault recording and reconstruction, self-test,
maintenance outlook, and the Rev14.2 retirement service that stops learned
state from latching forever — all of it is coherent, cross-referential, and
covered by dedicated tests (`Rev15DiagnosticsRetirementTests`, 9 tests
specifically targeting the latching-bug cluster).

Product score is the lowest in the project relative to its engineering
depth, and for a structural reason: **nothing surfaces this to the player.**
There is no diagnostics screen, no alert notification, no hypothesis list,
no problem board UI. `DeveloperHUDController` exposes raw numbers for
debugging, not the diagnosis-the-fault gameplay loop this system is clearly
built to support. This is the textbook case of "wired is not the same as
playable" — Rev14.3 gave the garage-operations half of this a caller
(`GarageOperationsService`), but the diagnostics half's output has never had
a screen.

**Recommendation**: before adding anything else here, this needs a minimal
UI pass — even a text list of open alerts and the top hypothesis — or the
investment stops compounding.

---

## 8. Engineering lab (setup and tuning) — **Tier B**, Engineering 80% / Product 35%

A complete, separate acceptance-test-and-optimization harness: 7 instrumented
tests with envelopes and scoring, single-parameter and multi-parameter DOE
tuning, protected-regression guards, setup memory with priors, and both
track and driver fingerprinting with a similarity search and bias-adjusted
recommendations. This is real engineering and it's the one place the project
already has export tooling (CSV/JSON) for its own telemetry.

It is explicitly not the dyno the research specifies (`31-DYNO-ANALYSIS.md`)
— that's a player-facing torque-curve instrument, and this is an automated
optimizer. Product readiness is capped because this lives in a separate
scene with its own builder, disconnected from career progression — a player
would need a reason inside the game to ever open it, and none exists yet.

---

## 9. Progression systems — **Tier C→B** (moved this pass), Engineering 65% / Product 20%

This category changed the most in Rev14.3. Seven of nine collections that
were pure data-only (`tools`, `facilities`, `mechanics`, `transportAssets`,
`eventLoadouts`, `mechanicalKnowledge`, `builderReputation`) now have real
readers and accrual paths through `GarageOperationsService`. Two
(`customerJobs`, `specialistRelationships`) are correctly left as `RESERVED`
rather than fake-wired.

The honest caveat, stated in the updated feature list: **wired is not
gating.** Reputation and knowledge move and feed inspection accuracy and
install workmanship, which is real mechanical effect — but nothing here
unlocks content, no license class exists, no property tier changes what a
player can do. This moved from "inert" to "has effect" without yet becoming
"the progression system" the research specifies. Treat it as plumbing that's
now connected to something, not as the finished feature.

---

## 10. Persistence — **Tier B**, Engineering 85% / Product 75%

Schema versioning with a contiguous, validated migration chain (1→7),
integrity checks that reject a corrupted or inconsistent save, and
backup/recovery are all solid. This is the part of the project closest to
"would survive contact with a real player's save file."

One real, flagged risk remains unfixed by design (it needs a decision, not
wiring): the non-atomic write is delete-then-move rather than
`File.Replace()`. A validation failure between those two steps starts a new
career, and the next two saves overwrite both the primary and the backup —
the exact failure mode backup/recovery exists to prevent, undermined by the
write path underneath it. **This is the single highest-value bug fix left
in the project outside the tyre model** — small, well-understood, and
directly threatens player trust in the save system if it ever fires.

---

## 11. UI and developer tooling — **Tier C**, Engineering 70% / Product 25%

The scene-generation pipeline (first-playable builder, lab builder,
auto-bootstrap) is genuinely production-grade tooling — it's how every
"content" number in §12 gets built at all, and it's why three fix passes
could each seed new authored assets (homologation rules, workshop starting
inventory, tow rig, loadout) without hand-authoring scenes. The structural
validator (26 real checks) and four content validators are real CI-adjacent
tooling most solo projects don't have this early.

Product score is low because the actual player-facing UI —
`VerticalSliceHUD` — has not moved since before this project's diagnostics,
capability-resolution, or operations-service work landed. It shows garage/
race/results modes, repair, cash, and condition. It does not show a single
thing built in the last three passes: no fitment rejection reason, no
inspection result, no capability bottleneck explanation, no diagnostic
alert. The gap between backend depth and front-end surface is the widest
gap in the project.

---

## 12. Content — **Tier F** (against the research spec) / **Tier A** (for what it claims to be, a vertical slice)

Exactly what `51-CONTENT-INVENTORY.md` already said and six "closed"
resolution passes didn't change: 1 hero generation of 7, 1 rival of 6
technically-complete-on-paper, 1 track of 8, 1 race format of 4, 0 of 35
build recipes, roughly 10 baseline component definitions against a full
catalogue. Zero `.asset`/`.unity`/`.prefab` files ship — everything is
generated at edit time.

This is not a regression to fix; it's the accurate description of "one
vertical slice," and it's fine as long as it's labeled as one. It becomes a
production-readiness problem only if it's mistaken for more than that when
scoping what's left.

---

## 13. Testing — **Tier C**, Engineering 70% / Product N/A

106 EditMode tests, 20 PlayMode tests, and a 26-check structural validator
verified by mutation testing (deliberately broken 6 things in a scratch
copy, confirmed each corresponding check flips to FAIL) is real coverage of
real behavior — not the token-presence checks the validator started as.

The number that matters more than either count: **zero of them have ever
run.** No test in this project has executed against a compiled Unity build.
Every "passes" claim in every report this project has produced, including
this one, is "would pass by static reading of the assertions against the
code," which is a much weaker claim than "passes." This is not a criticism
of the tests — it's the load-bearing caveat for everything above it.

---

## Cross-cutting risks (apply regardless of feature area)

1. **Never compiled.** Every score above assumes static review correctly
   predicts runtime behavior. Unity API surface changes, serialization
   quirks, and asmdef reference issues are exactly the class of bug static
   review is worst at catching. This is not a tier — it's a multiplier on
   every tier above, and it's currently unknown.
2. **Non-atomic save write** (§10) — small, well-understood, unfixed.
3. **Tyre model saturation** (§1) — large, well-understood, unfixed, and the
   one thing the whole tuning-depth thesis depends on.
4. **Backend/frontend gap** — the deepest, best-tested systems in the
   project (diagnostics, garage operations) are the least visible to a
   player. Continued backend investment here has diminishing returns until
   a UI pass happens.
5. **Two codebases** (`WHERE-WE-ARE.md`) — still unresolved. Every score
   above is scoped to `WTRL.*`, the tree that compiles. `Prototype~/`
   contains 24 files including the tyre model, the ragged-edge meter, and
   the dyno, none of which factor into any score here because none of it
   runs. This decision (WTRL / prototype / merge) is still yours to make
   and still gates how much of the above is worth polishing before that
   fork is resolved.

---

## Overall verdict

| Layer | Score | What it means |
|---|---|---|
| Engineering readiness (weighted by system depth) | **~75%** | The code that exists is mostly correct, mostly tested, and mostly consistent with itself. Rev14.1-14.3 closed real bugs rather than papering over them. |
| Product readiness (weighted the same way) | **~40%** | A player dropped into this today gets one working lap race against one AI rival in one car on one track, with a HUD that hasn't caught up to three passes of backend work, and a tyre model that won't produce the game's stated signature feel. |
| Verified readiness | **0%** | Nothing has compiled. This number moves before any of the others matter. |

**If I had to rank the next five moves by leverage:**

1. Compile in Unity 6000.0.58f2 and run the 126 tests. Every other number in
   this document is provisional until this happens.
2. Fix the non-atomic save write. Hours of work, protects every player's
   progress from the one failure mode the backup system was built to catch.
3. Decide WTRL vs. Prototype vs. merge (`WHERE-WE-ARE.md` §7). Nothing about
   the tyre model, the ragged-edge meter, or the dyno should get more static
   analysis before this is settled — the next unit of effort there should
   be code, not review.
4. A minimal diagnostics/operations UI pass — even read-only panels for
   alerts, hypotheses, capability, and fitment rejections. This converts the
   largest reservoir of tested-but-invisible work in the project into
   something a player can actually experience, and it's cheaper than it
   looks because the data model underneath is already correct.
5. Port the tyre model behind a feature flag. Highest-risk, highest-payoff
   change available, and everything the research calls the reason the game
   exists is downstream of it.

Everything else — more content, the remaining research systems, the
RESERVED collections — is real work but not the bottleneck. The bottleneck
is: nothing has run, the save path has one known hole, the core feel
mechanic can't be produced by the current physics, and the deepest systems
in the project are invisible to the person playing it.
