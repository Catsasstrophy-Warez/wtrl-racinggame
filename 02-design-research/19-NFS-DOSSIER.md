# The Need for Speed Dossier

**Why this is the largest reference document in the package.** EA rebooted this
series every few years for thirty-two years, which makes it a controlled
experiment on racing-game design. Each entry tested a different idea, and both
the successes and the documented failures are usable.

**One entry — Porsche Unleashed (2000) — is the closest existing game to what
you are building.** It gets Part 1 to itself.

Analysis only; all titles proprietary. See `12-DERIVATION-METHOD.md`.

---

# PART 1 — Porsche Unleashed (2000)

Fifth in the series. Titled *Porsche 2000* across most of Europe, Asia, Brazil
and Australia; *Need for Speed: Porsche* in Germany and much of Latin America.
Never released in Japan.

## 1.1 The natural experiment that validates your content model

`13-MUSTANG-DOSSIER.md` §1 argued for one nameplate across generations, using
Ford Mustang: The Legend Lives (2005) as the precedent — and noted it failed
because arcade physics made all forty cars handle identically.

**Porsche Unleashed is the same content model with a real physics engine.**

| | Mustang (2005) | Porsche Unleashed (2000) |
|---|---|---|
| Content | 40 variants, one nameplate | **80 models**, 1948–2000, one marque |
| Physics | Arcade — *"pivots on a central fulcrum"* | **Four-point model**, all four wheels |
| Result | Forty skins | *"You can feel the difference between the vehicles"* |
| Verdict | A licensing exercise | *"The best Need for Speed to date"* |

Same content strategy. Opposite physics. Opposite outcome.

> **This closes the case.** The single-marque model works if and only if the
> cars genuinely differ, and TORSION + RVP is exactly what makes them differ.
> Every hour you spend on the tyre model is an hour spent making this content
> strategy viable.

## 1.2 Evolution mode — the career

Start with enough money for one 356 and race chronologically to the 2000 996
Turbo. Cars divided into three eras — **Classic, Golden, Modern** — and within
those into **classes 3 (lowest) to 1 (highest)**, plus a separate Race class.

**Three mechanics worth taking:**

**Time advances as you win.** Tournament victories move the calendar forward and
new cars appear *because they have been released*, not because a gate opened.
Content pacing with an in-fiction justification — far better than XP thresholds.

**A used-car market.** Buy, repair, sell. Tournaments carry entry fees and vary
in difficulty, track count and course type. Economic decisions before the grid.

**Selling a car re-locks it.** A sold car disappears from Quick Race until you
own one again. Ownership means something rather than being a permanent unlock
flag. Pairs with the ownership-ledger schema in `code/CrazyCar-MIT/`.

**Parts are authentic and era-appropriate**, drawn from the real Porsche catalog
plus aftermarket, unlocking as you progress. A 1960s car takes 1960s parts —
Car Wars' class-bracket constraint (`06` §2.1) expressed through history rather
than through a rule.

## 1.3 Factory Driver mode — your premise, already built

**The player is an official Porsche test driver.** Not a racer — an employee.

Challenges are timed slaloms, acrobatic manoeuvres, obstacle courses, deliveries
and timed destination runs, progressing toward the rank of **Ace Test Driver**.
Rewards are cosmetically distinct Porsches that cannot be bought. Some sprint
events include police cars that actively impede the player.

The contemporary GameFAQs guide named its purpose exactly: **Factory Driver adds
skill sets beyond racing.**

> ## This closes the gap flagged twice already
>
> `17` §5.3 and `18` §5.2 both identified the missing skill-gate layer. Al Unser
> Jr. solved it through vehicle disciplines; **Porsche Unleashed solves it
> through employment.**
>
> Your protagonist is a mechanic. A tier where he does **paid technical driving**
> — shakedown runs, delivery jobs, evaluation laps for a shop or manufacturer —
> is native to that premise. It teaches car control without a tutorial, it pays
> money, and it is how a mechanic realistically earns seat time before anyone
> will hire him to race.
>
> It also gives you a reason for events that are not races, which your street
> tier needs.

