# Car Mechanic Simulator: The Removable Parts Taxonomy

**What this is.** `07-INFLUENCE-MAP.md` §2.6 and `24-GARAGE-SYSTEMS.md`
already cite Car Mechanic Simulator (CMS) as "the mechanic fantasy taken
seriously" and "the game that shows the work" — but at the concept level
only. This is the actual parts list: what's individually removable, how
it's organised, and what that structure validates or adds to the garage
and installation systems already specified in `25-GARAGE-DESIGN.md`.

**The headline finding: CMS's three-tier disassembly access — exterior,
engine bay, component — is the same structure `25`'s station model already
uses**, arrived at independently. That's a strong signal the station
approach is right, not a coincidence to note and move past.

---

# PART 1 — How disassembly actually works in CMS

## 1.1 Three tiers of access, not one flat parts list

**Exterior first.** "External Part Disassembly" is the default interaction
mode — holding the interact button while looking at the car's body removes
body panels and exterior elements directly, no menu required.

**The hood is a gate, not a panel.** Clicking the hood specifically is
what unlocks engine bay access — body and engine are treated as separate
disassembly *layers*, not one undifferentiated model.

**Engine and suspension each have their own disassembly mode**, entered by
clicking directly on the assembly in question, distinct from the exterior
mode.

> ## This is `25`'s station model, arrived at independently
>
> `25-GARAGE-DESIGN.md` Part 2 specifies seven camera stations — Hero,
> Lift, Engine Bay, Interior, Parts Wall, Desk, Bay Overview — precisely
> because different work happens in different places on the car. **CMS
> reaches the same structural conclusion from a completely different
> design lineage**: exterior, under-hood, and mechanical-assembly access
> are three separate interaction contexts, not one parts menu.
>
> That's independent convergence on the same idea, which is a stronger
> validation than either design alone.

## 1.2 Condition is numeric and colour-coded

Parts needing replacement are marked **red**, generally correlating with
**durability below 20%.** Some parts below that threshold still don't need
replacing, and some parts above it do — condition **and** the specific
job's requirements both matter, not condition alone.

> **Directly matches `25` §4.3's existing design**: damage stays visible
> on the car until paid for, not abstracted into a menu number. CMS's
> colour-and-percentage system is a concrete implementation pattern for
> exactly that principle.

## 1.3 Repairable vs. replace-only — a real, useful distinction

Most components can be **repaired** (their condition restored) or
**replaced** outright. But some are explicitly **not repairable** —
**the gearbox and the clutch plate** are named examples — meaning for
those specific parts, a worn one can only be swapped, never refurbished.

> ## This is a texture worth adopting
>
> `25` §6.2b already splits labour into "player does it" vs. "pay staff."
> **A repairable/replace-only split adds a second, independent axis**:
> some parts reward careful maintenance (repair before failure, cheaper
> than replacement), others are wear items with no maintenance path at
> all (you will replace this eventually, no amount of care avoids it).
> That's a real mechanical truth — clutch plates and gearboxes genuinely
> don't get "repaired" in the way a bearing cap or a housing does — and
> it gives the player a reason to learn *which parts are which*, which is
> exactly the kind of knowledge `30`'s protagonist should accumulate.

## 1.4 Parts are matched to specific engines, not generic

Drivetrain components are catalogued **by engine type** — a gearbox
listed as matched to a "V8 OHV" configuration, a starter motor similarly
tagged. **The same conceptual part (gearbox, starter) has multiple
distinct variants, each compatible with specific engine families only.**

> ## Maps directly onto the hero car's two-family engine structure
>
> `37-FORD-V8-AUDIO.md` establishes that the hero car's seven generations
> split into two real engine families (Windsor-lineage and Coyote-
> lineage). **CMS's engine-matched parts pattern is the mechanical-
> compatibility version of the same split** — a Windsor-family gearbox
> and starter shouldn't fit a Coyote-family engine, and vice versa. This
> is free authenticity: the two-family audio structure and a two-family
> parts-compatibility structure are the same underlying fact, expressed
> twice.

## 1.5 Quantities are explicit, not implied

Parts consistently specify count where it matters — brake calipers,
wheel hubs and tie rods listed **×2** (per axle or per side), rubber
bushings listed in sets as large as **×12**, leaf spring U-bolts **×4**.
**The player isn't left to infer that a car has two front brake calipers
— the game states it.**

> Small, cheap detail worth carrying over directly: any parts-wall
> listing (`25` §4.2) should state quantity explicitly rather than
> relying on the player to know a car has two rear shocks or four
> bushings per corner.

---

# PART 2 — The actual parts, by system

**Organised here by function, not reproduced as CMS's raw in-game lists** —
the point is the *taxonomy*, which is directly reusable, not the specific
item names, which belong to CMS's own content.

## 2.1 Engine bay — genuinely granular

Individually modelled and removable, spanning valvetrain, block internals,
fuel and induction, cooling, and electrical:

- **Valvetrain/top end:** camshaft, cylinder head, head cover, intake
  manifold, timing cover
- **Block internals:** crankshaft, crankshaft bearing caps, block housing
  sections
- **Fuel and induction:** carburettor (period-correct — not present on
  fuel-injected engines), fuel rail, throttle body, air filter and its
  housing, turbocharger and its intermediate housing
- **Cooling:** radiator, radiator fan, thermostat
- **Electrical/ignition:** ignition coil, distributor cap, alternator,
  starter (engine-matched, §1.4), battery
