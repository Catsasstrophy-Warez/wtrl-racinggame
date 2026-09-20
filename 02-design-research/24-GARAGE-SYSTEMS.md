# Garage Systems: Comparative Analysis

**Why this deserves its own document.** The garage is the one system where your
premise gives you a stronger position than almost every game in the corpus —
and it is also the system with the widest variation in how it has been built.

Every racing game here treats the garage as a **support system**. For a game
whose protagonist is a mechanic, it is the **workplace**. That difference is
worth exploiting deliberately.

The decisions that follow from this analysis are specified in
`25-GARAGE-DESIGN.md`.

---

# PART 1 — What a garage actually is

Six distinct functions. **Almost no game does all six.**

```
Store · Modify · Repair · Display · Trade · Generate
```

- Gran Turismo does five and never **generates**
- Mad Max does four and **stores one car**
- Motorsport Manager **generates** and never stores
- Car Mechanic Simulator does **modify** and **repair** as the entire game

**Which subset you pick determines what your game is about.**

---

# PART 2 — Axis 1: Place or menu

The most consequential split, because everything downstream follows from it.

## Garages as places
- **NFS Underground 2** distributed the garage across Bayview as **four
  separate shops** — Body Shop, Car Specialties Shop, Graphics Shop,
  Performance Shop — that the player physically drove to
- **Driver: San Francisco** scattered purchasable garages across the city
- **Car Mechanic Simulator** makes the workshop the entire playspace

## Garages as menus
Gran Turismo, Forza, Top Gear 2, and essentially every mobile racer.

## The documented cost of placeness
Underground 2's free roam was **widely criticised for killing the pacing**,
specifically because the player had to drive to every event and every shop
(`19` §2.5).

## The benefit
Ownership feels real. A shop you visit is a shop you have a relationship with.

> ## The resolution nobody in the corpus tried
>
> **Make the garage a place and eliminate the travel.** The garage is the home
> screen — you are already there, there is nothing to drive to.
>
> This is the decision taken in `25-GARAGE-DESIGN.md`.

---

# PART 3 — Axis 2: One car or many

An emotional fork, not a feature choice.

| Approach | Example | Result |
|---|---|---|
| **One car** | Mad Max — the Magnum Opus, lit, framed, attended by Chumbucket, every upgrade visible | The garage becomes a **shrine** |
| **Hundreds** | Gran Turismo — unlimited storage | The garage becomes a **database** |
| **Between** | Porsche Unleashed — many cars, era-locked and economically constrained | Each acquisition is deliberate |

GT7 added **Scapes** photography specifically to restore the reverence that
scale had destroyed.

> Your single-nameplate model (`13` §1) pushes you toward the shrine. **Three
> base generations and fifteen variants is few enough that each one can be an
> object rather than a row.**

---

# PART 4 — Axis 3: Does storage constrain?

| Game | Storage model |
|---|---|
| **Test Drive Unlimited** | **You buy houses; houses store cars.** The outlier, and the best idea. |
| **Driver: San Francisco** | Garages bought with Willpower; each unlocks cars *and* Shift upgrades |
| **Gran Turismo** | Effectively unlimited — acquisition has no cost beyond money |
| **CSR2 and most mobile** | Garage slots as a monetisation lever |

**Wanting a car you have nowhere to put is a genuine design problem to give a
player.** TDU is the only game in the corpus that understood this.

---

# PART 5 — Axis 4: Shrine or spreadsheet

**Shrine end:**
- **Mad Max** — the Magnum Opus presented with reverence
- **Porsche Unleashed** — the PC version let players open the **doors,
  convertible roof, trunk and engine lids** (`19` §1.5)
- **CSR2** — the garage as a showcase, best car rendering on mobile

**Spreadsheet end:** Motorsport Manager, and most mobile upgrade menus.

> **Porsche Unleashed's openable engine lid is the single most on-premise detail
> in this entire research package.** Your protagonist is a mechanic. Opening the
> bonnet is not decoration — it is the character.

---

# PART 6 — Axis 5: Does the garage do anything when you are not in it?

**This is where the RPG genre and the racing genre diverge most sharply.**

| Game | Passive effect |
|---|---|
| **Mad Max strongholds** | Scrap crews generate passive income |
| **Motorsport Manager / F1 Manager** | Each facility buffs **one named stat** |
| **Driver: San Francisco** | Garages unlock cars and Shift upgrades |
| **Gran Turismo, Forza, NFS, everything else** | **Nothing** |

**Racing-game garages are almost universally inert.**

Your property ladder is where you break with the genre. F1 Manager's discipline
is the model (`16` §4.1): Race Simulator improves driver development, Weather
Centre improves forecast accuracy, and so on. **One named effect per building,
never "+10% everything."**

---

# PART 7 — Axis 6: Maintenance as an activity

## 7.1 GT Auto — the deepest implementation in the genre

Gran Turismo 7 organises it into three departments: **Car Maintenance &
Service**, **Car Customisation**, and **Driving Gear**. Unlocked by completing
Menu Book No. 7 in the GT Café — roughly an hour into the game.

