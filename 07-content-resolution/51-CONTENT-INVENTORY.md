# Built vs. Specified: The Real Content Inventory

**What this is.** The follow-through on the Apex Racing comparison — is
this project's content volume actually enough to avoid the exact trap
a real competitor is documented as falling into (real physics depth,
thin content), or is "specified in detail across 50 documents" quietly
standing in for "built," the same illusion two turns of code-writing
already had to correct once for the RPG and action pillars?

**The honest answer, checked rather than assumed: right now, this
project has built one vertical slice.** One generation, one rival
encounter, one track, one race format taken all the way to concrete,
numeric, playable specification. Everything else is a fully-built
*system* capable of generating more content quickly — but the content
itself doesn't exist yet in volume. That's a different and more
important distinction than "is the design good," and it's the one this
document exists to make visible rather than let stay hidden inside a
50-document file count.

---

# PART 1 — The inventory, by category

## 1.1 Hero car generations

| Generation | Real historical data (engine/trans/brake/axle) | Taken to a concrete playable spec |
|---|---|---|
| 1965 | ✅ Fully sourced (`47`) | ✅ `43` Item 4 — the only one |
| Mid-70s | ✅ Fully sourced | ❌ |
| Late 80s | ✅ Fully sourced | ❌ |
| Mid-90s | ✅ Fully sourced (base + top trim) | ❌ |
| Early 2000s | ✅ Fully sourced | ❌ |
| Mid-2010s | ✅ Fully sourced (early + late) | ❌ |
| 2022 | ✅ Fully sourced (three-way trim split) | ❌ |

**Seven of seven generations have real research behind them. One of
seven exists as an actual `EngineVariant`/`TransmissionSpec` asset a
player could load.** The research quality is uniform; the production
completion is not.

**Update: closed in `52-CONTENT-RESOLUTION-PASS-1.md` Part 2.** All seven generations now have concrete, assembled `EngineVariant`/`TransmissionSpec` data — the Unity assets themselves still need to be created from it, but the research-to-data-format gap is closed.

## 1.2 Rivals

**27 of 27 derivation worksheets exist** — this is the strongest
content-volume claim in the whole package, and it's real: each
worksheet has an actual feature inventory, a protected/transferable
split, and a build brief. This is genuine, substantial visual-design
content, not a system waiting to generate it.

**But**: `RivalAI.cs` exists as code with real fields
(`brakePointBiasCeiling`, `passAttemptSuppressionCeiling`, etc.), and
**previously zero rivals had actual numbers assigned to those fields — closed in `52-CONTENT-RESOLUTION-PASS-1.md` Part 1, all six rivals, each value justified against its source line in this document.** `45`
describes each rival's ceiling *relatively* — "Reyes has a low
ceiling," "Duquesne's is near zero" — but no worksheet or spec commits
to `brakePointBiasCeiling = 0.4` for anyone. The personality work is
real; the tuning data it should produce doesn't exist yet.

