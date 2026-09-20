# Genre Taxonomy: 40 Years of Racing Games

**What this is.** A feature taxonomy derived from the racing canon, rather than a
catalogue of titles. The useful question is not *which* hundred games matter but
**what got invented when, what stuck, and what turned out to be decoration.**

Analysis only; all titles proprietary.

---

# PART 1 — The eras

## 1982–89: The arcade template

| Game | Contribution |
|---|---|
| **Pole Position** (1982) | Qualifying-then-race structure; the checkpoint time-extension loop that defined arcade racing for a decade |
| **Out Run** (1986) | **Branching routes**; radio station selection. Invented "driving as mood" rather than pure competition |
| **Hard Drivin'** (1989) | First genuine physics simulation in the genre; force-feedback wheel; **the instant replay** |
| **Top Gear** (KEMCO) | Soundtrack as identity |

**Still live today:** branching routes, replay, soundtrack selection, checkpoint
extension (now mostly vestigial).

## 1990–95: 3D, and the first career systems

| Game | Contribution |
|---|---|
| **Formula One: Built to Win** (SETA, 1990) | **The overlooked ancestor of your game.** A career across four cars that the player *progressively improved by purchasing parts*, plus a minigame to raise money |
| **Super Mario Kart** (1992) | Items; rubber-banding; character asymmetry; split-screen |
| **Ridge Racer** (1993) | A drift handling model as a *brand identity* — unrealistic and beloved because it was masterable |
| **Sega Rally** (1995) | **Surface-dependent grip.** Tarmac, gravel and snow as genuinely different physics |
| **Destruction Derby** (1995) | Damage as the objective rather than a penalty |
| **NASCAR Racing** (Papyrus, 1994) | The PC simulation lineage |

## 1996–2000: The simulation golden age

| Game | Contribution |
|---|---|
| **Gran Turismo** (1997) | **The car RPG.** Licence tests as tutorial *and* gate; used-car market; buy/sell/tune economy; collection as motivation. Nearly every progression system since descends from this. |
| **Colin McRae Rally** (1998) | Co-driver pace notes — information delivery as a mechanic |
| **Grand Prix Legends** (1998) | Punishing physics plus a modding community as a longevity strategy |
| **NFS: Porsche Unleashed** (2000) | Era-based progression through a single marque — see `13-MUSTANG-DOSSIER.md` §1 |
| **Test Drive Le Mans** (1999) | Endurance racing, day/night cycle |

## 2001–07: The split, and the console peak

| Game | Contribution |
|---|---|
| **Gran Turismo 4** (2004) | The benchmark: **721 cars from 80 manufacturers, 51 tracks.** Still cited two decades on |
| **Burnout 3: Takedown** (2004) | **The Takedown.** Aggression made economically rational by paying boost for it. Crash Mode and Road Rage as separate modes |
| **NFS Underground 1 & 2** (2003–04) | Tuner-culture visual customisation; shop-driven open world |
| **NFS Most Wanted** (2005) | The Blacklist; police **heat/pursuit** escalation |
| **Project Gotham Racing** | **Kudos** — style itself as a currency |
| **Forza Motorsport** (2005) | Livery editor plus **auction house**: user-generated content with a real economy |
| **Test Drive Unlimited** (2006) | Persistent world; **buying houses to store cars** |
| **SCAR** (2004) / **Race Driver: GRID** (2008) | **Rewind / flashback.** GRID also brought team ownership and sponsors |

## 2008–15: Open world and asynchronous social

| Game | Contribution |
|---|---|
| **Burnout Paradise** (2008) | Seamless open world; no menus, no race restart |
| **Forza Horizon** (2012) | Festival framing around simulation physics |
| **Forza Motorsport 5** (2013) | **Drivatar** — AI trained on real player behaviour | **Full analysis, including a direct check against this project's own rival AI safeguards, in `60-FORZA-DEEP-ANALYSIS.md`.**
| **Real Racing 3** (2013) | **Time-Shifted Multiplayer** — racing recorded ghosts of real players |
| **DiRT Rally** (2015) | Punishing rally simulation as a deliberate market position |
| **Driveclub** (2014) | Social clubs; dynamic weather |

## 2016–26: Convergence and live service

| Game | Contribution |
|---|---|
| **Forza Horizon 4** (2018) | Seasons changing weekly for every player simultaneously |
| **GT Sport / GT7** | **Driver etiquette rating**; Scapes photo mode; café/menu-book curation as soft direction |
| **iRacing** | **iRating + Safety Rating** — speed and cleanliness scored separately |
| **Assetto Corsa Competizione** | The GT3 tyre model benchmark |
| **Wreckfest / BeamNG** | Serious damage simulation coexisting with credible handling |
| **Trackmania** | User-generated tracks with medal times — content that outlives any pipeline |

---

# PART 2 — The feature matrix

## 2.1 Handling and physics — *where games actually differentiate*
Tyre model (slip curves, load sensitivity, temperature, wear) · suspension
geometry · drivetrain with differential and clutch · aerodynamics ·
**surface-dependent grip** · damage affecting handling · assist stack (ABS,
traction control, stability, racing line)