| Service | Effect |
|---|---|
| **Oil Change** | Gives a **new car a slight horsepower bump** over stock. Oil degrades with mileage, costing hp and performance points. |
| **Engine Overhaul** | Rebuilds a worn engine. **Neglect causes permanent horsepower loss that overhauls cannot restore.** |
| **Restore Rigidity** | Body rigidity decays with use; low rigidity means more body roll and a less planted car. If beyond repair, buy a new body entirely. |
| **Car Wash** | Cosmetic. One player: *"waste of time in my opinion."* |

## 7.2 Three decay models in one system

1. **Consumable** — oil, replaced on a schedule
2. **Restorable** — rigidity, repairable indefinitely
3. **Permanent** — engine neglect, which **cannot be undone**

The permanent tier is the bold one. **A car can be genuinely, irreversibly
ruined by an inattentive owner.**

Rigidity debuted in **GT4** as the "Rigidity Refresher Plan," located in each
dealer's tuning shop. GT Auto displays condition status directly (GT6 onward).

## 7.3 The tuning warning

GT7 players consistently complain that **rigidity deteriorates far too
quickly**, hoping for a patch bringing it closer to GT5's rate.

> **A maintenance system that demands attention too often becomes a chore
> rather than a texture.** Tune toward the slower rate.

## 7.4 The other model: repair as economic pressure

**NFS High Stakes** took a different approach — four damage systems tracked
separately, **no repair mid-race**, and a bill in the garage (`19` §2.3).

Not upkeep. **Consequence.** The two models can coexist: High Stakes' repair
bills for damage you caused, GT Auto's decay for time you let pass.

---

# PART 8 — Axis 7: Where tuning happens

| Location | Games |
|---|---|
| **In the garage** | Gran Turismo, Forza, Top Gear 2, most |
| **At the track** | Sim racers, via setup screens |
| **In practice** | Motorsport Manager — tuned to the specific circuit (`16` §3.1) |
| **Through a tool** | **Underground 2's Dyno Run** — tuning behind a diagnostic instrument rather than a slider wall (`19` §2.5) |

> Your seven subsystems want **all three**: garage for parts, dyno for
> calibration, practice session for circuit-specific setup. **Three contexts,
> three levels of commitment.** Specified in `25` Part 4.

---

# PART 9 — The comparison matrix

| | Store | Modify | Repair | Display | Trade | Generate |
|---|---|---|---|---|---|---|
| **Gran Turismo 7** | ∞ | Deep | **GT Auto** | Scapes | Used lot | — |
| **Porsche Unleashed** | Yes | Era-locked | Yes | **Openable panels** | Used market | — |
| **NFS Underground 2** | Yes | **4 shops + dyno** | — | Magazine covers | — | — |
| **NFS High Stakes** | Yes | 3 groups | **Core loop** | — | **Pink slips** | — |
| **Mad Max** | **One car** | Deep | Yes | **Shrine** | — | Strongholds |
| **Test Drive Unlimited** | **Houses** | Yes | — | Yes | Yes | — |
| **Driver: San Francisco** | Yes | Upgrades | — | — | Buy garages | **Unlocks** |
| **Motorsport Manager** | — | Parts R&D | — | — | — | **Facilities** |
| **Car Mechanic Simulator** | Yes | **The game** | **The game** | Yes | Barn finds | — |
| **Top Gear 2** | One | **Dependencies** | Armor | Paint | — | — |
| **CSR2** | Slots | Yes | — | **Showcase** | — | — |

---

# PART 10 — The gap nobody fills

**Every game here hides the mechanic behind a loading bar.**

Gran Turismo shows a spinner. Forza shows a spinner. NFS shows a spinner. Car
Mechanic Simulator shows the work — **and is not a racing game.**

> **A short, skippable, good installation sequence when a part goes on would be
> genuinely novel — and it is the thing your premise most obviously earns.**

Specified in `25` Part 5.

---

# PART 11 — What follows for your game

**You have a stronger claim to the garage than any racing game listed.** Every
one of them treats it as a support system. For you it is the protagonist's
workplace — which means it can be the home screen, the shrine, the tutorial and
the economy simultaneously.

The composite:

1. **Garage as home screen.** Placeness without travel (Part 2)
2. **One hero car, presented as an object** — openable bonnet, doors, boot (Part 5)
3. **Three tuning contexts** — garage, dyno, practice (Part 8)
4. **Repair as the economic engine**, High Stakes style (§7.4)
5. **Maintenance as texture, not chore** — GT Auto's three decay tiers, tuned
   toward GT5's slower rate, keeping the permanent-loss tier (§7.1–7.3)
6. **Property tiers that generate**, one named effect each (Part 6)
7. **Storage as a real constraint** at lower tiers (Part 4)
8. **Show the work** (Part 10)

Full specification in `25-GARAGE-DESIGN.md`.

---

# Cross-references
- Property ladder → `07` §2.1, `16` §4.1, `20` §18
- Repair economy → `19` §2.3, `20` §14
- Dyno → `19` §2.5, `20` §4
- Practice session → `16` §3.1, `20` §6
- Single-nameplate model → `13` §1
- Openable panels → `19` §1.5
- Garage as a hero scene → `08` §2.1
- Cameras and interiors → `23`
