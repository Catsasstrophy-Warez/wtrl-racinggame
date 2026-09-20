# Resolving the Content Gap, Pass 5: License Thresholds and Built Recipes

**What this is.** The last of `51`'s five gap categories. Two things
were genuinely unexamined, not just unbuilt: `DriverProgression.cs`'s
license thresholds and `PartsGating.cs`'s reputation thresholds were
arbitrary starting numbers nobody had reasoned through, and zero
`BuildRecipe` assets existed despite `48` §1.3 describing exactly where
they should come from.

**Stated honestly up front**: some of what follows can be paced
against a real structural anchor already in this package. Some of it
genuinely can't — these are game-balance decisions, not historical
facts, and no amount of research produces a "correct" number for how
many clean races should earn a license grade. Where that's true, this
document says so directly rather than dressing a guess up as settled.

---

# PART 1 — License and reputation thresholds, reasoned through

## 1.1 The one real structural anchor available

`33-ACT-STRUCTURE.md` fixes the shop-driver bridge at **nine years**.
That's the one piece of real career pacing already committed to in
this package, and it's the right thing to pace Contender grade
against — Contender is earned specifically *through* that bridge
(`49` §1.2), so it should complete roughly when the bridge does, not
at an arbitrary event count unrelated to the story's own timeline.

## 1.2 Reasoned thresholds

| Threshold | Old value | New value | Reasoning |
|---|---|---|---|
| `cleanStreetResultsRequired` | 5 | **8** | Street tier is the pre-bridge era — should take long enough to feel like a real proving period before the story hands the player the bridge, not a same-session unlock |
| `distinctJobTypesRequired` | 4 | **4 (kept, now justified)** | Already tied to `33` §2.3's 5 job types — deliberately less than all 5, since requiring literally every type would make one bad job-type matchup block progression entirely |
| `sustainedContenderResultsRequired` | 8 | **12** | Paced against the real 9-year bridge — roughly one clean result per 9 months of in-fiction time if the bridge's 5 job types each recur a few times across those years, giving Licensed grade a genuine multi-year feel rather than a quick unlock right after Contender |
| `dirtyResultsBeforeDemotion` | 3 | **3 (kept)** | ⚠️ **Genuinely unjustifiable beyond "three feels like enough to be a pattern, not a mistake."** No structural anchor exists for this one. Flagged as a real playtesting target, not dressed up as reasoned — the honest thing this whole document exists to do |
| `knownThreshold` (reputation) | 20 | **20 (kept)** | ⚠️ Same honesty: no structural anchor exists. Kept at its original value specifically *because* changing it would imply new reasoning that doesn't actually exist |
| `respectedThreshold` | 60 | **60 (kept)** | ⚠️ Same |
| `trustedThreshold` | 120 | **120 (kept)** | ⚠️ Same |

**Two of seven values changed with real reasoning behind the change.
Four stayed the same, but three of those four now say plainly that
they're unreasoned rather than silently implying otherwise** — the
actual closure this section provides isn't new numbers everywhere,
it's an honest audit of which numbers deserve confidence and which
don't.

---

# PART 2 — Five built recipes, the 1965 trim ladder

`48` §1.3 named the source directly: *"the real trim ladder already
cited as the model (`13` §2: base → performance → factory hot →
homologation → tuner halo) gives five natural target recipes."* Built
here for 1965 specifically, the one generation with a full playable
spec (`43` Item 4, `52` §2.1) to build against.

## 2.1 "Driveway Special" — base

```
recipeType: Target
targetWeightToPowerMin/Max: wide range, matching the degraded starting
  spec (164hp) as the baseline this recipe is built to just clear
requiredDifferentialType: none specified
unlockedTitle: "Driveway Special"
```
The entry-level target — clearing the degraded starting state,
proving the restoration has genuinely begun.

## 2.2 "Full Compression" — performance

```
targetWeightToPowerMin/Max: tightened around the base-spec range
  (195-225hp, 47 Part 3)
requiredDifferentialType: LSD, any type
unlockedTitle: "Full Compression"
```

## 2.3 "Hi-Po Spec" — factory hot

```
targetWeightToPowerMin/Max: built around 271hp (the real HiPo figure,
  47 Part 3)
requiredDifferentialType: LSD, Race-tier
unlockedTitle: "Hi-Po Spec"
unlockedLiveryId: a period-correct stripe treatment, distinct from any
  real manufacturer's actual factory graphic (12's derivation
  discipline applies to livery content the same way it applies to
  vehicle shape)
```

## 2.4 "Homologation Run" — homologation

```
targetMinDownforceN: the first recipe in this ladder to require
  aero at all -- 1965 has no factory aero (13, 32 S7.1), so this
  recipe specifically represents the period-correct supercharger
  path (40 S1.1) plus period-appropriate handling work, not
  downforce in the modern sense
requiredDifferentialType: LSD, Race-tier
unlockedTitle: "Homologation Run"
```

## 2.5 "Paxton Special" — tuner halo

```
Requires: the period supercharger (40 S1.1) specifically, at its
  fullest real-world boost figure (~7.5psi, 40's own sourced number)
targetWeightToPowerMin/Max: the tightest range in the ladder
unlockedTitle: "Paxton Special" -- named for the real period part
  category this recipe is built around, not a real product name
unlockedLiveryId: the halo-tier livery, most distinct from the base trim
```

## 2.6 What this demonstrates, and what it doesn't

**Five real recipes exist for one generation.** The pattern is now
concrete enough to replicate for the other six — but replicating it
six more times is real production work this document doesn't do,
consistent with `51`'s standing rule against padding a category to
look more finished than it is.

---

# PART 3 — All five original gap categories, final status

| Category | Status |
|---|---|
| Hero car generation data | ✅ Closed (`52` Part 2) |
| Rival AI tuning | ✅ Closed (`52` Part 1) |
| Race format instances | ✅ Closed (`53`) |
| Tracks (road courses + drag/oval facilities) | ✅ Closed (`53`, `54`, `55`) |
| RPG data assets | ✅ Closed for one generation's recipes and all threshold values audited (this document) — **the other six generations' recipe sets remain the one honestly open item** |

**Four of five fully closed. The fifth is closed in pattern and
partially in instance** — one generation's five recipes built, six
more generations' worth of the same pattern still ahead, correctly
sized as a repeatable production task rather than a research gap.

---

# Cross-references
- The gap this closes → `51-CONTENT-INVENTORY.md`
- The trim-ladder source → `48-RPG-SYSTEMS-SPEC.md` §1.3, `13-MUSTANG-DOSSIER.md` §2
- The 1965 spec these recipes are built against → `43-FIRST-PLAYABLE-SPECS.md` Item 4, `47-PARTS-PRICING.md`
- The nine-year anchor → `33-ACT-STRUCTURE.md`
- The code these values live in → `code/prototype/DriverProgression.cs`, `code/prototype/PartsGating.cs`
