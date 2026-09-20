# Genre Reference: The Road Warrior Lineage

**Scope note.** All titles here are proprietary. This document analyses
mechanics and systems, which are not copyrightable. No extracted content.
See `05-DESIGN-REFERENCE.md` for the legal boundaries section, which applies
equally here.

---

## Framing: the genre tension you have to resolve

The Road Warrior lineage is a **combat** genre. You are building a **physics
racer** with action, simulation, and RPG layers. These pull against each other:

- A simulation wants **precision and predictable consequences**
- Combat wants **chaos and readable spectacle**

Games that attempt both almost always pick one to serve properly and let the
other ride along. Decide which before you build the action layer.

**The question every game in this lineage answers:** what does the player do
with the throttle when a rival is alongside?

| Game | Answer |
|---|---|
| Mad Max (2015) | Ram them |
| Burnout | Ram them — and here is boost as a reward |
| Gaslands | Going fast is already dangerous; proximity compounds it |
| Gran Turismo | Nothing. Contact is a penalty. |

**Your premise spans street racing and sanctioned circuit racing, so the answer
should change across the career.** Street racing rewards contact; professional
racing penalises it. That gives your progression a mechanical arc rather than
just faster cars — the player has to *unlearn* something to move up. That is a
genuinely strong structure and it is worth building deliberately.

---

# PART 1 — Gaslands (2017; Refuelled 2019)

Mike Hutchinson / Osprey Games. Tabletop, played with Hot Wheels cars. Winner of
both the Judges' and People's Choice awards for Best New Miniatures Rules, UK
Games Expo 2018.

**The best-designed system in this genre, and almost nothing in video games has
copied it.** Highest-value item in this document.

## 1.1 Gear system — speed as risk

Every vehicle moves and attacks based on how fast it is going. **Faster means
more actions per turn.** Speed can literally kill you.

That single inversion — where going faster is simultaneously the reward and the
threat — is the design spine of the whole game. Contrast with most racing games
where speed is purely positive and risk lives only in the track geometry.

## 1.2 Hazard tokens — steal this outright

Shifting gears, sliding, spinning, and collisions all accumulate **hazard
tokens**. Six tokens at the end of any activation and you **Wipeout**: dropped
to Gear 1, possibly flipped, and the player to your left gets to spin your
vehicle to face any direction they choose.

**Skid dice** are the management tool. The number you roll is set by the
vehicle's **handling rating**.

| D6 | Result |
|---|---|
| 1 | **Hazard** — gain 1 hazard token |
| 2 | **Spin** — pivot up to 90° either direction, +1 token |
| 3 | **Slide** — displaced sideways per the template's slide exit point, +1 token |
| 4–6 | **Shift** — cancel another die, change gear up or down, *or remove a hazard token* |

### Why this is the key idea

**Handling is not a flat stat. It is how many chances you get to manage
accumulating instability.** A twitchy car doesn't merely corner worse — it hands
you fewer tools to recover from the trouble it creates.

### Application to your game — no combat required

Replace hazard tokens with an accumulating **"ragged edge" state**:
- Driving at the limit builds instability
- You shed it by backing off
- Cross the threshold and you lose the car

This is real driving. It is what separates a fast lap from a fast *stint*. And
it gives you a **visible, teachable representation of something sims normally
leave entirely implicit** — which matters enormously on mobile, where you have
no force feedback and limited seat-of-the-pants feel.

It also spans your whole career arc, because it is about instability rather than
violence. It works identically whether the risk comes from a rival's bumper in
a street race or from your own entry speed on a circuit.

## 1.3 Template commitment

Once a player picks up a movement template, they must use it. No pre-measuring.
Reviewers describe the resulting moments precisely: squinting at a gap, thinking
*I think I can squeeze past*, and finding out you cannot.

**Committed inputs with uncertain outcomes.** The analogue in your game is
committing to a line before you can see the apex — and it argues for a camera
and corner design that sometimes hides the exit.

## 1.4 Sponsors

Each player has a sponsor granting unique abilities and encouraging
specialisation. A faction-perk layer that pushes builds *apart* rather than
letting them converge on a single optimum.

Maps to team, manufacturer, or workshop affiliations in a career mode. Combine
with the Archangel-style build recipes from `05-DESIGN-REFERENCE.md` §1.3.

## 1.5 Collisions

Collisions are bad for the lighter vehicle and worse for everyone in a head-on.
Simple, physically honest, and it makes vehicle mass a real strategic axis
rather than just a handling penalty.

## 1.6 The documented flaw — learn from it

Build points were costed around **weapon effectiveness rather than physical
weight**. The result is absurdities: motorbikes can mount wrecking balls but
cannot fit a flamethrower.

