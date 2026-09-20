# The Derivation Method

**How to make something that feels like the thing you liked, legitimately.**

Documents 05–07 analyse references. Documents 08–11 specify production. This is
the bridge: a repeatable process for converting "I like that" into "here is what
I build," without producing something that gets your game pulled.

Run every reference through this before it touches a mesh, a mic, or a shader.

---

# PART 1 — Why this works

## 1.1 What the law actually covers

Two separate bodies of law, and conflating them is the usual source of paralysis.

| | Covers | Example |
|---|---|---|
| **Copyright** | The specific *design* — shapes, surfaces, styling | The exact body surface of a production car; a specific audio recording |
| **Trademark** | Names, brands, logos, badges | The marque name; the badge on the grille; a model name |

Neither covers **function, class, proportion, or technique**. A supercharger
protruding through a bonnet is engineering. A long-nose fastback silhouette
describes an entire market segment. Sodium-vapour light on wet asphalt is
physics. None of these are owned.

## 1.2 The practical consequence

**Almost everything you actually respond to in a reference is unprotected.**
The protected set is far narrower than it feels — it is a specific surface, a
specific name, a specific recording. Everything around it is yours.

The method below exists to separate those two sets reliably, rather than by
instinct.

## 1.3 The legal test: when does a movie car become protectable?

**Carroll Shelby Licensing, Inc. v. Halicki**, No. 23-4008 (9th Cir., 27 May
2025) answered this directly, and it is the most useful case law for your
situation.

The court applied the **Towle test** from *DC Comics v. Towle*, 802 F.3d 1012
(9th Cir. 2015) — the case that held the Batmobile *is* a copyrightable
character. Three requirements:

| Prong | Requirement |
|---|---|
| **1. Physical and conceptual qualities** | Exists in tangible form *and* has character-like identity |
| **2. Consistent, identifiable traits** | Recognisable and coherent across appearances |
| **3. Distinctive expression** | More than a generic idea or stock figure |

**The Batmobile passed. Godzilla and James Bond passed. "Eleanor" — the Mustang
from four *Gone in 60 Seconds*-lineage films — failed all three**, because its
appearance varied significantly across the films (a yellow 1971 Sportsroof in
1974, a 1967 Shelby GT500 in 2000). The court treated it as closer to a set
piece than a recurring persona. Copyright protects expression, not iconography;
nostalgia, branding, and screen time are not enough.

**The detail that proves how narrow protection is in practice:** the parties'
2009 settlement was interpreted to prohibit copying **only Eleanor's distinctive
hood and inset light design** — not other GT-series features. After twenty years
of litigation over one of the most famous cars in cinema, the enforceable set
was a hood and two headlights.

That is the strongest empirical support for this entire method. **The protected
column really is that small.**

### Two caveats
1. Halicki has stated an intent to seek further review, potentially to the
   Supreme Court. **Verify the case's status before relying on it.**
2. When copyright fails, holders pivot to **trademark and trade dress**, which
   are separate and still apply. This ruling is not a general licence.

### The inverse, if you want your own hero car protected
The Towle test tells you how: give it a **consistent visual identity across
every appearance**, a **narrative role**, and **distinctive traits**. Eleanor
lost because it kept changing. Design your signature car to stay the same.

Full case detail: `13-MUSTANG-DOSSIER.md` §4.

## 1.4 The industry precedent

**Fictional makes and models work at the largest commercial scale.** Rockstar
creates entirely fictional brands and models for GTA, reused across games and
eras so they read as long-lived manufacturers. No player experiences this as a
compromise.

**Modification past a threshold is a recognised route.** Gran Turismo included
Porsches by licensing through **RUF**, which modifies stock Porsches enough to
qualify as a vehicle manufactured by RUF rather than Porsche. *The Getaway* used
**Brabus** the same way for Mercedes. This is the same principle you are
applying, just formalised into a business.

**Licensing and damage are mutually exclusive.** Manufacturers refuse to license
vehicles that visibly break. Gran Turismo ran for years with extensive trademark
notices and *no damage modelling* — that was the trade. Rally Cross deliberately
used loosely Group B-inspired fictional cars **because** it wanted significant
damage modelling.

