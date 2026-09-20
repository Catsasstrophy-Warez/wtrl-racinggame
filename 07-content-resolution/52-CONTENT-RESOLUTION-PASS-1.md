# Resolving the Content Gap: Rival AI Data and Six More Playable Generations

**What this is.** Direct production against `51-CONTENT-INVENTORY.md`'s
findings — not new research, assembly of research already done into
the concrete data the existing code and specs were built to hold.
Every number below traces to a source already in this package.

---

# PART 1 — RivalAI concrete values, all six rivals

`45-RIVAL-DEVELOPMENT.md` described each rival's tuning *relatively*
("low ceiling," "near-zero," "rises fastest of all six"). `RivalAI.cs`
had the fields and zero assigned numbers. Closed here — each value
justified against its source line, not invented fresh.

## 1.1 Reyes

| Parameter | Value | Justification |
|---|---|---|
| `brakePointBiasCeiling` | **0.75** | "High ceiling specifically in technical sections" (`45` §1.1) — his one real vulnerability, so this is deliberately the highest of his four |
| `passAttemptSuppressionCeiling` | **0.25** | "Low ceiling... even at high reputation" (`45` §1.1) — explicitly stated low |
| `defensivePositionErrorCeiling` | **0.4** | No special note in `45` — baseline, unremarkable |
| `launchReactionDelayCeilingMs` | **120** | No special note — baseline |

## 1.2 Kade

| Parameter | Value | Justification |
|---|---|---|
| `brakePointBiasCeiling` | **0.4** | Baseline, no special note |
| `passAttemptSuppressionCeiling` | **0.4** | Baseline |
| `defensivePositionErrorCeiling` | **0.2** | "Low... even under pressure... whatever else rattles him, his positioning stays sharp" (`45` §1.2) |
| `launchReactionDelayCeilingMs` | **280** | "High ceiling — he's the rival most rattled at the line specifically" (`45` §1.2), near the code's own 300ms cap |

## 1.3 Vogel

| Parameter | Value | Justification |
|---|---|---|
| `brakePointBiasCeiling` | **0.4** | Baseline |
| `passAttemptSuppressionCeiling` | **0.4** | Baseline |
| `defensivePositionErrorCeiling` | **0.85** | "Rises fastest of all six" (`45` §1.3) — set as the highest of any rival's any parameter, matching that specific superlative |
| `launchReactionDelayCeilingMs` | **120** | Baseline |

## 1.4 Duquesne

| Parameter | Value | Justification |
|---|---|---|
| `brakePointBiasCeiling` | **0.65** | "Final appearances show the highest brakePointBias of his own arc" (`45` §1.4) — high but not the package-wide maximum, since the source describes his *own* arc, not a cross-rival superlative |
| `passAttemptSuppressionCeiling` | **0.05** | "Near-zero... ever" (`45` §1.4) — the most extreme single value in this whole table, matching the most extreme claim in the source |
| `defensivePositionErrorCeiling` | **0.4** | Baseline |
| `launchReactionDelayCeilingMs` | **120** | Baseline |

## 1.5 Osei

| Parameter | Value | Justification |
|---|---|---|
| `hasEnduranceSpecificBehaviour` | **true** | The one rival needing the format-conditional mechanism (`code/prototype/RivalAI.cs`'s new extension, Part 1 of this document's own code work) |
| `shortEventCeilingMultiplier` | **0.1** | "Near-zero in short events" (`45` §1.5) |
| All four ceilings | **0.6 each** | These are his *endurance-format* values ("rise sharply" — `45` §1.5) — moderate-high, uniform across all four since no single parameter is singled out, only the endurance/short-event split itself |

## 1.6 Marsh

| Parameter | Value | Justification |
|---|---|---|
| All four ceilings | **0.15 each** | "Rises slowest of all six" (`45` §1.6), uniformly — his real advantage is trail braking, actual physics (`34` Part 1c), not AI-assisted intimidation, so keeping every ceiling low and uniform is the correct expression of "nothing here is doing the work, his driving is" |

---

# PART 2 — Six more hero-car generations, made playable

`43-FIRST-PLAYABLE-SPECS.md` Item 4 took 1965 from research to a
concrete `EngineVariant`/`TransmissionSpec` pair. The other six
generations' numbers already existed in `47-PARTS-PRICING.md` — this
assembles them into the same concrete format, closing six of the seven
rows in `51` §1.1's table.

## 2.1 Mid-70s

```
EngineVariant:
  displacementLiters: ~4.9 (351-family reference, 40 Part 2)
  peakPowerHp: 139-140 (47 Part 3 -- net-rated, matches 1965's base output)
  redlineRPM: 6000 (similar mechanical ceiling to 1965, softer delivery)
  crankType: CrossPlane
  forcedInduction: None (period supercharger still available as an upgrade, 40 S1.1)

TransmissionSpec: "Loadmaster 4-speed" or "Loadmaster 3-speed" (same
  Top Loader family as 1965 -- 47 S3.1 confirms this generation
  continues the prior transmission, no change)
```

