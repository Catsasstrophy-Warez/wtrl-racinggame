# The Mustang Dossier

**Why this document is worth your time.** The Mustang thread produced two
findings that matter more than anything else in documents 05–07:

1. **A proven content model that solves your art-budget problem** (§1)
2. **A 2025 federal appellate ruling that defines exactly when a movie car
   becomes legally protectable** (§4)

Analysis only. Nothing extracted.

---

# PART 1 — The single-nameplate content model

## 1.1 The precedent

**Ford Mustang: The Legend Lives** (Eutechnyx, published by 2K and Global Star,
April 2005, PS2 and Xbox — part of the Ford Racing series, following Ford
Racing 3).

The content spec: **40 playable vehicles — all of them the same nameplate.**
Production, concept, and racing models spanning 1964 to 2005. 22 race tracks
across seven US cities including Chicago, Miami, New York and San Francisco.
Career, Arcade, and Challenge modes, with circuit, drag, and drift events.

Reviewers noted it was the first and only game to feature an SVO Mustang.
Progression traced the brand's evolution — unlocking mid-sixties Shelbys and
late-nineties Cobras as milestones in an implicit history of American muscle.

## 1.2 Why this matters enormously to you

`09-ASSET-PRODUCTION.md` §1 establishes the brutal arithmetic: **4–8 weeks per
game-ready hero car.** Eight cars is roughly a year of full-time art. Thirty is
not a plan.

**One nameplate across generations changes that arithmetic:**

| Multi-marque approach | Single-lineage approach |
|---|---|
| 8 cars, 8 ground-up models | 1 lineage, 3 base generations, 15 variants |
| No shared topology | Shared topology, shared UVs, shared rim library |
| 8 separate audio sessions | 3 engine families, variants by tuning state |
| Each car a discrete art task | Variants are trim changes, body kits, and eras |

You get *more* content for *less* modelling, and the shared proportions mean the
whole roster feels coherent instead of like an asset-store grab bag.

**It also serves your premise directly.** Your protagonist is a mechanic who
builds his way up. A game where the player's relationship is with one *lineage*
of car — inheriting a tired base model, restoring it, then acquiring better
generations — is a far tighter narrative than a garage of unrelated vehicles.

## 1.3 Why the 2005 game failed, and why you would not

GameSpot's review is the useful part. The physics model was arcade-grade:

> Rather than feeling the road from four distinct contact points, you'll swear
> each little Mustang seems to pivot on a central fulcrum.

**That is precisely the failure mode a single-nameplate game cannot survive.**
If forty variants of one car all handle the same, you have one car and thirty-
nine skins, and the concept collapses into a licensing exercise.

**You have the opposite problem solved already.** TORSION's drivetrain plus
RVP's suspension and tyre model mean a 1965 base coupe, a 1969 big-block, and a
1993 Fox-body genuinely *do* handle differently — different weight distribution,
different suspension geometry, different torque curves, different tyre
technology. The differences are simulated, not authored.

> **The 2005 game proves the content model is viable and proves exactly what
> kills it. You have the fix.**

## 1.4 Practical shape for your game

- **3 base generations**, each a ground-up model (12–24 weeks of art total)
- **4–6 variants per generation** via trim, body kit, and era parts
- **Shared rim and tyre library** across all of them (`09` §1)
- Cars acquired across the career arc: a tired early car in the street tier, a
  modern one at the professional tier
- The **restoration** of the first car becomes your tutorial for the whole
  tuning system

---

# PART 2 — The trim ladder as a ready-made progression tree

Real performance-car hierarchies are already designed as progression ladders,
tested on real customers for sixty years. You do not need to invent one.

The archetypal pony-car structure:

```
Base coupe  →  performance trim  →  factory hot version
                                          ↓
                            homologation special (track-focused)
                                          ↓
                            outside-tuner halo car (supercharged)
```

**This maps directly onto the named build recipes from `05-DESIGN-REFERENCE.md`
§1.3.** Assemble a full spec and you have earned a tier name — the same
mechanism as Mad Max's Archangels, except the real world already validated the
hierarchy.

**Design notes:**
- Each rung should change the car's *character*, not just its numbers. The
  homologation special should be worse at road driving and better on track.
  That is what makes the ladder a set of choices rather than a ratchet.
- Tie rungs to your class brackets (`06-GENRE-REFERENCE.md` §2.2) so climbing
  the ladder locks you out of lower classes.
- The outside-tuner halo tier is where your **pro shop property** (`07` §2.1)
  earns its purpose — only the shop can build that spec.

**Naming:** use the derivation method (`12`). The *structure* of a trim ladder
is unprotected; the specific names are trademarks. Invent your own.

---

# PART 3 — Movie Mustangs: production lessons

Per IMCDB, the classic Mustang has appeared in nearly 10,000 films and TV shows.
Four are worth studying, for four different reasons.

## 3.1 Bullitt (1968) — the chase standard

A Highland Green 1968 Mustang GT 390 Fastback, an **eleven-minute chase**, all
stunt driving and no CGI. The cultural weight put the car on the National
Historic Vehicle Register, and it later sold at auction for **$3.74 million**,
the most valuable Mustang ever. It influenced every chase sequence since.

**What to take:** geographic legibility. You always know where both cars are
relative to each other and to the city. On a phone screen with a small field of
view, that legibility is not a nicety — it is the difference between an exciting
race and a confusing one. Design your street circuits with landmarks and
elevation that keep the player oriented.

## 3.2 Gone in 60 Seconds (1974) — the solo-creator case study

