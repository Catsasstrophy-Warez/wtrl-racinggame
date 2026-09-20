# Design Reference: Mad Max (2015) and Outlander (1992)

**Scope note.** Both games are proprietary — Mad Max is Avalanche Studios /
Warner Bros., Outlander is Mindscape. Nothing here is extracted content. Game
*mechanics and systems* are not copyrightable; specific expression is. This
document analyses structure only.

See "Legal boundaries" at the end for what to keep clear of.

---

## Fit assessment

Your game is a grounded motorsport career: mechanic -> weekend street racer ->
professional track driver. Both references are post-apocalyptic vehicular
combat. That splits three ways:

| Area | Fit | Why |
|---|---|---|
| Progression / upgrade systems | **Strong** | Mad Max is the deepest car-upgrade RPG shipped. Directly applicable. |
| Combat / encounter design | **Partial** | Useful only for a street-racing aggression layer. |
| Art direction | **Harmful** | Wasteland palette fights an aspirational motorsport premise. |

---

# PART 1 — Mad Max (2015): the upgrade system

## 1.1 The tradeoff principle — the most important lesson here

Avalanche's stated rule: upgrading one element of the car negatively affects
another, so the player continually experiments and balances. It is explicitly
NOT "collect scrap, max everything."

Documented tradeoffs from the developer breakdown:

| Upgrade | Gain | Cost |
|---|---|---|
| Ramming grille | Wrecks enemy cars | Heft drags the front end; precise turns go sluggish |
| Engine | Much faster | Worse handling |
| Tires (slicks) | High speed on roads | Poor off-road manoeuvrability |
| Tires (off-road) | Off-road grip | Loses road speed |
| Armor / boarder barbs | Survivability | Decreased handling |
| Suspension | Counteracts weight, fixes clumsy off-roading | (the balancing lever) |
| Exhaust | Top speed | — |

**Application to your game.** Your tuning list — aero, suspension, engine,
tires, transmission, driver aids, differentials — is already tradeoff-shaped,
because real motorsport is nothing but tradeoffs. Mad Max is the commercial
proof that players engage with tradeoffs instead of just min-maxing.

**Your differentiator:** Mad Max's tradeoffs are coarse, roughly one slider per
category. Yours can be genuinely fine-grained because you have real physics
underneath. A downforce change that costs straight-line speed is a *simulated*
consequence in your game, not an authored penalty. Lean into that.

## 1.2 Two-axis gating

Upgrades are **unlocked by reducing Threat** in a territory, then **purchased
with Scrap**. Two independent gates.

This is the mechanism that prevents buying the endgame build in hour two while
still letting currency accumulate meaningfully.

**Map to your game:**
- Axis 1 (unlock): reputation, licence class, or career tier opens the *catalog*
- Axis 2 (purchase): money buys the *part*

Winning races opens the catalog; earnings fill the garage. Two separate
progression curves you can tune independently.

## 1.3 Archangels — named build recipes

The Magnum Opus can be crafted into specific configurations called **Archangels**,
unlocked by having all prerequisite parts fitted simultaneously.

A recipe layer sitting on top of individual parts. Solves a real problem: it
gives players a concrete target instead of shapeless upgrade soup.

**Adapt as:** named specs (canyon-carver, drag build, wet setup, endurance spec)
that unlock a title, livery, or event eligibility when assembled. Cheap to
implement, high motivational value, and it teaches the tuning system by example.

## 1.4 Strongholds -> your property ladder

Mad Max has upgradable strongholds with buildable projects that generate passive
scrap income (scrap crew, clean-up crew).

**Direct map** to your house -> garage -> pro shop -> warehouse ladder:
- Passive income generation
- Reduced repair or fabrication cost
- Unlocking a fabrication tier (e.g. only the pro shop can build custom diffs)
- Storage capacity (how many cars you can own)

## 1.5 The economy failure to avoid

**Players routinely finish Mad Max with 14,000-20,000 surplus scrap and nothing
to spend it on.** The currency becomes worthless the moment the tree completes.
Community threads are full of "what do I do with all this scrap."

**Build a late-game sink from day one.** Options for your game:
- Consumables: tires, fuel, brake pads, engine rebuilds
- Staff wages once the pro shop opens
- Entry fees scaling with event tier
- Livery / cosmetic spend
- Transport costs to away events

Anything *recurring*. A finite upgrade tree plus infinite income always ends here.

## 1.6 Cheap content trick

Hood ornaments are scattered collectibles granting small stat bonuses (e.g. a
speed bump). Findables that feed the upgrade system rather than sitting inert in
a checklist.

**Adapt as:** rare or vintage parts found via exploration, scrapyard finds, or
completing minor events. Content that costs little to author and rewards
curiosity.

## 1.7 Structural fork you need to decide early

Mad Max is **one hero car, upgraded continuously**. Most racing career games are
**a garage of many cars**. These pull in opposite directions:

- **Single car:** deeper emotional attachment, every upgrade matters, tuning
  payoff compounds. Fits "mechanic builds his own machine."
- **Multi-car:** serves class-based career progression (street -> club -> pro),
  supports the property/warehouse ladder, more content per art dollar.

