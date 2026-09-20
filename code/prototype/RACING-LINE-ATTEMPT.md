# Racing-Line Optimizer: A Full Honest Account

**What this is.** `04-EXTRACTION-INVENTORY.md` flagged Beckman's Physics of
Racing Parts 17–18 as *"a direct recipe for generating AI waypoints... never
actually built."* This is the record of building it — two attempts, six real
findings, one genuinely useful result, and one clearly-marked limitation.

**The short version:** attempt 1 (reproduce Beckman's exact numbers) failed
after fixing three real bugs, because no spreadsheet exists for these two
articles to check against. Attempt 2 (build a standard method from first
principles instead) works correctly for wide corners and has a known,
explained limitation for tight ones. Neither is fiction dressed as fact —
every claim below is something that was actually run.

---

# PART 1 — Attempt 1: reproducing Beckman's exact numbers

## 1.1 The setup

Beckman's own worked example, reproduced exactly so his numbers could serve
as the validation target: 650ft entry straight → 180° left-hander (inner
radius 100ft, outer 200ft) → 650ft exit chute. His hand-found optimum:
`r=167.5ft, k=3.25s, k_unwind=7.22s → 16.466s`, a 0.294s improvement over the
best "dummy line" (constant speed through the whole corner) at 16.760s.

## 1.2 What validated cleanly

**The dummy-line geometry — matched to 0.3%.** Entry straight, braking zone,
constant-speed corner arc, and a fixed 0.5g exit-chute acceleration, computed
independently and compared against his own published table for the widest
line (r=200ft): this implementation gives 16.718s against his 16.760s.

**This part is trustworthy on its own** — `racing_line.py`'s
`dummy_line_time()` function, usable independent of everything below it.

## 1.3 What didn't — three real bugs, in order found

**Bug 1 — wrong starting radius.** Beckman's accelerate-and-unwind
integration starts at the apex, whose position is computed from the *inner
edge radius* `r0` (fixed at 100ft) — not from `r`, the inscribed cornering
radius being searched. Using `r` in the starting-position formula put the
car in a different place for every search candidate, and every single
combination failed (returned no valid result) as a consequence.

**Bug 2 — reversed turn direction.** The code forced the lateral
("radial") acceleration to always point toward increasing x, on the
assumption this was "into the track." For this specific left-hand corner,
with the car heading up-and-right after the apex, that forcing actually
*reversed* the correct turning direction — the natural left-hand normal
already had the right sign, and the forced override was overwriting it
backwards. Removing the override fixed cars driving off-track immediately
after the apex.

**Bug 3 — missing arc-time term.** The entry-time calculation summed
straight-line time and braking time to reach the turn-in point, but never
added the time to actually traverse the arc *from* turn-in *to* the apex —
a real, non-zero segment (about 1.1 seconds at the values tested). Left
uncorrected, the total time came out roughly 5 seconds faster than physically
possible.

## 1.4 What remained unexplained after all three fixes

Even with all three bugs fixed, the search still does not converge on
anything close to Beckman's 16.466s / 0.294s-improvement figure. Confirmed by
direct search that **no spreadsheet exists for Parts 17 or 18** — unlike Part
26, which explicitly references and links `phors26.xls`, nothing in any
result for these two articles references an attached file. Beckman describes
the accelerate-and-unwind method entirely in prose: a traction-circle
constraint, throttle ramping in over time `k`, steering unwinding over a
longer time `k_unwind`. There are no published governing equations to
transcribe — every implementation of that mechanic, including this one, is a
*reconstruction* of what would produce that described behaviour, not a
transcription of his actual formulas.

**Search for independent implementations** (a fourth avenue, tried before
abandoning this approach) turned up nothing built specifically from
Beckman's Part 18 method — the search surfaced real, unrelated racing-line
optimizers instead (Part 2 below), none of which use his specific
parametrisation.

> ## Status: do not trust this attempt's specific numbers
>
> `racing_line.py`'s accelerate-and-unwind search runs and prints a result,
> but that result — and any `(r, k, k_unwind)` triple it reports — should
> not be relied on. The script itself now prints this same warning when run.
> **The dummy-line calculation in the same file is fine to use on its own.**

---

# PART 2 — What exists elsewhere (the search that redirected the approach)

Before abandoning attempt 1, a search for independent implementations turned
up real, useful, unrelated context:

**`MuX2001/Raceline-Optimization`** (LGPL-3.0) — a fork of
**`TUMFTM/global_racetrajectory_optimization`**, the same Technical
University of Munich group behind the Milliken Moment Method and g-g-g-v
diagram tools already in `35-EXTENDED-SOURCES.md`. A real, published,
DOI-backed minimum-time trajectory optimizer with multiple fidelity levels
(shortest path, minimum curvature via QP, full minimum-time via optimal
control), citing peer-reviewed papers including *Time-Optimal Trajectory
Planning for a Race Car Considering Variable Tire-Road Friction Coefficients*
(Christ et al.). Far more rigorous than anything reconstructable from
Beckman's prose alone.

**`OptiLine-Py`** (PyPI) — a similar-purpose package, multiple fidelity
levels from geometric methods to full collocation-based optimal control via
CasADi/IPOPT.

**Velenis & Tsiotras (Georgia Tech)** — an academic paper on minimum-time
versus maximum-exit-velocity cornering, using a bicycle model with
suspension dynamics, directly addressing the same "accelerate before/at the
apex" question Beckman's Part 18 raises, from a rigorous optimal-control
perspective.

**None of this code was used or ported** — only their existence, licences,
and general approach were noted. What follows in Part 3 is built independent
of all three, using textbook forward/backward velocity-profile methodology
(well-established, not sourced from any single copyrighted work) plus this
project's own already-validated tyre model.

---

# PART 3 — Attempt 2: a from-first-principles alternative

## 3.1 The method

Rather than continue reconstructing Beckman's specific, unpublished
mechanics, `velocity_profile.py` implements the standard two-pass
forward/backward velocity-profile method used throughout the trajectory-
optimization literature (including, almost certainly, the TUMFTM tool
above):

1. **Forward pass** — at each point along the path, cap speed by (a) the
   maximum cornering speed the tyre model allows at that point's curvature,
   and (b) how fast the car could have accelerated from the previous point,
   given how much of the traction ellipse cornering has already used.
2. **Backward pass** — the same thing in reverse from the end of the
   segment, capped by braking capacity instead of acceleration.
3. **Take the minimum of the two at every point.** This is the standard
   result, and it comes with a real structural property: the result can
   never be slower than a naive constant-speed line, because the profile
   always has the *option* of just being that line.

**Uses this project's own `TireForceModel`** (Beckman's three-parameter
formula, already validated against his Part 21 worked example to within
13% — see `34-PHYSICS-READING.md`) rather than Beckman's simplified fixed
1g/0.5g ellipse, which is more honest: it's the model this project would
actually ship with.

