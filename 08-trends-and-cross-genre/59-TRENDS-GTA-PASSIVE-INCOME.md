# Shop Passive Income: A Real Gap, Closed With a Grounded Lesson

**What this is.** A genuine gap surfaced by checking trend research
against this project's own design, not assumed from either side. `20-
CONCEPTS.md` §18 named "small passive income" as part of the House
property tier, six documents before `25-GARAGE-DESIGN.md` Part 7
specified that tier in full — and Part 7 never mentioned income at
all, only labour presentation. The line existed; nothing built it.

**What closes it**: not GTA content, GTA's economic *structure* —
researched directly rather than assumed. GTA Online's 2026 economy
runs on staffed businesses earning while the player is offline, and
its own guides are explicit that **purchase sequencing matters more
than the purchase itself** — buying earning capability before the
standing to use it means it "sits generating almost nothing." Neither
idea requires importing anything foreign to this project's premise —
both connect two systems that already exist here and have simply never
been wired together.

---

# PART 1 — The mechanism

## 1.1 What generates income, and why it isn't new

`25` §6.2b already has shop staff, introduced at the pro-shop tier,
currently doing exactly one job: installing parts on the player's own
car so the player's weekly slot goes to a job or commission instead.
**The passive-income mechanism is the same staff taking on outside
customer work** — cars that aren't the player's, generating income
while the player is off doing anything else, including nothing.

**This is not a new system.** It's the existing staff mechanic, given
a second customer.

## 1.2 Why it's gated by reputation, not just property tier

`48-RPG-SYSTEMS-SPEC.md` Part 2 already tracks reputation for a
completely different purpose — whether a *parts* dealer trusts the
player. **The same tracked value gates outside customer volume**,
because the underlying real-world logic is identical: nobody brings
their car to an unknown shop, the same way nobody sells serious parts
to an unknown buyer. One value, two consumers, no new number to
invent or balance separately.

**This is the direct mechanical expression of the sequencing lesson.**
A player who rushes to the warehouse tier without building reputation
first gets a fully-staffed shop with no customers walking in — exactly
GTA's Nightclub-before-supporting-businesses trap, arrived at here
through a system this project already owns rather than copied from
the source that surfaced the lesson.

## 1.3 The actual numbers, tied to existing tiers

| Property tier (`25` Part 7) | Reputation tier (`48` §2.4) | Passive income rate |
|---|---|---|
| Driveway / Garage | Any | **None** — no staff exist yet, matching `25` §6.2b exactly |
| Pro shop | Unknown | **None** — staff exist, but no outside customer trusts an unknown shop |
| Pro shop | Known or higher | **Low** — the first real passive trickle, small on purpose |
| Warehouse | Known | **Low** — same rate as pro shop; the property upgrade alone changes nothing without reputation to match, the sequencing lesson made concrete |
| Warehouse | Respected or higher | **Meaningful** — full staff, full trust, the tier this system is actually built to reward |

**No number here is invented in isolation** — each rate is set
relative to the existing repair-cost economy (`20` §14) specifically
to stay a texture, not a second main income source, the same
restraint already applied to the aggression economy's reward sizing
(`50` §1.2).

---

# PART 1b — Stress-tested against idle-game design specifically

Passive income is the newest, least-checked part of this design, and
idle/incremental games are built entirely around passive mechanics —
a sharper test than GTA's broader economy offered. Checked directly
rather than assumed sufficient.

**Adopted**: idle-game design treats a "welcome-back payout" as
near-universal — a clear summary of what accrued while the player was
away. **Correction caught before this claim shipped wrong**: the first
draft of this section said this "costs nothing new" because `41`
§2.3's Autolog layer already handles this shape of message. Checked
before trusting that — Autolog has never been implemented as code,
same as everything else in `41` before the resolution passes gave it
instances. The *pattern* is reused (one notification shape, two
message sources); the code is not free. Built below, in
`AutologNotification.cs`, as a small shared class both ghost/rival
results and passive income now feed.

**Confirmed, not rebuilt**: idle-design guidance is explicit that
early-game automation undermines engagement — "don't automate too
early." §1.3's table already gates all income to zero at Driveway/
Garage, for an unrelated reason (no staff exist yet, `25` §6.2b). Two
different reasons arriving at the same rule is a genuine independent
confirmation, not a change.

**Declined on purpose**: real idle games accrue income against actual
elapsed offline time, capped to keep the economy honest. This system
stays a flat per-session amount instead. **Not an oversight** — this
project isn't an idle game, and time-scaled accrual would push passive
income toward a second primary economy, which Part 2 below already
rules out explicitly. Stated here so the omission reads as a decision,
not a gap.

# PART 2 — What this deliberately doesn't do

**No criminal content, no businesses foreign to the premise.** GTA's
actual nightclubs, bunkers, and cargo routes stay exactly where they
are — what transferred is the *shape* (staffed capability, gated by
standing, sequencing-dependent), not the content.

**No live-service rebalancing system.** GTA's Title Update 1.73 — cutting
active-grind payouts to push players toward passive stacks — is a
live-ops lever this project has no reason to build before it has a
live game. Worth knowing that lever exists for later; not worth
building now.

**No change to the core economic engine.** `20` §14's repair costs
remain the primary economic driver. This stays exactly what its own
name says: passive, not primary.

---

**Update, from a self-check immediately after this document's own
code landed**: the first version used bare string literals
(`"ProShop"`, `"Warehouse"`) for property tier instead of a real enum —
the only place in this whole codebase where property tier had no
proper type, found specifically because this was the first code to
reference it by name at all. A typo would have failed silently at
runtime instead of at compile time. Fixed with a real `PropertyTier`
enum in `code/prototype/PartsGating.cs`, matching the type-safety
standard every other tiered concept in this codebase already has
(`ClassBracket.Tier`, `DriverLicense.Grade`).

**`AutologNotification.cs` built** — the welcome-back payout queues through `QueuePassiveIncome()`, called with `PartsGating.PassiveIncomePerSession()`'s real return value on session start.

# PART 3 — Code implication

`PartsGating.cs`'s `ReputationTier` enum and `CurrentTier` property are
already exactly what §1.3's table needs to read from — no new
enum, no new tracked value. A small addition (a passive-income-rate
lookup keyed by property tier + `ReputationTier`, computed on a timer
or on session return) is the only new code this requires, and it
reads two systems that already exist rather than adding a third.

---

**A third independent confirmation, from a genuinely different source, is in `60-FORZA-DEEP-ANALYSIS.md` Part 2.2** — Forza's Drivatar "paid while you're away" mechanic is the same shape again: automated earning, surfaced via a welcome-back notification, from a racing game's AI system rather than a crime game's economy or the idle genre's own design rules.

# Cross-references
- The gap this closes → `20-CONCEPTS.md` §18, `25-GARAGE-DESIGN.md` Part 7
- The staff mechanic this extends → `25-GARAGE-DESIGN.md` §6.2b
- The reputation value this reads → `48-RPG-SYSTEMS-SPEC.md` Part 2, `code/prototype/PartsGating.cs`
- The economic restraint principle this follows → `20-CONCEPTS.md` §14, `50-ACTION-PILLAR-EXPANDED.md` §1.2
