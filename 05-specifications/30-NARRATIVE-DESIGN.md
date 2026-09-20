# Narrative Design Specification

**The second specification document in the package.** Research is in
`29-NARRATIVE-ANALYSIS.md`; this records decisions.

## The five decisions

1. **A mentor who becomes obsolete** — and whose obsolescence is the story
2. **Inverted sabotage** — you are not the victim, you are the one who finds out
3. **Rivals you can read** by inspecting their builds
4. **A culture layer built on construction**, not collection
5. **No cutscenes, ever.** Story lives where the player already dwells

---

# PART 1 — The mentor

## 1.1 Who he is

**An old racer who cannot drive any more, and will not say why for a while.**

Not a shop owner — too transactional. Not a supplier — no stake in you. **A
racer**, because his authority must come from having done it, and his investment
must come from being unable to any more.

> **The wound is the engine of the character.** He is teaching you because he is
> out of time.

## 1.2 Where he lives

**In the garage. Voice and text. No body.**

Chumbucket is a voice off-screen. Al Unser Jr. is a floating head. Luca is a
static portrait. **None are animated characters and all of them work.**

**Production consequence:** the cheapest voice work in games. One acoustic space,
one mic setup, no environmental variation, no lip sync. **A day in a booth gets
a hundred lines.**

## 1.3 The diagnostic voice — his load-bearing function

**Your telemetry produces data. He produces meaning.**

| System output | Character output |
|---|---|
| *"Understeer on exit, sectors 2 and 4"* | *"You're pushing on the exits. That front bar's too stiff for this surface — take a turn out of it and try again."* |

**Same information. Same implementation cost. One of them is a person.**

He also reads the dyno with you, tells you what the next tier expects, and —
critically — **reacts to your builds.** Approval and disapproval are free, and
they are the entire relationship.

## 1.4 The thing that makes him a character

> **He should be wrong sometimes.**

He learned on cars from thirty years ago. **His instincts are good and his data
is old.** He will insist on a setup that worked when tyres were narrower, and
following him will cost you a tenth.

### The arc that writes itself

You learn everything from him → you begin to overrule him → eventually you are
right more often than he is.

**The game marks the moment:** the first time you ignore his advice and go
faster.

> **`49-PLAYER-CHARACTER-RPG.md` Part 2.3 gives this a mechanical
> trigger, not just a story beat**: as the player's diagnostic-skill
> use count rises, the mentor's installation commentary shortens,
> because the game increasingly lets the player spot the fault a beat
> before he names it.
>
> **His obsolescence is the story.** That is what an ascent narrative feels like
> from the inside, and **no racing game has done it** — because no racing game
> has had a protagonist who could surpass a teacher at anything but driving.
>
> **A second, quieter version of the same arc**, decided in `25` §6.2b: his
> diagnostic voice only fires when the player personally does the work. Once
> staff exist at the pro shop, paying them is a way of choosing not to have him
> in the room. He doesn't have to be wrong for the player to start needing him
> less — being busy, or being rich enough not to have to be there, does the
> same job.

---

# PART 2 — The inverted sabotage

## 2.1 The scene

You buy an engine. It is cheap. It is advertised as a specific spec.

You fit it — **using the installation sequence** (`25` Part 6).

You put the car on the dyno.

**The numbers do not match.**

## 2.2 Why this beats every version in the corpus

**The dyno is your core mechanic, and it becomes the plot device.** The
most-used screen in the game is where the story starts.

**The discovery requires competence the player has already earned.** You can only
find it if you have learned to read a power curve. **A knowledge gate wearing a
story beat** — and it retroactively validates every minute spent on the dyno.

**You are not a victim. You are the one who found out.** Every other racing game
opens with something done *to* the protagonist (`29` §2.2). **Yours opens with
the protagonist noticing.**

## 2.3 The antagonist is a parts seller, not a racer

The crucial substitution. **A man who profits from other people's ignorance** is
a far better enemy for a mechanic than a rival driver.

**You cannot out-race him. He does not drive.** You beat him by knowing more than
he does, in public.

## 2.4 The escalation

It is not one bad engine. **He has been selling underspec parts across the entire
scene.**

Half the paddock is running down on power and nobody knows, **because nobody else
can read a dyno chart.**

## 2.5 The decision the first act builds to

> **You can tell them. Or you can use it.**

Every rival you beat in the meantime, you beat partly because their car is
quietly sick. **Real moral weight, available only to a protagonist who is the one
person capable of seeing it.**

### Both branches resolve properly

**Tell them** → you become **the mechanic the scene trusts.** That is your
reputation currency, it makes your builds worth more in the resale economy
(`25` §7b), and it is a better endgame than *fastest driver*.

