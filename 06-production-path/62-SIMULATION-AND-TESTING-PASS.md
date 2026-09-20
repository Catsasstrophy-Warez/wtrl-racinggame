# Simulation and Testing Pass: One Real Bug, Two Real Confirmations

**What this is.** Extending numerical validation — the same discipline
already applied to the core tire model, the differential test, drag
strips, and oval banking — to the newest systems, which had been
checked for logic correctness but never actually run with numbers.

---

# PART 1 — A real bug, found only by simulating a realistic pattern

## 1.1 What was checked

`MechanicalFailure.cs`'s abuse-accumulation curve, previously verified
only by hand algebra (a rough estimate of ~16 seconds to reach
meaningful risk under continuous worst-case fill). That estimate was
correct — **and irrelevant**, because it tested the wrong scenario.

## 1.2 The actual finding

`code/prototype/simulation/mechanical_failure_sim.py` simulated a
realistic 6-lap driving pattern — corners holding high instability
fill for 2 seconds, straights dropping it for 3, repeated across 24
corners. **Accumulated abuse stayed at exactly 0.000 for the entire
120-second simulation.** Not low. Zero.

**The cause**: the original implementation required 5 *consecutive,
unbroken* seconds above the instability threshold before any risk
began accumulating. No real corner sustains peak instability for 5
uninterrupted seconds — a 2-second corner followed by any straight
resets the counter completely, forever, no matter how many laps get
driven. The system measured "sustained within one corner" when its own
design intent, stated directly in `20` §7, is "push lap after lap and
something breaks" — an inherently cumulative, multi-lap idea that the
consecutive-seconds implementation could never express.

## 1.3 The fix, validated before shipping

`mechanical_failure_sim_v2.py` reworked the tracking to cumulative
seconds above threshold across the whole event, with gentler decay so
one straight doesn't erase a full lap's abuse. Re-run against three
scenarios before touching the real code:

| Scenario | Result |
|---|---|
| Same realistic 6-lap abusive pattern | Risk becomes reachable at 67s (lap 3–4 of 6), reaching 0.976 by the end |
| Clean driving, 5 minutes | Stays at exactly 0.000 — no false positives |
| A brief 2-lap abusive stint only | 0.048 — safely under the 0.6 failure-risk threshold |

**Applied to `Physics/MechanicalFailure.cs`** with the exact validated
parameters, and the old field name (`gracePeriodSeconds`,
consecutive-only) replaced with `cumulativeGraceSeconds`, matching
what the field actually needs to mean now.

## 1.4 Why this one mattered more than a typo

Every prior bug this codebase caught — the `ClassBracket` type error,
the Python-syntax method names, the division-by-zero risk — was wrong
on inspection, findable by reading the code carefully enough. **This
one read correctly.** The formula was internally consistent, the
variable names made sense, the hand-algebra check even confirmed a
plausible-sounding number. It was wrong in a way only visible by
actually running a realistic pattern through it — the system would
have shipped, looked fine in isolated testing, and silently never
fired in real play.

---

# PART 2 — A real confirmation: the six rivals are genuinely distinguishable

## 2.1 What was checked

Whether `52-CONTENT-RESOLUTION-PASS-1.md`'s per-rival `RivalAI`
ceiling values — assigned individually, each justified against a
specific line in `45` — actually produce numerically distinct
personalities, or whether the differences were small enough to be
imperceptible in practice.

## 2.2 The result

`rival_differentiation_check.py`: no two of the six rivals are
numerically close on any combination of parameters. Real spread across
every axis — 0.60 range on brake-point bias, 0.55 on pass-attempt
suppression, 0.70 on defensive positioning, 235ms on launch reaction
delay, all on scales where the full range is 0–1 (or 0–300 for launch
delay). Duquesne's near-zero pass suppression (0.05) and Vogel's high
defensive-error ceiling (0.85) sit at genuine extremes, not just
"different enough to pass a glance."

**This is a real, positive finding, stated as plainly as the bug
above** — the personality-driven design work in `45` and `52`
produced numbers that actually hold up under direct comparison, not
values that happened to look distinct in separate tables without
anyone checking them side by side.

---

---

# PART 3 — A second system checked: confirmed working, one tuning note

`ObjectiveTracker.cs`'s instability-average objective uses a
completely different accumulation method than `MechanicalFailure.cs`
(a simple mean over the whole event, no grace period or threshold-
crossing logic) — different enough that finding a bug in one didn't
mean checking the other was redundant.

**Result: no bug.** `objective_tracker_sim.py` confirmed the system
genuinely differentiates behaviour rather than being trivially easy or
impossible — normal driving (the same corner/straight pattern that
broke `MechanicalFailure`) averages 0.540 and comfortably clears the
0.7 threshold; sustained reckless driving (corners pinned near maximum
for 3+ seconds each) averages 0.800 and fails.

**One honest tuning note, not a bug**: the crossover point requires
roughly 7 seconds of fill *pinned at maximum* (1.0, not just "at the
limit" around 0.85–0.9) per relaxation cycle before the objective
actually fails. A player driving hard at the ragged edge without
fully pinning it might clear the objective more easily than the
design intent — "a real choice, not a checklist" (`41` §3.1) — may
want. Worth a look once real playtesting exists; not something a
simulation alone can settle, since it's a feel question, not a logic
error.

# Cross-references
- The system this found a real bug in → `code/prototype/Physics/MechanicalFailure.cs`
- The original design intent the bug violated → `05-specifications/20-CONCEPTS.md` §7
- The rival values confirmed distinguishable → `07-content-resolution/52-CONTENT-RESOLUTION-PASS-1.md` Part 1
- Simulation scripts → `code/prototype/simulation/mechanical_failure_sim.py`, `mechanical_failure_sim_v2.py`, `rival_differentiation_check.py`
- The prior numerical-validation discipline this extends → `code/prototype/simulation/differential_test.py`, `oval_banking_test.py`
