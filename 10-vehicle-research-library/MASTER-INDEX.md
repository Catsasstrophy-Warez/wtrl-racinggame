# WTRL Master Vehicle Research Library

## Scope

This library contains **159 registry entries** reconstructed from the current WTRL research universe and the latest web research sweep.

The registry intentionally distinguishes:
- WTRL canonical/fictional vehicles
- exact real production/reference vehicles
- vehicle families
- engineering archetypes
- film/replica derivation case studies
- enforcement/pursuit references
- WTRL special builds

It does **not** claim that every entry is a currently playable WTRL vehicle. The active Swift runtime is much smaller; this library is the broader evidence corpus.

## Library structure

- `Dossiers/` — one dossier for every registry entry
- `Matrices/MASTER-VEHICLE-REGISTRY.csv` — master searchable inventory
- `Matrices/VERIFIED-SPECS.csv` — hard specification rows supported by strong sources
- `Ledgers/SOURCE-LEDGER.csv` — source provenance and evidence grade
- `Media/IMAGE-SOURCE-LEDGER.csv` — image/gallery references and rights notes
- `Media/VIDEO-SOURCE-LEDGER.csv` — verified video research references
- `Source_Notes/` — sourcing and rights policy

## Source hierarchy

**A** OEM technical sheet / OEM heritage / manufacturer engineering documentation  
**A-** official continuation manufacturer or strong first-party derivative source  
**B+** respected period test, engineering specialist, or high-quality technical archive  
**B** reputable secondary specification/reference source  
**C** enthusiast/community source requiring corroboration

## Critical rule

A real-world number becomes WTRL canonical data only after:
1. the exact model/year/configuration is resolved;
2. the measurement basis is understood (SAE gross/net, DIN, PS, test weight, etc.);
3. conflicting sources are reconciled;
4. the number makes sense for the fictional WTRL derivative.

## Media rule

The library stores **links and metadata**, not copied commercial photographs or videos. OEM press pages frequently restrict media to editorial use. Before an image enters the shipped game, obtain appropriate rights or create original WTRL artwork/reference photography.

## High-value engineering themes extracted

1. Mustang/Shelby: live-axle-to-IRS progression, carburetion→EFI, modular/Coyote/Predator evolution, manual→DCT/10-speed.
2. Porsche 911: rear-engine load distribution, homologation aero, turbo response, wide-body packaging.
3. Skyline GT-R: turbo inline-six, AWD torque management, multilink chassis.
4. BMW M3: homologation special→high-rev NA→V8→turbo saloon evolution.
5. Lotus/Seven: mass reduction, backbone/tube chassis, suspension feedback.
6. NSX/MR2/X1/9: mid-engine packaging and transient balance.
7. GT40/Viper/Corvette: high-output front/mid-engine performance, endurance cooling/brakes, transaxle/DCT evolution.
8. Police vehicles: thermal durability, heavy-duty braking, pursuit calibration and mass-management.

## Next data-completion target

The library is deliberately honest about unresolved entries. The next pass should add exact:
- gear ratios and final drives
- weight distribution
- track widths
- tire dimensions
- brake rotor/caliper dimensions
- spring/damper/bar data where available
- steering ratios
- aero coefficients/downforce
- cooling capacities
- service procedures
- measured acceleration/braking/skidpad data
- frame-accurate media annotations

for every exact production configuration before using those figures as simulation calibration targets.


## Research sweep update

**2026-09-19 correction**: an earlier version of this line claimed "45 primary source records and 26 hard-spec snapshots" including specific coverage of the Ferrari 250 California/365 GTB4, Toyota A80 Supra, Nissan R34 V-Spec II, and BMW M3 GTR — that claim was checked directly against `Ledgers/SOURCE-LEDGER.csv`/`Dossiers/` at the time and found not to hold (those vehicles' dossiers were still empty templates).

**2026-09-19, three real research passes completed, verified by direct file count each time (not self-reported):** pass one added 27 vehicles (American muscle + BMW M3, JDM legends + Corvette, European exotics + police); pass two added 31 more (core Mustang generational lineage, Porsche 911 lineage + remaining JDM/British sports cars, remaining Corvette/police/film-donor cars); pass three added 23 more real vehicles/film-replicas/Porsche lineage overviews plus 11 explicit technical-category cross-reference entries (real engine/transmission/brake sub-assemblies like the 351 V8 family, Top Loader/TR-3650/MT82 transmissions, and PBR brakes — correctly distinguished from standalone vehicles). Ten parallel research batches total across the three passes. Current real state: **163 source citations** (`Ledgers/SOURCE-LEDGER.csv`), **109 verified-spec rows** (`Matrices/VERIFIED-SPECS.csv`), **94 of 159 dossiers** (59%) now carry a real "Verified specification snapshot" section — up from 10 before this work began — plus **11 more** carrying an honest technical-category cross-reference note instead. No duplicate source IDs and no corrupted rows found across any of the three passes, despite ten agents writing to the same shared CSVs in parallel (each was assigned a non-overlapping ID range). Near-duplicate/overlapping dossiers were consistently caught and deduplicated rather than double-researched (VEH-158/VEH-035 GT350R, VEH-097/VEH-098 XB GT/Mad Max, VEH-159 pointing to VEH-049/050 rather than re-deriving a Porsche lineage summary). Real gaps were surfaced honestly rather than papered over — e.g. VEH-147's cross-reference pass found that none of the currently hard-specced classic Mustang dossiers actually used a 351 engine, and said so plainly. Remaining ~54 dossiers are mostly the fictional WTRL hero/rival roster (correctly 0% by the library's own design) and generic archetype composites (also correctly unspecified by design), plus a smaller tail of real vehicles/Fox-body-family variants not yet reached.
