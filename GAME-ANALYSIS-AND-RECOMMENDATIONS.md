# Per-Game Analysis + Full Open-World Design Recommendations

Part 1 catalogs every researched title's **unique feature**, **what worked**, and **what didn't** — drawn from the full corpus research (`USABLE-IDEAS-MASTER.md` + `UI-UX-RESEARCH-MASTER.md`). Part 2 synthesizes all of it into concrete recommendations for a full open-world racing game with race tracks, drag strips, street racing, garages, dynos, parts shops, gas stations, and diners.

---

# PART 1 — Per-game breakdown

## Mobile simulation / deep tuning

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Assoluto Racing** | PC-sim-depth tuning sheet on a phone (camber, gear ratios, torque curves) | Proves granular tuning is viable on touchscreen | No career mode — physics with nowhere to go |
| **Apex Racing** | Differential-level tuning on mobile, zero ads | Proved touchscreen can express fine setup differences | Small content volume, stalled post-launch |
| **Real Racing 3** | Time-Shifted Multiplayer (async ghost racing) | 13-year lifespan with zero netcode/server cost | Handling deliberately simplified to fit touch |
| **Assetto Corsa Mobile** | Tilt/wheel/button steering family | — | Thin public documentation; underdeveloped vs PC lineage |
| **Gear.Club** | "Workshop" spatial metaphor for tuning tiers | Assist-based middle ground works for casual sim fans | Ageing content |
| **F1 Mobile Racing** | Six control configurations spanning the whole design space; rear-view camera added late | Comprehensive input taxonomy; real F1 HUD language | Feral's own team admitted console handling doesn't map to mobile |
| **Nitro Nation** | Real dyno graphs + gearing charts in the tuning screen | One of the most data-rich mobile tuning UIs found | Drag-only scope |
| **CarX Drift Racing 2** | Drone camera to spectate *other players'* drift replays | Social spectator camera is genuinely novel | Drift-only scope |

## Console ports / PC sim

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **GRID Autosport** | XML-moddable per-car camera pipeline; $9.99 no-IAP | "Best campaign on mobile" reputation; clean pricing model | 6GB install (later split to reduce), zero ownership/garage, frozen content since 2014 |
| **Colin McRae Rally (mobile)** | Narrated "Car Viewer" garage inspection (a character, "Jack," narrates stats) | Gave a flat garage genuine personality for free | Thin post-port documentation |
| **DiRT Rally** | Enhanced camera control mods, companion telemetry apps | Deep community tooling ecosystem | No true distinct mobile UI ever shipped |
| **Grand Prix Legends** | TV-director-style multi-camera replay system (1998) | Presaged modern broadcast presentation | Zero HUD/hand-holding — legendary for punishing purism, not accessibility |
| **NASCAR Racing 2003** | Setup-sheet garage became a 20-year modding standard | Longevity of the underlying tools | Native HUD/UI considered dated even by its own community |
| **Trackmania** | Live ghost cars racing alongside you as a core HUD/competitive layer | The single clearest "make progress visible in real time" mechanic in the corpus | No car tuning at all (a deliberate scope choice, not a flaw) |
| **Driveclub** | Photo Mode (Free Camera + ~6 presets incl. engine-bay) became the industry template; HUD baked into the cockpit's digital dash | Both ideas widely copied/modded into other games afterward | Server-dependent launch was famously rocky (not UI-related but reputation-damaging) |
| **Test Drive Le Mans** | Compressed real-time 24-hour day/night cycle | Ambitious for an arcade endurance racer | No cockpit view at all — unusual omission for endurance racing; "grade-school garage" |
| **Project Gotham Racing** | Kudos — style-as-currency HUD meter; walkable 3D garage | Defining, widely-copied secondary scoring layer | — |