**A studio-scale worked example.** The *John Wick* Mustang is presented in-film
as a 1969 Boss 429. It is actually a 1969 Mach 1 styled and modified to look
like one — right down to an automatic transmission the real Boss 429 never
offered. A major production, with a real budget, solved an availability problem
exactly the way this document recommends. Nobody in the audience noticed or
cared.

> ## This settles the question for your project
>
> You are inheriting RVP's `VehicleDamage` — mesh deformation, detachable parts,
> shatter, and repair. **Licensed vehicles were never available to you.**
>
> Fictional cars are not a fallback. They are the only option regardless, which
> means the constraint is already paid for. Stop treating it as a limitation:
> your cars can deform, shed panels, and carry their history in ways a licensed
> game legally cannot. That is a *feature you have and they don't*.

---

# PART 2 — The method

## Step 1 — Name the response precisely

Write down what you actually liked, in concrete terms. **"The vibe" is not an
answer.** Push until you have physical descriptions.

- Bad: "I like how the Interceptor looks"
- Good: "Black, very long nose, blower sticking through the bonnet, wide rear
  arches, big rear spoiler, blunt nose cone, low and menacing three-quarter view"

If you cannot describe it physically, you cannot rebuild it — and you will
default to copying, because copying is what happens when you skip this step.

## Step 2 — Inventory every discrete feature

Break the response into individual elements. Aim for 8–15. Granularity is the
point: a feature you have not isolated is one you cannot substitute.

## Step 3 — Split the inventory

For each feature, ask: **is this a specific protected expression, or a class,
technique, or physical fact?**

Protected almost always means one of:
- A specific badge, logo, brand name, or model name
- The specific surface geometry of a specific real product
- A specific recording or texture file
- A named character or a livery with real sponsor marks

Everything else — proportion, material, mechanical feature, colour, lighting,
camera, pacing, function — goes in the transferable column.

**When genuinely unsure, put it in the protected column and substitute it.**
Substitution is cheap. A takedown is not.

## Step 4 — Trace upstream

**The single most valuable habit in this document.**

Every reference was itself referencing something real, and that source is
unprotected and usually better material.

| Reference | Upstream source to actually use |
|---|---|
| Mad Max vehicles | Australian muscle car owner-club photography, real rat rods, period Falcon/Monaro/Charger material |
| Mad Max landscape | Real outback and dust storm photography |
| Ford v Ferrari | Period Le Mans photography, Shelby-era workshop documentary footage |
| Initial D | Real Gunma touge road photography, 1980s Japanese coupe culture |
| Le Mans (1971) | Contemporary endurance racing photography and paddock documentary |
| Any garage scene | Real independent workshops — tool walls, fluorescent tubes, oil stains |

You end up with *better* reference than the original gave you, because you are
seeing what its art directors saw rather than their compressed interpretation.

## Step 5 — Plan substitutions

For each item in the protected column, write a specific replacement. Not "make
it different" — an actual decision.

The transferable column carries through untouched. That column is why the result
still feels right.

## Step 6 — Apply the distance test

Three checks, all must pass:

1. **The three-change rule.** At least three defining characteristics altered
   from any single real product.
2. **No names, no marks.** No brand name, model name, badge, or logo. Not
   subtly, not as an easter egg.
3. **The reasonable-person question.** Would someone say *"that IS X"* or
   *"that's like X"*? The second is fine and is what every good genre work does.

**Get a second pair of eyes.** You will be too close to your own work to judge
this, reliably and every time.

## Step 7 — Write the build brief

Output a short, concrete spec an artist (including future you) can execute
without re-reading the reference. If the brief requires the reference to make
sense, you have not finished the method.

---

# PART 3 — The worksheet

Copy this template per reference. Keep completed sheets in `docs/derivation/`
in your project — they are your evidence of independent creation if anyone ever
asks, and your build spec in the meantime.

