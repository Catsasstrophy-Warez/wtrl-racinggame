# Derivation Casebook

**Documented cases of professional productions building something that reads as
a specific car without being that car.** `12-DERIVATION-METHOD.md` is the
process; this is the evidence that the process is standard industry practice
rather than a workaround.

Sorted by pattern, because the pattern is the reusable part. Patterns 3 and 5
are the ones that map directly onto game development.

---

# PATTERN 1 — One model dressed as another

The base vehicle is available and cheap; the target vehicle is rare, expensive,
or nonexistent. Dress the base with the target's defining features.

### John Wick (2014)
Presented in-film as a 1969 Boss 429. **Actually a 1969 Mach 1**, styled and
modified to look like one — grey, hood pins, Magnum 500 wheels, Firestone Wide
Oval tyres, and an **automatic transmission the real Boss 429 never offered**.
All five picture cars were destroyed in filming.

> The inaccuracy that gives it away is *inside* the car. Audiences read the
> exterior signature features and stop there.

### Transformers (2007) — Bumblebee
The production ran **ahead of the real car's launch**, so the fifth-gen Camaro
did not yet exist to film. The on-screen car is a **kit build: a Pontiac GTO
chassis wearing plastic molds cast from the Chevy prototype body**.

> A convincing car can be an entirely different platform under a shell. The
> chassis is invisible to the audience — and, in your case, to the player.

### The Avengers (2012) — Tony Stark's NSX
The second-generation Acura NSX was still in development. The screen car is a
**kit body over a real first-generation NSX**.

### Nash Bridges — the Hemi 'Cuda convertible
The "ultra-rare Hemi 'Cuda convertible" is a **clone** — a lesser Barracuda
restored and dressed to present as the top-shelf car. Production bought various
Cudas and Barracudas to build it.

> Production note worth keeping: they intended Lemon Twist paint, it photographed
> badly, and they switched to the deeper Curious Yellow. **The camera decided the
> colour, not authenticity.** Applies directly to your car paint shader and
> garage lighting — pick what reads on a phone screen, not what matches a paint
> code.

### Vanishing Point — the ending
The car that hits the bulldozer is **a '68 Camaro roller loaded with roughly
fifty gallons of gasoline** and towed into the blade, not the hero Challenger.

---

# PATTERN 2 — Replicas standing in for the too-valuable

### Ford v Ferrari (2019)
The most thoroughly documented case, and directly relevant since it is your
closest premise match (`07` §1.1).

- **Superformance built the GT40 replicas.** The originals are worth $10M+ and
  were never candidates.
- **Hollywood Car Co. leased the entire fleet** to production — Ford, Ferrari,
  Porsche and Aston replicas alike.
- Director James Mangold shot **real driving footage** rather than leaning on
  CG; the cars genuinely hit triple digits.
- Twenty 1963 Falcons were bought for the factory scenes.
- Superformance sells GT40 kits without drivetrains from ~$130,000; a finished
  car runs $250,000–$300,000.

**Two details worth extracting:**

**The LS substitution.** Most replicas ran LS engines — lighter, cheaper, easier
to tune, and they package well with a G96 transaxle. The builder's summary: the
stunt drivers beat on them and nothing broke.

**Authenticity only where the camera looks.** **One GT40 received a real Ford
powerplant, specifically for the scenes where Miles is wrenching in the engine
bay.** Everywhere else, the cheaper option.

> This is a poly-budget principle. Detail belongs in the garage scene where the
> player inspects the car; aggressive LODs everywhere else. See `09` §2 and the
> garage-as-shrine rule in `08` §2.1.

### Ferris Bueller's Day Off (1986)
The Ferrari 250 GT California is a **1985 Modena GT Spyder replica**: steel-tube
subframe, **Ford-sourced small-block V8**, Ferrari-inspired fiberglass bodywork
and emblems. **Three built** — one for most of the film, one for stunts, one for
other shots.

### Miami Vice — the Ferrari 365 Daytona Spider
The season-one opener used a real one; the 365s throughout the first two seasons
were **replicas built on C3 Corvette platforms**. Ferrari sued.

**The settlement is the interesting part.** Ferrari agreed to supply real cars —
including the white Testarossa — on the condition that **the replicas be
destroyed on screen**. The season three opener has Crockett's 365 hit with a
missile launcher.

> A licensing dispute resolved *inside the fiction*. Filed here as a reminder
> that these negotiations happen constantly and are usually settled
> commercially, not litigated to judgment.

### Jurassic Park (1993)
The "Jeeps" are **Ford Explorers**.

---

# PATTERN 3 — Decoupling the visible, the audible, and the mechanical

**The pattern closest to how a game is actually built.** Three independent
layers serving three different needs, sourced separately.

### Fast & Furious — Dennis McCarthy's builds
- Stunt cars run **LS engines**, chosen for durability and serviceability
- **Period-correct Hemi sound effects are dubbed in post**
- Hemi-powered cars were built **only for shots where the engine was visible**
  and could not be disguised
- He eventually made a **body mold of the Charger** to stamp future props

> ## The core lesson for your project
>
> The car the audience sees, the engine they hear, and the machine that actually
> performs are three separate decisions.
>
> **Your equivalent:** a purchased or commissioned mesh, your own recorded FMOD
> audio, and a TORSION/RVP drivetrain underneath. **None of the three need share
> a source.** This is not a compromise — it is how the industry works, and it is
> what makes the derivation method practical rather than theoretical.