## Arcade spectacle / drag / drift

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Asphalt 9 / Legends Unite** | Input-adaptive HUD (3 full layouts per control scheme); auto-hiding HUD | Genuinely rare level of UI/input integration | Gacha-heavy monetization is the top complaint across the franchise |
| **Asphalt 8** | Published its own UX redesign case study (Gameloft blog) | Rare industry transparency; garage/upgrade prioritized as highest-traffic screens deliberately | — |
| **NFS No Limits** | Choreographed pre-race "launch camera" transition | Praised specifically by the UI designer's own portfolio | Blueprint-fragment gacha economy gating upgrades |
| **Horizon Chase** | Explicit "No HUD" toggle; retro minimalism as brand identity | Nostalgia-as-differentiation done with real design discipline | No car tuning system (a deliberate, coherent choice) |
| **Beach Buggy Racing 2** | Built-in Photo Mode with full HUD hide, on a kart racer | Unusual polish for its genre tier | Look-back camera sits too close per player complaints |
| **Rocket League Sideswipe** | Full 3D→2.5D reinterpretation of the parent game | Bold, coherent mobile-native reinvention rather than a straight port | Zero performance tuning (fully cosmetic — deliberate scope) |
| **Hill Climb Racing 2** | "Garage Editor" — build a vehicle from parts rather than pick a preset | Deeper build system than the genre norm | — |
| **Sonic Racing (CrossWorlds)** | Gadget-fusion combo system (closer to a shooter loadout than a stat garage) | Distinct identity within a crowded kart-racer field | — |
| **CSR Racing 2** | Dyno slider UI + live "Evo" number + "dyno-beating" meta-strategy | One of the clearest, most-cited good tuning UIs in mobile racing | — |
| **CSR Racing 3** | Pivoted away from sliders to tiered "Aftermarket Mods" loot | A genuine, deliberate in-house A/B test worth studying directly | Lost the live-graph feedback that made CSR2's dyno legible |
| **CSR Classics** | "Museum" garage aesthetic distinct from later CSR games | — | Forces "tunnel vision" HUD low in frame per reviewers; thin modern documentation |
| **Top Speed: Drag & Fast / 2** | Boss Races layered onto standard drag modes | — | Budget-tier titles with almost no independent review coverage |
| **Drag Racing: Streets** | "RPG-style" deep tuning (weight distribution, aero, ECU, clutch/manual) uncommonly deep for mobile drag | Ambitious parameter depth for its tier | No mainstream review coverage to validate execution |
| **CarX Street** | Garage-to-house-to-showcase progression tying customization to reputation | Blends menu tuning with an open-world "flex your garage" social layer | — |
| **Torque Drift / 2** | Camera re-centers on the specific part being edited in the tuning menu | A semi-diegetic feel despite menu-driven adjustment | Long scrollable tuning list makes specific parts hard to find |
| **FR Legends** | Live tandem-drift scoring popups ("Mimicking +2.0!") | Closely models real drift-competition judging | Community mods exist specifically to replace the stock HUD |
| **Drift Max Pro** | "Onlooker" spectator/crowd camera mode | Unusual arcade-spectacle framing | Thin documentation on HUD specifics |

## Rally / open-world sandbox / management

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Rush Rally 3** | Interior dial/gauge skins tied to livery decals | Cosmetic customization reaching all the way into the cockpit HUD | — |
| **Rush Rally Origins** | Retro top-down/isometric camera offered as a genuine first-class option alongside chase cam | A real, not-novelty alternative camera identity | Isometric mode makes elevation/braking judgment harder |
| **Car Parking Multiplayer** | Free-walking + Drone Mode + World Sale player-to-player marketplace | 100M+ installs on parking-game physics — proves garage/social systems alone can carry a game | Physics are explicitly the weak point; no real career arc |
| **Car Parking Multiplayer 2** | Drivable garage; savable custom camera presets | Evolves CPM1's ideas into an even more spatial, less menu-driven UX | — |
| **Extreme Car Driving Simulator** | Near-zero friction between opening the app and driving | 100M+ downloads *despite* shallow physics — "time-to-first-drive is a feature" | Heavy ad monetization, near-cosmetic damage |
| **Ride Master: Car Builder** | Puzzle-style, stats-transparent parts-catalog build system | Legible numeric part stats as the whole interaction | Shallow beyond the build-then-validate loop |
| **Highway Racer Pro** | Per-camera-view tunable parameters (FOV/height/pitch/damping/shake) | Unusually deep camera customization for a budget mobile title | — |
| **Motorsport Manager** | Unlicensed fictional universe; headquarters-as-spatial-map | Commercially successful without a license; fans defend the fiction against "realism" mods | — |
| **Motorsport Manager Online 2025** | F2P spinoff of the above | — | Widely reported "dumbed down," punitive resource rates driving IAP pressure |
| **F1 Manager 2024** | Named single-purpose facility rooms (9+ distinct rooms, each one stat) | The most legible facility-to-stat mapping found anywhere in the corpus | Licensed and expensive; license terminated early after failing to profit |
| **Top Drives** | Replaces driving entirely with a stat-card deck-builder | "Car knowledge as the product," a genuinely distinct genre blend | No driving at all — extreme scope choice |
| **Traffic Rider** | Exclusively first-person, diegetic gauges, no third-person option | A deliberate narrowing that reinforces immersion | — |
| **Drive Mad** | — | — | Essentially no indexed UI documentation; too thin to assess |

