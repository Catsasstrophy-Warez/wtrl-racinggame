# Forced Induction, Crank Type, and Transmissions Across the Seven Generations

**What this is.** Real Ford/Mustang engineering history — forced induction
options, crankshaft design, and transmission evolution — researched as
reference material for the hero car, the same relationship
`37-FORD-V8-AUDIO.md` has to real engine acoustics and `12`'s derivation
method establishes generally. **This is the direct answer to the request:
turbos, superchargers, intercoolers, blow-off valves, cross-plane vs
flat-plane cranks, and 3-to-10-speed manual and automatic transmissions,
matched to real counterparts across all seven generations.**

**One structural finding worth stating up front**: flat-plane crank turns
out to be a **variant-level** choice, not a family-level one — real Voodoo
cylinder heads get used on standard cross-plane Coyote builds, proving
crank type doesn't require a new engine family the way the Windsor→Coyote
firing-order break did (`37` Part 5–6). This keeps the two-family
structure intact while adding real depth inside it.

---

# PART 1 — Forced induction, mapped to the generations

## 1.1 Superchargers had a genuine period-correct 1965 option

**Paxton superchargers were a real, factory-adjacent option starting the
same year the hero car begins.** Available as an over-the-counter
dealer-installed option on standard small-block V8 Mustangs from
**1965–72**, and used in limited quantities on the **1966–68 Shelby
GT-350** itself — not purely aftermarket fantasy, a documented factory-
adjacent build.

**Real spec worth using directly**: the NOVI-series centrifugal
supercharger, gear-driven, running roughly **7.5psi at 5,500rpm** on a
stock small-block, for a claimed **30–75% horsepower gain** depending on
supporting engine work. Crucially, period installations already included
a **compressor bypass valve** — the direct mechanical ancestor of the
modern blow-off valve — confirming BOV-adjacent hardware is period-
appropriate for generation one, not just a later addition.

> ## Application
>
> **Supercharging can be offered as a genuine parts-wall option from the
> very first hero-car generation**, not gated to later eras. This is a
> free piece of authenticity — the "Paxton-equivalent" fictional analog
> (per `12`'s derivation method) gives 1965 real performance-upgrade depth
> most racing games only offer on modern cars.

## 1.2 Turbochargers are the honest gap — and that's useful too

No factory turbocharged V8 Mustang exists across this entire real
history. Turbocharging a Ford V8 has always been an aftermarket/tuner
proposition, not a factory option at any point in the lineage.

> **This is worth keeping as a design fact, not smoothing over.**
> Superchargers should read as the *period-plausible, dealer-adjacent*
> forced-induction path across all seven generations; turbocharging
> should read as the *aftermarket, tuner-shop* path throughout —
> consistent with the real distinction, and a free bit of texture for
> which acquisition channel each option comes from (`25` Part 3: bought,
> found, or won).

## 1.3 Superchargers return, factory-installed, at the top of the lineage

**The GT500-equivalent top trim of the final generations is real-world
supercharged from the factory** — a modern supercharger paired with a
cross-plane crank (not flat-plane — see Part 2), producing figures in the
760hp / 625lb-ft range in the real reference car, run through a
seven-speed dual-clutch automatic with **no manual available**.

> This closes a loop nicely: the hero car's forced-induction story can go
> **aftermarket supercharger (1965) → mostly naturally aspirated through
> the middle generations → factory supercharger returns at the top trim
> of the final generation** — the same shape as a real enthusiast's
> mental map of Mustang history, not an arbitrary progression.

## 1.4 Intercoolers and BOVs — texture, not a separate system

Neither needs its own subsystem. Both are **properties of a forced-
induction installation**, not independent purchases:

- **Intercooler**: present whenever forced induction is installed,
  quality/size scaling with the induction option's tier (a period Paxton
  install would run little to no charge cooling; a modern factory
  supercharger install runs a proper air-to-liquid intercooler)
- **Blow-off valve**: present specifically on turbo installations
  (compressor surge is a turbo-specific problem); the period
  supercharger's compressor bypass valve (§1.1) is the same *function*
  under a different name, worth surfacing as flavour text rather than a
  separate purchasable part

---

# PART 2 — Crank type: a variant property, not a family one

## 2.1 The real mechanics

**Cross-plane**: four crank pins on two planes, offset 90° from each
other (the "+" shape), firing every 90°. Used in essentially every real
American production V8, including the standard-tune version of the
modern reference engine.

**Flat-plane**: all crank pins in a single plane, opposite journals at
180°, firing every 180°. Lighter (no counterweights needed), revs more
freely, and produces a genuinely different sound — described consistently
as closer to a Ferrari or other European exotic than to a traditional
American V8.

## 2.2 ⚠️ The finding that refines the family/variant structure

The real flat-plane engine (the "Voodoo"-equivalent) is explicitly
**a variant of the same modern engine family**, not a separate
architecture — it shares the block heritage with the standard cross-plane
version, and real developer-market camshafts exist for running the
flat-plane cylinder heads on a **cross-plane** bottom end, confirming the
two are interchangeable at the variant level.