## 1.4 The two documented failures — more useful than the successes

**"Not enough difference in the parts."** The upgrade catalogue was deep and
authentic, and the parts did not change how the car felt enough to matter.

> **This is the exact failure your tuning system risks.** Seven subsystems are
> worthless if adjusting the differential produces no felt difference. Your
> physics engine should prevent it — but verify on a device, do not assume.

**"Money too easy to come by."** The economy collapsed once income outran
spending. **Same failure as Mad Max's 15–20k scrap surplus** (`05` §1.5), from a
completely different direction. Two independent confirmations that this is the
default failure mode of racing economies.

Also criticised: a limited number of tracks, even in a game otherwise beloved.

## 1.5 Three more things worth stealing

**The encyclopedia layer.** The game shipped historical videos, photographs and
written information about the cars. For a game built on car culture, **reverence
for the subject is content** — and it is text and images, the cheapest content
you can make.

**Interior customisation.** Paint covered exterior *and* interior colour, plus
trim packages of racing stripes and numbers.

**The car as an inspectable object.** The PC version had a fully 3D-modelled
cockpit and let players interact with **doors, the convertible roof, the trunk
and the engine lids.** In 2000. That is the garage-as-shrine principle from
`08` §2.1 — and for a mechanic's game, opening the engine bay is thematically
load-bearing.

---

# PART 2 — The rest of the series, game by game

## 2.1 The Need for Speed (1994)

Shipped with a **Road & Track licensing partnership**: real journalist
commentary, spec sheets, interior photography and video segments per car. The
encyclopedia was a feature, not a bonus. See §1.5.

## 2.2 NFS III: Hot Pursuit (1998)

Introduced police pursuit. Everything Most Wanted later perfected starts here.

## 2.3 High Stakes / Road Challenge (1999) — the economic blueprint

**First NFS with both a currency career and vehicle damage.** Developed by EA
Canada and EA Seattle.

**Damage reports four systems separately** — Engine, Steering, Body, Suspension
— with a red severity barometer, affecting appearance *and* performance.

**It cannot be repaired mid-race.** Repairs happen in the garage and cost
credits. The PlayStation version auto-repaired after each race and deducted the
bill automatically.

GameSpot named the resulting tension precisely:

> Do you pay the $8,000 to upgrade your car's suspension and engine, or do you
> save the money and hope you can win enough in the next race to buy an all-new
> ride?

**Ten tiers**, each circuit carrying an entry fee with placement-scaled prizes.
Three circuit types:

| Type | Rule |
|---|---|
| **Standard** | Most points across three or more tracks |
| **Knockout** | Last finisher eliminated each race |
| **High Stakes** | **Pink slips** — your entry fee *is* your car |

On PlayStation, with two memory cards, **the loser's car was deleted from their
card immediately** and added to the winner's roster.

Upgrades in three groups: suspension/tires, engine/brakes, aerodynamics.
Adjustable weather, traffic and time of day.

One detail worth keeping: in Test Drive mode, crashing into traffic could leave
**barriers at the accident site on subsequent laps.** Persistent consequence
within a session.

> **You already own every component of this loop.** RVP's `VehicleDamage` tracks
> per-area damage and exposes `Repair()`. Attach a bill and you have solved the
> currency-sink problem from `05` §1.5 in the most natural way available —
> damage → repair cost → economic pressure → drive more carefully.

## 2.4 Underground (2003)

Radically rebuilt the series: **removed exotics, scenic environments and
police**; added tuners, cities and aftermarket customisation.

**Underground Mode** is a career of **over 100 events**. A **five-star
reputation system ranks the car's style**, and new parts unlock through it.

### Outruns — the mechanic worth stealing

