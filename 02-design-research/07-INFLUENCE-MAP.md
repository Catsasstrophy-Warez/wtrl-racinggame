# Influence Map: Films and Games That Match Your Premise

**Scope note.** All titles proprietary. Mechanics and structures analysed;
nothing extracted. Legal boundaries in `05-DESIGN-REFERENCE.md` apply.

**Why this document exists.** Documents 05 and 06 cover the Road Warrior /
vehicular-combat lineage, which is a genre your game is *not* in. This one
covers the references that actually match a mechanic-becomes-professional-driver
arc. Start here if you only read one reference document.

---

# PART 1 — Films

## 1.1 Ford v Ferrari / Le Mans '66 (2019) — the closest match that exists

**Ken Miles is a mechanic who drives, not a driver who happens to know cars.**
That is your protagonist, already written.

Two structural things worth stealing:

**Failure as data.** The film's engine is engineering iteration: test, measure,
adjust, test again. Brake ducts, gear ratios, a door that will not close. Every
setback produces a specific data point that leads to a specific fix.

> **Application:** a lost race should teach the player something concrete about
> the car, not just award less money. Consider surfacing post-race telemetry
> that *names* the problem — "understeer on corner exit, sectors 2 and 4" —
> which then points at a tuning parameter. That closes the loop between your
> physics sim and your progression, and it is the reason to have deep tuning
> at all.

**Workshop vs. establishment.** Miles is too rough for the sponsors. Your
street-to-sanctioned arc has identical friction built in, and it gives the
mid-career act a conflict beyond "faster cars."

## 1.2 Gran Turismo (2023) — your premise as a film

Sim racer becomes professional driver. Watch specifically for how it handles the
**credibility jump between tiers** — outsider earning legitimacy. That is your
hardest narrative transition too, and the film has to solve it in two hours.

## 1.3 Rush (2013) — rivalry as structure

Hunt and Lauda embody two philosophies: instinct versus engineering. A clean
template for recurring AI opponents who *mean* something rather than being
difficulty sliders with names.

> **Application:** give your recurring rivals opposing setup philosophies that
> are visible in their car and their driving. The player learns to read an
> opponent's build.

## 1.4 Initial D — your first act

Delivery driver with an unremarkable car who is simply *very good*. Mountain-pass
street racing. Obsessive focus on **technique over horsepower** — specific
driving techniques appear as plot points.

> **Application:** if your street tier is about skill before money, this is the
> model. Early races the player wins with line and braking, not with parts.
> That makes the first upgrade feel earned rather than assumed.

Successors worth knowing: **Wangan Midnight** (highway racing, tuning
obsession), **MF Ghost** (modern follow-up).

## 1.5 Two-Lane Blacktop (1971)

The driver-and-mechanic duo as a two-hander. Sparse and slow, but the purest
version of that relationship on film.

## 1.6 Chase craft and camera

- **Ronin** (1998) — the best practical chase choreography ever filmed. Study
  the geography: you always know where every car is relative to every other.
- **Bullitt** (1968) — the foundational template.
- **Drive** (2011) — night-city lighting and restraint; long stretches of
  nothing punctuated by violence of action.
- **Baby Driver** (2017) — driving edited to music. If you want a rhythm layer
  or a soundtrack-reactive presentation, this is the reference.

## 1.7 Others worth a look

**Le Mans** (1971, Steve McQueen) — endurance racing, almost no dialogue, pure
procedure. The reference for your professional tier's *tone*.
**Days of Thunder** (1990) — the crew-chief-and-driver relationship.
**Senna** (2010, documentary) — for how motorsport is actually presented.
**The Fast and the Furious** (2001, the first one only) — garage and tuner
culture before the series became heist films.

---

# PART 2 — Games that solve your specific design problems

## 2.1 Test Drive Unlimited — your property ladder, already built

You buy houses; houses store cars. That is precisely the mechanic behind your
house -> garage -> pro shop -> warehouse progression, and TDU demonstrated
players find it genuinely motivating rather than a chore.

Key detail: **storage capacity as a real constraint**. Wanting a car you have
nowhere to put is a good problem to give a player.

## 2.2 Race Driver: GRID — your endgame

You own a team, secure sponsors, and hire teammates whose results you depend on.
**That is where your career should land**: the player stops being only a driver
and starts running the operation. It gives the pro shop and warehouse a purpose
beyond storage.

Also has a flashback/rewind mechanic — worth considering as an accessibility
valve on mobile, where a single mistake in a long race is punishing on a
touchscreen.

## 2.3 iRacing — the mechanical answer to your career transition

Two separate scores:
- **iRating** — how fast you are
- **Safety Rating** — how *clean* you are

Contact costs Safety Rating regardless of whether you won.

> **This is the single best mechanic for your street-to-sanctioned arc.**
> Introduce a Safety Rating at the professional tier and the aggressive habits
> that won street races start locking the player out of events. The player has
> to unlearn something to progress — which is exactly the arc identified in
> `06-GENRE-REFERENCE.md`'s framing section.

## 2.4 Gran Turismo (GT4 especially, plus GT7)

- **License tests** as a teaching structure — bite-sized skill gates that
  double as tutorials and as progression gates. Excellent fit for mobile
  session lengths.