---

# PATTERN 4 — Many cars for one role

- **The Dukes of Hazzard** — 300+ General Lees across the run, most destroyed
- **The Italian Job (1969)** — six hero Mini Cooper S plus a larger supporting batch
- **Gone in 60 Seconds (1974)** — two identical yellow Sportsroofs, one left
  stock and one heavily modified for stunt duty. The stunt car survives.
- **Gone in 60 Seconds (2000)** — 7–11 Eleanor replicas built, five destroyed
- **John Wick** — five cars, all destroyed

**The lesson is inverted for you.** Film builds many because each is disposable.
You build one asset and reuse it infinitely. That asymmetry is exactly why the
single-nameplate model in `13` §1 works: your marginal cost per *appearance* is
zero, so the cost is entirely in distinct models. Fewer models, more variants.

---

# PATTERN 5 — The fictional-brand system (games)

**Grand Theft Auto is the master class**, and the most directly applicable case
in this document.

## 5.1 Scale

**36 fictional manufacturers** across the franchise, each a deliberate mapping
to a real-world brand. **GTA 6 has 146 confirmed vehicles**, every one traceable
to a real inspiration.

| Fictional | Real |
|---|---|
| Vapid | Ford |
| Bravado | Dodge |
| Declasse | Chevrolet |
| Grotti | Ferrari |
| Pegassi | Lamborghini (+ Pagani, + Ducati for bikes) |
| Pfister | Porsche |
| Obey | Audi |
| Ocelot | Jaguar |
| Karin | Toyota (+ Subaru secondary) |
| Invetero | Chevrolet Corvette |

## 5.2 Technique one — multi-source blending

**The San Andreas Banshee is the best worked example in existence.**

- Primary donor: **first-generation Dodge Viper RT/10** — the long hood, dual
  exhaust, curvilinear body
- **Hood scoops:** mid-to-late-1990s Pontiac Firebird
- **Headlights:** Dodge Stealth
- Then in *Vice City* the same nameplate was **facelifted to read more like a
  mid-80s Corvette C4**

> One fictional car. Three real donors. And it *evolves across releases* while
> keeping its identity — which is also, per the Towle test in `12` §1.3, how you
> would build a car that is itself protectable.

## 5.3 Technique two — blend the brands, not just the cars

Pegassi draws from Lamborghini, Pagani, **and** Ducati. Karin is Toyota with a
Subaru secondary influence, which lets one fictional marque cover a wide
spectrum of Japanese mainstream vehicles.

**A marque sourced from two or three real manufacturers is far harder to read as
any one of them**, and it gives you a coherent design language across an entire
model range rather than car by car.

## 5.4 Technique three — names that carry meaning, not marks

- **Grotti** — from the Italian *grotto*, "cave," an ironic nod at Ferrari's
  flamboyance
- **Pegassi** — from Pegasus, with a **scorpion** logo echoing Lamborghini's bull

Wit rather than imitation. The reference is legible to anyone who knows cars and
invisible to a trademark search.

## 5.5 The proof it works: derivation running backwards

- Rockstar had **West Coast Customs build a physical Bravado Banshee** from
  custom-molded exterior panels laid over an unspecified used 2013 car — the
  same technique as the Transformers Bumblebee, applied in reverse.
- A Kansas City shop (RB's Adrenaline Factory) **turned a real Lamborghini
  Murciélago into a GTA 5 Infernus**, widening the chassis and fitting a custom
  body kit.

> The fictional designs became distinct enough that people now derive *backward*
> from them. That is the standard to aim for: not "which real car is that," but
> a design with its own identity.

---

# What to take

Ranked for your project:

**1. The Banshee is your template, not the Interceptor.** One fictional car,
three real donors, evolving across releases. Repeatable, and it produces
something nobody can point at and name. Run it through the worksheet in
`templates/derivation-worksheet.md`.

**2. Build brands, not just cars.** Two or three fictional marques with
consistent design languages. Gives your roster coherence, makes individual cars
harder to trace, and feeds the trim-ladder progression in `13` §2.

**3. Decouple your three layers.** Mesh, audio, physics — separate sources,
separate decisions. Pattern 3 above is the industry doing exactly this.

**4. Detail where the camera looks.** The Ford v Ferrari engine bay is a poly
budget principle. Garage scene gets the geometry; everything else gets LODs.

**5. Let the display decide the art, not the reference.** Nash Bridges changed
paint colour because Lemon Twist photographed badly. Pick colours, contrast, and
materials that read on a 6-inch screen in sunlight.

**6. Name with wit.** Grotti and Pegassi are better than a serial-number
approach, and they cost nothing.

---

# Cross-references

- The method and worksheet → `12-DERIVATION-METHOD.md`
- The Towle test (when a car becomes protectable) → `12` §1.3, `13` §4
- Single-nameplate content model → `13-MUSTANG-DOSSIER.md` §1
- Poly budgets and LOD policy → `09-ASSET-PRODUCTION.md` §2
- Audio layering and sourcing → `10-AUDIO-DESIGN.md` §6
- Garage as a hero scene → `08-ART-DIRECTION.md` §2.1
