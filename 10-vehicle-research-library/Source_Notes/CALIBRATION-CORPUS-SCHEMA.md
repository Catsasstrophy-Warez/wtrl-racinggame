# Calibration Corpus Schema

Each exact production configuration is progressively filled across:
- gear ratios
- final drive
- front/rear track
- tire dimensions
- brake rotor/caliper dimensions
- steering ratio and lock-to-lock
- static weight distribution
- aero hardware / measured coefficients where available
- cooling architecture
- instrumented acceleration, braking and skidpad results
- service documentation
- subsystem-specific video timestamps

Blank means **not yet verified**. It never means zero or not applicable.

Evidence types:
- FACT: manufacturer/heritage specification
- MEASURED: instrumented road test or official evaluation
- ADJACENT_MEASURED: useful neighboring model/year, never silently applied to the target
- ENVELOPE: bounded reference family
- AUTHORED: WTRL-created value informed by research
