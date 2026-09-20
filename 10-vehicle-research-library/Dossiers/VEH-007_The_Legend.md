# VEH-007 — The Legend

**Category:** Hero  
**Era:** 2022  
**Research type:** WTRL fictional/canonical  

## WTRL research role
Keep fiction mechanically grounded but visually/IP-distinct.

## Primary real-world reference cluster
- 2020 Shelby GT500
- 2021 Shelby GT500
- 2022 Shelby GT500

**2026-09-19: this reference cluster is now genuinely researched, and is
the single strongest real-world anchor of any hero generation in this
library.** See VEH-036 (2020 GT500 — 760hp supercharged Predator V8, an
exact power-figure match to this generation's own hero-car engine spec),
VEH-037 (2021 — confirmed mechanically identical, honestly reported as
unchanged rather than inventing a difference), and VEH-038 (2022 —
likewise confirmed unchanged). This exact car (2020 GT500) was also used
to tighten `SwiftRacer/Sources/WTRLCore/Simulation/GoldenVehicleCorpus.swift`'s
`hero-2022` performance envelope against real Car and Driver measured
data (0-60 3.4s, 1/4 11.3s@132mph, skidpad 0.99g) — the one case in this
whole project where vehicle-library research directly changed shipped
game code, not just documentation.

## Specification status
No single hard-spec row is asserted here unless the vehicle is an exact production configuration with sufficiently clear source evidence. For an archetype, use the linked family vehicles as an envelope rather than inventing a fake factory specification.

## Images
Use OEM heritage/media galleries first for shape, stance, suspension layout, cockpit, engine bay, brakes, wheels, and period-correct details. Images are **reference links only** in this library; no copyrighted image files are redistributed.

## Video research
Preferred capture targets: cold start/idle, engine bay, underbody/suspension, steering lock, braking, acceleration, shift behavior, body motion, track/road dynamics, service access, and cockpit ergonomics. See `Media/VIDEO-SOURCE-LEDGER.csv` for indexed videos and continue vehicle-specific capture where no video has yet been verified.

## WTRL extraction checklist
- Engine architecture and usable RPM band
- Transmission type, ratios/final drive where verified
- Differential/driven axle strategy
- Suspension architecture and wheel travel behavior
- Brake size/type/bias cues
- Tire/wheel sizing and sidewall behavior
- Wheelbase, track, mass and weight-distribution cues
- Aero devices and their functional intent
- Cooling/thermal strategy
- Service packaging and component accessibility
- Driver ergonomics and instrument layout
- Period-correct modification culture
- Failure/wear modes worth simulating
- Distinctive interaction ideas that can be transformed without copying trade dress

## Evidence policy
OEM/heritage sources are preferred. Period road tests and high-quality engineering sources are secondary. Community/forum claims require corroboration before becoming canonical WTRL data.