> **This means `EngineFamily.cs`'s firing-order field should live at the
> family level as a *default*, but `EngineVariant.cs` needs its own
> firing-order override** — which the code already supports
> (`valveArchitectureOverride` / `useOverride`, added for exactly this
> kind of case) but should be extended to cover crank type specifically.
> See Part 4 for the code change.

## 2.3 Where it fits in the lineage

**Recommend: flat-plane as a rare, high-performance variant option within
the final engine family only** (mid-2010s / 2022 generations,
per `37` Part 5–6's two-family split) — matching the real history
precisely, where flat-plane only ever appeared in the modern DOHC-era
engine, never in the earlier pushrod/SOHC lineage.

**Mechanical trade-offs worth modelling, both real**: flat-plane variants
rev higher and sound distinct, but real-world accounts note more
vibration (the lighter crank sacrifices the smoothing effect of cross-
plane's counterweights) — a genuine tuning trade-off, not a strict
upgrade, useful for keeping the choice meaningful rather than obviously
correct.

---

# PART 3 — Transmissions: a real 3-to-10-speed progression

## 3.1 Manual transmissions, era by era

| Hero car era (`32` §7.1) | Real reference | Speeds |
|---|---|---|
| **1965** | Top Loader | **3** (base) or **4** (performance) |
| **Mid-70s** | Top Loader, continuing | 3 or 4 |
| **Late 80s** | T5 arrives (Ford's move to T5 was mid-1984) | **5** |
| **Mid-90s** | T5 continuing through 1995; T45 arrives 1996+ | 5 |
| **Early 2000s** | TR3650 | 5 |
| **Mid-2010s** | MT82 (Getrag, replacing Tremec from 2011) | **6** |
| **2022** | Modern 6-speed manual (Tremec-lineage) | 6 |

**Real ratio data exists and is directly usable** — e.g. the Top Loader
4-speed close-ratio set (2.32/1.69/1.29/1.00) versus its wide-ratio
counterpart (2.78/1.93/1.36/1.00), and the T5's 3.35/1.99/1.34/1.00/0.67 —
genuine period gearing, not invented numbers, if real-feeling ratio
spread is wanted per era.

## 3.2 Automatic transmissions, era by era

| Hero car era | Real reference | Speeds |
|---|---|---|
| **1965** | C4 (or C6 for higher-torque applications) | **3** |
| **Mid-70s** | C3/C4/C6 continuing | 3 |
| **Late 80s** | AOD arrives (Ford's first overdrive automatic, Mustang debut 1984) | **4** |
| **Mid-90s** | AODE / early 4R70W (electronic control added) | 4 |
| **Early 2000s** | 4R70W continuing; 5R55S arrives | **5** (late in era) |
| **Mid-2010s** | 6R80 | **6** |
| **2022** | 10R80 (co-developed, real-world figures show roughly 10% quicker 0–60 from the extra ratios alone) | **10** |

> **This is the real 3-to-10 progression requested, confirmed from actual
> Ford transmission history rather than invented for range.** Seven
> generations, automatics alone span 3 → 4 → 4 → 5 → 6 → 10 — genuine
> engineering escalation, not a smoothed curve.

## 3.3 The top-trim exception, again

Consistent with §1.3's forced-induction top trim: the real GT500-
equivalent pairs its supercharged engine with a **seven-speed dual-clutch
automatic and no manual option at all.**

> **Worth offering as a distinct, deliberate choice at the top of the
> final generation**: the maximum-performance build trades the manual
> option away entirely, matching the real car's actual choice. A genuine
> trade-off (outright speed vs. driver engagement) rather than a strict
> upgrade — the same texture point as the flat-plane crank's vibration
> trade-off in Part 2.3.

---

# PART 4 — Code implications

`EngineVariant.cs` needs two additions, both following the pattern
already established for `valveArchitectureOverride`:

1. **A crank type field** (`CrossPlane` / `FlatPlane`), variant-level per
   §2.2, with its own firing-order description override rather than
   inheriting the family default unconditionally.
2. **A forced-induction descriptor** (none / period supercharger / modern
   supercharger / aftermarket turbo), carrying an intercooler-presence
   flag and a BOV-presence flag as properties of that descriptor rather
   than separate purchasable parts, per §1.4.

A **new `TransmissionSpec.cs`**, structurally parallel to
`EngineVariant.cs`: speed count, type (manual/automatic), era tag, and a
real per-gear ratio array — populated directly from the reference data in
Part 3 where authenticity is wanted, or used as a plausible starting point
for a fictional analog's own numbers.

**Both are implemented — see `code/prototype/EngineVariant.cs` (extended)
and the new `code/prototype/TransmissionSpec.cs`.**

---

# Cross-references
- Engine family/variant model → `code/prototype/EngineFamily.cs`
- Two-family acoustic structure this builds on → `37-FORD-V8-AUDIO.md`
- Hero car era table → `32-HERO-CAR.md` §7.1
- Parts acquisition channels (bought/found/won) → `25-GARAGE-DESIGN.md` Part 3
- Derivation method for fictional analog naming → `12-DERIVATION-METHOD.md`