## 2.2 Progression — *the second differentiator*
Currency and car purchase · performance parts · visual customisation ·
**licence tests as gates** · class / performance-index ratings · career tiers ·
reputation · used-car market · collection completion

## 2.3 Race types
Circuit · sprint · point-to-point · time trial · **drift scoring** · drag ·
endurance · elimination / knockout · pursuit and escape · championship season

**Pursuit and escape, the one type from this list `41` didn't build, is now fully specified in `50-ACTION-PILLAR-EXPANDED.md` Part 3.**

## 2.4 Opponents
Rubber-banding · difficulty scaling · **named rivals with technical profiles** ·
AI trained on player data · asynchronous ghosts · asymmetric team strengths

## 2.5 Forgiveness — *the most underrated category*
**Rewind / flashback** · restart · checkpoint time extension · assists ·
**post-race telemetry that names what went wrong**

## 2.6 Presentation
Replay · photo mode · livery editor · soundtrack selection · broadcast framing

## 2.7 Social and economy
Leaderboards · clubs · auction house · UGC tracks and liveries · live seasons

## 2.8 World
Open world vs menu-driven · day/night · weather · seasons · traffic

---

# PART 3 — Load-bearing vs decoration

## 3.1 The three that appear in every racing game still remembered

**1. A handling model that rewards learning.**
Not realism — *learnability*. Ridge Racer is not remotely realistic and is
beloved because its drift model could be mastered. Sega Rally's surfaces are
crude by modern standards and still feel better than most modern rally games.

> **This claim now has a physical grounding beyond game history.** `34` and
> `35` establish that the same threshold — the traction circle's "cup" region,
> where more slip stops producing more grip — is what real drivers learn to
> read by feel, and what three independent sources (Beckman's Parts 21/22/25,
> and a 2025 academic paper's oversteer criterion) converge on as the exact
> moment control is lost. A learnable handling model isn't a design trick
> layered over arbitrary physics — it's what correctly modelled physics
> *is*, presented so the player can feel the threshold coming.

**2. A progression economy where choices have consequences.**
GT's used-car lot works because buying the wrong car costs you real progress. An
economy with no wrong answers is a ratchet, not a system.

**3. Legible feedback on why you lost.**
Rally pace notes, Burnout's takedown counter, GT's ghost line. **The player must
be able to see the gap.** This is the category most indie racers neglect.

## 3.2 Frequently added, rarely load-bearing

Photo mode · livery editor without an economy behind it · weather · open world ·
licensed cars · day/night cycles.

Every one is expensive and **none of them saves a game whose handling is dull.**

## 3.3 The two most underrated features in the genre

**Rewind / flashback.** SCAR and GRID proved a single-mistake escape valve
massively widens the audience without diluting the simulation for players who
ignore it. On mobile — no force feedback, small screen, interruptible sessions —
this matters more, not less. Cheap to implement: record state, restore state.

**Surface-dependent grip.** Sega Rally's contribution, and **RVP already gives
it to you free** via `GroundSurfaceMaster` (`04-EXTRACTION-INVENTORY.md`). The
cheapest available way to make tracks feel genuinely different from one another.

---

# PART 4 — The mobile filter

**Survives well on a phone:**
Handling depth · progression economy · asynchronous ghosts · time trials · drift
scoring · rewind · telemetry · class ratings · livery editors · licence tests

**Does not:**
Real-time multiplayer · endurance sessions beyond ~15 minutes (thermal
throttling — `03-PLATFORM-NOTES.md`) · dense open worlds · dynamic weather with
wet-surface transitions · large grids at high LOD

---

# PART 5 — What this means for your game

## 5.1 The pattern across forty years
**Games are remembered for one or two features executed exceptionally, never for
coverage.** Burnout had takedowns. Sega Rally had surfaces. GT had the economy.
Trackmania had the editor. Ridge Racer had a drift model.

None of them won on feature count.

## 5.2 Pick your one thing
Three candidates from this research:

1. **Tuning depth** — nothing on mobile handles aero, differential and
   suspension properly (`07` §3.1–3.3 on the competitive landscape)
2. **The ragged-edge instability meter** — nothing does this *anywhere* (`06` §1.2)
3. **The mechanic's career** — no open-source or mobile prior art exists

**The research points at the first.** It is the mobile market gap, and your
physics stack already produces it. The other two are supporting differentiators.

## 5.3 The gap in your current spec

**Licence tests, or equivalent skill gates.**

GT's licence system is the most-copied progression device in the genre because
it teaches and gates simultaneously, and it fits mobile session lengths
perfectly. Your spec (`11-SYSTEMS-SPEC.md`) has no equivalent — the player
learns by racing, which is slower and less legible.

Consider skill challenges at the street tier that unlock the club tier: a
braking test, a line test, a car-control test. Each teaches one thing your
tuning system depends on the player understanding.

## 5.4 Two cheap wins already available to you
- **Surface-dependent grip** — RVP ships it (§3.3)
- **Rewind** — record and restore state; widens audience at low cost (§3.3)