In free roam the player challenges specific opponent cars, **identified by
bright tail lights** — the same visual signature the player's own car has under
NOS. **The goal is to put 300 metres between you and them.** Any route, any
tactics. Each stage permits a limited number, and once the required wins are
banked the outrun cars stop appearing.

> A race with **no track, no checkpoints and no lap counting** — pure
> pursuit-and-escape geometry. Extremely cheap to implement, and it works on a
> phone. Strong candidate for your street tier.

**Special Events** are sprints to reach a photographer within a time limit,
rewarding a magazine cover.

## 2.5 Underground 2 (2004) — deepest customisation in the series

**Bayview**, five districts with distinct aesthetics. **Four shop types**: Body
Shop, Car Specialties Shop, Graphics Shop, Performance Shop. GPS navigation.
Hidden money rewards and unmarked events in the world.

**New: Fine-tuning and a Dyno Run** for adjusting performance — a 2004
precedent for exposing tuning depth through a **diegetic tool** rather than a
slider menu. Directly applicable to your seven-subsystem system.

### The magazine cover loop

Reach a star-rating threshold → **Rachel phones with a shoot location** → **get
there before the photographer leaves** → enter **photo mode**, where you drive,
show off interior customisation, and work camera angles to compose the cover.
DVD covers unlock across ten visual star tiers. **Sponsor contracts** pay cash.

### Unique parts from Outruns — and how they got it wrong

Per-stage unlocks, **permanently missable** if you advance:

| Stage | Wins | Unique part |
|---|---|---|
| 2 | 4 | Hood |
| 3 | 3 / 6 | Engine, transmission or tyres / rims |
| 4 | 4 / 6 / 9 | Spoilers / vinyls / ECU, turbo or brakes |
| 5 | 6 / 11 | NOS, weight or suspension / widebody kit |

### The four documented failures

1. **Free roam killed the pacing.** Driving to every event was widely criticised.
2. **Stages 4 and 5 are padding** — 30 world wins plus 7 URL wins, then another
   35 and 9.
3. **The star-rating gate forced customisation players did not want**, and the
   late-game visual parts made cars look ridiculous. Later games dropped
   mandatory star ratings entirely.
4. **The uniques were too hidden to find and permanently lost** on stage advance.

> **All four are lethal for a mobile game with interruptible sessions.** Gate on
> skill, never on decoration. Make nothing permanently missable. Do not make
> players travel to content.

## 2.6 Most Wanted (2005)

**The Blacklist**: fifteen named rivals, each with a signature car and
personality, climbed in order. Heat levels, pursuit breakers, and the series'
best police AI. Still the most-played entry by community activity.

## 2.7 Carbon (2006) — the most underrated

Direct story sequel to Most Wanted. Sold 8M+. Four areas broken into sub-zones
of drift, street and duel racing — 80 tracks total.

**Canyon Duel.** Touge-inspired 1v1: **the closer you are to the leader, the
more points you accrue. Overtake and hold the lead for ten seconds and you win
outright.** Cliffs on one side.

> Proximity-based scoring rather than position-based, producing continuous
> tension instead of a binary outcome. **It also fits a phone perfectly** — one
> opponent, no grid to render, no field to track.

**Crew roles.** Recruit members with specific skills — **blockers, scouts,
drafters.** A scout finds hidden shortcuts; a blocker creates a distraction.
Teammates without simulating a team. Fits your pro-shop tier.

**Territory.** Winning earns districts; losing returns them to the rival crew.
To take a crew's turf you must beat their boss. **Progress that can be lost** is
rare, and it makes every race matter.

**Classes: Tuner, Muscle, Exotic**, each with distinct handling — classification
by character rather than by performance index.

**Autosculpt.** Free morphing of body panels rather than preset selection.
Ambitious; probably out of scope, but it existed in 2006.

## 2.8 ProStreet (2007) — the cautionary transition

Abandoned police and open-world street racing for **sanctioned closed-circuit
competition with damage and dyno tuning.** Regarded as the hardest NFS precisely
because it removed the arcade simplifications.

