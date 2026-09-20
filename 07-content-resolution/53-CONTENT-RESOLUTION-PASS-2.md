# Resolving the Content Gap, Pass 2: A Second Circuit and Three Format Instances

**What this is.** Continuing `52`'s work against `51`'s inventory. The
test circuit was the only fully-designed track in the package, and
three race formats had complete rulesets with zero concrete instances.
Building one real circuit unblocks all three at once — touge, knockout,
and pursuit/escape all need somewhere real to run, and now have it.

---

# PART 1 — The second circuit, built to real specs

Following `44-TRACK-ROSTER.md` Part 3.1's design brief (elevation and
length, rendered above) — the brief said "long relative to the roster,"
"three or four blind-crest sections," "forested, low-sightline
setting." This is that brief, made concrete the same way `43` Item 5
made the first circuit concrete.

## 1.1 The layout

**4.2km, sixteen corners, three blind crests** — three times the
length of the test circuit, with double the corner count, matching the
brief's own stated goal of rewarding real-time reading over
memorisation.

| Feature | Corners | Detail |
|---|---|---|
| Opening sequence | 1–2 | Moderate, building speed off the start |
| **Crest A** | 3 | Blind — the road drops away before the next corner is visible |
| Technical link | 4–5 | Tightening in, second blind rise into... |
| **Crest B** | leads to 6 | ...a hairpin taken blind, r=20m |
| Recovery sequence | 7–8 | Opening back up |
| **Crest C** | 9 | Third blind crest, different character from A and B — a compression rather than a drop |
| Second hairpin | 11 | r=18m, the tightest point on the circuit |
| Long closing sequence | 12–16 | Progressively opening back toward the start/finish |

**No corner sequence is reused or mirrored from the test circuit** —
different radii, different rhythm, deliberately built to feel like a
different circuit rather than a rescaled version of the first one.

## 1.2 What this specifically tests, versus the first circuit

The test circuit (`43` Item 5) was built short and learnable on
purpose — the opposite design goal. This one is long and
unpredictable on purpose. Together they cover both ends of what `44`
Part 3.1 originally specified as the point of having more than one
circuit in the first place.

---

# PART 2 — Touge duel, a real instance

`41-RACE-FORMATS-GHOSTS-OBJECTIVES.md` §1.2's ruleset, paired with a
real track and a real rival for the first time.

**Route**: corners 3 through 11 of the new circuit — both blind
crests A and B, the first hairpin, the technical link section. Deliberately
excludes the long closing sequence, since touge's proximity-scoring
format rewards sustained technical pressure, not a long straight where
the format's own logic (`41` §1.2) stops applying.

**Rival**: the Constant (Marsh) specifically — `45` §3.4 already names
touge duels as his format, and his real `RivalAI` values (`52` §1.6 —
all four ceilings low and uniform at 0.15) mean this instance tests the
player against his trail-braking advantage directly, not against AI
intimidation behaviour standing in for it.

**Win condition**: hold a cumulative 10-second lead across the route
(`41` §1.2's original spec, unchanged) — on this specific 8-corner
technical section, at this specific car's pace, that's a genuinely
demanding target, not a rubber-stamped number.

---

# PART 3 — Knockout event, a real instance

`41` §1.3's ruleset, `50` Part 3's action-pillar context (aggression
economy active, since knockout is a professional-tier format where the
Safety Rating gate — `48` §3.3 — keeps contact-as-strategy in check
without needing a separate rule).

**Route**: the full 4.2km lap, all sixteen corners — a knockout field
needs the longer circuit's real passing zones and recovery sections
that the shorter test circuit doesn't have room for.

**Field**: five rivals — Reyes, Kade, Vogel, Duquesne, and Osei, each
with their real `52` Part 1 tuning values live. Marsh is deliberately
excluded from this instance — his format is touge (§2 above), and `45`
§3.4 already established not every rival needs to appear in every
format.

**Elimination**: last place eliminated at the end of each lap,
five-car field down to one across four laps — short enough for a
mobile session, long enough for the elimination pressure to matter at
least twice before the final lap.

---

# PART 4 — Pursuit/escape, a real instance

`50` Part 3's two variants, given an actual route and rival pairing.

**Pursuit variant**: the player chases Duquesne — `45` §3.4 already
names him the natural pursuer archetype, but in the pursuit variant
specifically the player is doing the chasing, so his real tuning
(`52` §1.4 — near-zero pass suppression, the most extreme value in the
whole rival set) makes him drive with the same reckless-but-fast
character from the fleeing side of the chase, a genuine test of
closing a gap on a car that won't drive conservatively just because
it's being pursued.

**Escape variant**: the player flees Duquesne — matching his archetype
directly this time, aggression economy fully active for him as the
pursuer (`50` §3.3).

**Route**: the opening sequence through Crest A (corners 1–3) repeated
in a loop for the escape variant's duration-based win condition, since
a chase format benefits from a shorter, repeatable section rather than
a single long lap.

---

# PART 5 — What this closes, and what's still open

**Closed**: a second full circuit exists. All four race formats now
have at least one concrete instance with a real track, real rivals,
and real numbers — outrun (`43`), touge (§2), knockout (§3),
pursuit/escape (§4).

**Still open, per `51`'s own discipline — no invented target number**:
the road course design briefs in `44` Part 3.2 and 3.3 (the
signature-elevation-drop circuit and the technical/tight circuit)
remain briefs, not designs. Drag strips and ovals still have zero
named facilities. RPG data assets — actual `BuildRecipe` instances,
tested license thresholds — remain untouched by this pass.

---

# Cross-references
- The gap this continues resolving → `51-CONTENT-INVENTORY.md`
- The design brief this circuit fulfils → `44-TRACK-ROSTER.md` Part 3.1
- The first circuit, for contrast → `43-FIRST-PLAYABLE-SPECS.md` Item 5
- Race format rulesets → `41-RACE-FORMATS-GHOSTS-OBJECTIVES.md`, `50-ACTION-PILLAR-EXPANDED.md` Part 3
- Rival tuning values used throughout → `52-CONTENT-RESOLUTION-PASS-1.md` Part 1
- Per-rival format fit → `45-RIVAL-DEVELOPMENT.md` §3.4
