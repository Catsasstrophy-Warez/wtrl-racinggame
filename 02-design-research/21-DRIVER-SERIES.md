# The Driver Series: Chase Design and Input

**What this fills.** Across twenty documents this package has covered physics,
progression, economy, art, audio, and licensing — and **almost nothing about
input design.** That is a serious gap for a touchscreen game.

The Driver series is where to fix it. Its 1999 control scheme is more
sophisticated than most racing games shipped since, and its 2011 entry documents
a control failure worth studying in detail.

It is also the only lineage in the corpus built around **chase** rather than
**race**.

Analysis only; all titles proprietary.

---

# PART 1 — The design brief

Reflections Interactive, PS1, June 1999. Directed by Martin Edmondson.

The goal was stated plainly:

> There are plenty of driving games and racing games, but something that really
> nails or attempts to nail the car chase environment — there really isn't
> anything out there. I'm talking about the **movie** car chase style, not a
> videogame car chase.

Styled after *Bullitt*, *The French Connection*, *The Driver* (1976) and
*Starsky & Hutch*. It beat GTA III to open-world driving by two years and became
one of the thirty best-selling PlayStation games.

**The stated design philosophy**, from the original Driver website:

> Our titles can be picked up and played instantly by a novice yet provide a
> tough enough challenge for experienced players.

Which the opening tutorial then comprehensively violated (§3.2). Worth noting
that a studio can state the right principle and break it in the first five
minutes.

**Technical parallel:** Reflections **streamed assets from the disc** as the
player moved through the city — the technique GTA III would scale from 2001. A
memory ceiling solved by architecture, which is the shape of your app-size and
thermal problem (`03`, `09`).

---

# PART 2 — The traction vocabulary

**Most driving games give you one drift button. Driver gave you four ways to
break traction, each with a different cost.**

## 2.1 The control scheme

| Button | Function |
|---|---|
| X | Accelerate |
| Square | Brake / reverse |
| Triangle | **Handbrake** — locks the rear wheels |
| Circle | **Burnout** — spins the wheels, breaking traction under power |
| **L1** | **Locks steering to whichever direction is pressed** |
| R1 | Horn |
| L2 / R2 | Camera |
| D-pad / stick | Steering |

**L1 is the remarkable one.** A retrospective called it *the one new button I
haven't seen anywhere else.* It commits the steering angle, and it exists for a
specific reason: **most cars in Driver understeer**, so the player needs a
deliberate way to flick the rear out. It is integral to drifting and to the
reverse 180.

Note also that **Triangle for handbrake was criticised** as sitting further from
X (accelerate) than a frequently-combined input should. Button *adjacency*
matters when inputs are pressed together.

## 2.2 The combinations are the actual mechanics

| Manoeuvre | Input |
|---|---|
| **180 turn** (bootleg turn) | Wheel hard over **+ handbrake**, simultaneously |
| **360 turn** | Wheel hard over **+ burnout**, held |
| **Reverse 180** (J-turn) | Reverse to speed, then turn |

And the tactical distinction, from the speedrunning community:

> You can sometimes use burnout to turn faster in low-speed turns instead of
> using handbrake, **which lowers your speed.**

**Two traction-breaking tools with different penalties, chosen situationally.**

> ## Application
>
> This is what your seven-subsystem depth should feel like *at the input level*.
> Not one drift button, but a **vocabulary** — with the skill living in knowing
> which tool costs least in a given corner.
>
> RVP's separate forward and sideways friction curves with a `slip dependence`
> setting (`04`) already give you the substrate. Handbrake-induced slip and
> throttle-induced slip should scrub different amounts of speed.

## 2.3 Real technique names

These are documented real-world manoeuvres, not invented game moves:

- **Bootleg turn** / handbrake turn — steering input transfers weight to the
  outside tyres, the handbrake locks the rear, adhesion breaks
- **J-turn** — also called a moonshiner's turn, reverse 180, or **Rockford
  turn** after *The Rockford Files*. Both names originate with bootleggers
  evading police.

**Your mechanic protagonist could plausibly teach these.** Named real techniques
are free narrative content and free tutorial structure.

---

# PART 3 — The garage test

## 3.1 The syllabus

Nine manoeuvres, **sixty seconds, any order**:

```
burnout · handbrake · slalom · 180 turn · 360 turn
reverse 180 · full lap · speed test · brake test
```

The brake test requires stopping **as close to the wall as possible.**
Speedrunners complete the whole thing in under thirty seconds.

**Every manoeuvre exercises a different button or combination.** The tutorial is
a complete syllabus of the control scheme, disguised as an audition — a direct
recreation of the scene in *The Driver* (1976) where the wheelman proves himself
to gangsters in a parking garage.

## 3.2 And why it failed

