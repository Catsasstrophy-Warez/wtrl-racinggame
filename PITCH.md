# [WORKING TITLE]
### A driving simulation where you build the car before you race it.

**Outward-facing document.** Everything numbered elsewhere in this
archive is internal research and specification. This is the version
for funding conversations and press.

**To complete before sending:** title, team, budget, runway, milestone
gates.

---

## The pitch, in one paragraph

You start as a mechanic with a tired car and a weekend habit. You end
as a professional driver who owns the shop. In between you learn to
build — and everything you learn about the car is something you can
feel through the steering. A genuine simulation of vehicle dynamics
wrapped in a real career and a driver's own progression, on the
platform where nobody has managed both.

---

## The gap

The mobile racing market is enormous and split cleanly in two.

**CarX Street** owns open-world street racing. **Asphalt** owns arcade
spectacle. **Real Racing 3** owns licensed motorsport. **Assoluto
Racing** is the one title taking physics seriously — and its own
players cite thin content as the thing that stops them staying.
**Apex Racing**, the newest serious entrant, has real tuning depth and
the same weakness: strong physics, nowhere near enough game around it.

**Nobody is doing real vehicle dynamics with a reason to keep caring
about them.**

Deep tuning exists on PC — Assetto Corsa, iRacing, Automation. Career
progression exists on mobile. **The combination does not exist**,
because most mobile studios simplify the physics to fit the input,
which removes the thing worth progressing toward — or they build the
depth and stop, the way the depth-segment leaders currently do.

---

## Four things that make it different

### 1. Tuning that produces consequences, not stat bumps

Seven subsystems — aerodynamics, suspension, engine, tyres,
transmission, driver aids, differentials — on a real physics model,
with every hero-car generation's engine, transmission, brake, and axle
data sourced from genuine automotive history, not invented for
convenience.

**The tradeoffs are simulated, not authored.** A bigger turbo genuinely
needs a clutch that can hold the torque. Aggressive aero genuinely
needs suspension that can carry the load. Competitors write those
rules by hand. Ours fall out of the physics for free.

### 2. The ragged edge

An instability meter that fills as you drive at the limit and empties
when you back off. Cross the threshold and you lose the car. Handling
does not just determine how well you corner — **it determines how fast
you can recover.**

On a phone there is no force feedback and no seat-of-the-pants feel.
This makes limit-driving *visible*. **Nothing in the genre implements
it.**

### 3. The garage is the game

Not a menu. The workshop is the home screen. The car sits on the lift,
the bonnet opens, and damage stays visible on the panel until you pay
to fix it.

**When you fit a part, you watch it go on.** Every racing game ever
made hides that behind a loading spinner. We show it — and the way the
work looks improves as you climb from a driveway on jack stands to a
professional shop with air tools and a second pair of hands.

**Progression is visible in the most frequent action in the game.**

### 4. A career that's earned, not menu-allocated

Six named rivals, each with a real personality, a real technical
weakness a player can learn and exploit, and AI that only becomes
intimidating through history the player actually built with them — not
a difficulty slider.

The player's own progression works the same way. A Driver License Grade
earned through proven results, not purchased. Diagnostic skill that
deepens through actually using the car-reading systems already in the
game — and pays off directly in the mentor's own dialogue genuinely
shortening over a career, because the player is starting to catch
what he used to have to point out. **Nothing here is a stat point spent
from a menu.** It's read back from what the player actually did.

---

## Why this is credible, not aspirational

**It compiles and drives.** Not a plan — a confirmed result from a real
Unity session this project has already run. The physics stack, the
RPG systems, and the action-pillar code all exist, cross-checked
against each other and numerically validated in Python before any of
it was trusted. Real bugs were found this way and fixed before they
could have shipped quietly broken — including one where a system read
correctly on inspection and still never fired under any realistic
driving pattern, caught only by simulating one.

**The physics stack itself is already solved.** Drivetrain, suspension,
tyre model, surface system and damage come from mature MIT-licensed
codebases plus a free, commercially-cleared physics engine. We are not
writing a tyre model from scratch.

**There are no licensing costs, and no licensing conversation.**
Manufacturers will not license cars that visibly break — Gran Turismo
shipped for years without damage modelling for exactly that reason.
Since our damage model is core, licensed cars were never available.
Original vehicles, properly derived from real automotive history
rather than traced from it, cost us nothing and let the cars deform,
wear, and carry their history in ways a licensed competitor legally
cannot.

**No server costs.** Multiplayer is asynchronous — recorded ghosts of
real players with a rivalry layer on top. No netcode, no matchmaking,
no infrastructure bill.

