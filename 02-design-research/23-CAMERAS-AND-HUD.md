# Cameras, Cockpits and HUD

**The headline: this is an asset-budget question disguised as an art question.**

Cockpit views are the single most expensive presentation feature in racing
games, and the industry's most successful example rationed them severely.

---

# PART 1 — The production cost

## 1.1 The Gran Turismo numbers

**A GT5 "Premium" car took roughly six months to model from scratch**, mostly
in-house, whether during development or as post-launch DLC.

A "Standard" car — PS2-quality, no full interior — took **about one month**. For
context, in the PlayStation 1 era a single car could be completed in a day.

**GT5 therefore shipped ~200 Premium cars with full cockpits and roughly 800
Standard cars without them.**

> Against your budget of 4–8 weeks per game-ready hero car (`09` §1), **an
> interior roughly doubles the cost per vehicle.** It is a second full model with
> its own topology, UVs, materials and LODs — and the player views it at arm's
> length, so it cannot be cheap.

## 1.2 How Polyphony rationed it — three tricks worth stealing

**Tinted windows on Standard cars**, specifically so players could not see
inside. Kotaku noted Premium cars offered glimpses of stunning interiors while
Standard cars' windows were tinted. **The absence became a styling choice.**

**Silhouette dashboards.** After GT5's Spec 2.0 update, Standard cars gained a
cockpit/dashboard view — *"just not nearly as detailed as the premium cars."*
Not a modelled interior; a suggestion of one.

**The tier is visible in the fiction.** Premium cars sold in the new-car
dealership and were always available. Standard cars appeared only in the used
lot at random intervals, and per Kotaku *"generally have a 'used' car feeling to
them."*

> **The cheaper asset became the cheaper car.** The production constraint was
> absorbed by the economy rather than hidden from the player.

## 1.3 It still is not fully resolved

GT Sport and GT7 are all Premium ("Super Premium"), **but some cars still lack
cockpit views** — the Toyota S-FR Racing Concept and most Vision Gran Turismo
cars — and consequently **cannot be used in VR modes at all.**

In GT6 the taxonomy was explicit: cars with interiors were **Detailed**;
Premium cars lacking them were **Simple**.

---

# PART 2 — The camera taxonomy, by cost

| View | Interior needed | Notes |
|---|---|---|
| **Chase / third-person** | No | Default everywhere. Shows off the car the player bought. |
| **Hood / bumper** | No | The fast-lap favourite. Best road visibility. |
| **Roof** | No | Middle ground |
| **Cockpit** | **Yes — full second model** | Immersion; the only view where tuning feels mechanical |
| **Helmet** | Yes, plus head simulation | Most expensive in the genre |

---

# PART 3 — Shift 2's helmet cam

The most sophisticated camera in the corpus, built by Slightly Mad Studios with
Team Need for Speed drivers to simulate the physical experience of 200mph.

## 3.1 What it does

- You see the cockpit **through the driver's visor**, with the inside of the
  helmet silhouetting the screen edges
- **The camera turns toward the apex through corners**, as a real driver looks
  where they are going
- The head **bounces with bumps and jerks forward on impact**
- **Screen edges blur at high speed** to reproduce the tunnel vision drivers
  experience — drawing focus to the road and away from the interior
- **Colour desaturates in a heavy collision**, edges distort, and the driver
  audibly grunts
- At night, **damaged headlights dim or fail**, narrowing the view further

## 3.2 The criticism that matters more than the feature

GameSpot: the helmet consumes screen space and reduces road visibility, the
look-to-apex behaviour *"can feel very unnatural"*, and **most people reverted to
the normal cockpit or hood camera to set their fastest lap times.**

> ## Immersion cameras and performance cameras are different cameras
>
> Players will use one for feel and another for lap times. That is fine — but
> **do not build only the immersive one and expect it to serve both.**

## 3.3 The trick to steal