## PC/console simulation + GTA

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Gran Turismo (1997)** | Invented the license-test-as-tutorial-and-gate pattern | Still the industry standard 28 years later | Camera/HUD specifics too old to document confidently |
| **Gran Turismo 4/5/6/Sport** | Premium/Standard car tiers; GT Auto's 3-tier decay model | Turned a production constraint (can't model every interior) into an in-fiction economy signal | GT5/6 UI iterated wildly (XMB tiles → Windows-8-style grid → reverted) — no single stable identity for years |
| **Gran Turismo 7** | Café/Menu Book system — an NPC quest-log wrapping the whole campaign | The most significant UI/UX shift in series history; RPG conventions grafted onto a racing sim without feeling foreign | — |
| **Forza Motorsport (2005)** | First console racer to seriously rival GT's tuning depth | Established the brand identity from day one | Shipped UI barely documented today — even its own prototype builds are the best surviving reference |
| **Forza (Drivatar era)** | AI trained on real player driving data, tagged visibly in-HUD | Blurred single-player/multiplayer at the UI level in a genuinely new way | Documented toxic-AI incident from unbounded training; admitted rubber-banding despite "honest" AI |
| **Forza Horizon** | Wristband/Popularity progression tied to a live festival map | Franchise-defining alternative to a linear career ladder | — |
| **Forza Horizon 4** | Forzavista walkable/interactive showroom | Deepest "garage as object, not menu" execution in a mainstream franchise | — |
| **Forza Motorsport (2023)** | "Builder's Cup" — explicit RPG language (Car Mastery, XP) wrapping career mode | Fuses two genres' UI conventions cleanly | Launch bug: default HUD settings for Damage/Fuel/Tires displayed inconsistently |
| **iRacing** | iRating + Safety Rating dual-axis, painted as a livery stripe visible to everyone | Turns a backend number into a public, permanent social signal — unique in the corpus | Native HUD widely considered too sparse; large third-party overlay ecosystem exists to compensate |
| **Assetto Corsa** | Fully Python-scriptable, freeform "apps" HUD | The most influential extensibility architecture in sim racing | Base menus widely criticized as dated/utilitarian, spawning UI-replacement mods |
| **Assetto Corsa Competizione** | Structured 3-tier MFD mirroring a real endurance-racing engineer workflow; MoTeC i2 telemetry integration | Deliberately curated (vs AC's freeform) — a genuine philosophical alternative that also works | Cockpit dashboard cannot be disabled (a sim-purist choice some found restrictive) |
| **Trackmania** (again, cross-ref) | See above | | |
| **GTA III** | Minimalist radar+stat-bar HUD that set the entire open-world genre's template | Still recognizable in every modern open-world game's HUD | Zero vehicle customization of any kind |
| **GTA: Vice City** | "Too hot to handle" contextual refusal message at Pay 'n' Spray | Early example of contextual UI feedback gating a service screen | Still no real customization — resprays only |
| **GTA: San Andreas** | First real tuner garage split (TransFender=performance, Wheel Arch Angels=cosmetic) | Established functional/cosmetic separation the genre still uses | Split across two separate shop types felt disjointed vs. a unified experience |
| **GTA V** | Los Santos Customs — unified shop, live 3D part-swap preview | The customization-UI template most later racers/action games copied | — |
| **GTA Online** | In-game phone browser as the vehicle-purchase UI (diegetic commerce); business management via a dense Interaction Menu overlay | Genuinely blurs UI/world boundary; management UI stays legible precisely by refusing to be flashy | Property purchase order matters — buying earning capability before support businesses nets almost nothing (a real, if intentional, UX trap) |
| **GTA 6** | Two named garages (Rideout Customs, One-Eyed Willie's) confirmed pre-launch | — | No actual UI has been shown — pure speculation territory currently |

## NFS lineage

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **The Need for Speed (1994)** | "Electronic magazine" car showcase (Road & Track copy + FMV) | Genuinely novel for 1994; the first "car-as-object" presentation in the genre | No customization of any kind (a product of its era, not a flaw) |
| **NFS III: Hot Pursuit** | Introduced police pursuit as a mode | Foundational to the entire franchise identity going forward | Still minimal customization |
| **NFS High Stakes** | First persistent damage system + toggleable damage HUD meter | Damage tied directly to a visible, ownable consequence | Tuning still shallow relative to the damage ambition |
| **NFS: Porsche Unleashed** | Evolution mode — chronological 50-year career, openable doors/roof/trunk | Single-marque-with-real-physics proved the content model *can* work | Niche structure never repeated by the series itself |
| **NFS Underground** | First true garage mode; visual customization live on a rotating model | Set the tuner-culture visual template EA reused for a decade | No cockpit view at all — dropped entirely for street spectacle |
| **NFS Underground 2** | Dyno Run with live bar-graph curve shaping | The strongest "you can see what you changed" tuning UI in the whole NFS lineage | Free-roam killed pacing (documented, widely cited complaint); stock differential bug undermined trust in the tuning system itself |
| **NFS Most Wanted (2005)** | Speedbreaker (slow-mo steering aid); Blacklist rival "mugshot" cards | Turned a rival ladder into a visually gamified progression board | — |
| **NFS Carbon** | Autosculpt — direct-manipulation body sculpting, not a preset picker | Rare departure from static parts-list customization | Base camera options were comparatively limited vs. Most Wanted |
| **NFS ProStreet** | Deepest slider-bank tuning in the mainline series (camber/toe/caster/gear-by-gear) | Genuine engineering-spreadsheet depth, unmatched elsewhere in the franchise | No visualization of the changes — the corpus's clearest "depth without feedback" example; audience didn't follow the street→sanctioned tone shift |
| **NFS Shift** | Cockpit cam praised as best-in-class for its era | Set a high bar other studios explicitly chased | — |
| **NFS Hot Pursuit (2010)** | Autolog | Genre-defining social/notification layer | Dropped tuning/customization entirely |
| **NFS Shift 2** | Full head-tracking helmet cam (G-force-driven sway) | Regarded as one of the most immersive camera implementations of its console generation | Divisive/nauseating for some; hurt precision driving |
| **NFS Rivals** | AllDrive seamless SP/MP blending | Corner-notification design (unobtrusive real-player merge alerts) | Minimal tuning depth |
| **NFS Heat** | Day/night dual-currency loop (Bank vs. Rep) with pre-event recommended-spec display | Makes tuning depth legible before commitment — directly solves the "will my car even work here" problem | Underglow/livery couldn't be live-previewed on the car at launch |
| **NFS Payback** | Speed Cards + separate "Derelict" barn-find restoration system | Derelict's tiered before/after reveal is a good restoration-specific idea in isolation | Speed Cards are the series' most-cited tuning failure — RNG between decision and result |

## Driver series

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Driver (1999)** | Director Mode — full player-directed replay editing | Highly unusual for 1999; became a franchise signature | — |
| **Driver 2** | Exit-vehicle on-foot mode | First in the genre to blend driving and on-foot seamlessly | On-foot sections widely seen as weaker than driving |
| **DRIV3R** | Automated "Thrill Cam" replacing Director Mode | — | Losing player-directed replay was seen as a real regression; on-foot combat sections savaged |
| **Driver: San Francisco** | "Shift" — aerial camera doubling as the car-select/traversal UI | The single most inventive camera-as-UI idea in the whole corpus | Willpower-gated garages meant no true performance tuning |

## SNES / retro era

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Top Gear** | Fuel-consumption-as-strategy coupled to speed; 3 non-replenishing nitro boosts | Minimal systems producing real strategic depth | No damage or upgrades — a product of scope, not ambition |
| **Top Gear 2** | Schematic damage diagram + genuine upgrade shop between races | Ahead of its time for a 16-bit arcade racer | Upgrade prerequisites were arbitrary rather than physically justified |
| **Top Gear 3000** | Same systems, total sci-fi reskin | Proved the underlying systems design travels across fiction | — |
| **Lotus Esprit Turbo Challenge** | Repurposed "dead" single-player screen space to preview the rival | Efficient, still-relevant UX idea for ghost/rival panels | — |
| **Street Racer** | Horizontal-stack 4-player split-screen (vs. quadrant) | A genuinely distinct, still-comparable alternative to Mario Kart's approach | — |
| **Al Unser Jr.'s Road to the Top** | Multi-discipline vehicle roster (karts→snowmobiles→stock cars→Indy) as one game | Progression-as-curriculum, no separate tutorial needed | Thin surviving documentation of its actual garage/UI |
| **Pitstop (1983)** | Pit stop as an active, timed minigame; tire-wear via sprite color | The pit stop *is* the garage — kinetic rather than administrative | — |
| **Pole Position** | Foundational dashboard-HUD/pseudo-3D-camera template | Nearly every arcade racer since descends visually from this | — |
| **Out Run** | Branching routes signaled via a simple map cue at forks; radio/music select | Ties tone control directly into the HUD | — |
| **Rad Racer** | Selectable stereoscopic 3D mode | Distinctive historical curiosity | Soft-fail deceleration (no abrupt timeout) is a small but real UX nicety worth noting either way |
| **Super Hang-On** | World-map continent-select as meta-progression | Simple, legible structure | — |
| **Super Mario Kart** | Dropped the map entirely in split-screen rather than shrinking it | A clean, quotable precedent for prioritizing playable area over info density | — |
| **Ridge Racer** | Deliberately sparse HUD to keep focus on reading slip angle | HUD-as-skill-support, not just information display | No damage, no customization (a genre choice) |
| **Sega Rally** | Surface-dependent grip, communicated through feel not UI | Cheapest way ever found to make tracks feel genuinely different | — |
| **Destruction Derby** | Real-time deformation tied to actual drivability | Ahead of its time in 1995; damage genuinely readable and consequential | Camera options undocumented — possible thin implementation |
| **Ford Mustang: The Legend Lives** | 40 variants of one nameplate | Proved (partially) the single-nameplate content strategy | Reviewers specifically flagged the *absence* of a garage as a missed opportunity; arcade physics made all 40 cars feel identical |

## Vehicular combat / Mad Max lineage

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Mad Max (2015)** | Every upgrade a genuine trade-off; anywhere-accessible garage; named "Archangel" build presets | The clearest, most influential garage-design reference in the whole corpus | Late-game currency (scrap) becomes worthless — no economy sink |
| **Outlander** | First-person cockpit + picture-in-picture combat overlay | Strong reference for multi-threat HUDs on a first-person view | On-foot segments criticized relative to driving |
| **Interstate '76** | Hardpoint weapon mounting + location-specific armor allocation | One of the most sophisticated vehicle-combat build models found | Salvage-only economy in campaign mode limits build freedom |
| **Twisted Metal / Vigilante 8** | Vehicle-as-character design (fixed roster, personality-driven) | Strong contrast case to stat-customization garages | No persistent garage/upgrade loop at all |
| **Carmageddon** | Dual win-conditions with separate HUD tracks (finish / destroy all / splatter all) | A genuinely unusual multi-objective HUD | — |
| **Death Rally** | Top-down camera + persistent currency-driven shop | Early, clean RPG-lite economy loop in a racing-combat game | — |
| **FlatOut** | See above (Damage & repair section) | | |
| **Wreckfest** | See above (Damage & repair section) | | |
| **Motorstorm: Apocalypse** | Boost meter with overheat/explosion risk; living collapsing environment | Turns nitro into a push-your-luck resource | Environmental destruction as spectacle rather than mechanically consequential |
| **Split/Second** | Powerplay meter triggers track-altering scripted destruction | See HUD section — a meter that changes the world | No garage/customization at all |
| **Crossout** | Grid-based, node-connected part-placement builder; components shoot off individually in combat | The single most sophisticated garage/damage integration in the entire corpus | Steep build-complexity learning curve (implicit in the system's depth) |
| **Burnout 3: Takedown** | Crash Mode as its own scored spectator mode | Turned crashing into content, not just penalty | No performance tuning (a deliberate arcade choice) |
| **Burnout Paradise** | Removed the minimap for in-world signage | Bold, still-praised minimalist HUD choice | Junkyard/license-based unlocks instead of a stat garage — no deep tuning |

## Mechanic/construction sims

| Game | Unique feature | Worked | Didn't work |
|---|---|---|---|
| **Car Mechanic Simulator** | Zone-based interaction (approach→drill into subsystem→radial tool menu) | Independently converges with a 7-station garage design — validated pattern | — |
| **My Summer Car** | Per-bolt physical simulation, green-highlight tool-fit feedback, zero UI | The most granular, genuinely tactile repair interaction found anywhere | Extreme niche appeal — a cautionary example for mainstream scope |
| **Jalopy** | Whole-component swap + scarce consumable repair kits | Validates minimal (7-part) granularity as a complete design point | Durability decay tuned too aggressively per players |
| **Automation** | Family→Variant engine design hierarchy with live dyno graph and 3D fit visualization | Teaches real engineering trade-offs through UI restriction, not text | Community-found draw-call bug from unmerged part meshes (2.5x cost) — a real technical lesson |
| **BeamNG.drive** | Node-and-beam soft-body sim; slot-based tuning that unlocks with part investment | Physically consequential damage; UI complexity that scales with player investment | Players still want to cleanly remove already-broken parts — structurally can't, because there's no discrete "part" concept |
| **Test Drive Unlimited** | Houses as literal car storage — property is a physical destination, not a menu | The clearest "garage progression rooted in world space" precedent | — |
| **TDU Solar Crown** | In-world interactive tablet for property purchase; freely-positioned 8-car garage; friends' cars visible in driveways | Modernizes the original concept meaningfully | — |

---

# PART 2 — Full design recommendation

Synthesizing everything above (plus the deeper mechanics catalog in `USABLE-IDEAS-MASTER.md`) into a concrete open-world design covering race tracks, drag strips, street racing, garages, dynos, parts shops, gas stations, and diners.

## The core positioning

No title in either research pass has **physics depth + career depth + ownership depth** simultaneously (the corpus's own `27-COMPETITOR-ANATOMY.md` finding). GRID Autosport has the first two, no garage. Car Parking Multiplayer has ownership, no physics or career. This is the actual gap. Everything below is built to hold all three at once without diluting any of them.

## World structure: the "world as menu" principle

Every strong reference in this research treats physical destinations as UI screens, not the other way around:
- Test Drive Unlimited's houses, GTA's Pay 'n' Spray/LS Customs, Driver: San Francisco's Shift, CPM2's drivable garage, Mad Max's anywhere-accessible garage.

**Recommendation**: build the open world as the actual navigation layer, with zero abstract main menu beyond pause/settings. Concretely:

- **Garages** (your home base, one per property tier — house→garage→pro shop→warehouse, per the original corpus's property ladder) are physical buildings you drive into. Interior is the Los Santos Customs pattern: rotating 3D preview, live-swap-before-buy, categories split cleanly into Performance vs. Cosmetic (the GTA V lesson — San Andreas's two-shop split felt disjointed; unify it).
- **Dynos** live inside the garage as a distinct room/station (matches this project's own `25-GARAGE-DESIGN.md`), not a menu tab. Use the **CSR2 + Underground 2 hybrid** as the tuning-UI template: sliders that live-update a single legible number *and* a real graph, plus an actual "run it" simulated pass (CSR2's Test Ride) rather than trusting the predicted number blindly. This is the single best-evidenced pattern in the whole corpus — do not build ProStreet's disconnected slider wall, and do not build Payback's RNG cards.
- **Parts shops** are physical storefronts (echoing GTA SA's TransFender, NFS Underground's brand-tiered shops) but consolidated into the garage's "Parts Wall" station per the existing design, browsed as a catalog with live fit-preview on your actual car, gated by two independent axes kept genuinely separate (money buys what's shown; reputation determines what's shown at all — already specified in this project's `48-RPG-SYSTEMS-SPEC.md`, and directly validated here by Car Wars' three-way budget and GTA Online's reputation-gates-passive-income finding).
- **Gas stations** serve double duty: fuel/repair-on-the-go (functional) and, per Outlander's picture-in-picture pattern and CPM's landmark-as-meeting-place finding, a *social/navigation landmark* — "meet me at the Route 9 station" needs an actual place to mean something. Cheap to build (a fuel pump prop + a small interaction radius), disproportionately useful for world legibility.
- **Diners** are the narrative/social hub the corpus's mentor-character system needs a home in (`30-NARRATIVE-DESIGN.md`'s "the mentor talks while you work, you can ignore him" principle extends naturally to "the mentor talks over coffee"). This is also where rival encounters and job offers surface — matching the Café/Menu Book pattern from GT7 (an NPC handing out structured objectives) without needing GT7's budget, since a diner booth is far cheaper to build than a full café scene. Keep it non-mandatory and skippable, per the corpus's own "zero cutscenes" rule.

## Race tracks (circuit/road racing)

- Build 2–3 **structurally distinct** circuits, not palette-swapped clones — this project's own track-design docs already did this correctly (a short/learnable circuit, a long/unpredictable one with blind crests, a technical/tight street-circuit-character one). Keep that discipline.
- Every corner should exist to stress-test a specific system (the `43-FIRST-PLAYABLE-SPECS.md` test-circuit pattern: hairpin for low-speed instability response, sweepers for sustained lateral load, esses for rapid direction change). This is a genuinely reusable track-design method, not just a testing convenience — apply it to every circuit you ship, not just the tutorial one.
- License-test-style skill gates (GT's oldest, still-working idea) unlock circuit tiers. Keep them short and instantly retryable — Driver's garage-audition failure (mandatory, unskippable, too hard) is the cautionary tale; GT's version (optional, medal-tiered, retryable) is the one that survived 28 years.

## Drag strips

- Use real NHRA/UEM distances (660ft/1,320ft/1,000ft) — free, zero-IP-risk, and already sourced in this project's `44-TRACK-ROSTER.md`.
- The launch/shift interaction is the actual game here, and CSR3's rhythm-game reframing of the classic tach-and-lights HUD is the most interesting recent evolution of this found in research — worth prototyping as an option (traditional tach-watching vs. rhythm-timed shifts) rather than assuming the classic version is final.
- Give drag tuning its own simplified sub-mode of the main dyno UI (final drive, nitrous, tire pressure — CSR2's exact three-slider set is proven at massive scale) rather than exposing the full 7-subsystem tuning depth here; drag is about precision on 3 knobs, not breadth across 20.

## Street racing (open-world, illicit)

- **NFS Heat's day/night dual-currency loop is the strongest single reference found**: daytime sanctioned events build Bank (spend on parts), nighttime unsanctioned racing builds Rep (unlocks) and raises visible police Heat. This maps directly onto this project's own street-tier/professional-tier split without inventing a new system.
- Pursuit/escape as a format (already speced in `50-ACTION-PILLAR-EXPANDED.md`) should borrow Driver's **witnessed-only felony rule** — infractions only count if a cop actually sees them — for a diegetic basis, and Driver's cop-AI philosophy (faster but crash-prone, never rubber-banding) over any scaling-difficulty approach.
- Outrun-style pursuit races (open gap to 300m, no track) are the cheapest street-racing format to build and should be the first one shipped.
- Autolog-style async notifications ("a rival beat your street-race time here") extend naturally from the existing ghost-race system already planned — this is a near-zero-cost addition once ghosts exist at all.

## Garages, dynos, parts shops — the deliberate answer to "which tuning philosophy"

Given the direct evidence gathered (Underground 2/CSR2 succeeding, ProStreet/Payback failing, CSR3's in-house pivot, Crossout/Automation's construction-based alternative):

**Recommendation: slider+graph+live-number, not tiered loot, not full physical construction.** Reasons:
1. It's the only pattern with *two independent proven successes at different budget tiers* (Underground 2 at AAA scale, CSR2 at mobile-free-to-play scale).
2. Tiered loot (CSR3, Payback) reads as more "game-y" and risks the exact complaint already logged against Payback in this project's own research (`19-NFS-DOSSIER.md`) — chance between a decision and its result.
3. Full physical construction (Crossout) is the single most compelling system found, but it's a genre-defining commitment on its own — appropriate for a spinoff or a "hero car" showcase feature, not the baseline interaction for every car in an open world with a career mode attached.

Concretely: every tunable parameter shows (a) a slider or bar-graph input, (b) a live-updating readout (a graph for engine/ECU work, a single aggregate number for quick comparisons — CSR2's "Evo" and this project's own dyno-power-curve concept are the same idea at two zoom levels), and (c) an actual simulated test pass available on demand, never assumed. Gate deeper sliders behind installed parts (BeamNG's pattern: a stock suspension hides camber/toe until you install adjustable coilovers) so the UI complexity scales with investment rather than overwhelming a new player on day one.

## Camera

- Ship the standard four (chase/hood/cockpit/optional-helmet) as the baseline, but take the corpus's clearest lesson seriously: **never present the cinematic/immersive camera as also the competitive one.** Cockpit and helmet views are for feel; hood/chase are what players will actually use for lap times, every single time, across every title checked (Shift 2, GT5/7, GRID Autosport all independently confirm this). Don't be precious about wanting players to "experience" the cockpit view — let them opt out freely.
- Build one Driveclub-style Photo Mode (free camera, hideable HUD, a handful of fixed presets including an engine-bay angle) early — it's cheap relative to its marketing value (per this project's own CPM case study: "the substitute for an audience is a camera").
- Consider one Shift-style camera-as-navigation moment if the open world gets large enough to need fast travel — reusing an aerial view as both spectacle and a functional map-select screen is free UI real estate once you have flying-camera code for photo mode anyway.

## HUD

- Default to minimal: speed, position, a compact proximity radar (GT Sport's glowing-dot pattern) rather than a full minimap when in cockpit/hood view, in-world signage for route-finding in open-world free-roam (Burnout Paradise) rather than a permanent minimap overlay.
- Ship a hide-everything toggle from day one (near-universal across modern titles, trivial to build, disproportionately appreciated).
- The instability/ragged-edge meter (already speced in this project's own physics docs) should render as a physical-looking gauge in the driver's sightline, not a floating bar — this is both a corpus finding (`23-CAMERAS-AND-HUD.md`) and consistent with every well-received "give the player a legible danger signal" pattern found (Wreckfest's zone-colored silhouette, the classic squeak/squeal/squall tire audio).
- If a competitive online/ghost layer ships, consider iRacing's boldest idea — a visible rank signal on the car itself (paint stripe, plate style, whatever fits the fiction) rather than only in a menu. It's a cheap way to make skill/reputation feel real to everyone else in the world, not just the player who earned it.

## Damage

- Use the cheap, proven techniques first: color-coded wear (Pitstop), a zone-based silhouette readout (Wreckfest) before committing to full soft-body deformation everywhere. Reserve full deformation fidelity for the hero car and nearby traffic, matching this project's own LOD/production-budget findings.
- Tie damage to genuine mechanical consequence (Destruction Derby's 1995 lesson, still not universally followed 30 years later) — a bent wheel should affect handling, not just looks.
- The three-tier GT Auto decay model (consumable/restorable/*permanent*) is worth adopting wholesale for long-term car ownership — it's the only system found that makes neglect a real, felt cost over a long career.

## Career / progression wrapper

- GT7's Café (an NPC handing out sequenced objectives with a lightweight breadcrumb, not a hard-rail structure) and Forza 2023's "Builder's Cup" (explicit leveling language) converged independently on the same idea from different genres: **wrap the race-select list in a narrative/progression frame.** This project's own mentor-in-the-garage system already does this without needing GT7's dedicated Café location — keep leaning on existing screens (garage, dyno, post-race telemetry) as the delivery mechanism, per the corpus's own "zero cutscenes" rule, rather than building a new hub screen just for narrative delivery.
- If passive income/property management is added (GTA Online's business layer), keep the management UI deliberately plain and fast — GTA Online's own lesson is that a screen checked constantly should optimize for speed over spectacle, the opposite of the garage/dyno screens which are checked less often and can afford more presentation.

## What to explicitly avoid

Ranked by how repeatedly the research confirmed the failure:
1. **Tuning sliders with no visual feedback** (ProStreet) — the single most independently-confirmed failure pattern in the whole corpus.
2. **RNG between a tuning decision and its result** (Payback's Speed Cards).
3. **Rubber-banding AI**, whether admitted (Forza) or classic (Street Racer's dynamic difficulty) — every "honest AI" reference (Driver's cops, Top Gear 2, F1 Manager's asymmetric rivals) outperforms it for a career-driven design.
4. **Forcing the immersive camera as the only/default option** — always let players default to whatever wins lap times.
5. **A currency with no late-game sink** (Mad Max's 15–20k surplus scrap) — class brackets (Car Wars) are the proven fix; build them in from the start, don't patch them in later.
6. **A single monolithic garage screen with no spatial identity** — every strong reference (LS Customs, Mad Max, CPM2, TDU) treats the garage as a *place*, not a settings page.
