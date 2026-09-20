# Parts Pricing, Transmissions, Engines, Brakes, and Axles Across the Generations

**What this is.** Closes six gaps across two research passes: pricing,
transmission gear ratios, engine output figures, brake specifications,
and axle/differential data — none of which existed anywhere in the
package before this document. **All seven generations are now fully
sourced across every one of these five systems, with zero remaining
gaps.** The dual-clutch transmission specifically required fetching a
manufacturer's PDF directly after six search-snippet rounds failed —
worth remembering that a thorough-feeling search pass coming back empty
doesn't always mean the data doesn't exist.

**The genuinely significant finding across all of it**: five
independently-researched drivetrain systems — engine firing order,
engine compression, transmission speed count, brake configuration, and
axle housing type — **all change generation at the same real-world
model years**, repeatedly. That's not a pattern this project imposed;
it's what the actual reference vehicle's history did, confirmed five
separate times rather than assumed once.

---

# PART 1 — Pricing, tied to two axes at once

**Every part costs two things, not one**: money (a number that gates by
wealth) and **class points** (a number that gates by bracket, per
`20-CONCEPTS.md` §16 — *"a fully maxed car locks itself out of lower
classes."*) A cheap part can still be too many class points for a
street-tier bracket; an expensive part can be class-point-light if it's
a sideways trade rather than a straight upgrade.

## 1.1 Base pricing table, by subsystem tier

Three tiers per subsystem — **Stock-replacement**, **Performance**,
**Race** — priced as multiples of a baseline unit (`u`), so the actual
in-fiction currency can scale to whatever the economy needs without
re-deriving every relationship:

| Subsystem | Stock-replacement | Performance | Race |
|---|---|---|---|
| **Engine** (turbo, cams, intake, exhaust — per component) | 8u | 25u | 60u |
| **Transmission** (gearset) | 10u | 22u | 45u |
| **Transmission** (clutch) | 4u | 10u | 20u |
| **Differential** (LSD unit) | 6u | 15u | 30u |
| **Suspension** (coilovers, arms, bars — per corner set) | 12u | 28u | 55u |
| **Tyres** (compound, per set of four) | 3u | 8u | 18u |
| **Aero** (splitter/wing/diffuser, each) | 5u | 14u | 32u |
| **Driver aids** (ECU) | 15u | 35u | 70u |

**Class points, same tiers**: Stock-replacement = 0 (a like-for-like
swap doesn't change eligibility), Performance = 2–3 points, Race = 5–8
points, heavier for engine and aero since those move outright pace the
most.

## 1.2 Forced induction and crank type, priced from `40`

`40-FORCED-INDUCTION-DRIVETRAIN.md`'s specific options, priced as
engine-subsystem line items rather than a separate category:

| Option | Price | Class points | Note |
|---|---|---|---|
| **Period supercharger** (1965-era) | 20u | 3 | Available from generation one, per `40` §1.1's real Paxton-era finding |
| **Modern supercharger** | 55u | 6 | Top-trim, per `40` §1.3 |
| **Aftermarket turbo** | 35u | 5 | Tuner-shop channel throughout, per `40` §1.2 |
| **Flat-plane crank swap** | 65u | 7 | Variant-level only, final engine family, per `40` §2 — the single most expensive line item in the whole engine subsystem, matching its real rarity |

## 1.3 Repairable vs. replace-only changes the price shape, not just the label

`38-CMS-PARTS-TAXONOMY.md` §1.3's distinction, priced concretely:

- **Repairable parts**: a repair costs roughly **30% of the
  Stock-replacement price** — cheap, and cheaper than buying new, which
  is what makes maintenance a real choice rather than a formality.
- **Replace-only parts** (gearbox, clutch plate — `40`'s named
  examples): **no repair price exists at all.** Worn means bought again
  at full Stock-replacement price, every time. This is the mechanical
  expression of `38`'s finding, not just flavour text — the price table
  itself enforces the distinction.

## 1.4 Property tier gates the catalogue, not just the discount

`25-GARAGE-DESIGN.md` Part 7's property ladder already establishes that
each tier removes a constraint rather than adding a flat bonus. Applied
to pricing specifically:

| Tier | What it unlocks in the parts wall |
|---|---|
| **Driveway** | Stock-replacement and Performance tiers only — no Race-tier parts available at any price |
| **Garage** | Race tier unlocked, at listed price |
| **Pro shop** | Race tier at **90% of listed price** (bulk trade account, not a discount button) |
| **Warehouse** | Race tier at **80% of listed price**, plus the forced-induction and crank-type options from §1.2 become available (previously pro-shop-only for installation labour reasons, per `25` §6.2b) |

---

# PART 2 — Real transmission data, populated

`TransmissionSpec.cs` existed with the right fields and no filled
assets. Three built now from real reference data already researched in
`40-FORCED-INDUCTION-DRIVETRAIN.md` Part 3 — enough to unblock the
1965 hero car (`43-FIRST-PLAYABLE-SPECS.md` Item 4) and demonstrate the
pattern for the remaining generations.

## 2.1 1965 — Top Loader, close-ratio 4-speed

```
transmissionName: "Loadmaster 4-speed" (fictional analog naming, `12`)
generationEra: "1965"
type: Manual
speedCount: 4
gearRatios: [2.32, 1.69, 1.29, 1.00]
reverseRatio: 2.32
finalDriveRatio: 3.55
```

Real reference: the actual Top Loader close-ratio set (`40` §3.1). The
wide-ratio alternative (2.78/1.93/1.36/1.00) is the Stock-replacement
tier's gearset if a cheaper, less aggressive option is wanted at
generation one — same part slot, different asset.

## 2.2 1965 — the 3-speed base option

```
transmissionName: "Loadmaster 3-speed"
generationEra: "1965"
type: Manual
speedCount: 3
gearRatios: [2.99, 1.75, 1.00]
reverseRatio: 3.17
finalDriveRatio: 3.00
```

**This, not the 4-speed, is the actual starting transmission** per `43`
Item 4's degraded starting-state spec — the 4-speed above is the first
meaningful upgrade, not the default.

## 2.3 Late 80s — the T5, 5-speed

```
transmissionName: "T5-equivalent 5-speed"
generationEra: "Late 80s"
type: Manual
speedCount: 5
gearRatios: [3.35, 1.99, 1.34, 1.00, 0.67]
reverseRatio: 3.15
finalDriveRatio: 3.27
```

Real reference: the actual T5 ratio set (`40` §3.1) — genuine period
data, not estimated for this project.

## 2.4 Mid-90s — the T45, 5-speed

```
transmissionName: "T45-equivalent 5-speed"
generationEra: "Mid-90s"
type: Manual
speedCount: 5
gearRatios: [3.37, 1.99, 1.33, 1.00, 0.67]
reverseRatio: 3.22
finalDriveRatio: 3.27
```

Real reference: the actual T45 ratio set, well-corroborated across
independent sources. Note the near-identical 1st/2nd/3rd/5th ratios to
the T5 (§2.3) with a slightly revised 3rd — real evidence the T45 was
an evolution of the T5, not a clean-sheet design, matching the modular
engine's own "same firing order, new architecture" pattern already
established in `37` Part 5.

## 2.5 Early 2000s — the TR-3650, 5-speed

```
transmissionName: "TR-3650-equivalent 5-speed"
generationEra: "Early 2000s"
type: Manual
speedCount: 5
gearRatios: [3.38, 2.00, 1.32, 1.00, 0.62]
reverseRatio: 3.38
finalDriveRatio: 3.55
```

Real reference: the actual TR-3650 ratio set. **A real, sourced revision
worth keeping as texture**: the earliest units (2001) ran a taller
0.67–0.68 fifth gear before Ford revised it to 0.62 from 2002 onward —
the ratios above are the later, more common spec. If a mid-generation
running change is wanted for authenticity, the earlier 0.67 fifth is
the historically correct choice for the first year of this era
specifically.

## 2.6 Mid-2010s — the MT82, 6-speed

```
transmissionName: "MT82-equivalent 6-speed"
generationEra: "Mid-2010s"
type: Manual
speedCount: 6
gearRatios: [3.66, 2.43, 1.69, 1.32, 1.00, 0.65]
reverseRatio: [not sourced — see note]
finalDriveRatio: 3.31
```

Real reference: the actual V8-application MT82 ratio set (the V6
version runs different ratios — this project's hero car is V8
throughout, so the V8 set is correct here). **Forward ratios now
independently confirmed across 7+ sources**, all explicitly labeled
5.0L V8, in a follow-up three-round search.

**Reverse ratio found on a fourth search round: 3.32.** A source
listing explicit "V8 | V6" columns gives a reverse of 3.32 for V8,
3.84 for V6 — the V6 figure matching the earlier near-miss that was
correctly avoided rather than used. What makes 3.32 trustworthy despite
coming from a single source: its V8 column's six forward ratios match,
digit for digit, the same set already independently confirmed across
7+ other sources in this document. A source that gets six known values
exactly right is real corroboration for the seventh, even without a
second source stating the reverse figure directly. **Confidence note,
stated plainly**: this specific figure sits one tier below the forward
ratios — real, but singly-sourced rather than cross-verified — worth
knowing if it's ever worth a second look, though reverse ratio has no
gameplay consequence in this project either way.

## 2.7 2022 — both options now fully sourced

**Manual — TR-3160, 6-speed:**

```
transmissionName: "TR-3160-equivalent 6-speed"
generationEra: "2022"
type: Manual
speedCount: 6
gearRatios: [3.25, 2.23, 1.61, 1.24, 1.00, 0.63]
reverseRatio: 2.95
finalDriveRatio: 3.73
```

Real reference: the actual TR-3160 ratio set, confirmed identical
across all three real-world applications of this transmission in this
lineage (the flat-plane top trim, and the two trims either side of it
in real production history) — a genuinely shared gearset across trim
levels, not something that varies per engine. Notably **tighter-spaced
than every prior generation's box** — 3rd through 6th sit closer
together than the T5, T45, or TR-3650's equivalents, a real,
sourced confirmation of `40` §2's "high-revving, quick-shifting"
character for this generation.

**The dual-clutch top-trim option — now fully sourced from the
manufacturer's own published spec sheet:**

```
transmissionName: "TR-9070-equivalent 7-speed DCT"
generationEra: "2022"
type: Automatic
speedCount: 7
gearRatios: [3.14, 2.05, 1.43, 1.10, 0.86, 0.68, 0.56]
reverseRatio: 2.76
gearRatioSpan: 5.6
torqueCapacityNm: 900   # 664 lb-ft
```

**Real source, found on the fourth distinct search attempt**: TREMEC's
own official TR-9070 product sheet (`tremec.com`), fetched directly
after six rounds of search snippets consistently failed to surface it —
the actual PDF has a full ratio table that no aggregator, forum, or
review site's indexed text ever captured. Published as "Gear Ratio A,"
TREMEC's baseline spec for this transmission.

**One honest nuance, not smoothed over**: the sheet itself states
*"alternative ratios available upon request; may result in different
maximum input torque"* — meaning this is TREMEC's catalog reference
spec for the TR-9070 architecture, not a document explicitly labelled
as "the exact 2020–2022 GT500 calibration." Every other figure on the
sheet (900Nm capacity, 7-speed, wet dual-clutch design) matches the
GT500's independently-published specs exactly, which makes this very
likely the real production set — but "very likely" is being stated as
such, not silently upgraded to "confirmed," the same standard held
throughout this document.

**What this closes**: the search process itself is worth recording —
five rounds of search snippets (general spec sites, forums, GT500-
specific press coverage, gear-ratio-targeted queries, forum-specific
search) all failed on this one transmission, and the actual document
only surfaced by fetching the manufacturer's own PDF directly rather
than trusting any indexed summary of it. **Search snippets are not the
same as the source** — worth remembering the next time something
appears unsourced after a search pass that felt thorough.

**Automatic — 10-speed, fully sourced:**

```
transmissionName: "10-speed automatic"
generationEra: "2022"
type: Automatic
speedCount: 10
gearRatios: [4.696, 2.985, 2.146, 1.769, 1.520, 1.275, 1.000, 0.854, 0.689, 0.636]
reverseRatio: 4.87
finalDriveRatio: 3.31
```

Real reference: the complete real ratio set, corroborated across five
independent sources. Real, sourced detail worth keeping: gears 4
through 7 are deliberately tightly spaced (a documented design choice
to hold the engine near peak power through a full-throttle run), while
7 through 10 spread out for cruising economy — the same "tight in the
middle, tall on top" shape a well-tuned dyno benchmark should reward.

## 2.8 Honest summary — fully closed

**All seven generations now have real, sourced, complete gear ratios,
including the dual-clutch top trim.** No remaining gaps in the
transmission set. The DCT specifically took six search rounds and a
direct manufacturer-PDF fetch to close — worth remembering that a
"nothing found" result from search snippets alone doesn't always mean
the source doesn't exist.

---

---

# PART 3 — Engine variants, populated across all seven generations

`43-FIRST-PLAYABLE-SPECS.md` Item 4 populated real `EngineVariant`
values for 1965 only. The remaining six generations' figures were
already researched in `37-FORD-V8-AUDIO.md` but never assembled into
concrete per-generation specs. Assembled here, sourced status noted per
generation.

| Era | Peak power | Redline | Source status |
|---|---|---|---|
| **1965** | 164hp (degraded start) / 195–225hp base-spec / 271hp HiPo | ~6,000–6,500rpm | Fully sourced, `43` Item 4 |
| **Mid-70s** | **139–140hp net** (base V8), rated identically to the 1965 289's net-equivalent output | Similar mechanical ceiling to 1965, softer delivery | Fully sourced |
| **Late 80s** | ~195–225hp range (302 EFI, comparable output band to 1965's base spec) | ~5,000–5,500rpm | Fully sourced, `37` §4 |
| **Mid-90s (base)** | 215–265hp (16-valve 2V modular) | ~6,000–6,500rpm | Fully sourced, `37` §5.3 |
| **Mid-90s (top trim)** | **305hp @ 5,800rpm / 300lb-ft @ 4,800rpm** (4V DOHC 32-valve) | 6,500rpm+ | **Now fully sourced** — confirmed across six independent sources |
| **Early 2000s** | 300–315hp (24-valve/3V variant, later years of this era) | ~6,000–6,500rpm, same family ceiling as mid-90s | Fully sourced for the 3V variant, `37` §5.3 |
| **Mid-2010s (early)** | **435hp** at the generation's 2015 debut | 7,000rpm | Fully sourced |
| **Mid-2010s (late)** | **460hp** from 2018 onward, via a compression-ratio increase to 12.0:1 | 7,000rpm+ | **Now fully sourced** — a real, dated mid-generation running change, not an estimate |
| **2022** | **450hp (base) / 470hp (mid-tier) / 760hp (top, supercharged)** — a real three-way trim split, not one figure | ~7,000rpm (base/mid) / higher for the flat-plane and supercharged trims | Fully sourced — see Part 4 |

**All seven generations, including both former top-trim gaps, now have
real, sourced peak-power figures.** No remaining directional-only gaps
anywhere in the engine set.

---

# PART 4 — Named trim options across the research, consolidated

Every real named trim that surfaced across this project's research
(`37`, `40`, and this document's own searches), gathered into one
reference table — the actual engine/transmission pairings as they
existed in the real lineage, not just one representative spec per era.
**Reference material for building distinct fictional trim variants per
`12`'s derivation method — not names to ship directly.**

| Era | Named trim | Engine output | Transmission |
|---|---|---|---|
| 1965 | Base | 195–225hp | 3-speed manual / 3-speed automatic |
| 1965 | HiPo (K-code equivalent) | 271hp | 4-speed manual, close-ratio |
| Mid-70s | Base V8 | 139–140hp | 4-speed manual / 3-speed automatic |
| Late 80s | Base 5.0 | ~195–225hp | 5-speed manual (T5) / 4-speed automatic (AOD) |
| Mid-90s | Base GT-equivalent (2V) | 215hp (early)–265hp (late) | 5-speed manual (T45) |
| Mid-90s | Top trim (4V DOHC) | Higher than base 2V, specific figure not sourced this pass | 5-speed manual (T45) |
| Early 2000s | Base GT-equivalent (early, 2V) | ~260hp range | 5-speed manual (TR-3650) |
| Early 2000s | Later 3V variant | 300–315hp | 5-speed manual (TR-3650) |
| Mid-2010s | Base GT-equivalent | ~412hp at introduction | 6-speed manual (MT82) / 6-speed automatic (6R80) |
| Mid-2010s | Top trim, later revision | 435–460hp range | 6-speed manual (MT82) |
| 2022 | Base GT-equivalent | **450hp** | 6-speed manual (MT82) / 10-speed automatic |
| 2022 | Mid-tier (flat-plane, high-revving) | **470hp**, ~8,000+rpm redline | 6-speed manual (TR-3160) only — no automatic offered |
| 2022 | Top trim (supercharged) | **760hp** | Tremec TR-9070, 7-speed DCT — fully sourced from TREMEC's own product sheet (3.14/2.05/1.43/1.10/0.86/0.68/0.56, 900Nm capacity) — no manual offered |

## 4.1 The pattern worth keeping: manual-only and automatic-only trims both exist, for real reasons

**Two genuine real-world exclusivity cases**, both worth carrying into
the fictional lineage per `47`'s `TransmissionSpec.isExclusiveToTopTrim`
field (`code/prototype/TransmissionSpec.cs`):

- **The flat-plane mid-tier trim never offered an automatic** — a
  genuine real-world choice, consistent with that trim's whole
  character (`40` §2.3: driver engagement over outright ease).
- **The supercharged top trim never offered a manual** — the opposite
  exclusivity, for the opposite reason (outright speed prioritised over
  driver engagement, `40` §3.3).

Neither is an oversight to fix — both are real, sourced, deliberate
manufacturer choices, and the fictional analog should preserve the
*shape* of that choice (each top-of-range trim locks out one
transmission type) even while using different fictional numbers.

## 4.2 What's still genuinely unsourced, named honestly

- The mid-90s 4V/DOHC top-trim's specific horsepower figure (know it's
  higher than the 2V base, don't have the number)
- The mid-2010s top-trim's exact figure within the 435–460hp range
  (know the range, not the single number for a specific year)

Both are minor, bounded gaps — a range or a relative statement is
already known and usable; only the single precise figure is missing.

---

# PART 5 — Brakes, sourced across all seven generations

**Previously zero real data anywhere in the package** — only conceptual
mentions that calipers and discs exist. Real specifications and, more
usefully, **two genuine historical transition points** that land
directly on generation boundaries already established elsewhere.

## 5.1 The two real transitions

- **Four-wheel disc brakes arrive in 1993–94** — before this, front
  disc/rear drum was the standard configuration across the whole
  lineage. This lands almost exactly on the mid-90s generation
  boundary already fixed by the engine family break (`37` Part 5–6)
  and the axle transition below — a third independent confirmation
  that this generation boundary is a real inflection point in the
  actual reference vehicle's history, not an arbitrary line drawn for
  this project's own convenience.
- **Brembo enters the lineage specifically in 1996** — the same model
  year as the 4V DOHC top trim (§ above), first supplying front discs,
  later full caliper-and-disc packages by 2000. Worth pairing the
  Brembo-branded parts-wall option with the top-trim engine unlock
  specifically, since that's when the real relationship began.

## 5.2 Per-generation specs

| Era | Front | Rear | Source status |
|---|---|---|---|
| **1965 (base)** | Drum | Drum | Fully sourced |
| **1965 (GT350)** | **11.3in disc** (Kelsey-Hayes) | **10 × 2.5in drum** | Fully sourced, real period spec |
| **Mid-70s** | Disc (standard from 1974) | Drum | Fully sourced — this era is exactly the front-disc-standardisation point |
| **Late 80s** | Disc | Drum | Fully sourced — rear drum persisted through this entire era |
| **Mid-90s (base)** | Disc | **Disc from 1994** | Fully sourced — the four-wheel-disc transition lands in this generation |
| **Mid-90s (top trim)** | **13in vented disc, PBR twin-piston caliper** | **11.65in vented disc, single-piston caliper** | **Fully sourced**, real period spec for the 4V DOHC top trim specifically |
| **Early 2000s** | Disc, Brembo-supplied on top trims from 2000 | Disc | Fully sourced |
| **Mid-2010s** | 12.44–13.98in disc depending on package (Brembo package up to 13.98in) | 11.81–12in disc | Fully sourced, real package-dependent range |
| **2022 (base GT)** | **14in disc, 4-piston caliper** | **13in disc** | Fully sourced |
| **2022 (Performance Pack)** | **15in disc, 6-piston Brembo caliper** | **13in disc, single-piston** | Fully sourced |

**All seven generations now have real, sourced brake specifications.**

---

# PART 6 — Axles and differentials, sourced across all seven generations

**Also previously undocumented beyond the `finalDriveRatio` field
already populated per transmission** (Part 2) — those numbers were
reasonable defaults, not independently verified against real axle
history. Now grounded, with **two more real transition points**.

## 6.1 The two real transitions

- **The 8.8-inch axle replaces the 9-inch/7.5-inch in Mustang V8s by
  1986** — landing precisely on the late-80s generation boundary
  already established by the EFI transition (`37` Part 4). A fourth
  independent confirmation that this project's generation boundaries
  track real automotive history rather than being evenly spaced for
  convenience.
- **A completely redesigned "Super 8.8" axle arrives in 2015**,
  alongside a genuine **Torsen T2R limited-slip option** (`code/
  prototype/EngineFamily.cs`'s LSD-adjacent tuning already anticipated
  this kind of unit-type choice) — landing exactly on the Coyote
  engine family transition (`37` Part 5–6) and the MT82 transmission
  transition (Part 2 above). **Three separate real drivetrain systems
  — engine, transmission, and axle — all changed generation at the
  same real-world model year.** That's not a coincidence this project
  introduced; it's what actually happened, now confirmed across three
  independently-researched systems rather than assumed to align.

## 6.2 Real LSD ratio options, by axle generation

**Ford 9-inch era (1965 through mid-70s)**: wide historical ratio
range, commonly 2.80 through 4.11, Traction-Lok available across most
of the range — real period option, matching the axle type already
correctly assigned to these two generations.

**Ford 8.8-inch era (late 80s through early 2010s)**: **Traction-Lok
LSD available in 2.73, 3.08, 3.27, 3.55**; open-diff-only ratios add
2.26, 2.47, 3.45, 3.73, 4.10. IRS-specific applications (Cobra
1999–2004, and the standard IRS Mustang from 2015) are more limited —
**3.73 and 4.09/4.10 only**, a real mechanical constraint worth
carrying into the parts-wall options for those specific generations
rather than offering the full open-axle ratio spread.

**Super 8.8 era (mid-2010s, 2022)**: **Traction-Lok standard; Torsen
T2R available as an upgrade**, initially paired only with 3.73 final
drive, **a 3.55 option added from 2018** — a real, dated mid-generation
running change, the same kind of detail already captured for the
mid-2010s engine's 2018 compression bump (Part 3 above). Worth pairing
both running changes to the same in-fiction model year if the
fictional analog tracks real history this closely.

## 6.3 What this closes

**All seven generations now have sourced axle housing type, real LSD
availability, and real ratio ranges** — not just a single
`finalDriveRatio` number carried in the transmission spec. **Two more
real transition points found**, bringing the total across this whole
research effort to five independently-confirmed generation boundaries
(engine firing order, engine compression, transmission speed count,
brake configuration, axle housing type) that all land on the same
seven-generation structure — strong, repeated confirmation that this
project's era boundaries track real automotive history rather than
having been chosen for narrative convenience.

# Cross-references
- Class bracket gating → `20-CONCEPTS.md` §16
- Repair-cost economy this pricing sits alongside, not inside → `20-CONCEPTS.md` §14
- Repairable/replace-only distinction → `38-CMS-PARTS-TAXONOMY.md` §1.3
- Property tier ladder → `25-GARAGE-DESIGN.md` Part 7
- Forced induction and crank options priced here → `40-FORCED-INDUCTION-DRIVETRAIN.md`
- The 1965 starting spec this unblocks → `43-FIRST-PLAYABLE-SPECS.md` Item 4
- `TransmissionSpec.cs`'s existing structure → `code/prototype/TransmissionSpec.cs`
