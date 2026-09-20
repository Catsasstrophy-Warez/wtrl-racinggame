# Racing Game UI/UX Research — Master Comparison

Full-corpus visual/UI/UX research across the ~108 titles catalogued in this project's research package, organized by system rather than by game. Every claim traces to a specific title with a source link where research found one; gaps are flagged honestly rather than guessed. This complements [USABLE-IDEAS-MASTER.md](USABLE-IDEAS-MASTER.md) (mechanics/systems) with the visual/interface layer specifically.

**Note on images**: this doc deliberately does not embed scraped screenshots from ~100+ commercial games — that crosses into bulk-reproducing copyrighted material. Instead it links to official store pages, press kits, and community wikis/UI-database sites where the actual images live.

---

## 1. Garage / car-selection screen archetypes

Four recurring patterns emerged across the corpus:

**A. Flat menu/list** — the oldest and still most common pattern (original Gran Turismo's up/down car-list, early NFS titles, Beach Buggy Racing 2, Hill Climb Racing 2). Cheapest to build, least memorable.

**B. Rotating/turntable 3D showroom** — car presented on a platform, camera orbits or player free-rotates. This is the modern default: GTA V/Online's Los Santos Customs (live part-swap preview on the model before purchase — [GTA Wiki](https://gta.fandom.com/wiki/Los_Santos_Customs)), CSR Racing 2's cinematic reveal (garage door rolls up, car drives in, camera sweeps side→top-down — [NaturalMotion](https://www.naturalmotion.com/game/csr-racing-2/)), CSR Racing 3's "Car Exploration" (inspect interior trim and mechanical detail up close), NFS Underground 2/Most Wanted/Carbon's rotating carousel on a neon backdrop.

**C. Walkable physical space** — rarer, higher-investment: Project Gotham Racing 2 lets the player physically walk the showroom floor with one stick to move, one to look ([GameFAQs](https://gamefaqs.gamespot.com/xbox/562117-project-gotham-racing-2/faqs/27002)); Forza's **Forzavista** goes further — open doors/hood/trunk, sit inside, start the engine, get an informational cinematic on a highlighted part ([Forza Wiki](https://forza.fandom.com/wiki/Forzavista)); Car Parking Multiplayer 2's garage is literally drivable — you park your own car inside the garage space rather than selecting from a menu.

**D. Non-garage framing** — some titles skip a garage concept entirely: the original 1994 NFS used a "magazine spread" (Road & Track editorial copy, FMV clips, no mechanical framing at all); My Summer Car has no garage screen whatsoever — the garage is a literal 3D shed with zero UI overlay; Top Drives replaces the garage with a trading-card deck-builder.

**Design takeaway**: pattern B (rotating showroom) is the safe, proven default; pattern C (walkable/drivable) is the differentiator but costs real production budget (matches the corpus's own finding in `23-CAMERAS-AND-HUD.md` that interior fidelity roughly doubles per-vehicle cost).

---

## 2. Camera systems

**The standard four-tier cost ladder held up empirically across every title checked**: chase (cheapest, always present) → hood/bumper (cheap, best visibility, most-used for actual lap times regardless of what's "prettier") → cockpit (needs a modeled interior) → helmet/head-tracking (most expensive, rarest).

**Constraining camera choice as an identity move** (rather than maximizing options) shows up repeatedly as a deliberate, successful design choice, not a limitation:
- **Traffic Rider** ships *only* first-person, gauges built diegetically into the view — no third-person option exists at all.
- **Reckless Racing 3**'s fixed top-down/overhead perspective *is* the franchise's entire visual identity.
- **Rocket League Sideswipe** reinvented a fully-3D game as a fixed 2.5D side-on camera for mobile — the single biggest design deviation from its parent game, and it works because the whole field stays visible without any camera control needed.
- **Rush Rally Origins** ships a genuine choice between a retro top-down/isometric camera and a modern helicopter-chase cam as two first-class options, not a novelty toggle.

**Head-tracking / G-force-driven cameras**, the most expensive tier, appear in exactly two well-documented forms:
- **Shift 2: Unleashed's helmet cam** — swivels toward the apex *ahead of* the car's actual turn-in, bobs on bumps, snaps on impact, tunnel-vision blur at speed intensifying with G-force. Reviewers loved the feel but noted it could hurt lap-time precision because of the anticipatory head-turn — "immersion camera ≠ performance camera" is a recurring, hard-earned lesson across the corpus (also true of GT5/GT7 and GRID Autosport's cockpit views).
- **Assetto Corsa Competizione's Helmet Camera** — same G-force head-movement principle, more restrained, built for endurance-sim authenticity rather than spectacle.

**Free/decoupled cameras as a photo-mode/social feature**:
- **Driveclub's Photo Mode** — Free Game Camera + ~6 fixed presets including interior/engine-bay panel views, ~11 processing options (aperture, shutter speed, stylized filters), HUD fully hideable — widely credited as setting the template the rest of the industry copied ([TheSixthAxis](https://www.thesixthaxis.com/2014/11/21/pulling-focus-driveclubs-photo-mode-exposed/)).
- **Car Parking Multiplayer's Drone Mode** — a fully free-flying camera decoupled from the car, doubling as the game's actual screenshot/marketing pipeline. Its own case study (`28-CPM-CASE-STUDY.md`) calls this "the export pipeline nobody talks about."
- **Driver (1999)'s Film Director mode** — the earliest example in the corpus: full replay of a completed mission with player-chosen camera cuts, plus an auto-cut "Quick Replay." Removed in DRIV3R (2004) in favor of a scripted automatic "Thrill Cam" — widely seen as a step backward, a cautionary example of trading player authorship for a cheaper automated substitute.

**Camera as navigation/selection mechanic, not just a viewpoint** — the single most inventive finding in this whole research pass: **Driver: San Francisco's "Shift"** pulls the camera up into a top-down aerial city view, lets the player pan/scroll to find another car, then cuts back into chase-cam inside it. This aerial mode *is* the car-selection screen — there's no separate menu at all ([Driver Wiki](https://driver.fandom.com/wiki/Shift)). Driver (1999)'s original "garage test" tutorial level was itself a direct homage to the 1978 film *The Driver*'s parking-garage audition scene — camera-and-level-design doing narrative work simultaneously.

**Per-view configurability as a differentiator**: GRID Autosport's cameras are XML-moddable per car; Forza's FOV is adjustable 25°–65° across first- and third-person; Highway Racer Pro (a budget mobile title) exposes damping/distance/FOV/shake/height/pitch as user-tunable settings *per camera view* — unusually deep for its tier.

---

## 3. HUD design

**Minimalism is winning, consistently, across eras and platforms**:
- Trackmania's HUD is reduced to a timer and checkpoint delta by default, individually toggleable (ghost, interface, names) — built for speedrun-style play.
- GT7 and GT Sport keep HUD density low by series tradition; GT Sport's cockpit/bumper view adds a compact circular radar of glowing dots for nearby-car proximity rather than a full minimap.
- Horizon Chase ships a literal **"No HUD" toggle** as an explicit challenge/purity mode.
- Burnout Paradise removed the minimap entirely, replacing it with in-world signage (lit billboards/road markings) pointing the route — an explicit anti-clutter choice for an open world.
- CarX Street and Assetto Corsa Competizione both support fully hiding the HUD for clean screenshots (ACC via a long-press toggle).

**Modular/scriptable HUD as its own differentiator**: **Assetto Corsa's "apps" system** — the entire HUD is composed of independently draggable floating widgets, toggled via an edge-of-screen menu, and scriptable in Python. This single architectural choice spawned a large third-party ecosystem of custom telemetry overlays and is arguably the most influential UI decision in the sim-racing genre for extensibility ([assettocorsamods.io](https://assettocorsamods.io/apps/)). ACC deliberately chose the opposite approach — a curated, fixed 3-tier structure (Main Menu / Race Menu / in-session HUD) with a structured MFD (Multi-Function Display) cycling through purpose-built pages (gaps to cars, car settings, pit strategy) rather than a freeform desktop — a deliberate trade of flexibility for a curated, real-endurance-racing-engineer workflow feel.

**Signature single-purpose meters that become the whole game's identity**:
- **CSR Racing series' tachometer-as-rhythm-game** — CSR3 explicitly reframes the classic tach-and-lights drag HUD as a rhythm mechanic (watch the needle sweep into a green/yellow launch and shift zone).
- **Split/Second's Powerplay meter** — fills via drafting/drifting/jumps, and spending it triggers scripted, track-altering environmental destruction. A meter that changes the *world*, not just the car.
- **Burnout's boost meter** — filled by dangerous driving (near-misses, oncoming-lane driving, drifting), spent on boost — risk-taking made economically visible in real time.
- **Driver/Driver 2's felony meter** — accrues only from infractions witnessed by police, a diegetic justification baked directly into the HUD element itself.
- **Wreckfest's zone-colored damage silhouette** — a car outline that reddens by body region, giving an at-a-glance damage read without needing to inspect the 3D model.
- **Pitstop's (1983!) tire-wear color-coding directly on the tire sprite** — the earliest "damage-as-texture" technique found in the whole corpus, on 1983 hardware.

**Social/asynchronous HUD layers**:
- **NFS Hot Pursuit (2010)'s Autolog** — a persistent "Wall" of friend-beat-your-time notifications plus in-career-map "Recommendation" banners nudging you toward events where a friend holds a faster time. Widely credited as a genre-defining innovation, later evolved into Rivals' "Speedwall."
- **iRacing's license-tier color stripe** — Rookie(red)→D(orange)→C(yellow)→B(green)→A(blue)→Pro(black) painted directly onto every car's livery and helmet, making a numeric rank a permanently visible social/cosmetic signal to everyone else on track — unusual among racing games for turning a backend stat into a public-facing visual identity.

---

## 4. Tuning/upgrade UI — the widest variance in the whole corpus

Three fundamentally different philosophies recur, worth naming explicitly since a design team needs to pick one deliberately:

### Continuous sliders (the "engineering spreadsheet" model)
- **NFS ProStreet** — banks of ~-10 to +10 sliders per parameter: camber/toe/caster individually, gear-by-gear ratios, brake bias, forced-induction, tire, nitrous — the densest, most simulation-leaning tuning UI in the entire NFS lineage.
- **NFS Underground 2's Dyno Run** — a genuine hybrid: bar-graph sliders (not simple linear sliders) shaping the ECU/turbo delivery curve across RPM bands, with a *live-updating* power/torque graph responding to the bars in real time. This is the closest the corpus found to visualizing tuning cause-and-effect directly rather than hiding it behind an abstract stat number.
- **CSR Racing 2's dyno screen** — horizontal sliders (Nitrous duration/power, Final Drive, Tire Pressure) that live-update a single "Evo points" number, plus a genuine "Test Ride" mode that runs an actual simulated pass rather than trusting the estimate. Notably, players can deliberately tune *off* the peak Evo number for real-world race advantage ("dyno-beating") — a meta-strategy layer built directly into the slider UI.
- **Assetto Corsa / ACC / iRacing** — tabbed setup screens (aero, suspension, gearing, alignment, tire pressure/camber, brake bias) that only expose the parameters a given car actually supports, mirroring real tunability rather than presenting a uniform menu regardless of car.

### Discrete tiered parts / "loot" (the "gear" model)
- **CSR Racing 3 deliberately moved away from CSR2's sliders** entirely, replacing the dyno screen with an "Aftermarket Mods" system: discrete parts tiered by rarity (Uncommon→Legendary), some gated behind specific car traits, granting stat boosts *and* special abilities (Double NOS, reduced drag). A genuine philosophy pivot within the same franchise, worth studying as a real A/B comparison.
- **NFS Payback's Speed Cards** — six card types per part category, five collectible "brands," each with named perks — a full collectible-card layer bolted onto what used to be a linear parts shop. Widely cited (including in this project's own `19-NFS-DOSSIER.md`) as the series' clearest tuning failure — randomization between a tuning decision and its result was universally disliked.
- **GTA Online's Los Santos Customs** — clean category list (Engine/Brakes/Transmission/Suspension/Turbo/Armor vs. cosmetic Respray/Wheels/Body-kit), each swap previewed live on the 3D model before purchase confirmation.

### Physical/diegetic construction (the "builder" model)
- **Crossout** — the most sophisticated integration found anywhere in the corpus: a grid-based, node-connected part-placement builder where the exact parts you physically attach in the garage are the same physical objects that can be shot off piece-by-piece in combat. Garage screen and damage visualization are literally the same system.
- **Automation's engine designer** — a Family (locked architecture: cylinder layout, block material, valvetrain) → Variant (displacement, tune, aspiration — branches off a family) hierarchy, with a live-updating dyno graph and a **3D engine-bay fit visualization** showing dimensional clearance in real time. The family/variant lock is a genuinely clever UI trick: it visually grays out already-committed architectural choices once dependent variants exist, teaching real engineering trade-offs (shared tooling vs. bespoke design) through interface restriction rather than a tutorial popup.
- **BeamNG.drive's Vehicle Config menu** — a hierarchical part tree where installing an *advanced* part (e.g. racing suspension) unlocks previously-hidden tuning sliders (camber/toe) that a stock part doesn't expose — UI complexity that scales with the player's own investment level.
- **Car Mechanic Simulator's zone-based interaction** — approach a car and it defaults to body/paint tools; double-click a subsystem (suspension corner, engine bay) to drill into that zone's exploded-parts view; right-click opens a radial tool menu (wrench, socket, diagnostic scanner). Looser than a strict tier system but functionally divides work into body/subsystem/part-level granularity.
- **My Summer Car** — the extreme end of the spectrum and the single most granular interaction model found: physically pick up a specific-size wrench, hover it over a bolt (wrong size does nothing, correct size **highlights the bolt green**), scroll the mouse wheel to simulate ratchet motion, physically carry removed parts by hand to storage. Zero UI abstraction of any kind. Useful precisely as the far end of a fidelity spectrum, not as a template to copy wholesale.

**Design takeaway, stated directly**: the corpus's own dyno-analysis document already concluded this, and the visual research confirms it — Underground 2's bar-graph-with-live-graph and CSR2's slider-with-live-number are the two strongest *proven, shipped* references for "player understands what they changed," while ProStreet's slider-wall-with-no-visualization and Payback's card RNG are the two clearest *proven, shipped* failure modes.

**Two more variants worth naming**: Forza's **Performance Index (PI)** system shows a single numeric class rating recalculating live as you drag sliders across categories — a useful middle ground between ProStreet's dozens of disconnected sliders and CSR2's one "Evo" number. NFS Payback additionally splits its card-based tuning from a *separate* "Derelict" system — barn-find wrecks discovered via a map/photo-pin UI, restored through tiered before/after reveal animations (Scrap→Stock→Super Build) rather than sliders — worth noting as a restoration-specific UI pattern distinct from its much-maligned Speed Cards.

---

## 5. Damage / repair visualization

A clean historical progression:
1. **Color-coded wear on the sprite itself** (Pitstop, 1983) — cheapest possible technique, still legible.
2. **Schematic diagram** (Top Gear 2, 1993) — a small side-panel car outline showing accumulating wear, decoupled from the actual 3D model.
3. **Real-time mesh deformation tied to actual handling** (Destruction Derby, 1995) — genuinely ahead of its time; damaged wheels/engine visibly and mechanically affect drivability, not just cosmetics.
4. **Full soft-body/persistent deformation** (Wreckfest, BeamNG, FlatOut) — panels crumple progressively and persistently across a session; Wreckfest pairs this with the zone-colored HUD silhouette described above for legibility despite the complexity underneath.
5. **Damage as its own game mode** (Burnout 3's Crash Mode, FlatOut's ragdoll mini-games) — turning the crash itself into scored, replayable content rather than a pure penalty.
6. **Damage as narrative/economy** (GT Auto's three-tier decay model — consumable/restorable/*permanent*; NFS High Stakes' no-mid-race-repair-plus-garage-bill) — both already covered in depth in `USABLE-IDEAS-MASTER.md` §3.

---

## 6. Career/progression/management UI

- **GT7's Café/Menu Book system** is the standout finding here: an NPC (Luca) hands out "Menu Books" (Collection/Tournament/Misc types) completed in sequence, with a lightweight yellow-dot breadcrumb telling the player where to go next rather than a hard on-rails structure — explicitly RPG/live-service UI conventions grafted onto what used to be a flat dealership-and-event-list. GT Auto's three-department split (Maintenance & Service / Customization / Driving Gear) is the concrete execution of the maintenance-decay model already logged in the ideas master.
- **Forza's 2023 reboot ("Builder's Cup")** parallels this from the opposite direction — explicit RPG language (Car Mastery, XP, car leveling) wrapping the career mode, treating each car as a leveling "character."
- **F1 Manager 2024's named single-purpose facility rooms** (Board Room→confidence, Weather Centre→forecast accuracy, Helipad→sponsor benefits, etc.) is the cleanest, most legible execution found anywhere of the "one named effect per building" principle already in the ideas master — more granular than Motorsport Manager's broader building categories.
- **GTA Online's Interaction Menu** for business management is deliberately *not* visually flashy — dense text-list submenus, because it's checked constantly and clarity beats spectacle for frequently-used utility screens. Worth contrasting directly against GT7's Café, which is checked less often and can afford more presentation.
- **Top Drives** replaces driving skill entirely with a trading-card deck-builder using real Evo-sourced performance stats printed on each card — the most extreme "car knowledge as the product" execution in the corpus, confirming the same finding already noted from `26-MOBILE-LANDSCAPE.md`.

---

## 7. Per-title quick reference

Full per-game findings (garage style, camera list, HUD, tuning UI, standout feature, source links) were gathered for all ~108 titles across seven research passes. Rather than duplicate ~15,000 words of per-game notes here, they're preserved in this project's session record; ask for any specific title's full write-up to be pulled back out verbatim, or for a specific comparison (e.g. "every dyno screen side by side") to be re-assembled from the raw notes.

**Titles with genuinely thin/unconfirmed public documentation** (flagged honestly during research rather than guessed): Assetto Corsa Mobile, DiRT Rally (no true mobile port found), original 1997 Gran Turismo's exact camera list, original 2005 Forza Motorsport's shipped garage UI, Test Drive Le Mans, CSR Classics' camera details, Rally One: Race to Glory, Motorsport Manager 2 / Online 2025 (both very new/obscure), Drive Mad, Al Unser Jr.'s Road to the Top's garage structure, and camera details for Ford Mustang: The Legend Lives and Destruction Derby. For any of these, a direct screenshot/gameplay-video pass would be needed rather than text search.

---

## 8. Cross-cutting takeaways for design decisions

1. **Pick one tuning philosophy on purpose.** Slider/dyno (Underground 2, ProStreet, CSR2), tiered-loot (CSR3, Payback), or physical builder (Crossout, Automation, BeamNG) — each has proven successes and proven failures in this research; mixing them without a reason is how Payback's card system happened.
2. **Constraining camera choice is a valid identity move**, not just a budget concession — Traffic Rider, Reckless Racing 3, and Rocket League Sideswipe all prove a single well-chosen camera can be a stronger identity than five mediocre options.
3. **Immersion cameras and performance cameras are different tools** — this exact lesson recurs across Shift 2, GT5/7, and GRID Autosport independently. Never build only the cinematic one and expect competitive players to use it.
4. **The cheapest damage/state visualization techniques (color-coding, schematic diagrams, zone-colored silhouettes) remain legible and effective** even 40+ years after Pitstop invented the first one — full deformation simulation is a choice, not a requirement, for damage to read clearly.
5. **A meter that changes something external (the world, an opponent, a social feed) is more memorable than a meter that only tracks the player's own car** — Split/Second's Powerplay, Burnout's boost, and Autolog's social layer all outperform plain fuel/damage gauges as design ideas worth stealing.