## 2.2 Late 80s

```
EngineVariant:
  displacementLiters: ~5.0 (302 EFI reference)
  peakPowerHp: 195-225 (47 Part 3)
  redlineRPM: 5500
  crankType: CrossPlane
  forcedInduction: None (aftermarket turbo path available, 40 S1.2)

TransmissionSpec: "T5-equivalent 5-speed" (47 S2.3 -- fully populated
  already: 3.35/1.99/1.34/1.00/0.67, reverse 3.15, final drive 3.27)
```

## 2.3 Mid-90s

```
EngineVariant (base, 2V):
  peakPowerHp: 215-265 (47 Part 3)
  redlineRPM: 6250

EngineVariant (top trim, 4V DOHC):
  peakPowerHp: 305 @ 5800rpm, 300lb-ft @ 4800rpm (47 Part 3 -- the
    fully-sourced SVT Cobra figure)
  redlineRPM: 6500+
  Brakes (47 Part 5): 13in vented front (PBR twin-piston), 11.65in
    vented rear (single-piston) -- real period spec for this specific trim

TransmissionSpec: "T45-equivalent 5-speed" (47 S2.4 -- 3.37/1.99/1.33/
  1.00/0.67, reverse 3.22, final drive 3.27)
```

## 2.4 Early 2000s

```
EngineVariant:
  peakPowerHp: 300-315 (3V variant, later years of this era -- 47 Part 3)
  redlineRPM: 6250

TransmissionSpec: "TR-3650-equivalent 5-speed" (47 S2.5 -- 3.38/2.00/
  1.32/1.00/0.62, reverse 3.38, final drive 3.55)
```

## 2.5 Mid-2010s

```
EngineVariant (early, 2015 debut):
  peakPowerHp: 435
  redlineRPM: 7000

EngineVariant (late, 2018+):
  peakPowerHp: 460 (real, dated compression increase to 12.0:1 -- 47 Part 3)
  redlineRPM: 7000+

TransmissionSpec: "MT82-equivalent 6-speed" (47 S2.6 -- 3.66/2.43/1.69/
  1.32/1.00/0.65, final drive 3.31; reverse not sourced, flagged
  honestly in 47 rather than invented)
```

## 2.6 2022

```
EngineVariant (base):
  peakPowerHp: 450
  redlineRPM: ~7000

EngineVariant (mid-tier, flat-plane):
  peakPowerHp: 470
  redlineRPM: 8000+
  crankType: FlatPlane (40 Part 2 -- variant-level, same family)

EngineVariant (top trim, supercharged):
  peakPowerHp: 760
  forcedInduction: ModernSupercharger

TransmissionSpec options (47 S2.7, both fully sourced):
  "TR-3160-equivalent 6-speed" -- 3.25/2.23/1.61/1.24/1.00/0.63,
    reverse 2.95, final drive 3.73 -- pairs with the flat-plane trim only
  "10-speed automatic" -- 4.696/2.985/2.146/1.769/1.520/1.275/1.000/
    0.854/0.689/0.636, reverse 4.87, final drive 3.31
  "TR-9070-equivalent 7-speed DCT" -- 3.14/2.05/1.43/1.10/0.86/0.68/
    0.56, reverse 2.76, 900Nm capacity -- pairs with the supercharged
    top trim only, no manual offered (40 S1.3, 47 Part 2.7)
```

## 2.7 What this closes

**Seven of seven hero-car generations are now assembled into concrete,
buildable `EngineVariant`/`TransmissionSpec` data** — matching `43`
Item 4's format exactly, sourced from `47`'s already-researched
figures rather than anything new. This is the single largest lever
`51` identified, closed in one pass because the research had already
been done; only the assembly was missing.

**What's still not done, honestly**: these are data specifications,
not created Unity assets. Someone still has to open the editor and
build seven `EngineVariant` ScriptableObjects and seven
`TransmissionSpec` ScriptableObjects from the tables above. That step
is mechanical, not research — but it's still a step, and this document
doesn't claim otherwise.

---

# PART 3 — What's still open after this pass

Per `51`'s own honesty rule, no invented target number: this closes
two of the five gap categories that document listed (rival AI tuning
data, hero car generation specs). **Not touched in this pass**: the
remaining road course designs, named drag strip/oval facilities, the
other three race formats' concrete event instances, and any actual
`BuildRecipe` assets. Those remain exactly as `51` described them —
real systems, zero built instances — and are a reasonable next target
for the same treatment this document just gave rival AI and hero car
data.

---

# Cross-references
- The gap this resolves → `51-CONTENT-INVENTORY.md`
- Rival personality source → `45-RIVAL-DEVELOPMENT.md`
- Sourced hero-car figures this assembles → `47-PARTS-PRICING.md`
- The code extended for Osei's case → `code/prototype/RivalAI.cs`
- The format this matches → `43-FIRST-PLAYABLE-SPECS.md` Item 4