**H.B. Halicki wrote, financed, produced, directed, starred in, and performed
his own stunt driving**, using cars he owned. The film culminates in a chase
running roughly half an hour, wrecking cars across five cities. He bought two
identical yellow 1971 Mustang Sportsroofs to play "Eleanor" — one left stock,
one heavily modified for stunt duty. The stunt car survives.

**What to take:** this is your situation. One person, total creative control,
constrained resources, and a decision to go *extremely deep on one thing* — the
chase — rather than broad. The film is rough in every other respect and nobody
cares.

**Your equivalent:** go deep on driving feel and the tuning system. Let
everything else be adequate.

## 3.3 John Wick (2014) — the derivation method in commercial practice

The film calls it a 1969 Boss 429. **It is actually a 1969 Mach 1, styled and
modified to look like a Boss 429** — grey, hood pins, Magnum 500 wheels,
Firestone Wide Oval tyres, and an automatic transmission the real Boss 429 never
offered. All five picture cars were destroyed during filming.

**This is exactly the technique in `12-DERIVATION-METHOD.md`, executed by a
major studio production.** Take an available base, apply the defining visual
features of the thing you actually want, and the audience reads it as the target.
Nobody in the audience noticed or cared.

If a studio with a real budget solves the problem this way, so can you.

## 3.4 Gone in 60 Seconds (2000) — the body kit as the star

"Eleanor" here is a Dupont Pepper Grey 1967 Shelby GT500 fastback wearing a
**custom body kit designed by Steve Stanford and built by Chip Foose**. Seven to
eleven replicas were made for filming; five were destroyed. Original cars have
sold for $1M–$2.2M.

**The critical observation: Eleanor is a modification package on a base car, and
the modification became more famous than the base car.**

That is your body-kit and upgrade system, validated at cultural scale. A player
assembling a distinctive spec and having *that build* become their identity —
rather than the car they started with — is exactly the fantasy your progression
system should deliver. Name your builds. Let players screenshot them.

---

# PART 4 — The Eleanor ruling: when a car becomes legally protectable

**The most legally useful finding in this entire research package.** It gives you
the actual test courts apply, and it validates the decomposition framework in
`12-DERIVATION-METHOD.md`.

## 4.1 The case

**Carroll Shelby Licensing, Inc. v. Halicki**, No. 23-4008 (9th Cir., decided
27 May 2025).

The background: Denice Halicki, widow of H.B. Halicki, owns copyrights to *Gone
in 60 Seconds* (1974), *The Junkman* (1982), and *Deadline Auto Theft* (1983),
plus merchandising rights to Eleanor as it appears in the 2000 remake. After the
remake, Shelby licensed GT-500E Mustangs styled after Eleanor. Halicki sued in
2004; the parties settled in 2009. Shelby then licensed Classic Recreations to
build GT-500CR Mustangs, Halicki sent cease-and-desist letters to the shop,
auction houses, and buyers, and Shelby sued for declaratory relief.

## 4.2 The Towle test

The court applied the standard from **DC Comics v. Towle**, 802 F.3d 1012 (9th
Cir. 2015) — the case that held the Batmobile *is* a copyrightable character.

Three requirements for a vehicle to be a protectable character:

| Prong | Requirement |
|---|---|
| **1. Physical and conceptual qualities** | Must exist in tangible form *and* have character-like identity |
| **2. Consistent, identifiable traits** | Recognisable and coherent across appearances |
| **3. Distinctive expression** | More than a generic idea or stock figure |

**The Batmobile passed. Godzilla and James Bond passed. Eleanor failed all
three.**

## 4.3 Why Eleanor failed

**Its appearance varied significantly across the four films.** A yellow 1971
Mustang Sportsroof in 1974; a Pepper Grey 1967 Shelby GT500 in 2000. No
consistent visual identity, no character traits, no narrative role beyond being
the final heist target.

The court characterised Eleanor as closer to a set piece than a recurring
persona. As one summary put it, copyright protects expression rather than
iconography — nostalgia, branding, and screen time are not enough.

## 4.4 The detail that shows how narrow protection really is

The 2009 settlement agreement was interpreted, under California contract law, to
prohibit Shelby from copying **only Eleanor's distinctive hood and inset light
design** — not other features of GT-series Mustangs.

> **Two styling elements.** After twenty years of litigation over one of the
> most famous cars in cinema, the enforceable protected set came down to a hood
> and a pair of headlights.

This is the strongest possible empirical support for the decomposition method in
`12`. The protected column really is that small.

## 4.5 What this means for your project

**Building original cars in the style of a class or era is safe territory.**
Generic archetypes are explicitly outside character copyright. The risks that
remain are the ones `12` already covers: manufacturer trademarks on badges,
names, and specific body designs.

**Two live caveats:**
1. Halicki has stated an intention to seek further review, potentially to the
   Supreme Court. **This is not settled law — verify its status before relying
   on it.**
2. When copyright fails, holders turn to **trademark and trade dress**. Those
   are separate and still apply. Don't read this ruling as a general licence.

**And the inverse, if you ever want your own hero car protected:** the Towle test
tells you how. Give it a **consistent visual identity across every appearance**,
a **narrative role**, and **distinctive traits**. Eleanor lost because it kept
changing. If your game's signature car is meant to become an icon, design it to
stay the same.

---

# PART 5 — Cross-references

- Content model arithmetic → `09-ASSET-PRODUCTION.md` §1
- Named build recipes → `05-DESIGN-REFERENCE.md` §1.3
- Class brackets → `06-GENRE-REFERENCE.md` §2.2
- Property ladder and pro shop → `07-INFLUENCE-MAP.md` §2.1–2.2
- Derivation method and worksheet → `12-DERIVATION-METHOD.md`
