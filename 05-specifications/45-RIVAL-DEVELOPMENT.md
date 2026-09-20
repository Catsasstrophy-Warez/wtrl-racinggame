# Rival Development: Personalities and Cars

**What this is.** `30-NARRATIVE-DESIGN.md` §3.2 gives six archetypes one
philosophy line each and a class-level car lineage description. This is
the actual development pass: names, personalities mechanically tied to
the AI intimidation parameters already specified in `32-HERO-CAR.md`
§5.3, and real derivation work for each car lineage — real automotive
archetypes researched as reference, fictional analogs built per
`12-DERIVATION-METHOD.md`, the same discipline already applied to the
hero car. **No real driver names, no real model names — every car
lineage below is a derived archetype, not a badge-swap.**

---

# PART 1 — Personalities, mechanically expressed

`32-HERO-CAR.md` §5.3 specifies four AI intimidation parameters, all
defaulting to zero and rising only through earned history with a given
rival: `brakePointBias`, `passAttemptSuppression`,
`defensivePositionError`, `launchReactionDelay`. **Personality should be
the reason each rival's parameters rise at different rates and land on
different ceilings** — not just flavour text sitting beside a stat
block.

## 1.1 The Aero one — "Reyes"

**Personality**: cold, precise, contemptuous of anything he considers
untidy driving. Talks little; when he does, it's a correction, not
conversation. Doesn't get rattled by aggression — he's not an aggressive
driver himself, so brute intimidation barely moves him.

**AI tuning**: **low ceiling on `passAttemptSuppression`** even at high
player reputation — he doesn't back off because he's scared, he backs
off because the numbers say the pass doesn't work, and he trusts the
numbers completely. **High `brakePointBias` ceiling specifically in
technical sections** — the one place his philosophy fails him, so
pressure there genuinely rattles his composure, not just his lap time.

## 1.2 The Turbo one — "Kade"

**Personality**: loud, impatient, allergic to anything that isn't power.
Treats every conversation as a countdown to the next launch. Genuinely
warm once beaten fairly — respects anyone who out-guns him honestly,
resents anyone who wins on a technicality.

**AI tuning**: **high `launchReactionDelay` ceiling** — he's the rival
most rattled at the line specifically, since starts are the one place
his turbo lag makes him visibly vulnerable and he knows it.
**Low `defensivePositionError`** even under pressure — whatever else
rattles him, his positioning stays sharp; power is the thing he's
insecure about, not car control.

## 1.3 The Stiff one — "Vogel"

**Personality**: methodical, faintly superior, treats the car's setup as
a moral position. Believes discomfort is proof of correctness — a soft
ride is, to him, an admission of weakness. Long, unbroken presence
(`30` §3.3 — 80s through 2022) means he's the rival with the most
accumulated history with the player of anyone but the Constant.

**AI tuning**: **`defensivePositionError` rises fastest of all six** once
the player has genuinely beaten him on a bumpy circuit — his whole
philosophy is under threat there, and it shows in his driving before it
shows in his words.

## 1.4 The Locked one — "Duquesne"

**Personality**: brash, physical, treats every corner exit as a
confrontation. Doesn't do subtlety. The rival most likely to talk trash
before a race and mean every word of it. Exits the lineage in the
80s–90s transition (`30` §3.3) — proper differentials and wet-weather
tyres make his whole approach obsolete, and he knows it's coming before
it happens.

**AI tuning**: **near-zero `passAttemptSuppression` ceiling, ever** —
even deep into the player's career, he never fully stops trying
optimistic passes. It's not a design oversight; it's who he is. **His
final appearances should show the highest `brakePointBias` of his own
arc** — not fear of the player specifically, but a driver who knows his
era is ending and is driving like it.

## 1.5 The Light one — "Osei"

**Personality**: quiet, almost apologetic, talks about the car like it's
a diet rather than a machine. Disappears in the 80s, returns in the
2000s (`30` §3.3) — when he comes back, he should reference the gap
directly, one of the few rivals who acknowledges time passing in the
narrative rather than just being present or absent.

