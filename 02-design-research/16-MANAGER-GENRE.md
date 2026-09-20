# The Manager Genre

**Where this fits.** Race management games are the reference for your
**professional tier** — the point in the career where the player owns a shop and
stops being only a driver (`07-INFLUENCE-MAP.md` §2.2, `11-SYSTEMS-SPEC.md`
§2.10). They are not a model for your core game. Read §6 before anything else.

Analysis only; all titles proprietary.

---

# PART 1 — The commercial picture

Three data points that map almost exactly onto your positioning.

## 1.1 Motorsport Manager — unlicensed, mobile-first, succeeded

Playsport Games' first and only title. **Released on iOS 21 August 2014 as a
premium game.** Considerable critical and commercial success led to Android in
2015, and then SEGA — publisher of Football Manager, which played a mentoring
role in development — financially backed a full desktop version released
9 November 2016.

The PC version significantly expanded the mechanics, freed from mobile hardware
constraints. DLC added an **Endurance Series** (multi-class racing, longer races,
driver stamina, six-driver teams) and a **GT Series** (ERS, different car
silhouettes).

**In February 2026 Playsport bought the PC rights back from SEGA, and in June
2026 announced Motorsport Manager 2 for 2027.**

> A single studio's mobile game became the genre's defining franchise and
> outlasted its own publisher relationship.

## 1.2 F1 Manager — licensed, expensive, dead

Frontier Developments ran the official series 2022–2024 on Unreal Engine.
**F1 Manager 2024 (23 July 2024) was the final entry.** Frontier cancelled
F1 Manager 2025 and **terminated the Formula 1 licence early after the franchise
failed to turn a profit.** They had already priced the 2024 game below
Codemasters' F1 24 in response to underperformance.

Reviews rated 2024 the best of the three. It still failed commercially.

## 1.3 Motorsport Manager Online 2025 — free-to-play, hollowed out

The mobile follow-up. Representative player review:

> All of the mechanics are dumbed down with no depth left to "manage." You just
> upgrade everything to the maximum and if you're lacking money, either wait or
> buy more with microtransaction.

Resources described as punitively slow to earn, especially rare parts.

## 1.4 The pattern

| Approach | Outcome |
|---|---|
| Unlicensed, mobile-first, premium, deep | Franchise-defining success |
| Officially licensed, premium, annual | Licence terminated early, series cancelled |
| Free-to-play mobile with heavy monetisation | Depth stripped, players notice and say so |

**Unlicensed and deep beat licensed and expensive.** Directly supports the
positioning in `13-MUSTANG-DOSSIER.md` and the fictional-brand approach in
`12` and `15`.

---

# PART 2 — Fictional worlds validated

Motorsport Manager holds **no FIA licence.** Playsport built an entire fictional
universe: teams like Panther Precision Racing and Vexala Motorsport, and a
starting driver roster of recognisable expies — Zoe Sharp (Ricciardo), Harry
Chapman (Hamilton), Dieter Wexler (Vettel), all rated near five stars.

Fans built "Real World" mods on Steam Workshop replacing everything with actual
F1, F2 and IndyCar content. **Many veteran players prefer the original fiction**,
arguing the invented rivalries are more immersive and more distinctive.

Even the licensed game hedges: F1 Manager 2024's preset liveries take clear
inspiration from former F1 teams **without going close enough to require
licensing.**

> The genre's most successful game is entirely fictional, and its community
> actively prefers it that way. File alongside `15-DERIVATION-CASEBOOK.md`
> Pattern 5.

---

# PART 3 — The race weekend structure

Three phases: **Practice → Qualifying → Race.**