**Mandatory, unskippable, and legendarily difficult.** Top Gear's retrospective:
for less skilled players the audition *"probably also represented the entirety
of the game"* as they repeatedly failed the slalom into a concrete pillar.

> ## The lesson, stated precisely
>
> **The idea is right; the tuning was wrong. A gate must filter, not wall.**
>
> The concept maps perfectly onto your premise — a mechanic auditioning for a
> shop or a crew, proving car control in a controlled space, and learning the
> entire input scheme in one minute. It is the skill-gate answer (`17` §5.3)
> with narrative justification.
>
> Fix the three things Driver got wrong: **instant retry**, **show what went
> wrong**, and **let a partial pass count for something** (`19` §2.9, stars from
> objectives).

---

# PART 4 — The felony system

**Felony accrues only for laws broken in front of a police vehicle.** Witnessed,
not merely committed.

**Sources:** burnouts, running red lights, crashing into any vehicle — **even
when it is not your fault** — damaging property (signs, cones), and exceeding
60 mph.

**Escalation:**
- More felony → more police, more aggression
- **Crossing half the bar → roadblocks.** Passable cleanly, but not reliably.
- **Safe zones** exist where all pursuit stops, usually near entrances and exits

## The design decision that makes it work

> **Cop cars are always faster than you — but they crash often.**

That is the entire chase design in one line. You cannot win on top speed, so you
win on line, timing, and using the environment.

**Nothing rubber-bands. The AI is simply faster and worse.**

> This is a better solution than difficulty scaling and it costs a data table.
> Compare `16` §4.2 (asymmetric rival profiles) and `18` §2.3 (Top Gear 2's
> honest AI). Three independent arrivals at the same principle.

**The witnessed-only rule is also directly portable.** Penalising only contact
the stewards saw is smarter than blanket penalties, and it gives your Safety
Rating (`20` §11) a diegetic justification.

---

# PART 5 — Driver 2 (2000) through DRIV3R (2004)

Driver 2 added on-foot sections. DRIV3R expanded them and was savaged.

> **Third independent confirmation of a warning already in this package.**
> Outlander (1992) had praised driving and criticised on-foot segments
> (`05` §2.3). DRIV3R repeated it twelve years later at far greater cost. The
> Underground 2 pacing complaints (`19` §2.5) are a fourth.
>
> Your mechanic premise invites garage minigames. **Budget to make them
> genuinely good, or keep them menu-driven and fast.**

Incidental: Driver 2's composer was **Allister Brimble**, who also scored Street
Racer on SNES (`18` §4).

---

# PART 6 — Driver: San Francisco (2011)

Ubisoft Reflections. The series had sold 14 million copies by this point.

## 6.1 Shift

Tanner is in a coma; the entire game is his fantasy. He can **leave his body,
float above the scene, and possess any car in the city in real time.**

**What it enables:**
- Jump from your pursuit vehicle into an oncoming car to cause a head-on
- Make a 90-degree turn at full speed by shifting into a car already travelling
  perpendicular

Game Informer: *forget Tanner — the Shift mechanic is the star, and it
fundamentally changes and usually enhances every aspect of the game.*

**Reflections' own rationale is the transferable part:**

> It's pointless innovating with a new feature for the sake of it. As a gameplay
> mechanic, Shift really opens up possibilities previously unheard of.

> ## The innovation test
>
> **Does this mechanic multiply what other systems can do, or does it only
> affect itself?**
>
> Your instability meter (`20` §1) passes: it changes tuning, qualifying, career
> tiers, and event design simultaneously. Apply the same test to every candidate
> feature.

## 6.2 Controls — and a documented failure

| Input | Function |
|---|---|
| Triggers | Accelerate / brake |
| B | Emergency brake — quick turns and drifting |
| **Up on left stick** | **Boost** |
| — | **Ram** — charged, damages the target |
| — | **Rapid Shift** — jump to an ally, *or* cancel a shift and snap back |

### The failure

**Boost was mapped to pushing up on the left analog stick — the stick already
carrying steering.**

A reviewer's account: *if you're like me and slightly push the stick up when you
make turns*, you boost constantly by accident. Remappable, which is the only
reason it was survivable.

> **They overloaded an axis already carrying a continuous input.**
>
> On a touchscreen you have fewer axes, no tactile feedback, and no detents.
> **Any control sharing space with steering will fire accidentally.** This is
> the single most portable warning in the document.

### The success

**Rapid Shift** — one button that either jumps you to a teammate *or* cancels a
pending shift and returns you instantly. **One input, two context-dependent
functions**, described as almost required for team races. Efficient input design
under a button budget, which is exactly your constraint.

## 6.3 Vehicle handling classes

125–140 licensed vehicles, chosen to resemble chase-film cars.

