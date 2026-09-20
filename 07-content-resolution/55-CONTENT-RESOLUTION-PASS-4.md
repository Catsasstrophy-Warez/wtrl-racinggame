# Resolving the Content Gap, Pass 4: Named Drag Strip and Oval Facilities

**What this is.** `44-TRACK-ROSTER.md` Parts 1–2 established real
technical standards for drag strips and ovals but built zero actual
named facilities from them. Closed here — one drag strip, three ovals,
each a concrete instance of the real category it belongs to.

---

# PART 1 — The drag strip

**Name**: Redline Raceway (fictional, per `12`'s naming discipline —
no real strip name used).

**Distances offered, all three real standards from `44` Part 1**:
eighth mile (660ft), the classic quarter (1,320ft — the period-correct
distance for the 1965 hero car generation specifically), and 1,000ft
(the modern top-tier NHRA standard, offered as the "serious" distance
for later hero-car generations).

**Physical spec**: two lanes, 18m total width (UEM ideal), shutdown
zone equal to race distance at minimum — 1,320ft of shutdown for the
quarter-mile runs, matching `44`'s own sourced rule of thumb rather
than an arbitrary shorter runoff.

**Standing-mile pairing**: the same facility's shutdown area, extended,
doubles as the half-mile and full-mile standing-mile events (`44`'s own
honest reframing) — one physical location serving both the drag-strip
category and the standing-mile category, since both are straight-line
formats and building two separate facilities for them would be
redundant.

---

# PART 2 — Three ovals, one per real classification tier

## 2.1 Short track — tri-oval

**Name**: Cutback Tri-Oval.

**Length**: 3/4 mile, **30° banking** (Bristol-class, the steep end of
`44`'s sourced short-track range) — the tri-oval's third bend breaks up
the main straight for sightlines, a real, generic construction
technique, not tied to any specific named track.

**Grip-limited top speed** (from `code/prototype/simulation/
oval_banking_test.py`'s own output, already run against this exact
banking figure): ~149mph — genuinely grip-limited at this class, per
`44`'s own confirmed finding that short tracks sit comfortably within
the tire model's reach.

## 2.2 Intermediate — D-oval

**Name**: Longbow Speedway.

**Length**: 1.5 mile, **24° banking** (the steep end of `44`'s sourced
intermediate range) — a D-shaped layout (one straight backstretch, one
long sweeping frontstretch), deliberately a different shape from the
short track's tri-oval, per `44`'s own point that shape variety matters
as much as length variety.

**Grip-limited top speed**: ~164mph, per the same simulation output —
also within the tire model's reach at this classification.

## 2.3 Superspeedway

**Name**: Highbank Superspeedway.

**Length**: 2.5 mile, **33° banking** (the steep end of `44`'s sourced
superspeedway range).

**⚠️ The one figure that must not be presented as an achievable top
speed**: `44`'s own simulation finding already established this
specific banking angle as power-limited, not grip-limited — the
formula's implied 327mph figure would require roughly 2,150hp just to
overcome drag, achievable by nothing in this project's design. **This
facility's actual top speed should be set by whatever car is running
it, computed the normal way through `DynoController.cs`**, never by
the banked-corner grip formula. This is the one facility in this whole
document where the real number is deliberately *not* the headline
figure from the category's own research.

---

# PART 3 — What this closes

**Four named facilities now exist** covering every category `44`
established: one drag strip (serving both drag and standing-mile
formats), and three ovals, one per real classification tier, in two
different shapes. **The drag strip/oval facility gap in `51`'s
inventory is closed.**

**One category remains of `51`'s original five**: RPG data assets —
`BuildRecipe` instances, tested license and reputation thresholds.

---

# Cross-references
- The gap this closes → `51-CONTENT-INVENTORY.md`
- Real standards this builds from → `44-TRACK-ROSTER.md` Parts 1–2
- The simulation this cites directly → `code/prototype/simulation/oval_banking_test.py`
- The power-vs-grip finding this facility must respect → `44-TRACK-ROSTER.md` Part 2, "Simulated, and a real finding"
- Naming discipline → `12-DERIVATION-METHOD.md`
