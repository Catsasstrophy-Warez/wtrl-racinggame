# The Track Roster: Drag Strips, Ovals, and Derived Road Courses

**What this is.** Drag strips and ovals are standardized formats defined
by sanctioning-body distance and safety rules — building them accurately
is a technical-specification exercise, safe to do directly. **Road
courses are different**, and get the same treatment `12-DERIVATION-
METHOD.md` already applies to the hero car: real tracks researched as
reference, genuinely original layouts built from what makes each one
*interesting*, never their actual turn-by-turn geometry. Racing games
license real tracks explicitly (Gran Turismo licenses Laguna Seca and
the Nürburgring by name) — that licensing practice itself confirms there
is a recognized proprietary interest here, even where the exact legal
theory varies by jurisdiction. Nothing below traces a real layout.

---

# PART 1 — Drag strips: standardized, built directly

**Real NHRA/UEM standards used as-is** — these are functional
specifications, not creative works, the same category as "a regulation
football pitch."

| Format | Real standard | Notes |
|---|---|---|
| **Eighth mile** | 660 ft (201 m) | The traditional short format |
| **Quarter mile** | 1,320 ft (402 m) | *Not* the current top-tier NHRA standard — see below |
| **1,000 ft** | 304.8 m | **The actual modern NHRA top-fuel/funny-car standard**, adopted after 2008 for safety reasons. Worth including alongside the classic quarter for authenticity — a period-correct 1965-era strip should run the full quarter; a modern-era strip should offer 1,000 ft as the "serious" distance. |

**Shutdown area**: real-world rule of thumb is roughly the race distance
again, sometimes more — build shutdown zones at least equal to strip
length, per the sourced NHRA/UEM guidance.

**Lane width**: UEM standard gives 7m minimum per lane, 18m ideal total
for two lanes — directly usable.

## ⚠️ Half-mile and full-mile: not standard drag distances, reframed honestly

**Neither 1/2 mile nor full mile is a real NHRA/IHRA sanctioned drag
racing distance.** Drag racing's real standard distances are the three
above. Building fictional "sanctioned" half-mile and full-mile drag
strips would mean inventing a claim the real sport doesn't make.

**The honest fix — these map onto a real category instead**: **standing-
mile events** — land-speed-style runs, historically held on airstrips
and salt flats, a genuinely real and distinct motorsport tradition from
drag racing proper. Recommend building the 1/2-mile and full-mile
formats as **standing-mile events**, narratively and mechanically
distinct from the drag strips (different HUD, different scoring — top
speed and terminal velocity rather than reaction time and 60-foot times)
rather than presenting them as a fourth and fifth drag distance.

---

# PART 2 — Ovals: real classification, fictional facilities

Real NASCAR-style classification boundaries, used as the design
envelope — not any specific named track's layout.

| Requested length | Real category | Banking range (sourced) |
|---|---|---|
| **3/4 mile** | Short track (<1 mile) | Steepest real short tracks run up to ~30° (Bristol-class) |
| **1.5 mile** | Intermediate (1–2 miles) | Real intermediates typically run 12–24° |
| **2.5 mile** | Superspeedway (2+ miles) | Real superspeedways run 28–33° at the top end |

**Shape variety, all real, all generic categories** (not tied to any
specific track): the simple two-straight/two-180°-turn oval, the
**tri-oval** (a third bend breaking up the main straight, improving
sightlines), and the **D-shaped oval** (one straight backstretch, one
long sweeping frontstretch). Building all three as distinct fictional
facilities gives real variety without needing three different lengths
each — a 1.5-mile tri-oval and a 1.5-mile D-oval are meaningfully
different circuits at the same classification.

## ⚠️ Simulated, and a real finding: top banking is power-limited, not grip-limited