```markdown
# Derivation Worksheet: <short name>

Reference:        <title, year, medium>
Domain:           <vehicle model / audio / environment / UI / mechanic>
Date:             <yyyy-mm-dd>
Target in game:   <which car, track, tier, or system this feeds>

---

## 1. What is the response?
<Concrete physical description. No abstractions. 2-4 sentences.>

---

## 2. Feature inventory
1.
2.
3.
4.
5.
6.
7.
8.

---

## 3. The split

| # | Feature | Protected? | Why |
|---|---------|-----------|-----|
| 1 |         | No        | Class/technique/physical fact |
| 2 |         | YES       | Specific product surface / mark |
| 3 |         |           |     |

**Protected count:** ___    **Transferable count:** ___

> If protected > 3, this reference is too close to a single product.
> Widen the inventory across several examples of the class before proceeding.

---

## 4. Upstream trace
What was this reference itself referencing?

Primary sources to gather instead:
-
-
-

Reference board assembled from: <how many distinct real examples?>
> Fewer than 5 and one of them will dominate your result. Gather more.

---

## 5. Substitution plan

| Protected feature | Replacement decision |
|---|---|
|  |  |
|  |  |

---

## 6. Distance test

- [ ] Three or more defining characteristics changed from any single real product
- [ ] No brand name, model name, badge, or logo — anywhere, including textures
- [ ] Second pair of eyes says "like X" not "is X"   — reviewer: ______
- [ ] Nothing in the asset filename or mesh name references the original
      (this catches people out — check your FBX object names and material names)

---

## 7. Build brief

<The spec, standalone. Someone should be able to build this without seeing
the reference. Include proportions/numbers where the domain allows.>

Poly budget:      <from 09-ASSET-PRODUCTION.md §2>
Texture budget:   <from 09 §3>
LODs required:    <100% / 50% / 20%>

---

## 8. Attribution
Any third-party assets used in production of this item:
| Asset | Source | License | Modifications |
|---|---|---|---|
|  |  |  |  |
```

---

# PART 4 — Worked examples

## 4.1 Vehicle model

```
Reference:      Mad Max 2 (1981) — the Interceptor
Domain:         Vehicle model
Target in game: Street-tier hero car, "long-nose V8 coupe" class
```

**1. Response.** Black, very long nose, exposed supercharger through the bonnet,
wide rear arches, large rear spoiler, blunt nose cone. Low, wide, menacing in
three-quarter view.

**2–3. Inventory and split**

| # | Feature | Protected? | Why |
|---|---|---|---|
| 1 | Long-nose fastback proportion | No | Describes an entire 1970s market segment |
| 2 | Supercharger through bonnet | No | A real, common modification on thousands of cars |
| 3 | Black paint | No | A colour |
| 4 | Wide rear arches | No | Standard motorsport modification |
| 5 | Large rear spoiler | No | Function, not expression |
| 6 | Blunt front nose cone | No | Aero technique |
| 7 | **Ford Falcon XB GT body surface** | **YES** | Specific production car design |
| 8 | **Ford badge / marque** | **YES** | Trademark |
| 9 | **The name "Interceptor"** | **YES** | Trademark in this context |

Protected: 3. Transferable: 6. Proceed.

**4. Upstream.** Australian muscle of the era — Falcon, Monaro, Charger. Gather
from owner club galleries and period motoring press, minimum eight distinct cars
so no single one dominates.

**5. Substitutions.**
- Falcon XB surface → original body: different door pressing line, different
  lamp geometry (rectangular rather than round), steeper greenhouse angle,
  different C-pillar treatment
- Ford badge → original in-game marque
- "Interceptor" → original model name

**6. Distance test.** Four characteristics changed (doors, lamps, greenhouse,
C-pillar). No marks. Reads as the same class and era, not the same car. Pass.

**7. Build brief.**
> Long-nose two-door fastback, late-1970s large-car proportions. Wheelbase-to-
> overall-length ratio ~0.58. Bonnet length ≥ 40% of overall length. Rectangular
> quad headlamps in a full-width recessed grille. Fastback roofline with a
> heavy, wide C-pillar. Flared rear arches, +60mm over standard. Roots-type
> supercharger with visible scoop protruding through a cut bonnet aperture.
> Full-width rear wing on twin stanchions. Matte-to-satin black, clearcoat
> minimal. Damage-ready topology (see 09 §1).
>
> LOD0 30,000 tris. 2K albedo/normal, 1K ORM. Three LODs.

## 4.2 Engine audio

```
Reference:      Supercharged V8 engine note, Mad Max films
Domain:         Audio
Target in game: Street-tier hero car engine event
```

| Feature | Protected? | Why |
|---|---|---|
| Blown V8 harmonic character | No | A physical property of a real engine type |
| Supercharger whine over the note | No | Real mechanical sound |
| Aggressive off-throttle overrun | No | Physics of the engine type |
| **The specific film recordings** | **YES** | Copyrighted recordings |