**Keep quiet** → you climb faster on other people's broken engines. **The game
should let you, and should remember.**

---

# PART 3 — Rivals: six archetypes, persistent across eras

**Decision (supersedes the earlier six flat profiles):** rivals persist across
the hero car's sixty years. **A rival you beat in 1971 and lose to in 1994 is a
relationship. Two separate rivals are content.**

It also solves a problem the hero car creates: **sixty years is a long time to
spend with a car and nobody else.** Persistence gives the timeline witnesses.

## 3.1 The verb that makes rivals legible

> **You can walk around a rival's car at a meet, open the bonnet, and read the
> spec.**

That is the garage inspection system (`25` §4.5b) pointed at somebody else's
car. It turns the protagonist's actual skill — **looking at a car and knowing
what it does** — into the intelligence-gathering mechanic.

**No racing game has this.** It is native to the premise and costs a camera
position already built.

It also feeds the parts economy: **you read their build, then race them for the
piece you want** (`32` §3.1).

**This whole skill is now a real, growing system, not fixed from the
start** — `49-PLAYER-CHARACTER-RPG.md` Part 2 turns diagnostic reading
into something that deepens with use, and ties it directly into the
mentor's obsolescence arc below.

## 3.2 The six archetypes

**Full personality and car-lineage development — names, AI-parameter
tuning per rival, and derived engine architecture — is in
`45-RIVAL-DEVELOPMENT.md`.**

**All 27 per-generation derivation worksheets are complete** — `docs/derivation/` (one file per rival: reyes, kade, vogel, duquesne, osei, marsh). Every worksheet follows `12`'s method in full, grounded in real automotive class conventions rather than any single named product.


Each is **a person with a car lineage**, not a build. The lineage is a class
archetype that evolves across the eras exactly as the hero car does, with its own
derivation worksheets per generation (`12`).

