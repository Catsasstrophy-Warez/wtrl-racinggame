# Test and Evaluation Pass

**What this actually is.** "Test all features" can't mean what it would
for a running game — nothing in this package has compiled or executed
in Unity. What follows is the honest version: a full cross-file code
audit of all fourteen C# files, one specific syntax question checked
rather than assumed, and one genuine numerical test run against the
already-validated tire model. Real findings only — nothing here is
padded to look like more happened than did.

---

# PART 1 — Code audit: clean

Every type referenced across the fourteen files in
`code/prototype/` was traced back to exactly one real definition —
`RivalAI`, `ClassBracket`, `ReputationTier`, `PartsGating`,
`SafetyRating`, `DriverLicense`, `DiagnosticSkill`,
`ReputationTraits`, `BuildRecipe`, `NitrousSystem`, `StuntSystem`,
`AggressionEconomy`, `PursuitEscapeEvent`, `RaceFormat`,
`PartPriceTier`. No duplicates, no missing definitions, no leftover
references to a type that got renamed or restructured along the way —
the same class of bug the `ClassBracket` fix caught earlier in this
codebase's history, checked for again across the whole set and not
found a second time.

**Field access verified directly, not assumed**: `StuntSystem`'s
close-call detection reads `raggedEdgeMeter.fillLevel01`, and that's
confirmed as the real, exact public field name on `RaggedEdgeMeter`,
not a plausible-looking guess.

---

# PART 2 — One thing checked that looked like a bug and wasn't

`DriverLicense.Promote()`/`Demote()` use `currentGrade++` and
`currentGrade--` directly on an enum-typed field — a real, common C#
gotcha in other contexts, worth verifying rather than assuming either
way. **Confirmed valid**: C# defines increment/decrement operators on
any enum type against its underlying integral representation, so this
compiles cleanly. Recorded here specifically because catching a false
positive and saying so is as much a part of an honest audit as
catching a real one — the temptation with a "thorough test" is to
report only findings that sound like problems.

---

# PART 3 — The one genuine numerical test

`NitrousSystem.tractionCeilingMultiplier` (1.15×) was never checked
against anything before this pass — it existed as a plausible-looking
number in `ActionSystems.cs`, the same unexamined-value pattern `56`
found and audited in the RPG thresholds, just not yet checked on the
physics side.

**Run against the actual validated tire model**
(`code/prototype/simulation/tire_model.py`, the same one Beckman's own
worked example already confirmed):

| | Force per wheel | Implied friction coefficient |
|---|---|---|
| Baseline (no nitrous) | 5,538 N | **1.61** — matches the earlier Beckman-validated reference of ~1.6–1.7 |
| Full nitrous | 6,369 N | **1.85** |

**Finding**: not physically absurd — real drag-slick compounds on a
prepped surface can reach that range — but it sits near the upper edge
of plausibility rather than comfortably inside it, the way the
unboosted baseline does. **This is a production-tuning flag, not a
bug**: worth a second look once real device testing exists, since a
value that's defensible in isolation can still feel wrong in motion in
a way no static number check can catch.

---

# PART 4 — What this pass does not and cannot claim

No frame rate was measured. No input was tested on a device. No car
has driven a single metre in an engine. The dyno pass condition — curve
moves, lap time moves, felt through tilt — remains exactly as
unconfirmed as it's been since the first time this package named it as
the actual gate. **A clean code audit and one validated numerical
check are real, useful work, and they are not a substitute for that
gate.** Nothing in this document should be read as narrowing the gap
between "specified and internally consistent" and "known to work,"
because those remain two different claims, and conflating them is the
exact failure mode this whole package has spent its longest stretches
correcting in itself.

---

# Cross-references
- The codebase this audits → `code/prototype/*.cs`
- The tire model this test runs against → `code/prototype/simulation/tire_model.py`
- The original validation this nitrous check extends → `code/prototype/simulation/differential_test.py`
- The actual remaining gate → `42-PATH-TO-LIVE-TESTING.md`, `46-TONIGHT-BUILD-SESSION.md`