## 3.1 Practice
The player fine-tunes the car to adapt its performance to the track's features.
Drivers report back ("I'm losing time out here, we need to do something about
the setup").

> **This is the piece your game is missing.** You have enormous tuning depth
> (`11` §2.2) but no structured moment where it pays off. A practice session
> that reveals what the track demands converts tuning from a menu into a
> decision with stakes.

## 3.2 Qualifying
Determines grid position. A separate skill test from race pace, and a natural
place to use the "ragged edge" instability system (`06` §1.2) — one lap, maximum
risk, no recovery time.

## 3.3 Race
Tyres and other parts wear and slow the car as the race goes on. The player
orders a pit stop and selects what to swap or repair.

**The core trade: each repair and change adds to the pit time.** Too many stops
or repairs and you lose track position. That single rule generates the entire
strategic layer.

---

# PART 4 — Systems worth stealing

## 4.1 Facility → stat mapping (highest value)

F1 Manager 2024's facility list is a ready-made template for your property
ladder. Note that **every building buffs one named system** — no vague
"+10% everything" upgrades.

| Facility | Effect |
|---|---|
| Race Simulator | Driver development rate |
| Weather Centre | Accuracy of weather forecast |
| Board Room | Board confidence, team attractiveness |
| Hospitality Area | Team marketability, attractiveness |
| Helipad | Sponsorship, marketability, attractiveness |
| Memorabilia Room | Mentality, marketability, attractiveness |

**Apply to your house → garage → pro shop → warehouse ladder:** each tier must
name what it improves. Candidates — storage capacity, passive income, repair
cost reduction, fabrication tier unlocks, part development speed, sponsor
attractiveness, staff quality ceiling.

## 4.2 Asymmetric rival profiles

Every AI team starts with distinct technical strengths and weaknesses. Van Dort
has shoddy brakes and front wings; Kitano has terrible engines and mediocre
staff; Chariot has the second-best gearbox but poor engines, suspension and rear
wings, plus the weakest driver pairing.

**Result: rivals become readable.** You learn which teams are strong at which
circuits. Enormously better than a difficulty slider, and it costs only a data
table.

Pairs with Ishaan35's randomised AI pathing (`04` §5) — technical profile plus
behavioural variation.

## 4.3 Mechanical failures

F1 Manager 2024 finally added them: pushing cars to the edge lap after lap
exacts a toll, and races present evolving opportunities as rivals suffer issues.

> **This is the missing connective tissue** between your damage model (`11` §2.4)
> and your ragged-edge instability meter (`11` §2.3). Drive at the limit long
> enough and something breaks. It also creates comeback opportunities without
> rubber-banding, which is the honest way to keep races close.

## 4.4 Chairman expectations
The player must meet a stated objective — finish at least Xth by season end.
**Objectives with consequences, not just rewards.** Failure should cost
something: a sponsor, a contract, access to a tier.

## 4.5 Development curves that flatline
The genre's real texture, per one reviewer, is the willingness to fire a driver
who has been with your team six seasons because his development curve flatlined.
If you hire staff at the pro shop, they should be capable of disappointing you.

## 4.6 Create-a-team with backstory
F1 Manager 2024's Create a Team offers distinct entry points — a struggling
backmarker, a technological-breakthrough outfit, a well-funded giant — where the
**backstory affects starting resources**. Cheap replay hook.

---

# PART 5 — What not to take

- **Spreadsheet-first presentation.** MM's achievement was making management feel
  cinematic; the spreadsheets are the substrate, not the surface.
- **Season-long simulation.** Your player drives; they do not watch.
- **Team-of-drivers management.** Your player *is* the driver.
- **Free-to-play resource gating.** §1.3 is the cautionary case.

---

# PART 6 — The warning

**Do not build a manager game.** You are building a driving game with a career.

The manager layer belongs in exactly one slot: the **professional tier**, where
the player owns a shop and the race weekend acquires structure. Practice,
strategy, pit decisions and facility investment layered *on top of* driving —
never replacing it.

Motorsport Manager Online is what happens when the management layer becomes the
product and is then monetised. The depth goes first, and players say so in
public.

---

# Cross-references
- Property ladder → `07` §2.1, `11` §2.10
- Ragged edge instability → `06` §1.2, `11` §2.3
- Damage model → `04`, `11` §2.4
- Fictional brands → `12`, `13`, `15` Pattern 5
- Post-race telemetry → `07` §1.1, `11` §2.11