**AI tuning**: **the most conditional parameter set of the six** — every
value should be near-zero in short events and rise sharply in endurance-
format events specifically, mechanically reflecting his archetype's real
weakness (`30` §3.2 — "everything, briefly; vulnerable in endurance, no
cooling, no fuel").

## 1.6 The Constant — "Marsh"

**Already specified in full** (`30` §3.2, §3.5) — trail braking as his
real mechanical advantage, present in every era, the only rival whose
parameters should rise **slowest** of all six, and the only one with a
narrative exit already written (`30` §3.5: by 2022, the one who can't
drive any more, watching).

**One addition**: his name gives the mentor's dialogue something
concrete to reference across sixty years — *"Marsh again? Some things
don't change"* reads better across seven generations than referring to
him only by archetype.

---

# PART 2 — Car lineages, properly derived

**Method, stated once**: for each rival, a real automotive architecture
is identified as reference (engine layout, drivetrain philosophy, a real
manufacturer's genuine engineering lineage), then a fictional analog is
built that changes badge, specific model naming, and enough styling
detail to stand alone — the same three-part discipline `12` already
established for the hero car. **Family/variant structure** follows
`code/prototype/EngineFamily.cs` throughout.

## 2.1 Reyes's lineage — European rear-engine GT

**Real reference architecture**: air/liquid-cooled rear-engine flat-six,
the specific lineage most associated with escalating aerodynamic
homologation specials from the 1970s through modern GT racing —
`30` §3.2's "downforce solves everything" philosophy maps directly onto
this real engineering tradition.

**Family structure**: **one continuous family**, spanning his full
70s–2010s presence (`30` §3.3) — the real reference lineage's flat-six
architecture stayed genuinely continuous across that span, unlike the
hero car's mid-lineage firing-order break (`37` Part 5–6).

**Crank/induction**: flat-six firing order throughout (a fictional
analog value, not the real reference's actual spec); naturally aspirated
through the 80s, turbocharged variants from the 90s onward — real
history in this architecture family genuinely made that same transition,
so it's authentic to derive rather than invented for variety.

## 2.2 Kade's lineage — Japanese turbocharged inline-six

**Real reference architecture**: the specific golden-era Japanese
turbocharged inline-six tradition — big single turbo, tall gearing, the
real engineering culture that produced the most iconic JDM performance
sixes of the 80s–2000s.

**Family structure**: **one family**, matching his exact 80s–2000s
presence (`30` §3.3) — this rival's span *is* that real architecture's
actual golden era, so the family boundary and his presence table align
naturally rather than needing to be forced.

**Crank/induction**: inline-six, single large turbo as his signature
(`40` Part 1's `AftermarketTurbo`/`ModernSupercharger`-equivalent
categories apply here too, even outside the hero car's own family).

## 2.3 Vogel's lineage — German touring saloon

**Real reference architecture**: the specific German performance-saloon
tradition built on naturally aspirated high-revving inline engines
through the 2000s, transitioning to turbocharging in the 2010s — a real,
well-documented architecture shift in that tradition.

**Family structure**: **two families**, deliberately mirroring the hero
car's own two-family structure (`37` Part 5–6) — Vogel's 80s–2022 span
is long enough to cross a real naturally-aspirated-to-turbo transition
in the reference architecture, and letting his lineage mirror the hero
car's own family break is a design choice worth making on purpose: **the
player's own car and Vogel's both cross an NA-to-turbo-equivalent
transition at roughly the same point in the timeline**, which is a nice,
free piece of historical texture neither car needed to share on paper.

## 2.4 Duquesne's lineage — American big-block

**Real reference architecture**: American big-block V8 muscle, the same
broad era the hero car itself draws from (`13-MUSTANG-DOSSIER.md`) but
from a **different real manufacturer's engineering tradition** than the
hero car's own Ford-derived lineage — necessary so Duquesne's car reads
as a genuine rival marque, not the hero car's family badge-swapped.

**Family structure**: **one family**, matching his short 60s–80s
presence exactly (`30` §3.3) — no family break needed for a span this
short.

**Crank/induction**: cross-plane V8 (the standard for this whole real
tradition), naturally aspirated throughout — a period supercharger
option exists in the real reference tradition too (parallel to `40`
§1.1's Paxton-equivalent finding for the hero car), worth offering here
as well since it's genuine period authenticity, not an invented parallel.

## 2.5 Osei's lineage — British lightweight

**Real reference architecture**: the specific British minimalist sports-
car tradition — small-displacement, low-mass, "performance through
weight removal" as a stated engineering philosophy rather than an
afterthought.

**Family structure**: **one family conceptually revived**, spanning the
non-contiguous 60s–70s and 00s–10s presence (`30` §3.3). This is
authentic to the real tradition, not invented to explain a gap — the
actual lightweight-sports-car philosophy this draws from genuinely did
go dormant for an extended period in the real automotive world and was
genuinely revived by later engineering teams working from the same
stated principles, which is exactly Osei's in-fiction situation.

## 2.6 Marsh's lineage — the Constant

**Real reference architecture**: for 1965–mid-70s, a lightweight rear-
drive economy compact (matching `43-FIRST-PLAYABLE-SPECS.md`'s Item 6
fix); from the late 70s onward, front-wheel-drive hot hatch architecture
— a genuine real category boundary, not a stylistic choice.

**Family structure**: **two families**, split exactly at the real-world
category emergence point (`43` Item 6) — this is the one rival lineage
where the family break is dictated entirely by automotive history
existing or not existing yet, the cleanest possible derivation logic in
this whole document.

---

# PART 2b — Genuine weaknesses, the stated design intent finally built

`20-CONCEPTS.md` §12 states the actual design goal directly: **"Each
rival gets a car with genuine weaknesses — poor brakes, a peaky
engine, bad wet pace — so the player learns which circuits they are
vulnerable on."** Part 1 above built personality and AI parameters;
this closes the gap that check found — the weaknesses themselves were
never turned into real, checkable data.

**Each weakness ties into a system already built, not an arbitrary
stat penalty:**

| Rival | Weakness | Where it's grounded |
|---|---|---|
| **Reyes** | Weak at low speed — his aero-GT archetype genuinely produces little downforce below a threshold speed, so his `TireForceModel` cornering advantage should be tuned to *shrink* in tight, technical sections specifically | Matches his own AI tuning already specified (`brakePointBias` rises in technical sections, §1.1) — now the car itself, not just his driving, carries the weakness |
| **Kade** | Peaky, literally — his turbocharged inline-six `EngineVariant` torque curve should carry a real low-RPM dip before boost arrives, not a smooth curve | Matches his `launchReactionDelay` AI parameter (§1.2) with an actual physical cause, not just a behavioural tell |
| **Vogel** | Bad wet pace — his chassis-first, high-precision setup philosophy (*"discomfort is proof of correctness"*) genuinely trades wet-weather compliance for dry precision in the real touring-saloon tradition this lineage draws from | The first concrete rival application of surface-dependent grip (`20` §3) — previously a physics system with no gameplay use case naming a specific rival |
| **Duquesne** | Poor brakes, exactly matching `20` §12's own example | Grounded directly in his own sourced brake spec (`47` Part 5) — his 1965 and mid-70s generations run drum-only or minimal front disc, genuinely under-braked for his big-block power, a real period trope for this archetype |
| **Osei** | Vulnerable in endurance — already established (`30` §3.2, `45` §1.5) as *"everything, briefly; no cooling, no fuel"* | Already real; restated here as the formal weakness entry rather than left implicit |
| **Marsh** | **Deliberately none** | Consistent with his whole character (§1.6 — nothing rattles him, un-counter-buildable). The one rival without an exploitable weakness is the exception that makes the rule meaningful for the other five, not an oversight |

**What this actually gives the player**: `20` §12's stated payoff —
*"the player learns which circuits they are vulnerable on"* — now has
five genuine, checkable answers instead of one unfulfilled design
intent.

# PART 3 — Production note: done

**All 27 worksheets are complete** — `docs/derivation/`, one file per
rival: `reyes-worksheets.md` (5), `kade-worksheets.md` (3),
`vogel-worksheets.md` (5), `duquesne-worksheets.md` (3),
`osei-worksheets.md` (4), `marsh-worksheets.md` (7). Every worksheet
follows `12`'s full method — feature inventory, protected/transferable
split, upstream trace, substitution plan, distance test, build brief.

**Zero protected features across all 27** — every feature inventory was
built from class-wide, multi-manufacturer real-world conventions rather
than any single named product, which the template itself identifies as
the safest construction (`templates/derivation-worksheet.md` §3: "if
protected > 3, this reference is too close to a single product — widen
the inventory across several examples of the class").

**One real gap was caught and fixed during production**: the first pass
missed Reyes's 2010s worksheet (his presence table entry runs 70s
through 2010s, five eras; the first pass only wrote four). Found by
cross-checking header counts against the presence table rather than
assuming the first pass was complete, and corrected directly in
`reyes-worksheets.md` with the gap noted inline.

---

# Cross-references
- The six archetypes and presence table → `30-NARRATIVE-DESIGN.md` §3.2, §3.3
- AI intimidation parameters → `32-HERO-CAR.md` §5.3
- The derivation method → `12-DERIVATION-METHOD.md`
- Engine family/variant data model → `code/prototype/EngineFamily.cs`
- Forced induction and crank type patterns → `40-FORCED-INDUCTION-DRIVETRAIN.md`
- The hero car's own two-family structure (Vogel's deliberate mirror) → `37-FORD-V8-AUDIO.md` Part 5–6
- The Constant's era-correct car, already fixed → `43-FIRST-PLAYABLE-SPECS.md` Item 6