Your premise supports either. **Decide before building the data model**, because
it changes the schema, the garage UI, and the entire economy.

A hybrid worth considering: one persistent hero car that carries the story
(upgradeable indefinitely) plus class-specific cars required for sanctioned
events. The hero car is the mechanic's identity; the race cars are the job.

---

# PART 2 — Outlander (1992): what actually transfers

Mindscape developed it as a Road Warrior tie-in, lost the licence near
completion, renamed it, and shipped it. A Mad Max game in all but name.
Genesis 1992 (first-person), SNES 1993 (third-person).

## 2.1 Resource scarcity as core tension — the real idea

Fuel is consumed over time; run out and you are dumped into on-foot gameplay
among landmines and hostiles. Ammo is finite. Retrospectives describe the design
theme as dependence on gasoline — something taken for granted becoming precious
— and note the game is explicitly NOT about roaring down the highway firing
indiscriminately.

**This maps cleanly onto endurance racing with fuel and tire strategy:**
- Fuel load affects weight affects lap time
- Tire wear affects grip, non-linearly
- Pit stop timing becomes a genuine decision, not a cutscene
- Under- or over-fuelling is a risk the player chooses

Authentic motorsport, same design logic as Outlander's fuel gauge, and badly
underused in mobile racing games. **Strong fit for your professional-track-driver
endgame** — it's the mechanic that makes the pro tier feel different from street
racing rather than just faster.

## 2.2 The signposted detour

As the player approaches a town, a sign appears and the turn signal (SNES:
hazard lights) automatically activates. Pulling over enters the town — a longer
on-foot section offering fuel, food, and car parts.

A clearly telegraphed, *optional* stop that breaks up the drive without gating
progress.

**Adapt as:** roadside shops, scrapyards, or side events in a street-racing
open world. The key detail is the diegetic signposting — the game tells you an
opportunity is coming using the car's own controls, not a UI popup.

## 2.3 The structural warning — take this seriously

The game alternates driving segments with on-foot side-scrolling sections.
Reviews consistently praised the driving and called the on-foot parts tedious;
Nintendo Power specifically criticised them.

**Your mechanic premise invites garage minigames and shop management.** This is
exactly the trap. If those segments are not as good as the driving, players will
resent every second spent in them.

Either budget to make them genuinely good, or keep them light and fast —
menu-driven rather than simulated. Do not build a mediocre second game inside
your good first one.

## 2.4 Two HUD ideas worth stealing

**Picture-in-picture contextual overlay.** When an enemy pulls alongside, a car
window pops up letting the player fire a shotgun left or right. Contemporary
reviewers called it innovative and said it added real spice.

The generalisable pattern: *an overlay that changes what your inputs do without
leaving the driving view.* Strong on mobile where screen space and input
bandwidth are both scarce. Candidates for your game: mid-race brake bias or diff
adjustment, a pit-radio decision, a rival interaction.

**Persistent rear-view mirror.** The Genesis version keeps the mirror at the top
of the screen permanently, with enemy reactions visible in it. On a phone, a slim
always-on rear-view strip is genuinely useful for street racing where someone is
on your bumper — and it is cheap to render.

---

# PART 3 — Art direction

**Do not take the aesthetic from either.** A rust-and-sand wasteland palette
fights your premise directly. You cannot build "aspiring professional driver"
on post-apocalyptic iconography.

Three things from Mad Max's *presentation* are genre-agnostic and worth keeping:

1. **The garage as a shrine.** The Magnum Opus is lit, framed, and presented
   with reverence rather than as a spreadsheet. Treating the car as the hero
   object of the screen works in any setting, and it is where your player will
   spend a lot of time.

2. **Every upgrade visible on the car.** You can see what you built. Enormous
   motivational value and it costs nothing conceptually — your ride height,
   wheels, aero, and exhaust changes should all read visually. If a player
   spends money and the car looks identical, the money felt wasted.

3. **Wear as narrative.** Dirt and damage accumulate. In your game, stone chips,
   brake dust, and a repaired panel tell the mechanic's story with no dialogue.
   Consider making "restored to showroom" a deliberate player choice with a cost,
   so a battle-scarred car is a badge rather than neglect.

**For actual visual reference, look elsewhere:** motorsport photography, real
workshop and paddock spaces, night street-racing lighting, period-correct car
culture. Different reference set entirely.

---

# Legal boundaries

**Fine to use:** upgrade tradeoff systems, two-axis gating, build-recipe layers,
property/passive-income structures, resource-scarcity tension, fuel and tire
strategy, contextual HUD overlays, persistent mirrors. Mechanics and systems are
not protected.

**Keep clear of:**
- The names *Magnum Opus*, *Archangel*, *Chumbucket*, *Scrotus*, *War Boys*
- **"Scrap" as a currency name** in a car-upgrade context — close enough to
  invite a letter. Name your own.
- The Interceptor's silhouette or any recognisable Mad Max vehicle design
- Wasteland iconography distinctive enough to read as Mad Max
- Any character, likeness, logo, or audio asset from either game
- Outlander's specific level layouts or sprite work

**Rule of thumb:** if a reasonable player would look at it and say "that's from
Mad Max," change it. If they would say "that works like Mad Max," you are fine.