**The content plan is achievable, and partly already built.** One
lineage across seven real generations rather than thirty unrelated
cars — shared topology, two engine acoustic families, real sourced
data for every one of them. Four playable circuits, named drag and
oval facilities, and a full thirty-five-recipe progression ladder
already exist as concrete, specified content, not just a plan for
some.

---

## The market

- **Racing is a mature, consolidating category.** The Asphalt franchise
  has passed 1.2 billion downloads; CSR Racing sits under Take-Two.
- **Free-to-play racing revenue is declining** — down roughly 28.8%
  year-on-year in the US in H1 2022, and the wider category is growing
  at only a low single-digit CAGR.
- **The depth segment is underserved and still is.** Mapping physics
  depth against progression depth, the deep/deep quadrant has
  essentially one console-native precedent and no natively-built mobile
  occupant. The newest serious physics entrant on mobile has
  independently confirmed the other half of the thesis by falling into
  exactly the trap this design was built to avoid: real tuning depth,
  thin content, players saying so.

**We are not competing for user acquisition against billion-download
franchises.** We are building the game the quadrant does not have.

---

## Production

**Phase 1 — Prove the core. Underway, not just planned.** Physics
integration, one car, one circuit, confirmed compiling and driving in
a real Unity session. **Remaining in this phase**: the differential
pass-condition test — change one setting, confirm the curve and lap
time move (fully testable without a device), then confirm it's felt
through tilt on both a standard and a Pro-tier device, since device
tier may itself change the answer. This is the one result nothing else
in the project can substitute for.

**Phase 2 — The loop.** Race structure, opponents, the instability
system, basic tuning, money in and parts out — largely specified and
partially coded; needs a scene to finish.

**Phase 3 — Depth.** Full seven-subsystem tuning, damage and repair,
post-race telemetry that names the fault, asynchronous ghosts — data
and logic exist for most of this; UI and scene work remain.

**Phase 4 — The career.** Rating system, class brackets, property
ladder, economy sinks, the full RPG layer — specified and coded at the
systems level; content volume exists for one full generation and is a
repeatable production task for the rest.

**Phase 5 — Content.** Roster expansion, additional circuits, the
remaining rival AI tuning rolled out to live races.

---

## The honest risks

**Input resolution is still the one that could kill it.** If a player
cannot feel a differential change through a touchscreen, the premise
collapses — and it fails *silently*, presenting as "the parts don't do
anything." That exact criticism was levelled at three games in our
research, and it remains the single unresolved question in this whole
project.

**We tested it, cheaply, and it's half-answered.** One car, one
circuit, the full tuning model, a telemetry readout — built, compiled,
and confirmed driving. The curve-and-lap-time half of the pass
condition is fully checkable today. The felt-through-tilt half needs a
device session that hasn't happened yet. **We'll know the rest inside
that one session, not after eighteen months.**

**Thermal throttling is real.** A physics racer heats a phone and
performance collapses around the ten-minute mark. Design and
validation happen on hardware, not in an editor.

**Art is the schedule.** A game-ready hero car is four to eight weeks.
The content plan is built around that number, not despite it.

**CarX Street is the incumbent.** It has the open world and the
audience. Our answer is depth, not breadth — and the audience that
wants depth is currently served by nothing on this platform, including
by the newest title built specifically to try.

---

## What exists today

**Sixty-plus documents of primary research and specification**,
organized by purpose rather than left as a flat pile — covering the
physics stack and its licensing, iOS platform constraints, poly and
audio budgets with real numbers, forty years of genre analysis, the
mobile competitive landscape, six named rivals with real technical
profiles, and a full RPG and action-pillar design.

**Working prototype code for all three pillars** — physics, RPG, and
action — cross-checked file by file, numerically validated in Python
where the claims could be checked that way, and confirmed compiling
and driving in a real Unity session. Real bugs were found and fixed
during this process, not glossed over; several are documented in this
archive exactly as they were found, including the fixes.

**Every design decision traces to a documented precedent — including
the failures.** We know what killed Mad Max's economy, why Underground
2's pacing broke, which control mapping ruined Driver: San Francisco,
why Shift's rating system didn't work, and what happened to the newest
mobile title that tried real physics without building the game around
it.

**We are not going to rediscover those.**

---

## The ask

*[Funding sought, runway, team, milestone gates.]*

**Recommended first gate: the felt-through-tilt session.** Everything
else that could be de-risked without a device already has been. This
is the one result left that decides whether the rest is worth funding
at all — and it's a single session, not a milestone measured in
months.