**Substitution:** record a real supercharged V8, or license cleared vehicle
recordings from a library such as BOOM. Then **layer** — two different sources
blended, plus a subharmonic and a separate intake layer, produces something that
is neither source.

**Practical route:** supercharged V8 owners exist at every car meet and track
day, and are typically delighted to be recorded. A handheld recorder and a static
rev-sweep session gets a usable loop set. See `10-AUDIO-DESIGN.md` §2.1 for the
loop count and §6 for recording guidance.

**Distance test:** the source recording is entirely yours or cleared. Pass by
construction.

## 4.3 Environment and mood

```
Reference:      Initial D — night touge street racing
Domain:         Environment / art direction
Target in game: Street tier (Act 1)
```

| Feature | Protected? | Why |
|---|---|---|
| Night mountain-pass racing | No | A real activity |
| Guardrail-lined switchbacks | No | Real road engineering |
| Headlights as the only light source | No | Physics |
| Downhill emphasis, gravity as the tool | No | A racing discipline |
| **Specific real roads as depicted** | Borderline | Real geography isn't protected, but a laser-scanned recreation raises other issues |
| **Character cars and liveries** | **YES** | Specific designs and marks |

**Upstream:** real touge photography from Gunma and Hakone, plus night
automotive photography generally. Also worth noting your street tier may be
better served by industrial/urban rather than mountain — see
`08-ART-DIRECTION.md` §1, which sets your Act 1 in underpasses and empty lots.

**Build brief output:** original road layouts using the *techniques* — tight
radius switchbacks, guardrail framing, elevation change as the primary
difficulty, headlight-only illumination with sodium vapour at junctions.

---

# PART 5 — Domain notes

## 5.1 Vehicle models
- **Block out by proportion first.** Set wheelbase, track, front and rear
  overhang, roofline height, and beltline to the target class *before* any
  surfacing. Proportion is what makes something read as a class; surfacing is
  what makes it read as a specific car.
- **Reference boards from many examples**, minimum five, ideally ten. One
  dominant reference produces a copy no matter your intent.
- **Kitbash from a parts library.** Wheels, lamps, mirrors, intakes, exhausts,
  wings, cages. Individual parts are generic; the composition is your design.
  This also feeds your body-kit gameplay feature (`09` §4).
- **Check your object and material names before export.** An FBX with a mesh
  called `falcon_xb_body` undermines everything above.

## 5.2 Audio
Recording your own is both the safest and often the fastest route. Failing that,
cleared commercial libraries are the same source material shipping games use.
Layering two sources is the standard technique for making something distinct.
See `10-AUDIO-DESIGN.md`.

## 5.3 Environments and art direction
Build boards from primary sources — never from film stills or game screenshots.
Real photography is unprotected for reference purposes, gives you better detail,
and produces results that do not look derivative.

## 5.4 Mechanics, systems, and UI
**Fully transferable.** Game mechanics are not copyrightable. Documents 05–07
analyse these freely and `11-SYSTEMS-SPEC.md` specifies them. No worksheet
needed — take what works.

The only caution is **trade dress**: the overall "look and feel" of an interface
can attract trade dress claims where it creates consumer confusion. Do not
reproduce another game's exact UI layout, iconography, and colour scheme as a
package. Individual interaction patterns are fine.

---

# PART 6 — Record keeping

Keep every completed worksheet in `docs/derivation/`. Two reasons:

1. **It is your build spec.** Six months on you will not remember why the
   C-pillar is shaped that way.
2. **It is contemporaneous evidence of independent creation.** If anyone ever
   raises a question, a dated worksheet showing your feature split, your
   upstream sources, and your substitution decisions is far better than a
   recollection.

Pair this with `ATTRIBUTIONS.md` (see `09-ASSET-PRODUCTION.md` §6) for
third-party assets.

---

# Standard disclaimer

This is a working framework based on how studios operate day to day, not legal
advice, and none of it comes from a lawyer. IP law varies by jurisdiction and
outcomes turn on specifics. Before commercial release, an hour with a solicitor
or attorney who knows entertainment IP is cheap insurance — bring your
worksheets, which will make that conversation dramatically shorter.