**Lesson for you specifically:** when cost is decoupled from physical
plausibility, the fiction breaks and players notice. You have real physics
underneath — let **weight and packaging** be genuine constraints, not just
price tags. See Car Wars below for how to do that properly.

## 1.7 Rule of Carnage

Rules ambiguities are resolved toward whichever outcome causes the most carnage
for both sides. Not directly implementable, but a good north star for edge-case
design: when two behaviours are equally defensible, pick the more dramatic one.

---

# PART 2 — Car Wars (Steve Jackson Games, 1980)

The direct Road Warrior-era ancestor and the deepest vehicle construction
system ever written for a game.

## 2.1 The three-way budget

Every chassis has:
1. A fixed number of **spaces**
2. A **weight limit**
3. For arena vehicles, a **price bracket** you must build within to compete in
   a given class

**This is exactly the pattern your tuning system wants:**

| Car Wars constraint | Your equivalent |
|---|---|
| Spaces | **Physical packaging.** Does this differential fit this transmission tunnel? Can that intercooler coexist with that engine? |
| Weight | **The real currency.** Every addition costs you somewhere else. |
| Price bracket | **Racing classes.** Not the fastest car — the fastest car that still qualifies. |

## 2.2 Class brackets — the item most racing games omit

The price bracket is the important one and it is missing from nearly every
racing game's upgrade tree.

Class brackets convert upgrading from *make number go up* into a genuine
optimisation problem, and it is how real motorsport actually works.

**It also solves the late-game currency problem** flagged in
`05-DESIGN-REFERENCE.md` §1.5. If events are class-gated, a fully maxed car
**locks you out of lower classes**, so you need multiple builds and multiple
cars. Money stays useful indefinitely, and it happens for authentic reasons
rather than through artificial gating.

## 2.3 Derived handling

Car Wars derives a **Handling Class** stat from the completed build rather than
letting the player set it directly. Same principle as Gaslands' skid dice count:
handling is an *output* of your choices, not an input you buy.

Your physics engine already does this naturally. Make sure the **UI shows it as
a derived consequence**, so the player sees that fitting heavier armour or a
bigger turbo moved a number they did not directly touch.

---

# PART 3 — The video game lineage

One idea each, mostly.

**Interstate '76** (1997) — deep vehicle customisation with real chassis
constraints, plus a strong sense of a specific car being *yours*. The closest
video-game relative to Car Wars.

**Twisted Metal / Vigilante 8** — arena vehicular combat. Character-locked
vehicles with distinct handling as the differentiator. Little for you.

**Carmageddon** — damage modelling and deformation aesthetics. Notable mainly
for how much of the appeal came from wreck physics rather than the racing.

**Death Rally** (1996) — top-down racing with weapons and a **car upgrade
economy tied to prize money**. Small, tight, and its progression loop is close
to what you are building.

**FlatOut / Wreckfest** — the destruction-derby lineage, and the best damage
modelling in a genuine *racing* context. **Directly relevant** given you are
inheriting RVP's damage system. Wreckfest specifically proves that heavy damage
simulation and credible handling can coexist.

**Burnout** — the **Takedown** mechanic: aggression is rewarded with boost, so
risk-taking becomes economically rational rather than merely permitted. **If you
want a street-racing action layer, this is the cleanest model** — it adds combat
pressure without adding weapons, which keeps your physics honest.

**Motorstorm Apocalypse / Split/Second** — dynamic track events and
environmental destruction. Expensive to author. Probably out of scope for a solo
mobile project.

**Crossout** — modular vehicle building where parts are physically placed and
can be shot off. The most literal Car Wars descendant currently live.

---

# PART 4 — What to actually take

Ranked by value to your specific project:

1. **Gaslands hazard-token model** → your "ragged edge" instability system.
   Works with zero combat, spans the whole career, and makes limit-driving
   legible on a touchscreen. Highest-value idea in this document.

2. **Car Wars class brackets** → racing classes with build budgets. Fixes the
   late-game economy and makes tuning an optimisation problem rather than a
   ratchet.

3. **Car Wars three-way budget** (spaces / weight / cost) → physically honest
   upgrade constraints. Avoids Gaslands' own costing mistake.

4. **Burnout's Takedown logic** → if you build a street-racing aggression layer,
   reward risk economically rather than adding weapons.

5. **Wreckfest's damage-plus-handling coexistence** → proof of concept for
   pairing RVP's damage model with a credible tire model.

6. **Gaslands sponsors** → team or manufacturer affiliations that push builds
   apart. Pairs with the build-recipe layer in `05-DESIGN-REFERENCE.md` §1.3.

## What to skip

Arena combat, weapons, environmental destruction set-pieces, and anything that
requires authoring bespoke track events. All expensive, all pull against the
simulation, none of them serve the mechanic-to-professional-driver arc.