| # | Rival | Car lineage | Philosophy | Strong | Vulnerable |
|---|---|---|---|---|---|
| **1** | **The aero one** | European rear-engine GT — homologation specials, escalating wings | Downforce solves everything | Tight technical | Long straights |
| **2** | **The turbo one** | Japanese inline-six — boost, tall gearing, big single | Power is the answer | High-speed circuits | Slow corners, a second of lag |
| **3** | **The stiff one** | German touring saloon — chassis-first, track-spec | The car should never move | Smooth tarmac | Bumps, kerbs, street circuits |
| **4** | **The locked one** | American big-block — torque, brute force, welded diff | Traction beats finesse | Dry corner exit | Wet, anything needing rotation |
| **5** | **The light one** | British minimalist — stripped, no cooling, no comfort | Take things off | Everything, briefly | Endurance, heat, fuel |
| **6** | **The Constant** | **1965–mid-70s: lightweight rear-drive compact. Late-70s onward: front-drive hot hatch** (the category didn't exist before then — fixed in `43-FIRST-PLAYABLE-SPECS.md` §Item 6 after being caught there) — modest, unassuming, perfectly sorted throughout | **Trail braking** (`34` Part 1d) | **Everywhere** | **Nothing** |

> **The Constant driving the least impressive car on the grid is the whole
> point.** He beats you in a hatchback in 1978 and he beats you in a hatchback in
> 2011.
>
> ## And his advantage is physically real
>
> **Trail braking** (`34` Part 1d, Beckman Part 23). He carries braking into the
> corner, trailing off while winding in steering, which lets him **delay braking
> in the preceding straight.**
>
> Beckman quantifies it: **one car length per significant corner.** *"You may
> have perfect threshold braking. You may have perfect turn-in, apex and
> track-out points... corner after corner, lap after lap, he will gobble you
> up."*
>
> **It is invisible until someone names it** — which makes it the perfect late
> lesson from the mentor (§1.3), and one of the few things he is still better at
> than you.
>
> **Implementation:** if the tyre model does combination grip correctly
> (`34` Part 1d, Part 25), **trail braking emerges on its own.** You don't script
> it; you avoid preventing it.

## 3.3 Presence across the eras

**Not everyone appears everywhere. Entry and exit are characterisation.**

| | '65 | 70s | 80s | 90s | 00s | 10s | '22 |
|---|---|---|---|---|---|---|---|
| **1 · Aero** | — | ● | ● | ● | ● | ● | — |
| **2 · Turbo** | — | — | ● | ● | ● | — | — |
| **3 · Stiff** | — | — | ● | ● | ● | ● | ● |
| **4 · Locked** | ● | ● | ● | — | — | — | — |
| **5 · Light** | ● | ● | — | — | ● | ● | — |
| **6 · Constant** | ● | ● | ● | ● | ● | ● | ● |

**Read the shape of that table.**

- **The locked-diff man is a 60s–70s figure** who does not survive the arrival of
  proper differentials and wet-weather tyres
- **The turbo man is an 80s–2000s phenomenon** who vanishes when the era of huge
  boost ends
- **The lightweight disappears in the 80s and returns in the 2000s**, because
  that philosophy went out of fashion and came back
- **The Constant is in every column.** Sixty years, seven cars, same man, same
  modest philosophy

## 3.4 The six passers-through

**One per era, with 2022 left clear for the finale.** Single car, single
appearance. They carry variety while the six carry weight, so they can be
shallower.

| Era | Who | What they are for |
|---|---|---|
| **1965** | **The holdover** — pre-war machinery, refuses to modernise | Shows you the era you *just missed* |
| **Mid-70s** | **The emissions casualty** — fast car, strangled by regulation | The era's defining frustration, driving |
| **Late 80s** | **The chancer** — Group B refugee, more boost than sense | Terrifying, brilliant, gone by 1990 |
| **Mid-90s** | **The import kid** — tuner scene, all mods, no setup | The counterpoint to your engineering |
| **Early 2000s** | **The buyer** — money, no talent, the best car on the grid | Beatable, and satisfying |
| **Mid-2010s** | **The data driver** — young, laptop, no feel | **What comes after you** |

> The mid-2010s passer-through is **the mentor's fear made real** (`30` §1.4):
> someone who wins with software and cannot hear a misfire.

## 3.5 The persistence rules

### Rule 1 — Rivals age; the player stays vague

A rival who was twenty-four in 1968 is **seventy-eight in 2022.** That arithmetic
is the engine of the whole system.

### Rule 2 — They exit in character

- **The Constant** is the only one still there at the end
- **The locked-diff man stops driving** and turns up behind a parts counter — he
  sells you things now
- **The turbo man hands the car to someone younger**, who drives it worse
- **The aero man becomes an engineer**, and his cars beat you without him in them

### Rule 3 — They remember specifics, not a score

- You beat him for a part in 1989 — **he is still running the replacement in
  1996, and it is the wrong part**
- You told the scene about the bad engines (`30` §2.5); he was running one. **He
  owes you, or he resents you.**
- You raced him dirty in the street tier. **Twenty years later, at the
  professional tier where contact is penalised, he is the one who remembers you
  as someone who does that.**

> **Rule 3 gives the Safety Rating arc a face** (`20` §11, fully specified in `48-RPG-SYSTEMS-SPEC.md` Part 3). The unlearning is not
> only mechanical — **somebody was there for the version of you that had not
> unlearned it yet.**

### Rule 4 — The Constant must become beatable

**Sixty years of losing to one man is a bad time.** He should be beaten on merit
in the mid-game — and then the question becomes what he does next.

> **The ending: by 2022 he is the one who cannot drive any more, and he is
> watching you.**
>
> That closes the loop the mentor opened (`30` §1.4).

**And it doesn't have to end even there.** `41-RACE-FORMATS-GHOSTS-
OBJECTIVES.md` §2.4 specifies time-shifted ghosts as the mechanical
delivery system for this exact persistence: the Constant's recorded best
runs stay raceable forever, on whatever events he was once fastest at —
the player can still chase his 1978 lap in 2022, as a ghost, even though
the narrative Constant of 2022 can't drive any more.

## 3.6 Production cost

**The mitigation is the same one that makes the hero car work.**

- **Each lineage is one base model plus era variants**, not N separate cars —
  the shared-topology logic of `13` §1
- **Rivals never need hero-car fidelity.** Seen at LOD1 in a grid, not inspected
  at arm's length. `09` §2 gives 15–20k tris for that.
- **Except at meets**, where rival inspection happens (§3.1) — so **one
  hero-detail variant per lineage**, not per era
- **The passers-through are single cars with no variants at all**

**Realistically ~12–14 rival models plus trim variants**, against seven
hero-car generations.

> **Each lineage needs its own derivation worksheets per generation** (`12`,
> `32` §6.1). **Six lineages is six parallel derivation tracks** — worth knowing
> before modelling starts.

## 3.7 The timeline is shared

**The rival timeline and the hero car timeline are the same timeline.** Every era
in `32` §7.1 is an era in the presence table above, and a rival's car generation
draws from the same period parts library.

> Not just tidiness: **when you jump the hero car forward a decade, the entire
> field changes with you.** The people who were fast are older, the machinery is
> different, and the man in the hatchback is still there.

---

# PART 3b — The act structure

**`33-ACT-STRUCTURE.md` specifies the full career arc**, written to fix the
thinnest stretch: 1987–96, the club tier, where most racing careers sag.

The diagnosis that mattered: **the sag was not a content problem. Act two had no
loop of its own** — it was act one with better cars.

| Act | Loop |
|---|---|
| **One** | Build → race → climb |
| **Two** | **Drive other people's cars while your own sits waiting** |
| **Three** | **Everything competes; the property ladder is how you win the week back** |

Act two is nine years as a **hired gun** — shakedowns, evaluations, deliveries,
sorting jobs, ringer drives — with **the dyno closed on every job car.** That is
the only way to prove driving skill separate from building skill, and it is what
makes the professional tier plausible.

The 1987 choice (§2.5) shapes **which jobs appear, what parts cost, which events
accept you, and who races you clean** — with no meter on screen.

**The act break is 1995: somebody walks in and asks you to build something.**
Nine years of driving other people's cars, and the reward is a customer.

Act three adds the **three-currency week** — job, commission, or your own car —
and the property ladder becomes the way you buy your way out of choosing.

---

# PART 4 — The culture layer

## 4.1 Luca's structure, translated

GT7's Café gives Menu Books: *collect these three cars and I will tell you why
they matter.* **The reward for completion is knowledge, not a stat.**

**Your mechanic's version is not collection. It is construction:**

> *"Build me a car that could have run Group B."*
>
> *"Build one the way they did before aero — no wing, all mechanical grip."*
>
> *"Build the cheapest thing you can that'll run a twelve."*

## 4.2 Why this is better than collecting

**It is the named-build-recipe system (`05` §1.3, `20` §17) wearing a culture
layer.** You already have build recipes specified. This gives completing one a
*reason*: the mentor tells you why that specification existed in the real world,
what problem it solved, who it beat, and why it stopped being the answer.

> **The encyclopedia is delivered by doing engineering, not by shopping.**

Porsche Unleashed shipped historical videos and text (`19` §1.5). GT7 ships a
café host. **Yours ships a man who sets a problem and then tells the story behind
it once you have solved it** — the only version of an encyclopedia a player earns
rather than reads.

**And it is the cheapest content in the package:** text and a voice line,
attached to a system you are building anyway.

---

# PART 5 — Breaking the inverse law

**No racing game has combined deep simulation with an authored story**
(`29` §2.6). This part is why, and what to do about it.

## 5.1 Why the law holds — two real reasons, two false ones

**Not the real ones:**
- *Thin audience overlap* — Ford v Ferrari took $225M
- *Sim players dislike narrative* — Motorsport Manager's community **defends its
  fictional lore** against real-world mods (`16` Part 2)

**The real ones:**
- **Budget competition.** Story money and physics money come from the same pot.
  Sim studios choose physics, correctly.
- **Structural conflict.** A story wants authored beats; a simulation wants
  player freedom. **Sim players resent anything standing between them and the
  car.**

## 5.2 The answer

> **The inverse law holds because story has always been delivered as an
> interruption.**
>
> Cutscenes. Unskippable dialogue. A gate between the player and the next
> session.
>
> **Deliver it as ambient texture in the places the player already dwells, and
> the conflict disappears entirely.**

## 5.3 The rule

**Nothing narrative ever stands between the player and the car.**

**Zero cutscenes. Zero cinematics.** Every story beat happens somewhere the
player was going anyway:

| Location | What happens there |
|---|---|
| **The garage** (`25` §2) | The mentor talks while you work. You can ignore him. |
| **The dyno** (`25` Part 5) | The bad engine is found on a chart you were reading anyway |
| **Post-race telemetry** (`20` §5) | He names the fault — and sometimes gets it wrong |
| **The parts wall** (`25` §4.2) | Where you notice the seller's prices are too good |
| **A meet** | Where you read a rival's build (§3.2) |
| **The desk** (`25` §4.5) | Contracts, messages, classifieds |

> **Every one of those is a screen already specified in `25`.** The narrative
> costs no new contexts, no new scenes, and **no time away from driving.**

## 5.4 The precedent

**Ford v Ferrari is an engineering procedural.** Its story happens in workshops
and at test sessions. The racing is the payoff, not the substance. **Brake ducts
and gear ratios carry the plot** (`07` §1.1).

Proof the material works — and proof that the story of a car being built can be
told entirely in the places where cars get built.

> **You are not breaking the inverse law by adding story to a simulation. You are
> breaking it by putting the story where the simulation already lives.**

---

# Cross-references
- The research behind these decisions → `29-NARRATIVE-ANALYSIS.md`
- Garage stations, dyno, desk → `25`
- Named build recipes → `05` §1.3, `20` §17
- Post-race telemetry → `07` §1.1, `20` §5
- The street→professional transition risk → `19` §2.8, §2.12
- Resale economy and reputation → `25` §7b, `28` Part 3
- Voice and SFX budget → `10`
