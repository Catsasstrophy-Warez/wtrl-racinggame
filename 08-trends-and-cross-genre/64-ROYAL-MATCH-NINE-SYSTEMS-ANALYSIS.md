# The Nine Progression Systems, Analyzed Against Royal Match's Own Test

**Doc 64** — numbered after `63-DANGLING-METHODS-FOLLOWUP.md`, confirmed against the actual highest number in use across the whole project rather than just this folder, after an initial draft collided with an existing `61`.

**What this is.** Following up directly on the tension named when
researching Royal Match: nine individually well-motivated progression
systems now exist. Each derives cleanly from play, matching the
principle Dream Games' own testing confirmed as correct. But Dream
Games' actual finding was sharper than that — even systems that derive
correctly can still cost more than they give back if there are too
many of them competing for attention. That's a question about the
whole, not any one system, and it hadn't been asked that way before.

---

# PART 1 — The nine, checked individually for real player-facing surface

Royal Match's own distinction: a meta layer that's "background
progress, not the core loop" retains better than one requiring
deliberate management, even when both derive fairly from the same
core actions. Checked each of the nine against that exact question —
does this system require a dedicated screen, or does it enrich
something that already exists?

| System | Dedicated screen? | What it actually does |
|---|---|---|
| Driver License Grade | No | A label on the event-entry list |
| Diagnostic Skill | **No — explicitly zero UI by design** (`49` §2.2) | Deepens existing screens (inspection, telemetry, dyno) as use accumulates |
| Reputation Traits | No | Flavour text plus AI behaviour changes, "not chosen — observed" |
| Safety Rating | No | A single background number |
| Two-Axis Gating | No | Surfaces only as availability in the parts wall, an existing screen |
| Class Brackets | No | A label on the recipe/car screen |
| Passive Income | **One non-blocking notification card**, nothing more | The Autolog welcome-back moment, already built to be brief |
| Build Recipes | **Yes — a real interaction surface** | Naming, saving, loading at the Desk station |
| Aggression Economy | No | Entirely emergent during driving itself, not a meta layer at all |

**Seven of nine have no dedicated screen at all.** They're background
trackers enriching screens the player would visit anyway. This isn't
an accident — it's the direct consequence of "read from what the
player did, never allocated from a menu," the same design rule that's
governed this whole layer since `48` and `49` were first written. That
rule doesn't just avoid grinding; it structurally prevents most of
these systems from ever needing a management surface in the first
place.

**Only one — build recipes — genuinely asks for deliberate
interaction**, and it's the closest analog to Royal Match's own castle
decoration: optional, free-form at its simplest (a named save slot),
deeper only if the player chooses to chase a target recipe's brief.

---

# PART 2 — Does one action advance several systems, the way Royal Match's does?

Royal Match's actual retention engine isn't the light meta alone —
it's that completing one puzzle advances six tournament formats,
co-op challenges, and streak systems simultaneously. Checked whether
this project's own race-completion moment does anything similar.

**`RaceFlowCoordinator.EndEvent()`, one call, before this pass**:
`ObjectiveTracker` (five objectives at once), `DriverLicense`
(`RecordResult`), `PartsGating` (`AddReputationEvent`) — three systems
genuinely advancing from a single race result, with `ClassBracket`
already checked before the event even starts.

**Found missing during this exact check**: `ReputationTraits` was
being *applied* (`ApplyTraitsToRival`, at event start) but never
*updated* (`RecordEventOutcome`, which should fire at event end). The
method existed, the call site existed, and the two halves of the same
loop had never been connected — the trait system was applying frozen
defaults and never actually learning from a real result. **Fixed in
`RaceFlowCoordinator.cs`**: `EndEvent()` now calls
`RecordEventOutcome()` alongside everything else it already updates.

**After the fix**: one race completion now genuinely advances four of
the nine systems in a single moment, matching Royal Match's own
pattern of convergence rather than nine separate, disconnected
progress bars each needing their own triggering action.

---

# PART 3 — The honest remainder

Passive income and build recipes deliberately don't converge on the
race-completion moment — they trigger on garage arrival and on
deliberate recipe management respectively. **This is correct, not a
gap**: Royal Match's own tournaments, co-op events, and streaks aren't
all triggered by literally the same tap either; different systems on
different natural rhythms is the actual pattern, not everything firing
at once.

**What this analysis didn't and can't settle**: whether nine systems,
however lightly most of them sit, still add up to more cognitive load
than seven or five would. That's the same category of question Dream
Games answered with real A/B data against real players, not
architecture review. Nothing in this codebase can produce that
answer. Worth naming as a real open question for eventual playtesting
rather than either dismissing it because each system checks out
individually, or treating the surface-area analysis above as if it
were a substitute for watching an actual player's attention.

---

# Cross-references
- The Royal Match research this follows up on directly → prior conversation turn (Royal Match, Dream Games' meta-layer testing)
- The nine systems' own specifications → `05-specifications/48-RPG-SYSTEMS-SPEC.md`, `05-specifications/49-PLAYER-CHARACTER-RPG.md`, `05-specifications/50-ACTION-PILLAR-EXPANDED.md`, `08-trends-and-cross-genre/59-TRENDS-GTA-PASSIVE-INCOME.md`
- The fix applied → `code/prototype/Orchestration/RaceFlowCoordinator.cs`
- The design principle confirmed → `48-RPG-SYSTEMS-SPEC.md`'s governing rule, "nothing is a menu the player spends points in"