`code/prototype/simulation/oval_banking_test.py` — tested the tire
model's actual lateral grip against this table's real banking range,
using the standard banked-turn speed formula. Two bugs were found and
fixed in production (a geometry approximation that briefly implied
517mph before correction — see the script's own inline notes), and one
finding survived the fix and is worth building into the design directly:

**At superspeedway-class banking (28–33°), the grip-limited formula
implies speeds of 246–327mph.** Checked against the drag equation
(`34-PHYSICS-READING.md` Part 1c, Part 6): reaching 327mph requires
roughly **2,150hp just to overcome aerodynamic drag**, before any of
that power moves the car forward. Nothing in this project's design
gets near that output. **The real limiting factor at superspeedway
banking is power and drag, not tire grip** — the same effect Beckman's
own drag chapter already establishes, now confirmed against this
project's own track specifications rather than left as a general
physics fact.

**Design implication**: don't tune superspeedway lap times against the
grip ceiling this table's banking angles would suggest. The achievable
top speed on the 2.5-mile class should be set by each car's actual
power-to-drag balance, computed the normal way (`DynoController.cs`),
with the banking angle mattering far less at the top of the speed range
than it does on the short track and intermediate classes, where the
grip ceiling (100–164mph in the same test) is the real constraint and
sits comfortably within reach of the cars already specified.

---

# PART 3 — Road courses: the derivation method applied properly

**Three original circuits, each drawing on one real characteristic
principle — never a real layout.**

## 3.1 The elevation-and-length principle (not the Nürburgring's layout)

**What's real and citable**: extreme total elevation change, a high
corner count relative to distance, blind crests where the road drops
away before the driver can see the next section, and a setting that
removes visual reference points (dense tree cover rather than open
sightlines).

**What NOT to do**: trace anything resembling the actual 70-plus-corner
sequence, adopt the real name or any close variant, or reproduce the
specific famous named corners.

**The original design**: a long circuit (genuinely long relative to the
rest of the roster — this is a *length* and *unpredictability* principle,
not a specific-corner principle, which makes it the safest of the three
to build from), built with **three or four blind-crest sections** placed
at different points in the lap, each committing the player before the
next feature is visible. Forested, low-sightline setting throughout.
**This is the circuit that should punish memorization the least and
reward real-time reading the most** — the opposite design goal from the
test circuit in `43-FIRST-PLAYABLE-SPECS.md`, which is short and
learnable by design.

## 3.2 ⚠️ The signature-elevation-drop principle (explicitly not the Corkscrew)

**Built to concrete geometry in `54-CONTENT-RESOLUTION-PASS-3.md` Part 1** — all four deviations below confirmed preserved in the actual layout, not just specified as intent.

**What's real and citable**: a single, brief, dramatic elevation drop as
a circuit's most identifiable moment — a blind entry followed by a rapid
descent that compresses the car's suspension hard. This design pattern
(one signature corner as a track's "calling card") is real and common
enough across circuits worldwide that the *pattern itself* isn't
protectable — what would be a problem is copying the *specific*
corner sequence people instantly recognize.

**The single most recognizable element in this whole document** — worth
being explicit about, the same way `13-MUSTANG-DOSSIER.md` treats
Eleanor's hood scoop as the one detail that must be deliberately changed,
not the one to lean into.

**What's different in the original design, on purpose**:
- **Direction reversed** — the real reference corner is a left-right
  descending combination; this design uses a **right-left** sequence
- **Different elevation profile** — a single steep drop rather than the
  reference's two-stage compression
- **A coastal cliff setting rather than a coastal hillside** — same
  general "ocean views, elevation drop" character, different specific
  geography (a cliff-edge circuit reads differently from a hillside one)
- **The drop happens mid-lap, not two-thirds through** — different
  narrative position in the lap

**The result**: a circuit that's recognizably "a track with one dramatic
signature elevation moment near the coast" — a real, common circuit
archetype — without being a redrawn version of any specific one.

## 3.3 The technical-and-tight principle (drawing on Spa/Suzuka/Monaco generally, no single one specifically)

**Built to concrete geometry in `54-CONTENT-RESOLUTION-PASS-3.md` Part 2.**

**What's real and citable, drawn broadly rather than from one source**:
a fast, uphill compression corner as an early-lap test of commitment
(a pattern from several famous circuits, not one); a figure-eight or
crossing-over layout element (also a pattern that exists at more than
one real circuit); and a tight, low-speed, barrier-close street-circuit
character (again, a real pattern at several real circuits, not unique to
any one).

**The original design**: a mid-length technical circuit combining a
fast uphill compression section early in the lap with a tight, barrier-
close infield section in the second half — genuinely different specific
geometry from any single real reference, built from a *blend* of several
real patterns rather than one circuit's specific sequence, which is the
safest possible construction (no single real track's fingerprint is
traceable in the result).

---

**Named facilities built to these standards in `55-CONTENT-RESOLUTION-PASS-4.md`** — Redline Raceway (drag/standing-mile), Cutback Tri-Oval, Longbow Speedway, and Highbank Superspeedway.

# PART 4 — Roster summary

| Type | Count | Basis |
|---|---|---|
| Drag strips | 2 (eighth, 1,000ft) + period-correct quarter option | Real NHRA/UEM standards, used directly |
| Standing-mile events | 2 (half, full) | Reframed from "drag" to the real standing-mile category |
| Ovals | 3+ (short/intermediate/superspeedway, in tri-oval and D-oval variants) | Real classification envelope, fictional facilities |
| Road courses | 3 | Original layouts, each derived from a real *principle*, never a real *layout* — one explicitly reworked away from its most recognizable real-world reference point |

---

# Cross-references
- The derivation method this follows → `12-DERIVATION-METHOD.md`
- The hood-scoop precedent for "change the recognizable element" → `13-MUSTANG-DOSSIER.md`
- Worked derivation cases → `15-DERIVATION-CASEBOOK.md`
- The first test circuit (short, learnable — contrast with Part 3.1's design goal) → `43-FIRST-PLAYABLE-SPECS.md` Item 5
- Sanctioning-body legal status of real tracks generally → `01-LICENSING.md`