| Class | Behaviour |
|---|---|
| Small (AMC Pacer) | Tight turning, low top speed, light and nimble |
| Muscle | Harsh take-offs, burning rubber, low growl; fast but a handful in corners |
| Sports (Pagani, Lamborghini) | Quick take-offs, poor traction, launches as wildly as muscle |
| SUV / truck | Slow acceleration, long stopping distances |
| Off-road (Land Rover, Baja Bug) | Bought specifically for off-road missions |

**Cockpit view in every car**, despite arcade positioning. Boost was tuned
conservatively — *a turbo that could actually exist in real life, just a subtle
increase in revs and speed*, if you avoided the upgrades.

## 6.4 Two handling warnings

**"The difference between cars feels highly artificial because apart from speed,
there's not much to it. Therefore the fastest vehicle is almost always your best
bet."**

> **Third independent confirmation.** The Mustang game (`13` §1.3) and Porsche
> Unleashed's parts (`19` §1.4) failed identically. **If cars differ on one axis,
> players optimise that axis and the roster collapses to one car.**

**"It's sometimes too easy to drift, which makes proper driving harder as a
result."**

Cars turn fastest under handbrake, donuts are trivial, and cornering at speed is
difficult in every vehicle — *drifting happens whether you want it to or not*. A
sports car off-road *feels like a full-on snow rally with street tyres*.

> **Directly relevant to your instability system.** If breaking traction is the
> fast line, players will never learn the clean one. **Sliding must be costly,
> not merely dramatic.**

## 6.5 Willpower — style as currency, garages as property

**WP is earned through skilful or brave driving** — near misses, drifts, speeding
— as well as through activities.

**It is spent on garages**, scattered around the city and purchasable, which
unlock more cars to acquire and Shift upgrades for ramming and boost. Owning all
of them is the completionist goal.

> **Two of your systems already fused:** Project Gotham's style-as-currency
> (`17` §1) wired into Test Drive Unlimited's property ladder (`07` §2.1). Style
> points buy buildings; buildings gate content.

**Movie Challenges** recreate scenes from *Vanishing Point*, *Bullitt* and
*Starsky & Hutch*, presented with authentic film grain.

**And the design choice worth copying:** some missions **strip Shift and boost
entirely**, forcing reliance on fundamental driving. They deliberately removed
the signature mechanic to make the player prove they did not need it.

## 6.6 Film Director / Movie Maker

Driver 1999 shipped a **replay editor with player-placed cameras**, plus Quick
Replay with automatic selection. Reflections got the replay system running early
and added camera controls late — then **used it to produce their own promotional
videos and in-store demo footage.**

It returned in San Francisco as **Movie Maker**, with Hollywood-style effects and
online upload.

> For a solo developer with no marketing budget, that is the point. **A good
> replay and photo system means your players generate your marketing.** Compare
> the ECS sample's `HiResScreenShots.cs` (`04` §3), which you already have.

---

# PART 7 — What to take for a touchscreen

**1. A traction vocabulary, not a drift button.**
Handbrake slip and throttle slip should scrub different amounts of speed, so
choosing between them is a real decision. RVP's friction curves already support
this.

**2. Never overload the steering axis.**
San Francisco proved it fails with a physical stick. On glass, worse.

**3. Context-dependent single buttons.**
Rapid Shift did two jobs with one input. Under a mobile button budget this is
the pattern to reach for.

**4. Button adjacency matters.**
Driver's handbrake sat too far from accelerate for inputs meant to be combined.
On a touchscreen, thumb reach is the equivalent constraint.

**5. The audition as a control syllabus.**
Nine manoeuvres, sixty seconds, any order, each exercising a different input.
Teaches the whole scheme in a minute. **Instant retry, visible failure reason,
partial credit.**

**6. Rivals faster but flawed.**
Cops that outrun you and crash often beats difficulty scaling, and costs a data
table.

**7. Witnessed-only infractions.**
Penalise contact the stewards saw. Smarter than blanket penalties, and it gives
Safety Rating a diegetic basis.

**8. Style as currency, feeding property.**
Near misses and drifts earn WP; WP buys garages; garages unlock cars.

**9. Strip your signature mechanic occasionally.**
Events that disable assists, boost, or the instability buffer force fundamentals.

**10. Replay editor as marketing.**
Reflections used their own. So can you.

---

# Cross-references
- Input has no other coverage in this package — this document is the source
- Skill gates → `17` §5.3, `18` §5.2, `19` §1.3
- Honest AI over difficulty scaling → `16` §4.2, `18` §2.3
- Cars must differ on more than one axis → `13` §1.3, `19` §1.4
- Instability meter → `06` §1.2, `20` §1
- Style as currency → `17` §1
- Property ladder → `07` §2.1, `16` §4.1, `20` §18
- Non-driving segments warning → `05` §2.3, `19` §2.5