Reception was mixed enough that EA moved the franchise to Criterion afterward.

> **The street-racing audience did not follow the game to the racetrack.**
>
> Your career arc walks exactly this path. Whatever happens at your professional
> tier must **earn** the transition rather than assume the player wants it —
> which is a strong argument for Heat's approach (§2.12), where both modes
> coexist rather than one replacing the other.

## 2.9 Shift (2009) — the best progression system in the series

### The driver profile

Every action is classified as **Precision** or **Aggression**:

| Precision | Aggression |
|---|---|
| Mastering corners | Dirty overtaking |
| Staying on the racing line | Spinning or tapping out opponents |
| Clean overtaking | Blocking |
| Speed threshold | Sliding through corners |

**50 driver levels, 500,000 XP to max.** The profile drifts toward one pole
based on how the player actually drives, and it **creates rivalries, triggers
challenges, and unlocks vehicles and customisation options.**

### The star system — the key structural idea

Stars come from finishing position **and** from other objectives: holding the
racing line, mastering corners, accumulating profile points.

> **You do not have to win to advance.** Weak at drifting and only earned one
> star in the drift event? Make up the deficit with a strong time trial
> elsewhere. 280 stars unlock the finale.

For a mobile game this is enormously valuable — it keeps a player progressing
through a session where they never placed first.

### Supporting structure
- **27 badges** across Track, Race, Career and Online, levelable Bronze → Epic
- **Invitational events unlock based on style**, offering cars not yet driven
- **Driver Duels** — podium every event in a competition to challenge its rival
  1v1 for cash and badges
- Tiers 1–4 (everyday / sports / high-performance / supercars), plus Tier 5 GT
  race cars in Quick Race

### The documented flaw — a direct warning

A reviewer who constantly bumped, cut off and spun opponents **still trended
toward Precision**, because **racing-line points outweighed everything else.**
The two axes were not balanced against each other.

> **Direct warning for your dual rating system** (`07` §2.3). If clean-driving
> points accumulate faster than aggression penalties deduct, your Safety Rating
> becomes noise. Weight the axes against each other and **test with a
> deliberately dirty driver.**

The iOS version used accelerometer steering and was praised for narrowing scope
to single-player rather than attempting everything — a reasonable model for a
first release.

## 2.10 Hot Pursuit (2010) — Autolog

Criterion's social platform: progress tracking, leaderboards, screenshot
sharing, and friend recommendations. EA's own Shift 2 marketing called it
**rivalry-generating**. Its critical success made Criterion lead developer of
the franchise.

> **Pair with Real Racing 3's Time-Shifted Multiplayer** (`07` §3.5) for a
> complete social layer with no netcode:
> - **TSM** supplies the ghost data — recorded traces of real players
> - **Autolog** supplies the *reason* — "your rival beat your time here",
>   surfaced at the moment the player would care
>
> The ghosts are the content; the recommendation engine makes them rivals.

## 2.11 Shift 2 (2011) and Rivals (2013)

**Shift 2:** helmet cam, night racing, and **authentic degradation of tracks and
cars** across a session — track rubbering-in as a visible mechanic.

**Rivals:** **AllDrive**, blending single-player and multiplayer so other humans
drop in and out without loading screens, as cop or racer. Also a bank/risk
system where earnings accumulate while driving and are lost if you are busted
before banking them.

## 2.12 Heat (2019) — your career arc as a daily cycle

**Day: sanctioned events earn money. Night: illicit street racing earns REP, and
engaging with police builds heat.**

Two currencies, two risk profiles, one map. Widely described as the series' most
genuinely innovative recent idea.

> **That is your street-versus-professional split, compressed into a daily
> loop.** Money and reputation as separate currencies with different sources is
> the mechanism your premise needs — and unlike ProStreet (§2.8), neither mode
> replaces the other.

**Also worth stealing:** each event displays a **recommended performance level
and optimal handling profile** before entry, plus an Autolog recommendation from
a friend or rival, with **vehicle swapping at the entry screen.**