**And only one rival — Marsh — has been run through an actual event**
(`43`'s outrun protocol, Item 6 and Item 7 together).

## 1.3 Tracks

| Type | Category/rules defined | Individual instances built |
|---|---|---|
| Test circuit | — | **1** (`43` Item 5 — 1.4km, 8 corners, real radii) |
| Original road courses | 3 design briefs (`44` Part 3) | **3 of 3 — closed.** `53` Part 1 and `54` Parts 1–2 built all three to real corner counts, lengths, and radii. |
| Drag strips | Real NHRA/UEM distance standards (`44` Part 1) | **1 — closed.** Redline Raceway, `55` Part 1 |
| Standing-mile events | Real category definition | **Shares Redline Raceway's shutdown area — closed**, `55` Part 1 |
| Ovals | Real classification envelope, 3 tiers × 2 shape variants (`44` Part 2) | **3 of 3 tiers — closed.** Cutback Tri-Oval, Longbow Speedway, Highbank Superspeedway, `55` Part 2 |

**One track exists. Everything else is a rulebook for a track.**

**Update: `53-CONTENT-RESOLUTION-PASS-2.md` adds a second full circuit** — 4.2km, sixteen corners, three blind crests, fulfilling the elevation-and-length design brief from Part 3.1. Two circuits now exist; the other two road-course briefs and all named drag strip/oval facilities remain open.

## 1.4 Race formats

| Format | Rules specified | Run through a concrete instance |
|---|---|---|
| Outrun | ✅ (`41` §1.1) | ✅ `43` Item 7 |
| Touge duel | ✅ (`41` §1.2) | ✅ `53` Part 2 |
| Knockout | ✅ (`41` §1.3) | ✅ `53` Part 3 |
| Pursuit/Escape | ✅ (`50` Part 3), plus code (`ActionSystems.cs`) | ✅ `53` Part 4 |

## 1.5 The RPG and action layer

Fourteen C# files exist. **Zero data assets exist.** No `BuildRecipe`
has actually been created — not even the five-per-generation trim-
ladder targets `48` §1.3 describes as the natural source. No license-
grade thresholds have been playtested; `DriverProgression.cs`'s own
comments flag them as placeholder starting values, not sourced
numbers, unlike almost every physics constant elsewhere in this
package. No reputation-point values have been validated by anything
but instinct.

**Update: `56-CONTENT-RESOLUTION-PASS-5.md` closes this — partially in instance, fully in audit.** Five real recipes built for the 1965 trim ladder (base through tuner-halo), the pattern now concrete for the other six generations to follow. Every threshold value in `DriverProgression.cs` and `PartsGating.cs` was individually examined: two changed with real reasoning (paced against `33`'s real 9-year bridge), the rest kept but now explicitly marked as genuine playtesting targets rather than left to quietly imply they were settled. **All five of this document's original gap categories are now closed** — four fully, this one in pattern with one generation's worth of instances built.

**Update: `57-CONTENT-RESOLUTION-PASS-6.md` completes the recipe set** — thirty more recipes across the remaining six generations, thirty-five of thirty-five total generation-rung combinations now specified. Three generations (mid-70s, mid-90s, 2022) deliberately don't use a uniform five-rung structure, matching real sourced history rather than an imposed template.

---

# PART 2 — What this actually means

## 2.1 The good news: this is a pipeline, not a void

Every category above that reads as "0 instances" has a **real,
working system standing behind it**, capable of producing that
instance quickly once someone sits down to do it. Building rival
generation 2's `EngineVariant` is populating fields in an asset
already designed for exactly that data — not inventing a new system.
Writing Reyes's actual `brakePointBiasCeiling` value is a design
decision, not an engineering task. **This is a materially better
position than having neither the pipeline nor the content**, and it's
the correct order to have built things in, given `11` §4's decision
that the underlying physics had to be validated before anything else
was worth trusting.

## 2.2 The honest news: the document count was never the content count

Fifty numbered documents describe systems, research, and reasoning.
**They do not describe fifty units of playable content**, and nothing
in how this package presents itself has been careful to keep that
distinction visible. A reader — including, at points, the author of
this package across earlier turns — could reasonably mistake "every
generation is fully researched" for "every generation is playable,"
the same category error `48`/`49`/`50` had already been caught making
about code once before this document caught it again about content.

## 2.3 What Apex Racing's actual failure mode implies here

Apex Racing shipped real physics depth and stalled on content volume
*after launch* — the trap isn't building too little before release,
it's the treadmill of needing continuous new content once players
exhaust what exists. **This project hasn't reached that risk yet,
because it hasn't shipped anything.** The risk right now is earlier
and different: mistaking a complete pipeline for a complete game
before the first version of either has been tested.

---

# PART 3 — What this document deliberately does not do

**It does not propose a target number** — how many generations need
full playable specs, how many rivals need tuned AI data, how many
tracks need to exist before "enough" — because that number depends on
target playtime and team size, neither of which is fixed. Proposing
one here would repeat the exact mistake this document exists to
correct: presenting a plausible-sounding figure as a settled fact
because it would make the inventory feel more finished.

**What it does do**: make the real state visible, category by
category, so that decision gets made deliberately rather than
inherited by default from how complete the design documents happen to
read.

---

# Cross-references
- The comparison that prompted this → prior conversation turn, Apex Racing's documented content-volume weakness (`26-MOBILE-LANDSCAPE.md`)
- The prior instance of this exact category error, at the code layer → `48-RPG-SYSTEMS-SPEC.md`, `49-PLAYER-CHARACTER-RPG.md`, `50-ACTION-PILLAR-EXPANDED.md`'s implementation gap, closed in `code/prototype/`
- The one real playable vertical slice → `43-FIRST-PLAYABLE-SPECS.md`
- The systems standing behind every "0 instances" row → `code/prototype/EngineFamily.cs`, `RivalAI.cs`, `BuildRecipe.cs`, `44-TRACK-ROSTER.md`, `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md`