- **Exhaust:** exhaust manifold

**This level of granularity is far beyond what `25`'s current spec names
explicitly** — the garage design references "engine," "turbo," "cams,"
"intake," "exhaust" as purchasable categories (`25` Part 5) without
committing to component-level granularity underneath them.

## 2.2 Suspension and steering — equally granular, and axle-type-aware

- **Per-corner hardware:** wheel hub, wheel hub bearing, shock absorber
  (with distinct listings for double-wishbone vs. other geometries),
  spring, sway bar and its end links
- **Steering:** steering rack, inner and outer tie rods, steering
  knuckle
- **Structural:** front suspension crossmember, upper and lower
  suspension arms
- **Consumable/soft parts:** rubber bushings, listed in the quantities
  they actually come in (§1.5)

**A second axle architecture exists in parallel**: solid rear axle /
leaf-spring cars have their own distinct part set — leaf springs, leaf
spring plates and U-bolts, a solid rear drive axle, drum brakes and drum
brake cylinders — **entirely different from the coil-spring / independent
suspension part set** used elsewhere in the same game.

> ## Directly relevant to the hero car's suspension evolution
>
> The hero car moves from a 1965 chassis toward a modern independent-rear
> platform by the mid-90s generation (`32` §7.1: *"first real chassis
> stiffness"*). **CMS's leaf-spring-axle vs. coil-spring-independent split
> is exactly that transition**, modelled as two genuinely different part
> families rather than one system with different numbers. Worth adopting
> as a real structural split in the parts data, not just a stat change:
> **the early generations' suspension parts should be a different item
> family from the later ones**, the same way the engine audio families
> already are (`37`).

## 2.3 Braking — a system of its own

Distinct from suspension despite the physical proximity: brake callipers
and their cylinders, brake pads, ventilated vs. solid discs, a brake
servo, and — on the solid-axle cars — drum brakes and shoes instead.
**ABS is modelled as its own separate module**, not bundled into the
braking system generally.

## 2.4 Drivetrain

Clutch plate, clutch pressure plate, clutch release bearing, drive shaft,
and the gearbox itself — the last two items on the *not-repairable* list
(§1.3).

## 2.5 Body and interior

Present but far less granular in available research than the mechanical
systems above — body panels are handled at the exterior-disassembly tier
(§1.1) rather than broken into the same component-level detail as the
engine bay.

---

# PART 3 — What this changes in the garage spec

## 3.1 The station model is validated, not just plausible

§1.1's independent convergence is worth treating as settled rather than
worth re-litigating: **exterior / engine bay / mechanical-assembly access
should remain three distinct contexts**, exactly as `25` Part 2 already
specifies.

## 3.2 Consider a repairable/replace-only flag per part

`25` Part 5's tuning table (parts bought vs. calibrated) could gain a
third property per part: **repairable, or replace-only.** Cheap to add,
and it gives the mentor's diagnostic voice (`30` §1.3) something concrete
to say — *"that gearbox is on its way out, and there's no fixing it, only
delaying it."*

## 3.3 Component-level granularity is a genuine open question, not a given

CMS's dozens of individually named engine-bay parts are far more granular
than anything currently committed to in `25` or `20`'s seven-subsystem
tuning list. **This is not a recommendation to match that granularity** —
CMS is a game entirely *about* disassembly, where this project's mechanic
layer is one system among many (`11` §4 already decided simulation is the
primary pillar, but disassembly granularity specifically was never
decided). The honest options:

- **Match `25`'s current category-level granularity** (turbo, cams,
  intake, exhaust as single purchasable units) — cheaper, consistent
  with the current spec, loses some of the "real mechanic" texture
- **Add one tier of sub-component detail** to the categories that most
  reward it (engine internals, suspension per-corner hardware) without
  going as deep as CMS everywhere — a middle path
- **Match CMS's granularity for the hero car specifically**, since it's
  the one vehicle receiving full-interior treatment anyway (`23` §6) and
  the one the mentor's diagnostic voice centres on

**Answered in `39-MECHANIC-GAMES-SPECTRUM.md` Part 6**, after placing CMS
against four other mechanic games on a full granularity spectrum (Jalopy,
My Summer Car, Automation, BeamNG). Short version: category level — this
project's current default — is independently validated by Jalopy as a
complete design point, not a placeholder. The hero car alone is the
reasonable place to spend extra granularity, if any is spent at all.

## 3.4 Axle-family part sets should be structurally distinct

Per §2.2: build the early hero-car generations' suspension as a genuinely
separate part family from the later ones, mirroring the leaf-spring/
coil-spring split CMS models — not a single suspension system with
different numbers plugged in per era.

---

# Cross-references
- Garage stations and disassembly access → `25-GARAGE-DESIGN.md` Part 2
- Damage visibility and condition display → `25-GARAGE-DESIGN.md` §4.3
- Labour economy (player does it / pays for it) → `25-GARAGE-DESIGN.md` §6.2b
- The seven-subsystem tuning list → `25-GARAGE-DESIGN.md` Part 5
- Two-family engine structure → `37-FORD-V8-AUDIO.md`
- Hero car generational chassis evolution → `32-HERO-CAR.md` §7.1
- Mentor's diagnostic voice → `30-NARRATIVE-DESIGN.md` §1.3
- Original CMS citation → `07-INFLUENCE-MAP.md` §2.6, `24-GARAGE-SYSTEMS.md`
