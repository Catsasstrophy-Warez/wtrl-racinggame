# Forza, Analyzed Deeply: Drivatar Against What's Already Built

**What this is.** Forza appeared in four documents before this one,
always as a single comparison line, never a dedicated deep dive —
livery/auction economy, festival framing, Drivatar named but not
explained, seasonal content, "excellent telemetry, not a dyno." This
goes deep on the one Forza system with the most direct bearing on
work already done: **Drivatar**, an AI trained on real player driving
data, with a real documented history including a real failure case.

---

# PART 1 — What Drivatar actually is

Since Forza Motorsport 5 (2013), Drivatars train in the cloud via
reinforcement learning on real player data — car position, speed, and
consistency of behaviour, tracked **per track segment** (a 12-turn
circuit gets broken into roughly 27 segments, each modelled
separately) rather than as one whole-lap average. Trained models are
small enough (just network weights) to download quickly before a
race, meaning a player can end up racing an AI built from a specific
friend's actual habits, whether or not that friend is online.

**The "paid while you're away" mechanic**: a player's own Drivatar can
appear as an opponent in *other* players' races, earning the original
player in-game credits for it — surfaced via a message center
notification when they return.

---

# PART 2 — Two direct checks against systems already built

## 2.1 ⚠️ A real failure case, checked against `RivalAI.cs` — and it holds

Documented directly: early Drivatar versions trained too faithfully on
raw player behaviour and learned genuinely toxic habits — deliberately
ramming, dirty driving — forcing Turn 10 to build override logic that
filters bad training signals before they reach the AI, rather than
copying player behaviour unbounded.

**Checked against this project's own AI system before claiming
anything**: `RivalAI.cs`'s `ApplyDelta()` clamps every one of its four
parameters to a per-rival ceiling on every single call —
`brakePointBias`, `passAttemptSuppression`, `defensivePositionError`,
and `launchReactionDelayMs` all pass through `Mathf.Clamp` against a
bounded maximum, never accumulating past a personality-defined limit
no matter how much history feeds in.

> **This is the same lesson, arrived at independently.** Forza learned
> the hard way that raw, unbounded training on player behaviour
> produces toxic AI. This project's `RivalAI` was built with per-rival
> ceilings from the start — not because of Forza's failure, but for an
> unrelated reason (`32` §5.3's personality-driven limits, e.g.
> Reyes's low ceiling on backing off from intimidation). **Two
> unrelated design paths landing on the same safeguard** is a stronger
> confirmation than either alone, the same shape of evidence the idle-
> game check produced for the early-tier income gate two documents ago.

## 2.2 A third independent confirmation of the passive-income pattern

`59-TRENDS-GTA-PASSIVE-INCOME.md` built shop passive income from GTA
Online's staffed-business model, then stress-tested it against
idle-game design specifically. **Forza's own Drivatar "paid while
you're away" mechanic is a third, structurally identical pattern**:
something acting on the player's behalf earns money while they're
gone, surfaced through a non-blocking notification on return.

**Not new work — a confirmation, stated as one.** Three unrelated
sources (an open-world crime game's business economy, the idle-game
genre's own stated best practices, and a racing game's AI system) all
independently produce the same shape: automated earning, capped or
bounded, delivered through a welcome-back message rather than a
constant ambient counter. `AutologNotification.cs`, already built,
already handles this shape correctly.

---

# PART 3 — What's genuinely new, not yet built

## 3.1 Per-segment behaviour modelling — a real option, not a closed gap

Drivatar's track-segmentation approach — modelling player behaviour
*per corner*, not as one lap-average — is a genuinely different level
of fidelity from `RivalAI.cs`'s current flat, whole-race parameters.
**This is a real enhancement option, not a gap this document is
closing.** Unlike the passive-income and AI-safeguard findings above,
nothing already built does this, and building it would be new scope,
not assembly of existing work. Recorded here as a considered option
for later, consistent with this project's standing rule against
building speculative depth just because a well-documented technique
exists elsewhere.

## 3.2 Timestamped, decaying trust in older data

Drivatar treats older behavioural uploads with less confidence than
recent ones. **A real, usable pattern if `ReputationTraits.cs`'s
running-average calculation ever needs recency-weighting** — currently
a simple running mean (`ReputationTraits.cs`'s `RecordEventOutcome()`),
which weights old and recent results equally. Not changed here;
flagged as the specific place this Forza technique would apply if
recency ever becomes a design priority.

---

# PART 4 — What this deliberately doesn't take from Forza

**The rubber-banding admission.** Turn 10's own stated position is
that Drivatar *cars* are performance-adjusted based on gap to the
player, even though *driving behaviour* is trained honestly. This is
exactly the rubber-banding pattern this project's own research already
identified as a failure mode (`18` §2.3, `31` §2.3) and built the
intimidation-factor system specifically to avoid (`32` §5). Confirmed
as a real thing Forza does, and confirmed as correctly not adopted
here — a contrast worth having on record, not a gap to close.

**The auction house / UGC tuning economy.** Real, and genuinely
outside this project's scope at its current stage — a social/
marketplace layer requiring live infrastructure this project doesn't
have yet, the same reasoning that kept GTA's live-service rebalancing
lever out of `59`.

---

# Cross-references
- The passive-income pattern this confirms a third time → `59-TRENDS-GTA-PASSIVE-INCOME.md`
- The AI safeguard this checks → `code/prototype/RivalAI.cs`, `32-HERO-CAR.md` §5.3
- The notification system already built → `code/prototype/AutologNotification.cs`
- Rubber-banding, correctly avoided → `31-DYNO-ANALYSIS.md` §2.3, `32-HERO-CAR.md` §5
- Existing (thin) Forza mentions → `17-GENRE-TAXONOMY.md`, `24-GARAGE-SYSTEMS.md`, `25-GARAGE-DESIGN.md`, `31-DYNO-ANALYSIS.md`
- The running-average calculation §3.2 flags → `code/prototype/ReputationTraits.cs`