> That is the UI pattern that makes deep tuning legible: the game states what
> the event wants, and the player decides whether their build matches. Solves
> the "seven subsystems is overwhelming" problem without reducing the depth.

Criticisms: an identity crisis between its two halves, overly aggressive police,
and a real grind to unlock top-tier parts.

## 2.13 Payback (2017) — the clearest failure

Tuning upgrades delivered as randomised **speedcards**. Universally disliked.

> **Never put chance between the player and a tuning decision.** It destroys the
> thing that makes tuning satisfying — the causal link between a choice and a
> result.

---

# PART 3 — The full extraction, ranked

| # | Idea | Source | Cross-ref |
|---|---|---|---|
| 1 | **Repair costs as economic pressure** — four damage systems, no mid-race repair | High Stakes | `11` §2.4, `05` §1.5 |
| 2 | **Stars from objectives, not just position** — advance without winning | Shift | `11` §2.9 |
| 3 | **Day/night dual currency** — money vs reputation | Heat | `07` §2.3 |
| 4 | **Autolog over ghost data** — recommendations turn laps into rivalries | Hot Pursuit 2010 | `07` §3.5 |
| 5 | **Factory Driver employment tier** — paid technical driving | Porsche Unleashed | `17` §5.3 |
| 6 | **Outruns** — put 300m on one opponent, any route, no track | Underground | — |
| 7 | **Canyon Duel** — proximity scoring, 10-second lead wins | Carbon | `06` §1.2 |
| 8 | **Precision/Aggression profile** — but weight the axes | Shift | `07` §2.3 |
| 9 | **Dyno Run as a diegetic tuning tool** | Underground 2 | `11` §2.2 |
| 10 | **Pre-event recommended spec and handling profile** | Heat | `08` §6 |
| 11 | **Time advances as you win** — cars appear because they released | Porsche Unleashed | `13` §1 |
| 12 | **Era-locked authentic parts** | Porsche Unleashed | `06` §2.1 |
| 13 | **Photo mode as a reward loop** — time-limited cover shoots | Underground 2 | — |
| 14 | **Driver Duels** — podium a series to unlock a 1v1 with its rival | Shift | — |
| 15 | **Blacklist** — named rivals with signature cars, climbed in order | Most Wanted | `16` §4.2 |
| 16 | **Crew roles** — blocker, scout, drafter | Carbon | `07` §2.2 |
| 17 | **Knockout races** — last finisher eliminated each round | High Stakes | — |
| 18 | **Pink slips** — optional wager, your car as entry fee | High Stakes | — |
| 19 | **Territory** — progress that can be lost | Carbon | — |
| 20 | **Selling a car re-locks it** | Porsche Unleashed | CrazyCar schema |
| 21 | **Car encyclopedia** — spec sheets and history as content | The Need for Speed | — |
| 22 | **Interior colour and trim packages** | Porsche Unleashed | `08` §2.2 |
| 23 | **Interactive doors, bonnet, boot in the garage** | Porsche Unleashed | `08` §2.1 |

---

# PART 4 — The failures to avoid

Six, all documented at the time of release.

1. **Parts that do not change how the car feels** (Porsche Unleashed). Deep and
   authentic is worthless without felt difference. **Verify on a device.**
2. **Money that outruns spending** (Porsche Unleashed, and Mad Max
   independently). Design the sink first.
3. **Mandatory visual customisation gates** (UG2). Gate on skill, never on
   decoration.
4. **Permanently missable content** (UG2 uniques). Fatal in interruptible
   sessions.
5. **Driving to every event** (UG2). Free roam killed the pacing.
6. **Unbalanced rating axes** (Shift). Precision points drowned out aggression
   penalties. Test with a deliberately dirty driver.
7. **Randomised upgrades** (Payback). Never put chance between a tuning decision
   and its result.

And one structural warning: **ProStreet proved the street-racing audience does
not automatically follow you to the racetrack.** Earn the transition.