- **Used car dealership** — a rotating stock of affordable cars creates a real
  economy and makes early-game choices meaningful.
- **GT7's café / menu books** — a curated list of cars to acquire that guides
  the player through the collection without a linear campaign. Good model for
  soft-directing an open progression.

## 2.5 Need for Speed: Underground 2

Garage culture and a shop-driven open world. The visual customization loop is
what made the tuner scene work as a game rather than as set dressing.
Relevant to your street tier's identity.

## 2.6 Car Mechanic Simulator

The mechanic fantasy taken seriously — diagnosis, disassembly, part condition,
restoration.

**Poses a question you must answer:** does your player ever *do* the work, or
only pay for it? CMS shows what "yes" looks like. Note that
`06-GENRE-REFERENCE.md`'s warning about non-driving segments applies with full
force — Outlander's on-foot sections were the most criticised part of that game.

**Related:** *My Summer Car* (build a car from individual parts, punishing),
*Jalopy* (maintenance on a road trip).

**Full parts taxonomy in `38-CMS-PARTS-TAXONOMY.md`** — what's actually
individually removable, and a real finding: CMS's exterior/engine-bay/
component disassembly structure is the same three-tier station model
`25-GARAGE-DESIGN.md` already specifies, arrived at independently.

## 2.7 Automation + BeamNG.drive

Engine and chassis design in one tool, feeding into a soft-body physics sim in
the other. The deepest vehicle-construction experience currently available and
the direct modern descendant of Car Wars' build budgets
(`06-GENRE-REFERENCE.md` §2).

## 2.8 Assetto Corsa / Assetto Corsa Competizione

Physics reference and a large modding community. ACC in particular is regarded
as having the most convincing GT tire model available. Useful as a benchmark
for what your tire model should *feel* like, not as something to copy.

## 2.9 Wreckfest / FlatOut / BeamNG

Covered in `06`. Proof that serious damage simulation and credible handling can
coexist — relevant since you are inheriting RVP's damage model.

---

# PART 3 — Mobile: your actual platform

**The most actionable section in this package.** Play these before building
much more.

## 3.1 CarX Street — your nearest competitor

Open world, career mode, extensive customization including engine swaps and body
kits, drift battles, boss battles. In-game currency is used for performance
swaps, bets, and tuning.

**This is close enough to your concept that you need a clear answer to "how is
mine different."** Find that answer now, not after eighteen months of work.

## 3.2 Assoluto Racing — the closest existing thing to your design

The physics-focused mobile option: licensed cars, deep tuning, and an honest
feel of grip that puts it nearer a sim than an arcade racer. Built for players
who want more than a race result.

**Your differentiator is likely the RPG/career layer**, which Assoluto does not
have. Verify that by playing it.

## 3.3 Apex Racing — proof of concept for deep tuning on a touchscreen

Lets players modify all car parts and **tune differentials**, on real roads
including Angeles Crest Highway and Ebisu Minami. No ads.

Confirms that differential-level tuning is viable on mobile — the exact question
your tuning depth raises.

## 3.4 GRID Autosport (mobile) — proof your scope is achievable

A full console racing game ported to phones, widely cited as having the strongest
single-player campaign on mobile. Evidence that a real career mode with real
physics ships on this hardware.

## 3.5 Real Racing 3 — Time-Shifted Multiplayer

**Act on this one.** RR3 uses recorded ghost data from real players so
competitive racing works offline against no live opponents.

> **For a solo developer this is enormous: asynchronous multiplayer with no
> netcode, no servers, and no matchmaking.** You get rivalry, leaderboards, and
> a sense of a populated world, without any of the infrastructure the ECS
> Network Racing Sample (`04-EXTRACTION-INVENTORY.md` §3) would require.
>
> Implementation sketch: record player input + position traces per lap, store
> them (locally, or in the `time_trial_record` table pattern from
> `code/CrazyCar-MIT/SCHEMA-NOTES.md`), and replay them as opponents. Cheap,
> deterministic, and it works on a plane.

RR3 also spans many motorsport disciplines in one package — useful reference for
how to structure a career across event types.

## 3.6 CSR Racing 2

Not your genre (drag racing), but the benchmark for **how good a car can look on
a phone** and for treating the garage as a showcase rather than a menu. Pairs
with the "garage as a shrine" note in `05-DESIGN-REFERENCE.md` Part 3.

## 3.7 Asphalt 9

Pure arcade, licensed cars, spectacle-first. Useful only as a counter-example —
it is what you are *not* making, and knowing that sharpens your positioning.

---

# PART 4 — If you only do three things

1. **Watch Ford v Ferrari** for the arc, and specifically for how failure
   generates the next fix.
2. **Adopt an iRating / Safety Rating split** (§2.3). It is the cleanest
   mechanic for making your street and professional tiers feel genuinely
   different rather than just faster.
3. **Implement Time-Shifted Multiplayer-style ghosts** (§3.5) instead of real
   multiplayer. Months of netcode saved, most of the social value retained.

And spend one evening each with **CarX Street** and **Assoluto Racing**.
Everything else in this package is about how to build the thing. Those two tell
you what you are building against.