**The speed blur.** It sells velocity, it focuses attention on the road, and —
critically for you — **it hides interior detail you cannot afford to render.**

One effect solving an aesthetic goal and a budget problem at once. Cheap in URP.

---

# PART 4 — The rest of the corpus

**Porsche Unleashed (2000)** — fully 3D-modelled cockpit on PC, plus interactive
**doors, convertible roof, trunk and engine lids** (`19` §1.5). For a mechanic's
game, opening the engine bay is the thematically loaded one.

**Driver: San Francisco (2011)** — **cockpit view in every one of 125+ cars**,
despite arcade positioning (`21` §6.3). A deliberate statement of respect for the
vehicles.

**Top Gear (SNES, 1992)** — speedometer, tachometer, fuel gauge and position in
a fixed dash strip. And **always split-screen, even in single player**, with the
bottom half showing a CPU car (`18` §1.1). A hardware constraint turned into a
permanent framing device.

**Outlander (1992)** — the Genesis version kept a **rear-view mirror permanently
at the top of the screen**, with enemy reactions visible in it (`05` §2.4). Cheap
to render and genuinely useful. Also a **picture-in-picture combat window** that
changed what your inputs did without leaving the driving view.

**RVP** — you already ship `VehicleHud`: speedometer, gear, RPM meter, boost
meter (`04`).

**Motorsport Manager** — no cockpit at all. Depth via strategy (`16`).

---

# PART 5 — The dashboard matters more than the cockpit

**For your game the HUD layer matters more than the interior model, because the
dash is where your differentiator becomes visible.**

Three things need a home:

## 5.1 The instability meter
Your signature mechanic (`20` §1). **A real gauge — a sweeping needle, a filling
arc — reads faster than a floating UI bar** and belongs in the driver's
sightline. It should look like part of the car, not part of the interface.

## 5.2 Live telemetry
Tyre slip, per-wheel load, downforce. From `08` §6: **prefer curves and bars over
numeric tables** — numbers cannot be read at 60fps on a phone.

## 5.3 Pre-event spec matching
Heat's **recommended performance level and optimal handling profile**, displayed
before the player commits, with vehicle swapping at the entry screen
(`19` §2.12). This is what makes seven-subsystem tuning legible rather than
overwhelming.

---

# PART 6 — Mobile constraints

**Two govern everything:**

1. The road occupies a small fraction of a 6-inch screen
2. **Your thumbs cover the bottom corners.** Nothing critical goes there.

## Recommended camera set

1. **Chase cam as default.** Shows the car the player spent money on, which
   serves the upgrade system directly.
2. **Hood cam as the performance option.** Best road visibility, zero interior
   cost, and it is what players will use for lap times anyway (§3.2).
3. **A full cockpit for the hero car only.** One interior, not fifteen — the car
   the story is about. Pairs with the single-nameplate model in `13` §1.
4. **Tinted glass everywhere else**, with a silhouette dash if you want the
   option available. GT5's trick, and nobody complained about the cars they
   could not see into.
5. **Speed blur at the screen edges.** Sells velocity, focuses attention, hides
   what is not there.
6. **A slim persistent rear-view strip** for the street tier, where somebody on
   your bumper is the entire tension (Outlander's idea, §4).
7. **Instrument the dash properly** — the instability meter as a real gauge.

---

# PART 7 — The recommendation in one line

**Build one great interior for the hero car and spend the rest of that budget on
the tyre model.**

Nobody has ever chosen a racing game for its cockpit views, and **Shift 2's own
players abandoned the most expensive camera in the genre the moment they wanted
to go fast.**

---

# Cross-references
- Poly and texture budgets → `09` §2–3
- Art direction, garage-as-shrine, visible upgrades → `08` §2
- Single-nameplate content model → `13` §1
- Instability meter → `06` §1.2, `20` §1
- Pre-event spec display → `19` §2.12
- Input, and why thumbs matter → `22`
- RVP's `VehicleHud` → `04`