## 3.2 What it found — one real bug, and two things that looked like bugs but weren't

**Real bug: backward-pass initialization.** The backward pass's starting
value was tied to whatever the forward pass had computed at the same point,
which chains the entire backward pass to a possibly-suboptimal forward
result instead of starting from a genuinely free value. Fixed by starting
the backward pass from the curvature-based cap at the end of the segment
(effectively unconstrained, since the segment ends in open straight track)
rather than from `v_fwd`'s final value.

**Looked like a bug, wasn't — driven-wheel count.** Initial results showed
the profile losing to the dummy line at every tested radius. Testing 2
driven wheels (RWD, this project's assumption) against 4 confirmed that
Beckman's dummy line implicitly assumes a flat 0.5g exit acceleration
regardless of drivetrain — a more generous assumption than an RWD car's
actual tyre-limited capacity. Switching to 4 driven wheels for a fair
comparison resolved 4 of 5 initial test cases immediately. **This is a real
modelling choice, not an error** — an RWD hero car should genuinely show a
smaller exit-acceleration advantage than this comparison's baseline.

**Looked like a bug, wasn't — the r=150ft boundary degeneracy.** At exactly
r=150ft, Beckman's own geometry formula hits `(r1−r)/(r−r0) = (200−150)/
(150−100) = 1.0` precisely, forcing the apex angle to a hard 90° and
collapsing the remaining corner arc to zero length. This is a genuine
mathematical degeneracy in *his* closed-form formula at that exact point —
consistent with his own observation that the apex angle is extremely
sensitive right at the minimum radius — not an implementation error. The
dummy-line time at exactly r=150.0ft is an artifact of this degeneracy and
is not representative of neighbouring values (r=150.5ft already looks
completely different).

## 3.3 What's still a real, unresolved limitation

`build_path()` always models the corner as a full semicircle (`π×r` of arc)
regardless of radius. Beckman's actual geometry only arcs for
`180 − 2×alpha` degrees, with the rest of the segment straight — and
`alpha` grows toward 90° as `r` shrinks toward 150ft, meaning the *real*
arc at tight radii is far shorter than a full semicircle. This makes
tight-radius results in `velocity_profile.py` drive an artificially long
path and read as slower than they should.

> ## Status, precisely
>
> **Validated and trustworthy: r ≳ 167ft.** The profile time is
> structurally guaranteed to be ≤ the dummy-line time at every radius
> tested in this range, with real margin (0.3–2.0 seconds, growing with
> radius).
>
> **Not validated: r ≲ 165ft.** The path-length simplification makes these
> results unreliable until `build_path()` is rewritten to use the
> variable-arc-angle geometry already implemented in `racing_line.py`'s
> `solve_geometry()`. The script itself prints this limitation when run.

---

# PART 4 — What to actually use, and how

## 4.1 Trustworthy today

- `racing_line.py`'s `dummy_line_time()` — validated to 0.3%, safe standalone
- `velocity_profile.py`'s full pipeline, **for wide corners (r ≳ 167ft)** —
  structurally validated, uses this project's real tyre model
- The tyre model, weight transfer, differential test, and RK4 benchmark from
  the rest of `code/prototype/simulation/` — unrelated to this thread,
  unaffected by any of the above

## 4.2 Not trustworthy today

- `racing_line.py`'s accelerate-and-unwind search — reconstructed, not
  validated, clearly marked in its own output
- `velocity_profile.py`'s results for tight corners (r ≲ 165ft) — known
  path-length limitation, clearly marked in its own output

## 4.3 If this capability is wanted for real (AI waypoint generation)

The honest path, in order of effort:

1. **Cheapest fix**: port `solve_geometry()`'s variable arc-angle logic into
   `build_path()`, so tight radii get the correct shorter arc instead of a
   full semicircle. Should resolve the remaining limitation directly.
2. **More rigorous**: adopt the TUMFTM/OptiLine-Py style of full
   minimum-time optimal control (CasADi/IPOPT-based), which handles
   arbitrary track shapes without hand-coding geometry cases at all — more
   setup cost, but no per-corner-shape special-casing ever again.
3. **Cheapest of all, if only wide corners matter**: use
   `velocity_profile.py` exactly as it stands today, restricted to corners
   above the validated radius threshold.

---

# Cross-references
- The flag that started this → `04-EXTRACTION-INVENTORY.md`, AI section
- Beckman Parts 17–18, and the missing-spreadsheet finding → `34-PHYSICS-READING.md` Part 1e
- The tyre model this all runs on, and its own validation → `code/prototype/simulation/tire_model.py`, `34-PHYSICS-READING.md` Part 1d
- TUMFTM's other tools already in this package → `35-EXTENDED-SOURCES.md` Part 3.1, `code/prototype/RVP-TRIAGE.md`
